SELECT CONCAT ('ALTER TABLE ', tb1.TABLE_NAME, ' ADD CONSTRAINT ', tb1.CONSTRAINT_NAME, ' FOREIGN KEY (', tb1.COLUMN_NAME, ') REFERENCES ', tb1.REFERENCED_TABLE_NAME, ' (', tb1.REFERENCED_COLUMN_NAME, ') ON DELETE ', tb2.DELETE_RULE, ' ON UPDATE ', tb2.UPDATE_RULE, ';') as comando 
FROM information_schema.KEY_COLUMN_USAGE AS tb1
 INNER JOIN information_schema.REFERENTIAL_CONSTRAINTS AS tb2 
 ON tb1.CONSTRAINT_NAME = tb2.CONSTRAINT_NAME WHERE 
 table_schema = 'platform_communication' 
 and tb1.table_name in  ('message','message_sms', 'message_push',
'message_mail','message_mail_attachment','message_variable', 'message_event')
 AND referenced_column_name IS NOT NULL
