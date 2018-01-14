[toc]

> 　　服务器有其他用途时，不同任务之间文件访问、软件运行可能会产生冲突，新建一个用户，使用独立的用户目录，与其他用户之间的任务间不容易发生冲突，建站的时候顺便温习一下linux的用户相关操作。
# Linux用户管理
## 新建用户
### useradd命令
　　useradd是一个ELF可执行程序，useradd会添加用户名，并创建和用户名相同的组名，但它并不在/home目录下创建基于用户名的目录,也不提示创建新的密码。
　　如果不添加option参数，则建立的用户不含有home目录、系统shell和密码。

    $ sudo useradd [option] username

可选参数：

- option
 - -c comment 指定一段注释性描述。
 - -d 目录 指定用户主目录，如果此目录不存在，则同时使用-m选项，可以创建主目录。
 - -g 用户组 指定用户所属的用户组。
 - -G 用户组，用户组 指定用户所属的附加组。
 - -s Shell文件 指定用户的登录Shell。
 - -u 用户号 指定用户的用户号，如果同时有-o选项，则可以重复使用其他用户的标识号。
- username
 新添加的用户名。

### adduser命令
　　Ubuntu系统中，adduser是一个perl脚本, 可以交互式地设定一些用户参数，而且会生成用户home目录。

    $ sudo adduser username

　　这里我们使用adduser命令添加一个名为web的用户，按照提示可以设置用户登录密码和其他相关信息。
![adduser命令截图][1]
## 删除用户
　　如果一个用户的账号不再使用，可以从系统中删除。删除用户账号就是要将/etc/passwd等系统文件中的该用户记录删除，必要时还删除用户的主目录。
　　删除一个已有的用户账号使用userdel命令，其格式如下：

    # userdel [option] username

　　常用的选项为**-r**，将用户目录一起删除。

## 添加到sudo组
　　将用户username添加到sudo组获得管理员权限。

    # usermod -aG sudo username

　　这里我们把刚创建的web用户添加到sudo组。

    # usermod -aG sudo web

　　切换到web用户，使用sudo命令如果有警告信息，如下：
> sudo: unable to resolve host Server

　　才发觉之前修改hostname后忘记顺便修改/etc/hosts,使机器的反解出现问题，所以修改hosts文件替换原主机名为现在的主机名, 让主机名可以解回127.0.0.1 的IP 即可。
# 结语
　　之后与网站相关的操作在web用户下进行，所以还需要将ubuntu用户home目录下的**~/.ssh/authorized_keys**公钥复制到web用户目录下，并修改所有者为web用户，这样之后我们在本地可以ssh登录到web用户了。

    $ sudo cp /home/ubuntu/.ssh/authorized_keys ~/.ssh/
$ sudo chown web ~/.ssh/authorized_keys

![此处输入图片的描述][2]
# 参考链接
 1. [Linux 用户和用户组管理](http://www.runoob.com/linux/linux-user-manage.html)
 2. [Ubuntu中useradd和adduser的区别](http://os.51cto.com/art/201104/256231.htm)
 3. [ubuntu为用户增加sudoer权限的两种方法](http://www.cnblogs.com/jiangz/p/4183461.html)


  [1]: https://github.com/zuimrs/myBlogFile/raw/master/B006/8be5a7c3494592ea.png
  [2]: https://github.com/zuimrs/myBlogFile/raw/master/B006/efe1a3cf28806ca4.png