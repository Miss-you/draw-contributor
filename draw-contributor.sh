#!/bin/bash

#1. 算每天对应的commit id
git checkout master
git log --pretty=format:"%H#%ci" | awk -F " " '{print $1}' | awk -F "#" '{print $2" "$1}' > commit-info.txt
#git log --pretty=format:"%H#%ci" | awk -F " " '{print $1}' | awk -F "#" '{print $2" "$1}' > commit-info.txt

rm -f filter-commit-info.txt
predata=""
precommit=""
# 过滤重复日期
while read line 
do 
#echo $line 
nowdate=`echo $line|awk -F ' ' '{print $1}'`
nowcommit=`echo $line|awk -F ' ' '{print $2}'`

if [[ "${predata}" != "${nowdate}" ]]; then 
    #echo "${predata} ${nowdate}"
    echo "${nowdate} ${nowcommit}" >> filter-commit-info.txt
    predata=$nowdate
fi
done < commit-info.txt

# 倒序
nl filter-commit-info.txt| sort -nr | cut -f2 > conv-filter-commit-info.txt

#2. 计算对应每天commit id的贡献者数量并输出
firstcommit=""
while read line 
do 
#echo $line 
nowdate=`echo $line|awk -F ' ' '{print $1}'`
nowcommit=`echo $line|awk -F ' ' '{print $2}'`
if [[ $firstcommit == "" ]]; then 
    firstcommit=$nowcommit
fi

cmd="git log $firstcommit $nowcommit"
usercnt=`git log $firstcommit $nowcommit | grep Author | sort -u | perl -pe 's/(.*?)<\/author>/$1 = $1 <$1\com>/' | awk -F "<" '{print $1}'|sort -u | wc -l`

echo "$nowdate $usercnt" >> contributor.txt

done < conv-filter-commit-info.txt

#3. 绘图

#git checkout -q 1aefe915f1a01ff7d068cfe7013676bfece2d43e
#git log | grep Author | sort -u | perl -pe 's/(.*?)<\/author>/$1 = $1 <$1\com>/' | awk -F "<" '{print $1}'|sort -u | wc -l
