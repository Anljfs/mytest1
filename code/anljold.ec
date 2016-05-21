#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <time.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdarg.h>
#include <math.h>
#include <sys/errno.h>
#include <sys/types.h>
#include <netinet/in.h>
#include "trc_trace.h"
#include "tpu.h"
#include "tpulib.h"
#include "pool.h"
#include "ippora.h"
#include "applib.h"
#include "iconv.h"

extern int errno;
#define LOGFILE "testtime.log"
EXEC SQL include sqlca;
int main(){
	char sFlowno[20];
	char sTemp[2];
	char str1[200],str2[200];
	int  flowno;
	double d1,d2;
	int i,j,k,l;
	memset(str1, 0, sizeof(str1));
	memset(str2, 0, sizeof(str2));

	sprintf(str1,"-0.22");

	testDb2();
	return 0;
}
int testDb2()
{
	int iRet = 0;
	char aczWhere[256];
	memset(aczWhere, 0, sizeof(aczWhere));
	sprintf(aczWhere, "update ptstca set userid='test' where gwsid='222' ");
	printf("�������ݿ�����\n");
	iRet=DAI_ConnTpuDb();
	if(iRet < 0)
	{
		printf("�������ݿ�����ʧ��[%d][%s]\n",iRet,APP_PUB_GetSqlErrMsg());
		return -1;
	}else
	{
		printf("�������ݿ����ӳɹ�\n");
	}

	printf("���ݿ�����\n");
	iRet = CZDB_Connect("czdb");
	if(iRet < 0)
	{
		printf("���ݿ�����ʧ��[%d][%s]\n",iRet,APP_PUB_GetSqlErrMsg());
		return -1;
	}else
	{
		printf("���ݿ����ӳɹ�\n");
	}

	printf("�������ݿ�Ͽ�\n");
	iRet = DAI_DisconnDB( NULL );
	if(iRet < 0)
	{
		printf("�������ݿ�Ͽ�ʧ��\n");
		return -1;
	}else
	{
		printf("�������ݿ�Ͽ��ɹ�\n");
	}

	printf("���ݿ�Ͽ�\n");
	iRet = CZDB_DisConnect("czdb");
	if(iRet < 0)
	{
		printf("���ݿ�Ͽ�ʧ��\n");
		return -1;
	}else
	{
		printf("���ݿ�Ͽ��ɹ�\n");
	}
	return 0;
}

