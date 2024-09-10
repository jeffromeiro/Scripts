-- Verificar os indexes de uma tabela especifica

SELECT schemaname,tablename,indexname,tablespace,indexdef
FROM pg_indexes
WHERE tablename = 'scale_data'		--> especificar table_name
ORDER BY tablename, indexname;							   