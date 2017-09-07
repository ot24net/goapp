#!/bin/bash

# 需要导出的程序环境变量
export PJ_NAME="goapp"
export PJ_ROOT=`pwd`
# -------------------------------------------------

# 设定全编译或打包时的目录,用于sup [command] all 时的寻找路径
# 例如：sup build all, sup install all, sup restart all等
# 请配置实际项目中的路径
export BUILDPATH="$PJ_ROOT/src/app $PJ_ROOT/src/web"
# -------------------------------------------------

# 设定GO编译环境
# 更改路径可更改编译器的版本号, 如果未指定，使用系统默认的配置
goroot="/usr/local/go"
if [ -d "$goroot" ]; then
    export GOROOT="$goroot"
fi
export GOLIBS="$(dirname "$PJ_ROOT")/golibs"
export GOPATH=$GOLIBS:$PJ_ROOT
export GOBIN=$PJ_ROOT/bin
export PATH=$GOBIN:$GOROOT/bin:/bin:/sbin:/usr/sbin:/usr/bin:/usr/local/bin:$PATH
# -------------------------------------------------

# 设定SUP发布环境
# 以下是部署时的supervisor默认配置数据，若未配置时，会使用以下默认数据
# 开发IDE可不配置以下环境变量
# 配置supervisor的配置文件目录
export SUP_ETC_DIR="/etc/supervisor/conf.d/"
# 配置supervisor的子程序日志的单个文件最大大小
export SUP_LOG_SIZE="10MB"
# 配置supervisor的子程序日志的最多文件个数
export SUP_LOG_BAK="10"
# 配置supervisor配置中的environment环境变量
export SUP_APP_ENV="PJ_ROOT=\\\"$PJ_ROOT\\\",GIN_MODE=\\\"release\\\",LD_LIBRARY_PATH=\\\"$LD_LIBRARY_PATH\\\""
# -------------------------------------------------

# 构建项目目录
mkdir -p $PJ_ROOT/src
mkdir -p $PJ_ROOT/log
mkdir -p $PJ_ROOT/etc
mkdir -p $PJ_ROOT/res

# 下载默认依赖库
if [ ! -f $PJ_ROOT/bin/sup ]; then
	mkdir -p $PJ_ROOT/bin
	sup_path="gopkg.in/ot24net/sup.v2"
	go get -u -v -insecure $sup_path
	cp -rf $GOLIBS/src/$sup_path/sup $PJ_ROOT/bin
fi

# 设定git库地址转换, 以便解决私有库中https证书不可信的问题
# git config --global url."git@git.ot24.net:".insteadOf "https://git.ot24.net"

echo "Env have changed to \"$PJ_NAME\""
echo "Using \"sup help\" to manage project"

