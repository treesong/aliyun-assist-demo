## [编译机]
## 下载源代码
if [ ! -d "/root/source/gs-rest-service" ]; then
    mkdir -p /root/source && cd /root/source
    git clone git@github.com:treesong/gs-rest-service.git
fi;

## 拉取新代码
echo "> cd /root/source/gs-rest-service/complete"
cd /root/source/gs-rest-service/complete
echo "> git pull ..."
git pull
printf "_____\n\n"

## 编译代码
export PATH=/root/apache-maven/bin/:$PATH
echo "> mvn clean package -Dmaven.test.skip=true"
mvn clean package -Dmaven.test.skip=true
printf "_____\n\n"

## 分发代码
if [ ! -z "{{vm-ip-list}}" ]; then
  for ip in {{vm-ip-list}}; do
    echo "> scp *.jar to $ip ..."
    scp ./target/rest-service-0.0.1-SNAPSHOT.jar root@$ip:/root/webapp/
  done;
  echo "copy files done."
else
  echo "copy files skip."
fi;