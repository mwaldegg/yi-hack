#!/bin/sh
# each minute, check for a new video file (which is created in case of motion detection)
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


#mtime=1 #Search for Motion in last n Minutes


echo "Starting: Motion Detection"
led -boff -bfast
echo "Led: Blue flashing"
touch /home/hd1/record/lastboot


cd /home/hd1/record/

while [ 1 -eq 1 ]
  do
    motion_file=$(find . -type f -name "*.mp4" -mmin -1 | tail -1)
    echo "M="$motion_file
    echo $motion_file | sed "s/.\//record\//" > /home/hd1/test/http/motion
    if [ ! -z "$motion_file" ]; then
       echo "Motion detected wihin last minute"
       echo "LED: blue"
       led -boff -bon
       wget 'http://192.168.200.64:8080/remote?action=MONITORON'  -q > /dev/null 2&>1 #Enable MagicMirror
    else
       echo "no Motion detected"
       led -boff -yon
       echo "LED: yellow"
       wget 'http://192.168.200.64:8080/remote?action=MONITOROFF'  -q > /dev/null 2&>1 #Disable MagicMirror
    fi

    sleep 10

done
