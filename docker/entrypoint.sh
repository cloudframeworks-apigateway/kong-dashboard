#!/bin/bash
trap "exist" INT TERM

exist(){
   echo "Capture exit signal.. exit.."
   exit 0
}

if [ $# -gt 0 ]; then
    exec ./bin/kong-dashboard.js $@
else
    kongurl="http://$KONGADMIN_HOST:$KONGADMIN_PORT"
    # Prepare kong admin api
    for (( i = 0; i < 20; i++))
    do
        nc -v -z -w 2 $KONGADMIN_HOST $KONGADMIN_PORT
        if [ $? -eq 0 ];then
            break
        fi
        echo "step $i check kong admin api not ready, retry..."
        if [ $i -eq 19 ];then
            echo "waiting kong admin api ready timeout. exit"
            exit 1
        fi
        sleep 2
    done
    exec ./bin/kong-dashboard.js start --kong-url $kongurl
fi


