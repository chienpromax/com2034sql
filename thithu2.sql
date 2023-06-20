--Câu 1: Hiển thị tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất
SELECT TOP 1 COUNT(NV2.MANV), TENPHG, NV2.HONV + ' ' + NV2.TENLOT + ' ' + NV2.TENNV AS N'Tên trưởng PHG' FROM PHONGBAN PB
INNER JOIN NHANVIEN NV1 ON PB.MAPHG = NV1.PHG
INNER JOIN NHANVIEN NV2 ON PB.TRPHG = NV2.MANV
GROUP BY TENPHG, NV2.HONV + ' ' + NV2.TENLOT + ' ' + NV2.TENNV
ORDER BY COUNT(NV2.MANV) DESC
--Câu 2: Tìm các nhân viên có mức lương trên 25000 ở phòng 4 hoặc các nhân viên có mức lương trên 30000 ở phòng 5

select * from NHANVIEN 
where LUONG > 25000 and PHG=4 or LUONG > 30000 and PHG=5


--Câu 3: Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc của tất cả các nhân viên tham dự đề án đó.
-- (Xuất định dạng “tổng số giờ làm việc” kiểu decimal với 2 số thập phân.)
select TENDEAN,sum(cast(THOIGIAN as decimal(6,2))) as 'tong thoi gian' from DEAN inner join PHANCONG
on DEAN.MADA = PHANCONG.MADA
group by TENDEAN
--Câu 4: Cho biết tuổi của các nhân viên tính đến thời điểm hiện tại.
select *,year(getdate())-year(NGSINH) from NHANVIEN
--Câu 5: Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc của tất cả các nhân viên
--tham dự đề án đó.
--	Xuất định dạng “tổng số giờ làm việc” với hàm CEILING
select TENDEAN,CEILING(sum(cast(THOIGIAN as decimal(6,2)))) as 'tong thoi gian' from DEAN inner join PHANCONG
on DEAN.MADA = PHANCONG.MADA
group by TENDEAN
--	Xuất định dạng “tổng số giờ làm việc” với hàm FLOOR
select TENDEAN,FLOOR(sum(cast(THOIGIAN as decimal(6,2)))) as 'tong thoi gian' from DEAN inner join PHANCONG
on DEAN.MADA = PHANCONG.MADA
group by TENDEAN

--Câu 6: Tạo View lưu thông tin của TOP 3 nhân viên có lương cao nhất
drop view cau6
create view cau6
as
select top 3 * from NHANVIEN
order by LUONG desc

select * from cau6
--Câu 7: Tạo View hiển thị thông tin TenNV, Lương, Tuổi.
drop view cau7
create view cau7
as
select TENNV,LUONG,year(getdate())-year(NGSINH) as 'tuoi' from NHANVIEN

select * from cau7
--Câu 8: Viết Function có tham số đầu vào là @manv. Hàm này trả về tên 
--phòng ban và địa chỉ phòng ban của nhân viên đó
drop proc cau8
create function cau8 (@manv int)
returns table
as
return(select TENPHG ,DIADIEM from PHONGBAN inner join DIADIEM_PHG
on PHONGBAN.MAPHG=DIADIEM_PHG.MAPHG inner join NHANVIEN
on NHANVIEN.PHG = DIADIEM_PHG.MAPHG where MANV=@manv)

select * from dbo.cau8 (001)
--Câu 9: Viết Store Procedure nhập vào số nguyên @n. In ra tổng các số chẵn từ 1 đến @n.
go
alter proc cau9 (@n int)
as
begin
declare @i int =1,@tong int=0

	while(@i<=@n)
	begin
			if(@i=4)
		begin
			set @i += 2;
			continue;
		end
			if(@i % 2 =0 )
		begin
			set @tong+= @i
			set @i+=1
		end
		else set @i+=1
	end
	print'tong'+ cast(@tong as nvarchar)
end
go
exec cau9 10
--Câu 10: Viết Trigger khi xóa đề án ở bảng ĐỀ ÁN thì xóa luôn các dữ liệu liên quan đến đề án đó từ các bảng khác.
go
alter trigger cau10 on DEAN
instead of delete
as 
begin
	delete from PHANCONG where MADA in
	(select MADA from deleted)
	delete from CONGVIEC where MADA in
	(select MADA from deleted)
	delete from DEAN where MADA in
	(select MADA from deleted)
end

delete from DEAN where MADA = 1