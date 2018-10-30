#!/bin/bash
 
#AEM_AUTHOR is the location of the bin files of AEM  
export AEM_AUTHOR=/apps/AEM64TARMK/author/crx-quickstart/bin
 

#AEM_USER is the default user of AEM
export AEM_USER=was
 
#AEM_USAGE is the message if this script is called without any options
AEM_USAGE="Usage: $0 {\e[00;32mstart\e[00m|\e[00;31mstop\e[00m|\e[00;32mstatus\e[00m|\e[00;31mrestart\e[00m}"
 
#SHUTDOWN_WAIT is wait time in seconds for java proccess to stop
SHUTDOWN_WAIT=20
 
AEM_pid() {
        echo `ps -fe | grep author | grep -v grep | tr -s " "|cut -d" " -f2`
}
 
start() {

# Start AEM
echo -e "\e[00;32mStarting AEM\e[00m"
#ulimit -n 100000
#umask 007
#/bin/su -p -s /bin/sh AEM
    if [ `user_exists $AEM_USER` = "1" ]
    then
            su $AEM_USER -c $AEM_AUTHOR/start
    else
            sh $AEM_AUTHOR/start
    fi
    status
  return 0
}
 
status(){
          pid=$(AEM_pid)
          if [ -n "$pid" ]; then echo -e "\e[00;32mAEM is running with pid: $pid\e[00m"
          else echo -e "\e[00;31mAEM is not running\e[00m"
          fi
}
 
stop() {
  pid=$(AEM_pid)
  if [ -n "$pid" ]
  then
    echo -e "\e[00;31mStoping AEM\e[00m"
    #/bin/su -p -s /bin/sh AEM
        sh $AEM_AUTHOR/stop
 
    let kwait=$SHUTDOWN_WAIT
    count=0;
    until [ `ps -p $pid | grep -c $pid` = '0' ] || [ $count -gt $kwait ]
    do
      echo -n -e "\n\e[00;31mwaiting for processes to exit\e[00m";
      sleep 1
      let count=$count+1;
    done
 
    if [ $count -gt $kwait ]; then
      echo -n -e "\n\e[00;31mkilling processes which didn't stop after $SHUTDOWN_WAIT seconds\e[00m"
      kill -9 $pid
    fi
  else
    echo -e "\e[00;31mAEM is not running\e[00m"
  fi
 
  return 0
}
 
user_exists(){
        if id -u $1 >/dev/null 2>&1; then
        echo "1"
        else
                echo "0"
        fi
}
 
case $1 in
 
        start)
          start
        ;;
       
        stop)  
          stop
        ;;
       
        restart)
          stop
          start
        ;;
       
        status)
                status
               
        ;;
       
        *)
                echo -e $AEM_USAGE
        ;;
esac    
exit 0

