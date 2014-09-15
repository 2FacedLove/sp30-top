#!/bin/sh
VPD=`readboxvpd.sh`
SMB=${VPD:12:4}
PNR=${VPD:16:4}
MODEL_ID="SP1x"
MODEL_NAME="SP10"
RC=10

if [ ! "${SMB}" == "SMB-" ] ; then
	echo "BAD VPD"
	exit 1
fi

if [ "${PNR}" == "1200" ] ; then
	#echo "SMB-${PNR} - SP10"
	MODEL_ID=SP1x
	MODEL_NAME=SP10
	RC=10
elif  [ "${PNR}" == "1500" ] ; then
	#echo "SMB-${PNR} - SP2x/SP20"
	MODEL_ID=SP2x
	MODEL_NAME=SP20
	RC=20
elif  [ "${PNR}" == "5400" ] ; then
	#echo "SMB-${PNR} - SP3x/SP30"
	MODEL_ID=SP3x
	MODEL_NAME=SP30
	RC=30
elif  [ "${PNR}" == "5431" ] ; then
	#echo "SMB-${PNR} - SP3x/SP31"
	MODEL_ID=SP3x
	MODEL_NAME=SP31
	RC=31
elif  [ "${PNR}" == "5435" ] ; then
	#echo "SMB-${PNR} - SP3x/SP35"
	MODEL_ID=SP3x
	MODEL_NAME=SP35
	RC=35
fi


echo "${MODEL_NAME}"

exit ${RC}
#01234567890123456789012
#KG1438000001SMB-1500A00
