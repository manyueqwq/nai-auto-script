# nai-auto-script

#### An all in one script for NovelAI official frontend and backend.

## Usage

#### Teach you where to put this script.

[1] Put the auto.sh script under the official program folder. (Find it Yourself)

[2] Makesure you have Python >= 3.8, Python3 Pip, Nvidia Driver Installed.

[3] Try running these commands in your ssh to test [2].

```bash
$ /usr/bin/python --version
$ /usr/bin/pip --version
$ /usr/bin/nvidia-smi
```

[4] If they all shows up, you are all done.

[5] Check the command list to learn how to use this script.

#### [6] !!Importent: Buy me a cup of coffee ( :

## Command List

#### Teach you how to use this script.

[1] ./auto.sh all [none|cf|bore] - The All In One command.

##### It will finish the setup and start running, chose which proxy you want to use by select cf(CloudFlare Tunnel) or bore(Bore.pub) if you don't have a public ip address. Leave it blank to run only on local.

[2] ./auto.sh proxy [cf|bore] - Setup the proxy you choose.

##### Don't forget checking the script option, if you can't connect to GitHub.

[3] ./auto.sh setup - Just setup the NovelAI, an official script.

[4] ./auto.sh start - Just start the NovelAI, an official script.

## Script Options

#### Options in the script that can be changed.

[1] GitHubBoost - GitHub Address, Default: https://github.com

##### Some other proxies you can choose: https://ghproxy.com, https://gitclone.com, https://fastgit.org, https://gh.baiyi.icu (Mine)

[2] PipSource - Python Pip Repo

##### China boost proxy: https://pypi.tuna.tsinghua.edu.cn/simple from TUNA

## Troubleshoot

#### Bugs or errors.

[1] If you get this error message when running python venv, please add `--always-copy` after `virtualenv venv` in the setup function.

```bash
+ virtualenv venv
OSError: [Errno 38] Function not implemented: '/path/to/your/python' -> '/your/running/path/venv/bin/python'
```

```bash
# Setup Script
SetupScriptFun(){
	# Environment Setup
	pip install virtualenv
	set -ex
    	virtualenv venv --always-copy
	. venv/bin/activate
	pip install -r requirements.txt -i $PipSource
}
```
