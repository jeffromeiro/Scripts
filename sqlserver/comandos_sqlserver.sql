
-- WHO IS ACTIVE
-- use monitor
EXEC sp_whoisactive;

EXEC sp_WhoIsActive
    @filter_type = 'login',
    @filter = 'admin';
	

--LOCKING AND BLOCKING
SELECT * FROM sys.sysprocesses 
WHERE blocked > 0 
  OR SPID IN (SELECT Blocked FROM sys.sysprocesses);

-- TOP QUERIES
SELECT db_name(r.database_id),
    s.session_id,
    r.status,
    r.blocking_session_id 'Blk by',
    r.wait_type,
    wait_resource,
    r.wait_time / (1000 * 60) 'Wait M',
    r.cpu_time,
    r.logical_reads,
    r.reads,
    r.writes,
    r.total_elapsed_time / (1000 * 60) 'Elaps M',
    Substring(st.TEXT,(r.statement_start_offset / 2) + 1,
    ((CASE r.statement_end_offset
WHEN -1
THEN Datalength(st.TEXT)
ELSE r.statement_end_offset
END - r.statement_start_offset) / 2) + 1) AS statement_text,
    Coalesce(Quotename(Db_name(st.dbid)) + N'.' + Quotename(Object_schema_name(st.objectid, st.dbid)) + N'.' +
    Quotename(Object_name(st.objectid, st.dbid)), '') AS command_text,
    r.command,
    s.login_name,
    s.host_name,
    s.program_name,
    s.last_request_end_time,
    s.login_time,
    r.open_transaction_count
FROM sys.dm_exec_sessions AS s
    JOIN sys.dm_exec_requests AS r
ON r.session_id = s.session_id
    CROSS APPLY sys.Dm_exec_sql_text(r.sql_handle) AS st
WHERE r.session_id != @@SPID
ORDER BY r.cpu_time desc
 
DBCC INPUTBUFFER(422)

  
-- OLDEST OPEN TRANSACTION
DBCC OPENTRAN();

--RECENT EXPENSIVE QUERIES
;WITH qs AS (
  SELECT TOP 10 
    total_worker_time/execution_count AvgCPU
  , total_elapsed_time/execution_count AvgDuration
  , (total_logical_reads + total_physical_reads)/execution_count AvgReads
  , execution_count
  , sql_handle
  , plan_handle
  , statement_start_offset
  , statement_end_offset
  FROM sys.dm_exec_query_stats
  WHERE execution_count > 5
    AND min_logical_reads > 100
    AND min_worker_time > 100
  ORDER BY (total_logical_reads + total_physical_reads)/execution_count DESC)
SELECT
  AvgCPU
, AvgDuration
, AvgReads
, execution_count
 ,SUBSTRING(st.TEXT, (qs.statement_start_offset/2) + 1, 
            ((CASE qs.statement_end_offset  
                WHEN -1 THEN DATALENGTH(st.TEXT)
                ELSE qs.statement_end_offset  
              END - qs.statement_start_offset)/2) + 1) StatementText
 ,query_plan ExecutionPlan
FROM 
  qs  
    CROSS APPLY
  sys.dm_exec_sql_text(qs.sql_handle) AS st  
    CROSS APPLY
  sys.dm_exec_query_plan (qs.plan_handle) AS qp 
ORDER BY 
  AvgDuration DESC;
  

-- WAIT STATS
SELECT 
  wait_type 
, waiting_tasks_count
, signal_wait_time_ms
, wait_time_ms
, SysDateTime() AS StartTime
INTO 
  #WaitStatsBefore 
FROM 
  sys.dm_os_wait_stats 
