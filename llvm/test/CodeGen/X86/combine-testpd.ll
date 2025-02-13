; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s

;
; testz(~X,Y) -> testc(X,Y)
;

define i32 @testpdz_128_invert0(<2 x double> %c, <2 x double> %d, i32 %a, i32 %b) {
; CHECK-LABEL: testpdz_128_invert0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vtestpd %xmm1, %xmm0
; CHECK-NEXT:    cmovael %esi, %eax
; CHECK-NEXT:    retq
  %t0 = bitcast <2 x double> %c to <2 x i64>
  %t1 = xor <2 x i64> %t0, <i64 -1, i64 -1>
  %t2 = bitcast <2 x i64> %t1 to <2 x double>
  %t3 = call i32 @llvm.x86.avx.vtestz.pd(<2 x double> %t2, <2 x double> %d)
  %t4 = icmp ne i32 %t3, 0
  %t5 = select i1 %t4, i32 %a, i32 %b
  ret i32 %t5
}

define i32 @testpdz_256_invert0(<4 x double> %c, <4 x double> %d, i32 %a, i32 %b) {
; CHECK-LABEL: testpdz_256_invert0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vtestpd %ymm1, %ymm0
; CHECK-NEXT:    cmovael %esi, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %t0 = bitcast <4 x double> %c to <4 x i64>
  %t1 = xor <4 x i64> %t0, <i64 -1, i64 -1, i64 -1, i64 -1>
  %t2 = bitcast <4 x i64> %t1 to <4 x double>
  %t3 = call i32 @llvm.x86.avx.vtestz.pd.256(<4 x double> %t2, <4 x double> %d)
  %t4 = icmp ne i32 %t3, 0
  %t5 = select i1 %t4, i32 %a, i32 %b
  ret i32 %t5
}

;
; testz(X,~Y) -> testc(Y,X)
;

define i32 @testpdz_128_invert1(<2 x double> %c, <2 x double> %d, i32 %a, i32 %b) {
; CHECK-LABEL: testpdz_128_invert1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vtestpd %xmm0, %xmm1
; CHECK-NEXT:    cmovael %esi, %eax
; CHECK-NEXT:    retq
  %t0 = bitcast <2 x double> %d to <2 x i64>
  %t1 = xor <2 x i64> %t0, <i64 -1, i64 -1>
  %t2 = bitcast <2 x i64> %t1 to <2 x double>
  %t3 = call i32 @llvm.x86.avx.vtestz.pd(<2 x double> %c, <2 x double> %t2)
  %t4 = icmp ne i32 %t3, 0
  %t5 = select i1 %t4, i32 %a, i32 %b
  ret i32 %t5
}

define i32 @testpdz_256_invert1(<4 x double> %c, <4 x double> %d, i32 %a, i32 %b) {
; CHECK-LABEL: testpdz_256_invert1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vtestpd %ymm0, %ymm1
; CHECK-NEXT:    cmovael %esi, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %t0 = bitcast <4 x double> %d to <4 x i64>
  %t1 = xor <4 x i64> %t0, <i64 -1, i64 -1, i64 -1, i64 -1>
  %t2 = bitcast <4 x i64> %t1 to <4 x double>
  %t3 = call i32 @llvm.x86.avx.vtestz.pd.256(<4 x double> %c, <4 x double> %t2)
  %t4 = icmp ne i32 %t3, 0
  %t5 = select i1 %t4, i32 %a, i32 %b
  ret i32 %t5
}

;
; testc(~X,Y) -> testz(X,Y)
;

define i32 @testpdc_128_invert0(<2 x double> %c, <2 x double> %d, i32 %a, i32 %b) {
; CHECK-LABEL: testpdc_128_invert0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vtestpd %xmm1, %xmm0
; CHECK-NEXT:    cmovnel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = bitcast <2 x double> %c to <2 x i64>
  %t1 = xor <2 x i64> %t0, <i64 -1, i64 -1>
  %t2 = bitcast <2 x i64> %t1 to <2 x double>
  %t3 = call i32 @llvm.x86.avx.vtestc.pd(<2 x double> %t2, <2 x double> %d)
  %t4 = icmp ne i32 %t3, 0
  %t5 = select i1 %t4, i32 %a, i32 %b
  ret i32 %t5
}

define i32 @testpdc_256_invert0(<4 x double> %c, <4 x double> %d, i32 %a, i32 %b) {
; CHECK-LABEL: testpdc_256_invert0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vtestpd %ymm1, %ymm0
; CHECK-NEXT:    cmovnel %esi, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %t0 = bitcast <4 x double> %c to <4 x i64>
  %t1 = xor <4 x i64> %t0, <i64 -1, i64 -1, i64 -1, i64 -1>
  %t2 = bitcast <4 x i64> %t1 to <4 x double>
  %t3 = call i32 @llvm.x86.avx.vtestc.pd.256(<4 x double> %t2, <4 x double> %d)
  %t4 = icmp ne i32 %t3, 0
  %t5 = select i1 %t4, i32 %a, i32 %b
  ret i32 %t5
}

;
; testnzc(~X,Y) -> testnzc(X,Y)
;

