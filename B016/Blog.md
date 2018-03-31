#加速pip下载：更换pip源
pip下载python包时默认使用国外源，下载比较慢，可以考虑替换为国内源。
## 临时修改

### 清华源
清华大学的pip源，它是官网pypi的镜像，每隔5分钟同步一次，推荐使用。
```
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple
	--trusted-host pypi.tuna.tsinghua.edu.cn packagename
```

### 豆瓣源
```
pip install -i http://pypi.douban.com/simple 
	--trusted-host pypi.douban.com packagename
```

### 阿里源

```
pip install -i http://mirrors.aliyun.com/pypi/simple/ 
	--trusted-host mirrors.aliyun.com/pypi/simple/ packagename
```
## 永久修改
修改**～/.pip/pip.conf**文件，如果没有就创建一个，写入如下内容（以清华源为例）：

```
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
trusted-host = pypi.tuna.tsinghua.edu.cn
```