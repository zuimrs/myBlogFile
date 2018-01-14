# python开源项目目录结构参考
转载：[http://www.cnblogs.com/holbrook/archive/2012/02/24/2366386.html](http://www.cnblogs.com/holbrook/archive/2012/02/24/2366386.html)
原作者：[心内求法](http://www.cnblogs.com/holbrook/archive/2012/02/24/2366386.html)

每个真正的程序员，可能都会梦想着能够发布开源项目，让自己的代码被别人所用。开源项目会发布到开发的版本管理系统（比如GitHub）上面，为了让大家能够方便使用你的代码，项目的目录结构应该遵循一定的规范。即使不是开源项目，项目目录结构符合一定的规范对你的项目管理也是有好处的。

下面列出python开源项目的通常目录结构及说明：
```shell
.tx/            如果你使用Transifex进行国际化的翻译工作，创建此目录
    config      Transifex的配置文件
$PROJ_NAME/     按照你实际的项目名称创建目录。如果有多个子项目，就创建多个目录
docs/           项目文档
wiki/           如果有wiki，可以创建此目录
scripts/        项目用到的各种脚本
tests/          测试代码
extras/         扩展，不属于项目必需的部分，但是与项目相关的sample、poc等，下面给出4个例子：
    dev_example/
    production_example/
    test1_poc/
    test2_poc/
.gitignore      版本控制文件，现在git比较流行
AUTHORS         作者清单
INSTALL         安装说明
LICENSE         版权声明
MANIFEST.in     装箱清单文件
MAKEFILE        编译脚本
README          项目说明文件，其他需要的目录下也可以放一个README文件，说明该目录的内容
setup.py        python模块的安装脚本
```
![example][1]
这个目录结构是针对python项目的，各种语言习惯的目录结构可能不同，但一些基本的要素还是共同的，可以举一反三。

------
全文完。


  [1]: https://github.com/zuimrs/myBlogFile/raw/master/B010/15fdb6f41b3711aa.png