int testsplt()
{
	int iRet = 0;
	int iRetcode=0;
	int i=0;
	char strTmp2[250];
	char strValue[20][128];
	char strTmp[18];

	sprintf(strTmp, "123|aaa|bbb|�ŏ|");
	printf("strTmp = [%s]",strTmp);
	memset(strValue, 0, sizeof(strValue));
	iRet = strGetFormItem(strTmp,"|",strValue);
	printf("����[%d]���ָ���Ϣ\n", iRet);
	for(;i< iRet; i++)
	{
		printf("��[%d]��ֵΪ[%s]\n",i,strValue[i]);
	}
	printf("str=[%s]\n", strTmp);
	TRC_HexMsg(LOGFILE, strTmp, strlen(strTmp),"111");
	memset(strTmp2, 0, sizeof(strTmp2));
	for(i=1;i<=iRet;i++)
	{
		memset(strTmp2, 0, sizeof(strTmp2));
		iRetcode = GetItemFromStr(strTmp, strTmp2, i,"|", 0);
		if(iRetcode < 0)
		{
			printf("sep = 0 ��[%d]��ֵ����\n",i);
			break;
		}
		printf("sep = 0 ��[%d]��ֵΪ[%s]\n",i,strTmp2);
		memset(strTmp2, 0, sizeof(strTmp2));
		iRetcode = GetItemFromStr(strTmp, strTmp2, i,"|", 1);
		if(iRetcode < 0)
		{
			printf("sep = 1 ��[%d]��ֵ����\n",i);
			break;
		}
		printf("sep = 1 ��[%d]��ֵΪ[%s]\n",i,strTmp2);
	}

}
int testtime1()
{
	char sFlag[3];
	int iRet;
	long t1 =  20151000223000;
	char time1[20];
	char aczCurDateTime[20];
	pid_t curr_pid ;
	curr_pid= getpid();
	memset(aczCurDateTime, 0, sizeof(aczCurDateTime));
	//UTIL_GetSystemDateTime(aczCurDateTime,"YYYYMMDDhhmmss");
	sprintf(aczCurDateTime,"20160229145500");
	printf("  time =[%s]\n",aczCurDateTime);
	iRet = tranTimeCheck("m:1-n:0-2400;m:e:0-1800",aczCurDateTime);
	if(iRet == 0){
		printf("tranTimeCheck  [%d]YES iRet =[%d]\n",curr_pid,iRet);
		TRC_Trace(0,4,LOGFILE,"tranTimeCheck  [%d]YES iRet =[%d]\n",curr_pid,iRet);

	}else if(iRet == -2)
	{
		printf("tranTimeCheck  [%d] NO iRet =[%d]\n",curr_pid,iRet);
		TRC_Trace(0,4,LOGFILE,"tranTimeCheck  [%d] NO iRet =[%d]\n",curr_pid,iRet);
	}else
	{
		printf("tranTimeCheck  [%d] ERROR iRet =[%d]\n",curr_pid,iRet);
		TRC_Trace(0,4,LOGFILE,"tranTimeCheck  [%d] ERROR iRet =[%d]\n",curr_pid,iRet);
	}
	memset(sFlag, 0, sizeof(sFlag));
	iRet = dzTimeCheck("2-e:0145:F;e:1900:T",aczCurDateTime,sFlag);
	if(iRet == 0){
		printf("dzTimeCheck flag = [%s] [%d] YES iRet =[%d]\n",sFlag,curr_pid,iRet);
		TRC_Trace(0,4,LOGFILE,"dzTimeCheck flag = [%s] [%d] YES iRet =[%d]\n",sFlag,curr_pid,iRet);
	}else if(iRet == -2)
	{
		printf("dzTimeCheck  [%d] NO iRet =[%d]\n",curr_pid,iRet);
		TRC_Trace(0,4,LOGFILE,"dzTimeCheck flag = [%s] [%d] NO iRet =[%d]\n",sFlag,curr_pid,iRet);
	}else
	{
		printf("dzTimeCheck flag = [%s] [%d] ERROR iRet =[%d]\n",sFlag,curr_pid,iRet);
		TRC_Trace(0,4,LOGFILE,"dzTimeCheck flag = [%s] [%d] ERROR iRet =[%d]\n",sFlag,curr_pid,iRet);

	}
	memset(sFlag, 0, sizeof(sFlag));
	iRet = plTimeCheck("m:02-n:1130:P;m:e:1445:Q",aczCurDateTime,sFlag);
	if(iRet == 0){
		printf("plTimeCheck flag = [%s] [%d] YES iRet =[%d]\n",sFlag,curr_pid,iRet);
		TRC_Trace(0,4,LOGFILE,"plTimeCheck flag = [%s] [%d] YES iRet =[%d]\n",sFlag,curr_pid,iRet);
	}else if(iRet == -2)
	{
		printf("plTimeCheck flag = [%s] [%d] NO iRet =[%d]\n",sFlag,curr_pid,iRet);
		TRC_Trace(0,4,LOGFILE,"plTimeCheck flag = [%s] [%d] NO iRet =[%d]\n",sFlag,curr_pid,iRet);
	}else
	{
		printf("plTimeCheck  [%d] ERROR iRet =[%d]\n",curr_pid,iRet);
		TRC_Trace(0,4,LOGFILE,"plTimeCheck flag = [%s] [%d] ERROR iRet =[%d]\n",sFlag,curr_pid,iRet);
	}
	/*for(int i=0;i<31;i++){
		memset(time1 , 0, sizeof(time1));
		t1+=1000000;
		sprintf(time1,"%ld",t1);
		iRet = tranTimeCheck("m:1-n:0-2400;m:e:0-1800",);
		if(iRet == 0){
			printf(" [%s] [%s] YES iRet =[%d]\n","m:2-e:0100:F;w:5:2230:T",time1,iRet);
		}else if(iRet == -1)
		{
			printf(" [%s] [%s] NO iRet =[%d]\n","m:2-e:0100:F;w:5:2230:T",time1,iRet);
		}else
		{
			printf("error\n");
		}
	}*/
}

