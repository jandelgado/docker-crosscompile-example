SOURCES := hello.c
OBJS := $(SOURCES:.c=.o)

all: hello

hello: $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LFLAGS) $(LIBS)

.c.o:
	$(CC) $(CFLAGS) $(INCLUDES) -c $<

clean:
	rm -f $(OBJS)
