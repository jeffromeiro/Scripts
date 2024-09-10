-- Run the following queries to identify sessions:

select id,
       user,
       host,
       db,
       command,
       time,
       state,
       info
from information_schema.processlist where info is not null;
