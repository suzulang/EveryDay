# Docker学习笔记

[toc]



## Docker常用命令

删除所有容器

```shell
docker rm -f $(docker ps -aq)
```





## Commit

从中央仓库拉取tomcat的官方镜像

```shell
docker pull tomcat
```

启动起来看看效果

```shell
docker run -it -p 9001:8080 tomcat
```

发现404，因为官方镜像太精简了，webapps目录应该有的内容在webapps.dist目录下

所以，把webapps.dist目录下的内容拷贝到webapps下

```shell
.../tomcat cp -r webapps.dist/* webapps 
```

再次访问服务器ip:9001，可以访问到欢迎页面了

> 每一次都这么搞，太烦了。我能不能自己弄个镜像，也可以作回滚用的自定义镜像？

执行以下命令，就可以创建自己的本地镜像了

```shell
docker commit -a="tianpei" -m="add tomcat welcome index.html" f2faf7d97976 my_tomcat:1.0
```

![image-20240130105314435](/Users/wyatt/Library/Application Support/typora-user-images/image-20240130105314435.png)

用my_tomcat:1.0拉个容器下来看看效果

```shell
docker run -it -p 9002:8080 my_tomcat:1.0
```

发现不需要执行cp命令，就可以访问到欢迎页面了

## nginx外挂配置

conf.d/default.conf

```shell
server {
    listen       80;
    listen  [::]:80;
    server_name  localhost;

    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    #location ~ \.php$ {
    #    root           html;
    #    fastcgi_pass   127.0.0.1:9000;
    #    fastcgi_index  index.php;
    #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
    #    include        fastcgi_params;
    #}

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}


```

/nginx.conf

```shell

user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
}

```

/html/index.html

/logs