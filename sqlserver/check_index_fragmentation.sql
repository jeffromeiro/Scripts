-- Substitua 'NomeDaTabela' pelo nome da tabela que você deseja verificar
DECLARE @TableName VARCHAR(255) = 'NomeDaTabela';
SELECT 
    OBJECT_NAME(ips.object_id) AS TableName,
    ips.index_id,    i.name AS IndexName,
    ips.avg_fragmentation_in_percent FROM 
    sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID(@TableName), NULL, NULL, 'LIMITED') ips JOIN 
    sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE 
    ips.index_id > 0 
ORDER BY 
    ips.avg_fragmentation_in_percent DESC;