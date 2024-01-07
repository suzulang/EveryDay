# 快速搭建一个Springboot增删改查的项目

依赖关系

```pom
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.7.17</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
    <!-- groupId 定义了项目属于哪个组或组织。改成你自己的。 -->
    <groupId>com.jiang</groupId>
    <!-- artifactId 定义了这个项目的具体名称，改成你自己的。 -->
    <artifactId>suzulang-blog</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <!-- name 改成别人能一眼看懂的，通常建议和artifactId相同。 -->
    <name>suzulang-blog</name>
    <!-- description 元素提供了对项目的简短描述。 -->
    <description>suzulang-blog</description>

    <properties>
        <java.version>17</java.version>
    </properties>
    <dependencies>
        <!-- Spring Boot Starter Web 用于构建Web应用程序 -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <!-- MySQL Connector/J 用于与MySQL数据库进行连接 -->
        <dependency>
            <groupId>com.mysql</groupId>
            <artifactId>mysql-connector-j</artifactId>
            <scope>runtime</scope>
        </dependency>

        <!-- Project Lombok，用于简化Java代码的生成 -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>

        <!-- Spring Boot Starter Test 用于编写测试用例 -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>

        <!-- MyBatis Plus Generator，用于生成MyBatis Mapper和Entity类 -->
        <dependency>
            <groupId>com.baomidou</groupId>
            <artifactId>mybatis-plus-generator</artifactId>
            <version>3.5.3.2</version>
        </dependency>

        <!-- Apache Velocity Engine Core，用于MyBatis Plus Generator的代码生成模板 -->
        <dependency>
            <groupId>org.apache.velocity</groupId>
            <artifactId>velocity-engine-core</artifactId>
            <version>2.3</version> <!-- 请使用适合您项目的版本 -->
        </dependency>

        <!-- MyBatis Plus Boot Starter，用于集成MyBatis Plus到Spring Boot应用程序中 -->
        <dependency>
            <groupId>com.baomidou</groupId>
            <artifactId>mybatis-plus-boot-starter</artifactId>
            <version>3.5.3.2</version>
        </dependency>
    </dependencies>


    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <configuration>
                    <excludes>
                        <exclude>
                            <groupId>org.projectlombok</groupId>
                            <artifactId>lombok</artifactId>
                        </exclude>
                    </excludes>
                </configuration>
            </plugin>
        </plugins>
    </build>

</project>
```

代码生成器类

```java
package com.example;
import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.generator.FastAutoGenerator;
import com.baomidou.mybatisplus.generator.config.DataSourceConfig;
import com.baomidou.mybatisplus.generator.fill.Column;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
@SpringBootApplication
public class CodeGenerator implements CommandLineRunner {

    @Value("${spring.datasource.url}")
    private String url;

    @Value("${spring.datasource.username}")
    private String username;

    @Value("${spring.datasource.password}")
    private String password;

    public static void main(String[] args) {
        SpringApplication.run(CodeGenerator.class, args);
    }

    public void run(String... args) throws Exception {
        FastAutoGenerator.create(new DataSourceConfig.Builder(url, username, password))
                // 全局配置
                .globalConfig((scanner, builder) -> {
                    String projectPath = System.getProperty("user.dir");
                    builder.author(scanner.apply("请输入作者名称？"))
                            .outputDir(projectPath + "/src/main/java"); // 设置输出目录
                })
                .packageConfig((scanner, builder) -> builder.parent(scanner.apply("请输入包名？")))
                // 策略配置
                .strategyConfig((scanner, builder) -> builder.addInclude(getTables(scanner.apply("请输入表名，多个英文逗号分隔？所有输入 all")))
                        .controllerBuilder().enableRestStyle().enableHyphenStyle()
                        .entityBuilder().enableLombok().addTableFills(
                                new Column("create_time", FieldFill.INSERT)
                        ).build())
                .execute();
    }

    protected static List<String> getTables(String tables) {
        return "all".equals(tables) ? Collections.emptyList() : Arrays.asList(tables.split(","));
    }
}
```

yml文件

```yml
spring:
  datasource:
    url: jdbc:mysql://your_ip_address:port/db_name?useUnicode=true&useSSL=false&characterEncoding=utf8
    username: username
    password: password
    driver-class-name: com.mysql.cj.jdbc.Driver
  main:
    banner-mode: off
mybatis-plus:
  configuration:
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
  global-config:
    banner: false
logging:
  level:
    root: ERROR
    org.springframework: ERROR




```

