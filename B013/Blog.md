> 　　Django虽然自带一个Server，但只能作为开发时测试使用，我们需要一个可以稳定而持续的服务器对网站进行部署，比如Apache, Nginx, lighttpd等，本篇将以 nginx + uWSGI + Django 为例。

[toc]
#前言
## nginx简介
　　nginx是一个HTTP服务器,也是一个反向代理服务器，由基础模块、核心模块、第三方模块构成，与Apache相比更轻量级，占用更少的内存及资源。
## WSGI/uWSGI/uwsgi区别
**WSGI（Python Web Server GateWay Interface）**: WSGI是一种Web服务器网关接口。它是一个Web服务器（如nginx）与应用服务器（如uWSGI服务器）通信的一种规范。由于WSGI的通用性，出现了独立的WSGI程序，例如uWSGI和Apacke的mod_wsgi。

**uWSGI**: 是一个Web服务器，它实现了WSGI协议、uwsgi、http等协议。用于接收前端服务器转发的动态请求并处理后发给 web 应用程序。

**uwsgi**: 是uWSGI服务器实现的独有的协议。
## nginx/uWSGI/Django项目工作流程
1. 用户通过浏览器发出http请求到服务器。
2. nginx负责接受外部http请求并进行解包，若请求是静态文件则根据设置好的静态文件路径返回对应内容。若请求是动态内容则将请求交给uWSGI服务器（nginx和uWSGI使用端口或socket通信）。
3. uWSGI服务器收到请求后，根据wsgi协议解析并回调Django应用。
4. Django应用则根据请求进行数据库增删查改和模版渲染等工作，然后再逆方向返回nginx。
5. nginx将响应交付用户浏览器。

# 服务器Django+uWSGI+nginx配置
　　前面[4.1小结](http://blog.csdn.net/zuimrs/article/details/79057988)，我们利用在**/var/www/**下git clone了一个空仓库，假设名为"**com.test.blog**"，实际上是一个进行了git初始化的空文件夹。
## 创建项目虚环境
```Shell
    $ sudo -s                       // 获得root权限
    $ cd /var/www/com.test.blog     // 进入项目文件夹
    $ virtualenv env --python=python2.7 \
                --no-site-packages  // 创建名为env的python空环境
```
　　如果产生如下报错，说明服务器语言未设置。
> locale.Error: unsupported locale setting

　　则先执行
```Shell
    $ export LC_ALL=C
```
　　后再次执行上述命令。
## Django部分
### 安装Django
　　启用env环境。
```Shell
    $ source env/bin/activate       // 启用环境
```
　　安装支持python2.7的Django 1.11。
```Shell
    $ pip install Django==1.11
    $ django-admin --version
```
### 创建一个Django默认项目用于测试
```Shell
    $ django-admin startproject test_nginx
                    // 创建名为“test_nginx”的Django项目
```
![Django 测试项目][1]
### 测试Django服务器
![Django Server][2]
　　进入./test_nginx/test_nginx，利用vim修改settings.py中的“ALLOWED_HOSTS”。
```python
    ...
    
        ALLOWED_HOSTS = ['*'] 
    
    ...
```
　　这样可以在本地直接利用服务器ip和端口访问网页了。
　　
　　运行Django Server(Ctrl + C 结束运行)。
```Shell
    $ pwd           // 当前路径
            /var/www/com.test.blog/test_nginx
    $ python manage.py runserver 0.0.0.0:8000
                    // 8000端口，启用Django服务器
```
　　本地浏览器输入"服务器IP:8000"，显示
![Django welcome页面][3]
## uWSGI部分 
### 安装uWSGI
　　在env虚拟环境下使用pip安装。
```Shell
    $ pip install uwsgi
    $ uwsgi --version       // 显示uwsgi安装版本
```
### 测试uWSGI服务器
　　新建test.py文件，内容如下：
```python
def application(env, start_response):
    start_response('200 OK', [('Content-Type','text/html')])
    return "Hello World from uWSGI"
```
　　终端运行：
```Shell
    $ uwsgi --http :8000 --wsgi-file test.py
```
　　本地浏览器刷新页面，显示
![uWSGI welcome页面][4]
### uWSGI+Django测试
![uWSGI+Django][5]
　　终端运行：
```Shell
    $ pwd
        /var/www/com.test.blog/test_nginx
    $ uwsgi --http :8000 --module test_nginx.wsgi
```
　　本地浏览器刷新页面，显示
![Django welcome页面][3]
## nginx部分
### 安装nginx
```Shell
    $ sudo apt install nginx
```
### nginx常用命令
启动nginx服务器

        $ sudo service nginx start
停止nginx服务器

        $ sudo service nginx stop
查看nginx服务的状态

        $ sudo service nginx status
重启nginx服务器

        $ service nginx restart
### 测试nginx服务器状态
　　启动nginx服务器后，本地浏览器输入"服务器IP:80"，如下图显示说明nginx工作正常。
![nginx welcome页面][6]


# 结语
　　服务器端nginx，uWSGI和Django彼此之间已经可以独立工作，下半篇将修改配置文件，真正使nginx作为Django网站项目的代理服务器。
# 参考文献
 1. [WSGI，uwsgi和uWSGI的区别](http://mode1943.blog.163.com/blog/static/792184362016118112349964/)
 2. [使用uWSGI和nginx来设置Django和你的web服务器](http://uwsgi-docs-zh.readthedocs.io/zh_CN/latest/tutorials/Django_and_nginx.html)


  [1]: https://github.com/zuimrs/myBlogFile/raw/master/B013/d7ed792ae24f133e.png
  [2]: https://github.com/zuimrs/myBlogFile/raw/master/B013/f63eacd0ae16d72c.png
  [3]: https://github.com/zuimrs/myBlogFile/raw/master/B013/f68507573e6c1052.png
  [4]: https://github.com/zuimrs/myBlogFile/raw/master/B013/1ce1d7531b26ed04.png
  [5]: https://github.com/zuimrs/myBlogFile/raw/master/B013/a0c82f9386f00613.png
  [6]: https://github.com/zuimrs/myBlogFile/raw/master/B013/633cdf5b55fdcd4f.png