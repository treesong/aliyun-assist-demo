aliyun vpc CreateVpc --RegionId=cn-shenzhen \
    --VpcName="vpc-for-assist-demo-d" \
    --CidrBlock="192.168.0.0/16" \
    --ResourceGroupId="rg-acfmzrhgt47v2py"

aliyun ecs CreateSecurityGroup \
    --RegionId=cn-shenzhen \
    --SecurityGroupName="sg-axt-demo" \
    --VpcId="vpc-wz9bvfkc63529josqj2zg"

aliyun ecs AuthorizeSecurityGroup --RegionId=cn-shenzhen \
    --SecurityGroupId="sg-wz9iwarx7zt1x9ip8rtc"
    --NicType="intranet"


aliyun vpc CreateVSwitch --RegionId=cn-shenzhen \
    --ZoneId="cn-shenzhen-d" \
    --VSwitchName="vws-for-axt-demo-d" \
    --CidrBlock="192.168.0.0/29" \
    --VpcId="vpc-wz9bvfkc63529josqj2zg"

aliyun vpc CreateVSwitch --RegionId=cn-shenzhen \
    --ZoneId="cn-shenzhen-e" \
    --VSwitchName="vws-for-axt-demo-e" \
    --CidrBlock="192.168.1.0/29" \
    --VpcId="vpc-wz9bvfkc63529josqj2zg"


aliyun ecs RunInstances --RegionId=cn-shenzhen \
    --ZoneId="cn-shenzhen-d" \
    --VSwitchId="vsw-wz9l2n6q17bsq5exes0zx" \
    --DryRun=false \
    --InstanceType="ecs.c6e.large" \
    --IoOptimized="optimized" \
    --InstanceChargeType="PostPaid" \
    --ImageId="centos_8_2_x64_20G_alibase_20200824.vhd" \
    --SecurityGroupId="sg-wz9f3oa2tgga7bkjlof8" \
    --KeyPairName="ecs-ssh-key" \
    --Period=1 \
    --PeriodUnit="Hourly" \
    --InternetChargeType="PayByTraffic" \
    --InstanceName="code-compile-server" \
    --HostName="code-compile-server" \
    --Amount=1 \
    --InternetMaxBandwidthOut=0 \
    --SecurityEnhancementStrategy="Active" \
    --SystemDisk.Size=40 \
    --SystemDisk.Category="cloud_essd"


for i in {1..1}; do
  aliyun ecs RunInstances --RegionId=cn-shenzhen \
    --ZoneId="cn-shenzhen-c" \
    --VSwitchId="vsw-wz90vkux72402hkj86oiz" \
    --DryRun=false \
    --InstanceType="ecs.n1.medium" \
    --IoOptimized="optimized" \
    --InstanceChargeType="PostPaid" \
    --ImageId="centos_8_2_x64_20G_alibase_20200824.vhd" \
    --SecurityGroupId="sg-wz9iwarx7zt1x9ip8rtc" \
    --KeyPairName="ecs-ssh-key" \
    --Period=1 \
    --PeriodUnit="Hourly" \
    --InternetChargeType="PayByTraffic" \
    --InstanceName="java-webapp-server-00$i" \
    --HostName="java-webapp-server-00$i" \
    --Amount=1 \
    --InternetMaxBandwidthOut=0 \
    --SecurityEnhancementStrategy="Active" \
    --SystemDisk.Size=40 \
    --SystemDisk.Category="cloud_ssd"
done;