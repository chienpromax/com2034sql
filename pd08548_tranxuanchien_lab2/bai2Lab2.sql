--➢ Chương trình tính diện tích, chu vi hình chữ nhật khi biết chiều dài và chiều 
--rộng.
--p= 2 *(a+b) chu vi 
--s= a*b dien tich
--a chieu dai, b chieu rong
declare @a int, @b int,@p int,@s int
set @a=10
set @b=15
set @s=@a*@b
set @p=2*(@a*@b)
select @p as 'chu vi', @s as 'dien tich'

--1. Cho biêt nhân viên có lương cao nhất
declare @MaxLuong int 
set @MaxLuong=(select max(LUONG) from NHANVIEN)
select @MaxLuong as'luong nhan vien cao nhat',* from NHANVIEN
where LUONG=@MaxLuong

--2. Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương 
--trên mức lương trung bình của phòng "Nghiên cứu”
declare @TBLuong int
set @TBLuong=(select AVG(LUONG) from NHANVIEN)
select @TBLuong as'Trung Bình Lương nhân viên'
select HONV+' '+TENLOT+' '+TENNV as N'Tên nhân viên',LUONG,TENPHG from NHANVIEN
inner join PHONGBAN
on NHANVIEN.PHG = PHONGBAN.MAPHG
where LUONG > @TBLuong and TENPHG like N'Nghiên Cứu'

--3. Với các phòng ban có mức lương trung bình trên 30,000, liệt kê tên
--phòng ban và số lượng nhân viên của phòng ban đó.
--select AVG(Luong) as'luong TB phòng' from NHANVIEN
--group by PHG
--select TENPHG, COUNT(MaNV) as'so luong' from NHANVIEN
--inner join PHONGBAN on NHANVIEN.PHG= PHONGBAN.MAPHG
--group by TENPHG
--having  avg(luong)>30000

declare @Table table (MaPB int ,TenPB nvarchar(50),LuongTB float, SoLuong int )
insert into @Table
select  MAPHG,TENPHG,avg(LUONG),count(MaNV) from NHANVIEN
inner join PHONGBAN on NHANVIEN.PHG=PHONGBAN.MAPHG
group by MAPHG,TENPHG
having avg(Luong)>30000
select * from @Table

--4. Với mỗi phòng ban, cho biết tên phòng ban và số lượng đề án mà
--phòng ban đó chủ trì
declare @tableBai4 table (TenPHG Nvarchar(50),MaDA int )
insert into @tableBai4
select TENPHG,COUNT(MaDA) from DEAN
inner join PHONGBAN on PHONGBAN.MAPHG= DEAN.PHONG
group by PHONG,TENPHG
select TENPHG,(MaDA)as 'so Luong De an' from @tableBai4