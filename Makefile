.POSIX:

BITS = 32
CC = gcc
CFLAGS = -ggdb3 -m$(BITS) -O0 -pedantic-errors -std=c89 -Wall
GAS_EXT = .S
LIB_DIR = lib/
NASM = nasm -f elf$(BITS) -gdwarf -w+all
NASM_EXT = .asm
OBJ_EXT = .o
OUT_EXT = .out
PHONY_MAKES =
RUN = main
TEST = test
export

-include params.makefile

OUTS := $(foreach IN_EXT,$(GAS_EXT) $(NASM_EXT),$(patsubst %$(IN_EXT),%$(OUT_EXT),$(wildcard *$(IN_EXT))))

.PRECIOUS: %$(OBJ_EXT)
.PHONY: all clean driver gas run $(PHONY_MAKES)

all: driver $(OUTS) $(PHONY_MAKES)
	for phony in $(PHONY_MAKES); do \
	  $(MAKE) -C $${phony}; \
	done

%$(OUT_EXT): %$(OBJ_EXT)
	$(CC) $(CFLAGS) -o '$@' '$<' $(LIB_DIR)*$(OBJ_EXT)

%$(OBJ_EXT): %$(NASM_EXT)
	$(NASM) -o '$@' '$<'

%$(OBJ_EXT): %$(GAS_EXT)
	$(CC) $(CFLAGS) -c -o '$@' '$<'

clean:
	rm -f *$(OBJ_EXT) *$(OUT_EXT)
	$(MAKE) -C $(LIB_DIR) '$@'
	for phony in $(PHONY_MAKES); do \
	  $(MAKE) -C $${phony} clean; \
	done

driver:
	$(MAKE) -C $(LIB_DIR)

gdb-%: %$(OUT_EXT)
	gdb --nh -ex 'layout split' -ex 'break asm_main' -ex 'run' '$<'

run-%: %$(OUT_EXT)
	./'$<'

test: all
	@\
	if [ -x $(TEST) ]; then \
	  ./$(TEST) '$(OUT_EXT)' ;\
	else\
	  fail=false ;\
	  for t in *"$(OUT_EXT)"; do\
	    if ! ./"$$t"; then \
	      fail=true ;\
	      break ;\
	    fi ;\
	  done ;\
	  if $$fail; then \
	    echo "TEST FAILED: $$t" ;\
	    exit 1 ;\
	  else \
	    echo 'ALL TESTS PASSED' ;\
	    exit 0 ;\
	  fi ;\
	fi
	for phony in $(PHONY_MAKES); do \
	  $(MAKE) -C $${phony} test; \
	done
