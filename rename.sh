#!/bin/zsh
for f in $(find ./img -iname "*.png"); do
  # 计算MD5值，并赋予一个变量
  a=$(md5sum $f)
  # 复制文件
  cp $f ./B006/${a:1:16}.png
done