WHERE 
  wait_type NOT IN ('SLEEP_TASK','BROKER_EVENTHANDLER','XE_DISPATCHER_WAIT','BROKER_RECEIVE_WAITFOR', 'CLR_AUTO_EVENT', 'CLR_MANUAL_EVENT','REQUEST_FOR_DEADLOCK_SEARCH','SQLTRACE_INCREMENTAL_FLUSH_SLEEP','SQLTRACE_BUFFER_FLUSH','LAZYWRITER_SLEEP','XE_TIMER_EVENT','XE_DISPATCHER_WAIT','FT_IFTS_SCHEDULER_IDLE_WAIT','LOGMGR_QUEUE','CHECKPOINT_QUEUE', 'BROKER_TO_FLUSH', 'BROKER_TASK_STOP', 'BROKER_EVENTHANDLER', 'SLEEP_TASK', 'WAITFOR', 'DBMIRROR_DBM_MUTEX', 'DBMIRROR_EVENTS_QUEUE', 'DBMIRRORING_CMD', 'DISPATCHER_QUEUE_SEMAPHORE','BROKER_RECEIVE_WAITFOR', 'CLR_AUTO_EVENT', 'DIRTY_PAGE_POLL', 'HADR_FILESTREAM_IOMGR_IOCOMPLETION', 'ONDEMAND_TASK_QUEUE', 'FT_IFTSHC_MUTEX', 'CLR_MANUAL_EVENT', 'SP_SERVER_DIAGNOSTICS_SLEEP', 'QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP', 'QDS_PERSIST_TASK_MAIN_LOOP_SLEEP','CLR_SEMAPHORE','DBMIRROR_WORKER_QUEUE','SP_SERVER_DIAGNOSTICS_SLEEP','HADR_CLUSAPI_CALL','HADR_LOGCAPTURE_WAIT','HADR_NOTIFICATION_DEQUEUE','HADR_TIMER_TASK','HADR_WORK_QUEUE','REDO_THREAD_PENDING_WORK','UCS_SESSION_REGISTRATION','BROKER_TRANSMITTER','SLEEP_SYSTEMTASK','QDS_SHUTDOWN_QUEUE');--These are a series of irrelevant wait stats.
 
WAITFOR DELAY '00:00:15'; --15 seconds
 
SELECT 
  a.wait_type 
, a.signal_wait_time_ms - b.signal_wait_time_ms AS CPUDiff 
, (a.wait_time_ms - b.wait_time_ms) - (a.signal_wait_time_ms - b.signal_wait_time_ms) AS ResourceDiff
, a.waiting_tasks_count - b.waiting_tasks_count AS waiting_tasks_diff
, CAST(CAST(a.wait_time_ms - b.wait_time_ms AS FLOAT) / (a.waiting_tasks_count - b.waiting_tasks_count) AS DECIMAL(10,1)) AS AverageDurationMS
, a.max_wait_time_ms max_wait_all_timeMS
, DATEDIFF(ms,StartTime, SysDateTime()) AS DurationSeconds
FROM 
  sys.dm_os_wait_stats a 
    INNER JOIN 
  #WaitStatsBefore b ON a.wait_type = b.wait_type 
WHERE 
  a.signal_wait_time_ms <> b.signal_wait_time_ms
    OR 
  a.wait_time_ms <> b.wait_time_ms
ORDER BY 3 DESC;



--IO SUBSYSTEM DELAY STATISTICS

SELECT 
  b.name
, a.database_id
, a.[FILE_ID]
, a.num_of_reads
, a.num_of_bytes_read
, a.io_stall_read_ms
, a.num_of_writes
, a.num_of_bytes_written
, a.io_stall_write_ms
, a.io_stall
, GetDate() AS StartTime
INTO
  #IOStatsBefore
FROM 
  sys.dm_io_virtual_file_stats(NULL, NULL) a 
    INNER JOIN 
  sys.databases b ON a.database_id = b.database_id;
 
 
WAITFOR DELAY '00:00:15'
 
SELECT
  a.name DatabaseName
, a.[FILE_ID]
, (b.io_stall_read_ms - a.io_stall_read_ms)/ CAST(1000 as DECIMAL(10,1)) io_stall_read_Diff 
, (b.io_stall_write_ms - a.io_stall_write_ms)/ CAST(1000 as DECIMAL(10,1)) io_stall_write_Diff 
, (b.io_stall - a.io_stall)/ CAST(1000 as DECIMAL(10,1)) io_stall_Diff 
, DATEDIFF(s,StartTime, GETDATE()) AS DurationSeconds
FROM 
  #IOStatsBefore a
    INNER JOIN 
  sys.dm_io_virtual_file_stats(NULL, NULL) b ON a.database_id = b.database_id AND a.[file_id] = b.[file_id]
ORDER BY
  a.name
, a.[FILE_ID];



--CPU HISTORY

;WITH XMLRecords AS (
SELECT 
         DATEADD (ms, r.[timestamp] - sys.ms_ticks,SYSDATETIME()) AS record_time
       , CAST(r.record AS XML) record
       FROM 
         sys.dm_os_ring_buffers r  
           CROSS JOIN 
         sys.dm_os_sys_info sys  
       WHERE   
         ring_buffer_type='RING_BUFFER_SCHEDULER_MONITOR' 
           AND 
         record LIKE '%<SystemHealth>%')
 SELECT 
   100-record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') AS SystemUtilization
 , record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') AS SQLProcessUtilization
 , record_time
 FROM XMLRecords;
 
 --MEMORY STATISTICS
 
 SELECT  
  LEFT(counter_name, 25) CounterName
