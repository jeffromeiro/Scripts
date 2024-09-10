https://www.dbrnd.com/2016/04/mysql-how-to-enable-and-disable-foreign-key-constraint/

## At Session level:
To Disable:
1 - SET FOREIGN_KEY_CHECKS=0;
To Enable:
1 - SET FOREIGN_KEY_CHECKS=1;


## At Global level:

To Disable:
1 - SET GLOBAL FOREIGN_KEY_CHECKS=0;
To Enable:
1 - SET GLOBAL FOREIGN_KEY_CHECKS=1;


--
check the constraint_name :

select COLUMN_NAME, CONSTRAINT_NAME, REFERENCED_COLUMN_NAME, REFERENCED_TABLE_NAME
from information_schema.KEY_COLUMN_USAGE
where TABLE_NAME = 'table_name';

