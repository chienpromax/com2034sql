--Bài 1: (3 điểm)
--Viết stored-procedure:
--➢ In ra dòng ‘Xin chào’ + @ten với @ten là tham số đầu vào là tên Tiếng Việt có dấu của 
create procedure Hello
@Ten nvarchar(20)
as
begin
print 'Hello ' + @Ten
end
exec Hello N'chiến'
drop proc Hello

--➢ Nhập vào 2 số @s1,@s2. In ra câu ‘Tổng là : @tg’ với @tg=@s1+@s2.
create procedure tinhTong @s1 int , @s2 int
as
begin
declare @tong int
set @tong = @s1 + @s2;
print 'Tong la: '+cast(@tong as varchar(100))
end
exec tinhTong 1,2
drop proc tinhTong

--➢ Nhập vào số nguyên @n. In ra tổng các số chẵn từ 1 đến @n.
create procedure soChan @n int
as
begin
declare @tongSC int=0, @i int =0;
	while  @i<@n
	begin
		set @tongSC =@tongSC +@i
		set @i= @i+2
	end
print N'Tổng các số chẵn là: '+cast(@tongSC as varchar(50))
end
exec soChan 90
drop proc soChan

--➢ Nhập vào 2 số. In ra ước chung lớn nhất của chúng theo gợi ý dưới đây:
--o b1. Không mất tính tổng quát giả sử a <= A 
--o b2. Nếu A chia hết cho a thì : (a,A) = a ngược lại : (a,A) = (A%a,a) hoặc (a,A) = 
--(a,A-a) 
--o b3. Lặp lại b1,b2 cho đến khi điều kiện trong b2 được thỏa
create procedure uocChung @a int ,@b int
as
begin
	while (@a != @b)
	begin
		if(@a > @b)
			set @a=@a-@b
		else
			set @b=@b-@a
	end
	print'UCLN: ' + convert(nvarchar(100),@a)
end
exec uocChung 30,40
drop proc uocChung

--Bài 2: (3 điểm)
--Sử dụng cơ sở dữ liệu QLDA, Viết các Proc:
--➢ Nhập vào @Manv, xuất thông tin các nhân viên theo @Manv.
create proc lab5_bai2a @MaNV int
as
begin
if exists(select * from NHANVIEN where MANV=@MaNV)
select * from NHANVIEN where MANV=@MaNV
else
print'khong tim thay'
end
exec lab5_bai2a 017
drop proc lab5_bai2a

--➢ Nhập vào @MaDa (mã đề án), cho biết số lượng nhân viên tham gia đề án đó
create proc lab5_bai2b @MaDA int
as
begin
if exists(select * from PHANCONG where MADA=@MaDA)
select count(*) as'so NV' from PHANCONG where MADA=@MaDA
group by MADA
else
print'khong tim thay'
end
exec lab5_bai2b 30
drop proc lab5_bai2b

--➢ Nhập vào @MaDa và @Ddiem_DA (địa điểm đề án), cho biết số lượng nhân viên tham 
--gia đề án có mã đề án là @MaDa và địa điểm đề án là @Ddiem_DA
create proc lab5_bai2c @MaDA int ,@Ddiem_DA nvarchar(15)
as
begin
if exists(select * from DEAN inner join PHANCONG on PHANCONG.MADA= DEAN.MADA
where DEAN.MADA=@MaDA and DDIEM_DA=@Ddiem_DA
group by PHANCONG.MADA)
select count(*)as 'so luong NV',PHANCONG.MADA from DEAN inner join PHANCONG on PHANCONG.MADA= DEAN.MADA
where DEAN.MADA=@MaDA and DDIEM_DA=@Ddiem_DA
group by PHANCONG.MADA
else
print'khong tim thay'
end
exec lab5_bai2c 1,N'Vũng tàu'
drop proc lab5_bai2c