, CASE counter_name 
    WHEN 'Stolen pages' THEN cntr_value/128 --8kb pages/128 = MB 
    WHEN 'Stolen Server Memory (KB)' THEN cntr_value/1024 --kb/1024 = MB 
    ELSE cntr_value
  END CounterValue_converted_to_MB
FROM 
  sys.dm_os_performance_counters
WHERE 
  OBJECT_NAME = N'SQLServer:Buffer Manager' 
    AND 
  counter_name = 'Page life expectancy';
  
  
-- DISK CAPACITY

SELECT DISTINCT 
  vs.volume_mount_point Drive
, vs.logical_volume_name
, vs.total_bytes/1024/1024/1024 CapacityGB
, vs.available_bytes/1024/1024/1024 FreeGB
, CAST(vs.available_bytes * 100. / vs.total_bytes AS DECIMAL(4,1)) FreePct 
FROM 
  sys.master_files mf
    CROSS APPLY 
  sys.dm_os_volume_stats(mf.database_id, mf.file_id) AS vs;  
  
  
--SLEEPING SESSIONS IDLE FOR OVER 15 MINUTES

SELECT CURRENT_TIMESTAMP AS currenttime,
                            datediff(MINUTE, last_batch, GETDATE()) AS 'idletime_in_minute',
                            sp.status,
                            sp.spid,
                            sp.login_time,
                            sp.program_name,
                            sp.hostprocess,
                            sp.loginame,text
FROM sys.sysprocesses sp CROSS APPLY sys.dm_exec_sql_text(sp.sql_handle) AS QT
WHERE sp.status = 'sleeping'
  AND datediff(MINUTE, last_batch, GETDATE()) >15
  AND spid>50
  

-- TOP 10 HIGH CPU QUERIES THAT CURRENTLY RUNNING IN THIS SQL INSTANCE 
SELECT s.session_id,
       r.status,
       r.blocking_session_id 'Blk by',
                             r.wait_type,
                             wait_resource,
                             r.wait_time / (1000 * 60) 'Wait M',
                                                       r.cpu_time,
                                                       r.logical_reads,
                                                       r.reads,
                                                       r.writes,
                                                       r.total_elapsed_time / (1000 * 60) 'Elaps M',
                                                                                          Substring(st.TEXT, (r.statement_start_offset / 2) + 1, ((CASE r.statement_end_offset
                                                                                                                                                       WHEN -1 THEN Datalength(st.TEXT)
                                                                                                                                                       ELSE r.statement_end_offset
                                                                                                                                                   END - r.statement_start_offset) / 2) + 1) AS statement_text,
                                                                                          Coalesce(Quotename(Db_name(st.dbid)) + N'.' + Quotename(Object_schema_name(st.objectid, st.dbid)) + N'.' + Quotename(Object_name(st.objectid, st.dbid)), '') AS command_text,
                                                                                          r.command,
                                                                                          s.login_name,
                                                                                          s.host_name,
                                                                                          s.program_name,
                                                                                          s.last_request_end_time,
                                                                                          s.login_time,
                                                                                          r.open_transaction_count
FROM sys.dm_exec_sessions AS s
JOIN sys.dm_exec_requests AS r ON r.session_id = s.session_id CROSS APPLY sys.Dm_exec_sql_text(r.sql_handle) AS st
WHERE r.session_id != @@SPID
ORDER BY r.cpu_time DESC



-- TOP 10 HIGH MEMORY USAGE QUERIES THAT CURRENTLY RUNNING IN THIS SQL INSTANCE
SELECT mg.session_id,
       mg.granted_memory_kb,
       mg.requested_memory_kb,
       mg.ideal_memory_kb,
       mg.request_time,
       mg.grant_time,
       mg.query_cost,
       mg.dop,
       st.[TEXT],
       qp.query_plan
FROM sys.dm_exec_query_memory_grants AS mg CROSS APPLY sys.dm_exec_sql_text(mg.plan_handle) AS st CROSS APPLY sys.dm_exec_query_plan(mg.plan_handle) AS qp
ORDER BY mg.required_memory_kb DESC



-- LIST PROGRESSIVE (ON-GOING) EXECUTION PLAN FOR A SPECIFIC SESSION (STARTING WITH SQL 2016)

--For SQL 2016 and 2017, please first run below TSQL in the query session of which the execution plan you wish to extract later
  set statistics profile on

--Run below query to extract the on-going execution plan for your target session (input the SPID in the bracket)
        SELECT * FROM sys.dm_exec_query_statistics_xml(422);