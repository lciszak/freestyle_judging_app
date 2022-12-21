SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';

SET search_path = public, pg_catalog;
SET default_tablespace = '';
SET default_with_oids = false;

CREATE SEQUENCE contest_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.contest_seq OWNER TO fsrest;

CREATE SEQUENCE judge_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.judge_seq OWNER TO fsrest;

CREATE SEQUENCE rider_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.rider_seq OWNER TO fsrest;

create table contest(
    contest_id integer DEFAULT nextval('contest_seq'::regclass) primary key,
    contest_name varchar(255)
);
ALTER TABLE public.contest OWNER TO fsrest;


create table judge(
    judge_id integer DEFAULT nextval('judge_seq'::regclass) primary key,
    judge_name varchar(255)
);
ALTER TABLE public.judge OWNER TO fsrest;

create table rider(
    rider_id integer DEFAULT nextval('rider_seq'::regclass) primary key,
    rider_name varchar(255)
);
ALTER TABLE public.rider OWNER TO fsrest;

create table contest_rider(
    rider_id integer,
    contest_id integer,
    division varchar(100)
);
ALTER TABLE public.contest_rider OWNER TO fsrest;
alter table public.contest_rider add constraint contest_rider_pk primary key (rider_id,contest_id);
alter table public.contest_rider add constraint rider_fk foreign key(rider_id) references rider(rider_id);
alter table public.contest_rider add constraint contest_fk foreign key(contest_id) references contest(contest_id);

create table contest_judge(
	judge_id int,
	contest_id int,
	contest_role varchar(100)
);
alter table contest_judge add constraint contest_judge_pk primary key(judge_id,contest_id);
ALTER TABLE public.contest_judge OWNER TO fsrest;

create table run_score(
    rider_id integer,
    contest_id integer,
    judge_id integer,
    run_num integer,
    contest_round varchar(100)
);
ALTER TABLE public.run_score OWNER TO fsrest;
alter table public.run_score add constraint run_score_pk primary key (rider_id,contest_id,judge_id,run_num,contest_round);
alter table run_score  add constraint contest_judge_fk foreign key(judge_id,contest_id) references contest_judge(judge_id,contest_id);

create table run_score_point(
    rider_id integer,
    contest_id integer,
    judge_id integer,
    run_num integer,
    contest_round varchar(100),
    point_type varchar(100),
    point_value numeric
);
ALTER TABLE public.run_score_point OWNER TO fsrest;
alter table public.run_score_point add constraint run_score_point_pk primary key (rider_id, contest_id,judge_id,run_num,contest_round,point_type);
alter table public.run_score_point add constraint run_score_fk foreign key (rider_id, contest_id,judge_id,run_num,contest_round) references run_score (rider_id, contest_id,judge_id,run_num,contest_round);