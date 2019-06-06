; # MOVZX

    ; mov and zero extend

    ; Works for unsigned numbers.

#include <lkmc.h>

LKMC_PROLOGUE

    mov eax, 0
    mov ax, 0x1000
    movzx eax, ax
    LKMC_ASSERT_EQ_32(%eax, $0x1000)

    mov ebx, 0
    mov al, 0x10
    movzx ebx, al
    mov eax, ebx
    LKMC_ASSERT_EQ_32(%eax, $0x10)

    mov eax, 0
    mov ax, -1
    movzx eax, ax
    ASSERT_NEQ eax, -1

    ; ERROR: operands have the same size. Fist must be larger.
    ;movzx al, al

    ; ERROR: must be a register
    ;movzx eax, 0
LKMC_EPILOGUE
