; Compare two numbers and set the flags register.
;
; `cmp X, Y` does `X - Y` and ignores the exact result,
; but sets all flags that would be set on the subtraction.
;
; If operands are unsigned:
;
;     ZF = (X == Y) ? 1 : 0
;     CF = (X < Y) ? 1 : 0
;
; If operands are signed:
;
;     ZF = (eax == ebx) ? 1 : 0
;     if( eax < ebx)
;         assert(OF == SF)
;     else if(eax > ebx)
;         assert(OF != SF)

#include <lkmc.h>

LKMC_PROLOGUE
    mov eax, 0
    cmp eax, 0
    ASSERT_FLAG je
    LKMC_ASSERT_EQ_32(%eax, $0)

    mov eax, 2
    cmp eax, 1
    ASSERT_FLAG jne
    LKMC_ASSERT_EQ_32(%eax, $2)

LKMC_EPILOGUE
