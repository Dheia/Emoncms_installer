# Emoncms-Scripts
**usb_hdd**: script modificado para crear una particion en el disco duro de 100GB de tamaño para luego mover la particion localizada en la microsd al disco duro, finalmente modifica el boot para el arranque desde el HDD.

**backup**: scripts de importación y exportación de backups, se modifico para mostrar barra de pogreso del proceso de exportación de datos,ademas de los archivos phpfina, phpseries, base de datos Maria, se incluye los archivos de NodeRed y el archivo de configuración del Emonhub y Emoncms. Adicionalmente se modifico para que los daemon  mqtt_input se encuentre detenido durante menor tiempo (mientras se comprime los archivos phpfina y phpseries).

**picofssd**: script del daemon de upspico modificado para enviar datos del estado del raspberry al emoncms a traves de HTTP método GET.
