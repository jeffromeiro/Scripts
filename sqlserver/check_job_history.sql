use monitor

select *--CommandType, count(*)
from CommandLog where
CommandType='ALTER_INDEX' 
--CommandType='UPDATE_STATISTICS'
and 
StartTime > DATEADD(DAY, -7, GETDATE())
--group by CommandType
order by StartTime desc;