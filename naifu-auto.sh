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
# Disable sentry logging
export ERROR_REPORTING=FALSE
#-----------------
# Do not reinstall existing pip packages on Debian/Ubuntu
export PIP_IGNORE_INSTALLED=0
#-----------------

# Run Script
RunScriptFun(){
	# Start Running
	# UNCOMMENT if you want the backend to automatically save files for you
	# export SAVE_FILES="1"
	export DTYPE="float32"
	export CLIP_CONTEXTS=3
	export AMP="1"
	export MODEL="stable-diffusion"
	export DEV="True"
	export MODEL_PATH="models/animefull-latest"
	# these aren't actually used by the site
	# export MODULE_PATH="models/modules"
	# unclear if these are used either
	# export PRIOR_PATH="models/vector_adjust_v2.pt"
	export ENABLE_EMA="1"
	export VAE_PATH="models/animevae.pt"
	export PENULTIMATE="1"
	export PYTHONDONTWRITEBYTECODE=1
	if [[ -f venv/bin/python ]]; then
		PYTHON=venv/bin/python
	else
		PYTHON=$PythonLocation
	fi
	$PYTHON -m uvicorn --host 0.0.0.0 --port=6969 main:app
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
