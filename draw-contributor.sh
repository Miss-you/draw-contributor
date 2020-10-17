#!/bin/bash

#1. 算每天对应的commit id
git checkout master
git log --pretty=format:"%H#%ci" | awk -F " " '{print $1}' | awk -F "#" '{print $2" "$1}' > commit-info.txt

#2. 计算对应每天commit id的贡献者数量并输出
#3. 绘图

#git checkout -q 1aefe915f1a01ff7d068cfe7013676bfece2d43e
#git log | grep Author | sort -u | perl -pe 's/(.*?)<\/author>/$1 = $1 <$1\com>/' | awk -F "<" '{print $1}'|sort -u | wc -l
