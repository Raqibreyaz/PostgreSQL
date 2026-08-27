create table students (
	student_id serial primary key,
	name varchar(100) not null
);

insert into students(name)
values
	('raquib'),
	('imran'),
	('amaan');

create table student_profiles (
	student_id integer primary key,
	address text,
	age smallint,
	phone varchar(15)
);


insert into student_profiles (student_id, address, age, phone)
values
	(1, 'Delhi', 23, '9876543210'),
	(2, 'Mumbai', 22, '9876543210'),
	(3, 'Bangalore', 24, '9876543210');

alter table student_profiles
add constraint fk_student_id
foreign key (student_id)
references students(student_id);

select * from student_profiles;
select * from students;

select 
	s.student_id, 
	s.name, 
	sp.address,
	sp.age,
	sp.phone
from students s
join student_profiles sp
on s.student_id = sp.student_id;


