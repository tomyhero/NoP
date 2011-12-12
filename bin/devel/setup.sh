#!/bin/bash

set -e;

APP_HOME='.'
MYRC=$HOME/.`basename $SHELL`rc
DATABASE_NAME=nop_${NOP_ENV}


if [ ! -f $APP_HOME/bin/devel/setup.sh ]; then
    echo 'you must excute this script from application home directory!! like a ./bin/devel/setup.sh'
    exit;
fi



#* 環境変数
if [ ! $NOP_ENV ];then
echo "export NOP_ENV=local" >> $MYRC
source $MYRC
fi



HAS_DB=`echo 'show databases' | mysql -u root | grep $DATABASE_NAME | wc -l`

if [ $HAS_DB == 1 ]
then
    echo 'HAS database'
else
    mysqladmin -u root create $DATABASE_NAME
    mysql -u root $DATABASE_NAME < $APP_HOME/misc/nop.sql
fi



