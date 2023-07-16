#!/bin/bash

# 提示用户选择
echo "请选择要运行的程序:"
echo "0. Linux-构建django+NestJs"
echo "1. Linux-构建django"
echo "2. Linux-构建NodeJs"
echo "3. 拉取最新代码并重启docker"
echo "4. Linux-设置ZeroTier局域网络"
echo "5. 生成RSA文件"
echo "6. ubuntu & N1 安装宝塔面板"
echo "7. 玩客云armbian安装宝塔面板"
echo "8. PIP换源"
echo "9. NPM换源"
echo "10. 安装docker"
echo "11. 系统升级和软件升级"
echo "12. 安装JS"
echo "13. docker换源"
echo "14. 清除docker缓存"

# 读取用户输入
read -p "请输入选项: " choice

# 根据用户选择执行对应的命令

if [[ $choice == "0" ]]; then
  sudo docker-compose up --build -d
elif [[ $choice == "1" ]]; then
  sudo docker-compose -f django.yml up --build -d
elif [[ $choice == "2" ]]; then
  sudo docker-compose -f nodejs.yml up --build -d
elif [[ $choice == "3" ]]; then
  git pull
  sudo docker-compose -f django.yml down
  sleep(20)
  echo "docker down successfully"
  sudo docker-compose -f django.yml up --detach --force-recreate
  echo "Docker已成功重启！"
elif [[ $choice == "4" ]]; then
  curl -s https://install.zerotier.com | sudo bash
  sudo zerotier-cli start
  sudo zerotier-cli join c7c8172af1ee1026
  sudo systemctl enable zerotier-one.service
elif [[ $choice == "5" ]]; then
  ssh-keygen -t rsa
  cat ~/.ssh/id_rsa.pub
elif [[ $choice == "6" ]]; then
  wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && sudo bash install.sh
elif [[ $choice == "7" ]]; then
  wget -O install.sh http://download.bt.cn/install/install-ubuntu.sh && bash install.sh
elif [[ $choice == "8" ]]; then
  pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
elif [[ $choice == "9" ]]; then
  npm config set registry http://mirrors.cloud.tencent.com/npm/
elif [[ $choice == "10" ]]; then
  sudo apt-get install docker.io
  sudo systemctl start docker
  sudo systemctl enable docker
  docker --version
  sudo apt-get install docker-compose
  docker-compose --version
elif [[ $choice == "11" ]]; then
  sudo apt update
  sudo apt upgrade
  sudo apt dist-upgrade
elif [[ $choice == "12" ]]; then
  sudo apt install nodejs
  sudo apt install npm
elif [[ $choice == "13" ]]; then

  # 定义要添加的镜像地址
  mirror_urls=(
    "https://hub-mirror.c.163.com"
    "https://ustc-edu-cn.mirror.aliyuncs.com"
    "https://ghcr.io"
    "https://mirror.baidubce.com"
  )

  # 检查 daemon.json 文件是否存在，如果不存在则创建
  if [ ! -f "/etc/docker/daemon.json" ]; then
    sudo touch /etc/docker/daemon.json
  fi

  # 备份原始 daemon.json 文件
  sudo cp /etc/docker/daemon.json /etc/docker/daemon.json.bak

  # 创建一个新的 daemon.json 文件
  sudo bash -c 'echo "{" > /etc/docker/daemon.json'

  # 添加镜像源到 daemon.json 文件
  for url in "${mirror_urls[@]}"
  do
    sudo bash -c "echo '  \"registry-mirrors\": [\"$url\"],' >> /etc/docker/daemon.json"
  done

  # 关闭最后一个镜像源的逗号
  sudo sed -i '$ s/.$//' /etc/docker/daemon.json

  # 添加 daemon.json 文件的结尾
  sudo bash -c 'echo "}" >> /etc/docker/daemon.json'

  # 重启 Docker 服务
  sudo service docker restart

  echo "Docker 镜像源已成功更新！"
elif [[ $choice == "14" ]]; then
  sudo docker builder prune
else
  echo "无效的选项"
fi
