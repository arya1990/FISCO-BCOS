#
#         一键安装脚本说明
#1 build.sh在centos和Ubuntu版本测试成功；
#2 所有Linux发行版本请确保yum和git已安装，并能正常使用；
#3 如遇到中途依赖库下载失败，一般和网络状况有关，请到https://github.com/bcosorg/lib找到相应的库，手动安装成功后，再执行此脚本
#

#!/bin/sh
set -e

#install package
sudo yum -y install cmake3
sudo yum install -y openssl openssl-devel

#install nodejs 
sudo yum install -y nodejs 
sudo npm install -g cnpm --registry=https://registry.npm.taobao.org
sudo cnpm install -g babel-cli babel-preset-es2017
echo '{ "presets": ["es2017"] }' > ~/.babelrc  

#install deps
chmod +x scripts/install_deps.sh
./scripts/install_deps.sh

#install fisco-solc
sudo cp fisco-solc  /usr/bin/fisco-solc
sudo chmod +x /usr/bin/fisco-solc

#install console
sudo cnpm install -g ethereum-console

#build bcos
mkdir -p build
cd build/
if grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
cmake -DEVMJIT=OFF -DTESTS=OFF -DMINIUPNPC=OFF .. 
else
cmake3 -DEVMJIT=OFF -DTESTS=OFF -DMINIUPNPC=OFF .. 
fi

make

make install

cd ..
cd ./tool
cnpm install

cd ..
cd ./systemcontractv2
cnpm install

if [ ! -f "/usr/local/bin/fisco-bcos" ]; then
	echo 'fisco-bcos build fail!'
	else
	echo 'fisco-bcos build succ! path: /usr/local/bin/fisco-bcos'
 fi
