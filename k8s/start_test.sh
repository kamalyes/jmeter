#!/bin/bash
jmx="api_test.jmx" # jmx压测文件
csv="api_test.csv" # csv在jmx中路径为/jmeter/jmx；若无，同时注释掉Step2
echo "Step1 拷贝jmx至master"
master_pod=`kubectl get po | grep jmeter-master | grep Running | awk '{print $1}'`
kubectl cp "$jmx" -c jmmaster  "$master_pod:/jmeter/jmx/test.jmx"
echo "Step2 拷贝csv至slave"
slave_pod=`kubectl get po | grep jmeter-slave | grep Running | awk '{print $1}'`
for i in $slave_pod;do
  kubectl cp "$csv"  "$i:/jmeter/jmx/$csv"
done;
echo "Step3 开启压测"
kubectl exec -ti  $master_pod -c jmmaster -- bash /run.sh
echo "Step4 查询压测结果："
echo "http://<外网IP>:30080"

