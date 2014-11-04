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

#default fet for "all" cases (SP30 old boards)
OLDTOP=0
OLDBOT=0

#default for SP20
boxtype.sh
BOXTYPE=$? #this is not error-code, this is value!

if [ ${BOXTYPE} -eq 20 ] ; then
	OLDTOP=5
	OLDBOT=5
elif [ ${BOXTYPE} -eq 31 ] ; then
	OLDTOP=1
	OLDBOT=1
fi
 

calcfet()
{
	if [ ${RC} -eq 0 ] ; then
		if [ ${PNR:4} -eq 2003 ] ; then
			#echo FET 1/3 72B
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
		elif [ ${PNR:4} -eq 2023 ] ; then
				#78B3P50A		
				FET=11 
		elif [ ${PNR:4} -eq 2103 ] ; then
			if [ ${REV:2} -lt 1 ] ; then
				FET=5
			else
				FET=3
			fi
		elif [ ${PNR:4} -eq 2113 ] ; then
				#72A3P50A
				FET=2
		elif [ ${PNR:4} -eq 2123 ] ; then
				#78B3P50A
				FET=11
		elif [ ${PNR:4} -eq 1003 ] ; then 
			#72B4P50A
			FET=5
		elif [ ${PNR:4} -eq 1013 ] ; then 
			#72A4P50A
			FET=4
		elif [ ${PNR:4} -eq 1023 ] ; then 
			#78B4P50A
			FET=9
		fi
	fi
}


# first - TOP
PNR=`mainvpd -top -q -p`
REV=`mainvpd -top -q -r`
RC=$? #this is error-code - there is no 12V.
if [ $RC -ne 0 ] ; then 
	TOPFET=100
else
	FET=${OLDTOP}
	calcfet
	TOPFET=${FET}
fi 
# then BOTTOM
PNR=`mainvpd -bottom -q -p`
REV=`mainvpd -bottom -q -r`
RC=$? #this is error-code - there is no 12V.
if [ $RC -ne 0 ] ; then 
	BOTFET=100
else
	FET=${OLDBOT}
	calcfet
	BOTFET=${FET}
fi 



echo "0:${TOPFET} 1:${BOTFET}" > ${FETFILE}

