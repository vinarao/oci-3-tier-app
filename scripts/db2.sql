alter session set "_ORACLE_SCRIPT"=true; 

CREATE USER dbfirst IDENTIFIED BY "DevOps_123#"
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users; 

GRANT CONNECT, DBA to dbfirst;

GRANT create table, create sequence to dbfirst;

GRANT all privileges to dbfirst;

CREATE TABLE "DBFIRST"."DEPT" (
  given_name  VARCHAR2(100) NOT NULL
);


INSERT INTO "DBFIRST"."DEPT"
VALUES ('Welcome to Virtual Networking HUB');

commit;
