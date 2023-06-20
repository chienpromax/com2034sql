--Bài 1: (4 điểm)
--Viết các hàm:
--➢ Nhập vào MaNV cho biết tuổi của nhân viên này.
create function lab7bai1a (@manv nvarchar(9)) 
returns int
as
begin
	return(select year(getdate())-year(NGSINH)
	from nhanvien where MANV = @manv)
end
PRINT CAST(dbo.lab7bai1a('001') as nvarchar(20))
go

--➢ Nhập vào Manv cho biết số lượng đề án nhân viên này đã tham gia
go
alter function lab7bai1b (@manv nvarchar(9)) 
returns int
as
begin
return(select count(*) from PHANCONG
WHERE MA_NVIEN = @manv
group by MA_NVIEN)
end
go
print dbo.lab7bai1b('001')
--➢ Truyền tham số vào phái nam hoặc nữ, xuất số lượng nhân viên theo phái
go
create function lab7bai1c (@gt nvarchar(3)) 
returns int
as
begin
return(select count(MANV) from NHANVIEN
WHERE PHAI = @gt
group by phai)
end
go 
print'nam '+cast(dbo.lab7bai1c('nam') as nvarchar(10))
print'nu '+cast(dbo.lab7bai1c(N'Nữ') as nvarchar(10))
--➢ Truyền tham số đầu vào là tên phòng, tính mức lương trung bình của phòng đó, Cho biết 
--họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương trung bình 
--của phòng đó.
go
create function lab7bai1d (@tenPhg int) 
returns table
as
return( 
select HONV,TENLOT,TENNV,luong from NHANVIEN 
WHERE LUONG >( select avg(luong) from NHANVIEN) and PHG = @tenPhg)
go 
select * from lab7bai1d('1')
--➢ Tryền tham số đầu vào là Mã Phòng, cho biết tên phòng ban,
--họ tên người trưởng phòng 
--và số lượng đề án mà phòng ban đó chủ trì.
go
create function lab7bai1e (@maPhg int) 
returns @tbLab7 table(tenphg nvarchar(15),honv nvarchar(15),tennv nvarchar(15),soLuong int)
as
begin
insert into @tbLab7
select TENPHG,HONV,TENNV,count(MADA)as 'so luong' from PHONGBAN
inner join NHANVIEN on MANV = TRPHG
inner join dean on DEAN.PHONG  = PHONGBAN.MAPHG
WHERE MAPHG = @maPhg 
group by TENPHG,TRPHG,TENNV,HONV
return
end
go 
select * from lab7bai1e('1')

drop function lab7bai1e

--Bài 2: (4 điểm)
--Tạo các view:
--➢ Hiển thị thông tin HoNV,TenNV,TenPHG, DiaDiemPhg.
go
create view lab7bai2a
as
select HONV,TENNV,TENPHG,DIADIEM_PHG.DIADIEM from NHANVIEN
inner join PHONGBAN on PHONGBAN.MAPHG = NHANVIEN.PHG
inner join DIADIEM_PHG on DIADIEM_PHG.MAPHG= PHONGBAN.MAPHG
group by HONV,TENNV,TENPHG,DIADIEM_PHG.DIADIEM
select * from lab7bai2a
--➢ Hiển thị thông tin TenNv, Lương, Tuổi.
go
create view lab7bai2b
as
select TENNV,LUONG,year(getdate())-year(NGSINH) as 
'tuoi' from NHANVIEN
select * from lab7bai2b
--➢ Hiển thị tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất
go
create view lab7bai2c
as
select TENPHG,HONV,TENNV from NHANVIEN inner join PHONGBAN
on PHONGBAN.MAPHG = NHANVIEN.PHG
where TRPHG=MANV and MAPHG in (select top 1 PHG from NHANVIEN
group by PHG
order by count(*) desc)

select * from lab7bai2c
