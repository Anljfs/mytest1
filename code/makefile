########################
#水费对账动态库编译专用#
########################

include $(IPPBASE)/ippsrc/bin/shell/make.ora
#include $(IPPBASE)/bin/shell/makeinc
#include $(IPPBASE)/bin/shell/make.pub

# 本项目的所有模块
PROJECT = anlj

# 全部流程
all: $(PROJECT) install clean
	@echo ""
	@echo $(CLINE) " Making anlj Component End " $(CLINE)
	@echo ""

# 编译单元
anlj: anlj.o
	@echo ""
	@echo ""
	@echo ' ==== Now Start to Rebuild (anlj) ==== '
	@echo ""
	@echo ""
#	$(CC)  $(SHARED) -o a.out $(CFLAGS) $(LLFLAGS) $(USEDLL) $? \
#cc -o anlj -brtl anlj.o -lapppub
	$(CC)  -o anlj $(CFLAGS) $(LLFLAGS) $(USEDLL) anlj.o \
	  -lapppub -ltpurun -lmftp \
	-ltpu -lark -lxml -lcurses -ltcp -lutil   -lshm -llog -ldai \
    -lmesg -livytools -lcop -lscript -ldb -lld -lm  -lapptab  -lappmid -lcmpapi
	@echo ""
	@echo ""
	@echo ' ==== Rebuild (anlj) successfully ==== '
	@echo ""
anlj.o: anlj.ec
	#proc config=/ippzh/env/pcscfg.cfg anlj.ec
	#cc -D__MAIN__ -o anlj.o -c anlj.c
	$(PRECOMP) $(DBPFLAG) anlj.ec;
	$(CC) $(CFLAGS) -D__MAIN__ -o anlj.o -c anlj.c
	-rm anlj.c	
# 安装
install:
	

# 清理
clean:
	rm -rf *.o
