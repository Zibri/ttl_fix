#!/system/bin/sh
# Written by Zibri (Zibri @ GitHub)

MAGISKBOOT="/data/adb/magisk/magiskboot"

err() {
	echo -e "\e[94m[!] $@\e[39m"
	exit 1
}

[[ ! -f "$MAGISKBOOT" ]] && err "Failed to find magiskboot binary. Exiting."


SLOT=`getprop ro.boot.slot_suffix`
BOOT="boot$SLOT"
BOOTIMG="/dev/block/by-name/$BOOT"

mkdir -p /data/local/tmp/ttl_fix
cd /data/local/tmp/ttl_fix

dd if="$BOOTIMG" of="/data/local/tmp/ttl_fix/boot.img" conv=notrunc
$MAGISKBOOT unpack -h "/data/local/tmp/ttl_fix/boot.img"
$MAGISKBOOT hexpatch kernel C9220039C816007968F24039E8002836 1F2003D51F2003D568F24039E8002836
$MAGISKBOOT repack "/data/local/tmp/ttl_fix/boot.img" new.img
dd if=new.img of="$BOOTIMG" conv=notrunc
mv /data/local/tmp/ttl_fix/boot.img /sdcard/boot.img.backup
rm -rf /data/local/tmp/ttl_fix
