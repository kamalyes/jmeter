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