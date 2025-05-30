//===-- HostInfoTest.cpp --------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "lldb/Host/HostInfo.h"
#include "TestingSupport/SubsystemRAII.h"
#include "TestingSupport/TestUtilities.h"
#include "lldb/Host/FileSystem.h"
#include "lldb/lldb-defines.h"
#include "llvm/TargetParser/Host.h"
#include "gtest/gtest.h"

using namespace lldb_private;
using namespace llvm;

namespace {
class HostInfoTest : public ::testing::Test {
  SubsystemRAII<FileSystem, HostInfo> subsystems;
};
} // namespace

TEST_F(HostInfoTest, GetAugmentedArchSpec) {
  // Fully specified triple should not be changed.
  ArchSpec spec = HostInfo::GetAugmentedArchSpec("x86_64-pc-linux-gnu");
  EXPECT_EQ(spec.GetTriple().getTriple(), "x86_64-pc-linux-gnu");

  // Same goes if we specify at least one of (os, vendor, env).
  spec = HostInfo::GetAugmentedArchSpec("x86_64-pc");
  EXPECT_EQ(spec.GetTriple().getTriple(), "x86_64-pc");

  // But if we specify only an arch, we should fill in the rest from the host.
  spec = HostInfo::GetAugmentedArchSpec("x86_64");
  Triple triple(sys::getDefaultTargetTriple());
  EXPECT_EQ(spec.GetTriple().getArch(), Triple::x86_64);
  EXPECT_EQ(spec.GetTriple().getOS(), triple.getOS());
  EXPECT_EQ(spec.GetTriple().getVendor(), triple.getVendor());
  EXPECT_EQ(spec.GetTriple().getEnvironment(), triple.getEnvironment());

  // Test LLDB_ARCH_DEFAULT
  EXPECT_EQ(HostInfo::GetAugmentedArchSpec(LLDB_ARCH_DEFAULT).GetTriple(),
            HostInfo::GetArchitecture(HostInfo::eArchKindDefault).GetTriple());
  EXPECT_NE(
      HostInfo::GetAugmentedArchSpec("armv7k").GetTriple().getEnvironmentName(),
      "unknown");
}

TEST_F(HostInfoTest, GetHostname) {
  // Check non-empty string input works correctly.
  std::string s("abc");
  EXPECT_TRUE(HostInfo::GetHostname(s));
}

TEST_F(HostInfoTest, GetProgramFileSpec) {
  FileSpec filespec = HostInfo::GetProgramFileSpec();
  EXPECT_TRUE(FileSystem::Instance().Exists(filespec));
}

#if defined(__APPLE__)
TEST_F(HostInfoTest, GetXcodeSDK) {
  auto get_sdk = [](std::string sdk, bool error = false) -> llvm::StringRef {
    auto sdk_path_or_err =
        HostInfo::GetSDKRoot(HostInfo::SDKOptions{XcodeSDK(std::move(sdk))});
    if (!error) {
      EXPECT_TRUE((bool)sdk_path_or_err);
      return *sdk_path_or_err;
    }
    EXPECT_FALSE((bool)sdk_path_or_err);
    llvm::consumeError(sdk_path_or_err.takeError());
    return {};
  };
  EXPECT_FALSE(get_sdk("MacOSX.sdk").empty());
  // These are expected to fall back to an available version.
  EXPECT_FALSE(get_sdk("MacOSX9999.sdk").empty());
  // This is expected to fail.
  EXPECT_TRUE(get_sdk("CeciNestPasUnOS.sdk", true).empty());
}

TEST_F(HostInfoTest, FindSDKTool) {
  auto find_tool = [](std::string sdk, llvm::StringRef tool,
                      bool error = false) -> llvm::StringRef {
    auto sdk_path_or_err =
        HostInfo::FindSDKTool(XcodeSDK(std::move(sdk)), tool);
    if (!error) {
      EXPECT_TRUE((bool)sdk_path_or_err);
      return *sdk_path_or_err;
    }
    EXPECT_FALSE((bool)sdk_path_or_err);
    llvm::consumeError(sdk_path_or_err.takeError());
    return {};
  };
  EXPECT_FALSE(find_tool("MacOSX.sdk", "clang").empty());
  EXPECT_TRUE(find_tool("MacOSX.sdk", "CeciNestPasUnOutil").empty());
}
#endif

TEST(HostInfoTestInitialization, InitTwice) {
  llvm::VersionTuple Version;
  {
    SubsystemRAII<FileSystem, HostInfo> subsystems;
    Version = HostInfo::GetOSVersion();
  }

  {
    SubsystemRAII<FileSystem, HostInfo> subsystems;
    EXPECT_EQ(Version, HostInfo::GetOSVersion());
  }
}

#ifdef __APPLE__
struct HostInfoTester : public HostInfoMacOSX {
public:
  using HostInfoMacOSX::FindComponentInPath;
};

TEST_F(HostInfoTest, FindComponentInPath) {
  EXPECT_EQ("/path/to/foo",
            HostInfoTester::FindComponentInPath("/path/to/foo/", "foo"));

  EXPECT_EQ("/path/to/foo",
            HostInfoTester::FindComponentInPath("/path/to/foo", "foo"));

  EXPECT_EQ("/path/to/foobar",
            HostInfoTester::FindComponentInPath("/path/to/foobar", "foo"));

  EXPECT_EQ("/path/to/foobar",
            HostInfoTester::FindComponentInPath("/path/to/foobar", "bar"));

  EXPECT_EQ("", HostInfoTester::FindComponentInPath("/path/to/foo", "bar"));
}
#endif
