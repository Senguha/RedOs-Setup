
#!/bin/bash

cd /root/Bash\ script

$iStatus
paksFolder="`ls | grep -x 'paks'`"



if nc -zw1 google.com 443; then
     iStatus="True"
fi

if [[ -z "$iStatus" && -n "$paksFolder" ]]; then
paksList="`ls ./paks`"
paksCheckOffline="`echo $paksList | grep '1c-paks.tar.gz' | grep 'cabextract-1.9.1-3.red80.x86_64.rpm' | grep 'enchant-1.6.0-29.red80.x86_64.rpm'| grep 'kesl-11.3.0-7441.x86_64.rpm'| grep 'kesl-gui-11.3.0-7441.x86_64.rpm'| grep 'msttcore-fonts-installer-2.6-3.noarch.rpm'| grep 'perl-File-Copy-2.39-494.red80.noarch.rpm'| grep 'perl-Getopt-Long-2.52-494.red80.noarch.rpm'| grep 'xorg-x11-font-utils-7.5-53.red80.x86_64.rpm'`"
paksCheckOnline="`echo $paksList | grep '1c-paks.tar.gz' | grep 'kesl-11.3.0-7441.x86_64.rpm'| grep 'kesl-gui-11.3.0-7441.x86_64.rpm'`"
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
    dnf install cabextract-1.9.1-3.red80.x86_64.rpm xorg-x11-font-utils-7.5-53.red80.x86_64.rpm enchant-1.6.0-29.red80.x86_64.rpm msttcore-fonts-installer-2.6-3.noarch.rpm -y
else
    dnf install msttcore-fonts-installer -y
fi

cd 1c-paks

dnf install 1c-enterprise-8.3.23.1782-common-8.3.23-1782.x86_64.rpm 1c-enterprise-8.3.23.1782-server-8.3.23-1782.x86_64.rpm 1c-enterprise-8.3.23.1782-client-8.3.23-1782.x86_64.rpm -y

cd ..

mv /opt/1cv8/common/libstdc++.so.6 /opt/1cv8/common/libstdc++.so.6.old
ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /opt/1cv8/common/libstdc++.so.6
mv /opt/1cv8/x86_64/8.3.23.1782/libstdc++.so.6 /opt/1cv8/x86_64/8.3.23.1782/libstdc++.so.6.old
ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /opt/1cv8/x86_64/8.3.23.1782/libstdc++.so.6



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



