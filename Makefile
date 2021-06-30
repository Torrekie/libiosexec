CC       ?= cc
AR       ?= ar
LN       ?= ln
RANLIB   ?= ranlib
INSTALL  ?= install

MEMO_PREFIX     ?=
MEMO_SUB_PREFIX ?= /usr

SOVER := 1

SRC := execl.c execv.c utils.c get_new_argv.c

all: libiosexec.$(SOVER).dylib libiosexec.a

%.o: %.c
	$(CC) -c $(CFLAGS) -fvisibility=hidden -DLIBIOSEXEC_INTERNAL $^

libiosexec.$(SOVER).dylib: $(SRC:%.c=%.o)
	$(CC) $(CFLAGS) -fvisibility=hidden -DLIBIOSEXEC_INTERNAL -install_name $(MEMO_PREFIX)$(MEMO_SUB_PREFIX)/lib/$@ -shared -o $@ $^

libiosexec.a: $(SRC:%.c=%.o)
	$(AR) cru $@ $^
	$(RANLIB) $@

install: all
	$(INSTALL) -Dm644 libiosexec.$(SOVER).dylib $(DESTDIR)$(MEMO_PREFIX)$(MEMO_SUB_PREFIX)/lib/libiosexec.$(SOVER).dylib
	$(LN) -sf libiosexec.$(SOVER).dylib $(DESTDIR)$(MEMO_PREFIX)$(MEMO_SUB_PREFIX)/lib/libiosexec.dylib
	$(INSTALL) -Dm644 libiosexec.a $(DESTDIR)$(MEMO_PREFIX)$(MEMO_SUB_PREFIX)/lib/libiosexec.a
	$(INSTALL) -Dm644 libiosexec.h $(DESTDIR)$(MEMO_PREFIX)$(MEMO_SUB_PREFIX)/include/libiosexec.h

clean:
	rm -f libiosexec.$(SOVER).dylib libiosexec.a *.o

.PHONY: all clean install
