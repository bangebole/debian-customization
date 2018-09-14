###此文件夹内容为:建立生成ISO环境文件夹。
##根据官方源提供的debian-installer源码,初步编译可以得到编译debian-installer需要的udeb包，保留udeb包到localudebs文件夹，清空其余产生的编译文件，重新编译.注意!这时要在sources.list.udeb文件中注释掉从官方获取文件编译，这样就只从localudebs文件夹中获取文件，我们就可以修改源码重新生成udeb包然后再放到localudebs文件夹，满足定制要求
#源代码中build文件夹中编译：
make reallyclean	#清理编译
fakeroot make build_cdrom_isolinux	#编译
#修改build/config/common文件
USE_UDEBS_FROM ?= unstable  ---→  USE_UDEBS_FROM ?= stretch	#stretch为对应版本代号，这样在编译的过程，会自动根据本地的sources.list文件生成sources.list.udeb文件
##编译完成后会在build/dest/cdrom/ 文件夹中会得到：debian-cd_info.tar.gz gtk/ initrd.gz vmlinuz。这些是我们编译ISO需要的文件。
#debian-cd_info.tar.gz:debian-installer的基本配置文件和启动引导文件（安装器安装选项、背景，安装器启动操作文件，preseed文件配置路径等都可以在这里解压修改，然后重新打包）
#initrd.gz:临时文件系统（修改localechooser、netcfg源码包生成的udeb包就是用于编译到这个临时的文件系统中）
#vmlinuz:用于光盘安装的kernel文件
#gtk:图形安装相关文件夹
##准备好这些，就准备好了生成ISO的基本环境文件。此外，还需要基本包。
#基本包理解需要两个部分（主要问题是处理包依赖的问题）：
１．deb包：用于安装系统的包，这个是真正操作系统的包（包括基本系统包，和其他应用程序包）。基本系统包可以通过debootstrap工具生成最小系统，主要是获取生成最小系统的依赖包。其他应用程序包可以在先安装最小系统后，通过apt方式安装程序，在/var/cacahe/apt/archives/目录下会有安装程序过程的包。再将所有过程的包整合在一起。
２．udeb包：用于debian-installer运行的包（这部分的包可以从源站下载）

