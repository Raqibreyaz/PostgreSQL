create table students (
	student_id serial primary key,
	student_name varchar(100)
);

create table courses(
	course_id serial primary key,
	course_name varchar(100)
);

create table student_courses(
	student_id integer,
	course_id integer,
	primary key (student_id, course_id),
	foreign key (student_id) references students(student_id),
	foreign key (course_id) references courses(course_id)
);

insert into students(student_name)
values
	('raquib'),
	('reyaz'),
	('imran');

insert into courses(course_name)
values
	('Python'),
	('SQL'),
	('Node.js');

insert into student_courses(student_id, course_id)
values
	(1, 1),
	(1, 2),
	(2, 1),
	(2, 3),
	(3, 2);

select * from students;
select * from courses;
select * from student_courses;

select 
	s.student_name,
	count(*) as courses_taken
from student_courses sc
join students s 
	on sc.student_id = s.student_id
join courses c
	on sc.course_id  = c.course_id
group by s.student_name;