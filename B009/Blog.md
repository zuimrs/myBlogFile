> 　　开发时，不同Python项目使用的框架可能依赖相同的库，但是对应版本不同，版本安装的不合适就会各种报错，非常蛋疼，又不能每次开发都来回安装对应的版本库，所以将不同项目的环境隔离开，使用各自的虚拟环境，解决包冲突问题。
　　virtualenv是Python多版本管理的利器,本节主要记录下virtualenv的安装和使用。

[toc]
# 前言
　　笔者比较穷，一台服务器可能要干好多活，所以开发环境和生产环境都要装一下virtualenv啦，如果生产环境的服务器只做搭建网站使用，则大可不必这样，直接配置目标环境就好。
# 安装virutalenv
## 通过apt安装
　　ubuntu用户可以直接通过apt进行安装。

    $ sudo apt install python-virtualenv

## 通过pip安装
　　如果没有pip的话，先安装并更新下pip吧。

``` shell
$ sudo apt install python-pip
$ sudo pip install -U pip
```
　　通过pip安装virtualenv：

    $ sudo pip install virtualenv

# virtualenv的使用
## 创建环境
### 常用命令
　　在当前目录下创建一个新环境目录（会复制系统已安装的第三方包）：

    $ virtualenv 环境名

　　在当前目录下创建一个新环境目录并指定Python版本为python2.7:

    $ virtualenv 环境名 --python=python2.7

　　在当前目录下创建一个不含第三方包的干净环境:

    $ virtualenv 环境名 --no-site-packages

### 其他
　　利用--help参数查看其他参数含义，这里就不赘述了。

    $ virtualenv --help

![virtualenv --help][1]

## 使用环境

    $ source 环境名/bin/activate

![env27虚拟环境][2]
如图，笔者创建了一个空的Python2.7环境，名为env27，使用source命令后，命令提示符改变，增加了(env27)前缀，表示当前环境是刚才配置的Python环境。


# 结语
　　因为笔者构想是用nginx+Django+uWSGI建站，所以django和uWSGI包就需要在虚环境下安装咯。

  [1]: https://github.com/zuimrs/myBlogFile/raw/master/B009/7ff00c22a8f308e6.png
  [2]: https://github.com/zuimrs/myBlogFile/raw/master/B009/3169793c9293c869.png