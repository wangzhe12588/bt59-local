#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_US.UTF-8

#fonts color
Green_font="\033[32m" 
Red_font="\033[31m" 
Green_background="\033[42;37m" 
Red_background="\033[41;37m"  
Font="\033[0m"

Info="${Green_font}[信息]${Font}"
Error="${Red_font}[错误]${Font}"
Tip="${Green_font}[注意]${Font}"

vp=$1
m=`cat /www/server/panel/class/common.py|grep checkSafe`
if [ "${vp}" == "free" ]; then
	vp=""
	Ver="免费版"
elif [ "${vp}" == "pro" ] || [ "${m}" != "" ] ;then
	vp="_pro"
	Ver="专业版"
elif [ -f /www/server/panel/plugin/beta/config.conf ]; then
	updateApi=https://www.bt.cn/Api/updateLinuxBeta
	vp=""
	Ver="内测版"
fi


public_file=/www/server/panel/install/public.sh
if [ ! -f $public_file ];then
	wget -O $public_file http://download.bt.cn/install/public.sh -T 5;
fi
. $public_file

download_Url=$NODE_URL
setup_path=/www
version=''


pcreRpm=`rpm -qa |grep bt-pcre`
if [ "${pcreRpm}" != "" ];then
	rpm -e bt-pcre
	yum reinstall pcre pcre-devel -y
fi

if [ "$version" = '' ];then
	if [ "${updateApi}" == "" ];then
		updateApi=https://www.bt.cn/Api/updateLinux
	fi
	if [ -f /usr/local/curl/bin/curl ]; then
		version=`/usr/local/curl/bin/curl $updateApi 2>/dev/null|grep -Po '"version":".*?"'|grep -Po '[0-9\.]+'`
	else
		version=`curl $updateApi 2>/dev/null|grep -Po '"version":".*?"'|grep -Po '[0-9\.]+'`
	fi	
	
fi

if [ "$version" = '' ];then
	version=`cat /www/server/panel/class/common.py|grep "\.version"|awk '{print $3}'|sed 's/"//g'|sed 's/;//g'`
	version=${version:0:-1}
fi

if [ "$version" = '' ];then
	echo '版本号获取失败,请手动在第一个参数传入!';
	exit;
fi

newVersion=${version:0:1}
if [ "$newVersion" != "5" ];then
	echo "脚本目前仅仅支持5.X系列，请安装宝塔5.X再试"
	exit;
fi

wget -T 5 -O panel.zip $download_Url/install/update/LinuxPanel-${version}${vp}.zip
if [ ! -f "panel.zip" ];then
	echo "获取更新包失败，请稍后更新或联系宝塔运维"
	exit;
fi
unzip -o panel.zip -d $setup_path/server/ > /dev/null
rm -f panel.zip
cd $setup_path/server/panel/
rm -f $setup_path/server/panel/data/templates.pl
check_bt=`cat /etc/init.d/bt`
if [ "${check_bt}" = "" ];then
	rm -f /etc/init.d/bt
	wget -O /etc/init.d/bt $download_Url/install/src/bt.init -T 10
	chmod +x /etc/init.d/bt
fi
if [ ! -f "/etc/init.d/bt" ]; then
	wget -O /etc/init.d/bt $download_Url/install/src/bt.init -T 10
	chmod +x /etc/init.d/bt
fi

sed -i 's/panelAuth.panelAuth().get_order_status(None)/{"status":True,"msg":{"endtime" : 32503651199 }}/' /www/server/panel/class/common.py
echo > /www/server/panel/data/userInfo.json

cd /www/server/panel
python tools.py o

sleep 1 && service bt restart > /dev/null 2>&1 &

echo -e "
# ====================================================
#   ${Green_font} 已成功升级到[$version]${Ver} ${Font}
#   ${Green_font} 作者：Eleven ${Font}
#   ${Green_font} 网站：https://letcloud.cn ${Font}
# ====================================================
"






