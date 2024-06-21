
#!/bin/bash

echo 'Скрипт по установке ПО на RedOs'

name="`ls | grep '1c-paks'`"

one="`(dnf list installed | grep '^1c')`"

if [[ -n "$one" ]];
then
    echo "Установлены следующие пакеты:"
    echo "$one"
    echo ""
fi


if [[ -n "$name" ]];
then
    echo "Найден архив $name в директории программы"
else
    echo 'Введите ссылку на скачку архива в пакетами установки 1С'1c-paks.tar.gz
    read archiveUrl
    curl $archiveUrl -o 1c-paks.tar.gz
fi
    #curl http://178.208.92.119:81/script/1c-paks.tar.gz -o 
tar -xzf 1c-paks.tar.gz

echo "Установка клиента 1C"

cd 1c-paks
sudo dnf install 1c-enterprise-8.3.23.1782-common-8.3.23-1782.x86_64.rpm 1c-enterprise-8.3.23.1782-server-8.3.23-1782.x86_64.rpm  1c-enterprise-8.3.23.1782-client-8.3.23-1782.x86_64.rpm -y

sudo dnf install msttcore-fonts-installer

mv /opt/1cv8/common/libstdc++.so.6 /opt/1cv8/common/libstdc++.so.6.old
ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /opt/1cv8/common/libstdc++.so.6
mv /opt/1cv8/x86_64/8.3.23.1782/libstdc++.so.6 /opt/1cv8/x86_64/8.3.23.1782/libstdc++.so.6.old
ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /opt/1cv8/x86_64/8.3.23.1782/libstdc++.so.6


