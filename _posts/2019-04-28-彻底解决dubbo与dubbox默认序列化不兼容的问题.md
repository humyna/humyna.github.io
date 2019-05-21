
> 本文主要解决了spring-boot项目引入dubbo官方提供starter暴露服务被dubbox客户端调用出现序列化不兼容的问题。
>
> 项目已开源，[项目地址](https://github.com/humyna/spring-boot-starter-dubbox)

```
近期公司业务发展需要需要基于spring-boot搭建一个新项目。
项目为了兼容公司旧技术栈需要对外暴露Dubbo服务，故引入了Dubbo的原生starter。
在测试过程中发现暴露服务被现有调用时出现序列化问题。
经查是Dubbox修改了Dubbo底层通讯序列化实现，导致无法进行反序列化。

先尝试使用@ImportResource引入Dubbox配置，不过还是因为项目启动时无法替换占位符而放弃。
原因是xml配置文件中使用了AnnotationBean，该bean类型为BeanFactoryPostProcessor，它会提前初始化dubbo的一些其他配置，又xml优先级比其他注解高导致在此AnnotationBean在初始化的时候PropertyPlaceholderConfigurer还未生效，最终导致AnnotationBean初始化dubbox配置失败，占位符未被替换。

我们知道原生Dubbo使用xml配置<dubbo:annotation />来开启注解配置，并提供com.alibaba.dubbo.config.annotation.Service注解进行服务注册，提供com.alibaba.dubbo.config.annotation.Reference注解进行服务注入。既然Dubbo支持使用JavaConfig方式进行服务的注册暴露及调用，那么可以从这入手来解决序列化兼容问题。实现思路参考：https://my.oschina.net/roccn/blog/847635

具体实现可以参考项目源码。
```

# spring-boot-starter-dubbox
## 使用方法

#### 一、发布jar至maven伺服
1. 下载工程代码
2. 修改pom.xml中添加你的私服配置
3. 然后执行mvn deploy，发布至仓库

#### 二、springboot工程暴露和调用dubbo服务

1. 工程pom.xml引入

```
<dependency>
	<groupId>info.zoio.spring</groupId>
	<artifactId>spring-boot-starter-dubbox</artifactId>
	<version>1.0.0</version>
</dependency>
```

2. 配置

* yml配置

```
spring:
  dubbo:
    application:
        name: app-demo
    registry:
      address: zookeeper://127.0.0.1:2181 #修改成your zk配置
    consumer:
      check: false
    provider:
      timeout: 90000
      token: false
      retries: 0
      actives: 30
      accepts: 1000
    protocol:
      id: dubbo
      name: dubbo
      payload: 83886080
      port: 0
      dispatcher: all
      threadpool: fixed
      threads: 1000
```
如果没有配置spring.dubbo.registry,系统会默认注册到127.0.0.1:2181上。

3. 服务调用
```
@org.springframework.stereotype.Component
@org.springframework.context.annotation.Profile({"dev","test","online"})
public class DubboReference {
	@com.alibaba.dubbo.config.annotation.Reference(group = "demo", version = "1.0.0", timeout = 60000, retries = 0)
	public DemoFacade demoFacade;
}
```

> 其中dev、test、online对应
>
> application-dev.yml
>
> application-test.yml
>
> application-online.yml

* 业务调用

```
@javax.annotation.Resource
private DubboReference dubboReference;

dubboReference.demoFacade.methodXXX();
```

4. 暴露服务

```
@org.springframework.stereotype.Component
@Service(version = "1.0.0",timeout = 10000,interfaceClass = ExportDemoFacade.class,group="demo")
public class ExportDemoFacadeImpl implements ExportDemoFacade {
	//TODO
}
```

#### 三、多注册中心&多协议配置说明
> 以下配置均经过测试，可放心使用！

1. 单注册中心配置示例

```
spring:
  dubbo:
 		registry:
      address: zookeeper://127.0.0.1:2181 #修改成your zk配置
```

2. 多注册中心配置示例

```
spring:
  dubbo:
		registry[0]:
			id: provider #务必填写id
			address: zookeeper://127.0.0.1:2181 #修改成你服务注册zk地址
		registry[1]:
			id: consumer1
			address: zookeeper://127.0.0.1:2181 #修改成服务提供者1zk地址
		registry[2]:
			id: consumer2
			address: zookeeper://127.0.0.1:2181 #修改成服务提供者2zk地址
		registry[3]:
			id: consumer3
			address: zookeeper://127.0.0.1:2181 #修改成服务提供者3zk地址
在启动参数中添加，使用逗号隔开
-Dspring.dubbo.provider.registry.ids=provider
-Dspring.dubbo.consumer.registry.ids=consumer1,consumer2,consumer3
```

3. provider多协议支持同多注册中心配置

```
spring:
  dubbo:
  	protocol[0]:
  		id: dubbo #务必填写

在启动参数中添加，使用逗号隔开
-Dspring.dubbo.provider.protocol.ids=dubbo
```
