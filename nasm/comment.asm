; # Comments

    ; Single line with semicolon `;`

    ; Multi-line: TODO `%comment` was added but then removed?

        ;%comment
            ;Any thing.
        ;%endcomment

#include <lkmc.h>

LKMC_PROLOGUE
    mov eax, 1
    ; mov eax, 2
    LKMC_ASSERT_EQ(%eax, $1)
LKMC_EPILOGUE
