# export_hive_schema_base_tables_and_views

## Summary
**export_schema.sh** is a shell script written to export Hive `SHOW CREATE TABLE <TABLE NAME>` DDL statements in order of the base tables being written out before view tables, so as not to encounter `Table not found '<BASE TABLE NAME>'` error messages.

This was written as a work-around for ["HIVE-14558 - Add support for listing views similar to 'show tables'"](https://issues.apache.org/jira/browse/HIVE-14558) not being available in Hive 1.2.1

The script queries the Hive Metastore TBLS table in MySQL to generate separte lists of base tables and views.
It iterates over each base table and appends the output of "show create table <base table name>" to a file.
It then iterates over each view and appends the output of "show create table <view name>" to the same file.

Path of the output file for the create table commands can be passed as an argument to the bash script.

## Usage
```
# bash export_schema.sh [/path/to/output/file]
```
