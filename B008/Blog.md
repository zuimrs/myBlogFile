> 　　建一个类似博客之类的网站，项目代码文件和之后你更新的博文文件都存储在服务器上，文件的交互虽然可以通过带ui的文件传输工具或者命令行的scp等命令方便的实现，但笔者想搭建一个git服务器，实现本地与远程项目更方便的同步。

[toc]
# 前言
　　github的仓库虽然可以提供稳定的服务，但是如果你不想公开你的源码又不想交保护费的话，就可以用自己的服务器搭建一个Git私有仓库。
# 搭建git服务器
　　如果不特殊说明，笔者在服务器端的命令都是通过ssh到服务器主机的拥有sudo权限的用户执行。
## 服务器端安装git

    $ sudo apt install git

## 服务器端添加git用户

    $ sudo adduser git

　　git用户需要自己的home目录，方便起见我们用adduser命令添加（linux下用户管理戳[这里](http://blog.csdn.net/zuimrs/article/details/78917898)）。

![创建git用户][1]

## 本地创建密钥对
　　如果本地的**~/.ssh/**文件夹下有曾经生成过的密钥对id\_rsa 和 id\_rsa.pub文件，可直接使用，否则运行以下命令：

    $ ssh-keygen
　　方便起见，配置时一直回车，按默认选项配置。

![创建密钥对][2]

## 本地公钥导入服务器
　　本地运行

    $ scp ~/.ssh/id_rsa.pub 用户名@主机名:~/

　　将本地公钥复制到服务器可以通过ssh访问的用户的home目录下。
![scp上传公钥][3]
　　注意，如果用户名为git会提示:
>  Permission denied (publickey).

　　因为git用户的**~/.ssh/authorized_keys**里并没有本地主机的公钥，无法使用ssh和scp操作,暂时把公钥文件放到web用户（上篇博文创建）的home目录下。
　　通过ssh登录，并将刚才的id\_rsa.pub文件添加到**~/.ssh/authorized\_keys**里。
```shell
$ su - git
$ mkdir .ssh
$ cat /home/web/id_rsa.pub >> authorized_keys
```
　　此时可以在本地主机通过ssh命令登录git用户了。

## 禁用git用户的shell登录
　　为了安全，需要禁用git用户的shell登录，编辑服务器的**/etc/passwd**文件：

　　找到
> git:x:1001:1001:,,,:/home/git:/bin/bash

　　改为
> git:x:1001:1001:,,,:/home/git:/usr/bin/git-shell

## 初始化git仓库
　　通过ssh登录服务器，在一个合适的位置建立一个空仓库，先假设建立在某个用户的home目录下，名字为example。
```shell
$ cd /home/用户名/
$ sudo git init --bare example.git
```
　　Git就会创建一个裸仓库，裸仓库没有工作区，因为服务器上的Git仓库纯粹是为了共享，所以不让用户直接登录到服务器上去改工作区，并且服务器上的Git仓库通常都以.git结尾。

　　将仓库的拥有者改为git。

    $ sudo chown -R git:git example.git

## 测试仓库
　　本地运行

    $ git clone git@主机名或主机IP:/home/用户名/example.git

![git测试][4]

##管理公钥
　　重复将不同主机的公钥添加到git服务器的**~/.ssh/authorized_keys**。

　　如果团队人多的话，可以使用Gitosis。
　　[github链接:Gitosis](https://github.com/res0nat0r/gitosis)

# 结语
　　在服务器上添加git用户并搭建git服务器，以后网站的代码文件可以直接push到服务器上，免去了git clone的麻烦，静态文件也更方便同步。
# 参考链接
 1. [搭建git服务器](https://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000/00137583770360579bc4b458f044ce7afed3df579123eca000)


  [1]: https://github.com/zuimrs/myBlogFile/raw/master/B008/89a2e58cf1850ae5.png
  [2]: https://github.com/zuimrs/myBlogFile/raw/master/B008/45793031f4a13068.png
  [3]: https://github.com/zuimrs/myBlogFile/raw/master/B008/69a13ca001147c9c.png
  [4]: https://github.com/zuimrs/myBlogFile/raw/master/B008/b35c3ae05c739935.png