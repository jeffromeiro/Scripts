SELECT 	table_schema, sum(TABLE_ROWS) , sum(round(data_length/1024/1024/1024,2)) data_gb, sum(round(index_length/1024/1024/1024,2)) index_gb,
		sum(ROUND((data_length+index_length+data_free)/1024/1024/1024,2)) SIZE_GB 
		from 	information_schema.tables  
	     group by table_schema
        order by 5 desc;		


SELECT 	table_name, table_schema, TABLE_ROWS,check_time, update_time, 
sum(round(data_length/1024/1024/1024,2)) data_gb, sum(round(index_length/1024/1024/1024,2)) index_gb,
		sum(ROUND((data_length+index_length+data_free)/1024/1024/1024,2)) SIZE_GB 
		from 	information_schema.tables  
	  #  WHERE table_schema IN ('qrcode','qrcode2') 
	    group by table_name,table_schema,TABLE_ROWS, update_time, create_time 
        order by 3 desc;
		
		
		
		