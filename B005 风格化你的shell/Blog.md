>　　是否感觉Ubuntu默认的shell颜色单调,没有个性呢?不妨试一下oh_my_zsh吧,让你的终端随心所欲.

[toc]
# 前言
　　什么是oh_my_zsh呢?
>　　"Oh-My-Zsh is an open source, community-driven framework for managing your ZSH configuration. It comes bundled with a ton of helpful functions, helpers, plugins, themes, and a few things that make you shout..."

　　这是[官网](http://ohmyz.sh/)给出的定义,你只需要知道你能通过它,仅需要修改几行代码,就可以自定义你的shell配色,风格,体现个性.
　　![官网oh_my_zsh图片][1]

　　下面贴出oh_my_zsh官网和项目的github链接,大家觉得好的话可以去star一下.
　　[官网: http://ohmyz.sh/](http://ohmyz.sh/)
　　[github: https://github.com/robbyrussell/oh-my-zsh/](https://github.com/robbyrussell/oh-my-zsh/)
# 安装篇
 - 安装oh-my-zsh
 `$ sudo apt install zsh`
 `$ wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh`
 - 替换默认shell为zsh
 `$ chsh -s /bin/zsh`
 - 重启
 `$ sudo reboot`
# 主题篇
## 主题推荐
　　这是我常用的主题(具体出处忘了,但是挺好看的,贴一下地址吧):
　　　　[github: my zsh theme](https://github.com/zuimrs/my_zsh_theme/blob/master/.zshrc)
　　顺便贴一下官方的主题地址.
　　　　[github: oh-my-zsh themes](https://github.com/robbyrussell/oh-my-zsh/wiki/themes)
## 更换主题
- 如果你是通过自定义**~/.zshrc**文件设置主题的话,只需要运行
　　　`$ source ~/.zshrc`
- 如果你选择使用官方的主题,只需要修改原来的**~/.zshrc**文件,在前面加一行
　　　`ZSH_THEME=主题名`
然后再运行
　　　`$ source ~/.zshrc`
就可以看到最终效果了．

# 插件篇
　　oh-my-zsh提供的插件都可以在它的github里找到.
　　
　　[https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins)
　　
　　这个页面列出了所有支持的插件,点击可以跳转到插件的具体介绍.

![插件界面][2]
　　
　　部分插件带有wiki界面.

![git插件wiki][3]
## 安装插件
- 修改**~/.zshrc**文件,添加
　　`plugins=(插件1 插件2 插件3)`
- 运行
　　`$ source ~/.zshrc`
## 插件推荐
### git
　oh-my-zsh 默认开启的插件，提供了大量 git 的alias,缩短git命令长度.
　详细列表请参见：
　　[https://github.com/robbyrussell/oh-my-zsh/wiki/Plugin:git](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugin:git)
### autojump
　　根据你cd的历史纪录智能判断你想去到哪个目录．
### extract
　　通过一个命令**x**解压所有压缩文件,再也不用背参数了.
### emoji
　　显示emoji字符，你懂得.

# 结语
　　一个好用的，适合自己的个性化shell配置不仅赏心悦目，更是能提高你的开发效率，所以还在等什么呢？赶紧配置起来吧。

  [1]: http://ohmyz.sh/img/themes/eastwood.jpg
  [2]: https://github.com/zuimrs/myBlogFile/tree/master/B005/ea2365365183e511.png
  [3]: https://github.com/zuimrs/myBlogFile/tree/master/B005/d0654e7525ac7bc4.png