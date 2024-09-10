/* usr_microfocus */

drop user usr_microfocus;

/* user_onetrust */
CREATE USER 'user_onetrust'@'%' IDENTIFIED BY 'xxx' ;
GRANT SELECT ON *.* TO 'user_onetrust'@'%';

FLUSH PRIVILEGES;

/* dba_monitor */
CREATE USER 'dba_monitor'@'%' IDENTIFIED BY 'xxx' ;
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, PROCESS, INDEX, ALTER, SHOW DATABASES, CREATE TEMPORARY TABLES, LOCK TABLES, 
CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER ON *.* TO 'dba_monitor'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON `%`.* TO 'dba_monitor'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;