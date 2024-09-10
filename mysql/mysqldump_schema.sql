=======================
1) export e import schema:

export 

mysqldump -u ibi \
--column-statistics=0 \
-h rds-ibi-combr-prd.ceip7fi02lcw.sa-east-1.rds.amazonaws.com \
-p ibi_digital > C:\ibi\bkp_schema_ibi_digital.sql


import 

mysql -h rds-ibi-combr-prd.ceip7fi02lcw.sa-east-1.rds.amazonaws.com -u ibi -p --column-statistics=0 --set-gtid-purged=OFF  < C:\ibi\bkp_schema_ibi_digital.sql


=======================
2) verificando os processos em execução:

show processlist;

