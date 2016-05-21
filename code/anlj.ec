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
	printf("本地数据库连接\n");
	iRet=DAI_ConnTpuDb();
	if(iRet < 0)
	{
		printf("本地数据库连接失败[%d][%s]\n",iRet,APP_PUB_GetSqlErrMsg());
		return -1;
	}else
	{
		printf("本地数据库连接成功\n");
	}
	iRet = DAI_DirectSQL(NULL,aczWhere2);
	if(iRet != 0)
	{
		printf("本地更新数据库失败[%d][%s]\n",iRet,APP_PUB_GetSqlErrMsg());
	}else
	{
		printf("本地数据库更新成功\n");
	}
	printf("数据库连接\n");
	iRet = CZDB_Connect("czgz");
	if(iRet < 0)
	{
		printf("数据库连接失败[%d][%s]\n",iRet,APP_PUB_GetSqlErrMsg());
		return -1;
	}else
	{
		printf("数据库连接成功\n");
	}
	iRet = DAI_DirectSQL(NULL,aczWhere2);
	if(iRet != 0)
	{
		printf("本地更新数据库失败[%d][%s]\n",iRet,APP_PUB_GetSqlErrMsg());
	}else
	{
		printf("本地数据库更新成功\n");
	}
	iRet = CZDB_DirectSQL("czgz", aczWhere);
	if(iRet != 0)
	{
		printf("更新数据库失败[%d][%s]\n",iRet,APP_PUB_GetSqlErrMsg());
	}else
	{
		printf("数据库更新成功\n");
	}


	printf("数据库断开\n");
	iRet = CZDB_DisConnect("czgz");
	if(iRet < 0)
	{
		printf("数据库断开失败\n");
		return -1;
	}else
	{
		printf("数据库断开成功\n");
	}

	iRet = CZDB_DirectSQL("czgz", aczWhere);
	if(iRet != 0)
	{
		printf("更新数据库失败[%d][%s]\n",iRet,APP_PUB_GetSqlErrMsg());
	}else
	{
		printf("数据库更新成功\n");
	}
	iRet = DAI_DirectSQL(NULL,aczWhere2);
	if(iRet != 0)
	{
		printf("本地更新数据库失败[%d][%s]\n",iRet,APP_PUB_GetSqlErrMsg());
	}else
	{
		printf("本地数据库更新成功\n");
	}
	printf("本地数据库断开\n");
	iRet = DAI_DisconnDB( NULL );
	if(iRet < 0)
	{
		printf("本地数据库断开失败\n");
		return -1;
	}else
	{
		printf("本地数据库断开成功\n");
	}

	return 0;
}


