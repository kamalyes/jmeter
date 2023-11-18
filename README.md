[![Docker Build](https://github.com/kamalyes/docker-jmeter/actions/workflows/build-dockerhub.yml/badge.svg)](https://github.com/kamalyes/docker-jmeter/actions/workflows/build-dockerhub.yml)

# 快速使用

## 镜像版本

你可以在[Docker Hub](https://hub.docker.com/r/kamalyes/jmeter)上找到镜像。
- [`latest`, `5.5`, `5.5-11-jre`,`5.5.0`, `5.5.0-11-jre`](https://github.com/kamalyes/docker-jmeter/blob/v2/Dockerfile)
- [`latest-11-jdk`, `5.5-11-jdk`,`5.5.0-11-jdk`](https://github.com/kamalyes/docker-jmeter/blob/v2/Dockerfile)
- [`latest-plugins`, `5.5-plugins`, `5.5-plugins-11-jre`, `5.5.0-plugins`, `5.5.0-plugins-11-jre`](https://github.com/kamalyes/docker-jmeter/blob/v2/Dockerfile)
- [`latest-plugins-11-jdk`, `5.5-plugins-11-jdk`, `5.5.3-plugins-11-jdk`](https://github.com/kamalyes/docker-jmeter/blob/v2/Dockerfile)
- [`5.4`, `5.4-11-jre`,`5.4.3`, `5.4.3-11-jre`](https://github.com/kamalyes/docker-jmeter/blob/v2/Dockerfile)
- [`5.4-11-jdk`,`5.4.3-11-jdk`](https://github.com/kamalyes/docker-jmeter/blob/v2/Dockerfile)
- [`5.4-plugins`, `5.4-plugins-11-jre`, `5.4.3-plugins`, `5.4.3-plugins-11-jre`](https://github.com/kamalyes/docker-jmeter/blob/v2/Dockerfile)
- [`5.4-plugins-11-jdk`, `5.4.3-plugins-11-jdk`](https://github.com/kamalyes/docker-jmeter/blob/v2/Dockerfile)

## 产品特点

1. 最小大小为~110MB。
2. 两个版本:原生JMeter版本和带有预配置插件管理器的JMeter版本。
3. 执行超时。超时后，docker将停止，即使测试尚未完成。这有助于在超时后强制停止JMeter docker。
4. 下载带有maven依赖项格式的插件。
5. 下载插件与url列表。
6. 下载插件与插件管理器(仅插件版本)。
7. 使用文件夹中的插件。
8. 检查JMX测试(仅插件版本)
9. 在多节点上拆分CSV数据。
10. 执行前/后测试shell脚本。
11. 将项目配置从节点配置中分离出来，将配置从执行团队和开发团队中分离出来。
12. 隔离输出文件夹(日志、jtl文件、html报告)。
13. 任何JMeter参数都可以在参数中使用。
14. 这个图像没有限制，如果不使用自定义输入参数，JMeter可以直接使用。
15. 可以通过检查文件是否存在来执行延迟。
16. 使用Jolokia监视Jmx(仅适用于JDK映像)。

## 目录

- [镜像变量](#image-variants)
  - [`jmeter:<jmeter-version>-plugins-*`](#jmeterjmeter-version-plugins-)
- [文件夹结构](#folder-structure)
  - [image文件夹结构](#image-folder-structure)
  - [项目文件夹结构](#project-folder-structure)
  - [文件夹结构](#user-folder-structure)
  - [配置](#configuration)
- [暴露的端口](#exposed-port)
- [插件安装](#plugins-installation)
  - [以Maven格式下载插件](#download-plugins-with-maven-format)
  - [以Maven格式下载Plugins依赖项](#download-plugins-dependencies-with-maven-format)
  - [以zip格式下载依赖项](#download-dependencies-with-zip-format)
  - [使用插件管理器自动下载依赖项](#download-dependencies-automatically-with-plugin-manager)
  - [使用插件管理器下载依赖项列表](#download-dependencies-list-with-plugin-manager)
  - [使用项目或用户文件夹中的插件和依赖项](#use-plugins-and-dependencies-from-project-or-user-folder)
  - [使用插件和依赖项作为附加库](#use-plugins-and-dependencies-as-additional-lib)
- [Test plan check](#test-plan-check)
- [Split CSV files](#split-csv-files)
- [Timezone](#timezone)
- [JMX Monitoring (Jolokia)](#jmx-monitoring-jolokia)
- [Examples](#examples)
  - [更改JVM内存大小](#change-jvm-memory-size)
  - [使用其他属性文件](#use-additional-properties-files)
  - [为JMeter执行使用超时](#use-timeout-for-jmeter-execution)
  - [只在主节点上执行before-test.sh/after-test.sh](#execute-before-testshafter-testsh-only-on-master-node)
  - [生成JTL, HTML报告和日志文件](#generate-jtl-html-report-and-log-file)
  - [使用额外的原始JMeter参数](#using-additional-raw-jmeter-parameter)
  - [使用原始JMeter参数](#using-raw-jmeter-parameter)
  - [使用wait to be Ready](#using-wait-to-be-ready)
- [最佳实践](#best-practice)

# Image Variants

`JMeter`图像有很多种风格，每一种都是为特定的用例设计的。

镜像版本是基于用于构建镜像的组件:

1. **JMeter版本**:5.5.0 ->默认为5.5。

2. **JVM版本**:例如:(-11-jre，默认为11-jre)，默认JVM为' eclipse-temurin '。

3.**插件**:预装了[插件管理器](https://jmeter-plugins.org/wiki/PluginsManagerAutomated/)和[测试计划检查工具](https://jmeter-plugins.org/wiki/TestPlanCheckTool/)。这将为图像提供检查JMX文件和使用插件管理器下载插件的功能。

## `jmeter:<jmeter-version>-plugins-*`

This is the image containing pre-installed [plugins manager](https://jmeter-plugins.org/wiki/PluginsManagerAutomated/) and [test plan check tool](https://jmeter-plugins.org/wiki/TestPlanCheckTool/). This will provide the image with the feature to check JMX file and download plugins with plugin manager.

# Folder structure

## Image Folder structure

| Folder/files                      | Environnement variable  | Description             |
| --------------------------------- | ----------------------- | ----------------------- |
| `/opt/apache-jmeter`              | `JMETER_HOME`           | JMeter的安装路径 |
| `/jmeter/additional/lib`          | `JMETER_ADDITIONAL_LIB` | 使用属性的JMeter文件夹的附加库 [plugin_dependency_paths](https://jmeter.apache.org/usermanual/properties_reference.html#classpath)                                                                                              |
| `/jmeter/additional/lib/ext`      | `JMETER_ADDITIONAL_EXT` | 使用属性的JMeter文件夹的附加插件 [search_paths](https://jmeter.apache.org/usermanual/properties_reference.html#classpath)                                                                                                     |
| `/jmeter/project`                 | `PROJECT_PATH`          | 项目文件夹，其中应该存在JMX文件。|
| `/jmeter/workspace`               | `WORKSPACE_TARGET`      | 如果选择了复制的项目文件夹(`$CONF_COPY_TO_WORKSPACE`)，这将是目标文件夹。`$WORKSPACE_PATH`将是工作空间文件夹，这取决于是否复制项目，它将是`$WORKSPACE_TARGET`或`$PROJECT_PATH`|
| `/jmeter/user`                    | `USER_PATH`             | 第二个用于配置项目执行的文件夹。|
| `/jmeter/out`                     | `OUTPUT_PATH`           | 基本输出文件夹 |
| `$OUTPUT_PATH/jtl`                | `OUTPUT_JTL_PATH`       | 默认的JTL目标文件夹 |
| `$OUTPUT_PATH/log`                | `OUTPUT_LOG_PATH`       | 默认日志目标文件夹 |
| `$OUTPUT_PATH/csv`                | `OUTPUT_CSV_PATH`       | 默认分割的csv目标文件夹，仅用于调试。|
| `$OUTPUT_PATH/dashboard`          | `OUTPUT_REPORT_PATH`    | 默认报表基文件夹 |
| `/opt/jolokia/jolokia.properties` | `JOLOKIA_CONFIG`        | Jolokia配置文件:<https://jolokia.org/reference/html/agents.html#agents-jvm> |

## Project folder structure

| Folder/files                                    | Description                          |
| ----------------------------------------------- | ------------------------------- |
| `lib`                                           | 在$JMETER_HOME/lib文件夹中，这个文件夹中的文件将被复制到$JMETER_HOME/lib|
| `plugins`                                       | plugins文件夹，这个文件夹中的文件将被复制到$JMETER_HOME/lib/ext|
| `dependencies/url.txt`                          | 该文件中的url将被下载并解压缩到$JMETER_HOME|
| `dependencies/settings.xml`                     | 如果不需要对maven存储库或自定义存储库进行身份验证，则使用该文件 |
| `dependencies/plugins-lib-dependencies.xml`     | 该文件中的插件、jar将被复制到JMeter的lib文件夹中。|
| `dependencies/plugins-lib-ext-dependencies.xml` | 该文件中的插件、jar将被复制到JMeter中的`lib/ext`文件夹中。|
| `scripts/after-test.sh`                         | 该脚本将在JMeter测试结束后执行。要在slave测试后执行，JMeter应该在测试后使用`$JMETER_EXIT`停止。 |
| `scripts/before-test.sh`                        | 该脚本将在JMeter启动之前执行|
| `jmeter.properties`                             | 默认值属性文件。

Example of project folder: (<https://github.com/kamalyes/docker-jmeter/tree/v2/tests/projects/sample1>)

## User Folder structure

与项目文件夹一样，唯一不同的JMX文件不会在这个文件夹中使用。
用户文件夹示例:(<https://github.com/kamalyes/docker-jmeter/tree/v2/tests/users/user1>)

## Configuration

This environment variable are input to configure JMeter and execution:

| Environment variables                    | default value       | Description |
| ---------------------------------------- | ------------------- | ---------------------- |
| `CONF_SKIP_PLUGINS_INSTALL`              | `false`             | 跳过从maven安装插件，以及url.txt和文件夹。
| `CONF_SKIP_PRE_ACTION`                   | `false`             | 跳过执行aftertest .sh
| `CONF_SKIP_POST_ACTION`                  | `false`             | 跳过执行before-test.sh
| `CONF_COPY_TO_WORKSPACE`                 | `false`             | 在执行测试之前，将项目复制到' $WORKSPACE_TARGET '，此功能可以与' $CONF_CSV_SPLIT '一起使用，以不更改可与多个slave共享的项目文件夹上的文件。|
| `CONF_WITH_JOLOKIA`                      | `false`             | 启用Jolokia进行JMX监控，此功能仅适用于JDK版本|
| `CONF_EXEC_IS_SLAVE`                     | `false`             | True，作为从属节点，这将添加“——server”作为JMeter的参数，这个变量也可以在脚本上使用，以选择是否也可以在从属节点上执行操作或仅在主节点上执行操作。|
| `CONF_EXEC_WORKER_COUNT`                 | `1`                 | JMeter slave总数。该值仅用于分割CSV文件。|
| `CONF_EXEC_WORKER_NUMBER`                | `1`                 | 当前从服务器的数量。该值仅用于分割CSV文件。|
| `CONF_EXEC_WAIT_BEFORE_TEST`             | `0`                 | 在启动JMeter之前等待一秒钟。|
| `CONF_EXEC_WAIT_AFTER_TEST`              | `1`                 | 停止JMeter后等待1秒。|
| `CONF_EXEC_TIMEOUT`                      | `2592000`           | 默认超时以秒为单位，在此持续时间之后JMeter和docker容器将停止，默认为30天|
| `CONF_READY_WAIT_FILE`                   |                     | 如果文件以`/`开头，文件将被视为绝对路径，如果文件以`/`开头，文件将被视为`PROJECT_PATH`的相对路径，当我们需要启动容器而不是在Kubernetes上使用mount将项目复制到容器时，这个选项很有用。  |
| `CONF_READY_WAIT_TIMEOUT`                | `1200`              | 等待就绪文件出现的默认超时(以秒为单位)|
| `CONF_CSV_SPLIT`                         | `false`             | 分割csv文件上的' $CONF_EXEC_WORKER_COUNT '，并采取部分' CONF_EXEC_WORKER_COUNT ' |
| `CONF_CSV_SPLIT_PATTERN`                 | `**`                | 模式用于选择要分割的csv文件，默认过滤器(*.csv)已经被使用，所以只有csv文件被分割，模式是应用于文件的相对路径，所以模式可以应用于文件夹或文件名。(例如:“data”文件夹下的CSV文件为“./data/*. CSV”，后缀为“*_split.csv”的“data”文件夹下的CSV文件为“。/data/*_split.csv”) |
| `CONF_CSV_WITH_HEADER`                   | `true`              | 分割CSV文件是否有头。|
| `CONF_CSV_DIVIDED_TO_OUT`                | `true`              | 将分割的文件复制到`$OUTPUT_CSV_PATH`，仅用于调试。
| `JMETER_JMX`                             |                     | JMX测试文件。 |
| `JMETER_EXIT`                            | `false`             | 所有节点测试完成后强制退出。
| `JMETER_PROPERTIES_FILES`                | `jmeter.properties` | 要用作附加属性的属性文件列表(例如:"size。属性preprod.properties”)。如果文件存在，此列表将从项目和用户文件夹中添加。  |
| `JMETER_JTL_FILE`                        |                     | JTL结果文件的名称，将保存在文件夹中`$OUTPUT_JTL_PATH` |
| `JMETER_LOG_FILE`                        | `jmeter.log`        | JMeter日志文件名`$OUTPUT_LOG_PATH`             |
| `JMETER_REPORT_NAME`                     |                     | HTML报告名称，将保存在文件夹中`$OUTPUT_REPORT_PATH` |
| `JMETER_JVM_ARGS`                        |                     | JMeter JVM参数，可以配置JVM的Xmx, Xms，…    |
| `JMETER_JVM_EXTRA_ARGS`                  |                     | 第二个参数用于配置JVM参数。|
| `JMETER_DEFAULT_ARGS`                    | `--nongui`          | 默认参数，默认情况下JMeter以非gui模式执行 (headless mode).  |
| `JMETER_CHECK_ONLY`                      | `false`             | 不要执行test，而只做一个检查 [test plan check tool](https://jmeter-plugins.org/wiki/TestPlanCheckTool/), available only on (variant plugins) |
| `JMETER_PLUGINS_MANAGER_INSTALL_LIST`    |                     | 安装列表的插件使用 [plugins manager](https://jmeter-plugins.org/wiki/PluginsManagerAutomated/) (e.g. : "jpgc-json=2.2,jpgc-casutg=2.0") |
| `JMETER_PLUGINS_MANAGER_INSTALL_FOR_JMX` | `false`             | 安装所需的插件为jmx文件自动使用 [plugins manager](https://jmeter-plugins.org/wiki/PluginsManagerAutomated/)                                                                                                                                                                                                                                              |

# 暴露的端口

1. 暴露的RMI端口是1099。参见<https://jmeter.apache.org/usermanual/remote-test.html>上的文档
2. Jolokia端口8778。

# 插件安装

插件可以通过多种方式提供。

我们区分了两种类型的库依赖，插件和插件依赖。在JMeter中，它们分别位于lib/ext和lib文件夹中。

## 以Maven格式下载插件

在`项目文件夹`或`用户文件夹`中放置maven xml文件`dependencies/plugins-lib-ext-dependencies.xml`，使用排除符\*来不下载JAR的依赖项，只使用文件中引用的JAR。
这个文件中的JAR将被下载到`$JMETER_HOME/lib/ext`文件夹中。
例如:

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>org.kamalyes.jmeter.docker</groupId>
  <version>1.0.0</version>
  <packaging>pom</packaging>

  <artifactId>sample-lib-ext</artifactId>

  <dependencies>
    <dependency>
      <groupId>com.blazemeter</groupId>
      <artifactId>jmeter-plugins-random-csv-data-set</artifactId>
      <version>0.8</version>
      <exclusions>
        <exclusion>
          <groupId>*</groupId>
          <artifactId>*</artifactId>
        </exclusion>
      </exclusions>
    </dependency>
    <dependency>
      <groupId>kg.apc</groupId>
      <artifactId>jmeter-plugins-graphs-additional</artifactId>
      <version>2.0</version>
      <exclusions>
        <exclusion>
          <groupId>*</groupId>
          <artifactId>*</artifactId>
        </exclusion>
      </exclusions>
    </dependency>
  </dependencies>
</project>
```

## 以Maven格式下载Plugins依赖项


在`项目文件夹`或`用户文件夹`中放置maven XML文件`dependencies/plugins-lib-dependencies.xml`，使用排除符\*来不下载JAR的依赖项，只使用文件中引用的JAR。

这个文件中的JAR将被下载到`$JMETER_HOME/lib`文件夹中。

与[plugins]使用的格式相同(#download-plugins-with-maven-format)

## 以zip格式下载依赖项

在`项目文件夹`或`用户文件夹`中，将文件`dependencies/url.txt`与ZIP url列表放在一起。
这些zip使用与lib和lib/ext文件夹相同的JMeter结构。从网站<https://jmeter-plugins.org/>下载的ZIP链接与此文件兼容。
**注意:**:来自<https://jmeter-plugins.org/>的ZIP文件还包含JMeter插件管理器和其他常见的jar，这些jar可以在使用多个插件时复制。

## 使用插件管理器自动下载依赖项

使用[version with plugins](#jmeterjmeter-version-plugins-)来预先配置插件管理器。
在使用[plugins manager](https://jmeter-plugins.org/wiki/PluginsManagerAutomated/)
启动JMeter之前，使用env变量JMETER_PLUGINS_MANAGER_INSTALL_FOR_JMX下载插件

```sh
docker run --rm \
-v ${PWD}/tests/projects/sample1/:/jmeter/project \
-e JMETER_JMX="test-plan.jmx" \
-e JMETER_PLUGINS_MANAGER_INSTALL_FOR_JMX="true" \
kamalyes/jmeter:latest-plugins
```

## 使用插件管理器下载依赖项列表

使用[version with plugins](#jmeterjmeter-version-plugins-)来预先配置插件管理器。
在使用[plugins manager](https://jmeter-plugins.org/wiki/PluginsManagerAutomated/)
启动JMeter之前，使用env变量JMETER_PLUGINS_MANAGER_INSTALL_LIST下载插件

```sh
docker run --rm \
-v ${PWD}/tests/projects/sample1/:/jmeter/project \
-e JMETER_JMX="test-plan.jmx" \
-e JMETER_PLUGINS_MANAGER_INSTALL_LIST="jpgc-json=2.2,jpgc-casutg=2.0" \
kamalyes/jmeter:latest-plugins
```

## 使用项目或用户文件夹中的插件和依赖项

在启动JMeter之前，将`/jmeter/project/plugins`文件夹和`/jmeter/user/plugins`文件夹拷贝到`$JMETER_HOME/lib/ext`目录下，将`/jmeter/project/lib`文件夹和`/jmeter/user/lib`文件夹拷贝到`$JMETER_HOME/lib`目录下。

## 使用插件和依赖项作为附加库

文件夹`/jmeter/additional/lib`被用作jmeter的附加lib文件夹，`/jmeter/additional/lib/ext`被用作jmeter的lib/ext文件夹的附加文件夹，这些文件夹中的文件不会被复制。

```sh
docker run --rm \
-v ${PWD}/tests/projects/sample1/:/jmeter/project \
-v /mylib/:/jmeter/additional/lib  \
-e JMETER_JMX="test-plan.jmx" \
kamalyes/jmeter:latest-plugins
```

# 测试计划检查

使用[version with plugins](#jmeterjmeter-version-plugins-)进行预先配置的测试计划检查。

[测试计划检查工具](https://jmeter-plugins.org/wiki/TestPlanCheckTool/)可以在不执行测试的情况下验证测试计划，例如:

```sh
docker run --rm \
-v ${PWD}/tests/projects/sample1/:/jmeter/project \
-e JMETER_JMX="test-plan.jmx" \
-e JMETER_CHECK_ONLY="true" \
kamalyes/jmeter:latest-plugins
```

**NB**测试计划检查不能检测到附加文件夹中的插件，所以[Use plugins and dependencies as additional-lib .](# Use -plugins-and-dependencies-as-additional-lib)将不能与测试检查一起工作，即使它与执行一起工作。

# 拆分CSV文件

通常我们需要JMeter集群不使用重复的数据(如登录用户，…)。这可以通过根据slave的数量拆分CSV文件来实现。
要做到这一点，你可以按照以下步骤:

1. 您必须使用模式`CONF_CSV_SPLIT_PATTERN`来识别要分割的CSV文件，例如，在所有文件上使用前缀(*_split.csv: login_split.csv)。
2. 您必须知道slave的总数`CONF_EXEC_WORKER_COUNT`，并通过编号`CONF_EXEC_WORKER_NUMBER`识别每个slave。
3. CSV文件将被分割后的文件所替换。如果项目文件夹不应该被修改，使用选项copy到工作空间`CONF_COPY_TO_WORKSPACE`，在开始执行之前复制项目文件夹。
4. 您还可以将分割的文件复制到out文件夹中，用于调试以检查分割的数据`CONF_CSV_DIVIDED_TO_OUT`

```sh
docker run --rm \
-v ${PWD}/tests/projects/sample1/:/jmeter/project \
-e JMETER_JMX="test-plan.jmx" \
-e CONF_COPY_TO_WORKSPACE="true" \
-e CONF_EXEC_WORKER_COUNT="5" \
-e CONF_EXEC_WORKER_NUMBER="1" \
-e CONF_CSV_SPLIT_PATTERN="**_split.csv"
-e CONF_CSV_DIVIDED_TO_OUT="true" \
kamalyes/jmeter:latest
```

# Timezone

默认的时区是'亚洲/上海'，如果你需要改变时区在jmeter日志上有正确的时间，你可以设置环境变量**TZ**，时区列表可在这里<https://en.wikipedia.org/wiki/List_of_tz_database_time_zones>。

```sh
docker run --rm \
-v ${PWD}/tests/projects/sample1/:/jmeter/project \
-e JMETER_JMX="basic-plan.jmx" \
-e TZ="Africa/Casablanca" \
kamalyes/jmeter:latest
```

还可以在before-test.sh文件中更改时区

```sh

export TZ="Africa/Casablanca"

```

# JMX Monitoring (Jolokia)

启用Jolokia进行Jmx监视，在端口8778上，强制使用jdk版本映像与Jolokia。

```sh
docker run --rm \
-p 8778:8778
-v ${PWD}/tests/projects/sample1/:/jmeter/project \
-e JMETER_JMX="basic-plan.jmx" \
-e CONF_WITH_JOLOKIA="true" \
kamalyes/jmeter:latest-plugins-11-jdk
```

# Examples

## Change JVM Memory size

你可以使用`JMETER_JVM_ARGS`或`JMETER_JVM_EXTRA_ARGS`来改变内存大小，例如:

```sh
docker run --rm \
-v ${PWD}/tests/projects/sample1/:/jmeter/project \
-e JMETER_JMX="basic-plan.jmx" \
-e JMETER_JVM_ARGS=" -Xmx2G -Xms1G " \
kamalyes/jmeter:latest
```

## Use additional properties files

You can add additional properties files using `JMETER_PROPERTIES_FILES`. Default value is jmeter.properties (If a file *jmeter.properties* is found in [project folder](#project-folder-structure) or in [user folder](#user-folder-structure) it will be added to JMeter execution.).

```sh
docker run --rm \
-v ${PWD}/tests/projects/sample1/:/jmeter/project \
-e JMETER_JMX="test-plan.jmx" \
-e JMETER_PROPERTIES_FILES="common.properties prepord.properties " \
kamalyes/jmeter:latest
```

## Use timeout for JMeter execution

您可以通过`CONF_EXEC_TIMEOUT`值设置执行超时时间。在该超时之后，JMeter停止，之后容器也将停止。当docker容器有成本时，超时在云基础设施上很有用。如果由于任何原因测试没有启动，slave将在超时后关闭。超时值应该比测试在执行期间不停止所需的时间大得多。
例如:timeout为1小时

```sh
docker run --rm \
-v ${PWD}/tests/projects/sample1/:/jmeter/project \
-e JMETER_JMX="test-plan.jmx" \
-e CONF_EXEC_TIMEOUT="3600" \
kamalyes/jmeter:latest
```

## Execute before-test.sh/after-test.sh only on master node

before-test.sh/after-test.sh在所有节点上执行，但是您可以在脚本文件中添加条件来测试是否应该执行代码块。
例如:timeout为1小时

```sh
   if [[ "$CONF_EXEC_IS_SLAVE" == "true" ]]; then
     # Slave block
     else
     # Master block
   fi

```

## Generate JTL, HTML report and log file

输出基本文件夹预先配置为`/jmeter/out`，您可以选择报告名称`JMETER_REPORT_NAME`将存储在`/jmeter/out/dashboard`中。
JTL文件名`JMETER_JTL_FILE`将存储在`/jmeter/out/jtl/`和jmeter日志文件(默认为jmeter.log)。
`JMETER_LOG_FILE`将存储在`/jmeter/out/log/`中。

```sh
docker run --rm \
-v ${PWD}/tests/projects/sample1/:/jmeter/project \
-e JMETER_JMX="basic-plan.jmx" \
-e JMETER_JTL_FILE=out.jtl \
-e JMETER_LOG_FILE=out.log \
-e JMETER_REPORT_NAME=myreport \
kamalyes/jmeter:latest
```

JTL file will be in `/jmeter/out/jtl/out.jtl`, report folder will be in `/jmeter/out/dashboard/myreport` and JMeter log will be in `/jmeter/out/log/out.log`

## Using additional raw JMeter parameter

传递给docker容器的参数最终会传递给JMeter，因此您可以使用任何附加参数
禁用RMI SSL，并添加自定义属性' numberthread '

```sh
docker run --rm \
-v ${PWD}/tests/projects/sample1/:/jmeter/project \
-e JMETER_JMX="basic-plan.jmx" \
-e JMETER_JTL_FILE=out.jtl \
-e JMETER_LOG_FILE=out.log \
-e JMETER_REPORT_NAME=myreport \
kamalyes/jmeter:latest -Jserver.rmi.ssl.disable=true -Jnumberthread=500
```

## Using raw JMeter parameter

预先配置的文件夹结构可以忽略，JMeter可以作为标准方式使用。
默认情况下会添加以下参数:

1. `--nongui` from `JMETER_DEFAULT_ARGS`
2. ' --jmeterlogfile /jmeter/out/log/jmeter.log' from value `JMETER_LOG_FILE`, if `JMETER_LOG_FILE` is empty or a custom `--jmeterlogfile` or `-j` to have new JMeter log file this arguments will be not add to JMeter.

```sh
docker run --rm \
-v ${PWD}/tests/projects/sample1/:/myproject \
kamalyes/jmeter:latest -t /myprojet/test.jmx -Jthread=50 -q /myproject/prop.properties
```

## Using wait to be Ready

容器可以启动并等待，直到准备就绪。
默认情况下会添加以下参数:

1. `--nongui` from `JMETER_DEFAULT_ARGS`
2. ' --jmeterlogfile /jmeter/out/log/jmeter.log' from value `JMETER_LOG_FILE`, if `JMETER_LOG_FILE` is empty or a custom `--jmeterlogfile` or `-j` to have new JMeter log file this arguments will be not add to JMeter.

```sh
docker run --name jmeter \
-e CONF_READY_WAIT_FILE="ready.txt" \
-e JMETER_JMX="basic-plan.jmx" \
 kamalyes/jmeter:latest

# Copy test to container
docker cp ${PWD}/tests/projects/sample1/basic-plan.jmx jmeter:/jmeter/project

# Start test by creation of file ready.txt
docker exec jmeter touch /jmeter/project/ready.txt

```

# Best Practice

1. 通过执行使用容器实例。
2. 在执行后强制退出容器，使用' JMETER_EXIT '在测试执行后强制远程退出。
3. 在容器有成本的环境中(如AWS Fargate, Azure容器实例，谷歌云运行)，并且存在JMeter不能正确停止的风险(由于任何原因，如slave启动但master失败，…)，使用超时执行' CONF_EXEC_TIMEOUT '在几秒钟内。注意，超时时间应该大于测试的最大持续时间。
4. 使用“JMETER_JVM_ARGS”调整JVM所需的内存，不要使用巨大的内存实例，最好使用最小的内存实例:小于8GB。
5. 始终使用属性来参数化测试(<https://jmeter.apache.org/usermanual/best-practices.html#parameterising_tests>)，这样您就可以保存多个预配置的属性文件，以便与' JMETER_PROPERTIES_FILES '一起使用。
