#!/bin/bash

#安装和更新软件包
UPDATE_PACKAGE() {
	local PKG_NAME=$1
	local PKG_REPO=$2
	local PKG_BRANCH=$3
	local PKG_SPECIAL=$4

	# 清理旧的包
	read -ra PKG_NAMES <<< "$PKG_NAME"  # 将PKG_NAME按空格分割成数组
	for NAME in "${PKG_NAMES[@]}"; do
		rm -rf $(find feeds/luci/ feeds/packages/ -maxdepth 3 -type d -iname "*$NAME*" -prune)
	done

	# 克隆仓库
	if [[ $PKG_REPO == http* ]]; then
		local REPO_NAME=$(echo $PKG_REPO | awk -F '/' '{gsub(/\.git$/, "", $NF); print $NF}')
		git clone --depth=1 --single-branch --branch $PKG_BRANCH "$PKG_REPO" package/$REPO_NAME
	else
		local REPO_NAME=$(echo $PKG_REPO | cut -d '/' -f 2)
		git clone --depth=1 --single-branch --branch $PKG_BRANCH "https://github.com/$PKG_REPO.git" package/$REPO_NAME
	fi

	# 根据 PKG_SPECIAL 处理包
	case "$PKG_SPECIAL" in
		"pkg")
			# 提取每个包
			for NAME in "${PKG_NAMES[@]}"; do
				cp -rf $(find ./package/$REPO_NAME/*/ -maxdepth 3 -type d -iname "*$NAME*" -prune) ./package/
			done
			# 删除剩余的包
			rm -rf ./package/$REPO_NAME/
			;;
		"name")
			# 重命名包
			mv -f ./package/$REPO_NAME ./package/$PKG_NAME
			;;
	esac
}

#UPDATE_PACKAGE "argon" "sbwml/luci-theme-argon" "openwrt-24.10"
#UPDATE_PACKAGE "kucat" "sirpdboy/luci-theme-kucat" "js"
#UPDATE_PACKAGE "homeproxy" "VIKINGYFY/homeproxy" "main"
#UPDATE_PACKAGE "nikki" "nikkinikki-org/OpenWrt-nikki" "main"
#UPDATE_PACKAGE "openclash" "vernesong/OpenClash" "dev" "pkg"
#UPDATE_PACKAGE "passwall" "xiaorouji/openwrt-passwall" "main" "pkg"
#UPDATE_PACKAGE "ssr-plus" "fw876/helloworld" "master"

#UPDATE_PACKAGE "luci-app-tailscale" "asvow/luci-app-tailscale" "main"

#UPDATE_PACKAGE "alist" "sbwml/luci-app-alist" "main"
#UPDATE_PACKAGE "easytier" "EasyTier/luci-app-easytier" "main"
#UPDATE_PACKAGE "gecoosac" "lwb1978/openwrt-gecoosac" "main"
#UPDATE_PACKAGE "mosdns" "sbwml/luci-app-mosdns" "v5" "" "v2dat"
#UPDATE_PACKAGE "qmodem" "FUjr/modem_feeds" "main"
#UPDATE_PACKAGE "viking" "VIKINGYFY/packages" "main" "" "luci-app-timewol luci-app-wolplus"
#UPDATE_PACKAGE "vnt" "lmq8267/luci-app-vnt" "main"

UPDATE_PACKAGE "luci-app-adguardhome" "ysuolmai/luci-app-adguardhome" "apk"
UPDATE_PACKAGE "kucat-config" "sirpdboy/luci-app-kucat-config" "main"
UPDATE_PACKAGE "advancedplus" "sirpdboy/luci-app-advancedplus" "main"
#UPDATE_PACKAGE "luci-app-poweroff" "esirplayground/luci-app-poweroff" "master"
UPDATE_PACKAGE "luci-app-ddns-go" "sirpdboy/luci-app-ddns-go" "main"

#small-package
#UPDATE_PACKAGE "xray-core xray-plugin dns2tcp dns2socks haproxy hysteria \
#        naiveproxy shadowsocks-rust v2ray-core v2ray-geodata v2ray-geoview v2ray-plugin \
#        tuic-client chinadns-ng ipt2socks tcping \
#	trojan-plus \
#	simple-obfs shadowsocksr-libev \
#	luci-app-passwall smartdns luci-app-smartdns v2dat mosdns luci-app-mosdns \
#	taskd luci-lib-xterm luci-lib-taskd vlmcsd luci-app-vlmcsd\
#	luci-theme-argon netdata luci-app-netdata  luci-app-cloudflarespeedtest \
#	lucky luci-app-lucky luci-app-openclash mihomo  luci-app-mihomo luci-app-amlogic
UPDATE_PACKAGE	"taskd luci-lib-xterm luci-lib-taskd luci-app-store quickstart luci-app-quickstart luci-app-istorex oaf open-app-filter luci-app-oaf" \
	"kenzok8/small-package" "main" "pkg"

#speedtest
#UPDATE_PACKAGE "luci-app-netspeedtest" "https://github.com/sbwml/openwrt_pkgs.git" "main" "pkg"
#UPDATE_PACKAGE "speedtest-cli" "https://github.com/sbwml/openwrt_pkgs.git" "main" "pkg"



#rm -rf $(find feeds/luci/ feeds/packages/ -maxdepth 3 -type d -iname luci-app-diskman -prune)
#rm -rf $(find feeds/luci/ feeds/packages/ -maxdepth 3 -type d -iname parted -prune)
#mkdir -p luci-app-diskman && \
#wget https://raw.githubusercontent.com/lisaac/luci-app-diskman/master/applications/luci-app-diskman/Makefile -O luci-app-diskman/Makefile
#mkdir -p parted && \
#wget https://raw.githubusercontent.com/lisaac/luci-app-diskman/master/Parted.Makefile -O parted/Makefile




#######################################
#DIY Settings
#######################################
#默认主题
#WRT_THEME: argon
#WRT_THEME="bootstrap"
 #WRT_IP="192.168.10.1"
 WRT_NAME="RanWRT"
 WRT_SSID="AX"
 WRT_THEME="kucat"
#修改默认主题
 sed -i "s/luci-theme-argon/luci-theme-$WRT_THEME/g" $(find ./feeds/luci/collections/ -type f -name "Makefile")
#修改immortalwrt.lan关联IP
 #sed -i "s/192\.168\.[0-9]*\.[0-9]*/$WRT_IP/g" $(find ./feeds/luci/modules/luci-mod-system/ -type f -name "flash.js")
#添加编译日期标识
 #sed -i "s/(\(luciversion || ''\))/(\1) + (' \/ $WRT_MARK-$WRT_DATE')/g" $(find ./feeds/luci/modules/luci-mod-status/ -type f -name "10_system.js")
 
 WIFI_SH=$(find ./target/linux/{mediatek/filogic,qualcommax}/base-files/etc/uci-defaults/ -type f -name "*set-wireless.sh" 2>/dev/null)
 WIFI_UC="./package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc"
 if [ -f "$WIFI_SH" ]; then
 	#修改WIFI名称
 	sed -i "s/BASE_SSID='.*'/BASE_SSID='$WRT_SSID'/g" $WIFI_SH
 	#修改WIFI密码
 	sed -i "s/BASE_WORD='.*'/BASE_WORD='$WRT_WORD'/g" $WIFI_SH
 elif [ -f "$WIFI_UC" ]; then
 	#修改WIFI名称
 	sed -i "s/ssid='.*'/ssid='$WRT_SSID'/g" $WIFI_UC
 	#修改WIFI密码
 	sed -i "s/key='.*'/key='$WRT_WORD'/g" $WIFI_UC
 	#修改WIFI地区
 	sed -i "s/country='.*'/country='CN'/g" $WIFI_UC
 	#修改WIFI加密
 	sed -i "s/encryption='.*'/encryption='psk2+ccmp'/g" $WIFI_UC
 fi

CFG_FILE="./package/base-files/files/bin/config_generate"

#修改默认IP地址
#sed -i "s/192\.168\.[0-9]*\.[0-9]*/$WRT_IP/g" $CFG_FILE
#修改默认主机名
sed -i "s/hostname='.*'/hostname='$WRT_NAME'/g" $CFG_FILE

#配置文件修改argon
#echo "CONFIG_PACKAGE_luci=y" >> ./.config
#echo "CONFIG_LUCI_LANG_zh_Hans=y" >> ./.config
#echo "CONFIG_PACKAGE_luci-theme-$WRT_THEME=y" >> ./.config
#echo "CONFIG_PACKAGE_luci-app-$WRT_THEME-config=y" >> ./.config
#sed -i '/CONFIG_PACKAGE_luci-light/d' ./.config
#echo "CONFIG_PACKAGE_luci-light=n" >> ./.config
echo "CONFIG_PACKAGE_luci-i18n-argon-config-zh-cn=n" >> ./.config
echo "CONFIG_PACKAGE_luci-app-argon-config=n" >> ./.config
echo "CONFIG_PACKAGE_luci-theme-argon=n" >> ./.config
echo "CONFIG_PACKAGE_luci-theme-$WRT_THEME=y" >> ./.config
#echo "CONFIG_PACKAGE_luci-app-$WRT_THEME=y" >> ./.config
echo "CONFIG_PACKAGE_luci-app-advancedplus=y" >> ./.config
#echo "CONFIG_PACKAGE_luci-app-$WRT_THEME-config=y" >> ./.config

#补齐依赖
#sudo -E apt-get -y install $(curl -fsSL https://raw.githubusercontent.com/ophub/amlogic-s9xxx-armbian/main/compile-kernel/tools/script/ubuntu2204-make-openwrt-depends)

keywords_to_delete=(
    "xiaomi_ax3600" "xiaomi_ax9000" "xiaomi_ax1800" "glinet" "mr7350"
     "uugamebooster" "luci-app-wol" "luci-i18n-wol-zh-cn" "ddns" "luci-app-advancedplus" "mihomo"
)

#[[ $WRT_CONFIG == *"NOUSB"* ]] && keywords_to_delete+=( "USB" "samba" "autosamba")
#[[ $WRT_TARGET == *"NAND"* ]] && keywords_to_delete+=("ax5-jdcloud" "jdcloud_re-ss-01" "jdcloud_re-cs-02" "nn6000")
#[[ $WRT_TARGET == *"WIFI-NO"* ]] && keywords_to_delete+=("wpad" "hostapd")
#[[ $WRT_TARGET != *"EMMC"* ]] && keywords_to_delete+=("samba" "autosamba" "disk")
#[[ $WRT_TARGET == *"EMMC"* ]] && keywords_to_delete+=("cmiot_ax18" "qihoo_v6" "qihoo_360v6" "redmi_ax5=y" "zn_m2")

for keyword in "${keywords_to_delete[@]}"; do
    sed -i "/$keyword/d" ./.config
done

#if [[ "$WRT_CONFIG" != *"EMMC"* && "$WRT_CONFIG" == *"WIFI-NO"* ]]; then
#    sed -i 's/\s*kmod-[^ ]*usb[^ ]*\s*\\\?//g' ./target/linux/qualcommax/Makefile
#    echo "已删除 Makefile 中的 USB 相关 package"
#fi

#if [[ "$WRT_CONFIG" == *"NOUSB"* ]]; then
#    sed -i 's/\s*kmod-[^ ]*usb[^ ]*\s*\\\?//g' ./target/linux/qualcommax/Makefile
#    echo "已删除 Makefile 中的 USB 相关 package"
#fi

# Configuration lines to append to .config
provided_config_lines=(
	#科学插件调整
	"CONFIG_PACKAGE_luci-app-passwall=y"
	"CONFIG_PACKAGE_luci-app-passwall_INCLUDE_SingBox=y"
	"CONFIG_PACKAGE_luci-app-passwall_INCLUDE_V2ray_Geoview=y"
	"CONFIG_PACKAGE_luci-app-nikki=y"
	#增加插件
	"CONFIG_PACKAGE_luci-app-ramfree=y"
	"CONFIG_PACKAGE_luci-app-smartdns=y"
	#"CONFIG_PACKAGE_luci-app-upnp=y"
	"CONFIG_PACKAGE_bind-dig=y"
	"CONFIG_PACKAGE_luci-app-autoreboot=y"
	#"CONFIG_PACKAGE_luci-light=n"
	#"CONFIG_PACKAGE_luci-app-argon-config=n"
 	#"CONFIG_PACKAGE_luci-i18n-argon-config-zh-cn=n"
	#"CONFIG_PACKAGE_luci-theme-argon=n"
	#"CONFIG_PACKAGE_luci-theme-kucat=y"
	#"CONFIG_PACKAGE_luci-app-kucat=y"
	#删除插件
 	#"CONFIG_PACKAGE_luci-app-argon-config=n"
 	#"CONFIG_PACKAGE_luci-i18n-argon-config-zh-cn=n"	
  	#"CONFIG_PACKAGE_luci-theme-argon=n"
	"CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Haproxy=n"
	"CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Hysteria=n"
	"CONFIG_PACKAGE_luci-app-passwall_INCLUDE_NaiveProxy=n"
	"CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Client=n"
	"CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Server=n"
 	"CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadow_TLS=n"
	"CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Simple_Obfs=n"
	"CONFIG_PACKAGE_luci-app-passwall_INCLUDE_V2ray_Plugin=n"
	"CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Xray=n"
	"CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Xray_Plugin=n"
	"CONFIG_PACKAGE_luci-app-passwall_INCLUDE_tuic_client=n"
	"CONFIG_PACKAGE_luci-app-passwall_INCLUDE_V2ray_Geodata=n"
 	"CONFIG_PACKAGE_luci-app-netspeedtest=n"
	"CONFIG_PACKAGE_luci-app-partexp=n"
	"CONFIG_PACKAGE_luci-app-homeproxy=n"
	"CONFIG_PACKAGE_luci-app-samba4=n"
	"CONFIG_PACKAGE_luci-app-wolplus=n"
	"CONFIG_PACKAGE_luci-app-gecoosac=n"
	"CONFIG_PACKAGE_luci-app-tailscale=n"
	"CONFIG_PACKAGE_luci-app-wol=n"
	"CONFIG_PACKAGE_luci-app-ddns=n"
	"CONFIG_PACKAGE_luci-app-vlmcsd=n"
	"CONFIG_PACKAGE_luci-app-xlnetacc=n"
	"CONFIG_PACKAGE_luci-app-zerotier=n"
	"CONFIG_PACKAGE_luci-app-wireguard=n"
	"CONFIG_PACKAGE_luci-app-ipsec-vpnd=n"
	"CONFIG_PACKAGE_luci-app-adbyby-plus=n"
	"CONFIG_PACKAGE_luci-app-filetransfer=n"
	"CONFIG_PACKAGE_luci-app-unblockmusic=n"
	"CONFIG_PACKAGE_luci-app-accesscontrol=n"
	"CONFIG_PACKAGE_luci-app-fileassistant=n"
 	"CONFIG_PACKAGE_htop=n"
 	"CONFIG_PACKAGE_iperf3=n"
	#内核调整
	#"CONFIG_PACKAGE_kmod-dsa=y"
	#"CONFIG_PACKAGE_kmod-fs-btrfs=y"
	#"CONFIG_PACKAGE_kmod-fuse=y"
	#"CONFIG_PACKAGE_kmod-inet-diag=y"
	#"CONFIG_PACKAGE_kmod-mtd-rw=y"
	#"CONFIG_PACKAGE_kmod-netlink-diag=y"
	#"CONFIG_PACKAGE_kmod-nft-bridge=y"
	#"CONFIG_PACKAGE_kmod-nft-core=y"
	#"CONFIG_PACKAGE_kmod-nft-fib=y"
	#"CONFIG_PACKAGE_kmod-nft-fullcone=y"
	#"CONFIG_PACKAGE_kmod-nft-nat=y"
	#"CONFIG_PACKAGE_kmod-nft-netdev=y"
	#"CONFIG_PACKAGE_kmod-nft-offload=y"
	#"CONFIG_PACKAGE_kmod-nft-queue=y"
	#"CONFIG_PACKAGE_kmod-nft-socket=y"
	#"CONFIG_PACKAGE_kmod-nft-tproxy=y"
	#"CONFIG_PACKAGE_kmod-sound-core=y"
	#"CONFIG_PACKAGE_kmod-tun=y"
	#"CONFIG_PACKAGE_kmod-usb3=y"
	#"CONFIG_PACKAGE_kmod-usb-audio=y"
	#"CONFIG_PACKAGE_kmod-usb-core=y"
	#"CONFIG_PACKAGE_kmod-usb-dwc3=y"
	#"CONFIG_PACKAGE_kmod-usb-net=y"
	#"CONFIG_PACKAGE_kmod-usb-net-cdc-eem=y"
	#"CONFIG_PACKAGE_kmod-usb-net-cdc-ether=y"
	#"CONFIG_PACKAGE_kmod-usb-net-cdc-mbim=y"
	#"CONFIG_PACKAGE_kmod-usb-net-cdc-ncm=y"
	#"CONFIG_PACKAGE_kmod-usb-net-cdc-subset=y"
	#"CONFIG_PACKAGE_kmod-usb-net-huawei-cdc-ncm=y"
	#"CONFIG_PACKAGE_kmod-usb-net-ipheth=y"
	#"CONFIG_PACKAGE_kmod-usb-net-qmi-wwan=y"
	#"CONFIG_PACKAGE_kmod-usb-net-qmi-wwan-fibocom=y"
	#"CONFIG_PACKAGE_kmod-usb-net-qmi-wwan-quectel=y"
	#"CONFIG_PACKAGE_kmod-usb-net-rndis=y"
	#"CONFIG_PACKAGE_kmod-usb-net-rtl8150=y"
	#"CONFIG_PACKAGE_kmod-usb-net-rtl8152=y"
	#"CONFIG_PACKAGE_kmod-usb-ohci=y"
	#"CONFIG_PACKAGE_kmod-usb-storage=y"
	#"CONFIG_PACKAGE_kmod-usb-storage-extras=y"
	#"CONFIG_PACKAGE_kmod-usb-storage-uas=y"
	#"CONFIG_PACKAGE_kmod-usb-uhci=y"
	#"CONFIG_PACKAGE_kmod-usb-xhci=y"
	#"CONFIG_PACKAGE_kmod-wireguard=y"
	#组件调整
	#"CONFIG_PACKAGE_autocore=y"
	#"CONFIG_PACKAGE_automount=y"
	#"CONFIG_PACKAGE_blkid=y"
	#"CONFIG_PACKAGE_cfdisk=y"
	#"CONFIG_PACKAGE_cgdisk=y"
	#"CONFIG_PACKAGE_coremark=y"
	#"CONFIG_PACKAGE_cpufreq=y"
	#"CONFIG_PACKAGE_dmesg=y"
	#"CONFIG_PACKAGE_fdisk=y"
	#"CONFIG_PACKAGE_gdisk=y"
	#"CONFIG_PACKAGE_htop=y"
	#"CONFIG_PACKAGE_iperf3=y"
	#"CONFIG_PACKAGE_ip-full=y"
	#"CONFIG_PACKAGE_libimobiledevice=y"
	#"CONFIG_PACKAGE_lsblk=y"
	#"CONFIG_PACKAGE_luci-base=y"
	#"CONFIG_PACKAGE_luci-compat=y"
	#"CONFIG_PACKAGE_luci-lib-base=y"
	#"CONFIG_PACKAGE_luci-lib-ipkg=y"
	#"CONFIG_PACKAGE_luci-lua-runtime=y"
	#"CONFIG_PACKAGE_luci-proto-bonding=y"
	#"CONFIG_PACKAGE_luci-proto-relay=y"
	#"CONFIG_PACKAGE_mmc-utils=y"
	#"CONFIG_PACKAGE_nand-utils=y"
	#"CONFIG_PACKAGE_openssh-sftp-server=y"
	#"CONFIG_PACKAGE_sfdisk=y"
	#"CONFIG_PACKAGE_sgdisk=y"
	#"CONFIG_PACKAGE_usbmuxd=y"
	#"CONFIG_PACKAGE_usbutils=y"
	)


#[[ $WRT_CONFIG == *"WIFI-NO"* ]] && provided_config_lines+=("CONFIG_PACKAGE_hostapd-common=n" "CONFIG_PACKAGE_wpad-openssl=n")
if [[ $WRT_CONFIG == *"WIFI-NO"* ]]; then
    provided_config_lines+=(
        "CONFIG_PACKAGE_hostapd-common=n"
        "CONFIG_PACKAGE_wpad-openssl=n"
    )
#else
    #provided_config_lines+=(
    #    "CONFIG_PACKAGE_kmod-usb-net=y"
    #    "CONFIG_PACKAGE_kmod-usb-net-rndis=y"
    #    "CONFIG_PACKAGE_kmod-usb-net-cdc-ether=y"
    #    "CONFIG_PACKAGE_usbutils=y"
    #)
fi

if [[ $WRT_CONFIG == *"NMODEM"* ]]; then
    provided_config_lines+=(
        "CONFIG_PACKAGE_luci-app-netdata=y"
        "CONFIG_PACKAGE_coreutils-timeout=y"
	#内核调整
	#"CONFIG_PACKAGE_kmod-dsa=y"
	#"CONFIG_PACKAGE_kmod-fs-btrfs=y"
	#"CONFIG_PACKAGE_kmod-fuse=y"
	#"CONFIG_PACKAGE_kmod-inet-diag=y"
	#"CONFIG_PACKAGE_kmod-mtd-rw=y"
	#"CONFIG_PACKAGE_kmod-netlink-diag=y"
	#"CONFIG_PACKAGE_kmod-nft-bridge=y"
	#"CONFIG_PACKAGE_kmod-nft-core=y"
	#"CONFIG_PACKAGE_kmod-nft-fib=y"
	#"CONFIG_PACKAGE_kmod-nft-fullcone=y"
	#"CONFIG_PACKAGE_kmod-nft-nat=y"
	#"CONFIG_PACKAGE_kmod-nft-netdev=y"
	#"CONFIG_PACKAGE_kmod-nft-offload=y"
	#"CONFIG_PACKAGE_kmod-nft-queue=y"
	#"CONFIG_PACKAGE_kmod-nft-socket=y"
	#"CONFIG_PACKAGE_kmod-nft-tproxy=y"
	"CONFIG_PACKAGE_kmod-sound-core=n"
	#"CONFIG_PACKAGE_kmod-tun=y"
	"CONFIG_PACKAGE_kmod-usb3=n"
	"CONFIG_PACKAGE_kmod-usb-audio=n"
	"CONFIG_PACKAGE_kmod-usb-core=n"
	"CONFIG_PACKAGE_kmod-usb-dwc3=n"
	"CONFIG_PACKAGE_kmod-usb-net=n"
	"CONFIG_PACKAGE_kmod-usb-net-cdc-eem=n"
	"CONFIG_PACKAGE_kmod-usb-net-cdc-ether=n"
	"CONFIG_PACKAGE_kmod-usb-net-cdc-mbim=n"
	"CONFIG_PACKAGE_kmod-usb-net-cdc-ncm=n"
	"CONFIG_PACKAGE_kmod-usb-net-cdc-subset=n"
	"CONFIG_PACKAGE_kmod-usb-net-huawei-cdc-ncm=n"
	"CONFIG_PACKAGE_kmod-usb-net-ipheth=n"
	"CONFIG_PACKAGE_kmod-usb-net-qmi-wwan=n"
	"CONFIG_PACKAGE_kmod-usb-net-qmi-wwan-fibocom=n"
	"CONFIG_PACKAGE_kmod-usb-net-qmi-wwan-quectel=n"
	"CONFIG_PACKAGE_kmod-usb-net-rndis=n"
	"CONFIG_PACKAGE_kmod-usb-net-rtl8150=n"
	"CONFIG_PACKAGE_kmod-usb-net-rtl8152=n"
	"CONFIG_PACKAGE_kmod-usb-ohci=n"
	"CONFIG_PACKAGE_kmod-usb-storage=n"
	"CONFIG_PACKAGE_kmod-usb-storage-extras=n"
	"CONFIG_PACKAGE_kmod-usb-storage-uas=n"
	"CONFIG_PACKAGE_kmod-usb-uhci=n"
	"CONFIG_PACKAGE_kmod-usb-xhci=n"
	#"CONFIG_PACKAGE_kmod-wireguard=y"
	#组件调整
	#"CONFIG_PACKAGE_autocore=y"
	#"CONFIG_PACKAGE_automount=y"
	#"CONFIG_PACKAGE_blkid=y"
	"CONFIG_PACKAGE_cfdisk=n"
	"CONFIG_PACKAGE_cgdisk=n"
	#"CONFIG_PACKAGE_coremark=y"
	#"CONFIG_PACKAGE_cpufreq=y"
	#"CONFIG_PACKAGE_dmesg=y"
	"CONFIG_PACKAGE_fdisk=n"
	"CONFIG_PACKAGE_gdisk=n"
	"CONFIG_PACKAGE_htop=n"
	"CONFIG_PACKAGE_iperf3=n"
	#"CONFIG_PACKAGE_ip-full=y"
	#"CONFIG_PACKAGE_libimobiledevice=y"
	#"CONFIG_PACKAGE_lsblk=y"
	#"CONFIG_PACKAGE_luci-base=y"
	#"CONFIG_PACKAGE_luci-compat=y"
	#"CONFIG_PACKAGE_luci-lib-base=y"
	#"CONFIG_PACKAGE_luci-lib-ipkg=y"
	#"CONFIG_PACKAGE_luci-lua-runtime=y"
	#"CONFIG_PACKAGE_luci-proto-bonding=y"
	#"CONFIG_PACKAGE_luci-proto-relay=y"
	#"CONFIG_PACKAGE_mmc-utils=n"
	#"CONFIG_PACKAGE_nand-utils=y"
	#"CONFIG_PACKAGE_openssh-sftp-server=y"
	"CONFIG_PACKAGE_sfdisk=n"
	"CONFIG_PACKAGE_sgdisk=n"
	"CONFIG_PACKAGE_usbmuxd=n"
	"CONFIG_PACKAGE_usbutils=n"
    )
fi

if [[ $WRT_CONFIG == *"NAND"* ]]; then
    provided_config_lines+=(
	"CONFIG_PACKAGE_htop=y"
 	"CONFIG_PACKAGE_btop=y"
 	"CONFIG_PACKAGE_iperf3=y"
  	"CONFIG_PACKAGE_luci-app-usb3disable=y"
  	"CONFIG_PACKAGE_luci-app-ttyd=y"
    	"CONFIG_PACKAGE_luci-app-oaf=y"
     	#"CONFIG_PACKAGE_taskd=y"
     	#"CONFIG_PACKAGE_luci-lib-taskd=y"
	#"CONFIG_PACKAGE_luci-lib-xterm=y"
 	#"CONFIG_PACKAGE_luci-app-store=y"
    	#"CONFIG_PACKAGE_luci-app-istorex=y"
     	"CONFIG_PACKAGE_luci-app-samba4=y"
      	#"CONFIG_PACKAGE_luci-app-vlmcsd=y"
       	"CONFIG_PACKAGE_luci-app-wol=y"
	"CONFIG_PACKAGE_luci-app-netspeedtest=y"
 	"CONFIG_PACKAGE_luci-app-mwan3=y"
  	"CONFIG_PACKAGE_luci-app-gecoosac=y"
    )
fi

if [[ $WRT_CONFIG == *"EMMC"* ]]; then
    provided_config_lines+=(
	"CONFIG_PACKAGE_htop=y"
 	"CONFIG_PACKAGE_btop=y"
 	"CONFIG_PACKAGE_iperf3=y"
  	"CONFIG_PACKAGE_luci-app-usb3disable=y"
  	"CONFIG_PACKAGE_luci-app-ttyd=y"
    	"CONFIG_PACKAGE_luci-app-oaf=y"
     	#"CONFIG_PACKAGE_taskd=y"
     	#"CONFIG_PACKAGE_luci-lib-taskd=y"
	#"CONFIG_PACKAGE_luci-lib-xterm=y"
 	#"CONFIG_PACKAGE_luci-app-store=y"
    	#"CONFIG_PACKAGE_luci-app-istorex=y"
     	"CONFIG_PACKAGE_luci-app-samba4=y"
      	#"CONFIG_PACKAGE_luci-app-vlmcsd=y"
       	"CONFIG_PACKAGE_luci-app-wol=y"
	"CONFIG_PACKAGE_luci-app-netspeedtest=n"
    )
fi
if [[ $WRT_CONFIG == *"MEDIATEK"* ]]; then
    provided_config_lines+=(
	"CONFIG_PACKAGE_luci-app-gecoosac=y"
    )
fi
#[[ $WRT_CONFIG == "IPQ"* ]] && provided_config_lines+=("CONFIG_PACKAGE_sqm-scripts-nss=y" "CONFIG_PACKAGE_luci-app-sqm=y")
#if [[ $WRT_TAG == "IPQ"* ]]; then
#    provided_config_lines+=(
#        "CONFIG_PACKAGE_sqm-scripts-nss=y"
#        "CONFIG_PACKAGE_luci-app-sqm=y"
#    )
#fi

# 添加 SQM 配置（仅限 IPQ 平台）
if [[ $WRT_CONFIG == "IPQ"* ]]; then
  #echo. "检测到 IPQ 平台，启用 SQM 配置..."
  provided_config_lines+=(
    "CONFIG_PACKAGE_sqm-scripts-nss=y"
    "CONFIG_PACKAGE_luci-app-sqm=y"
    # 依赖项
    #"CONFIG_PACKAGE_kmod-nft-core=y"
    #"CONFIG_PACKAGE_tc-full=y"
  )
else
  echo. "非 IPQ 平台，跳过 SQM 配置"
fi

# Append configuration lines to .config
for line in "${provided_config_lines[@]}"; do
    echo "$line" >> .config
done


#./scripts/feeds update -a
#./scripts/feeds install -a

#find ./ -name "cascade.css" -exec sed -i 's/#5e72e4/#6fa49a/g; s/#483d8b/#6fa49a/g' {} \;
#find ./ -name "dark.css" -exec sed -i 's/#5e72e4/#6fa49a/g; s/#483d8b/#6fa49a/g' {} \;
#install -Dm755 "${GITHUB_WORKSPACE}/Scripts/99_set_argon_primary" "package/base-files/files/etc/uci-defaults/99_set_argon_primary"

#find ./ -name "cascade.css" -exec sed -i 's/#5e72e4/#31A1A1/g; s/#483d8b/#31A1A1/g' {} \;
#find ./ -name "dark.css" -exec sed -i 's/#5e72e4/#31A1A1/g; s/#483d8b/#31A1A1/g' {} \;
#find ./ -name "cascade.less" -exec sed -i 's/#5e72e4/#31A1A1/g; s/#483d8b/#31A1A1/g' {} \;
#find ./ -name "dark.less" -exec sed -i 's/#5e72e4/#31A1A1/g; s/#483d8b/#31A1A1/g' {} \;

#修改ttyd为免密
#install -Dm755 "${GITHUB_WORKSPACE}/Scripts/99_ttyd-nopass.sh" "package/base-files/files/etc/uci-defaults/99_ttyd-nopass"

#find ./ -name "getifaddr.c" -exec sed -i 's/return 1;/return 0;/g' {} \;
#find ./ -type d -name 'luci-app-ddns-go' -exec sh -c '[ -f "$1/Makefile" ] && sed -i "/config\/ddns-go/d" "$1/Makefile"' _ {} \;
#find ./ -type d -name "luci-app-ddns-go" -exec sh -c 'f="{}/Makefile"; [ -f "$f" ] && echo "\ndefine Package/\$(PKG_NAME)/install\n\trm -f \$(1)/etc/config/ddns-go\n\t\$(call InstallDev,\$(1))\nendef\n" >> "$f"' \;
#find ./ -type d -name "ddns-go" -exec sh -c 'f="{}/Makefile"; [ -f "$f" ] && sed -i "/\$(INSTALL_BIN).*\/ddns-go.init.*\/etc\/init.d\/ddns-go/d" "$f"' \;
#rm -rf ./feeds/packages/net/ddns-go;

#fix makefile for apk
if [ -f ./package/v2ray-geodata/Makefile ]; then
    sed -i 's/VER)-\$(PKG_RELEASE)/VER)-r\$(PKG_RELEASE)/g' ./package/v2ray-geodata/Makefile
fi
if [ -f ./package/luci-lib-taskd/Makefile ]; then
    sed -i 's/>=1\.0\.3-1/>=1\.0\.3-r1/g' ./package/luci-lib-taskd/Makefile
fi
if [ -f ./package/luci-app-openclash/Makefile ]; then
    sed -i '/^PKG_VERSION:=/a PKG_RELEASE:=1' ./package/luci-app-openclash/Makefile
fi
if [ -f ./package/luci-app-quickstart/Makefile ]; then
    # 把 PKG_VERSION:=x.y.z-n 拆成 PKG_VERSION:=x.y.z 和 PKG_RELEASE:=n
    sed -i -E 's/PKG_VERSION:=([0-9]+\.[0-9]+\.[0-9]+)-([0-9]+)/PKG_VERSION:=\1\nPKG_RELEASE:=\2/' ./package/luci-app-quickstart/Makefile
fi
if [ -f ./package/luci-app-store/Makefile ]; then
    # 把 PKG_VERSION:=x.y.z-n 拆成 PKG_VERSION:=x.y.z 和 PKG_RELEASE:=n
    sed -i -E 's/PKG_VERSION:=([0-9]+\.[0-9]+\.[0-9]+)-([0-9]+)/PKG_VERSION:=\1\nPKG_RELEASE:=\2/' ./package/luci-app-store/Makefile
fi

if [ -d "package/vlmcsd" ]; then
    mkdir -p "package/vlmcsd/patches"
    cp -f "${GITHUB_WORKSPACE}/Scripts/001-fix_compile_with_ccache.patch" "package/vlmcsd/patches"
fi
