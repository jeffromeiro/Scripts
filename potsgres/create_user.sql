-- Create user and Select all tables
--postgres

--drop user usr_microfocus:
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE SELECT ON TABLES from usr_microfocus;
drop role usr_microfocus;

--create user user_onetrust:
CREATE ROLE user_onetrust WITH  
LOGIN
NOSUPERUSER
NOCREATEDB
NOCREATEROLE
INHERIT
NOREPLICATION
CONNECTION LIMIT -1
PASSWORD 'admin'
;
	
GRANT readonly TO user_onetrust;
COMMENT ON ROLE user_onetrust IS 'C2112-734, Usuário utilizado pela equipe de SI - Segurancao da Informação';

--

CREATE ROLE dba_monitor WITH  
LOGIN
NOSUPERUSER
NOCREATEDB
NOCREATEROLE
INHERIT
NOREPLICATION
CONNECTION LIMIT -1
PASSWORD 'admin'
;
	
GRANT readonly, dba TO dba_monitor;
COMMENT ON ROLE dba_monitor IS 'Usuário utilizado pela equipe de DBA';


