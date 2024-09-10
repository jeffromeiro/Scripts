-- Run the following queries to identify last startup:

SELECT	DATE_SUB(now(), 
		INTERVAL variable_value SECOND) "LAST STARTUP" 
from 	performance_schema.global_status 
where 	variable_name='Uptime';
