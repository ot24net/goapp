#!/bin/bash

echo -n '#' "Your Project Name : "
read PJNAME

echo '#!/bin/bash
PWDDIR=`pwd`
export sup_mode="src"
export PJROOT=$PWDDIR
export GOLIBS="$(dirname "$PJROOT")/golibs"

# 手工需要设定以下变量
# -------------------------------------------------
# 具体项目需要手工更改此名称
export PJNAME="'$PJNAME'"

# 配置库目录的环境变更，以便可以直接使用简短的环境变更打开
export github=$GOLIBS/src/github.com/ # 快速跳转github.com库使用

# 设定全编译或打包时的目录,用于sup [command] all 时的寻找路径
# 例如：sup build all, sup install all, sup restart all等
# 请配置实际项目中的路径
export BUILDPATH="$PJROOT/src/app $PJROOT/src/web"
# -------------------------------------------------

# 设定git库地址转换, 以便解决部分包的库存在https的相关问题
# git config --global url."git@git.ot24.net:".insteadOf "https://git.ot24.net"

# 设定编译环境
# 更改路径可更改编译器的版本号, 如果未指定，使用系统默认的配置
goroot="/usr/local/go"
if [ -d "$goroot" ]; then
    export GOROOT="$goroot"
fi

# 设定库目录
export GOPATH=$GOLIBS:$PJROOT
export GOBIN=$PJROOT/bin

# 构建项目目录
mkdir -p $PJROOT/src
mkdir -p $PJROOT/log

# bin
export PATH=$GOLIBS/src/github.com/ot24net/sup.v1:$GOBIN:$GOROOT/bin:/bin:/sbin:/usr/sbin:/usr/bin:/usr/local/bin

# 下载默认依赖库
if [ "$sup_mode" = "src" ]; then
    go get -v -insecure github.com/ot24net/sup.v1
fi

echo "Env have changed to \"$PJNAME\""
echo "Using \"sup help\" to manage project"
'>env.bash

echo '#' "Init Done"
echo '#' "You can edit 'BUILDPATH' environment for 'sup build all' in env.bash "
echo '#' "And using 'source env.bash' to change environment of project"

# This example shows how to prompt for user's input.
echo -n '#' "Clean template data?[Y/N]"
read ANS
case $ANS in
    Y)
        rm init.bash
        rm -rf .git
        exit 0
        ;;
esac

