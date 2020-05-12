#!/bin/bash
set -euo pipefail
logo_print(){
        cat << "EOF"

    ███╗   ███╗██╗███╗   ██╗██████╗     ██╗  ██╗ ██████╗ ███████╗████████╗██╗███╗   ██╗ ██████╗
    ████╗ ████║██║████╗  ██║██╔══██╗    ██║  ██║██╔═══██╗██╔════╝╚══██╔══╝██║████╗  ██║██╔════╝
    ██╔████╔██║██║██╔██╗ ██║██║  ██║    ███████║██║   ██║███████╗   ██║   ██║██╔██╗ ██║██║  ███╗
    ██║╚██╔╝██║██║██║╚██╗██║██║  ██║    ██╔══██║██║   ██║╚════██║   ██║   ██║██║╚██╗██║██║   ██║
    ██║ ╚═╝ ██║██║██║ ╚████║██████╔╝    ██║  ██║╚██████╔╝███████║   ██║   ██║██║ ╚████║╚██████╔╝
    ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═════╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝
                                                                                         PHP 7.3
    APACHE PHP CONTAINER (R) MAI2020 V0.1
    FOR MIND HOSTING
    https://mind.hosting
    by SAKLY Ayoub
    saklyayoub@gmail.com

EOF
}
apache_set_servername(){
	echo "ServerName "$VIRTUAL_HOST >> /etc/apache2/apache2.conf
}

if [[ "$1" == apache2* ]]; then
	echo " "
	echo " "
	logo_print
	echo " "
	echo " "
	apache_set_servername
	echo " "
	echo " "
	echo "**** WORDPRESS CONTAINER STARED SUCCESSFULY ****"
	echo "Notice: You website URL https://$VIRTUAL_HOST/"
	echo "Notice: PhpMyAdmin is available under https://$VIRTUAL_HOST/phpmyadmin"
	echo "Notice: Filemanager is available under https://$VIRTUAL_HOST/filemanage"
	echo "Notice: below there will be the instant apache access and error log"
	echo " "
	echo " "
fi
exec "$@"
