# Linux 上的常用文件传输方式介绍与比较
转载：[https://www.ibm.com/developerworks/cn/linux/l-cn-filetransfer/](https://www.ibm.com/developerworks/cn/linux/l-cn-filetransfer/)
原作者：李 梅雯, 孙 敏, 郭 聪宾

[toc]
## ftp
　　ftp 命令使用文件传输协议（File Transfer Protocol, FTP）在本地主机和远程主机之间或者在两个远程主机之间进行文件传输。

　　FTP 协议允许数据在不同文件系统的主机之间传输。尽管这个协议在传输数据上提供了高适应性，但是它并没有尝试去保留一个特定文件系统上的文件属性（例如一个文件的保护模式或者修改次数）。而且 FTP 协议很少对一个文件系统的整体结构作假定，也不提供这样的功能，比如递归的拷贝子目录。在使用 ftp 命令时，需要注意 FTP 协议的这些特性。当需要保留文件属性或者需要递归的拷贝子目录时，可以使用 rcp/scp 等命令。
### 基本语法
　　ftp 命令的一般格式如下：

    $ ftp 主机名 /IP

　　其中“主机名 /IP ”是所要连接的远程机的主机名或 IP 地址。在命令行中，主机名属于可选项，如果指定主机名，ftp 将试图与远程机的 ftp 服务程序进行连接；如果没有指定主机名，ftp 将给出提示符，等待用户输入命令：

    $ ftp 
    ftp >

　　此时在 ftp> 提示符后面输入 open 子命令加主机名或 IP 地址，将试图连接指定的主机。不管使用哪一种方法，如果连接成功，需要在远程机上登录。用户如果在远程机上有帐号，就可以通过 ftp 使用这一帐号并需要提供口令。在远程机上的用户帐号的读写权限决定该用户在远程机上能下载什么文件和能将上载文件放到哪个目录中。在远程站点上登录成功后，在“ ftp> ”提示符下可以自由使用 ftp 提供的各种子命令，最常用的子命令如下表所示。
　　表一：ftp 子命令

| 命令       | 描述   |
| --------   | -----  |
| ls	| 列出远程机的当前目录|
|cd	|在远程机上改变工作目录|
|lcd	|在本地机上改变工作目录|
|ascii	|设置文件传输方式为 ASCII 模式|
|binary	|设置文件传输方式为二进制模式|
|close	|终止当前的 ftp 会话|
|get (mget)	|从远程机传送指定文件到本地机|
|put (mput)	|从本地机传送指定文件到远程机|
|open	|连接远程 ftp 站点|
|quit	|断开与远程机的连接并退出 ftp|
|?	|显示本地帮助信息|
|!	|转到 Shell 中|
|prompt 1	|关闭交互模式|

### 使用实例
　　利用编写 ftp 脚本可以自动完成文件传输任务。具体方法是使用 ftp 命令的 -in 选项，并重定向 ftp 命令的输入。现在我们来编写一个利用 ftp 登录到远程服务器，并以 bin 的文件格式，在 /home 目录下，下载 file1.log 以及 file2.sh 至本机 /opt/ibm/，并从本地 /opt 目录上传文件 file3.jave 至远程服务器 /home 的自动化脚本。

```shell
ftp -ni <<+ 
     open $IP 
     user $USERNAME $PASSWD 
     bin 
     cd /home 
     lcd /opt/ibm 
     mget file1.log file2.sh 
     lcd /opt 
     mput file3.jave 
     ls 
     bye
```
## rcp
　　rcp 意为“ remote file copy ”（远程文件拷贝）。该命令用于计算机之间进行文件拷贝。其有两种格式。第一种格式用于文件到文件的拷贝；第二种格式用于把文件或目录拷贝到另一个目录中。
### 基本语法
```
$ rcp [-px] [-k realm] file1 file2 
$ rcp [-px] [-r] [-k realm] file directory
```
　　每个文件或目录参数既可以是远程文件名也可以是本地文件名。远程文件名具有如下形式：rname@rhost：path，其中 rname 为远程用户名，rhost 为远程计算机名，path 为该文件的路径。下表说明了 rcp 命令各个参数的含义。
表二：rcp 命令的命令行参数

| 选项       | 描述   |
| --------   | -----  |
|-r	|递归地将源目录中的所有内容拷贝到目的目录中。若使用该选项，目的须为一个目录。|
|-p	|试图保留源文件的修改时间和模式，忽略 umask 。|
|-k	|请求 rcp 获得在指定区域内的远程主机的 Kerberos 许可，而不是获得由 krb_relmofhost（3）确定的远程主机区域内的远程主机的 Kerberos 许可。|
|-x	|为传送的所有数据进行 DES 加密。这会影响响应时间和 CPU 利用率，但是可以提高安全性。|
　　如果在文件名中指定的路径不是完整的路径名，则该路径将被解释为相对远程机上同名用户的主目录。若没有给出远程用户名，则使用当前用户名。如果远程机上的路径包含特殊 shell 字符，需要使用反斜线（\）、双引号（”）或单引号（’）将其括起来，使所有的 shell 元字符都能被远程地解释。需要说明的是，rcp 不提示输入口令，它通过 rsh（remote shell）命令来执行拷贝。
###使用实例

将本地文件复制到远程登录目录中

    $ rcp <source> <remoteDir>

将多个本地文件复制到远程登录目录的子目录中

    $ rcp <source1> <source2> <source3> <subdirectory in remote system>

将多个文件从多个远程源复制到使用不同用户名的远程目标中

    $ rcp <host1.user1:source1> <host2.user2:source2> <dest.destuser:directory>
## scp
　　scp 命令在网络上的主机之间拷贝文件，它是安全拷贝（secure copy）的缩写。 scp 命令使用 ssh 来传输数据，并使用与 ssh 相同的认证模式，提供同样的安全保障。 scp 命令的用法和 rcp 命令非常类似，这里就不做过多介绍了。一般推荐使用 scp 命令，因为它比 rcp 更安全。

　　我们可以通过配置 ssh，使得在两台机器间拷贝文件时不需要每次都输入用户名和密码。
### 基本语法

    scp [-1246BCpqrv] [-c cipher] [-F ssh_config] [-i identity_file] 
             [-l limit] [-o ssh_option] [-P port] [-S program] 
             [[user@]host1:]file1 [...] [[user@]host2:]file2
　　使用 scp 命令，需要输入密码，如果不想每次都输入，可参考下面的方法。

　　首先生成密钥对

    $ ssh-keygen -t rsa 
    
     Generating public/private rsa key pair. 
     Enter file in which to save the key (/home/user/.ssh/id_rsa): 
     Created directory '/home/user/.ssh'. 
     Enter passphrase (empty for no passphrase): 
     Enter same passphrase again: 
     Your identification has been saved in /home/user/.ssh/id_rsa. 
     Your public key has been saved in /home/user/.ssh/id_rsa.pub. 
     The key fingerprint is: 
     10:66:da:38:85:8a:8c:bd:db:9c:6e:eb:ee:bd:7d:15 user@somehost

　　在这里，我们指定了生成 rsa 类型的密钥。在提示密钥的保存路径和密码时，可以直接回车使用默认路径和空密码。这样，生成的公共密钥保存在 **\$HOME/.ssh/id_rsa.pub**，私有密钥保存在 **\$HOME/.ssh/id_rsa** 。然后把这个密钥对中的公共密钥的内容复制到要访问的机器上的 **\$HOME/.ssh/authorized_keys** 文件中。这样，下次再访问那台机器时，就不用输入密码了。
### 使用实例
Copy 本地文件 /etc/eva.log, 到远程机器 sysB, 用户 user 的家目录下

    $ scp /etc/eva.log user@sysB:/home/user

copy 远程机器 sysB 上的文件 /home/uesr/eva.log, 到本地的 /etc 目录下 , 并保持文件属性不变

    $ scp -p user@sysB:/home/uesr/eva.log /etc

copy sysB 上的目录 /home/user， 到本地 /home/user/tmp

    $ scp -r user@sysB:/home/user /home/user/tmp
## wget
　　wget 是一个经由 GPL 许可的可从网络上自动获取文件的自由软件包。它是一个非交互式的命令行工具。支持 HTTP，HTTPS 和 FTP 协议，支持代理服务器以及断点续传功能。 wget 可实现递归下载，即可跟踪 HTML 页面上的链接依次下载来创建远程服务器的本地版本，完全重建原始站点的目录结构，实现远程网站的镜像。在递归下载时，wget 将页面中的超级链接转换成指向本地文件，方便离线浏览。由于非交互特性，wget 支持后台运行，用户在退出系统后，仍可继续运行。功能强大，设置方便简单。
### 基本语法

    $ wget [options] [URL-list]
　　wget 有很多不同的参数以用于远程站点信息的获取，常用参数如下，更多参数请参照 wget 帮助手册.
　　[wget 帮助手册](http://www.gnu.org/software/wget/manual/wget.html)

表三：wget工具常用参数

| 选项       | 描述   |
| --------   | -----  |
|-r	|递归下载服务器上所有的目录和文件。由 -l 选项来指定递归深度。
|-b	|后台下载
|-m	|制作站点镜像
|-c	|指定断点续传功能。该功能要求服务器支持断点续传。
|-I	|指定下载目录列表，可实现批量下载
|-A/-R	|指定接受／拒绝下载列表，实现选择性地下载
|--proxy=on/off	|指定是否利用代理服务器进行下载
|-t, --tries=NUMBER	|最大尝试链接次数 (0 表示无限制，默认为 20 次 )
|-nc, --no-clobber	|不覆盖已存在的文件
|-N, --timestamping	|只下载比本地新的文件
|-nd --no-directories	|不进行目录结构创建
|-x, --force-directories	|强制创建目录结构
|-nH, --no-host-directories	|不继承主机目录结构
|-P, --directory-prefix=PREFIX	|设置目录前缀

### 使用实例
　　递归下载 http://www.ibm.com.cn 站点的信息。下载所有显示完整网页所以需要的文件，如图片等。在下载不进行上层目录搜索并将绝对链接转换为相对链接。

    $ wget -r -p -np -k http://www.ibm.com.cn

　　将在本地硬盘建立 http://www.ibm.com.cn 的镜像，镜像文件存入当前目录下一个名为 www.ibm.com.cn 的子目录中（也可以使用 -nH 参数指定不建立该子目录，而直接在当前目录下建立镜像的目录结构），递归深度为 4，重试次数为无穷（若连接出现问题，wget 将永远重试下去，直至任务完成）

    $ wget -m -l4 -t0 http://www.ibm.com.cn

　　使用代理进行下载，并实现断点续传。代理可以在环境变量 PROXY 或 wgetrc 文件中设定。 -c 选项要求服务支持断点续传。

    $ wget -Y on -c http://www.ibm.com.cn

## curl
　　另一个可以用来进行文件传输的工具是 curl，它是对 libcurl 库的一个命令行工具包装。 libcurl 库中提供了相应功能的 API，可以在程序中调用。对于 libcurl 库的使用方法介绍超出了本文的讨论范围。 curl 使用 URL 的语法来传输文件，它支持 FTP, FTPS, HTTP, HTTPS, TFTP, SFTP, TELNET 等多种协议。 curl 功能强大，它提供了包括代理支持，用户认证，FTP 上载，HTTP post，SSL 连接，文件续传等许多特性。
### 基本语法

    $ curl [options … ] <url>
　　其中下载参数大约有 80 多个，curl 的各个功能完全依靠这些参数来完成。下面举例说明 curl 的一些基本用法。
### 使用实例
获取 GNU 的主页

    $ curl http://www.gnu.org

获取 GNU 的 FTP 服务器上根目录下的 README 文件

    $ curl ftp://ftp.gnu.org/README

从一个字典中获取 curl 的定义

    $ curl dict://dict.org/m:curl

如果需要指定用户名和密码的话，可以在 url 中指定，或者使用 -u 参数

    $ curl ftp://name:passwd@machine.domain:port/full/path/to/file

    $ curl -u name:passwd ftp://machine.domain:port/full/path/to/file

curl 会将从指定 url 处获取的内容打印到标准输出上。如果需要保存在本地文件中，可以使用 -o，或使用 -O 参数指定使用远程主机上的文件名（如果 url 中没有给出文件名的部分，则此操作将会失败）

    $ curl – o gnu.html http://www.gnu.org

    $ curl – O http://www.gnu.org/index.html

使用 -x 选项来使用代理进行连接

    $ curl -x my-proxy:port ftp://ftp.somesite.com/README

通过使用 curl 的 -T 选项来进行上载

    $ curl -T - ftp://ftp.upload.com/upfile

此命令从标准输入读取数据，并上载至远程 FTP 服务器上的 upfile 文件中。也可以指定上载一个本地文件

    $ curl -T localfile -a ftp://ftp.upload.com/upfile

其中 -a 参数表示以添加方式将 localfile 中的内容附加到 upfile 的末尾。

　　总的来说，curl 适合用来进行自动的文件传输或操作序列，它是一个很好的模拟用户在网页浏览器上的行为的工具。尤其当需要在程序中调用时，libcurl 是个很好的选择。
## rsync
　　rsync 是一款高效的远程数据备份和镜象工具，可快速地同步多台主机间的文件，其具有如下特性：

 - 支持链接、所有者、组信息以及权限信息的拷贝； 
 - 通过远程 shell（ssh, rsh）进行传输； 
 - 无须特殊权限即可安装使用；
 - 流水线式文件传输模式，文件传输效率高； 
 - 支持匿名操作；

　　需要提及的是 rsync 以其优越的性能优势区别于其它几种 Linux 文件传输方法，其同步文件的速度相当快，这主要归功于 rsync 所使用的传输算法。简而言之 rsync 算法能在相当短的时间内计算出需要备份的数据，只对源文件与目标文件的不同之处进行传输，从而降低网络中传输的数据量，以此达到快速备份镜像的目的。下面通过一典型应用场景来描述 rsync 算法的基本原理：主机 A 与主机 B 均有对同一文件的拷贝，用户对主机 A 上的拷贝进行更新，主机 B 通过 rsync 算法对更新后的文件进行同步。以下是该算法的实现步骤：

 1. 主机 B 将原始拷贝划分成大小为 N的不重合的若干块（文件末尾部分分块大小可能不足N），并对这些数据块进行两种不同方式的校验：32位的滚动弱校验、128 位的MD4强校验。弱校验较之强校验计算速度快。
 2. 主机 B 将每个数据块的弱校验、强校验结果发送给主机 A 。
 3. 主机 A 对更新后的文件拷贝中的每个长度为 N 的数据块进行弱校验并与从 B
接收到的弱校验值进行匹配，若相同再进行强校验匹配。由于弱校验的滚动特性可以快速地筛选出需要进行同步的数据块。该算法的运算量主要集中在主机A 上。
4. 通过上述计算，主机 A 将文件的不同部分发送给 B，B 接收到两个拷贝之间的不同之处，从而同步得到更新后的文件。
　　通过如上方式，rsync避免了对相同数据的传输，减少了网络带宽的浪费。在时间上整个过程中需一个往返，从某种程度上也保证了 rsync的优越性能。

　　用户可从官方网站 http://rsync.samba.org/ 上下载安装 rsync 的最新版本。使用时需将 rsync分别安装于服务端和客户端，服务端和客户端使用同一个 rsync 软件包来实现远程镜像和定期同步更新。需要说明的是一个 rsync 服务端可同时备份多个客户端的数据；多个服务端备份一个客户端的数据。 rsync 默认端口为 873，服务器在该端口接收客户的匿名或者认证方式的备份请求。

　　rsync 服务端在使用之前需要进行必要的配置，其配置文件为 /etc/rsyncd.conf，进行认证、访问、日志记录等控制。配置文件包括全局参数、模块参数的设置。 rsyncd.conf 文件中 [module] 之前的所有参数为全局参数，也可以在全局参数部分定义模块参数，在这种情况下该参数的值就是所有模块的默认值。全局参数设置程序使用的端口号，指定消息文件、日志文件 pid 文件以及发送日志消息的级别。模块参数主要定义服务端哪个目录需要被同步。用户可根据不同的需要指定多个模块，每个模块对应需要备份的一个目录树，即若有 N 个需要备份的目录树，则需要 N个模块与之对应。模块中可以定义许多参数，常见参数如下。

表四： rsyncd.conf 配置文件常见模块参数列表

| 选项       | 描述   |
| --------   | -----  |
|Comment	|模块信息描述，该描述连同模块名在客户连接得到模块列表时显示给客户。默认没有描述定义。
|Path	|指定供备份的目录路径，必须指定该参数。
|max connections	|指定最大并发连接数以保护服务器，超过限制的连接请求将被告知随后再试。默认值为 0，即没有限制。
|log file	|指定日志文件
|read only	|设定是否允许客户上载文件。若为 true 任何上载请求均会失败，若为 false 且客户端拥有服务器目录读写权限则可以上载。默认值为 true 。
|write only	|设定是否允许客户下载文件。若为 true 任何下载请求均会失败，默认值为 false 。
|List	|设定当客户请求可以使用的模块列表时，是否列出该模块。若为 false，则创建隐藏的模块。默认值为 true 。
|fake super	|允许文件享有所有权限，而无需后台服务以 root 权限进行操作。
|Filter	|设置过滤列表以决定哪些文件可由客户端访问。
|hosts allow	|指定允许客户连接的 IP 地址。可以为单个 IP 地址或整个网段。多个 IP 或网段需要以空格隔开。默认是允许所有主机连接。
|dont compress	|指定不进行压缩处理即可传输的文件，默认值是 *.gz *.tgz *.zip  *.z *.rpm *.deb *.iso *.bz2 *.tbz
|pre-xfer exec, post-xfer exec	|设置可在文件传输前／后执行的命令。若在文件传输前执行的命令失败，则取消本次传输操作。

###基本语法

 通过远程 shell 方式： 

    $ rsync [OPTION] [USER@]HOST:SRC DEST 

 使用远程 shell（如 ssh,rsh）实现将远程机器的内容拷贝到本地机器。 SRC 地址路径中以单个冒号 ":" 进行分隔。 

    $ rsync [OPTION] SRC [USER@]HOST:DEST 
使用远程 shell（如 rsh、ssh）实现本地机器的内容拷贝到远程机器。 DEST
地址路径中以单个冒号 ":" 进行分隔。 
通过 rsync daemon 方式： 

    $ rsync [OPTION] [USER@]HOST::SRC DEST 

或

    $ rsync [OPTION] rsync://[USER@]HOST[:PORT]/SRC [DEST] 
    
从远程 rsync 服务器中拷贝文件到本地机。 SRC 地址路径中以双冒号 "::" 进行分隔。 

    $ rsync [OPTION] SRC [USER@]HOST::DEST

或 

    $ rsync [OPTION] SRC rsync://[USER@]HOST[:PORT]/DEST 

从本地机器拷贝文件到远程 rsync 服务器中。 DEST地址路径中以双冒号 "::" 进行分隔。
　　如果 rsync 命令中只指定 SRC 参数而不指定 DEST 参数，则意为显示源文件列表而非进行同步拷贝。 rsync 有许多功能选项，常用的选项如下：

表五：rsync 常用参数

| 选项       | 描述   |
| --------   | -----  |
|-a, --archive	|归档模式，保持所有文件属性，等同于 -rlptgoD
|-v, --verbose	|详细信息输出
|-r, --recursive	|对子目录进行递归处理
|-R, --relative	|使用相对路径信息
|-b, --backup	|创建备份
|-z, --compress	|对备份的文件在传输时进行压缩处理
|--delete	|用于同步目录，从 DEST 中将 SRC 不存在的文件进行删除
|--progress	|显示备份过程

### 使用实例
- 查看服务端文件及列表

        # rsync 9.186.110.53::

    查看服务端可用的模块列表以及注释信息

        # rsync ibmuser@9.186.110.53::www/
    查看服务端 www 模块中的目录及文件列表（使用 rsyncd 用户认证方式）

        # rsync ibmuser@9.186.110.53:/var/www/html/
    查看服务端 /var/www/html 目录中的内容（使用服务端的系统用户进行验证，如 ibmuser）

- 保持客户端与服务端的数据同步

        # rsync -avz ibmuser@9.186.110.53::www/ /backup1/
    使用后台服务方式将服务端 www 模块下的内容备份到本地 /backup1 目录中，备份时保留原有权限、属性、属主及符号连接等，并使用压缩方式加快数据传输。

        # rsync – avz ibmuser@9.186.110.53:/var/www/html /backup2/
    使用 ssh 方式将远程的 /var/www/html 目录备份到本地 /backup2/ 目录下

        # rsync -avz --delete ibmuser@9.186.110.53::www/ /backup3/
    将远程 www 模块备份到本地 /backup3/ 目录中，同时进行同步目录，删除本地目录中多余的文件。

　　当服务端的数据出现问题时，需要通过客户端的数据对服务端进行恢复，只要客户端有服务端的写入权限，即可通过调换 rsync 命令的 SRC、DEST 参数进行恢复。

##结尾与总结
　　综上所述，各种文件传输方式的特征表现各有千秋，我们从以下几个方面综合对比，更深入地了解它们各自的特性。

- 传输性能
wget 通过支持后台执行及断点续传提高文件传输效率 ； rsync 则以其高效的传输及压缩算法达到快传输的目的。

- 配置难度
rcp 只需进行简单的配置，创建 .rhost 文件以及设置 /etc/hosts 文件中主机名与 IP 地址列表； wget 设置设置方便简单，只需在客户端指定参数执行命令即可； rsync 在使用前需要对服务端 /etc/rsyncd.conf 进行参数设定，配置内容相对复杂。

- 安全性能
ftp、rcp 不保证传输的安全性，scp、rsync 则均可基于 ssh 认证进行传输，提供了较强的安全保障。 wget 也可通过指定安全协议做到安全传输。

　　通过上述的对比不难发现，每种文件传输方法基于其自身的特点与优势均有其典型的适用场景：

 - ftp 作为最常用的入门式的文件传输方法，使用简单，易于理解，并且可以实现脚本自动化；
 - rcp 相对于 ftp
   可以保留文件属性并可递归的拷贝子目录；
 - scp 利用 ssh 传输数据，并使用与 ssh 相同的认证模式，相对于 rcp
   提供更强的安全保障； 
 - wget，实现递归下载，可跟踪 HTML
   页面上的链接依次下载来创建远程服务器的本地版本，完全重建原始站点的目录结构，适合实现远程网站的镜像；
 - curl，则适合用来进行自动的文件传输或操作序列，是一个很好的模拟用户在网页浏览器上的行为的工具；
 - rsync，更适用于大数据量的每日同步，拷贝的速度很快，相对 wget 来说速度快且安全高效。
　　读者可在不同的场合根据实际需要，选择适合的文件传输方法。

------
　　全文完。

