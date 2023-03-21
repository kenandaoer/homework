查询"01"课程比"02"课程成绩高的学生的信息及课程分数
select s.*,s2.s_score,s3.s_score 
  from student s 
     join score s2 on s.s_id = s2.s_id and s2.c_id = '01'
     join score s3 on s.s_id = s3.s_id and s3.c_id = '02'
  where s2.s_score > s3.s_score


查询"01"课程比"02"课程成绩低的学生的信息及课程分数
select s.*,s2.s_score,s3.s_score 
  from student s 
     join score s2 on s.s_id = s2.s_id and s2.c_id = '01'
     join score s3 on s.s_id = s3.s_id and s3.c_id = '02'
  where s2.s_score < s3.s_score
  
查询平均成绩大于等于 60 分的同学的学生编号和学生姓名和平均成绩
select ss.s_id,st.s_name,ss.avg_score
  from student st
  join
  (
    select s_id,avg(s_score) as avg_score 
	  from score 
	  group by s_id having avg_score >= 60
  ) ss on ss.s_id = st.s_id;


查询平均成绩小于 60 分的同学的学生编号和学生姓名和平均成绩 (包括有成绩的和无成绩的)
select st.s_id,st.s_name,ss.avg_score
  from student st
  left join
  (
    select s_id,avg(s_score) as avg_score 
  from score 
  group by s_id 
  ) ss on ss.s_id = st.s_id
  where avg_score < 60 or avg_score is null;

查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩
select s.s_id,s.s_name,total_course,total_score
from student s
join (
select s_id,count(c_id) as total_course ,sum(s_score) as total_score
from score
group by s_id
)  temp
on temp.s_id = s.s_id;

查询"李"姓老师的数量
select count(*)
from teacher
where t_name like '李%';

查询学过"张三"老师授课的同学的信息
select st.*,c.c_name,t.t_name from student st
 left join score s on s.s_id = st.s_id
 left join course c on s.c_id = c.c_id
 left join teacher t on c.t_id = t.t_id
 where t.t_name = '张三';

 查询没学过"张三"老师授课的同学的信息
 select * from student st
 left join 
  (
select st.*,c.c_name,t.t_name from student st
left join score s on s.s_id = st.s_id
left join course c on s.c_id = c.c_id
left join teacher t on c.t_id = t.t_id
where t.t_name = '张三'
  ) temp on temp.s_id = st.s_id
  where temp.t_name is null;

查询学过编号为"01"并且也学过编号为"02"的课程的同学的信息
select st.* from student st
join score s on s.s_id = st.s_id and s.c_id = '01'
join score s2 on s2.s_id = st.s_id and s2.c_id = '02';

查询学过编号为"01"但是没有学过编号为"02"的课程的同学的信息
select s.*, s3.c_id
from student s
         join score s2 on s.s_id = s2.s_id and s2.c_id = '01'
         left join score s3 on s.s_id = s3.s_id and s3.c_id = '02'
where s3.c_id is null;

查询没有学全所有课程的同学的信息
select s.s_id,s.s_name,count(s2.c_id) count
from student s 
     left join score s2 on s.s_id = s2.s_id
group by s.s_id,s.s_name 
having count < 3;

查询至少有一门课与学号为"01"的同学所学相同的同学的信息
select s.*, row_number() over (partition by s.s_id order by s.s_id) rk
from student s
         join (select c_id
               from score
               where s_id = '01') temp1
         join (select s_id,
                      c_id
               from score) temp2
              on temp1.c_id = temp2.c_id and s.s_id = temp2.s_id
group by s.s_id, s.s_name, s.s_birth, s.s_sex;

查询和"01"号的同学学习的课程完全相同的其他同学的信息
select s.*
from student s
         join (select s_id, concat_ws('|', collect_set(c_id)) course1
               from score
               group by s_id
               having s_id != '01') temp1
              on s.s_id = temp1.s_id
         join (select concat_ws('|', collect_set(c_id)) course2 from score group by s_id having s_id = '01') temp2
              on temp1.course1 = temp2.course2;

查询没学过"张三"老师讲授的任一门课程的学生姓名
select s.*
from student s
         left join (select *
                    from score s2
                             join course c on s2.c_id = c.c_id
                             join teacher t on c.t_id = t.t_id and t_name = '张三') t1 on s.s_id = t1.s_id
where t1.t_name is null;

查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
select s.*, s2.avg_score
from student s
         join (select s_id,
                      count(c_id)  count_fail,
                      avg(s_score) avg_score
               from score
               where s_score < 60
               group by s_id) s2
              on s.s_id = s2.s_id;

