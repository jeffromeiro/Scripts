use monitor

DECLARE @login_name VARCHAR(20) = 'user_ep_funcao';
DECLARE @session_id NUMERIC(20) = 999;
DECLARE @horas NUMERIC(20) = 8;

SELECT [collection_time]
      ,[dd hh:mm:ss.mss]
     ,[login_name]
	 ,[database_name]
      ,[session_id]
      ,[status]
	,[sql_text]
      ,[wait_info]
      ,[blocking_session_id]
    	,[percent_complete]
      ,[host_name]
      ,[sql_command]
      ,[CPU]
      ,[CPU_delta]
      ,[reads]
      ,[reads_delta]
      ,[writes]
      ,[program_name]
      ,[open_tran_count]
      ,[query_plan]
  FROM [dbo].[log_whoisactive]
where collection_time > DATEADD(HOUR, -@horas, GETDATE())
and login_name = IIF(@login_name IS NULL, login_name, @login_name)
--and session_id= @session_id
and session_id =  IIF(@session_id IS NULL, session_id, @session_id)
order by 1 desc;