--➢ Nhập vào @Trphg (mã trưởng phòng), xuất thông tin các nhân viên có trưởng phòng là 
--@Trphg và các nhân viên này không có thân nhân.
create procedure lab5_bai2d @trphg int 
as
begin
if exists(select * from NHANVIEN 
where MA_NQL = @trphg AND MANV not in (SELECT MA_NVIEN FROM THANNHAN))
select * from NHANVIEN
where MA_NQL = @trphg
else
print'co than nhan trong bang'
end

exec lab5_bai2d 001

exec lab5_bai2d 009
drop proc lab5_bai2d


--➢ Nhập vào @Manv và @Mapb, kiểm tra nhân viên có mã @Manv có thuộc phòng ban có 
--mã @Mapb hay không

create proc lab5_bai2e @MaNV int , @Mapb int
as
begin
if exists(select * from NHANVIEN where MANV = @MaNV and PHG = @Mapb)
print'co thuoc'
else
print'khong thuoc'
end
exec lab5_bai2e 001,4

--Bài 3: (3 điểm)
--Sử dụng cơ sở dữ liệu QLDA, Viết các Proc
--➢ Thêm phòng ban có tên CNTT vào csdl QLDA, các giá trị được thêm vào dưới dạng 
--tham số đầu vào, kiếm tra nếu trùng Maphg thì thông báo thêm thất bại.

create proc lab5_bai3a @ten nvarchar(15),@maphg int , @trphg nvarchar(15) ,@ngay date
as
begin
	if exists(select * from PHONGBAN where MAPHG = @maphg)
	print'trung ma maphg'
	else
	begin
	insert into PHONGBAN values(@ten,@maphg,@trphg,@ngay)
	print'ok'
	end
end
exec lab5_bai3a 'CNTT',14,'006','05-30-2023'
drop proc lab5_bai3a
--➢ Cập nhật phòng ban có tên CNTT thành phòng IT.
create procedure lab5_bai3b @ten nvarchar(10),@ten2 nvarchar(10)
as 
begin
	update PHONGBAN set TENPHG = @ten
	where TENPHG = @ten2
end
exec lab5_bai3b 'IT','CNTT'

delete from PHONGBAN where MAPHG =6
--➢ Thêm một nhân viên vào bảng NhanVien, tất cả giá trị đều truyền dưới dạng tham số đầu 
--vào với điều kiện:
--o nhân viên này trực thuộc phòng IT
--o Nhận @luong làm tham số đầu vào cho cột Luong, nếu @luong<25000 thì nhân 
--viên này do nhân viên có mã 009 quản lý, ngươc lại do nhân viên có mã 005 quản 
--lý
--o Nếu là nhân viên nam thi nhân viên phải nằm trong độ tuổi 18-65, nếu là nhân 
--viên nữ thì độ tuổi phải từ 18-60

create proc lab5_bai3c @honv nvarchar(15), @tenlot nvarchar(15), @tennv nvarchar(15),
@manv int , @ngsinh date,@dchi nvarchar(50),@phai nvarchar(5),@luong float ,
@manql nvarchar(5) =null ,@phg int 
as
begin
	declare @age int 
	set @age = YEAR(GETDATE())-YEAR(@ngsinh)
	if @phg = (select MAPHG from PHONGBAN where TENPHG = 'IT')
	begin
	if @luong<25000
		set @manql='009'
	else set @manql='005'
		if (@phai = 'nam' and (@age >=18 and @age <=65))
		or (@phai = N'nữ' and (@age >=18 and @age <=65))
		begin
		insert into NHANVIEN(HONV,TENLOT,TENNV,MANV,NGSINH,DCHI,PHAI,LUONG,MA_NQL,PHG)
		values(@honv,@tenlot,@tennv,@manv,@ngsinh,@dchi,@phai,@luong,@manql,@phg)
		end
	end
	else print'khong thuoc it'
end
exec lab5_bai3c 'tran','xuan','chien',007,'2000-05-05',N'đà nẵng','nam',100000,
004,14
select * from NHANVIEN
select * from PHONGBAN
select * from PHANCONG
delete NHANVIEN where MANV = 007
