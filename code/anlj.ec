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
extern int g_OraInTran;
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
	char s1[30];
	printf("s11   =    [%s]\n",s1);
	testS();
	char sq[20];
	printf("s12   =   [%s]\n",s1);
	printf("s21   =    [%s]\n",sq);

	return 0;
}
int testS()
{
	char s1[20];
	char s2[3][3];
	char s3[30];
	memset(s3, 0, sizeof(s3));
	memset(s1, 0, sizeof(s1));

	sprintf(s2,"112323112311313213332");
	printf("s1= [%s]\n",s1);
	printf("s2[0]= [%s]\n",s2[0]);
	printf("s2[1]= [%s]\n",s2[1]);
	printf("s2[2]= [%s]\n",s2[2]);
	printf("s3= [%s]\n",s3);
	return 0;
}
int testDb2()
{
	int iRet = 0;
	char aczWhere[256];
	char aczWhere2[256];
	memset(aczWhere, 0, sizeof(aczWhere));
	sprintf(aczWhere, "update ptstca set userid='test' where sid='222' ");
	memset(aczWhere2, 0, sizeof(aczWhere2));
	sprintf(aczWhere2, "update ptstca set userid='tedb' where sid='222' ");
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
	iRet = DAI_DirectSQL(NULL,aczWhere2);
	if(iRet != 0)
	{
		printf("���ظ������ݿ�ʧ��[%d][%s]\n",iRet,APP_PUB_GetSqlErrMsg());
	}else
	{
		printf("�������ݿ���³ɹ�\n");
	}
	printf("���ݿ�����\n");
	iRet = CZDB_Connect("czgz");
	if(iRet < 0)
	{
		printf("���ݿ�����ʧ��[%d][%s]\n",iRet,APP_PUB_GetSqlErrMsg());
		return -1;
	}else
	{
		printf("���ݿ����ӳɹ�\n");
	}
	iRet = DAI_DirectSQL(NULL,aczWhere2);
	if(iRet != 0)
	{
		printf("���ظ������ݿ�ʧ��[%d][%s]\n",iRet,APP_PUB_GetSqlErrMsg());
	}else
	{
		printf("�������ݿ���³ɹ�\n");
	}
	iRet = CZDB_DirectSQL("czgz", aczWhere);
	if(iRet != 0)
	{
		printf("�������ݿ�ʧ��[%d][%s]\n",iRet,APP_PUB_GetSqlErrMsg());
	}else
	{
		printf("���ݿ���³ɹ�\n");
	}


	printf("���ݿ�Ͽ�\n");
	iRet = CZDB_DisConnect("czgz");
	if(iRet < 0)
	{
		printf("���ݿ�Ͽ�ʧ��\n");
		return -1;
	}else
	{
		printf("���ݿ�Ͽ��ɹ�\n");
	}

	iRet = CZDB_DirectSQL("czgz", aczWhere);
	if(iRet != 0)
	{
		printf("�������ݿ�ʧ��[%d][%s]\n",iRet,APP_PUB_GetSqlErrMsg());
	}else
	{
		printf("���ݿ���³ɹ�\n");
	}
	iRet = DAI_DirectSQL(NULL,aczWhere2);
	if(iRet != 0)
	{
		printf("���ظ������ݿ�ʧ��[%d][%s]\n",iRet,APP_PUB_GetSqlErrMsg());
	}else
	{
		printf("�������ݿ���³ɹ�\n");
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
/*****************************************************************
 *  �� �� ��:	    CZDB_DirectSQL
 *  ��������:	    �ڲ�������ִ��sql���
 *  �� �� ��:	    anlj
 *  �������:	char * conn,  ������������
 *  		char * sql    sql���
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
int CZDB_DirectSQL(char * conn, char * sql)
{
	int  iRet;
	EXEC SQL BEGIN DECLARE SECTION;
		char aczSqlBuf[10240];
		char aczConnName[20];
	EXEC SQL END   DECLARE SECTION;

	memset(aczSqlBuf, 0, sizeof(aczSqlBuf));
	memset(aczConnName, 0, sizeof(aczConnName));
	strcpy(aczSqlBuf, sql);
	strcpy(aczConnName, conn);
	EXEC SQL at :aczConnName PREPARE a FROM :aczSqlBuf;
	EXEC SQL at :aczConnName EXECUTE a;
	iRet = sqlca.sqlcode;
	/*EXEC SQL at :aczConnName free a;*/

	/*EXEC SQL at :aczConnName COMMIT;*/
	return iRet;
}
/*****************************************************************
 *  �� �� ��:	    CZDB_BeginTrans
 *  ��������:	    ��ʼ����
 *  �� �� ��:	    anlj
 *  �������:	char * conn,  ������������
 *	�������:		��
 *  �� �� ֵ:	   	0	 �ɹ�
				!=0 	������
 *  �����Զ��庯��: ��
 *  �����Ҫ:	    ��
 *  ȫ�ֱ���:	    ��
 *  �޸ĵ�ȫ�ֱ���: ��
 *  ���ʱ��:	    2016/03/02
 *  ����޸�ʱ��:   2016/03/02
****************************************************************/
/*int CZDB_BeginTrans(char * conn)
{
	EXEC SQL BEGIN DECLARE SECTION;
		char aczConnName[20];
	EXEC SQL END   DECLARE SECTION;

	memset(aczConnName, 0, sizeof(aczConnName));
	strcpy(aczConnName, conn);

    EXEC SQL at :aczConnName BEGIN WORK;

    return sqlca.sqlcode;
}*/
/****************************************************************
 *  �� �� ��:	    CZDB_EndTrans
 *  ��������:	    ��������
 *  �� �� ��:	    anlj
 *  �������:	char * conn,  ������������
 *  		int flag    �ύ�ع������־  0-�ύ����  1-�ع�����
 *	�������:		��
 *  �� �� ֵ:	   	0	 �ɹ�
				!=0 	������
 *  �����Զ��庯��: ��
 *  �����Ҫ:	    ��
 *  ȫ�ֱ���:	    ��
 *  �޸ĵ�ȫ�ֱ���: ��
 *  ���ʱ��:	    2016/03/02
 *  ����޸�ʱ��:   2016/03/02
****************************************************************/
/*int CZDB_EndTrans(char * conn, int flag)
{
	EXEC SQL BEGIN DECLARE SECTION;
		char aczConnName[20];
	EXEC SQL END   DECLARE SECTION;

	memset(aczConnName, 0, sizeof(aczConnName));
	strcpy(aczConnName, conn);
	if (flag != 0) {
		EXEC SQL at :aczConnName ROLLBACK WORK;
	}else
	{
		EXEC SQL  at :aczConnName COMMIT WORK;
	}

	return sqlca.sqlcode;
}*/

/*****************************************************************
 *  �� �� ��:	    CZDB_RollbackTran
 *  ��������:	    �ع�
 *  �� �� ��:	    anlj
 *  �������:	char * conn,  ������������
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
int int CZDB_RollbackTran(char *conn)
{
	EXEC SQL BEGIN DECLARE SECTION;
		char aczConnName[20];
	EXEC SQL END   DECLARE SECTION;
	strcpy(aczConnName, conn);

	g_OraInTran = 0;
	EXEC SQL at :aczConnName ROLLBACK WORK;
	return sqlca.sqlcode;
}
/*****************************************************************
 *  �� �� ��:	    CZDB_CommitTran
 *  ��������:	    �ύ
 *  �� �� ��:	    anlj
 *  �������:	char * conn,  ������������
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
int CZDB_CommitTran(char *conn)
{
	EXEC SQL BEGIN DECLARE SECTION;
		char aczConnName[20];
	EXEC SQL END   DECLARE SECTION;
	strcpy(aczConnName, conn);
	g_OraInTran = 0;
	EXEC SQL at :aczConnName COMMIT WORK;
	return sqlca.sqlcode;
}

/*****************************************************************
 *  �� �� ��:	 CZDB_GetSeqSalFeedback
 *  ��������:	    ��ȡ����S_BANK_FEEDBACKֵ
 *  �� �� ��:	    anlj
 *  �������:	char * conn,  ������������
 *	�������:	int *iSeq    S_BANK_FEEDBACK����ֵ
 *  �� �� ֵ:	   	0	 �ɹ�
				!=0 	������
 *  �����Զ��庯��: ��
 *  �����Ҫ:	    ��
 *  ȫ�ֱ���:	    ��
 *  �޸ĵ�ȫ�ֱ���: ��
 *  ���ʱ��:	    2016/03/02
 *  ����޸�ʱ��:   2016/03/02
*****************************************************************/
int CZDB_GetSeqSalFeedback(char *conn, int *iSeq)
{

	EXEC SQL BEGIN DECLARE SECTION;
		char aczConnName[20];
		int iSequence;
	EXEC SQL END   DECLARE SECTION;
	strcpy(aczConnName, conn);

	EXEC SQL at :aczConnName select S_BANK_FEEDBACK.Nextval into :iSequence from dual;
	*iSeq = iSequence;

	return sqlca.sqlcode;
}

/*****************************************************************
 *  �� �� ��:	 CZDB_GetSeqSumSalFeedback
 *  ��������:	    ��ȡ����S_BANK_SUM_FEEDBACKֵ
 *  �� �� ��:	    anlj
 *  �������:	char * conn,  ������������
 *	�������:	int *iSeq    S_BANK_SUM_FEEDBACK����ֵ
 *  �� �� ֵ:	   	0	 �ɹ�
				!=0 	������
 *  �����Զ��庯��: ��
 *  �����Ҫ:	    ��
 *  ȫ�ֱ���:	    ��
 *  �޸ĵ�ȫ�ֱ���: ��
 *  ���ʱ��:	    2016/03/02
 *  ����޸�ʱ��:   2016/03/02
*****************************************************************/
int CZDB_GetSeqSumSalFeedback(char *conn, int *iSeq)
{

	EXEC SQL BEGIN DECLARE SECTION;
		char aczConnName[20];
		int iSequence;
	EXEC SQL END   DECLARE SECTION;
	strcpy(aczConnName, conn);

	EXEC SQL at :aczConnName select S_BANK_SUM_FEEDBACK.Nextval into :iSequence from dual;
	*iSeq = iSequence;

	return sqlca.sqlcode;
}
/*****************************************************************
 *  �� �� ��:	 CZDB_GetSeqSumPafFeedback
 *  ��������:	    ��ȡ����S_PAF_SUM_FEEDBACKֵ
 *  �� �� ��:	    anlj
 *  �������:	char * conn,  ������������
 *	�������:	int *iSeq    S_PAF_SUM_FEEDBACK����ֵ
 *  �� �� ֵ:	   	0	 �ɹ�
				!=0 	������
 *  �����Զ��庯��: ��
 *  �����Ҫ:	    ��
 *  ȫ�ֱ���:	    ��
 *  �޸ĵ�ȫ�ֱ���: ��
 *  ���ʱ��:	    2016/03/02
 *  ����޸�ʱ��:   2016/03/02
*****************************************************************/
int CZDB_GetSeqSumPafFeedback(char *conn, int *iSeq)
{

	EXEC SQL BEGIN DECLARE SECTION;
		char aczConnName[20];
		int iSequence;
	EXEC SQL END   DECLARE SECTION;
	strcpy(aczConnName, conn);

	EXEC SQL at :aczConnName select S_PAF_SUM_FEEDBACK.Nextval into :iSequence from dual;
	*iSeq = iSequence;

	return sqlca.sqlcode;
}
