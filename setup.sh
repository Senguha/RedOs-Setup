 
tar -xzf 1c-paks.tar.gz

dnf install 1c-enterprise-8.3.23.1782-server-8.3.23-1782.x86_64.rpm 1c-enterprise-8.3.23.1782-common-8.3.23-1782.x86_64.rpm 1c-enterprise-8.3.23.1782-client-8.3.23-1782.x86_64.rpm

dnf install msttcore-fonts-installer

mv /opt/1cv8/common/libstdc++.so.6 /opt/1cv8/common/libstdc++.so.6.old
ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /opt/1cv8/common/libstdc++.so.6
mv /opt/1cv8/x86_64/8.3.23.1782/libstdc++.so.6 /opt/1cv8/x86_64/8.3.23.1782/libstdc++.so.6.old
ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /opt/1cv8/x86_64/8.3.23.1782/libstdc++.so.6


