#!/bin/bash
#-----------------
# Blog.BaiYi.ICU
#-----------------

#-----------------
# Script Options
#-----------------
# GitHub Boost(Default: https://github.com)
# China: ghproxy.com, gitclone.com, fastgit.org, gh.baiyi.icu
GitHubBoost="https://github.com"
#-----------------
# Python Pip Source(Default: https://pypi.org/simple)
# China: https://pypi.tuna.tsinghua.edu.cn/simple(TUNA)
PipSource="https://pypi.org/simple"
# Disable sentry logging
export ERROR_REPORTING=FALSE
# Pretty print
delimiter="################################################################"
if [[ $(id -u) -eq 0 ]]
then
    printf "\n%s\n" "${delimiter}"
    printf "\e[1m\e[31mERROR: This script must not be launched as root, aborting...\e[0m"
    printf "\n%s\n" "${delimiter}"
    exit 1
else
    printf "\n%s\n" "${delimiter}"
    printf "Running on \e[1m\e[32m%s\e[0m user" "$(whoami)"
    printf "\n%s\n" "${delimiter}"
fi
