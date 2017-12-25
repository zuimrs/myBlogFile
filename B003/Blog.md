> 　　服务器端一切ok,接下来就该设置远程登录了,本篇主要以介绍Windows和Linux下的ssh登录为主,密码登录比较简单,不再过多赘述.

[toc]

标签（空格分隔）： 远程登录 ssh wincp shell
# Windows下配置
　　由于Windows自带的cmd和powershell我不是太熟悉,所以推荐给大家一款十分强大的,在Windows 环境下使用的 SSH 的开源图形化客户端"[WinScp](https://zh.wikipedia.org/wiki/WinSCP)",结合[PuTTY](https://zh.wikipedia.org/wiki/PuTTY)使用,可以十分方便的在本地与远程计算机间安全地复制管理文件和进行远程控制.
## WinScp＆PuTTY安装
　　[WinScp官方下载页面](https://winscp.net/eng/download.php)
　　建议下载Portable executables (7.2 MB; 6,516 downloads to date）绿色免安装版．
　　别忘了顺带下载底下的PuTTY Portable executable (0.7 MB)和PuTTYgen Portable executable (0.3 MB)，把他们放在一起．
## 通过WinScp进行密码登录
　　参照下方"配置SSH登录"的流程,只需要把密码填到对应的用户名之后就好,不再赘述.
## 通过WinScp进行SSH登录
### 密钥文件转换
　　腾讯云服务器提供给我们的私钥文件WinScp无法直接使用,需要首先进行转换.
　　点击"WinScp"左下角的工具.
　　缺图
　　点击运行PuTTYGen,界面如下图所示.
　　
　　![PuTTYGen界面][1]
　　
　　点击Load,加载之前从腾讯云下载的私钥文件．

　　![保存ppk格式文件][2]
　　
　　你可以修改Key comment区分不同私钥,而Key passphrase作为之后使用该私钥的凭证,为了安全性最好设置一个,当然也可以留空,没有太大影响.　　
　　之后点击"Save private key",将ppk格式的私钥文件保存到本地.　
### 配置SSH登录
　　点击"新建站点",文件协议选择SFTP,主机名填写你购买的服务器的公网IP地址,端口号22,用户名ubuntu,如下图所示.
　　![配置登录][3]
　　
　　点击"高级",并在"验证'里添加刚才生成的ppk私钥文件．
　　
　　![添加私钥文件][4]
　　
## 登录成功
　　点击登录，输入你的Keypasspharse,就可以看到ubuntu用户当前的目录了.
　　缺图
　　点击左上方打开"Putty",同样输入Keypassphrase或者用户名＋密码就可以使用命令行了.
　　![PuTTY命令行][5]

# Linux下配置
　　如果你是Linux用户,也可以通过简单的配置远程登录你的服务器.
　　笔者以Ubuntu 16.04为例(以下均为本地系统配置).
## 本地添加host记录
　　在一切开始之前,我们首先要编辑**/etc/hosts**,添加一条ip-主机名记录到主机名静态查询表并保存(不了解hosts文件的同学,可以点[这里](https://zh.wikipedia.org/wiki/Hosts%E6%96%87%E4%BB%B6)),hosts文件内容如下:

>　　127.0.0.1　　localhost
>　　XXX.XXX.XXX.XXX(公网ip)　　XXX(主机名)  <--(新添加记录）
>　　......

　　之后登录就不需要每次输入ip地址,只需要输入你设置的主机名就好.
## 安装ssh
　　Ubuntu已经默认安装了ssh client,否则使用
　　`sudo apt install openssh-client`
　　命令进行安装.
![安装ssh成功][6]
## 添加私钥
　　进入**~/.ssh**目录,将私钥文件首先复制到这里,并通过命令行修改私钥文件权限为400.

      chmod 400 ~/.ssh/私钥文件

　　创建**config**文件并输入以下内容并保存.

        Host 主机名
            HostName 主机名
            Port 22
            IdentityFile ~/.ssh/私钥文件

　　重启ssh服务.

          service ssh restart
　　若未修改私钥文件权限则会产生如下报错:

> @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@　　　WARNING: UNPROTECTED PRIVATE KEY FILE!　　　@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Permissions 0777 for '/home/XXX/.ssh/私钥文件' are too open.
It is required that your private key files are NOT accessible by others.
This private key will be ignored.
Load key "/home/XXX/.ssh/私钥文件": bad permissions
Permission denied (publickey).

## ssh登录
　　命令行输入:

        ssh ubuntu@主机名
　　若显示欢迎语句,则登录成功.
　　![ssh登录成功][7]

# 结语
　　因为之后在服务器系统上我们不再使用Ubuntu这个默认用户,所以在config里我并没有添加Username这一项,ssh登录时仍需要用"ssh 用户名@主机名"这种形式.
　　笔者只浅显的介绍了我们建站时可能用到的相关命令和配置,具体的ssh原理与应用读者感兴趣的话可以找相关资料深入研究.
　　本文如有错误,恳请各位读者不吝赐教.


　
　　
  [1]: https://github.com/zuimrs/myBlogFile/raw/master/B003/88164d0a4789b51c.png
  [2]: https://github.com/zuimrs/myBlogFile/raw/master/B003/0c368b7c7aa86c58.png
  [3]: https://github.com/zuimrs/myBlogFile/raw/master/B003/da7e58af423e4724.png
  [4]: https://github.com/zuimrs/myBlogFile/raw/master/B003/2ad5e647a4cfee0a.png
  [5]: https://github.com/zuimrs/myBlogFile/raw/master/B003/86e56ba68aca7f88.png
  [6]: https://github.com/zuimrs/myBlogFile/raw/master/B003/36831d6cd14eb868.png
  [7]: https://github.com/zuimrs/myBlogFile/raw/master/B003/866d4b974fd78f74.png
  [8]: https://github.com/zuimrs/myBlogFile/raw/master/B003/c22bb60735da3ffe.png
  [9]: https://github.com/zuimrs/myBlogFile/raw/master/B003/58a12d73e37520da.png
  [10]: https://github.com/zuimrs/myBlogFile/raw/master/B003/b07d1a11a0afd778.png
