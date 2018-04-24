CFLAGS = -O3 -Wall -fPIC 
#LDFLAGS = -shared -L/usr/lib/x86_64-linux-gnu -llua-5.1 
LDFLAGS = -L/usr/lib 
INC = /usr/include

TARGET = socser

socser:
	gcc -o socser ser_socket.c -g $(CFLAGS) -I$(INC) $(LDFLAGS)


#.PHONY: clean

#clean:
	
#	rm -rf $(OBJS) $(TARGET)
