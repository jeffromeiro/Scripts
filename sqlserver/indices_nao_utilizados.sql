use CDC
GO
SELECT sqlserver_start_time FROM sys.dm_os_sys_info
go
declare @BASE_EXEC VARCHAR(200)
declare @SERVER_EXEC VARCHAR(500)
SET @BASE_EXEC = DB_NAME()  
SET @SERVER_EXEC = @@SERVERNAME
SELECT SYS.indexes.name as 'indice', 
	   sys.objects.name as 'tabela ',
	   dm_db_index_usage_stats. user_lookups,
	   dm_db_index_usage_stats.user_seeks,
   	   dm_db_index_usage_stats.user_scans,
	   dm_db_index_usage_stats.user_updates, 
	   dm_db_index_usage_stats.last_user_seek,
	   dm_db_index_usage_stats.last_user_scan,
	   dm_db_index_usage_stats.last_user_lookup,
	   dm_db_index_usage_stats.system_updates, 
	   dm_db_index_usage_stats.last_user_update, 	   	   
	   SYS.indexes.object_id, 
	   SCHEMA_NAME(sys.objects.schema_id) as 'schema', 	   	   
	   @BASE_EXEC as 'base_exec', 
	   @SERVER_EXEC as 'servidor_inst'
  FROM SYS.indexes WITH(NOLOCK)
 INNER JOIN sys.objects WITH(NOLOCK) ON SYS.indexes.OBJECT_ID = objects.OBJECT_ID and SYS.objects.type = 'U'
 LEFT JOIN sys.dm_db_index_usage_stats WITH(NOLOCK) ON dm_db_index_usage_stats.OBJECT_ID = indexes.OBJECT_ID
	AND dm_db_index_usage_stats.index_id = indexes.index_id
	AND database_id = DB_ID()
 WHERE sys.objects.name IN ('COPER', 'CPARC', 'EMOV1', 'EFINA')