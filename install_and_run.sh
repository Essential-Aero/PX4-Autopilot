#/bin/bash

function install_dependencies {

	if [ -f "dependencies.log" ]; then
    		echo "starting gazebo"
	else
		sudo apt-get install python3-pip
		pip3 install -r requirements.txt
		./Tools/setup/ubuntu.sh
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
	sed -i.bak 's/-p.*/-p/g' ROMFS/px4fmu_common/init.d-posix/px4-rc.mavlink
	HEADLESS=1 make px4_sitl_default gazebo
else
	sed -i.bak "s/$var2/g" ROMFS/px4fmu_common/init.d-posix/px4-rc.mavlink
	HEADLESS=1 make px4_sitl_default gazebo
fi
