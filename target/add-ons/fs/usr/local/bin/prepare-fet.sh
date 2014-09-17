#!/bin/sh

#currently it's pretty stupid.
#when board vpd is supported, we will make it a bit smarter...
#define FET_T_72A            0v
#define FET_T_72B            1
#define FET_T_72A_3PHASE     2
#define FET_T_72B_3PHASE     3

#Harel
#5:30 PM (6 hours ago)
#
#to me, Benny, Zvisha 
#Hi,
#The 3 phase change is implemented on the following Rev (included and until farther notice--> need to support increment in rev for example ELA-2003 B03..B09)
#ELA-2003 B02
#ELA-2013 B03

FETFILE="/tmp/mg_fet"
FC=`cat ${FETFILE}`
#OLDTOP=${FC:2:1}
OLDTOP=1
#OLDBOT=${FC:6:1}
OLDBOT=1

calcfet()
{
	if [ ${RC} -eq 0 ] ; then
		if [ ${PNR:4} -eq 2003 ] ; then
			#echo FET 1/3
			if [ ${REV:2} -lt 2 ] ; then
				FET=1
			else
				FET=3
			fi
		elif [ ${PNR:4} -eq 2013 ] ; then 
			#echo FET 0/2
			if [ ${REV:2} -lt 3 ] ; then
				FET=0
			else
				FET=2
			fi
		elif [ ${PNR:4} -eq 1003 ] ; then 
			FET=5
		elif [ ${PNR:4} -eq 1013 ] ; then 
			FET=4
		fi
	fi
}


# first - TOP
PNR=`mainvpd -top -q -p`
REV=`mainvpd -top -q -r`
RC=$?
FET=${OLDTOP}
calcfet
TOPFET=${FET}

# then BOTTOM
PNR=`mainvpd -bottom -q -p`
REV=`mainvpd -bottom -q -r`
RC=$?
FET=${OLDBOT}
calcfet
BOTFET=${FET}


echo "0:${TOPFET} 1:${BOTFET}" > ${FETFILE}

