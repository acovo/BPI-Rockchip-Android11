Afptool -pack .\backupimage backupimage\backup.img ./package-file-rk356x
Afptool -pack ./ Image\update.img ./package-file-rk356x


RKImageMaker.exe -RK3568 Image\MiniLoaderAll.bin  Image\update.img update.img -os_type:androidos

rem update.img is new format, Image\update.img is old format, so delete older format
del  Image\update.img

pause 
