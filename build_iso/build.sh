#!/bin/sh
#准备环境：
#当前目录文件：txt.cfg、rootfs、udeb、debian-cd_info.tar.gz、initrd.gz、vmlinz、preseed.cfg、gtk
#创建ISO目录
mkdir -pv isotree/
mkdir -pv isotree/{boot,efi,isolinux,installer/gtk,.disk}
mkdir -pv isotree/efi/boot/
touch     isotree/.disk/{base_components,base_installable,cd_type,info,udeb_include}
#安装器启动文件
mkdir tmp && tar -xvpf debian-cd_info.tar.gz -C tmp
cp -av      ./{vmlinuz,initrd.gz}    isotree/installer
cp -av      ./gtk/{vmlinuz,initrd.gz}	isotree/installer/gtk
mcopy   -i tmp/grub/efi.img ::efi/boot/bootx64.efi isotree/efi/boot/bootx64.efi
mv         tmp/grub/                                   isotree/boot/
cp -av    tmp/*                                        isotree/isolinux/
cp          /usr/lib/ISOLINUX/isolinux.bin             isotree/isolinux/
cp        /usr/lib/syslinux/modules/bios/{ldlinux.c32,libcom32.c32,libutil.c32,vesamenu.c32} isotree/isolinux/
#修改启动配置文件
#cp -v txt.cfg isotree/isolinux/txt.cfg
#cp -v gtk.cfg isotree/isolinux/gtk.cfg
#
cd isotree/ && mkdir conf
cat > conf/distributions << EOF
Codename:stretch
Description: official main repository
Architectures: i386 amd64
Components: main contrib non-free
UDebComponents: main
Contents: .gz
Suite: stable
EOF
#reprepro includedeb stretch ../rootfs/var/cache/apt/archives/*.deb
reprepro includedeb stretch ../adddeb/*.deb
reprepro includeudeb stretch ../udeb/*.udeb
#md5
echo "Debian Custom" > .disk/info
#mv preseed
cp -v ../preseed.cfg ./
find . -type f | grep -v -e ^\./\.disk -e ^\./dists | xargs md5sum >> md5sum.txt
#build_iso
cd ..
xorriso -as mkisofs -r -V 'Debian Custom '\
	-J -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin\
	-J -joliet-long\
	-b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot\
	-boot-load-size 4 -boot-info-table -eltorito-alt-boot\
	-e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus isotree/\
	-o debian-custom-minimal-amd64.iso
#mv
mv -v debian-custom-minimal-amd64.iso /media/sf_debian_share/
