os_release_path="/etc/os-release"
openwrt_release_path="/etc/openwrt_release"
SHELL_FOLDER=$(dirname $(readlink -f "$0"))
if [ -f "$os_release_path" ];then
	source /etc/os-release
else
	if [ -f "$openwrt_release_path" ];then
		ID="openwrt"
	fi
fi
	
if [[ $ID != "openwrt" ]];then
	read -r -p "Mismatch Operation System Detected, Are you sure to install? [Y/n] " response
	if [[ $response != "y" && $response != "Y" ]];then
		exit 0
	fi
fi

echo "Auto install start ..."
wget --no-check-certificate https://raw.githubusercontent.com/how1ewu/OPRebootWinNoNet/main/oprebootnonet.sh && chmod +x oprebootnonet.sh
croncmd="sh ${SHELL_FOLDER}"/oprebootnonet.sh""
cronjob="*/1 * * * * $croncmd"
( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -

sed -i "2a ${croncmd}" /etc/rc.local

echo "Auto Install Finished. Enjoy."
rm -- "$0"
