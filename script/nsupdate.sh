#!/bin/bash
while getopts "s:k:v:o:t:T:S:D:H:h" arg #选项后面的冒号表示该选项需要参数
do
        case $arg in
             s)
                SERVER="$OPTARG"
                ;;
             k)
                KEY="$OPTARG"
                ;;
             v)
                VALUE="$OPTARG"
                ;;
             o)
                OPERATOR="$OPTARG"
                ;;
             t)
                TTL="$OPTARG"
                ;;
             T)
                TYPE="$OPTARG"
                ;;
             S)
                SOURCE="$OPTARG"
                ;;
             D)
                DEST="$OPTARG"
                ;;
             H)
                HOST="$OPTARG"
                ;;

             h)  #当有不认识的选项的时候arg为?
                echo -e "
-s DNS server \n 
-k key \n 
-v value \n 
-o operator ( add,delete) \n
-t ttl \n
-T type (A,CNAME) \n
-S source address \n
-D dest \n
-H host \n
-h help \n
                        "
                exit 1
                ;;
        esac
done

echo "
local 127.0.0.1
server $SERVER
key $KEY $VALUE
update $OPERATOR $SOURCE $TTL $TYPE $DEST
send
"

nsupdate << MAYDAY
local 127.0.0.1
server $SERVER
key $KEY $VALUE
update $OPERATOR $SOURCE $TTL $TYPE $DEST
send
MAYDAY
