#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define PORT    1234  
#define BACKLOG 2  
#define MAXDATASIZE 1000  

int flag =1;
 /*
// C prototype : void StrToHex(BYTE *pbDest, BYTE *pbSrc, int nLen)
// parameter(s): [OUT] pbDest - ���������
// [IN] pbSrc - �ַ���
// [IN] nLen - 16���������ֽ���(�ַ����ĳ���/2)
// return value: 
// remarks : ���ַ���ת��Ϊ16������
*/
void StrToHex(char *pbDest, char *pbSrc, int nLen)
{
	char h1,h2;
	char s1,s2;
	int i;

	for (i=0; i<nLen; i++)
	{
		h1 = pbSrc[2*i];
		h2 = pbSrc[2*i+1];

		s1 = toupper(h1) - 0x30;
		if (s1 > 9) 
		s1 -= 7;

		s2 = toupper(h2) - 0x30;
		if (s2 > 9) 
		s2 -= 7;

		pbDest[i] = s1*16 + s2;
	}
}

/*
// C prototype : void HexToStr(BYTE *pbDest, BYTE *pbSrc, int nLen)
// parameter(s): [OUT] pbDest - ���Ŀ���ַ���
// [IN] pbSrc - ����16����������ʼ��ַ
// [IN] nLen - 16���������ֽ���
// return value: 
// remarks : ��16������ת��Ϊ�ַ���
*/
void HexToStr(char *pbDest, char *pbSrc, int nLen)
{
	char ddl,ddh;
	int i;

	for (i=0; i<nLen; i++)
	{
		ddh = 48 + pbSrc[i] / 16;
		ddl = 48 + pbSrc[i] % 16;
		if (ddh > 57) ddh = ddh + 7;
		if (ddl > 57) ddl = ddl + 7;
		pbDest[i*2] = ddh;
		pbDest[i*2+1] = ddl;
	}

	pbDest[nLen*2] = '\0';
}
void printid(int addr)
{
	int id = getpid();
	int ppid = getppid();
	printf("[%d]now pid is %d ppid is %d\n", addr, id, ppid);
}
void process_cli(int connectfd, struct sockaddr_in client)  
{
		int num;  
		printf("[�ӽ���]now getpid is %d \n", getpid());
		char recvbuf[MAXDATASIZE],cli_name[MAXDATASIZE];  
		memset(cli_name, 0, sizeof(cli_name));
		printf("You got a connection from:%s.",inet_ntoa(client.sin_addr));  
		num=recv(connectfd,cli_name,MAXDATASIZE,0);  
		if(num==0)  
		{  
				close(connectfd);  
				printf("client disconnected.\n");  
				return;  
		}  
  
		cli_name[num-1]='\0';  
		if(cli_name[num-2] == 13 && cli_name[num-1] ==10) {
			cli_name[num-2] = '\0';
		}else{
			cli_name[num]='\0';  
		}
		printf("Client's name is %s.\n",cli_name);  
  
		while((num=recv(connectfd,recvbuf,MAXDATASIZE,0))>0)  
		{  
				//printf("Client's name is %s.\n",cli_name);
				//printf("%s",cli_name);
				printf("receive msg len is [%d]", num);
				for(int i=0;i<num;i++){
					//printf("receive [%d] char is [%d]\n", i, recvbuf[i]);
				}
				if(recvbuf[num-2] == 13 && recvbuf[num-1] ==10) {
					recvbuf[num-2] = '\0';
				}else{
					recvbuf[num]='\0';  
				}
				for(int i=0;i<num;i++){
					//printf("--receive [%d] char is [%d]\n", i, recvbuf[i]);
				}
				if (strcmp("-1",recvbuf) == 0) 
					break;
				
				//printf("Received client %s message:%s\n",cli_name,recvbuf);  
				printf("Received client message:[%s][%d]\n",recvbuf, (int)strlen(recvbuf));  
				send(connectfd,"sent successfully.\n",19,0);  
		}  
		close(connectfd);  
}

int main(){
    //�����׽���
    int serv_sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	pid_t pid;
    //���׽��ֺ�IP���˿ڰ�
    struct sockaddr_in serv_addr;
    memset(&serv_addr, 0, sizeof(serv_addr));  //ÿ���ֽڶ���0���
    serv_addr.sin_family = AF_INET;  //ʹ��IPv4��ַ
    serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");  //�����IP��ַ
    serv_addr.sin_port = htons(1234);  //�˿�
    bind(serv_sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
	printf("bind success \n");
    //�������״̬���ȴ��û���������
    listen(serv_sock, 20);
	printf("listen ....\n");
    //���տͻ�������
    struct sockaddr_in clnt_addr;
	while(1){
		socklen_t clnt_addr_size = sizeof(clnt_addr);
		int clnt_sock = accept(serv_sock, (struct sockaddr*)&clnt_addr, &clnt_addr_size);
		//��ͻ��˷�������
		printf("received msg ....\n");
		
		printf("[������]now getpid is %d\n", getpid());
		if((pid=fork())<0)  
		{  
				printf("fork error\n");  
				exit(1);  

		}  
		//�ӽ���
		else if(pid==0)  
		{  
				printf("[�ӽ���]now pid is %d getpid is %d\n", pid, getpid());
				close(serv_sock);  
				process_cli(clnt_sock,clnt_addr);  
				exit(0);  
		}  
		//������
		else  
		{  
				printf("[������]now �ӽ���pid is %d getpid is %d\n", pid, getpid());
				close(clnt_sock);  
				continue;  

		}  
		printf("[������after]now getpid is %d\n", getpid());
		char str[] = "Hello World!";
		int wint = 0;
		wint =  write(clnt_sock, str, sizeof(str));
		printf("%d ...\n",wint);
		printf("send msg ....\n");
		//�ر��׽���
		close(clnt_sock);
	}
    close(serv_sock);
	printf("closed ....\n");
    return 0;
}
