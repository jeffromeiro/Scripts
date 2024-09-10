=======================
1) export e import table:

-- dump da tabela: node_property da base de dados: db-prd-flexvision-13jan

export 

mysqldump -h db-prd-flexvision-13jan.csycb5dngdsd.sa-east-1.rds.amazonaws.com \
-u flexadmin \
-p flex4 node_property \
--column-statistics=0 \
--set-gtid-purged=OFF  > D:\flexvision-13jan\dump_node_property_13jan.sql

import 

mysql -h db-prd-flexvision-13jan.csycb5dngdsd.sa-east-1.rds.amazonaws.com \
-u flexadmin \
-p flex4 node_property_13jan \
--column-statistics=0 \
--set-gtid-purged=OFF  
< D:\flexvision-13jan\dump_node_property_13jan.sql


=======================
2) verificando os processos em execução:

show processlist;

