CREATE USER USR_BDD
    IDENTIFIED BY USR_BDD;

ALTER USER USR_BDD
    ACCOUNT LOCK;

CREATE USER USR_BDD2
    IDENTIFIED BY USR_BDD2
    DEFAULT TABLESPACE TBS_CLIENT
    TEMPORARY TABLESPACE EXERCICE2_TBS
    QUOTA 100K ON TBS_COMPTA
    PASSWORD EXPIRE
    ACCOUNT UNLOCK;

ALTER USER USR_BDD
    IDENTIFIED BY NEW;

DROP USER USR_BDD CASCADE;

ALTER USER USR_BDD2
    QUOTA 50K ON TBS_COMPTA;

ALTER USER USR_BDD2
    DEFAULT TABLESPACE TBS_COMPTA;