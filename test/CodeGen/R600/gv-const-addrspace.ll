; RUN: llc -march=r600 -mcpu=redwood < %s | FileCheck -check-prefix=EG -check-prefix=FUNC %s
; RUN: llc -march=r600 -mcpu=SI -verify-machineinstrs < %s | FileCheck -check-prefix=SI -check-prefix=FUNC %s


@b = internal addrspace(2) constant [1 x i16] [ i16 7 ], align 2

; XXX: Test on SI once 64-bit adds are supportes.

@float_gv = internal addrspace(2) unnamed_addr constant [5 x float] [float 0.0, float 1.0, float 2.0, float 3.0, float 4.0], align 4

; FUNC-LABEL: @float

; EG-DAG: MOV {{\** *}}T2.X
; EG-DAG: MOV {{\** *}}T3.X
; EG-DAG: MOV {{\** *}}T4.X
; EG-DAG: MOV {{\** *}}T5.X
; EG-DAG: MOV {{\** *}}T6.X
; EG: MOVA_INT

define void @float(float addrspace(1)* %out, i32 %index) {
entry:
  %0 = getelementptr inbounds [5 x float] addrspace(2)* @float_gv, i32 0, i32 %index
  %1 = load float addrspace(2)* %0
  store float %1, float addrspace(1)* %out
  ret void
}

@i32_gv = internal addrspace(2) unnamed_addr constant [5 x i32] [i32 0, i32 1, i32 2, i32 3, i32 4], align 4

; FUNC-LABEL: @i32

; EG-DAG: MOV {{\** *}}T2.X
; EG-DAG: MOV {{\** *}}T3.X
; EG-DAG: MOV {{\** *}}T4.X
; EG-DAG: MOV {{\** *}}T5.X
; EG-DAG: MOV {{\** *}}T6.X
; EG: MOVA_INT

define void @i32(i32 addrspace(1)* %out, i32 %index) {
entry:
  %0 = getelementptr inbounds [5 x i32] addrspace(2)* @i32_gv, i32 0, i32 %index
  %1 = load i32 addrspace(2)* %0
  store i32 %1, i32 addrspace(1)* %out
  ret void
}


%struct.foo = type { float, [5 x i32] }

@struct_foo_gv = internal addrspace(2) unnamed_addr constant [1 x %struct.foo] [ %struct.foo { float 16.0, [5 x i32] [i32 0, i32 1, i32 2, i32 3, i32 4] } ]

; FUNC-LABEL: @struct_foo_gv_load

define void @struct_foo_gv_load(i32 addrspace(1)* %out, i32 %index) {
  %gep = getelementptr inbounds [1 x %struct.foo] addrspace(2)* @struct_foo_gv, i32 0, i32 0, i32 1, i32 %index
  %load = load i32 addrspace(2)* %gep, align 4
  store i32 %load, i32 addrspace(1)* %out, align 4
  ret void
}

@array_v1_gv = internal addrspace(2) constant [4 x <1 x i32>] [ <1 x i32> <i32 1>,
                                                                <1 x i32> <i32 2>,
                                                                <1 x i32> <i32 3>,
                                                                <1 x i32> <i32 4> ]

; FUNC-LABEL: @array_v1_gv_load
define void @array_v1_gv_load(<1 x i32> addrspace(1)* %out, i32 %index) {
  %gep = getelementptr inbounds [4 x <1 x i32>] addrspace(2)* @array_v1_gv, i32 0, i32 %index
  %load = load <1 x i32> addrspace(2)* %gep, align 4
  store <1 x i32> %load, <1 x i32> addrspace(1)* %out, align 4
  ret void
}
