    #include<stdio.h>  
    #include<strings.h>  
    #include<unistd.h>  
    #include<sys/types.h>  
    #include<sys/socket.h>  
    #include<netinet/in.h>  
    #include<arpa/inet.h>  
    #include<stdlib.h>  
    #include<string.h>  
      
    #define PORT    1234  
    #define BACKLOG 2  
    #define MAXDATASIZE 1000  
      
    void process_cli(int connectfd,struct sockaddr_in client);  
      
    int main()  
    {  
            int listenfd,connectfd;  
            pid_t pid;  
            struct sockaddr_in server;  
            struct sockaddr_in client;  
            int sin_size;  
      
            if((listenfd=socket(AF_INET,SOCK_STREAM,0))==-1)  
            {  
                    perror("socket() error");  
                    exit(1);  
            }  
      
            bzero(&server,sizeof(server));  
            server.sin_family=AF_INET;  
            server.sin_port=htons(PORT);  
            server.sin_addr.s_addr=htonl(INADDR_ANY);  
      
      
            if(bind(listenfd,(struct sockaddr *)&server,sizeof(struct sockaddr))==-1)  
            {  
                    perror("bind() error");  
                    exit(1);  
            }  
      
            if(listen(listenfd,BACKLOG)==-1)  
            {  
                    perror("listen() error");  
                    exit(1);  
            }  
      
            sin_size=sizeof(struct sockaddr_in);  
      
            while(1)  
            {  
                    sin_size=sizeof(struct sockaddr_in);  
                    if((connectfd=accept(listenfd,(struct sockaddr *)&client,&sin_size))==-1)  
                    {  
                            perror("accept() error");  
                            exit(1);  
                    }  
      
                    if((pid=fork())<0)  
                    {  
                            printf("fork error\n");  
                            exit(1);  
      
                    }  
                    else if(pid==0)  
                    {  
                            close(listenfd);  
                            process_cli(connectfd,client);  
                            exit(0);  
                    }  
                    else  
                    {  
                            close(connectfd);  
                            continue;  
      
                    }  
            }  
            close(listenfd);  
    }  
      
    void process_cli(int connectfd, struct sockaddr_in client)  
    {  
            int num,i;  
            char recvbuf[MAXDATASIZE],sendbuf[MAXDATASIZE],cli_name[MAXDATASIZE];  
      
            printf("You got a connection from:%s.",inet_ntoa(client.sin_addr));  
            num=recv(connectfd,cli_name,MAXDATASIZE,0);  
            if(num==0)  
            {  
                    close(connectfd);  
                    printf("client disconnected.\n");  
                    return;  
            }  
      
            cli_name[num-1]='\0';  
            printf("Client's name is %s.\n",cli_name);  
      
            while((num=recv(connectfd,recvbuf,MAXDATASIZE,0))>0)  
            {  
                    recvbuf[num]='\0';  
                    printf("Received client (%s) message:%s",cli_name,recvbuf);  
      
                    send(connectfd,"sent successfully.\n",19,0);  
            }  
            close(connectfd);  
    }  