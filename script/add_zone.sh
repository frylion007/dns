while getopts "Z:V:T:S:h" arg #选项后面的冒号表示该选项需要参数
do
        case $arg in
             Z)
                ZONE="$OPTARG"
                ;;
             V)
                VIEW="$OPTARG"
                ;;
             T)
                TYPE="$OPTARG"
                ;;
             S)
                MASTER_DNS_SERVER="$OPTARG"
                ;;
             h)  #当有不认识的选项的时候arg为?
                echo -e "-Z zone\n-V view\n-T type (master,slave)\n"
                exit 1
                ;;
        esac
done

workDir="/usr/local/named"
zoneTemplate="zones/domain-view.template"
zoneFile="zones/${ZONE}-${VIEW}.zone"
viewFile="views/${VIEW}.view"

if [ -f "${workDir}/${zoneFile}" ]
then
    echo "${ZONE} is not new zone"
    exit 1
fi

grep "zones/${ZONE}-${VIEW}.zone" ${workDir}/${viewFile}

if [ $? -eq 0 ]
then
    echo "${ZONE} is not new zone"
    exit 1
fi

MasterViewTemplate="
zone \"${ZONE}\" IN {
        type ${TYPE};
        file \"$zoneFile\";
};
"
SlaveViewTemplate="
zone \"${ZONE}\" IN {
        type ${TYPE};
        masters { ${MASTER_DNS_SERVER}; };
        file \"$zoneFile\";
};
"


# master zone need add new zone file in zones folder
if [ ${TYPE} == "master" ]
then

    cp -f "${workDir}/${zoneTemplate}" "${workDir}/${zoneFile}"
    echo $MasterViewTemplate >> "${workDir}/${viewFile}"

elif [ $MASTER_DNS_SERVER -a ${TYPE} == "slave" ]
then
    echo $SlaveViewTemplate >> "${workDir}/${viewFile}"
fi

echo "add zone ${ZONE} success"
