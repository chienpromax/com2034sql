--Bài 1: (3 điểm)
--Viết trigger DML:
--➢ Ràng buộc khi thêm mới nhân viên thì mức lương phải lớn hơn 15000, nếu vi phạm thì 
--xuất thông báo “luong phải >15000’
create trigger lab6bai1a on NHANVIEN
for insert 
as
	if (select LUONG from inserted)<15000
begin
	print 'luong lon hon 15000'
	rollback transaction
end
insert into NHANVIEN values ('phan','thi','khacha','401','1990-01-01',
'dak lak','nam',11500,'002',4)

drop trigger lab6bai1
select * from nhanvien
delete from NHANVIEN where MANV = '401'

--➢ Ràng buộc khi thêm mới nhân viên thì độ tuổi phải nằm trong khoảng 18 <= tuổi <=65.
--xuất thông báo “luong phải >15000’
create trigger lab6bai1b on NHANVIEN
for insert 
as
	if ((select year(getdate())-year(NGSINH) from inserted) not between 18 and 65)
begin 
	print'tuoi phai 18<tuoi<65'
rollback transaction
end
insert into NHANVIEN values ('phan','thi','khacha','501','2010-01-01',
'dak lak','nam',111500,'002',4)

drop trigger lab6bai1b
select * from nhanvien
select * from PHONGBAN


--➢ Ràng buộc khi cập nhật nhân viên thì không được cập nhật những nhân viên ở TP HCM
create trigger lab6bai1c on NHANVIEN
for update as
if (select DCHI from inserted) like '%TP HCM%'
begin
print'khong dc cap nhat NV TP HCM'
rollback transaction
end
update NHANVIEN set LUONG = 100000 where MANV ='001'
drop trigger lab6bai1c
--Bài 2: (3 điểm)
--Viết các Trigger AFTER:
--➢ Hiển thị tổng số lượng nhân viên nữ, tổng số lượng nhân viên nam mỗi khi có hành động 
--thêm mới nhân viên.

create trigger lab6bai2a on nhanvien 
after insert as
begin
	declare @a char,@b char
	select @a =count(*) from nhanvien where phai = 'Nam' group by phai
	select @b =count(*) from nhanvien where phai = N'Nữ' group by phai
	print N'Sô lượng nhân viên nam sau khi thêm là ' + @a
	print N'Sô lượng nhân viên nữ sau khi thêm là ' + @b
end

insert into nhanvien
values(N'Nguyễn',N'thi',N'thu','016','1960-03-11',
N'45 Lê Văn Sỹ,da nang',N'Nữ',20000,'001',4)

delete from NHANVIEN where MANV = '016'
--➢ Hiển thị tổng số lượng nhân viên nữ, tổng số lượng nhân viên nam mỗi khi có hành động 
--cập nhật phần giới tính nhân viên
create trigger lab6bai2b on nhanvien 
after update as
begin
	declare @nam char,@nu char
	select @nam =count(*) from nhanvien where phai = 'Nam' group by phai
	select @nu =count(*) from nhanvien where phai = N'Nữ' group by phai
	print N'Sô lượng nhân viên nam sau khi thêm là ' + @nam
	print N'Sô lượng nhân viên nữ sau khi thêm là ' + @nu
end

update nhanvien set phai = N'nam' where manv = '016'
--➢ Hiển thị tổng số lượng đề án mà mỗi nhân viên đã làm khi có hành động xóa trên bảng 
--DEAN
create trigger lab6bai2c on dean 
after delete as
begin
	select ma_nvien,count(*) from phancong
	group by ma_nvien
end

delete from dean where MADA = 100
insert into DEAN values ('code dao',100,'da nang',4)

--Bài 3: (3 điểm)
--Viết các Trigger INSTEAD OF
--Quản trị cơ sở dữ liệu với SQL Server 2
--➢ Xóa các thân nhân trong bảng thân nhân có liên quan khi thực hiện hành động xóa nhân 
--viên trong bảng nhân viên.
create trigger lab6bai3a on nhanvien
instead of delete as 
begin
	delete from thannhan where ma_nvien in
	(select manv from deleted)
	print N'ok'
end
drop trigger lab6bai3a
delete from nhanvien where manv = '001'

--➢ Khi thêm một nhân viên mới thì tự động phân công cho nhân viên làm đề án có MADA 
--là 1. 
create trigger lab6bai3b on nhanvien
instead of insert as
begin
	insert into NHANVIEN select  * from inserted 
	insert into phancong(mada,ma_nvien,stt,THOIGIAN)
	values(1,(select manv from inserted),2,'20')
end
drop trigger lab6bai3b
insert into nhanvien
values(N'Nguyễn',N'thi',N'thu','016','2000-03-11',
N'45 Lê Văn Sỹ,da nang',N'Nữ',20000,'001',4)

delete from PHANCONG where ma_nvien = '016'
delete from NHANVIEN where MANV = '016'
select * from phancong
select * from NHANVIEN