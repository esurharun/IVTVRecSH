#!/bin/sh

# PROVIDE: channel4 
# REQUIRE: DAEMON
# KEYWORD: nojail 

CHANNEL=3
RECPATH=/diski4_1/TV/
#SETCHANNELCMD="/usr/local/bin/setchannel0 -g 352x240 -s"
#SETCHANNELCMD="/usr/local/bin/setchannel0 -g 480x480 -s"
#SETCHANNELCMD="/usr/local/bin/setchannel0 -g 352x480 -c"
#SETCHANNELCMD="/usr/local/bin/setchannel0 -g 720x480 -c"
SETCHANNELCMD="/usr/bin/v4l2-ctl -c video_bitrate=1350000  -c stream_type=4 -c audio_sampling_frequency=0 --set-input=1 --set-fmt-video=width=704,height=480 --device=/dev/video${CHANNEL}"


DATE=`date "+%Y%m%d_%H%M%S"`
TIME=`date "+%H%M%S"`
FILENAMEBASE=/var/run/channel${CHANNEL}
START_FILE=${FILENAMEBASE}.start
PID_FILE=${FILENAMEBASE}.pid
TEMP_FILE=${RECPATH}tmp.mpg
COMMAND="buffer -m 8192k -p 75 -i /dev/video${CHANNEL} -o ${TEMP_FILE}"


kill_processes()
{
	 	ps auwx | grep "${COMMAND}" | grep -v grep | awk '{ print $2 }' | awk '{ system( "kill  " $1 ) }'
} 

is_processes_alive() 
{
	AC=`ps auwx | grep "${COMMAND}" | grep -v grep | awk '{ print $2 }' | head -n 1`
	if [ ! -z ${AC} ] ; then
		echo "true"
	else
		echo "false" 
	fi
}

stop()
{
	echo "Stopping channel " ${CHANNEL} " ..."
	if [ `is_processes_alive` = "true" ]; then
		kill_processes
	fi
	if test -e ${START_FILE} ; then
        	START_TIME=`cat ${START_FILE}`
		REC_FILE="${RECPATH}/CH${CHANNEL}-${START_TIME}-${TIME}.mpg"	
		if test -e ${TEMP_FILE} ; then
			`mv ${TEMP_FILE} ${REC_FILE} >/dev/null`
		else
			echo "Temporary file is not found.."
		fi 
	
		if test -e ${START_FILE} ; then
			`rm ${START_FILE} >/dev/null`
		else
			echo "Startup file is not found.."
 		fi
	fi
	
	if [ `is_processes_alive` = "false" ]; then
		echo "Channel " ${CHANNEL} " stopped.."
	fi
}

start()
{
	sleep 2
 	 echo "Starting channel " ${CHANNEL} " ..." 
         ${SETCHANNELCMD}; 
	 (${COMMAND} ; /opt/recserver/mailer.sh "`date "+%m/%d %H:%M"` TV${CHANNEL} stopped") & 
         echo ${DATE} > ${START_FILE}
	 echo "Channel " ${CHANNEL} " started."
}

if [ ! -z "${1}" ]; then
	if [ ${1} = "start" ]; then
	 if [ `is_processes_alive` = "true" ]; then
		echo "Channel ${CHANNEL} is already recording"
	 fi
	 stop
	 start
	fi

	if [ ${1} = "stop" ]; then
	 if [ `is_processes_alive` = "false" ]; then
		echo "Channel ${CHANNEL} is not recording"
		exit 0
	 fi
	 stop 
        fi
fi


