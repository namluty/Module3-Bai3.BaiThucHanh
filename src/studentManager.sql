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

# Hiển thị tất cả các sinh viên có tên bắt đầu bảng ký tự ‘H’
select * from Student where StudentName like 'H%';
# Hiển thị các thông tin lớp học có thời gian bắt đầu vào tháng 12.
select * from class where Class.StartDate;
# Hiển thị tất cả các thông tin môn học có credit trong khoảng từ 3-5.
select * from Subject where Credit between 3 and 5;
# Thay đổi mã lớp(ClassID) của sinh viên có tên ‘Hung’ là 2.
update Student set ClassID = 2 where StudentName = 'Hung';
# Hiển thị các thông tin: StudentName, SubName, Mark. Dữ liệu sắp xếp theo điểm thi (mark) giảm dần. nếu trùng sắp theo tên tăng dần.
select s.StudentName , s2.SubName, Mark from mark join student s on s.StudentId = mark.StudentId
                                                 join subject s2 on s2.SubId = mark.SubId order by SubName asc, Mark desc;

use QuanLySinhVien;

#Sử dụng hàm count để hiển thị số lượng sinh viên ở từng nơi
SELECT Address, COUNT(StudentId) AS 'Số lượng học viên'
FROM Student
GROUP BY Address;

#Tính điểm trung bình các môn học của mỗi học viên bằng cách sử dụng hàm AVG
select s.StudentId, StudentName, avg(Mark) from Student s
    join Mark M on s.StudentId = M.StudentId group by s.StudentId, s.StudentName;

#Hiển thị những bạn học viên co điểm trung bình các môn học lớn hơn 15
select s.StudentId, StudentName, avg(Mark) from Student s
    join Mark M on s.StudentId = M.StudentId group by s.StudentId, s.StudentName having avg(Mark) > 15;

#Hiển thị thông tin các học viên có điểm trung bình lớn nhất.
SELECT S.StudentId, S.StudentName, AVG(Mark)
FROM Student S join Mark M on S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName
HAVING AVG(Mark) >= ALL (SELECT AVG(Mark) FROM Mark GROUP BY Mark.StudentId);

#Hiển thị tất cả các thông tin môn học (bảng subject) có credit lớn nhất.
select * from subject where Credit >= all(select Credit from subject);


#Hiển thị các thông tin môn học có điểm thi lớn nhất.
select subject.SubId, SubName, Credit, Status, Mark.Mark from subject join mark on subject.SubId = mark.SubId
where Mark >= all(select Mark from mark);

#Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên, xếp hạng theo thứ tự điểm giảm dần
select StudentName,Address,Phone,Status, avg(Mark) as avgmark from mark
    join student on mark.StudentId = student.StudentId group by mark.StudentId order by avgmark desc;
