一、概述
----

单个 `JMeter` 实例可能无法产生足够的负载来对应用程序进行压力测试，就如`jmeter`[官网所示](https://jmeter.apache.org/usermanual/remote-test.html)，一个 `JMeter`实例将能够控制多个远程 `JMeter` 实例对应用程序进行更大的负载测试。 `JMeter` 使用 Java RMI [远程方法调用] 与分布式网络中的对象进行交互。

JMeter 的宿主机`master`及从属机`slave`之间的通信，如下图所示。

![](https://raw.githubusercontent.com/kamalyes/image-bed/master/snap/jm-master-slave-2.png)

如图所示，从属机`slave`需要开通两个端口

```bash
#slave机器需要开通的端口
Server_port=1099
server.rmi.localport=50000
```

在宿主机`master`上打开一个端口，让从属机`slave`将压测的结果发送给宿主机`master`。

```bash
#master机器需要开通的端口
client.rmi.localport=60000
```

通过在多台从属机`slave`上运行多个 `JMeter` 实例作为服务器，这样就可以根据需要生成尽可能多的负载。

![](https://raw.githubusercontent.com/kamalyes/image-bed/master/snap/JMeter-Docker-Basic-New-Page-1.png)

二、执行逻辑
------

### 1、`Docker`的作用

Docker就像一个管理者，它能够将软件及其所有依赖项打包成一个容器运行。

首先，我们可以把将要部署的软件打包成一个Docker image(镜像)，并将其部署在安装了docker的机器上，它可以将软件与硬件分开，应用程序都可以在任何计算

机上运行，不管运行的计算机有什么自定义设置不同于编写和测试代码的机器。这样我们不再关注硬件，可以快速部署应用。

### 2、`Docker`在`JMeter`分布式测试中扮演的角色

如果要根据上图所示，进行分布式负载测试就需要`1个master，N个slave`来生成大量的负载。每个`JMeter slave`都需要安装相同(指定)版本的`Java`和`JMeter`。

应该打开指定的端口并运行`JMeter`服务器，准备就绪并等待主服务器发送指令。

手动设置三五台计算机看起来很容易，那如果我们必须对50/100/1000台计算机执行此操作呢？还可以想象如果将来需要在所有机器上升级`JMeter`版本或者`Java`版本会发生什么？可以想象工作量得有多大，至此，Docker就该派上用场了。

### 3、分布式前置条件

**这些条件使用于所有机器，包括master和slave的机器：**

*   运行相同版本的JMeter
    
*   使用相同的java版本
    
*   有基于SSL的RMI的有效密钥库，或者禁用SSL。（本文举例中是采用的禁用SSL）
    
```bash
server.rmi.ssl.disable=true
```
    
*   都在一个网络
    
*   关闭防火墙
    

### 4、如何做

*   通常，我们会在名为 **Dockerfile** 的文件中配置`JMeter`分布式测试的整个基础架构，检查dockerfile并阅读注释以了解每个步骤的作用，最后生成包含`JMeter`、`java`等工具集合的镜像。
*   然后，再根据生成的基础镜像，开始部署`master`机器及`slave`机器。
*   接着，在`master`机器执行压测命令。

三、基础镜像
------

在分布式压测中，所有的环境都应该使用相同版本的Java、JMeter、plugins等。master和slave之间唯一区别是所公开的端口和正在运行的进程。因此，让我们创建一个Dockerfile，该文件具有master和slave的所有通用步骤，称其为 **jmbase** 基础镜像，我们将需要执行以下操作来构建基本映像:

*   需要Java8 –因此，让openjdk-8-jre slim版本，大小保持尽可能小。
*   需要安装公共的工具包，例如wget、net-tools、telnet、vim等。
*   需要最新版本的JMeter，为版本创建变量，以便后续维护。
*   安装需要的插件。
*   添加一个包含测试用例的文件夹。

### 1、基础镜像`Dockerfile`

这是`Dockerfile`文件，作用是生成基础镜像

```bash
FROM openjdk:8-jre-slim

# jmeter版本
ARG JMETER_VERSION=5.5

# 默认工作区
ENV APP_WORKSPCE=/opt

# 安装必要软件
RUN apt-get clean && \
  apt-get update && \
  apt-get -qy install \
  vim \
  wget \
  curl \
  telnet \
  iputils-ping \
  net-tools

# 防止vim安装失败
RUN apt-get update --fix-missing && apt-get install -y vim --fix-missing


#jmeter环境变量
ENV JMETER_HOME=/jmeter
ENV PATH=$JMETER_HOME/bin:$PATH
ENV CLASSPATH=$JMETER_HOME/lib/ext/ApacheJMeter_core.jar:$JMETER_HOME/lib/jorphan.jar:$CLASSPATH

# 安装jmeter
RUN mkdir -p $APP_WORKSPCE \
  && cd $APP_WORKSPCE \
  #	国内镜像高速下载jmeter
  && wget https://mirrors.aliyun.com/apache/jmeter/binaries/apache-jmeter-$JMETER_VERSION.tgz \
  #	官方下载jmeter
  #	&& wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-$JMETER_VERSION.tgz \
  && tar -xvzf apache-jmeter-$JMETER_VERSION.tgz \
  && mv apache-jmeter-$JMETER_VERSION $JMETER_HOME \
  && rm apache-jmeter-$JMETER_VERSION.tgz

WORKDIR $JMETER_HOME

#脚本复制到当前路径
COPY ./config/user.properties bin/user.properties
COPY ./scripts/install_plugin_manager.sh .
COPY ./scripts/entrypoint.sh .

RUN chmod +x install_plugin_manager.sh entrypoint.sh \
  && mkdir -p lib/ext \ 
  && ./install_plugin_manager.sh

EXPOSE 1099 50000 60000 
ENTRYPOINT ["sleep", "36000"]
```

### 2、容器启动运行脚本

这是`entrypoint.sh`脚本，在容器生成时，根据容器启动时的命令，输入**master**或者**server**，选择打开对应的端口号。**jmeter-server**运行的时候公开端口1099和50000。

```bash
#!/bin/bash
set -e
echo "Starting entrypoint!"
pwd
case $1 in
    master)
        tail -f /dev/null # 防止容器启动后退出
        ;;
    server)
        $JMETER_HOME/bin/jmeter-server \
            -Dserver.rmi.localport=50000 \
            -Dserver_port=1099
        ;;
    *)
        echo "Sorry, this option doesn't exist!"
        ;;
esac
exec "$@"
```

### 3、安装插件

这是`install_plugin_manager.sh`脚本，在容器生成时，安装插件

```bash
#!/bin/bash

CMD_RUNNER_URL="http://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/2.3/cmdrunner-2.3.jar"
PLUGIN_MANAGER_URL="https://jmeter-plugins.org/get/"

# DOWNLOAD RUNNER
wget -O "lib/cmdrunner-2.3.jar" $CMD_RUNNER_URL

# DOWNLOAD MANAGER
wget -O "lib/ext/jmeter-plugins-manager.jar" $PLUGIN_MANAGER_URL

# GENERATING SCRIPTS
java -cp lib/ext/jmeter-plugins-manager.jar org.jmeterplugins.repository.PluginManagerCMDInstaller
```

这是`user.properties`配置文件，在容器生成时，安装好`jmeter`后，把`jmeter`的`user.properties`配置文件替换一下。

```bash
#将注释打开，并且将值修改成true，就会打开该条记录，JMeter就会将该条信息输出到我们指定的.jtl文件中。
jmeter.save.saveservice.default_delimiter=\t
jmeter.save.saveservice.print_field_names=true
#关闭SSL传输
server.rmi.ssl.disable=true
```

### 4、镜像生成

生成基础镜像`kamalyes/jmeter:jdk8-slim`，命令如下：

```bash
docker build -t kamalyes/jmeter:jdk8-slim . 
```

四、执行压测
------

### 1、启动容器

这是`docker-compose.yml`文件，基础镜像`kamalyes/jmeter:v1.0.0`生成后，使用`docker-compose`命令启动容器，并执行负载均衡。

```bash
version: '3'

services:
  master:
    image: kamalyes/jmeter:jdk8-slim
    command: master
    container_name: jmeter-master # 容器名称
    tty: true
    ports:
      - 60000:60000
    volumes:
      - "../sample_test/:/jmeter/sample_test/"
    networks:
      - jmeter-network

  server:
    image: kamalyes/jmeter:jdk8-slim
    command: server
    container_name: jmeter-slave # 容器名称
    tty: true
    ports:
      - 1099:1099
      - 50000:50000
    networks:
      - jmeter-network
    depends_on:
      - master

networks:
  jmeter-network:
    driver: bridge
```

注意：volumes挂载的目录，此压测脚本是在当前目录，或者上级目录。

使用`docker-compose`命令启动容器，并后台执行。

```bash
docker-compose up -d
```

### 2、查询slave的IP地址

docker命令启动的容器，可以通过以下命令，查询所有的ip地址

```bash
docker inspect -f '{{.Name}} => {{.NetworkSettings.IPAddress }}' $(docker ps -aq)
```

若是通过docker-compose命令启动的容器，那么查询容器的IP地址

```bash
docker inspect -f '{{.Name}} => {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -aq)
或者
docker inspect --format='{{.Name}} => {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -aq)
```

查询筛选对应的容器的IP地址，命令如下：

```bash
docker inspect --format='{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -aq) | grep "docker-compose-server"
```

### 3、执行压测

进入容器

```bash
docker exec -it docker-compose-master-1 /bin/sh 
```

执行压测脚本

```bash
jmeter -n -t ../sample/baidu.jmx -l ../sample/data/baidu.jtl -j ../sample/data/baidu.log -R 172.18.0.3,172.18.0.4
```

若脚本没有挂载到容器，也可以将本地jmeter脚本复制到容器中，命令如下：

```bash
sudo docker exec -i master sh -c 'cat > /jmeter/apache-jmeter-5.5/bin/baidu.jmx' < baidu.jmx
```

负载均衡，通过`--scale server=5`我们构建3个server服务

```bash
docker-compose up -d --scale server=3 
```

重新构建镜像 --force-rm 删除构建过程中的临时容器

```bash
docker-compose build --force-rm
```

五、参考
----

1、jmeter分布式压测（官方）：[https://jmeter.apache.org/usermanual/remote-test.html](https://jmeter.apache.org/usermanual/remote-test.html)

2、前置条件：[https://www.cnblogs.com/MasterMonkInTemple/p/11978058.html](https://www.cnblogs.com/MasterMonkInTemple/p/11978058.html)
