insert into judge(judge_name) values('Lukasz Ciszak');
insert into judge(judge_name) values('Antonious Gale');
insert into judge(judge_name) values('Patrick Thies');
insert into judge(judge_name) values('Monica Tusinean');
insert into judge(judge_name) values('Patrick Lozano');

insert into contest(contest_name) values ('Euro Freestyle Championships 2022');

insert into rider(rider_name) values ('Matej Kouba');
insert into rider(rider_name) values ('Guenter Mokulys');
insert into rider(rider_name) values ('Jakub Janczewski');
insert into rider(rider_name) values ('Marius Constantin');
insert into rider(rider_name) values ('Nenad Kocic');
insert into rider(rider_name) values ('Hayato Kojima');

insert into contest_judge values(1,1,'head judge');
insert into contest_judge values(2,1,'judge');
insert into contest_judge values(3,1,'judge');
insert into contest_judge values(4,1,'judge');
insert into contest_judge values(5,1,'judge');

insert into contest_rider (rider_id,contest_id,division)
select r.rider_id, c.contest_id , 'Rookie'
from rider r cross join contest c
where c.contest_name ='Euro Freestyle Championships 2022'
and r.rider_name='Matej Kouba';

insert into contest_rider (rider_id,contest_id,division)
select r.rider_id, c.contest_id , 'Amateurs'
from rider r cross join contest c
where c.contest_name ='Euro Freestyle Championships 2022'
and r.rider_name='Nenad Kocic';

insert into contest_rider (rider_id,contest_id,division)
select r.rider_id, c.contest_id , 'Pro'
from rider r cross join contest c
where c.contest_name ='Euro Freestyle Championships 2022'
and r.rider_name='Marius Constantin';

insert into contest_rider (rider_id,contest_id,division)
select r.rider_id, c.contest_id , 'Girls'
from rider r cross join contest c
where c.contest_name ='Euro Freestyle Championships 2022'
and r.rider_name='Jakub Janczewski';

insert into contest_rider (rider_id,contest_id,division)
select r.rider_id, c.contest_id , 'Masters'
from rider r cross join contest c
where c.contest_name ='Euro Freestyle Championships 2022'
and r.rider_name='Guenter Mokulys';

insert into contest_rider (rider_id,contest_id,division)
select r.rider_id, c.contest_id , 'Sponsored Amateurs'
from rider r cross join contest c
where c.contest_name ='Euro Freestyle Championships 2022'
and r.rider_name='Hayato Kojima';
