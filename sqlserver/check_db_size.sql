select sum(total_size_mb) as total_instancia_gb from (
SELECT 
      database_name = DB_NAME(database_id)
    , log_size_gb = CAST(SUM(CASE WHEN type_desc = 'LOG' THEN size END) * 8. / 1024/1024 AS DECIMAL(8,2))
    , row_size_gb = CAST(SUM(CASE WHEN type_desc = 'ROWS' THEN size END) * 8. / 1024/1024 AS DECIMAL(8,2))
    , total_size_gb = CAST(SUM(size) * 8. / 1024/1024 AS DECIMAL(8,2))
FROM sys.master_files WITH(NOWAIT)
WHERE database_id > 4 -- for current db 
GROUP BY database_id
--order by 4 desc
) dbs;


SELECT 
      database_name = DB_NAME(database_id)
    , log_size_gb = CAST(SUM(CASE WHEN type_desc = 'LOG' THEN size END) * 8. / 1024/1024 AS DECIMAL(8,2))
    , row_size_gb = CAST(SUM(CASE WHEN type_desc = 'ROWS' THEN size END) * 8. / 1024/1024 AS DECIMAL(8,2))
    , total_size_gb = CAST(SUM(size) * 8. / 1024/1024 AS DECIMAL(8,2))
FROM sys.master_files WITH(NOWAIT)
--WHERE database_id > 4 -- for current db 
GROUP BY database_id
order by 4 desc;