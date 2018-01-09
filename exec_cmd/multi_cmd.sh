#!/bin/bash

HOSTS=
COMMAND=
EXEC_CMD=0

usage()
{
    echo -e "Usage: flood_cmd [options] [\"command\"] \n\n"
    echo -e "options: \n"
    echo -e "  -h file     ;host file \n"
    echo -e "  -A          ;to execuse command \n"
    echo -e "  -c          ;execuse command para\n"

    echo -e "\n"
    echo -e "eg: ./flood_cmd -A -h host.txt -c \"pwd\" \n"
}

function doCommand()
{
    echo $1
    echo $2
    echo " "
    echo "processing start ................."
    hosts=`sed -n '/^[^#]/p' $1`
    for host in $hosts
    do
        echo " "
        echo $host
        sshpass -p 'TODO_PASSWORD' ssh $host "$2" && echo $host "SUCCESS" || echo $host "FAIL"
    done
    echo "processing end  ................."

    return 0
}

if [ $# -lt 5 ]
then
    echo $(usage)
    exit
fi

echo $*
while getopts "Ac:h:" opt
do
    case $opt in
        h)
            HOSTS=$OPTARG
            echo "HOSTS" $HOSTS
            ;;
        c) 
            COMMAND=$OPTARG
            echo "COMMAND" $COMMAND
            ;;
        A)
            EXEC_CMD=1
            echo "EXEC_CMD"
            ;;

        esac
done

if [ 1 -eq $EXEC_CMD ]; then
    if [ -z "$HOSTS" ]; then
        echo "command must contain \"-h host_file\""
        exit -1;
    fi


    if [ -z "$COMMAND" ]; then
        echo "must contain command \"-c 'ls -l'\""
        exit -1;
    fi

    doCommand $HOSTS "$COMMAND"
else
    echo "error format"
    echo $(usage)
    exit;
fi
echo "============================================"
