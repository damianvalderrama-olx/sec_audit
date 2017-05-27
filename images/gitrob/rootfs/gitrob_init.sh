#!/bin/bash
username=$(env|grep POSTGRES_USER|cut -d= -f2-)
password=$(env|grep POSTGRES_PASSWORD|cut -d= -f2-)
db=$(env|grep POSTGRES_DB|cut -d= -f2-)
host=$(env|grep POSTGRES_HOST|cut -d= -f2-)
port=$(env|grep POSTGRES_PORT|cut -d= -f2-)
token=$(env|grep GITHUB_TOKEN|cut -d= -f2-)
gitrob_config="/root/.gitrobrc"
[ -e $gitrob_config ] && rm $gitrob_config

echo "---" > $gitrob_config
echo "sql_connection_uri: postgres://"$username":"$password"@"$host":"$port"/"$db >> $gitrob_config
echo "github_access_tokens:" >> $gitrob_config
echo "- "$token >> $gitrob_config

echo "user accepted" > /var/lib/gems/2.3.0/gems/gitrob-1.1.2/agreement.txt

#gitrob -b 0.0.0.0 --no-color -o $1
exec tail -f /dev/null
