#!/bin/bash

cd ~/lede

git pull

# 清除(./lede/bin/targets/x86/x64下的内容)
make clean
# 清除临时
rm -rf ./tmp

./scripts/feeds update -a
./scripts/feeds install -a

make defconfig
make download -j8

# Modify default IP
sed -i 's/192.168.1.1/192.168.1.2/g' package/base-files/files/bin/config_generate

make V=s -j$(nproc)

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