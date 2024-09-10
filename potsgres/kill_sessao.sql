select pg_cancel_backend(pid); -- elimina o processo e a conexão do usuário permanece
--ou
select pg_terminate_backend(pid); -- elimina o processo e a sessão
--ou
select pg_terminate_backend(pid) from pg_stat_activity where usename ='digitar o usuário' -- elimina o processo de um usuário especifico
