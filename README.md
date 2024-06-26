# Установка ПО при помощи системы удалённого управления Ansible
Данный проект устанаваливает на удалённую рабочую станцию **RedOS** клиент 1С-преприятие и антивирусную программу Kaspersky Endpoint Security.
> Протестировано на версии [redos-8-20240218.1](https://files.red-soft.ru/redos/8.0/x86_64/iso/redos-8-20240218.1-Everything-x86_64-DVD1.iso)

## Инструкция по установке 

### Установка зависимостей

  1. Скачайте и установите Ansible на сервер с которого будет происходить удалённое управление
     
      **Ubuntu**
       ```
       $ sudo apt update
       $ sudo apt install software-properties-common
       $ sudo add-apt-repository --yes --update ppa:ansible/ansible
       $ sudo apt install ansible
       ```
      **Debian**
       
       Хоть Ansible и доступен из [основного репозитория Debian](https://packages.debian.org/stable/ansible), он может быть устаревшим.
       Чтобы получить более свежую версию, пользователи Debian могут использовать Ubuntu PPA в соответствии со следующей таблицей:

        | Debian | Ubuntu | UBUNTU_CODENAME |
        | Debian 12 (Bookworm) | Ubuntu 22.04 (Jammy) | ``jammy`` |
        | Debian 11 (Bullseye) | Ubuntu 20.04 (Focal) | ``focal`` |
        | Debian 10 (Buster) | Ubuntu 18.04 (Bionic) | ``bionic`` |

       В следующем примере мы предполагаем, что у вас уже установлены wget и gpg (sudo apt install wget gpg).
       Выполните следующие команды, чтобы добавить репозиторий и установить Ansible. Установите UBUNTU_CODENAME=... в соответствии с таблицей выше (в данном примере мы используем jammy).
       
       ```
       $ UBUNTU_CODENAME=jammy
       $ wget -O- "https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=0x6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367" | sudo gpg --dearmour -o /usr/share/keyrings/ansible-archive-keyring.gpg
       $ echo "deb [signed-by=/usr/share/keyrings/ansible-archive-keyring.gpg] http://ppa.launchpad.net/ansible/ansible/ubuntu $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/ansible.list
       $ sudo apt update && sudo apt install ansible
       ```
       
      **Fedora Linux**
       
       ```
       $ sudo dnf install ansible
       ```
       
  2. Склонируйте репозиторий в удобную для вас директорию
     
     ```
     $ git clone https://github.com/Senguha/RedOs-Setup.git
     ```
     
  3. Внесите в файл ``RedOs-Setup/Ansible script/inventory.ini`` адреса всех удалённых рабочих станций на которые необходимо установить ПО.
     
     ```
     [myhosts]
     192.168.0.101
     192.168.0.102
     hostname.one
     hostname.two
     ```
     
  4. Убедитесь что на сервере настроено удалённое подключение ко всем рабочим станциям из файла ``inventory.ini`` при помощи ssh ключей.
     
      Сгенерируйте ssh ключ на всех удалённых станциях
       
       ```
       $ su
       $ ssh-keygen 
       ```
       
      Скопируйте публичный ключ каждой станции на сервер. Для этого для каждой удалённой машины выполните следующие команды на сервере.
       
     ```
       ssh-copy-id root@hostname
     ```
     
      Проверьте копирование ssh ключа на сервер, подключившись к станции удалённо.
     ```
       ssh root@hostname
     ```
     
     Если при входе вас не спросили пароль, то ключи установлены верно

### Запуск сценария Ansible

Для инициализации playbook'а Ansible и развёртывании ПО на удалённых станциях запустите скрипт ``RedOs-Setup/Ansible script/run.sh``

```
$ bash ./Ansible script/run.sh
```

### Дополнительно

**Первоначальная установка KES**

Для конфигурации первоначальной настройки Kaspersky Endpoint Security измените файл автоустановки ``RedOs-Setup/Bash script/autoinstall.ini`` в соответствии с [оффициальной документацией](https://support.kaspersky.ru/kes-for-linux/11.3.0/236945) 

**Оффлайн установка**

При отсутствии подключения к сети интернет на удалённых машинах, для установки ПО необходимо поместить все необходимые rpm пакеты в директорию ``RedOs-Setup/Bash script/paks``. При этом способе установки около **780 мб** данных будет передано на удалённые станции через ssh подключение.

Установка с передачей пакетов на удалённые машины так же доступна и при наличии подключения к сети интернет на удалённой станции. В этом варианте при неполном наборе пакетов в папке `paks`, архив в необходимыми пакетами будет скачан с файлового сервера как при онлайн установке. 

**Архивы пакетов:**

[Оффлайн установка](http://178.208.92.119:81/script/paks-offline.tar.gz)

[Онлайн установка](http://178.208.92.119:81/script/paks.tar.gz)
  



       
       