/*****************************************************************
 *  函 数 名:	    DB_Connect
 *  函数功能:	    连接远程数据库
 *  编 程 者:	    anlj
 *  输入参数:	              无
 *	输出参数:		无
 *  返 回 值:	   	0	 成功
				!=0 	错误码
 *  调用自定义函数: 无
 *  处理概要:	    无
 *  全局变量:	    无
 *  修改的全局变量: 无
 *  完成时间:	    2016/03/02
 *  最后修改时间:   2016/03/02
*****************************************************************/
int CZDB_Connect( char *conn )
{
	char aczTpuDb[256];   /*数据库连接用户名密码和服务标识*/
	char aczUser[21];
	char aczPassword[21];
	char aczServer[21];
	char aczFileName[256];  /*存放数据库连接的配置文件*/
	int iRet = 0;               /*返回值*/
	EXEC SQL BEGIN DECLARE SECTION;
		char aczConnectStr[256]; /*数据库连接用户名密码和服务标识*/
		char aczConnName[20];
		char aczUsr[21];
		char aczPwd[21];
		char aczSrv[21];
	EXEC SQL END DECLARE SECTION;

	memset(aczConnectStr, 0, sizeof(aczConnectStr));
	memset(aczConnName, 0, sizeof(aczConnName));
	strcpy(aczConnName, conn);

	/*获取数据库连接信息*/
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
	/*连接数据库*/
	/*EXEC SQL connect to :aczConnectStr ;*/
	EXEC SQL CONNECT :aczUsr IDENTIFIED BY :aczPwd at :aczConnName using :aczSrv;
	return sqlca.sqlcode;
}
/*****************************************************************
 *  函 数 名:	    CZDB_DisConnect
 *  函数功能:	    断开远程数据库连接
 *  编 程 者:	    anlj
 *  输入参数:	              无
 *	输出参数:		无
 *  返 回 值:	   	0	 成功
				!=0 	错误码
 *  调用自定义函数: 无
 *  处理概要:	    无
 *  全局变量:	    无
 *  修改的全局变量: 无
 *  完成时间:	    2016/03/02
 *  最后修改时间:   2016/03/02
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
 *  函 数 名:	    CZDB_DirectSQL
 *  函数功能:	    在财政数据执行sql语句
 *  编 程 者:	    anlj
 *  输入参数:	char * conn,  数据连接名称
 *  		char * sql    sql语句
 *	输出参数:		无
 *  返 回 值:	   	0	 成功
				!=0 	错误码
 *  调用自定义函数: 无
 *  处理概要:	    无
 *  全局变量:	    无
 *  修改的全局变量: 无
 *  完成时间:	    2016/03/02
 *  最后修改时间:   2016/03/02
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
 *  函 数 名:	    CZDB_BeginTrans
 *  函数功能:	    开始事务
 *  编 程 者:	    anlj
 *  输入参数:	char * conn,  数据连接名称
 *	输出参数:		无
 *  返 回 值:	   	0	 成功
				!=0 	错误码
 *  调用自定义函数: 无
 *  处理概要:	    无
 *  全局变量:	    无
 *  修改的全局变量: 无
 *  完成时间:	    2016/03/02
 *  最后修改时间:   2016/03/02
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
 *  函 数 名:	    CZDB_EndTrans
 *  函数功能:	    结束事务
 *  编 程 者:	    anlj
 *  输入参数:	char * conn,  数据连接名称
 *  		int flag    提交回滚事务标志  0-提交事务  1-回滚事务
 *	输出参数:		无
 *  返 回 值:	   	0	 成功
				!=0 	错误码
 *  调用自定义函数: 无
 *  处理概要:	    无
 *  全局变量:	    无
 *  修改的全局变量: 无
 *  完成时间:	    2016/03/02
 *  最后修改时间:   2016/03/02
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
 *  函 数 名:	    CZDB_RollbackTran
 *  函数功能:	    回滚
 *  编 程 者:	    anlj
 *  输入参数:	char * conn,  数据连接名称
 *	输出参数:		无
 *  返 回 值:	   	0	 成功
				!=0 	错误码
 *  调用自定义函数: 无
 *  处理概要:	    无
 *  全局变量:	    无
 *  修改的全局变量: 无
 *  完成时间:	    2016/03/02
 *  最后修改时间:   2016/03/02
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
 *  函 数 名:	    CZDB_CommitTran
 *  函数功能:	    提交
 *  编 程 者:	    anlj
 *  输入参数:	char * conn,  数据连接名称
 *	输出参数:		无
 *  返 回 值:	   	0	 成功
				!=0 	错误码
 *  调用自定义函数: 无
 *  处理概要:	    无
 *  全局变量:	    无
 *  修改的全局变量: 无
 *  完成时间:	    2016/03/02
 *  最后修改时间:   2016/03/02
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
 *  函 数 名:	 CZDB_GetSeqSalFeedback
 *  函数功能:	    获取序列S_BANK_FEEDBACK值
 *  编 程 者:	    anlj
 *  输入参数:	char * conn,  数据连接名称
 *	输出参数:	int *iSeq    S_BANK_FEEDBACK序列值
 *  返 回 值:	   	0	 成功
				!=0 	错误码
 *  调用自定义函数: 无
 *  处理概要:	    无
 *  全局变量:	    无
 *  修改的全局变量: 无
 *  完成时间:	    2016/03/02
 *  最后修改时间:   2016/03/02
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
 *  函 数 名:	 CZDB_GetSeqSumSalFeedback
 *  函数功能:	    获取序列S_BANK_SUM_FEEDBACK值
 *  编 程 者:	    anlj
 *  输入参数:	char * conn,  数据连接名称
 *	输出参数:	int *iSeq    S_BANK_SUM_FEEDBACK序列值
 *  返 回 值:	   	0	 成功
				!=0 	错误码
 *  调用自定义函数: 无
 *  处理概要:	    无
 *  全局变量:	    无
 *  修改的全局变量: 无
 *  完成时间:	    2016/03/02
 *  最后修改时间:   2016/03/02
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
 *  函 数 名:	 CZDB_GetSeqSumPafFeedback
 *  函数功能:	    获取序列S_PAF_SUM_FEEDBACK值
 *  编 程 者:	    anlj
 *  输入参数:	char * conn,  数据连接名称
 *	输出参数:	int *iSeq    S_PAF_SUM_FEEDBACK序列值
 *  返 回 值:	   	0	 成功
				!=0 	错误码
 *  调用自定义函数: 无
 *  处理概要:	    无
 *  全局变量:	    无
 *  修改的全局变量: 无
 *  完成时间:	    2016/03/02
 *  最后修改时间:   2016/03/02
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
