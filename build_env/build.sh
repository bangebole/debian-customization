#!/bin/sh
#用于修改好udeb包后，重新编译生成debian-installer环境文件
mv -v localechooser_2.69_amd64.udeb /home/0909/debian-installer-20170615+deb9u4//build/localudebs/
cd /home/0909/debian-installer-20170615+deb9u4/build/
make reallyclean 
make build_cdrom_isolinux
cd dest/cdrom/
cp -v initrd.gz /home/build_iso/
cp -v gtk/initrd.gz /home/build_iso/gtk
cd /home/build_iso/
