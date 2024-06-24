
#!/bin/bash

echo 'Скрипт по установке ПО на RedOs'

#paks_folder="`(ls | grep 'paks')`"

#if [[ -z "$paks_folder" ]];
#then
#    mkdir paks
#fi

cd paks

#name="`ls | grep '1c-paks'`"

#one="`(dnf list installed | grep '^1c')`"

#if [[ -n "$one" ]];
#then
#    echo "Установлены следующие пакеты:"
#    echo ""
#    echo "$one"
#fi


#if [[ -n "$name" ]];
#then
#    echo "Найден архив $name в директории программы"
#else
#    echo 'Скачивание пакетов 1С'
#    echo ""
#    curl http://178.208.92.119:81/script/1c-paks.tar.gz -o 1c-paks.tar.gz
#fi

tar -xzf 1c-paks.tar.gz

echo "Установка клиента 1C"

sudo dnf install enchant-1.6.0-29.red80.x86_64.rpm msttcore-fonts-installer-2.6-3.noarch.rpm -y

cd 1c-paks

sudo dnf install 1c-enterprise-8.3.23.1782-common-8.3.23-1782.x86_64.rpm 1c-enterprise-8.3.23.1782-server-8.3.23-1782.x86_64.rpm  1c-enterprise-8.3.23.1782-client-8.3.23-1782.x86_64.rpm -y

cd ..

mv /opt/1cv8/common/libstdc++.so.6 /opt/1cv8/common/libstdc++.so.6.old
ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /opt/1cv8/common/libstdc++.so.6
mv /opt/1cv8/x86_64/8.3.23.1782/libstdc++.so.6 /opt/1cv8/x86_64/8.3.23.1782/libstdc++.so.6.old
ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /opt/1cv8/x86_64/8.3.23.1782/libstdc++.so.6



echo "Установка Kaspersky Endpoint Security"

#curl https://products.s.kaspersky-labs.com/endpoints/keslinux10/11.3.0.7441/multilanguage-11.3.0.7441/3635353133317c44454c7c31/kesl-11.3.0-7441.x86_64.rpm -o kesl-11.3.0-7441.x86_64.rpm

sudo dnf install kesl-11.3.0-7441.x86_64.rpm perl-Getopt-Long-2.52-494.red80.noarch.rpm perl-File-Copy-2.39-494.red80.noarch.rpm -y

/opt/kaspersky/kesl/bin/kesl-setup.pl --autoinstall=kesl.ini





