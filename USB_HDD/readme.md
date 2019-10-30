# USB_HDD Install Script
## Introduction
El script usb_hdd se modifico para crear ina particion de 100GB,se adiciono comandos sed para modificar los archivos fstab y cmdline.txt  de la imagen de Raspbian Strech.
```shell

sudo chmod +x usb_hdd
sudo  ./usb_hdd -d /dev/sda
```
