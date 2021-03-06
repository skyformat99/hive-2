UNAME = $(shell uname)

ifeq ($(UNAME), Linux)
	CC:= gcc
	LDFLAGS:= -Wl,-E -llua -lpthread -lm -ldl
else ifeq ($(UNAME), Darwin)
	CC:= clang
	LDFLAGS:= -llua -lpthread -lm
endif

CFLAGS:= -g -Wall -DDEBUG_MEMORY -std=gnu99  -Isrc/
# CFLAGS:= -g -Wall -O2 -Isrc/ -std=gnu99

SOURCE_C := src/hive.c src/hive_actor.c src/hive_memory.c \
	src/hive_mq.c src/hive_log.c src/socket_mgr.c \
	src/hive_bootstrap.c src/actor_log.c \
	src/lhive_buffer.c  src/hive_timer.c src/lhive_pack.c

SOURCE_O := $(SOURCE_C:.c=.o)


all: hive

hive: $(SOURCE_O)
	$(CC) -o $@ $^ $(LDFLAGS)


ringbuffer: src/hive_memory.c src/actor_gate/imap.c src/actor_gate/ringbuffer.c test/test_ringbuffer.c
	$(CC) -o $@ $(CFLAGS) $^

servergate: src/hive_memory.c src/actor_gate/imap.c src/actor_gate/servergate.c test/test_servergate.c
	$(CC) -o $@ $(CFLAGS) $^

clean:
	rm -rf $(SOURCE_O)


.PHONY: all clean