int testshuzu()
{
	char str1[400],str2[500];
	int j[5]={1,2,3,4,5};
	int n=10;
	int i;
	for(i=0;i<5;i++){
		printf("\n [%d]", j[i+1]);
	}
	printf("\n i =[%d]\n",i);

	return 0;
}
int testcharset()
{
	char str1[400],str2[500];
	int i;
	int j=0,k=500,l=0;
	memset(str2, 0, sizeof(str2));
	sprintf(str1,"111����ʯ������");
	i=GBK2Utf(str1,15,str2,&k);
	printf("\n i =[%d]\n",i);
	printf("str1 =[%s] str2=[%s] k=[%d]\n",str1, str2, k);
	return 0;
}
int testtxgl(){
	char aczNAME[20];
	char aczSTATUS[20];
	char aczIP[20];
	int iPort;
	memset(aczNAME,0,sizeof(aczNAME));
	memset(aczSTATUS,0,sizeof(aczSTATUS));
	memset(aczIP,0,sizeof(aczIP));
	int iRegResult = CMP_GetPara("CIP0", "IPPD", aczIP, &iPort, aczNAME ,aczSTATUS);
    if(iRegResult < 0)
    {
				printf("��ȡͨѶ����ʧ��[%d]\n",iRegResult);
        return -1;
    }

		printf("��ȡͨѶ�����ɹ�[%d]ip[%s]port[%d]\n",iRegResult,aczIP,iPort);
}
int testerr(){
	int j,i1;
	int t1,t2;
	struct timeval start, end;
	printf("errno:[%d]\n",errno);
	i1=open("ssss.txt",O_WRONLY|O_CREAT|O_APPEND,0777);
	printf("errno2:[%d]\n",errno);

	t1=time(NULL);
	t2=time(NULL);
	j= t2-t1;
	printf("time [%d] openfile[%d]\n",j,i1);

    gettimeofday( &start, NULL );
	sleep(3);
    for(int i=0;i<10000;i++)
	{
		write(i1,"123456678918231234566789182312345667891823123456678918231234566789182312345667891823\n",85);
	}
    gettimeofday( &end, NULL );
    int timeuse = 1000000 * ( end.tv_sec - start.tv_sec ) + end.tv_usec - start.tv_usec;
    printf("time: %d us\n", timeuse);
	return errno;
}
int GetDbStr1(char *strSql,char *strResult)
{
	int iRet;
	EXEC SQL BEGIN DECLARE SECTION;
		 	char 	aczSqlBuf[500];
			char	aczStr[200];
	EXEC SQL END DECLARE SECTION;
/* 	printf("\n1-----%s\n",strSql);
 */	memset(aczSqlBuf , 0, sizeof(aczSqlBuf));
	strcpy(aczSqlBuf, strSql);
	/* printf("\n2-----%s\n",strSql); */
	DAI_ConnTpuDb();
	EXEC SQL prepare dbQueryld FROM :aczSqlBuf;
	if (sqlca.sqlcode != 0)
	{
		DAI_DisconnDB( NULL );
		printf("\n[%s][%d]\n",sqlca.sqlerrm.sqlerrmc,sqlca.sqlcode);
		return sqlca.sqlcode;
	}
/* 	printf("\n3-----%s\n",strSql);
 */	EXEC SQL declare dbQueryCursor cursor for dbQueryld;
	if (sqlca.sqlcode != 0) {DAI_DisconnDB( NULL );return sqlca.sqlcode;}
/* 	printf("\n4-----%s\n",strSql);
 */	EXEC SQL open dbQueryCursor;
	if (sqlca.sqlcode != 0) {DAI_DisconnDB( NULL );return sqlca.sqlcode;}
/* 	printf("\n1-----%s\n",strSql);
 */	memset(aczStr, 0, sizeof(aczStr));
	EXEC SQL fetch dbQueryCursor into :aczStr;
	if (sqlca.sqlcode != 0)
	{
		 EXEC SQL close dbQueryCursor;
		 DAI_DisconnDB( NULL );
		 return sqlca.sqlcode;
	}
	EXEC SQL close dbQueryCursor;

	UTIL_trim(aczStr);
	strcpy(strResult, aczStr);
    return 0;
}

