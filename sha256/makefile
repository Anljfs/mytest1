CFLAGS = -O3 -Wall -fPIC 
--LDFLAGS = -shared -llua
INC = /usr/include/lua5.1
OBJS = main.o

TARGET = test clean

test: 
	gcc -o test sha256.c -I$(INC)
#gcc -o $@ $^ -I$(INC)

#$(OBJS):%.o:%.c
#	gcc $< $(CFLAGS) -I$(INC)


.PHONY: clean

clean:
	rm -rf main.o
