-- Run the following queries to identify the approximate fragmented space at the database level and table level:


SELECT 	table_schema AS "DB_NAME", 
		SUM(size) "DB_SIZE", 
		SUM(fragmented_space) APPROXIMATED_FRAGMENTED_SPACE_GB 
FROM 	(SELECT 	table_schema, 
					table_name, 
					ROUND((data_length+index_length+data_free)/1024/1024/1024,2) AS size, 
					ROUND((data_length - (AVG_ROW_LENGTH*TABLE_ROWS))/1024/1024/1024,2) AS fragmented_space 
		 FROM 		information_schema.tables 
		 WHERE 		table_type='BASE TABLE' 
		 AND 		table_schema NOT IN ('performance_schema', 'mysql', 'information_schema') 
		) AS TEMP 
GROUP BY DB_NAME 
ORDER BY APPROXIMATED_FRAGMENTED_SPACE_GB DESC;


SELECT 	table_schema DB_NAME, 
		table_name TABLE_NAME, 
		ROUND((data_length+index_length+data_free)/1024/1024/1024,2) SIZE_GB, 
		ROUND((data_length - (AVG_ROW_LENGTH*TABLE_ROWS))/1024/1024/1024,2) APPROXIMATED_FRAGMENTED_SPACE_GB 
from 	information_schema.tables 
WHERE 	table_type='BASE TABLE' 
AND 	table_schema NOT IN ('performance_schema', 'mysql', 'information_schema') ORDER BY APPROXIMATED_FRAGMENTED_SPACE_GB DESC;



SELECT 	
		sum(ROUND((data_length+index_length+data_free)/1024/1024/1024,2)) SIZE_GB
from 	information_schema.tables 
WHERE 	table_type='BASE TABLE' 
AND 	table_schema IN ('account_instant_payment') 
--ORDER BY APPROXIMATED_FRAGMENTED_SPACE_GB DESC;

SELECT 	table_schema DB_NAME, 
		table_name TABLE_NAME, 
		ROUND((data_length+index_length+data_free)/1024/1024/1024,2) SIZE_GB, 
		ROUND((data_length - (AVG_ROW_LENGTH*TABLE_ROWS))/1024/1024/1024,2) APPROXIMATED_FRAGMENTED_SPACE_GB 
from 	information_schema.tables 
WHERE 	table_type='BASE TABLE' 
AND 	table_schema  IN ('platform_login') ORDER BY APPROXIMATED_FRAGMENTED_SPACE_GB DESC;
