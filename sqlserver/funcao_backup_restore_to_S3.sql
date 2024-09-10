-- Exemplo de backup

exec msdb.dbo.rds_backup_database 	
@source_db_name='FIARQUIVOSCBSS', 	
@s3_arn_to_backup_to='arn:aws:s3:::backup-funcao-database/FIARQUIVOSCBSS_teste.bak';

-- comando para verificar status do backup
exec msdb.dbo.rds_task_status

--Exemplo de restore_db_name

exec msdb.dbo.rds_restore_database
@restore_db_name='FIARQUIVOSCBSS_TESTE_RESTORE',
@s3_arn_to_restore_from='arn:aws:s3:::backup-funcao-database/FIARQUIVOSCBSS_teste.bak',
@type='FULL',
@with_norecovery=0;

-- comando para verificar status do restore
exec msdb.dbo.rds_task_status
    @db_name='FIARQUIVOSCBSS',
    @task_id=10280;
