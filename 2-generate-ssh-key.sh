## 生成 ssh 密钥
if [ ! -f "/root/.ssh/id_rsa_ssh" ]; then
    ssh-keygen -q -t rsa -b 4096 \
      -C "ruiqi@alibaba-inc.com" \
      -f /root/.ssh/id_rsa_ssh \
      -N ""
fi;

echo "===== begin pub key for ssh ====="
cat /root/.ssh/id_rsa_ssh.pub
echo "===== end pub key for git ====="
echo ""

## 配置自动选择 ssh 密钥
for vm_ip in {{vm-ip-list}}; do
  echo "config ssh $vm_ip by id_rsa_ssh ..."
  echo "host $vm_ip
     HostName $vm_ip
     StrictHostKeyChecking no
     User root
     IdentityFile ~/.ssh/id_rsa_ssh
" >> /root/.ssh/config
done;