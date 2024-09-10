-- Get DDL 
-- https://blog.dbi-services.com/can-i-do-it-with-postgresql-5-generating-ddl-commands/

SELECT proname
     , pg_get_functiondef(a.oid)
  FROM pg_proc a
 WHERE a.proname = 'monit_flex_white_label_01'
 ;
 
 
SELECT pg_get_functiondef(to_regproc('monit_flex_white_label_01'));
                   pg_get_functiondef
