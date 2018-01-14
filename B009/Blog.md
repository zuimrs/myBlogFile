>　　前面零零散散的介绍了环境配置，这里进行一下小结，一是将之前的各种配置按流程来一遍，看一下是否有纰漏，二是记录下网站的部署结构，为之后nginx+uWSGI+Django建站服务。

[toc]
#前言
　　此次主要任务是在服务器**/var/**文件夹下建立一个git空仓库托管网站源码，并在**/var/www/**建立项目文件夹以部署网站源码，如果无特殊说明，以下命令均在服务器端执行。
#主要流程
## 创建裸仓库
```Shell
    $ sudo -s       // 进入root模式
    $ git init --bare /var/git/website.git  
        // 在var/git/下初始化不含工作区的裸仓库
    $ chown -R git:git /var/git/
        // 修改拥有者和组为git
    $ chmod -R 777 /var/git/
        // 权限改为所有用户可读可写可执行
```
## 添加公钥
　　将服务器root用户公钥添加至git用户的**authorized_keys**中，使root用户可以使用git clone操作更新代码文件。
```Shell
    ......          // 仍为root模式
    $ cd /root      // 进入root目录
    $ ssh-keygen    // 为root生成密钥
    $ cat id_rsa.pub >> /home/git/.ssh/authorized_keys
```
　　root用户ssh登录git进行验证。
```Shell
    $ ssh git@localhost
```
![root用户ssh登录git][1]
　　之前关闭了git用户的ssh登录，所以无法进入git用户的shell.
## git clone
　　服务器端：
```Shell
    $ git clone git@localhost:/var/git/website.git \
            /var/www/com.域名.blog
        // git clone空仓库并指定项目名
```
　　建议使用[顶级域名.一级域名.二级域名]的命名方式,部署在**/var/www/**文件夹下，便于管理。
　　本地：
```Shell
    $ git clone git@服务器主机名或IP:/var/git/website.git 项目名
```
　　本地仅做开发和测试用途，项目存放到一个常用的文件夹下就好。
#结语
　　在本地进行开发，git push到服务器的git仓库中，并登录服务器的root用户进行git clone操作更新项目代码。

  [1]: https://github.com/zuimrs/myBlogFile/raw/master/B009/408cf91e9fb62305.png
