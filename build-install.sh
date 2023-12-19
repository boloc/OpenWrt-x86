#!/bin/bash

cd ~
##############依赖安装 START##########################
# PS:如果已经装过依赖的就不用执行此步骤了
sudo apt update -y
sudo apt full-upgrade -y
sudo apt install -y ack antlr3 asciidoc autoconf automake autopoint binutils bison build-essential \
    bzip2 ccache cmake cpio curl device-tree-compiler fastjar flex gawk gettext gcc-multilib g++-multilib \
    git gperf haveged help2man intltool libc6-dev-i386 libelf-dev libfuse-dev libglib2.0-dev libgmp3-dev \
    libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev libncursesw5-dev libpython3-dev libreadline-dev \
    libssl-dev libtool lrzsz mkisofs msmtp ninja-build p7zip p7zip-full patch pkgconf python2.7 python3 \
    python3-pyelftools python3-setuptools qemu-utils rsync scons squashfs-tools subversion swig texinfo \
    uglifyjs upx-ucl unzip vim wget xmlto xxd zlib1g-dev
#################依赖安装 END#########################


git clone https://github.com/coolsnowwolf/lede
cd lede

sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default

git pull
./scripts/feeds update -a
./scripts/feeds install -a

# 已经配置好.config，就不重新设置config了
# make menuconfig

make download -j8

# Modify default IP
sed -i 's/192.168.1.1/192.168.1.2/g' package/base-files/files/bin/config_generate

make V=s -j1

# 将rootfs传至CT模板
# # 检查 sshpass 是否已经安装
# if ! command -v sshpass &> /dev/null; then
#     echo "sshpass 未安装，开始安装..."
#     sudo apt update
#     sudo apt install sshpass
# else
#     echo "sshpass 已经安装，跳过安装步骤."
# fi
# # 执行上传至PVE的容器中（/home/containers/template/cache为我CT模板存放路径）
# password=$1
# sshpass -p $password scp ./bin/targets/x86/64/openwrt-x86-64-generic-rootfs.tar.gz root@192.168.1.10:/home/containers/template/cache

# 执行方法:
# ./build-install.sh <password>