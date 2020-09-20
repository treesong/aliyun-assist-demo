## 阿里云-云助手使用演示
## [编译机]

## 检测/安装 JDK
java -version
if [ $? = 127 ]; then
    yum install -y java-1.8.0-openjdk-devel
    echo "install java done"
    java -version
fi;
printf "_____\n\n"

## 检测/安装 GIT
git --version
if [ $? = 127 ]; then
    yum install -y git
    echo "install git done"
fi;
printf "_____\n\n"

## 检测/下载 Maven
cd /root
if [ ! -d "/root/apache-maven" ]; then
    wget -q https://mirrors.bfsu.edu.cn/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.zip
    unzip -q -o -d ./ ./apache-maven-3.6.3-bin.zip
    ln -s /root/apache-maven-3.6.3/ /root/apache-maven
fi;

export PATH=/root/apache-maven/bin/:$PATH
mvn --version
printf "_____\n\n"

## 更新 maven settings.xml 配置
echo '
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">

    <localRepository>/root/.m2/repository</localRepository>

    <mirrors>
        <mirror>
            <id>aliyun</id>
            <name>aliyun Maven</name>
            <mirrorOf>central</mirrorOf>
            <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
        </mirror>
        <mirror>
            <id>CN</id>
            <name>OSChina Central</name>
            <url>http://maven.oschina.net/content/groups/public/</url>
            <mirrorOf>central</mirrorOf>
        </mirror>
    </mirrors>

    <profiles></profiles>

</settings>
' > /root/apache-maven/conf/settings.xml


## 生成 git 密钥
if [ ! -f "/root/.ssh/id_rsa_git" ]; then
    ssh-keygen -q -t rsa -b 4096 \
      -C "treesong@github.com" \
      -f /root/.ssh/id_rsa_git \
      -N ""
fi;

## 配置自动选择 git 密钥
echo "host github.com
    HostName github.com
    StrictHostKeyChecking no
    User treesong
    IdentityFile /root/.ssh/id_rsa_git
" > /root/.ssh/config

echo "===== beging pub key for git ====="
cat /root/.ssh/id_rsa_git.pub
echo "===== end pub key for git ====="