# 基于Springboot3 + Vue3的论坛前后端分离项目踩坑点

## ThreadLocal简化方法的参数传递

![image-20240201205629283](https://raw.githubusercontent.com/suzulang/typro-picgo/main/EveryDay/202402012056415.png)

```java
 public Result<User> userInfo(@RequestHeader(name = "Authorization") String token) {
        //根据用户名查询用户
        Map<String, Object> map = JwtUtil.parseToken(token);
        String username = (String) map.get("username");
        User u = userService.findByUserName(username);
        return Result.success(u);
 }
```

可以直接简化成

```java
    public Result<User> userInfo(){
        Map<String, Object> map = ThreadLocalUtil.get();
        String username = (String) map.get("username");
        User u = userService.findByUserName(username);
        return Result.success(u);
    }
```



## 用redis实现旧令牌登录失效



## element-plus + tailwindcsss导入方式

> tailwindcss

1. 安装包

   ```shell
   npm install -D tailwindcss@latest postcss@latest autoprefixer@latest
   ```

2. 初始化配置文件

   ```shell
   npx tailwindcss init -p
   ```

3. 在生成的配置文件tailwind.config.js中添加一行代码，扫描文件

   ```javascript
   purge: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
   ```

4. 在src下创建index.css文件

   ```css
   @tailwind base;
   @tailwind components;
   @tailwind utilities;
   ```

5. 在main.js下，引入.css文件

   ```javascript
   import './index.css'
   ```

> element-plus

1. 安装包

   ```shell
   npm install element-plus
   ```

2. 在main.js下，引入element-plus

   ```js
   import { createApp } from 'vue'
   import ElementPlus from 'element-plus'
   import 'element-plus/dist/index.css'
   import App from './App.vue'
   
   const app = createApp(App)
   
   app.use(ElementPlus)
   app.mount('#app')
   ```


## 前端向后端发请求时，接口的封装和统一处理

在script标签里面发axios请求的时候，每个页面里面重复的部分很多。

这时候如果login函数里，如果只需要调用一个服务函数就好了

```js
const login =async ()=>{
    //调用接口,完成登录
   let result =  await userLoginService(registerData.value);
}
```

在LoginService里面，发请求的时候，因为是表单格式的数据，所以需要

创建一个新的URLSearchParams实例

构造一个表单编码的格式（application/x-www-form-urlencoded）的查询字符串

然后直接调用一下request.post，这样只需要传后端接口路径和参数就可以了

```js
//提供调用登录接口的函数
export const userLoginService = (loginData)=>{
    const params = new URLSearchParams();
    for(let key in loginData){
        params.append(key,loginData[key])
    }
    return request.post('/user/login',params)
}
```

看看request.js里面，定制一个请求的实例，并暴露出去

```js
//定制请求的实例
//导入axios  npm install axios
import axios from 'axios';
const baseURL = 'http://localhost:8080';
const instance = axios.create({ baseURL })
export default instance;
```

在执行这一句`request.post('/user/login',params)`时，实际发生的是这样的

1. 使用 /user/login 作为URL路径发送一个POST请求。
2. 由于 instance 有一个 baseURL，所以实际的URL将是 baseURL + '/user/login'。
3. params 是一个 URLSearchParams 对象，它将被作为请求的 body 发送，并且 axios 会自动处理数据的编码。

这一句是关键`import request from '@/utils/request.js'`

所以这是一个实例，而不是类对象，这就解释了，为什么虽然request.js里面没有写post方法，但是可以调用request.post



## 跨域处理

首先明确：跨域问题由于浏览器同源策略限制的

![image-20240205184855168](https://raw.githubusercontent.com/suzulang/typro-picgo/main/EveryDay/202402051848389.png)

配置代理后：前端代理，发请求给后端

![image-20240205185003547](https://raw.githubusercontent.com/suzulang/typro-picgo/main/EveryDay/202402051850635.png)

1. 在前端项目中通过axios发ajax给后端的时候，在一个/api标识一下

   `http://localhost:5173/api`

2. 在vite中配置代理

   ```js
     server:{
       proxy:{
         '/api':{//获取路径中包含了/api的请求
             target:'http://localhost:8080',//后台服务所在的源
             changeOrigin:true,//修改源
             rewrite:(path)=>path.replace(/^\/api/,'')///api替换为''
         }
       }
     }
   ```

比如说`http://localhost:5173/api/user/register`

1. 把api前的改成`http://localhost:8080:/api/user/register`
2. 把api给去掉改成`http://localhost:8080/user/register`

## request.js文件做了什么？

做了一层很重要的封装。

```js
//添加响应拦截器
instance.interceptors.response.use(
    result => {
        //判断业务状态码
        if(result.data.code===0){
            return result.data;
        }

        //操作失败
        //alert(result.data.msg?result.data.msg:'服务异常')
        ElMessage.error(result.data.msg?result.data.msg:'服务异常')
        //异步操作的状态转换为失败
        return Promise.reject(result.data)
        
    },
    err => {
        //判断响应状态码,如果为401,则证明未登录,提示请登录,并跳转到登录页面
        if(err.response.status===401){
            ElMessage.error('请先登录')
            router.push('/login')
        }else{
            ElMessage.error('服务异常')
        }
       
        return Promise.reject(err);//异步的状态转化成失败的状态
    }
)
```

在这里， axios如果说正常请求后端的话，得到的响应结果是一个result。里面有很多属性

![image-20240205201901019](https://raw.githubusercontent.com/suzulang/typro-picgo/main/EveryDay/202402052019265.png)

重要的数据都在data属性里面，所以这一句是核心。这样的话，后面前端取响应数据的话，直接result.data就行了。不需要result.data.data来取数据了。

```js
        //判断业务状态码
        if(result.data.code===0){
            return result.data;
        }
```

## 前端环境搭建

初始化一个vue3项目`npm init vue@latest`





## 路由

1. 下载依赖`npm install vue-router`

2. 创建src/router/index.js

   ```js
   import {createRouter, createWebHistory} from "vue-router";
   import LoginVue from "@/views/Login.vue"
   const routes = [
       {path: '/', component: LoginVue}
   ]
   
   const router = createRouter({
       history: createWebHistory(),
       routes: routes
   })
   export default router
   ```

3. 在App.vue中添加`<router-view>`标签

4. 在main.js中使用路由

   ```js
   import './assets/main.css'
   
   import { createApp } from 'vue'
   import App from './App.vue'
   const app = createApp(App)
   import router from '@/router'
   app.use(router)
   app.mount('#app')
   ```

   

## 项目部署

因为用到了mysql和redis，所以后端的组成应该是mysql+redis+springboot3的镜像

前端是用nginx做web服务器，需要准备好nginx的.conf文件和静态资源目录

配置后端：

1. 创建一个网络，让mysql+redis+springboot3三者可以连通`docker network create demo`

2. 启动一个mysql容器，并且把它加入到demo这个网络中

   `docker run --name mysql-demo -p 3307:3306 --network demo -e MYSQL_ROOT_PASSWORD=123456 -d mysql` 

   启动完成后，用navicat测试一下是否启动成功了

3. 启动一个redis容器，并且把它加入到demo这个网络中

   `docker run --name redis-demo -p 6380:6379 --network demo -d redis`

​	用redis客户端测试下连接是否成功，不成功的话检查下防火墙

4. 修改springboot代码，做构建镜像前的准备

   1. application.yaml

      ```shell
      spring:
        datasource:
          driver-class-name: com.mysql.cj.jdbc.Driver
          url: jdbc:mysql://${db.host}:3306/nytd_forum
          username: root
          password: ${db.pw}
        profiles:
          active: dev #本地测试改成localhost
        data:
          redis:
            host: ${redis.host}
      ```

   2. 创建application-dev.yaml和application-local.yaml

      ```shell
      #application-dev.yaml
      db:
        host: mysql-demo #这里用容器名
        pw: 123456
      redis:
        host: redis-demo #这里用容器名
      ```

      ```shell
      #application-local.yaml
      db:
        host: localhost
        pw: 983003972
      redis:
        host: localhost
      ```

   3. 进行打包，并且创建Dockerfile

      ```dockerfile
      # 基础镜像
      FROM openjdk:17-jdk-alpine
      # 设定时区
      ENV TZ=Asia/Shanghai
      RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo "$TZ" > /etc/timezone
      
      # 拷贝jar包
      # 这里要注意前面是宿主机上的jar包的名字
      COPY nytd-forum-demo-0.0.1-SNAPSHOT.jar /app.jar 
      # 入口
      ENTRYPOINT ["java", "-jar", "/app.jar"]
      
      ```

      <img src="https://raw.githubusercontent.com/suzulang/typro-picgo/main/EveryDay/202402211045086.png" alt="image-20240221104526873" style="zoom:33%;" />

   4. cd到nytd-forum-demo目录下执行`docker build -t nytd-forum-demo .`构建镜像

      执行`docker run --name nytd-forum-demo -p 8090:8080 --network demo -d nytd-forum-demo` 启动容器

5. 最后用postman测试一下

   <img src="https://raw.githubusercontent.com/suzulang/typro-picgo/main/EveryDay/202402211058418.png" alt="image-20240221105840202" style="zoom:33%;" />

## 参数校验@Validation

1. 引入Spring Validation依赖
2. 在参数前加@Pattern注解
3. 在Controller上加@Validated注解

处理application/x-www-form-urlencoded格式数据的时候，可以直接在方法的参数列表里获取

```java
package com.example.demo1;

import com.example.demo1.model.User;
import jakarta.validation.constraints.Pattern;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping ("/user")
@Validated
public class UserController {

    @RequestMapping("/login")
    public String login(@Pattern(regexp = "^. {3,10}$") String username,
                        @Pattern(regexp = "^. {3,10}$") String password) {
        return username + password;

    }
}

```



处理JSON数据的时候要创建一个实例类

```java
package com.example.demo1.model;

import com.example.anno.PasswordAnno;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.groups.Default;
import lombok.Data;
import org.springframework.validation.annotation.Validated;

@Data
public class User {
    @Pattern(regexp="^.{3,10}$")
    private String username;
    @Pattern(regexp="^.{3,10}$")
    private String password;

}

```

使用@RequestBody注解，并且在参数列表上加上@Validate注解

```java
package com.example.demo1;

import com.example.demo1.model.User;
import jakarta.validation.constraints.Pattern;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/user")
@Validated
public class UserController {
    @RequestMapping("/login")
    public String login(@RequestBody @Validated User user){
        return user.getUsername() + user.getPassword();
    }
}

```



## 自定义校验

1. 添加依赖

   ```xml
           <dependency>
               <groupId>org.springframework.boot</groupId>
               <artifactId>spring-boot-starter-validation</artifactId>
           </dependency>
   ```

2. 创建注解类

   ```java
   package com.example.anno;
   
   import com.example.validation.PValidation;
   import jakarta.validation.Constraint;
   import jakarta.validation.Payload;
   
   import java.lang.annotation.*;
   
   @Documented
   @Target({ ElementType.FIELD })
   @Retention(RetentionPolicy.RUNTIME)
   @Constraint(validatedBy = {PValidation.class})
   public @interface PasswordAnno {
       String message() default  "密码只能是纯数字";
   
       Class<?>[] groups() default {};
   
       Class<? extends Payload>[] payload() default {};
   }
   
   ```

   3. 定义校验规则

      ```java
      package com.example.validation;
      
      import com.example.anno.PasswordAnno;
      import jakarta.validation.ConstraintValidator;
      import jakarta.validation.ConstraintValidatorContext;
      
      public class PValidation implements ConstraintValidator<PasswordAnno, String> {
          @Override
          public boolean isValid(String value, ConstraintValidatorContext constraintValidatorContext) {
              // 检查值是否为null
              if (value == null) {
                  return false;
              }
              // 使用正则表达式检查字符串是否只包含数字
              // 这个正则表达式表示：字符串只能由数字组成
              return value.matches("\\d+");
          }
      }
      
      ```

   

   

   ## 分组校验

   1. 定义分组

      ```java
          public interface Register extends Default {
      
          }
      ```

   2. 定义指定操作校验的字段

      ```java
          @NotNull(groups= Register.class)
          private String rePassword;
      ```

   3. 找到对应的方法，在@Validate注解上加上这个组

      ```java
          @RequestMapping("/register")
          public String register(@RequestBody @Validated(User.Register.class) User user){
              return user.getUsername() + user.getPassword() + user.getRePassword();
          }
      ```

      
