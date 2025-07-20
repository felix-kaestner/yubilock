CC   = clang
OUT  = yubilock
SRCS = yubilock.c

CFLAGS = -Wall -Wextra -O2
LDFLAGS = -F /System/Library/PrivateFrameworks -framework login

PREFIX ?= /usr/local

.PHONY: all clean install

all: $(OUT)

$(OUT): $(SRCS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(OUT) $(SRCS)

fmt:
	clang-format -i $(SRCS)

clean:
	rm -f $(OUT)

install: all
	install -d "$(PREFIX)/bin"
	install "$(OUT)" "$(PREFIX)/bin"
