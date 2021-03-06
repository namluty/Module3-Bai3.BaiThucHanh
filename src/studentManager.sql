CREATE DATABASE QuanLySinhVien;
USE QuanLySinhVien;
CREATE TABLE Class
(
    ClassID   INT         NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ClassName VARCHAR(60) NOT NULL,
    StartDate DATETIME    NOT NULL,
    Status    BIT
);
INSERT INTO Class
VALUES (1, 'A1', '2008-12-20', 1);
INSERT INTO Class
VALUES (2, 'A2', '2008-12-22', 1);
INSERT INTO Class
VALUES (3, 'B3', current_date, 0);


CREATE TABLE Student
(
    StudentId   INT         NOT NULL AUTO_INCREMENT PRIMARY KEY,
    StudentName VARCHAR(30) NOT NULL,
    Address     VARCHAR(50),
    Phone       VARCHAR(20),
    Status      BIT,
    ClassId     INT         NOT NULL,
    FOREIGN KEY (ClassId) REFERENCES Class (ClassID)
);
INSERT INTO Student (StudentName, Address, Phone, Status, ClassId)
VALUES ('Hung', 'Ha Noi', '0912113113', 1, 1);
INSERT INTO Student (StudentName, Address, Status, ClassId)
VALUES ('Hoa', 'Hai phong', 1, 1);
INSERT INTO Student (StudentName, Address, Phone, Status, ClassId)
VALUES ('Manh', 'HCM', '0123123123', 0, 2);

CREATE TABLE Subject
(
    SubId   INT         NOT NULL AUTO_INCREMENT PRIMARY KEY,
    SubName VARCHAR(30) NOT NULL,
    Credit  TINYINT     NOT NULL DEFAULT 1 CHECK ( Credit >= 1 ),
    Status  BIT                  DEFAULT 1
);
INSERT INTO Subject
VALUES (1, 'CF', 5, 1),
       (2, 'C', 6, 1),
       (3, 'HDJ', 5, 1),
       (4, 'RDBMS', 10, 1);

CREATE TABLE Mark
(
    MarkId    INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    SubId     INT NOT NULL,
    StudentId INT NOT NULL,
    Mark      FLOAT   DEFAULT 0 CHECK ( Mark BETWEEN 0 AND 100),
    ExamTimes TINYINT DEFAULT 1,
    UNIQUE (SubId, StudentId),
    FOREIGN KEY (SubId) REFERENCES Subject (SubId),
    FOREIGN KEY (StudentId) REFERENCES Student (StudentId)
);
INSERT INTO Mark (SubId, StudentId, Mark, ExamTimes)
VALUES (1, 1, 8, 1),
       (1, 2, 10, 2),
       (2, 1, 12, 1);

SELECT *
FROM Student;

SELECT *
FROM Student
WHERE Status = true;

SELECT *
FROM Subject
WHERE Credit < 10;

SELECT S.StudentId, S.StudentName, C.ClassName
FROM Student S join Class C on S.ClassId = C.ClassID;

SELECT S.StudentId, S.StudentName, C.ClassName
FROM Student S join Class C on S.ClassId = C.ClassID
WHERE C.ClassName = 'A1';

SELECT S.StudentId, S.StudentName, Sub.SubName, M.Mark
FROM Student S join Mark M on S.StudentId = M.StudentId
    join Subject Sub on M.SubId = Sub.SubId;

SELECT S.StudentId, S.StudentName, Sub.SubName, M.Mark
FROM Student S join Mark M on S.StudentId = M.StudentId join Subject Sub on M.SubId = Sub.SubId
WHERE Sub.SubName = 'CF';

# Hi???n th??? t???t c??? c??c sinh vi??n c?? t??n b???t ?????u b???ng k?? t??? ???H???
select * from Student where StudentName like 'H%';
# Hi???n th??? c??c th??ng tin l???p h???c c?? th???i gian b???t ?????u v??o th??ng 12.
select * from class where Class.StartDate;
# Hi???n th??? t???t c??? c??c th??ng tin m??n h???c c?? credit trong kho???ng t??? 3-5.
select * from Subject where Credit between 3 and 5;
# Thay ?????i m?? l???p(ClassID) c???a sinh vi??n c?? t??n ???Hung??? l?? 2.
update Student set ClassID = 2 where StudentName = 'Hung';
# Hi???n th??? c??c th??ng tin: StudentName, SubName, Mark. D??? li???u s???p x???p theo ??i???m thi (mark) gi???m d???n. n???u tr??ng s???p theo t??n t??ng d???n.
select s.StudentName , s2.SubName, Mark from mark join student s on s.StudentId = mark.StudentId
                                                 join subject s2 on s2.SubId = mark.SubId order by SubName asc, Mark desc;

use QuanLySinhVien;

#S??? d???ng h??m count ????? hi???n th??? s??? l?????ng sinh vi??n ??? t???ng n??i
SELECT Address, COUNT(StudentId) AS 'S??? l?????ng h???c vi??n'
FROM Student
GROUP BY Address;

#T??nh ??i???m trung b??nh c??c m??n h???c c???a m???i h???c vi??n b???ng c??ch s??? d???ng h??m AVG
select s.StudentId, StudentName, avg(Mark) from Student s
    join Mark M on s.StudentId = M.StudentId group by s.StudentId, s.StudentName;

#Hi???n th??? nh???ng b???n h???c vi??n co ??i???m trung b??nh c??c m??n h???c l???n h??n 15
select s.StudentId, StudentName, avg(Mark) from Student s
    join Mark M on s.StudentId = M.StudentId group by s.StudentId, s.StudentName having avg(Mark) > 15;

#Hi???n th??? th??ng tin c??c h???c vi??n c?? ??i???m trung b??nh l???n nh???t.
SELECT S.StudentId, S.StudentName, AVG(Mark)
FROM Student S join Mark M on S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName
HAVING AVG(Mark) >= ALL (SELECT AVG(Mark) FROM Mark GROUP BY Mark.StudentId);

#Hi???n th??? t???t c??? c??c th??ng tin m??n h???c (b???ng subject) c?? credit l???n nh???t.
select * from subject where Credit >= all(select Credit from subject);


#Hi???n th??? c??c th??ng tin m??n h???c c?? ??i???m thi l???n nh???t.
select subject.SubId, SubName, Credit, Status, Mark.Mark from subject join mark on subject.SubId = mark.SubId
where Mark >= all(select Mark from mark);

#Hi???n th??? c??c th??ng tin sinh vi??n v?? ??i???m trung b??nh c???a m???i sinh vi??n, x???p h???ng theo th??? t??? ??i???m gi???m d???n
select StudentName,Address,Phone,Status, avg(Mark) as avgmark from mark
    join student on mark.StudentId = student.StudentId group by mark.StudentId order by avgmark desc;
