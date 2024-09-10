SELECT 
   blocking_session_id AS BlockingSessionID,
   session_id AS SessionID,
   wait_type AS WaitType,
   wait_time AS WaitTime,
   wait_resource AS WaitResource,
   TEXT AS SqlStatement
FROM 
   sys.dm_exec_requests r
CROSS APPLY 
   sys.dm_exec_sql_text(r.sql_handle) AS st
WHERE 
   r.blocking_session_id <> 0;
