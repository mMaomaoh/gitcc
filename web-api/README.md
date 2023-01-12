# web-api

云枢应用脚手架工程 (Web API Spring Boot启动工程)

## 工程结构说明
```
├─db                    #部署SQL迁移脚本
├─lib                   #自行管理的jar包
├─main                  #主工程
│  ├─src 
│     ├─main
│        ├─java                                #源代码
│           ├─app   
│              ├─configuration                 #配置层
│              ├─controller                    #适配器层
│              ├─infrastructure                #基础设施层
│              └─WebApiBootStartupApplication  #程序入口类
├─modules               #拓展模块目录
│  ├─airack             #ai货架示例模块
│     ├─src 
│        ├─main
│           ├─java   
│              ├─application                   #应用层（业务服务）
│              ├─configuration                 #配置层
│              ├─controller                    #适配器层
│              ├─domain                        #领域层
│              └─infrastructure                #基础设施层
│  └─meeting            #会议系统示例模块
│     ├─src 
│        ├─main
│           ├─java   
│              ├─application                   #应用层（业务服务）
│              ├─configuration                 #配置层
│              ├─controller                    #适配器层
│              ├─domain                        #领域层
│              └─infrastructure                #基础设施层

```

* `src/main/resources/application-local.yml` 本地开发环境配置 (覆盖默认配置)

* `src/main/resources/application-prod.yml`  生产环境配置 (覆盖默认配置)

## 准备开发环境

1. JDK 8
2. Maven (3.6.x版本)
3. IntelliJ IDEA

## 使用帮助

### 打包

```shell
$ mvn clean package

Forces a check for missing releases and updated snapshots on remote repositories
$ mvn -U clean package
```

### 运行

* 通过Intellij IDEA 运行

通过IDEA 打开工程

选择启动主类运行

* 通过FatJar运行

```shell
$ mvn clean package
$ java -jar target/web-api-${version}.jar
$ java -Dspring.profiles.active=local -jar target/web-api-${version}.jar
$ java -Dspring.profiles.active=prod -Dserver.port=8090 -jar target/web-api-6.4.1-SNAPSHOT.jar
```

* 通过Spring Boot Maven插件运行

```shell
$ mvn clean install
$ mvn spring-boot:run -pl com.authine.cloudpivot:main
$ mvn spring-boot:run -Dspring-boot.run.arguments=--spring.profiles.active=prod -pl com.authine.cloudpivot:main
$ mvn spring-boot:run -Dspring-boot.run.arguments=--spring.profiles.active=prod,--server.port=8199 -pl com.authine.cloudpivot:main
```

```powershell
$ mvn spring-boot:run -D"spring-boot.run.arguments=--spring.profiles.active=local" -pl com.authine.cloudpivot:main
```
### 通过npm 运行常用命令

安装依赖(需要先安装Node.js)

```shell
$ npm install
```

打印命令列表:

```shell
$ npm run
```

如:

本地开发模式启动: `npm run local`

构建FatJar: `npm run build`

构建war包: `npm run build:war`