define i32 @testpdnzc_128_invert0(<2 x double> %c, <2 x double> %d, i32 %a, i32 %b) {
; CHECK-LABEL: testpdnzc_128_invert0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vtestpd %xmm1, %xmm0
; CHECK-NEXT:    cmovbel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = bitcast <2 x double> %c to <2 x i64>
  %t1 = xor <2 x i64> %t0, <i64 -1, i64 -1>
  %t2 = bitcast <2 x i64> %t1 to <2 x double>
  %t3 = call i32 @llvm.x86.avx.vtestnzc.pd(<2 x double> %t2, <2 x double> %d)
  %t4 = icmp ne i32 %t3, 0
  %t5 = select i1 %t4, i32 %a, i32 %b
  ret i32 %t5
}

define i32 @testpdnzc_256_invert0(<4 x double> %c, <4 x double> %d, i32 %a, i32 %b) {
; CHECK-LABEL: testpdnzc_256_invert0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vtestpd %ymm1, %ymm0
; CHECK-NEXT:    cmovbel %esi, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %t0 = bitcast <4 x double> %c to <4 x i64>
  %t1 = xor <4 x i64> %t0, <i64 -1, i64 -1, i64 -1, i64 -1>
  %t2 = bitcast <4 x i64> %t1 to <4 x double>
  %t3 = call i32 @llvm.x86.avx.vtestnzc.pd.256(<4 x double> %t2, <4 x double> %d)
  %t4 = icmp ne i32 %t3, 0
  %t5 = select i1 %t4, i32 %a, i32 %b
  ret i32 %t5
}

;
; SimplifyDemandedBits - only the sign bit is required
;

define i32 @testpdc_128_signbit(<2 x double> %c, <2 x double> %d, i32 %a, i32 %b) {
; CHECK-LABEL: testpdc_128_signbit:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vtestpd %xmm1, %xmm0
; CHECK-NEXT:    cmovael %esi, %eax
; CHECK-NEXT:    retq
  %t0 = bitcast <2 x double> %c to <2 x i64>
  %t1 = ashr <2 x i64> %t0, <i64 63, i64 63>
  %t2 = bitcast <2 x i64> %t1 to <2 x double>
  %t3 = call i32 @llvm.x86.avx.vtestc.pd(<2 x double> %t2, <2 x double> %d)
  %t4 = icmp ne i32 %t3, 0
  %t5 = select i1 %t4, i32 %a, i32 %b
  ret i32 %t5
}

define i32 @testpdz_256_signbit(<4 x double> %c, <4 x double> %d, i32 %a, i32 %b) {
; CHECK-LABEL: testpdz_256_signbit:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vtestpd %ymm1, %ymm0
; CHECK-NEXT:    cmovnel %esi, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %t0 = bitcast <4 x double> %c to <4 x i64>
  %t1 = icmp sgt <4 x i64> zeroinitializer, %t0
  %t2 = sext <4 x i1> %t1 to <4 x i64>
  %t3 = bitcast <4 x i64> %t2 to <4 x double>
  %t4 = call i32 @llvm.x86.avx.vtestz.pd.256(<4 x double> %t3, <4 x double> %d)
  %t5 = icmp ne i32 %t4, 0
  %t6 = select i1 %t5, i32 %a, i32 %b
  ret i32 %t6
}

define void @combine_testp_v4f64(<4 x i64> %x){
; CHECK-LABEL: combine_testp_v4f64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vcmptrueps %ymm1, %ymm1, %ymm1
; CHECK-NEXT:    vtestpd %ymm1, %ymm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
entry:
  %xor.i.i.i.i.i.i.i.i.i = xor <4 x i64> %x, <i64 -1, i64 -1, i64 -1, i64 -1>
  %.cast.i.i.i.i.i.i = bitcast <4 x i64> %xor.i.i.i.i.i.i.i.i.i to <4 x double>
  %0 = call i32 @llvm.x86.avx.vtestz.pd.256(<4 x double> %.cast.i.i.i.i.i.i, <4 x double> %.cast.i.i.i.i.i.i)
  %cmp.i.not.i.i.i.i.i.i = icmp eq i32 %0, 0
  br i1 %cmp.i.not.i.i.i.i.i.i, label %if.end3.i.i.i.i.i.i, label %end

if.end3.i.i.i.i.i.i:                              ; preds = %entry
  ret void

end: ; preds = %entry
  ret void
}

declare i32 @llvm.x86.avx.vtestz.pd(<2 x double>, <2 x double>) nounwind readnone
declare i32 @llvm.x86.avx.vtestc.pd(<2 x double>, <2 x double>) nounwind readnone
declare i32 @llvm.x86.avx.vtestnzc.pd(<2 x double>, <2 x double>) nounwind readnone

declare i32 @llvm.x86.avx.vtestz.pd.256(<4 x double>, <4 x double>) nounwind readnone
declare i32 @llvm.x86.avx.vtestc.pd.256(<4 x double>, <4 x double>) nounwind readnone
declare i32 @llvm.x86.avx.vtestnzc.pd.256(<4 x double>, <4 x double>) nounwind readnone
