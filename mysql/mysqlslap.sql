--concurrency = quantidade de concorrência da execução
--iterations = quantidade de iterações da execução

mysqlslap -h endpoint -u user -p --concurrency=100 --iterations=10 --create-schema=standin --query="select * from STDIN_CONTA";