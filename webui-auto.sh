#!/bin/bash

#-----------------
# Script Options
#-----------------
# GitHub Boost(Default: https://github.com)
# China: ghproxy.com, gitclone.com, fastgit.org, gh.baiyi.icu
GitHubBoost="https://github.com"
export GITHUBBOOST=$GitHubBoost
#-----------------
# Python Pip Source(Default: https://pypi.org/simple)
# China: https://pypi.tuna.tsinghua.edu.cn/simple(TUNA)
PipSource="https://pypi.org/simple"
export PIPSOURCE=$PipSource
#-----------------
# Python Binary Location
# Default: /usr/bin/python
# Command: which python
PythonLocation=$(which python)
#-----------------
# Python Pip Location
# Default: /usr/bin/pip
# Command: which pip
PipLocation=$(which pip)
#-----------------
# Nvidia-SMI Location
# Default: /usr/bin/nvidia-smi
# Command: which nvidia-smi
SmiLocation=$(which nvidia-smi)
#-----------------
# Commandline arguments for webui.py
export COMMANDLINE_ARGS=""
#-----------------
# Disable sentry logging
export ERROR_REPORTING=FALSE
#-----------------
# Do not reinstall existing pip packages on Debian/Ubuntu
export PIP_IGNORE_INSTALLED=0
#-----------------
# git executable
export GIT="git"
#-----------------
# script to launch to start the app
export LAUNCH_SCRIPT="launch.py"
#-----------------
# Fixed git repos
#export K_DIFFUSION_PACKAGE=""
#export GFPGAN_PACKAGE=""
#-----------------
# Fixed git commits
#export STABLE_DIFFUSION_COMMIT_HASH=""
#export TAMING_TRANSFORMERS_COMMIT_HASH=""
#export CODEFORMER_COMMIT_HASH=""
#export BLIP_COMMIT_HASH=""
#-----------------

# Run Script
RunScriptFun(){
    if [[ -f venv/bin/python ]]; then
        PYTHON=venv/bin/python
    else
        PYTHON=$PythonLocation
    fi
    $PYTHON "launch.py"
}

# Setup Script
SetupScriptFun(){
    # Environment Setup
    $PipLocation install virtualenv
    set -ex
    virtualenv venv
    . venv/bin/activate
    $PipLocation install -r requirements.txt -i $PipSource
}

# Install Cloudflared
    InstallCloudflaredFun(){
    curl -Lo /usr/bin/cloudflared $GitHubBoost/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 && chmod +x /usr/bin/cloudflared
    cloudflared version
    echo "Cloudflared Installed! Location: /usr/bin/cloudflared"
}

# Install Bore.pub
InstallBoreFun(){
    curl -Ls $GitHubBoost/ekzhang/bore/releases/download/v0.4.0/bore-v0.4.0-x86_64-unknown-linux-musl.tar.gz | tar zx -C /usr/bin
    bore --version
    echo "Bore.pub Installed! Location: /usr/bin/bore"
}

if [ -f $PythonLocation ] && [ -f $PipLocation ] && [ -f $SmiLocation ]
then

    # Install NovelAI Requirements Only
    if [ $1 == "setup" ]
    then
        echo "Installing NovelAI Requirements ..." && sleep 3s
        SetupScriptFun
    fi

    # Start NovelAI Only
    if [ $1 == "start" ]
    then
        echo "Starting NovelAI ..." && sleep 3s
        RunScriptFun
    fi

    # Run Command Proxy
    if [ $1 == "proxy" ] && [ -z $2 ]
    then
        echo "[cf|bore]"
    fi

    # Run Or Install Cloudflared
    if [ $1 == "proxy" ] && [ $2 == "cf" ]
    then
        if [ -f /usr/bin/cloudflared ]
        then
            echo "Starting Cloudflared ..." && sleep 3s
            cloudflared tunnel --url localhost:6969
        else
            echo "Installing Cloudflared ..." && sleep 3s
            InstallCloudflaredFun
            echo "Starting Cloudflared ..." && sleep 3s
            cloudflared tunnel --url localhost:6969
        fi
    fi

    # Run Or Install Bore.pub
    if [ $1 == "proxy" ] && [ $2 == "bore" ]
    then
        if [ -f /usr/bin/bore ]
        then
            echo "Starting Bore.pub ..." && sleep 3s
            bore local 6969 --to bore.pub
        else
            echo "Installing Bore.pub ..." && sleep 3s
            InstallBoreFun
            echo "Starting Bore.pub ..." && sleep 3s
            bore local 6969 --to bore.pub
        fi
    fi

    # Auto Setup Install Proxy And Start NovelAI
    # Not Using Proxies [Default]
    if [ $1 == "all" ] && [ -z $2 ]
    then
        echo "Installing NovelAI Requirements ..." && sleep 3s
        SetupScriptFun
        echo "Starting NovelAI ..." && sleep 3s
        RunScriptFun
    fi
else
    echo "PreInstall Check Failed! [Python|Pip|Nvdia-SMI]"
fi

