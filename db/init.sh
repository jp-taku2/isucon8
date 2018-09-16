#!/bin/bash

ROOT_DIR=$(cd $(dirname $0)/..; pwd)
DB_DIR="$ROOT_DIR/db"
BENCH_DIR="$ROOT_DIR/bench"
DB_HOST="172.16.211.2"

export MYSQL_PWD=isucon

mysql -uisucon -h$DB_HOST -e "DROP DATABASE IF EXISTS torb; CREATE DATABASE torb;"
mysql -uisucon -h$DB_HOST torb < "$DB_DIR/schema.sql"

if [ ! -f "$DB_DIR/isucon8q-initial-dataset.sql.gz" ]; then
  echo "Run the following command beforehand." 1>&2
  echo "$ ( cd \"$BENCH_DIR\" && bin/gen-initial-dataset )" 1>&2
  exit 1
fi

mysql -uisucon -h$DB_HOST torb -e 'ALTER TABLE reservations DROP KEY event_id_and_sheet_id_idx'
gzip -dc "$DB_DIR/isucon8q-initial-dataset.sql.gz" | mysql -uisucon -h$DB_HOST torb
mysql -uisucon -h$DB_HOST torb -e 'ALTER TABLE reservations ADD KEY event_id_and_sheet_id_idx (event_id, sheet_id)'
mysql -uisucon -h$DB_HOST torb -e 'alter table reservations add index reserved_at_idx(reserved_at);'
