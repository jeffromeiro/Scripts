SELECT Concat('ALTER TABLE ', table_name, ' ', 'ADD ',
              IF(non_unique = 1, CASE Upper(index_type)
                            WHEN 'FULLTEXT' THEN 'FULLTEXT INDEX'
                            WHEN 'SPATIAL' THEN 'SPATIAL INDEX'
                            ELSE Concat('INDEX ', index_name, ' USING ',
                                 index_type)
                          end, IF(Upper(index_name) = 'PRIMARY', Concat(
                               'PRIMARY KEY USING ', index_type),
                                                       Concat('UNIQUE INDEX ',
                                                       index_name, ' USING ',
                                                       index_type))), '(',
              Group_concat(DISTINCT Concat('', column_name, '') ORDER BY
              seq_in_index
              ASC
              SEPARATOR ', '), ');') AS 'Show_Add_Indexes'
FROM   information_schema.statistics
WHERE  table_schema = 'platform_communication'
       AND table_name IN ( 'message', 'message_sms', 'message_push',
                           'message_mail',
                           'message_mail_attachment', 'message_variable',
                           'message_event' )
GROUP  BY table_name,
          index_name
ORDER  BY table_name ASC,
          index_name ASC; 