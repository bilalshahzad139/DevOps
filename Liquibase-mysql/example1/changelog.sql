--liquibase formatted sql

--changeset bilalshahzad:1
create table person (
    id int primary key,
    name varchar(50) not null,
    address1 varchar(50),
    address2 varchar(50),
    city varchar(30)
)

--changeset bilalshahzad:2
create table teacher (
    id int primary key,
    name varchar(50) not null,
    address1 varchar(50),
    address2 varchar(50),
    city varchar(30)
)

--changeset bilalshahzad:3 endDelimiter://
//
DROP PROCEDURE IF EXISTS new_procedure1;
//
CREATE PROCEDURE new_procedure1 ()
BEGIN
	select * from teacher;
END//