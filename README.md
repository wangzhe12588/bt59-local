# bt59-local
btpanel 5.9 install from local
debian-ubuntu

本地化一键安装脚本：
wget -N --no-check-certificate -O install.sh https://github.com/wangzhe12588/bt59-local/raw/master/install/install-ubuntu.sh && bash install.sh

一键开心脚本 ：

wget -N --no-check-certificate https://github.com/wangzhe12588/bt59-local/raw/master/install/bt_Creak.sh && chmod 755 bt_Creak.sh && bash bt_Creak.sh

该脚本仅仅是将原来的panel文件夹重命名为panel.bak  ，再下载授权的panel文件，如果需要切回原版，仅需要将文件夹pane.bak恢复即可。panel的路径是/www/server/panel

执行完开心脚本之后，需要重新设置下宝塔后台密码

cd /www/server/panel && python tools.pyc panel passwd

passwd就是你准备设置的密码 。执行完显示的字符是当前宝塔的用户名，登陆宝塔面板之后在后台修改即可
