# Python|生成requirements.txt
> 　　在Python的开源项目中常见requirements.txt，用以记录项目的依赖包和对应的版本号，便于迁移和部署时环境的配置。

## 使用pip管理

　　结合使用Python虚环境，避免了pip导出项目不相关依赖包的缺点。

### 生成依赖
　　进入虚环境(env)，执行

    (env)$ pip freeze > ./requirements.txt
　　项目下生成依赖文件requirements.txt
### 安装依赖
　　其他主机或项目中执行：

    $ pip install -r ./path/requirements.txt
