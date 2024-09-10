--Explain 
explain format=tree select...

--Explain analyze
explain analyze select ...

--show columns
 show columns from conciliation_content;
 
--show create table
 show create table transaction;
 
 --show indexes
 show indexes from xpto;
 
 --analyze table
 analyze table xpto;
 
 --query redundant indexes
 select * from sys.schema_redundant_indexes;
 
 --order by optimization
 https://dev.mysql.com/doc/refman/8.0/en/order-by-optimization.html