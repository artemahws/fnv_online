#!/bin/bash
​
read -s -p "Please enter the password for sudo: " PW
SP="echo $PW"
SS="sudo -S"
PKGS="vim ntp htop openssh-server network-manager"
DCKRDEP="apt-transport-https ca-certificates curl gnupg-agent software-properties-common"
DCKRLINK="https://download.docker.com/linux/ubuntu/gpg"
DCKRREP="deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
DCKRPKGS="docker-ce docker-ce-cli containerd.io"
DCLINK="https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)"
DCOUT="/usr/local/bin/docker-compose"
FNVLINK="https://faceneurovision.com/wp-content/uploads/2019/04/fnv_pkg.tar.gz"
DOKNKEY="https://nvidia.github.io/nvidia-docker/gpgkey"
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
DOKNV="https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list"
LOGFILE="install.log"
​
echo '### Step 1/* - Preinstall ###'
$SP | $SS apt-get update -qqy && $SS apt-get dist-upgrade -qqy
$SP | $SS apt install -qqy $PKGS
echo '### Step 2/* - Docker dependencies ###'
$SP | $SS apt-get install -qqy $DCKRDEP
echo '### Step 3/* - Docker key ###'
$SP | $SS curl -fsSL $DCKRLINK | sudo apt-key add -
echo '### Step 4/* - Docker repository ###'
$SP | $SS add-apt-repository "$DCKRREP"
echo '### Step 5/* - Update ###'
$SP | $SS apt-get update -qqy
echo '### Step 6/* - Docker install ###'
$SP | $SS apt-get install -qqy $DCKRPKGS
echo '### Step 7/* - Docker privileges ###'
$SP | $SS usermod -aG docker $USER 
echo ' ### Step 8/* - Chmod for docker dir - ### Step 9/* - Docker-compose install ###'
$SP | $SS curl -L $DCLINK -o $DCOUT
$SP | $SS chmod +x $DCOUT
$SP | $SS chmod ug+s /usr/bin/docker
$SP | $SS chmod ug+s $DCOUT
echo '### Step 10/*'
$SP | $SS curl -s -L $DOKNKEY | sudo apt-key add -
$SP | $SS curl -s -L $DOKNV | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
$SP | $SS apt-get update
$SP | $SS apt-get install -qqy nvidia-docker2
$SP | $SS pkill -SIGHUP dockerd
echo '### Step 11/* - Logfile ###'
echo `date +%F_at_%H-%M-%S` > $LOGFILE 
$SP | $SS lsb_release -d >> $LOGFILE
$SP | $SS dmidecode -s system-product-name >> $LOGFILE
$SP | $SS lscpu | grep -i 'model name' >> $LOGFILE
$SP | $SS dmidecode -t memory | grep -i 'installed size' | grep -v Not >> $LOGFILE
# $SP | $SS nvidia-smi -L >> $LOGFILE
$SP | $SS docker -v >> $LOGFILE
$SP | $SS docker-compose -v >> $LOGFILE
$SP | $SS nvidia-docker -v >> $LOGFILE
echo '### Step 12/* - FNV download ###'
cd /home/$USER
$SP | $SS curl -L -O $FNVLINK
tar -xzf fnv_pkg.tar.gz
echo '### Step 13/* - Docker-compose configuring ###'
echo '''
​
​
​
​
​
​
    Start configure docker for FNV
    Please follow the installation instructions
​
​
​
​
​
​
'''
cd /home/$USER/fnv_pkg/utils
./configure_docker.sh
echo '### Step 14/* - FNV launching ###'
cd /home/$USER/fnv_pkg/docker
docker-compose up -d
docker ps