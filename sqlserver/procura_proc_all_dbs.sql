exec sp_msforeachdb 'use [?] select db_name(),name from sys.objects where name =''sp_BlitzCache'' and type =''p'''