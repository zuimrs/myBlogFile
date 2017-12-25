>　　当你拥有一台服务器和一个已经备案的域名之后，你就可以着手服务器相关设置了。

[toc]
# 系统安装
　　打开官方提供的控制台界面，找到所购买的服务器，在右侧“操作”——“更多”下点击“重装系统”。
　　弹出如下界面。
![系统安装][1]
　　我选择公共镜像的Ubuntu 16.04 64位的长期支持版作为运行系统，当然如果你更熟悉其他Linux发行版的话，可以选择你熟悉的系统。
　　注：不推荐windows。
# 登录设置
## 用户帐号密码登录
![密码设置][2]
　　比较简单，不再赘述，记得记住你刚才敲的一串密码就好。
## ssh登录
　　[关于SSH：wiki](https://zh.wikipedia.org/wiki/Secure_Shell)
　　简而言之，ssh登录通过一对密钥认证你的身份，省去了每次远程登录都要敲密码的繁琐步骤。
### 创建ssh密钥
　　![导航菜单][3]
　　点击“SSH密钥”，选择上方“创建密钥”，如下。
　　![创建密钥][4]
　　笔者暂在windows下，暂时就命名为“ubuntu_win10”了。
　　![下载密钥][5]
　　点击下载密钥，保存在本地，服务器为你生成的私钥千万不能丢失（重要）。
### 设置为ssh登录
![ssh登录][6]
# 大功告成
　　点击“开始重装”，之后就等官方用邮件通知你系统重装完成啦。
![重装完成][7]


  [1]: https://github.com/zuimrs/myBlogFile/raw/master/B002/7ead16b919ea8c1a.png
  [2]: https://github.com/zuimrs/myBlogFile/raw/master/B002/e2efa60d1fff9c4f.png
  [3]: https://github.com/zuimrs/myBlogFile/raw/master/B002/8e9605a715ab2bac.png
  [4]: https://github.com/zuimrs/myBlogFile/raw/master/B002/c7e9d1cb3328ddd8.png
  [5]: https://github.com/zuimrs/myBlogFile/raw/master/B002/c5f94e48a091c3d2.png
  [6]: https://github.com/zuimrs/myBlogFile/raw/master/B002/2d94daec5e712e1c.png
  [7]: https://github.com/zuimrs/myBlogFile/raw/master/B002/2321f1ff350c790e.png