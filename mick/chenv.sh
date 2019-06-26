if [ "$1" = "ousg" ]
then
source /home/oracle/OU_SG_FX.sh
FLXSCHEMA=FLXOSIN/FLXOSIN
elif [ "$1" = "odsg" ]
then
source /home/oracle/OD_FX_SG.sh
FLXSCHEMA=FLXOSIN/FLXOSIN
elif [ "$1" = "oulb" ]
then
source /home/oracle/OU_LB_FX.sh
FLXSCHEMA=flxolab/flxolab
elif [ "$1" = "odlb" ]
then
source /home/oracle/OD_FC_LB.sh
FLXSCHEMA=flxolab/flxolab
elif [ "$1" = "ouhm" ]
then
source /home/oracle/OU_FC_HM.sh
FLXSCHEMA=flxohcm/flxohcm
elif [ "$1" = "ousd" ]
then
source /home/oracle/OU_SD_FX.sh
FLXSCHEMA=flxosyd/flxosyd
elif [ "$1" = "odsd" ]
then
source /home/oracle/OD_FC_SD.sh
FLXSCHEMA=flxosyd/flxosyd
elif [ "$1" = "ouhk" ]
then
source /home/oracle/OU_HK_FX.sh
FLXSCHEMA="sys as sysdba/orchksa
"
elif [ "$1" = "odhk" ]
then
source /home/oracle/OD_FC_HK.sh
FLXSCHEMA=flxohkg/flxohkg
elif [ "$1" = "oush" ]
then
source /home/oracle/OU_SH_FX.sh
FLXSCHEMA=flxosha/flxosha
elif [ "$1" = "odsh" ]
then
source /home/oracle/OD_FC_SH.sh
FLXSCHEMA=flxosha/flxosha
elif [ "$1" = "odhm" ]
then
source /home/oracle/OD_FC_HM.sh
FLXSCHEMA=flxohcm/flxohcm
elif [ "$1" = "outk" ]
then
source /home/oracle/OU_FC_TK.sh
FLXSCHEMA=flxotky/flxotky
elif [ "$1" = "odtk" ]
then
source /home/oracle/OD_FC_TK.sh
FLXSCHEMA=flxotky/flxotky
elif [ "$1" = "ourp" ]
then
source /home/oracle/OU_RP_FX.sh

fi

export FLXSCHEMA
export PS1="`hostname`:$ORACLE_SID$:\w$"

