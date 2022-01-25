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

while getopts t:n:a: flag
do
    case "${flag}" in
        t) latitude=${OPTARG};;
        n) longitude=${OPTARG};;
        a) altitude=${OPTARG};;
    esac
done

export PX4_HOME_LAT=$latitude
export PX4_HOME_LON=$longitude
export PX4_HOME_ALT=$altitude

make px4_sitl_default gazebo
