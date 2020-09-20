## 阿里云-云助手使用演示
## [应用服务器]
## 安装 JRE/JDK

java -version
if [ $? = 127 ]; then
    echo "install jdk ..."
    yum install -y java-1.8.0-openjdk-devel
    echo "install jdk done"
    java -version
fi;
printf "_____\n\n"

## 停止 WebApp
pid=$(jps -l | grep jar | cut -d' ' -f 1)
if [[ $pid =~ ^[0-9]+$ ]]; then
   jps -l | grep jar 
   echo "stop java process $pid ..."
   kill -9 $pid
fi;

pid=$(jps -l | grep rest | cut -d' ' -f 1)
if [[ $pid =~ ^[0-9]+$ ]]; then
   jps -l | grep rest
   echo "stop java process $pid ..."
   kill -9 $pid
fi;
printf "_____\n\n"

## 启动 WebApp
if [ -f  "/root/webapp/rest-service-0.0.1-SNAPSHOT.jar" ]; then
    echo "> ls -l1 --color "/root/webapp""
    ls -l1 --color "/root/webapp"
    printf "_____\n\n"
    
    echo "start java rest webapp ..."
    /bin/bash -c "java -jar /root/webapp/rest-service-0.0.1-SNAPSHOT.jar > /dev/null &"

    for i in {1..60}; do
        echo "[$i] > curl -s http://localhost:8080/ping"
        msg=$(curl -s http://localhost:8080/ping)
        if [ "$msg" = "pong" ]; then
            echo "[$i] > $msg"
            pid=$(jps -l | grep rest | cut -d' ' -f 1)
            echo "java webapp started, pid: $pid"
            break;
        fi;

        echo "wait for java webapp starts ...."
        sleep 2
    done;
else 
    echo "file not exists: /root/webapp/rest-service-0.0.1-SNAPSHOT.jar"
    exit 127
fi;