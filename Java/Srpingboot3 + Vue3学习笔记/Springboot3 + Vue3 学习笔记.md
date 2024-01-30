# Springboot3 + Vue3 学习笔记

[toc]

## @RestController和@Controller

当使用@Controller的时候，必须返回一个字符串，随后它会去找渲染模版。

```java
@Controller
@RequestMapping("/user")
public class UserController {
    @RequestMapping("/hello")
    public String hello(){
        return "hello"; // 返回的逻辑视图名称，需要有一个对应的hello.html模板
    }
}
```

必须存在/resources/template/hello.html

当使用@RestController的时候，可以返回String、json之类的

```java
@RestController
@RequestMapping("/user")
public class UserController {
    @RequestMapping("/hello")
    public String hello(){
        return "hello";
    }
    @RequestMapping("/json")
    public User json(){
        User user = new User();
        user.setUsername("张三");
        user.setPassword("123456");
        return user;
    }
}
@Data
class User {
    private String username;
    private String password;;
}
```

## yml配置

如果想所有的请求前面都加一个user的话可以这么配置

```yaml
server:
  port: 8080
  servlet:
    context-path: /path/user
```

对应的Controller类就可以简化了

```java
@RestController
public class UserController {
    @RequestMapping("/hello")
    public String hello(){
        return "hello";
    }
}
```

### 依赖注入

创建一个User类

```java
@Data
@Component
@ConfigurationProperties(prefix = "email")
public class User {
    private String username;
    private String password;
}
```

在Application类上加上注解

```java
@ConfigurationPropertiesScan
```

配置yml文件

```yaml
email:
  username: tianpei
  password: 983003972
```

1. 字段注入

   ```java
   @RestController
   public class UserController {
       @Autowired
       private User user;
       @RequestMapping("/yml")
       public String testYml(){
           return user.toString();
       }
   }
   ```

2. 构造器注入（推荐）

   ```java
   @RestController
   public class UserController {
       private User user;
       @Autowired
       public UserController(User user) {
           this.user = user;
       }
       @RequestMapping("/yml")
       public String testYml(){
           return user.toString();
       }
   }
   ```

用@Value注解进行注入

```java
@Data
@Component
public class User {
    @Value("${email.username}")
    private String username;
    @Value("${email.password}")
    private String password;
}
```

