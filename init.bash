#!/bin/bash

echo -n '#' "Your Project Name : "
read project_name

echo '#!/bin/bash

# 需要导出的程序环境变量
export PJ_ROOT=`pwd`
export PJ_NAME="'$project_name'"


# 以下配置可使用默认配置即可 
# --------------------START-------------------
# 设定GO编译环境
export GOLIBS="$(dirname "$PJ_ROOT")/golibs" # 可作为公共库时使用
export GOPATH=$GOLIBS:$PJ_ROOT
export GOBIN=$PJ_ROOT/bin

# 更改路径可更改编译器的版本号, 如果未指定，使用系统默认的配置
go_root="/usr/local/go"
if [ -d "$go_root" ]; then
    export GOROOT="$go_root"
fi

bin_path=$GOBIN:$GOROOT/bin
if [[ ! $PATH =~ $bin_path ]]; then
	export PATH=$bin_path:$PATH
fi
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
# 设定sup [command] all 的目录
export SUP_BUILD_PATH="$PJ_ROOT/src/app $PJ_ROOT/src/web"
# -------------------------------------------------

# 设定publish指令打包时需要包含的文件夹
# 默认会打包：$PJ_ROOT/bin $PJ_ROOT/src/app/app等二进制程序
export PUB_ROOT_RES="" # 根目录下的文件夹列表，如"etc res"等
export PUB_APP_RES="public" # app下的文件夹列表，如"etc public"等


# 构建项目目录
mkdir -p $PJ_ROOT/src
mkdir -p $PJ_ROOT/log

# 下载自定义goget管理工具
if [ ! -f $PJ_ROOT/bin/sup ]; then
	sup_path="gopkg.in/ot24net/sup.v3"
	go get -u -v $sup_path
    go install $sup_path/goget
    # TODO: code sup by golang
	cp -rf $GOLIBS/src/$sup_path/sup $PJ_ROOT/bin
fi

# 设定git库地址转换, 以便解决私有库中https证书不可信的问题
# git config --global url."git@git.ot24.net:".insteadOf "https://git.ot24.net"
# 用于快速跳转文件变量
# export github=$GOLIBS/src/github.com

echo "Env have changed to \"$PJ_NAME\""
echo "Using \"sup help\" to manage project"
# --------------------END--------------------
'>env.bash

echo '#' "Init Done"
echo '#'
echo '#' "You should edit env.bash when used, some command need special environment."
echo '#' "'SUP_BUILD_PATH' environment for 'sup build all' in env.bash "
echo '#' "'SUP_APP_ENV' environment for 'sup install' in env.bash "
echo '#' "'PUB_ROOT_RES' environment for 'sup publish' in env.bash "
echo '#' "'PUB_APP_RES' environment for 'sup publish' in env.bash "
echo '#'
echo '#' "Using 'source env.bash' to loading environment of project"

# This example shows how to prompt for user's input.
echo -n '#' "Clean template data?[Y/n]"
read ANS
case $ANS in
    Y)
        rm init.bash
        rm -rf .git
	rm -rf src
        exit 0
        ;;
esac

