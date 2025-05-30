; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 5
; RUN: llc < %s -march=nvptx64 -mcpu=sm_100 -mattr=+ptx86 | FileCheck %s --check-prefixes=CHECK,CHECK-PTX-SHARED64
; RUN: llc < %s -march=nvptx64 -mcpu=sm_100 -mattr=+ptx86 --nvptx-short-ptr | FileCheck --check-prefixes=CHECK,CHECK-PTX-SHARED32 %s
; RUN: %if ptxas-12.8 %{ llc < %s -mtriple=nvptx64 -mcpu=sm_100 -mattr=+ptx86 | %ptxas-verify -arch=sm_100 %}
; RUN: %if ptxas-12.8 %{ llc < %s -mtriple=nvptx64 -mcpu=sm_100 -mattr=+ptx86 --nvptx-short-ptr | %ptxas-verify -arch=sm_100 %}

define void @nvvm_clusterlaunchcontrol_try_cancel(
; CHECK-PTX-SHARED64-LABEL: nvvm_clusterlaunchcontrol_try_cancel(
; CHECK-PTX-SHARED64:       {
; CHECK-PTX-SHARED64-NEXT:    .reg .b64 %rd<3>;
; CHECK-PTX-SHARED64-EMPTY:
; CHECK-PTX-SHARED64-NEXT:  // %bb.0:
; CHECK-PTX-SHARED64-NEXT:    ld.param.b64 %rd1, [nvvm_clusterlaunchcontrol_try_cancel_param_0];
; CHECK-PTX-SHARED64-NEXT:    ld.param.b64 %rd2, [nvvm_clusterlaunchcontrol_try_cancel_param_1];
; CHECK-PTX-SHARED64-NEXT:    clusterlaunchcontrol.try_cancel.async.shared::cta.mbarrier::complete_tx::bytes.b128 [%rd1], [%rd2];
; CHECK-PTX-SHARED64-NEXT:    ret;
;
; CHECK-PTX-SHARED32-LABEL: nvvm_clusterlaunchcontrol_try_cancel(
; CHECK-PTX-SHARED32:       {
; CHECK-PTX-SHARED32-NEXT:    .reg .b32 %r<3>;
; CHECK-PTX-SHARED32-EMPTY:
; CHECK-PTX-SHARED32-NEXT:  // %bb.0:
; CHECK-PTX-SHARED32-NEXT:    ld.param.b32 %r1, [nvvm_clusterlaunchcontrol_try_cancel_param_0];
; CHECK-PTX-SHARED32-NEXT:    ld.param.b32 %r2, [nvvm_clusterlaunchcontrol_try_cancel_param_1];
; CHECK-PTX-SHARED32-NEXT:    clusterlaunchcontrol.try_cancel.async.shared::cta.mbarrier::complete_tx::bytes.b128 [%r1], [%r2];
; CHECK-PTX-SHARED32-NEXT:    ret;
                                             ptr addrspace(3) %saddr, ptr addrspace(3) %smbar,
                                             i128 %try_cancel_response) {

  tail call void @llvm.nvvm.clusterlaunchcontrol.try_cancel.async.shared(ptr addrspace(3) %saddr, ptr addrspace(3) %smbar)
  ret void;
}

define i32 @nvvm_clusterlaunchcontrol_query_cancel_is_canceled(i128 %try_cancel_response) local_unnamed_addr #0 {
; CHECK-LABEL: nvvm_clusterlaunchcontrol_query_cancel_is_canceled(
; CHECK:       {
; CHECK-NEXT:    .reg .pred %p<2>;
; CHECK-NEXT:    .reg .b32 %r<2>;
; CHECK-NEXT:    .reg .b64 %rd<3>;
; CHECK-EMPTY:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    ld.param.v2.b64 {%rd1, %rd2}, [nvvm_clusterlaunchcontrol_query_cancel_is_canceled_param_0];
; CHECK-NEXT:    {
; CHECK-NEXT:    .reg .b128 %clc_handle;
; CHECK-NEXT:    mov.b128 %clc_handle, {%rd1, %rd2};
; CHECK-NEXT:    clusterlaunchcontrol.query_cancel.is_canceled.pred.b128 %p1, %clc_handle;
; CHECK-NEXT:    }
; CHECK-NEXT:    selp.b32 %r1, 1, 0, %p1;
; CHECK-NEXT:    st.param.b32 [func_retval0], %r1;
; CHECK-NEXT:    ret;
  %v0 = call i1 @llvm.nvvm.clusterlaunchcontrol.query_cancel.is_canceled(i128 %try_cancel_response)
  %v2 = zext i1 %v0 to i32
  ret i32 %v2;
}

define i32 @nvvm_clusterlaunchcontrol_query_cancel_get_first_ctaid_x(i128 %try_cancel_response) local_unnamed_addr #0 {
; CHECK-LABEL: nvvm_clusterlaunchcontrol_query_cancel_get_first_ctaid_x(
; CHECK:       {
; CHECK-NEXT:    .reg .b32 %r<2>;
; CHECK-NEXT:    .reg .b64 %rd<3>;
; CHECK-EMPTY:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    ld.param.v2.b64 {%rd1, %rd2}, [nvvm_clusterlaunchcontrol_query_cancel_get_first_ctaid_x_param_0];
; CHECK-NEXT:    {
; CHECK-NEXT:    .reg .b128 %clc_handle;
; CHECK-NEXT:    mov.b128 %clc_handle, {%rd1, %rd2};
; CHECK-NEXT:    clusterlaunchcontrol.query_cancel.get_first_ctaid::x.b32.b128 %r1, %clc_handle;
; CHECK-NEXT:    }
; CHECK-NEXT:    st.param.b32 [func_retval0], %r1;
; CHECK-NEXT:    ret;
  %v0 = call i32 @llvm.nvvm.clusterlaunchcontrol.query_cancel.get_first_ctaid.x(i128 %try_cancel_response)
  ret i32 %v0;
}

define i32 @nvvm_clusterlaunchcontrol_query_cancel_get_first_ctaid_y(i128 %try_cancel_response) local_unnamed_addr #0 {
; CHECK-LABEL: nvvm_clusterlaunchcontrol_query_cancel_get_first_ctaid_y(
; CHECK:       {
; CHECK-NEXT:    .reg .b32 %r<2>;
; CHECK-NEXT:    .reg .b64 %rd<3>;
; CHECK-EMPTY:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    ld.param.v2.b64 {%rd1, %rd2}, [nvvm_clusterlaunchcontrol_query_cancel_get_first_ctaid_y_param_0];
; CHECK-NEXT:    {
; CHECK-NEXT:    .reg .b128 %clc_handle;
; CHECK-NEXT:    mov.b128 %clc_handle, {%rd1, %rd2};
; CHECK-NEXT:    clusterlaunchcontrol.query_cancel.get_first_ctaid::y.b32.b128 %r1, %clc_handle;
; CHECK-NEXT:    }
; CHECK-NEXT:    st.param.b32 [func_retval0], %r1;
; CHECK-NEXT:    ret;
  %v0 = call i32 @llvm.nvvm.clusterlaunchcontrol.query_cancel.get_first_ctaid.y(i128 %try_cancel_response)
  ret i32 %v0;
}

define i32 @nvvm_clusterlaunchcontrol_query_cancel_get_first_ctaid_z(i128 %try_cancel_response) local_unnamed_addr #0 {
; CHECK-LABEL: nvvm_clusterlaunchcontrol_query_cancel_get_first_ctaid_z(
; CHECK:       {
; CHECK-NEXT:    .reg .b32 %r<2>;
; CHECK-NEXT:    .reg .b64 %rd<3>;
; CHECK-EMPTY:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    ld.param.v2.b64 {%rd1, %rd2}, [nvvm_clusterlaunchcontrol_query_cancel_get_first_ctaid_z_param_0];
; CHECK-NEXT:    {
; CHECK-NEXT:    .reg .b128 %clc_handle;
; CHECK-NEXT:    mov.b128 %clc_handle, {%rd1, %rd2};
; CHECK-NEXT:    clusterlaunchcontrol.query_cancel.get_first_ctaid::z.b32.b128 %r1, %clc_handle;
; CHECK-NEXT:    }
; CHECK-NEXT:    st.param.b32 [func_retval0], %r1;
; CHECK-NEXT:    ret;
  %v0 = call i32 @llvm.nvvm.clusterlaunchcontrol.query_cancel.get_first_ctaid.z(i128 %try_cancel_response)
  ret i32 %v0;
}
