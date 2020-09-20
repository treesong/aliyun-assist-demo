if [ -f "/root/.ssh/authorized_keys" ]; then
    ssh_key=$(cat /root/.ssh/authorized_keys | grep "ruiqi@alibaba-inc.com")
    
    if [ -z "${ssh_key}" ]; then
        echo "{{ssh-rsa-pub}}" >> /root/.ssh/authorized_keys
    fi;
else
    echo "{{ssh-rsa-pub}}" > /root/.ssh/authorized_keys
fi;

echo "===== content of ssh-rsa-pub ====="
cat /root/.ssh/authorized_keys | grep "ruiqi@alibaba-inc.com"
mkdir -p /root/webapp