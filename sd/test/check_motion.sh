#!/bin/sh
# check for a new video file (which is created in case of motion detection)
# and if found, create the appropriate file for the http server


led() {
    # example usage :
    #    led -boff -yon
    # options :
    #    -bfast
    #    -bon
    #    -boff
    #    -yfast
    #    -yon
    #    -yoff

    # first, kill current led_ctl process
    kill $(ps | grep led_ctl | grep -v grep | awk '{print $1}')
    # then process
    /home/led_ctl $@ &

}

laststate="init"

echo "Starting: Motion Detection"
led -boff -bfast
echo "checking state..."
echo "LED: blue flashing"
echo $(date) > /home/hd1/record/newboot


cd /home/hd1/record/

while [ 1 -eq 1 ]
  do
    motion_file=$(find . -type f -name "*.mp4*" -mmin -1 | tail -1)
    echo "M="$motion_file
    echo $motion_file | sed "s/.\//record\//" > /home/hd1/test/http/motion
    led -boff -bfast
    echo "LED: Blue flashing"
    sleep 1
    if [ ! -z "$motion_file" ]; then
       echo "Motion detected wihin last minute"
       echo "LED: blue"
       led -boff -bon
       sleep 30
    else
       echo "no Motion detected"
       led -boff -yon
       echo "LED: yellow"
       sleep 5
    fi

done
