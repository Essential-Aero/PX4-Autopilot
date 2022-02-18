#/bin/bash

function install_dependencies {

	if [ -f "dependencies.log" ]; then
    		echo "starting gazebo"
	else
		git submodule update --init --recursive
		sudo apt-get install -y python3-pip
		sudo apt-get install -y python-pip
		sudo apt-get install -y make
		pip3 install -r requirements.txt
		pip3 install --upgrade pip
		pip3 install --upgrade setuptools
		./Tools/setup/ubuntu.sh
		wget https://github.com/Kitware/CMake/releases/download/v3.18.2/cmake-3.18.2-Linux-x86_64.sh -O cmake.sh
		sudo sh cmake.sh --prefix=/usr --exclude-subdir
	fi

}

install_dependencies | tee dependencies.log

altitude=0
latitude=0
longitude=0
ip_address=""

while getopts t:n:a:i: flag
do
    case "${flag}" in
        t) latitude=${OPTARG};;
        n) longitude=${OPTARG};;
        a) altitude=${OPTARG};;
	i) ip_address=${OPTARG};;
    esac
done

export PX4_HOME_LAT=$latitude
export PX4_HOME_LON=$longitude
export PX4_HOME_ALT=$altitude

var1="-p.*/-p -t "
var2=$var1$ip_address

if [ -z "$ip_address" ];
then
	sed -i 's/-p.*/-p/g' ROMFS/px4fmu_common/init.d-posix/px4-rc.mavlink
	HEADLESS=1 make px4_sitl_default gazebo
else
	sed -i "s/$var2/g" ROMFS/px4fmu_common/init.d-posix/px4-rc.mavlink
	HEADLESS=1 make px4_sitl_default gazebo
fi
