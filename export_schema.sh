#!/usr/bin/env bash
# Change the connection string to an appropriate value for your cluster
CONNECTION_STRING="jdbc:hive2://jyoung-hdp250-3.openstacklocal:10000/default;principal=hive/_HOST@EXAMPLE.COM"
# DDL will be written to /tmp/backup_hive_ddl by default. Can be changed by supplying a path as a command line argument.
OUTPUT_FILE=${1-/tmp/backup_hive_ddl}
IFS=$'\n'
echo "Getting list of base tables..."
BASE_TABLES=($(mysql -s -N -e "select TBL_NAME from hive.TBLS where TBL_TYPE <> 'VIRTUAL_VIEW'"))
echo "${BASE_TABLES[*]}"
echo "Getting list of views..."
VIEWS=($(mysql -s -N -e "select TBL_NAME from hive.TBLS where TBL_TYPE = 'VIRTUAL_VIEW'"))
echo "${VIEWS[*]}"
echo "Writing base tables DDL to $OUTPUT_FILE ..."
for TABLE_NAME in "${BASE_TABLES[@]%%:*}"; do 
    (beeline -u "$CONNECTION_STRING" --silent=true --outputformat=tsv2 --showheader=false -e "show create table $TABLE_NAME"; echo ";") >> $OUTPUT_FILE 
done
echo "Writing views DDL to $OUTPUT_FILE ..."
for TABLE_NAME in "${VIEWS[@]%%:*}"; 
    do (beeline -u "$CONNECTION_STRING" --silent=true --outputformat=tsv2 --showheader=false -e "show create table $TABLE_NAME"; echo ";") >> $OUTPUT_FILE 
done
