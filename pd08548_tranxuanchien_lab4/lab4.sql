--Bài 1: (3 điểm)
--➢ Viết chương trình xem xét có tăng lương cho nhân viên hay không. Hiển thị cột thứ 1 là 
--TenNV, cột thứ 2 nhận giá trị
--o “TangLuong” nếu lương hiện tại của nhân viên nhở hơn trung bình lương trong 
--phòng mà nhân viên đó đang làm việc. 
--o “KhongTangLuong “ nếu lương hiện tại của nhân viên lớn hơn trung bình lương 
--trong phòng mà nhân viên đó đang làm việc.
declare @TBluong int
set @TBluong = (select AVG(LUONG) from NHANVIEN) 
select HONV+' '+TENLOT+' '+TENNV,LUONG,
'luong moi' = case 
when LUONG<@TBluong then 'khong tang luong'
when LUONG>@TBluong then 'tang luong'
end
from NHANVIEN

--➢ Viết chương trình phân loại nhân viên dựa vào mức lương.
--o Nếu lương nhân viên nhỏ hơn trung bình lương mà nhân viên đó đang làm việc thì 
--xếp loại “nhanvien”, ngược lại xếp loại “truongphong”
declare @TBluong1 int
set @TBluong1 = (select AVG(LUONG) from NHANVIEN) 
select HONV+' '+TENLOT+' '+TENNV,LUONG,
iif(luong<@tbluong1,'nhan vien','truong phong')
as 'nv' from NHANVIEN

--➢ .Viết chương trình hiển thị TenNV như hình bên dưới, tùy vào cột phái của nhân viên
select HONV+' '+TENLOT+' '+TENNV,PHAI,
case PHAI
when 'nam' then 'mr.'+TENNV
when N'nữ' then 'ms.'+TENNV
else 'khong biet'
end
from NHANVIEN
select * from NHANVIEN

--➢ Viết chương trình tính thuế mà nhân viên phải đóng theo công thức:
--o 0<luong<25000 thì đóng 10% tiền lương
--o 25000<luong<30000 thì đóng 12% tiền lương
--o 30000<luong<40000 thì đóng 15% tiền lương
--o 40000<luong<50000 thì đóng 20% tiền lương
--o Luong>50000 đóng 25% tiền lương
select HONV+' '+TENLOT+' '+TENNV,LUONG,
'thue thu nhap' = case 
when LUONG>0 and LUONG<25000 then LUONG*0.1
when LUONG>25000 and LUONG<30000 then LUONG*0.12
when LUONG>30000 and LUONG<40000 then LUONG*0.15
when LUONG>40000 and LUONG<50000 then LUONG*0.2
else luong*0.25
end
from NHANVIEN

--Bài 2: (2 điểm)
--Sử dụng cơ sở dữ liệu QLDA. Thực hiện các câu truy vấn sau, sử dụng vòng 
--lặp
--➢ Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn.
declare @i int = 2,@dem int
set @dem = (select COUNT(MANV) from NHANVIEN)
while (@i<@dem)
begin
select HONV+' '+TENLOT+' '+TENNV,MANV from NHANVIEN
where cast(MANV as int) =@i;
set @i=@i+2;
end

--➢ Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn nhưng 
--không tính nhân viên có MaNV là 4.
declare @ix int = 2,@demx int;
	set @demx = (select COUNT(MANV) from NHANVIEN)
while (@ix<@demx)
begin
	if @ix = 4
	begin
		set @ix= @ix +2
		continue;
	end
	select HONV+' '+TENLOT+' '+TENNV,MANV from NHANVIEN
	where cast(MANV as int) =@ix;
	set @ix=@ix+2;
end
--Bài 3: (3 điểm)
--Quản trị cơ sở dữ liệu với SQL Server 
--4
--➢ Thực hiện chèn thêm một dòng dữ liệu vào bảng PhongBan theo 2 bước 
--o Nhận thông báo “ thêm dư lieu thành cong” từ khối Try
--o Chèn sai kiểu dữ liệu cột MaPHG để nhận thông báo lỗi “Them dư lieu that bai” 
--từ khối Catch
begin try
insert into PHONGBAN(MAPHG,TENPHG,TRPHG,NG_NHANCHUC)
values (111,'ke hoach',007,'2023-12-30')
print 'thanh cong'
end try
begin catch
print N'!!! lỗi rồi '+convert(varchar,error_number(),1)
+'->' + error_message()
end catch
--➢ Viết chương trình khai báo biến @chia, thực hiện phép chia @chia cho số 0 và dùng 
--RAISERROR để thông báo lỗi.
begin try
declare @a int = 4,@b int =0,@tong int
set @tong = @a/@b
end try
begin catch
declare @ErMessage nvarchar(2048),
		@ErSeverity int,
		@ErState int
select @ErMessage =error_message(),
		@ErSeverity= error_severity(),
		@ErState =error_state()
raiserror (@ErMessage,@ErSeverity,@ErState)
end catch



