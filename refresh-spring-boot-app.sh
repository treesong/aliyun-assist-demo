## 获取 VM: code-compile-server 实例 ID
compilerVmId=$(aliyun ecs DescribeInstances \
  --RegionId=cn-shenzhen \
  --InstanceName="code-compile-server" \
  | jq -r .Instances.Instance[0].InstanceId)

echo "code-compile-server: $compilerVmId"

## 获取 VM: webapp-server 实例 IP 列表
webappVmIps=$(aliyun ecs DescribeInstances \
  --RegionId=cn-shenzhen \
  --InstanceName="webapp-server%" \
  | jq -r .Instances.Instance[].NetworkInterfaces.NetworkInterface[].PrimaryIpAddress)

vm_ip_list=$(tr '\n' ' ' <<< $webappVmIps)
echo "应用服务器 IP 列表：$vm_ip_list"

parameters="{\"vm-ip-list\": \"${vm_ip_list}\"}"

## 更新代码，编译打包，并复制到应用服务器上
## run "4-pull-build-deploy-code.sh"
commandId=$(aliyun ecs DescribeCommands --RegionId=cn-shenzhen \
  --Name="4-pull-build-deploy-code" \
  | jq -r .Commands.Command[].CommandId)

invokeId=$(aliyun ecs InvokeCommand \
  --RegionId=cn-shenzhen \
  --CommandId=$commandId \
  --InstanceId.1=$compilerVmId \
  --Parameters="$parameters" \
 | jq -r .InvokeId)

echo "任务 ID:  ${invokeId}"

function wait_for_invocation_finish() {
  invokeId=$1
  printf "_________________________________\n"
  for i in {1..10}; do
    result=$(aliyun ecs DescribeInvocationResults \
      --RegionId=cn-shenzhen \
      --InvokeId=$invokeId \
      --ContentEncoding=PlainText \
    | jq -r .Invocation.InvocationResults.InvocationResult[0])
 
    status=$(jq -r .InvocationStatus <<< $result)
    echo "任务 $invokeId 状态: $status"

    if [ "$status" = "Success" ]; then
        output=$(jq -r .Output <<< $result)
        echo "任务 $invokeId 输出: $output"
        break;
    fi;
    sleep 1
  done;
  printf "_________________________________\n"
}

wait_for_invocation_finish $invokeId

## 获取 VM: webapp-server 实例 ID 列表
webappVmIds=$(aliyun ecs DescribeInstances \
  --RegionId=cn-shenzhen \
  --InstanceName="webapp-server%" \
  | jq -r '.Instances.Instance[].InstanceId')

index=1
idArray=()
for vmId in $webappVmIds; do
  idArray+=("--InstanceId.$((index++))=$vmId")
done;
InstanceIdArgs=$(echo ${idArray[@]});
echo $InstanceIdArgs

## 重启 WebApp Java 应用 (c-sz0wh66r6146ps)
commandId=$(aliyun ecs DescribeCommands --RegionId=cn-shenzhen \
  --Name="5-start-webapp-server" \
  | jq -r .Commands.Command[].CommandId)

invokeId=$(aliyun ecs InvokeCommand $InstanceIdArgs \
  --RegionId=cn-shenzhen \
  --CommandId=$commandId \
  | jq -r .InvokeId)

echo "任务 ID:  ${invokeId}"
wait_for_invocation_finish $invokeId