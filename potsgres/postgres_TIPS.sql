### Tips for postgresql

1) ----------------------------------------------------------------------
-------------------------------------------------------------------------
Acesso via command line:

psql 
-h hostname
-p port
-d database_name
-U user
-W pass

ex.:

S:\install\postgresql_12\bin\psql.exe -h teste.cmoxbsxtl1mr.us-east-1.rds.amazonaws.com -p 5432 -d teste -U teste -W



2) ----------------------------------------------------------------------
-------------------------------------------------------------------------
Plano de execucao - sql

EXPLAIN ANALYZE

ex.:
explain analyze
select * from scale_data
where section < 10;

                                                                 QUERY PLAN
--------------------------------------------------------------------------------------------------------------------------------------------
 Index Scan using idx_scale_data2 on scale_data  (cost=0.57..11005.42 rows=315877 width=16) (actual time=0.022..78.212 rows=135000 loops=1)
   Index Cond: (section < '10'::numeric)
 Planning time: 0.992 ms
 Execution time: 103.140 ms
(4 rows)



3) ----------------------------------------------------------------------
-------------------------------------------------------------------------
Carga de dados - sql

ex.:
CREATE TABLE scale_data (
   section NUMERIC NOT NULL,
   id1     NUMERIC NOT NULL,
   id2     NUMERIC NOT NULL
);
INSERT INTO scale_data
SELECT sections.*, gen.*
     , CEIL(RANDOM()*100) 
  FROM GENERATE_SERIES(1, 300) sections,
       GENERATE_SERIES(1, 900000) gen
 WHERE gen <= sections * 3000;


 
4) ----------------------------------------------------------------------
-------------------------------------------------------------------------
Evitando lock de carga de dados, limitando em 5000 linhas
 
 do {
  numRowsUpdated = executeUpdate(
    "UPDATE items SET last_update = ? " +
    "WHERE ctid IN (SELECT ctid FROM items WHERE last_update IS NULL LIMIT 5000)",
    now);
} while (numRowsUpdate > 0);


link: https://www.citusdata.com/blog/2018/02/22/seven-tips-for-dealing-with-postgres-locks/



5) ----------------------------------------------------------------------
-------------------------------------------------------------------------
Sempre execute qualquer alter table, com a opção de lock_timeout, por que 
evita que quaisquer consulta sendo realizada na tabela seja interrompida imediatamente
ou fique em lock

SET lock_timeout TO '2s'
ALTER TABLE items ADD COLUMN last_update timestamptz;

link: https://www.citusdata.com/blog/2018/02/22/seven-tips-for-dealing-with-postgres-locks/



6) ----------------------------------------------------------------------
-------------------------------------------------------------------------
Informações postgres:

/etc/postgresql/versao/main

7) ----------------------------------------------------------------------
-------------------------------------------------------------------------
Configurações do db postgres:

select name, context, unit, setting, boot_val, reset_val 
from pg_settings where name in ('listen_addresses','max_connections','effective_cache_size','shared_buffers', 'work_mem','maintenance_work_mem') order by context,name;

8) ----------------------------------------------------------------------
-------------------------------------------------------------------------
Verificar os arquivos de configuração

select name, setting from pg_settings
where category = 'File Locations';


9) ----------------------------------------------------------------------
-------------------------------------------------------------------------

O conceito de usuário no postgres e chamado de role:

create role pedro login password '123456' createdb valid until 'infinity';

-- super user 
create role pedro login password '123456' SUPERUSER valid until 'infinity';



Você pode criar groups: 

create role group1 inherint;

grant group1 to pedro;


10) ----------------------------------------------------------------------
-------------------------------------------------------------------------
export & import


pg_dump -h ct-rds-prd-apikong.cluster-ceip7fi02lcw.sa-east-1.rds.amazonaws.com -U pveloso -f "D:\DBA\export_dump\dump_prd_kong_data_17FEV2022.sql" kong
psql -h uat-site-digio-cms.cluster-c30dl4awyeay.sa-east-1.rds.amazonaws.com -U pveloso teste < "D:\DBA\export_dump\dump_uat_site_digio_cms_01FEV2023.sql"

--
pg_restore -h ct-rds-prd-apikong.cluster-ceip7fi02lcw.sa-east-1.rds.amazonaws.com -U pveloso kong < "D:\DBA\export_dump\dump_prd_kong_data_17FEV2022.sql"
 
