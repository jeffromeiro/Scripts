SELECT databases.name AS [Database Name],
       materfiles.type_desc AS [File Type],
	   materfiles.name,
	   materfiles.physical_name,
       CAST((CAST(materfiles.Size AS BIGINT) * 8) / 1024.0 AS DECIMAL(18, 1)) AS [Initial Size (MB)],
       'By '+IIF(materfiles.is_percent_growth = 1, CAST(materfiles.growth AS VARCHAR(10))+'%', CONVERT(VARCHAR(30), CAST((materfiles.growth * 8) / 1024.0 AS DECIMAL(18, 1)))+' MB') AS [Autogrowth],
       IIF(materfiles.max_size = 0, 'No growth is allowed', IIF(materfiles.max_size = -1, 'Unlimited', CAST((CAST(materfiles.max_size AS BIGINT) * 8) / 1024 AS VARCHAR(30))+' MB')) AS [MaximumSize]
FROM sys.master_files AS materfiles
INNER JOIN sys.databases AS databases ON databases.database_id = materfiles.database_id
WHERE  
--databases.name='FICDCCBSS'
databases.database_id=DB_ID()
order by 1,2;

-- Find the available space
SELECT name , type_desc, physical_name,size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0 AS AvailableSpaceInMB
FROM sys.database_files;


Declare @SQL VarChar(8000)
Set @SQL = 'DBCC SHOWFILESTATS WITH TABLERESULTS'
If Object_ID('tempdb.dbo.#UsedSpace') > 0
	Drop Table #UsedSpace
Create Table #UsedSpace (FileID SmallInt, FileGroup SmallInt, TotalExtents Int, UsedExtents Int, 
Name NVarChar(256), FileName NVarChar(512))
Insert Into #UsedSpace
Exec(@SQL)
Select Name, (TotalExtents * 64) / 1024 As 'TotalSpace',
(UsedExtents * 64) / 1024 As 'UsedSpace', 
((TotalExtents * 64) / 1024) - ((UsedExtents * 64) / 1024) As 'FreeSpace'
From #UsedSpace
order by Name
Drop Table #UsedSpace
