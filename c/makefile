CFLAGS = -O3 -Wall -fPIC 
LDFLAGS = -shared -llua
INC = /usr/include/lua5.1
OBJS = demo.o

TARGET = test

$(TARGET): $(OBJS)
	$(LD) -o $@ $^ $(LDFLAGS) -I$(INC)

$(OBJS):%.o:%.cpp
	$(CC) $< $(CFLAGS) -I$(INC)


.PHONY: clean

clean:
	rm -rf $(OBJS) $(TARGET)
