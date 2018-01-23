> 　　Django虽然自带一个Server，但只能作为开发时测试使用，我们需要一个可以稳定而持续的服务器对网站进行部署，比如Apache, Nginx, lighttpd等，本篇将利用nginx和uWSGI部署Django网站项目。

[toc]
# 前言
　　上篇我们安装好了nginx，uWSGI，并创建了Django的测试项目，本篇将修改nginx和uWSGI配置文件，使nginx作为Django项目的代理服务器。
![结构][1]
# 服务器Django+uWSGI+nginx配置（下）
　　nginx擅长处理静态文件的请求，我们把静态文件交给nginx，所以首先要建立静态文件文件夹，并把Django项目的静态文件转移到对应文件夹下。
## Django配置
### 部署静态文件
```Shell
    ...                     // root身份执行
    $ cd /var/www/com.test.blog
    $ mkdir static          // 静态文件文件夹
    $ mkdir media           // 媒体文件文件夹
```
　　编辑test_nginx/settings.py,添加：

    STATIC_ROOT = os.path.join(BASE_DIR, "static/")

　　进入env虚环境后，执行

    $ python manage.py collectstatic

## nginx配置
安装程序把nginx以服务的形式安装在系统中，相关的程序及文件路径如下。

 - 程序文件： /usr/sbin/nginx目录中.
 - 全局配置文件：/etc/nginx/nginx.conf
 - 访问日志文件：/var/log/nginx/access.log
 - 错误日志文件：/var/log/nginx/error.log
 - 站点配置文件：/etc/nginx/sites-enabled/default
### 删除软连接default文件
　　首先用vim看一下站点配置文件的内容：

![default文件][2]

　　nginx默认站点监听80端口，冲突，要修改端口或者删除文件，这样网站才能使用服务器的80端口。

![default文件软连接][3]

　　default实际上是一个指向nginx默认配置文件的一个软连接，所以直接删掉就好。
### 创建新的站点配置文件
```Shell
    ...                 \\ root身份执行
    $ pwd               \\ 当前目录
        /var/www/com.test.blog
    $ mkdir scripts     \\ 创建scripts文件夹，存放配置文件和脚本
    $ cd scripts        \\ 进入文件夹
    $ vim django.conf   \\ 创建配置文件
```
　　django.conf文件的内容如下：
```
# mysite_nginx.conf

# the upstream component nginx needs to connect to
upstream django {
    server 127.0.0.1:8001; # 使用8001端口与uWSGI服务器通信
}

# configuration of the server
server {
    # 监听80端口
    listen      80;
    # the domain name it will serve for
    server_name XXX.XXX.XXX.xxx; # 改为服务器IP
    charset     utf-8;

    # 允许上传最大文件尺寸
    client_max_body_size 75M;

    # Django media文件
    location /media  {
        alias /var/www/com.test.blog/test_nginx/media;  
    }
    # Django static文件
    location /static {
        alias /var/www/com.test.blog/test_nginx/static;
    }

    # 将动态请求交付给Django处理
    location / {
        uwsgi_pass  django;
        include     /var/www/com.test.blog/scripts/uwsgi_params; # the uwsgi_params file you installed
    }
}

```
　　这个配置文件告诉nginx提供来自文件系统的媒体和静态文件，以及处理那些需要Django干预的请求。
### 下载uwsgi_params
```Shell
    $ cd /var/www/com.test.blog/scripts
    $ wget https://github.com/nginx/nginx/raw/master/conf/uwsgi_params
```

### 创建配置文件软连接
```Shell
    ...                                         // root身份执行
    $ ln -s django.conf /etc/nginx/sites-enabled/
```
　　这样nginx在遍历site-enabled文件夹时就能看到网站的配置信息了。
### 测试nginx文件服务
　　在media文件夹下创建test.txt文件。
```Shell
    ...                                         // root身份执行
    $ cd /var/www/com.test.blog/test_nginx/media
    $ echo 'helloworld from media file' >> test.txt
                                                // 创建文件
```
　　重启Nginx服务。
```Shell
    $ service nginx restart
```
　　本地浏览器访问“IP/media/test.txt”,显示：
![测试nginx文件服务][4]
## uWSGI配置
### 使用nginx和uWSGI运行test.py测试
　　使用8001端口启动uWSGI服务器。
```Shell
    ...                                         // env虚环境
    $ pwd                                       // 当前目录
        /var/www/com.test.blog/test_nginx
    $ uwsgi --socket :8001 --wsgi-file test.py  // 启动uWSGI
```
　　本地浏览器访问“服务器IP”，显示：
![uWSGI test.py测试][5]
### 使用uwsgi和nginx运行Django应用
```Shell
    ...                                         // env虚环境
    $ pwd                                       // 当前目录
        /var/www/com.test.blog/test_nginx
    $ uwsgi --socket :8001 --module test_nginx.wsgi  // 启动uWSGI
```
　　本地浏览器刷新，显示Django欢迎界面：
![此处输入图片的描述][6]
### 使用ini配置文件启动
　　在scripts文件夹下创建uwsgi.ini,内容：
```Python
# uwsgi.ini file
[uwsgi]

# Django-related settings
# the base directory (full path)
chdir           = /var/www/com.test.blog/test_nginx
# Django's wsgi file
module          = test_nginx.wsgi
# the virtualenv (full path)
home            = /var/www/com.test.blog/env

# process-related settings
# master
master          = true
# maximum number of worker processes
processes       = 4
# the socket (use the full path to be safe
socket          = 127.0.0.1:8001
# ... with appropriate permissions - may be needed
# chmod-socket    = 664
# clear environment on exit
vacuum          = true
```
　　使用ini配置文件启动uWSGI服务器：
```Shell
    $ uWSGI --ini /var/www/com.test.blog/scripts/uwsgi.ini
```
### 使用Unix socket而不是端口
　　Unix socket比端口具有更少的开销，所以我们将8001端口修改为socket文件。
　　修改django.conf中的server行：
```Python
    ...
    # server 127.0.0.1:8001 改为
    server unix:///var/www/com.test.blog/mysite.sock;
    ...
```
　　修改uwsgi.ini:
```Python
    ...
    # the socket (use the full path to be safe
    socket          = /var/www/com.test.blog/mysite.sock
    # ... with appropriate permissions - may be needed
    chmod-socket    = 666
    ...
```
# 结语
　　熟悉了使用nginx和uWSGI部署默认的Django项目的流程，之后部署自己写的项目应该驾轻就熟了。
# 参考文献
 1. [使用uWSGI和nginx来设置Django和你的web服务器](http://uwsgi-docs-zh.readthedocs.io/zh_CN/latest/tutorials/Django_and_nginx.html)


  [1]: https://github.com/zuimrs/myBlogFile/raw/master/B014/bb7e171ff401b2e9.png
  [2]: https://github.com/zuimrs/myBlogFile/raw/master/B014/3f6ca1a84c70fa5e.png
  [3]: https://github.com/zuimrs/myBlogFile/raw/master/B014/00a511f28e6703eb.png
  [4]: https://github.com/zuimrs/myBlogFile/raw/master/B014/aa95b36ca656443d.png
  [5]: https://github.com/zuimrs/myBlogFile/raw/master/B014/86372900d771eb42.png
  [6]: https://github.com/zuimrs/myBlogFile/raw/master/B014/69cc13dd7b0fca03.png