-- Verificar a tabela

SELECT schemaname,tablename,tableowner,tablespace
FROM pg_tables
WHERE schemaname != 'pg_catalog'
AND schemaname != 'information_schema'
--AND tablename = ' '  						--> especificar table
ORDER BY tablename;	