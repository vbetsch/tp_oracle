-- ADMIN BDD TD final - DEV B
-- Auteur: Victor BETSCH
-- Date de rendue maximum : 06/12/2022 à 18h
-- Coefficient : 3
-- Temps conseillé : 8h
-- Sujet choisi: Plateforme de musiques (SpotHiFi)

-- PARTIE 1

/*
    ----- EXPLICATION -----

    (Partie 1) Je vais ici créer une base de données sécurisée d'une plateforme de musiques (SpotHiFi).
    J'entends par "sécurisée" une base de données structurée constituée de tables
    (LISTENINGS, SONGS, PLAYLISTS, ALBUMS, ARTISTS, AUDITORS), de contraintes d'intégrité (PRIMARY KEY et FOREIGN KEY pour relier
    toutes les tables) et de tablespaces (TBS_LABELS, TBS_CLIENTS, TBS_USERDATA).

    (Partie 2) La base sera administrée par 4 utilisateurs (ADMIN, PRODUCER, ARTIST, AUDITOR) ayants des privilèges
    associés à leurs rôles respectifs (ADMIN et CLIENT) et des limites associées à leurs profils (COMMON et APP).
    Ils seront associés aux tablespaces qui leur convient.
    Les nouvelles fonctionnalités envisagées par le chef de projet impliquent la création de requêtes complexes
    ("The trendiest album", "The frequency of album published per month", "The number of listeners per country",
    "The most productive artists"), de vues ("Price per album", "The best song of the year", "Your number of listenings in the year",
    "Your last 10 albums listened to"), de fonctions ("The last music listened to by a user",
    "The history of the music listened to") et d'une instruction composée permettant de créer un nouvel album lorsqu'on
    ajoute une musique avec un album non-existant.

*/

-- CONFIGURE SGA TO 999Mo
ALTER system SET sga_target=999M SCOPE=SPFILE;

-- CONFIGURE PGA TO 200Mo per user so 200*4 = 800Mo
ALTER system SET pga_aggregate_target=800M;


-- TABLESPACES
CREATE TABLESPACE TD_TBS_LABELS
DATAFILE 'tbs_labels.dbf' SIZE 10M
AUTOEXTEND ON NEXT 20M
MAXSIZE 100M
ONLINE;

CREATE UNDO TABLESPACE TD_TBS_CLIENTS
DATAFILE 'tbs_clients.dbf' SIZE 10M
AUTOEXTEND ON NEXT 20M
MAXSIZE 100M;

CREATE TEMPORARY TABLESPACE TD_TBS_USERDATA
TEMPFILE 'tbs_userdata.dbf' SIZE 10M
AUTOEXTEND ON NEXT 20M
MAXSIZE 100M;


-- USERS
CREATE USER TD_ADMIN
    IDENTIFIED BY adm1n;

CREATE USER TD_PRODUCER
    IDENTIFIED BY pr0duc3r;

CREATE USER TD_ARTIST
    IDENTIFIED BY art1st;

CREATE USER TD_AUDITOR
    IDENTIFIED BY aud1t0r;


-- TABLES
CREATE TABLE SYSTEM.TD_ARTIST (
    ID NUMBER(8) GENERATED AS IDENTITY
        PRIMARY KEY,
    NAME VARCHAR2(255) NOT NULL
);

CREATE TABLE SYSTEM.TD_ALBUM (
    ID NUMBER(8) GENERATED AS IDENTITY
        PRIMARY KEY,
    NAME VARCHAR2(255) NOT NULL,
    RELEASE_DATE DATE NULL
);

CREATE TABLE SYSTEM.TD_AUDITOR (
    ID NUMBER(8) GENERATED AS IDENTITY
        PRIMARY KEY,
    NAME VARCHAR2(255) NOT NULL,
    MAIL VARCHAR2(255) NULL,
    AGE NUMBER(8) NULL,
    COUNTRY VARCHAR2(255) NULL
);

CREATE TABLE SYSTEM.TD_SONG (
    ID NUMBER(8) GENERATED AS IDENTITY
        PRIMARY KEY,
    NAME VARCHAR2(255) NOT NULL,
    PRICE FLOAT NULL,
    ALBUM_ID NUMBER(8) NULL,
    CONSTRAINT FK_SONG_ALBUM FOREIGN KEY (ALBUM_ID)
        REFERENCES TD_ALBUM(ID)
);

CREATE TABLE SYSTEM.TD_LISTENING (
    ID NUMBER(8) GENERATED AS IDENTITY
        PRIMARY KEY,
    AUDITOR_ID NUMBER(8) NOT NULL,
    SONG_ID NUMBER(8) NOT NULL,
    LISTEN_DATE DATE NULL,
    CONSTRAINT FK_LISTENING_AUDITOR FOREIGN KEY (AUDITOR_ID)
        REFERENCES TD_AUDITOR(ID),
    CONSTRAINT FK_LISTENING_SONG FOREIGN KEY (SONG_ID)
        REFERENCES TD_SONG(ID)
);

CREATE TABLE SYSTEM.TD_PLAYLIST (
    ID NUMBER(8) GENERATED AS IDENTITY
        PRIMARY KEY,
    NAME VARCHAR2(255) NOT NULL,
    AUDITOR_ID NUMBER(8) NOT NULL,
    CONSTRAINT FK_PLAYLIST_AUDITOR FOREIGN KEY (AUDITOR_ID)
        REFERENCES TD_AUDITOR(ID)
);

CREATE TABLE SYSTEM.TD_COMPOSED_OF (
    ID NUMBER(8) GENERATED AS IDENTITY
        PRIMARY KEY,
    PLAYLIST_ID NUMBER(8) NOT NULL,
    SONG_ID NUMBER(8) NOT NULL,
    CONSTRAINT FK_COMPOSEDOF_PLAYLIST FOREIGN KEY (PLAYLIST_ID)
        REFERENCES TD_PLAYLIST(ID),
    CONSTRAINT FK_COMPOSEDOF_SONG FOREIGN KEY (SONG_ID)
        REFERENCES TD_SONG(ID)
);

CREATE TABLE SYSTEM.TD_PRODUCED_BY (
    ID NUMBER(8) GENERATED AS IDENTITY
        PRIMARY KEY,
    SONG_ID NUMBER(8) NOT NULL,
    ARTIST_ID NUMBER(8) NOT NULL,
    CONSTRAINT FK_PRODUCEDBY_SONG FOREIGN KEY (SONG_ID)
        REFERENCES TD_SONG(ID),
    CONSTRAINT FK_PRODUCEDBY_ARTIST FOREIGN KEY (ARTIST_ID)
        REFERENCES TD_ARTIST(ID)
);