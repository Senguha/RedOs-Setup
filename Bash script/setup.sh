
#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: this script must be run as root or via sudo" >&2
    exit 1
fi

cd /root/Bash\ script

$iStatus
paksFolder="`ls | grep -x 'paks'`"



if nc -zw1 google.com 443; then
     iStatus="True"
fi

if [[ -z "$iStatus" && -n "$paksFolder" ]]; then
paksList="`ls ./paks`"
paksCheckOffline="`echo $paksList | grep '1c-paks.tar.gz' | grep 'cprocsp-paks.tar.gz' | grep 'cabextract-1.9.1-3.red80.x86_64.rpm' | grep 'enchant-1.6.0-29.red80.x86_64.rpm'| grep 'kesl-11.3.0-7441.x86_64.rpm'| grep 'kesl-gui-11.3.0-7441.x86_64.rpm'| grep 'msttcore-fonts-installer-2.6-3.noarch.rpm'| grep 'perl-File-Copy-2.39-494.red80.noarch.rpm'| grep 'perl-Getopt-Long-2.52-494.red80.noarch.rpm'| grep 'xorg-x11-font-utils-7.5-53.red80.x86_64.rpm'`"
paksCheckOnline="`echo $paksList | grep '1c-paks.tar.gz' | grep 'cprocsp-paks.tar.gz' | grep 'kesl-11.3.0-7441.x86_64.rpm'| grep 'kesl-gui-11.3.0-7441.x86_64.rpm'`"
fi

echo 'Скрипт по установке ПО на RedOs'

if [[ -z "$iStatus" && -z "$paksFolder" ]]; then
    echo "Установка ПО невозможна. Отсутвует интернет подключение и папка paks с пакетами программ" >&2
    exit 1
fi

if [[ -z "$paksCheckOffline" && -z "$iStatus" ]]; then
    echo "Установка ПО невозможна. Отсутвует интернет подключение и папка paks содержит не все пакеты" >&2
    exit 1
fi

if [[ -z "$paksFolder" || -z "$paksCheckOnline" ]]; then
    if [[ -z "$paksCheckOnline" ]]; then
        echo "Папка paks содержит не все пакеты. Удаление папки для дальнейшей скачки с файлового сервера"
        rm -rf ./paks/
    fi
    echo "Скачивание архива с пакетами"
    curl http://178.208.92.119:81/script/paks.tar.gz -o paks.tar.gz
    tar -xzf paks.tar.gz
fi

cd paks

tar -xzf 1c-paks.tar.gz

echo "Установка клиента 1C"

if [[ -z "$iStatus" ]]; 
then
    dnf install cabextract-1.9.1-3.red80.x86_64.rpm xorg-x11-font-utils-7.5-53.red80.x86_64.rpm enchant-1.6.0-29.red80.x86_64.rpm msttcore-fonts-installer-2.6-3.noarch.rpm  -y
else
    dnf install msttcore-fonts-installer libxcrypt-compat msttcore-fonts-installer -y
fi

cd 1c-paks

chmod +x setup-full-8.3.23.2040-x86_64.run

./setup-full-8.3.23.2040-x86_64.run --mode unattended --disable-components client_full --enable-components server,ws,server_admin,config_storage_server,liberica_jre


cd ..

mv /opt/1cv8/common/libstdc++.so.6 /opt/1cv8/common/libstdc++.so.6.old
 ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /opt/1cv8/common/libstdc++.so.6
 mv /opt/1cv8/x86_64/8.3.23.2040/libstdc++.so.6 /opt/1cv8/x86_64/8.3.23.2040/libstdc++.so.6.old
 ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /opt/1cv8/x86_64/8.3.23.2040/libstdc++.so.6

systemctl link /opt/1cv8/x86_64/8.3.23.2040/srv1cv8-8.3.23.2040@.service
systemctl enable srv1cv8-8.3.23.2040@default.service --now

echo "Установка R7-офис"

if [[ -n "$iStatus" ]]; then
    dnf install r7-release -y && dnf install r7-office -y && dnf install r7organizer -y && dnf install R7Grafika -y
else
    dnf install r7-release-1.0-1.red80.noarch.rpm r7-office-2024.3.1-487.el8.x86_64.rpm r7organizer-2.0.1-1.x86_64.rpm  R7Grafika-x86_64-1.8.221111227.rpm -y
fi


echo "Установка Kaspersky Endpoint Security"

if [[ -z "$iStatus" ]]; 
then
    dnf install kesl-11.3.0-7441.x86_64.rpm perl-Getopt-Long-2.52-494.red80.noarch.rpm perl-File-Copy-2.39-494.red80.noarch.rpm -y
else
    dnf install kesl-11.3.0-7441.x86_64.rpm perl-Getopt-Long perl-File-Copy -y
fi

if [[ -n "$iStatus" ]]; then
    /opt/kaspersky/kesl/bin/kesl-setup.pl --autoinstall=/root/Bash\ script/autoinstall.ini
fi

dnf install kesl-gui-11.3.0-7441.x86_64.rpm -y

echo "Установка КриптоПРО"

tar -xzf cprocsp-paks.tar.gz

cd cprocsp-paks

dnf install lsb-cprocsp-base-5.0.12000-6.noarch.rpm lsb-cprocsp-rdr-64-5.0.12000-6.x86_64.rpm lsb-cprocsp-kc1-64-5.0.12000-6.x86_64.rpm lsb-cprocsp-capilite-64-5.0.12000-6.x86_64.rpm -y

dnf install cprocsp-curl-64-5.0.12000-6.x86_64.rpm lsb-cprocsp-ca-certs-5.0.12000-6.noarch.rpm cprocsp-rdr-gui-gtk-64-5.0.12000-6.x86_64.rpm cprocsp-rdr-pcsc-64-5.0.12000-6.x86_64.rpm cprocsp-rdr-emv-64-5.0.12000-6.x86_64.rpm cprocsp-rdr-inpaspot-64-5.0.12000-6.x86_64.rpm cprocsp-rdr-kst-64-5.0.12000-6.x86_64.rpm cprocsp-rdr-mskey-64-5.0.12000-6.x86_64.rpm cprocsp-rdr-novacard-64-5.0.12000-6.x86_64.rpm cprocsp-rdr-edoc-64-5.0.12000-6.x86_64.rpm cprocsp-rdr-rutoken-64-5.0.12000-6.x86_64.rpm cprocsp-rdr-cloud-64-5.0.12000-6.x86_64.rpm cprocsp-rdr-cpfkc-64-5.0.12000-6.x86_64.rpm cprocsp-rdr-infocrypt-64-5.0.12000-6.x86_64.rpm cprocsp-rdr-rosan-64-5.0.12000-6.x86_64.rpm cprocsp-rdr-cryptoki-64-5.0.12000-6.x86_64.rpm cprocsp-cptools-gtk-64-5.0.12000-6.x86_64.rpm lsb-cprocsp-pkcs11-64-5.0.12000-6.x86_64.rpm lsb-cprocsp-import-ca-certs-5.0.12000-6.noarch.rpm -y

cd /opt/cprocsp/lib/amd64

libapi10="`ls | grep libcapi10 | tail -1`"
libapi20="`ls | grep libcapi20 | tail -1`"

gcc -shared -Wl,-soname,$libapi10,$libapi10 -o libcapilite.so

