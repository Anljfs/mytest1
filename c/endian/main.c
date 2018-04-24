#include<stdio.h>
#include<string.h>

int checkSystem2(void)  
    {  
        int i = 0x12345678;  
        char *c = &i;  
        return ((c[0] == 0x78) && (c[1] == 0x56) && (c[2] == 0x34) && (c[3] == 0x12));  
    }  

typedef union {  
    int i;  
    char c;  
}my_union;  
  
int checkSystem1(void)  
{  
    my_union u;  
    u.i = 1;  
    return (u.i == u.c);  
} 

    int main(void)  
    {  
        if(checkSystem1())  
            printf("little endian\n");  
        else  
            printf("big endian\n");  
      
        if(checkSystem2())  
            printf("little endian\n");  
        else  
            printf("big endian\n");  
      
        return 0;  
    }  