int testtime()
{
	char sFlag[3];
	int iRet;
	long t1 =  20151000223000;
	char time1[20];
	char aczCurDateTime[20];
	pid_t curr_pid ;
	curr_pid= getpid();

	for(int i=0;i<100000;i++){
		sleep(1);
		memset(aczCurDateTime, 0, sizeof(aczCurDateTime));
		UTIL_GetSystemDateTime(aczCurDateTime,"YYYYMMDDhhmmss");
		printf("  time =[%s]\n",aczCurDateTime);
		iRet = tranTimeCheck("m:1-n:0-2400;m:e:0-1800",aczCurDateTime);
		if(iRet == 0){
			printf("tranTimeCheck  [%d]YES iRet =[%d]\n",curr_pid,iRet);
			TRC_Trace(0,4,LOGFILE,"tranTimeCheck  [%d]YES iRet =[%d]\n",curr_pid,iRet);

		}else if(iRet == -2)
		{
			printf("tranTimeCheck  [%d] NO iRet =[%d]\n",curr_pid,iRet);
			TRC_Trace(0,4,LOGFILE,"tranTimeCheck  [%d] NO iRet =[%d]\n",curr_pid,iRet);
		}else
		{
			printf("tranTimeCheck  [%d] ERROR iRet =[%d]\n",curr_pid,iRet);
			TRC_Trace(0,4,LOGFILE,"tranTimeCheck  [%d] ERROR iRet =[%d]\n",curr_pid,iRet);
		}
		memset(sFlag, 0, sizeof(sFlag));
		iRet = dzTimeCheck("2-e:0145:F;e:1900:T",aczCurDateTime,sFlag);
		if(iRet == 0){
			printf("dzTimeCheck  [%d] YES iRet =[%d]\n",curr_pid,iRet);
			TRC_Trace(0,4,LOGFILE,"dzTimeCheck flag = [%s] [%d] YES iRet =[%d]\n",sFlag,curr_pid,iRet);
		}else if(iRet == -2)
		{
			printf("dzTimeCheck  [%d] NO iRet =[%d]\n",curr_pid,iRet);
			TRC_Trace(0,4,LOGFILE,"dzTimeCheck flag = [%s] [%d] NO iRet =[%d]\n",sFlag,curr_pid,iRet);
		}else
		{
			printf("dzTimeCheck  [%d] ERROR iRet =[%d]\n",curr_pid,iRet);
			TRC_Trace(0,4,LOGFILE,"dzTimeCheck flag = [%s] [%d] ERROR iRet =[%d]\n",sFlag,curr_pid,iRet);

		}
		memset(sFlag, 0, sizeof(sFlag));
		iRet = plTimeCheck("m:02-n:1130;m:e:1445",aczCurDateTime,sFlag);
		if(iRet == 0){
			printf("plTimeCheck  [%d] YES iRet =[%d]\n",curr_pid,iRet);
			TRC_Trace(0,4,LOGFILE,"plTimeCheck flag = [%s] [%d] YES iRet =[%d]\n",sFlag,curr_pid,iRet);
		}else if(iRet == -2)
		{
			printf("plTimeCheck  [%d] NO iRet =[%d]\n",curr_pid,iRet);
			TRC_Trace(0,4,LOGFILE,"plTimeCheck flag = [%s] [%d] NO iRet =[%d]\n",sFlag,curr_pid,iRet);
		}else
		{
			printf("plTimeCheck  [%d] ERROR iRet =[%d]\n",curr_pid,iRet);
			TRC_Trace(0,4,LOGFILE,"plTimeCheck flag = [%s] [%d] ERROR iRet =[%d]\n",sFlag,curr_pid,iRet);
		}
	}
	/*for(int i=0;i<31;i++){
		memset(time1 , 0, sizeof(time1));
		t1+=1000000;
		sprintf(time1,"%ld",t1);
		iRet = tranTimeCheck("m:1-n:0-2400;m:e:0-1800",);
		if(iRet == 0){
			printf(" [%s] [%s] YES iRet =[%d]\n","m:2-e:0100:F;w:5:2230:T",time1,iRet);
		}else if(iRet == -1)
		{
			printf(" [%s] [%s] NO iRet =[%d]\n","m:2-e:0100:F;w:5:2230:T",time1,iRet);
		}else
		{
			printf("error\n");
		}
	}*/
}
int test4(){
	char sa[20];
	int i =1234;
	memset(sa,0,sizeof(sa));
	printf("\n str = [%012d]\n",i);
	printf("\n sizeof sa =[%d]\n",strlen(sa));
}
int teststrstr(){
	char sa[200],sa1[200],sa2[200],sa3[200];
	char sp[200]="/ssit/ext/20150608/ppp.txt";
	char spp[200] ="/cbskf/ftp/ext/pldl/20171130/DDHP00108494";
	char *p;
	char *p1,*p2;
	memset(sa,0,sizeof(sa));
	memset(sa1,0,sizeof(sa));
	memset(sa2,0,sizeof(sa));

	p = strstr(spp,"pldl");
	if(p != NULL)
	{
	    strcpy(sa,p+14);
		printf("\n  sa =[%s]\n",sa);
	}
	p2 = spp;
	while(1)
	{
		p1=strstr(p2,"/");
		if(p1==NULL){
			strcpy(sa1,p2);
			break;
		}
		p2 = p1+1;
	}
	printf("\n  sa1 =[%s]\n",sa1);
	/* printf("\n sizeof sa =[%d]\n",strlen(sa));
	p = strstr(sp,"/");
	if(p != NULL)
	{
	 strcpy(sa,p);
	printf("\n  sa =[%s]\n",sa);
	}
	p1 = strstr(sp,"ext");
	if(p1 != NULL)
	{
	 strcpy(sa1,p1+12);
	printf("\n  sa1 =[%s]\n",sa1);
	}
	p2 = strstr(sp,"08");
	if(p2 != NULL)
	{
	 strcpy(sa2,p2);
	printf("\n  sa2 =[%s]\n",sa2);
	} */
}
int testif()
{
 if(0)
 {printf("\nprint if(0) is true\n");}
 if(1)
 {printf("\nprint if(1) is true\n");}
#if 1
printf("\n if print if(0) is true\n");
#endif

}
int testbreak(){
	int iRet =-2;
	int j;
	printf("\n����ѭ����ʼ\n");
	if(iRet < 0)
	{
		printf("ftp�ϴ��ļ�ʧ��\n");
		for(j =0;j<10;j++)
		{
			printf("ftp�ϴ��ļ�����[%d]�ο�ʼ\n",j+1);
			iRet = j-3;
			if(iRet<0)
			{
				printf("ftp�ϴ��ļ�ʧ�ܣ���[%d]��\n",j+1);
			}else
			{
				printf("ftp�ϴ��ļ��ɹ�����[%d]��\n",j+1);
				break;
			}
			printf("ftp�ϴ��ļ�����[%d]�ν���\n",j+1);
		}
		printf("����ѭ������1\n");
	}
	printf("����ѭ������2\n");
}
int test1(){
	float f = 16.10;
	float f1,f2;
	double d1,d2;
	double d = 24.40;
	char str1[20];
	char strTmp[20];
	int i=0;
	long ni;
	char sni[20];

	memset(str1,0,sizeof(str1));
	for(;f<170.00;){
		sprintf(str1,"%.2f",f);
		f1 = atof(str1);

		memset(strTmp,0,sizeof(strTmp));
		sprintf(strTmp,"%.0f",f1*100);
		i = 1 + (int)(f1*100);
		ni = (int)(atof(str1)*100);

		memset(sni, 0, sizeof(sni));
		sprintf(sni, "%d",ni);
		if(strcmp(strTmp,sni)!=0){
			printf("\n str = %s" ,str1);
			printf("\n%f,%.2f\n",f1,f1);
			printf("i1 = %d  i2 = %d\n",(int)(f1*100) ,ni);
			printf("%s\n",strTmp);

		}
		f+=0.01;
	}

}
int test3()
{
	char s1[20];
	double f = 2244.5655;
	printf("\n f = %.0f\n",f);
}
int teststrcp()
{
	char s1[20];
	char s2[20]="good";
	printf("\n s1 = [%s]\n",s1);
	memset(s1,'a',sizeof(s1));
	printf("\n s1 = [%s]\n",s1);
	printf("\n s2 = [%s]\n",s2);
	sprintf(s1,s2);

	printf("\n s1 = [%s]\n",s1);
}
int test2(){
	char str1[20];
	char str2[20];
	str1[0]=0;
	str2[0]='\0';
	sprintf(str1,"20150524");
	sprintf(str2,"20140231");
	if(str1 <str2){
	  printf("\n big \n");
	  }else{
	 printf("\n small \n");
	  }
}
/* int IsMonthEnd(char *strDate)
{
	char strNextDay[9];
	char strNextMon[3],strMon[3];
	int iRet;

	memset(strMon, 0, sizeof(strMon));
	memcpy(strMon, strDate+4, 2);

	memset(strNextDay, 0, sizeof(strNextDay));
	memset(strNextMon, 0, sizeof(strNextMon));

	iRet = DayAdd(strDate, strNextDay, 1);
	if(iRet < 0)
	{
		return -1;
	}
	memcpy(strNextMon, strNextDay+4, 2);
	if(strcmp(strNextMon, strMon) == 0)
	{
		return 1;
	}else
	{
		return 0;
	}
}
int IsMonthEnd2(char *strDate)
{
	char strNextDay[9];
	int iRet;

	memset(strNextDay, 0, sizeof(strNextDay));

	iRet = DayAdd(strDate, strNextDay, 1);
	if(iRet < 0)
	{
		return -1;
	}
	if(memcmp(strDate+4, strNextDay+4, 2) == 0)
	{
		return 1;
	}else
	{
		return 0;
	}
} */
/*******************************************************************************
 * ������          : APP_PUB_DelDot
 * ��������        : ����ַ���ɾ��С����,
 * ��ڲ���        : strAmt1  �������ַ��� ��С����
 * ���ڲ���        : strAmt2  �������ַ��� ����С����
 * ����ֵ          : 0             -�ɹ�
          : -1            -ʧ��
 * �����Ա        : Anlj
 * ���ʱ��        : 2015/07/06
 * ά����¼        : ά��ʱ��    ά����Ա    ά����¼
 ===============================================================================
 ******************************************************************************/
