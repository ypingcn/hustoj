echo " ------ "
echo "程序暂且支持 Debian 、　Ubuntu 及其他基于前者的发行版（例如 deepin、mint）"
echo " ------ "
echo "请确认程序已经用管理员权限( sudo )启动"
echo " ------ "

apt-get install python-dev build-essential -y
apt-get install python-pip
pip install isso  -i https://pypi.tuna.tsinghua.edu.cn/simple virtualenv
apt-get install sqlite3
mkdir -p /var/lib/isso
groupadd isso
useradd isso
chown isso:isso /var/lib/isso -R

echo "修改 /home/judge/src/web/issue-isso.conf /home/judge/src/web/issue.html 的配置以确保正确显示， isso 程序启动也要管理员权限以保证正确读写"
echo "服务器部署请自行配置 nginx 和 supervisor "
echo "启动命令：sudo isso -c /home/judge/src/web/issue-isso.conf run"
