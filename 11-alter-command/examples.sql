create table students(
	student_id serial primary key,
	name varchar(100) not null,
	age  integer check (age > 0)
);

insert into students(name, age)
values
	('raquib', 21),
	('amaan', 31);

select * from students;

alter table students
add column email varchar(100) default 'not provided';

alter table students
drop column email;

alter table students
rename column name to full_name;

alter table students
drop column age;

alter table students
add column age bigint default 18;

alter table students
alter column age type smallint;

alter table students
alter column age set default 18;

alter table students
alter column age drop default;

alter table students
add constraint age_check check(age >= 0);

insert into students(full_name, age)
values
	('imran', 17);

alter table students
add constraint students_pkey primary key;

alter table students
rename to school_students; 