int APP_PUB_DelDot(char *strAmt1,char *strAmt2)
{
	char str1[20];
	char *p,*q;
	q = strAmt1;
	p = strstr(strAmt1,".");
	if(p == NULL){
		strcpy(strAmt2,strAmt1);
		return 0;
	}
	memset(str1,0,sizeof(str1));

	memcpy(str1,q,p-q);
	str1[p-q]=0;

	sprintf(strAmt2,"%s",str1);
	sprintf(strAmt2+strlen(strAmt2),"%s",p+1);

	return 0;
}
/*****************************************************************
 *  �� �� ��:       APP_PUB_StrToInt
 *  ��������:       �����ַ���ת��Ϊint���ͣ������ַ���С��������������λ���֣�
 *  �� �� ��:       Anlj
 *  ��    ��:       char *aczAmt  ����ַ���
 *  			int   iAmt   ���ν��
 *  �� �� ֵ:       =0 �ɹ�
 *                  <0 ʧ��
 *  �����Զ��庯��:
 *  �����Ҫ:
 *  ȫ�ֱ���:
 *  �޸ĵ�ȫ�ֱ���:
 *  ���ʱ��:       2015/09/28
 *  ����޸�ʱ��:   2015/09/28
*****************************************************************/
int APP_PUB_StrToInt(char * aczAmt)
{
 	int iAmt;
 	char strTmp[20], strTmp2[20];
 	double dAmt,dTmpAmt;

 	memset(strTmp, 0, sizeof(strTmp));
 	memset(strTmp2, 0, sizeof(strTmp2));
 	dAmt = atof(aczAmt);
 	sprintf(strTmp,"%.2f", dAmt);

 	/*ɾ���ַ�С����*/
 	APP_PUB_DelDot(strTmp, strTmp2);

 	iAmt = atoi(strTmp2);

 	return iAmt;
}
int test19()
{
    char strTmp[10];
    memset(strTmp, 0, sizeof(strTmp));
    sprintf(strTmp,"112");
    printf("\n%-012s\n",strTmp);
    return 0;
}
int ComRevHostCont()
{

	int iRet;
	int iSum;
	char aczSum[20];
	char aczTemp[20+1];
	char aczSql[1024];
	char aczAcno[256];
	char aczDliywh[20];
	char aczDanwbh[10];
	char aczErrmsg[100];
	char aczAtomTrName[20];

	memset(aczDliywh, 0, sizeof(aczDliywh));
	memset(aczAcno, 0, sizeof(aczAcno));

	/* PGetStr2("DLIYWH", aczDliywh);
	PGetStr2("KEHUZH", aczAcno); */
	sprintf(aczDliywh,"009800013004010");
	sprintf(aczAcno, "62146001800027631212");
	memset(aczSql, 0, sizeof(aczSql));
	sprintf(aczSql,"select nvl(count(*),0) from mbcont where bsid='%s' and acno ='%s' and "
			"actflag ='A'", aczDliywh, aczAcno);
	memset(aczSum, 0, sizeof(aczSum));
	DAI_ConnTpuDb();
	iRet = GetDbStr(aczSql, aczSum);
	if(iRet < 0)
	{
	DAI_DisconnDB( NULL );
		/* TPU_SetRet("GAS101","ͳ�Ƹ��˺�ǩԼ����ʧ��"); */
		/* TRC_Trace(0,4,GASLOG,"ͳ�Ƹ��˺�ǩԼ����ʧ��[%d][%s]", iRet,  APP_PUB_GetSqlErrMsg()); */
		return -1;
	}
	DAI_DisconnDB( NULL );
	iSum = atoi(aczSum);
	printf("��ѯ����[%d]\n",iSum);
	/* if(iSum <= 1)
	{
		memset(aczAtomTrName, 0, sizeof(aczAtomTrName));
		sprintf(aczAtomTrName, "H_5972");
		iRet = FLC_RunAtTrByName("H_5972");
		if(iRet < 0)
		{
			memset(aczErrmsg, 0, sizeof(aczErrmsg));
			PGetStr("TPU_ERRMSG", aczErrmsg, -1);
			TRC_Trace(0,4,GASLOG,"���Ľ���ͻ�ǩԼЭ��ʧ��[%d][%s]", iRet, aczErrmsg);
			return iRet;
		}
	} */
	return 0;
}
/*****************************************************************
 *  �� �� ��:	    DB_Connect
 *  ��������:	    ����Զ�����ݿ�
 *  �� �� ��:	    anlj
 *  �������:	              ��
 *	�������:		��
 *  �� �� ֵ:	   	0	 �ɹ�
				!=0 	������
 *  �����Զ��庯��: ��
 *  �����Ҫ:	    ��
 *  ȫ�ֱ���:	    ��
 *  �޸ĵ�ȫ�ֱ���: ��
 *  ���ʱ��:	    2016/03/02
 *  ����޸�ʱ��:   2016/03/02
*****************************************************************/
int CZDB_Connect( char *conn )
{
	char aczTpuDb[256];   /*���ݿ������û�������ͷ����ʶ*/
	char aczUser[21];
	char aczPassword[21];
	char aczServer[21];
	char aczFileName[256];  /*������ݿ����ӵ������ļ�*/
	int iRet = 0;               /*����ֵ*/
	EXEC SQL BEGIN DECLARE SECTION;
		char aczConnectStr[256]; /*���ݿ������û�������ͷ����ʶ*/
		char aczConnName[20];
		char aczUsr[21];
		char aczPwd[21];
		char aczSrv[21];
	EXEC SQL END DECLARE SECTION;

	memset(aczConnectStr, 0, sizeof(aczConnectStr));
	memset(aczConnName, 0, sizeof(aczConnName));
	strcpy(aczConnName, conn);

	/*��ȡ���ݿ�������Ϣ*/
	memset(aczFileName, 0, sizeof(aczFileName));
	sprintf(aczFileName,"%s/etc/czgz.xml",getenv("IPPBASE"));
	iRet=XML_DGetAttribValue(aczFileName,"Common",1,"User",aczUser,20,"","/ROOT/",1);
	if (iRet<0)
	{
		return iRet;
	}
	iRet=XML_DGetAttribValue(aczFileName,"Common",1,"Pwd",aczPassword,20,"","/ROOT/",1);
	if (iRet<0)
	{
		return iRet;
	}
	iRet=XML_DGetAttribValue(aczFileName,"Common",1,"Server",aczServer,20,"","/ROOT/",1);
	if (iRet<0)
	{
		return iRet;
	}
	strcpy(aczUsr , aczUser);
	strcpy(aczPwd , aczPassword);
	strcpy(aczSrv , aczServer);
	/*�������ݿ�*/
	/*EXEC SQL connect to :aczConnectStr ;*/
	EXEC SQL CONNECT :aczUsr IDENTIFIED BY :aczPwd at :aczConnName using :aczSrv;
	return sqlca.sqlcode;
}
/*****************************************************************
 *  �� �� ��:	    CZDB_DisConnect
 *  ��������:	    �Ͽ�Զ�����ݿ�����
 *  �� �� ��:	    anlj
 *  �������:	              ��
 *	�������:		��
 *  �� �� ֵ:	   	0	 �ɹ�
				!=0 	������
 *  �����Զ��庯��: ��
 *  �����Ҫ:	    ��
 *  ȫ�ֱ���:	    ��
 *  �޸ĵ�ȫ�ֱ���: ��
 *  ���ʱ��:	    2016/03/02
 *  ����޸�ʱ��:   2016/03/02
*****************************************************************/
int CZDB_DisConnect(char *conn)
{
  EXEC SQL BEGIN DECLARE SECTION;
    char aczConnName[40];
  EXEC SQL END   DECLARE SECTION;

  memset(aczConnName, 0,sizeof(aczConnName));
  strcpy(aczConnName, conn);

  EXEC SQL at :aczConnName COMMIT RELEASE;

  return sqlca.sqlcode;
}
