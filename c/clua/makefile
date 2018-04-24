CC = g++
LD = g++

CFLAGS = -O3 -Wall -fPIC 
#LDFLAGS = -shared -L/usr/lib/x86_64-linux-gnu -llua-5.1 
LDFLAGS = -L/usr/lib/x86_64-linux-gnu -llua-5.1 
INC = /usr/include/lua5.1

TARGET = demo.so clean

demo.so: demo.o
	gcc -o demo.so demo.o -shared -I$(INC) $(LDFLAGS)
demo.o:%.o:%.c
	gcc -c demo.c -I$(INC) $(CFLAGS)



.PHONY: clean

clean:
	rm -rf demo.o
