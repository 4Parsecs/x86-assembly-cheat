; Increment, i++.

#include <lkmc.h>

LKMC_PROLOGUE
    mov eax, 0
    ; eax++
    inc eax
    LKMC_ASSERT_EQ(%eax, $1)
LKMC_EPILOGUE
