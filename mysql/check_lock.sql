SELECT  COALESCE(MAX(IF(pb.command='Sleep',pb.time, 0)), 0) idle_in_trx,
        pb.ID BLK_ID,pb.USER BLK_USER,pb.HOST BLK_HOST,pb.DB BLK_DB,pb.COMMAND BLK_CMD,
        pb.TIME BLK_TIME,pb.STATE BLK_STATE,pb.INFO BLK_INFO,
        pr.ID REQ_ID,pr.USER REQ_USER,pr.HOST REQ_HOST,pr.DB REQ_DB,
        pr.COMMAND REQ_CMD,pr.TIME REQ_TIME,pr.STATE REQ_STATE,pr.INFO REQ_INFO,w.*
FROM       INFORMATION_SCHEMA.INNODB_LOCK_WAITS AS w
INNER JOIN INFORMATION_SCHEMA.INNODB_TRX        AS b  ON b.trx_id = w.blocking_trx_id
INNER JOIN INFORMATION_SCHEMA.INNODB_TRX        AS r  ON r.trx_id = w.requesting_trx_id
LEFT JOIN  INFORMATION_SCHEMA.PROCESSLIST       AS pb ON pb.id    = b.trx_mysql_thread_id
LEFT JOIN  INFORMATION_SCHEMA.PROCESSLIST       AS pr ON pr.id    = r.trx_mysql_thread_id