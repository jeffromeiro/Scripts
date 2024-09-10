select concat('CALL mysql.rds_kill(',id,');'), time from information_schema.processlist where user='sys_account_instant_payment' and info is null order by time;

select concat('KILL ',id,';'), time from information_schema.processlist where user='teste' and info is null order by time;