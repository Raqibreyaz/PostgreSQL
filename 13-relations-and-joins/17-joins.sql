insert into students(name)
values('salman');

select * from students;
select * from marks;

select s.name, m.subject, m.marks 
from students s
full join marks m
on s.student_id = m.student_id;
--where name = 'raquib';

insert into marks(student_id, subject, marks) 
values(7, 'english', 83);