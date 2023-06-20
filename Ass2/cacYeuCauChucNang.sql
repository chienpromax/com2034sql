--1. Thêm thông tin vào các bảng
--- Tạo ba Stored Procedure (SP) với các tham số đầu vào phù hợp.
--o SP thứ nhất thực hiện chèn dữ liệu vào bảng NGUOIDUNG
create proc YC_1a(
	@mand smallint,@tennd nvarchar(50),@gioitinh nvarchar(5),@dienthoai varchar(15),
	@diachi nvarchar(50),@quan nvarchar(50),@email nvarchar(50))
as
begin
	if @mand is null or @tennd is null or @gioitinh is null or @dienthoai is null or
	@diachi is null or @quan is null or @email is null
begin
	print'ban nhap sai'
return;
end
else
	insert into NGUOIDUNG values(@mand,@tennd,@gioitinh,@dienthoai,@diachi,@quan,@email)
end
	exec YC_1a 0,N'vu quan dung','nam','036225235',N'123 Nguyễn Thị thập',N'liên triểu'
	exec YC_1a null,N'vu quan dung','nam','036225235',N'123 Nguyễn Thị thập',N'liên triểu','dung@fpt.edu.vn'

drop proc YC_1c
delete NGUOIDUNG where MaND=0
delete DANHGIA where MaND=0

--o SP thứ hai thực hiện chèn dữ liệu vào bảng NHATRO
create proc YC_1b(
	@mant smallint,@maln smallint,@mand smallint,@dientich float,@giaphong int,
	@diachi nvarchar(50),@quan nvarchar(20),@mota nvarchar(20),@ngaydang date)
as
begin
	if @mant is null or @maln is null or @mand is null or @dientich is null or
	@giaphong is null or @diachi is null or @quan is null or @mota is null or @ngaydang is null
	print'ban nhap sai'
else
	insert into NHATRO values(@mant,@maln,@mand,@dientich,@giaphong,@diachi,@quan,@mota,@ngaydang)
end
	exec YC_1b 0,1,4,50.6,5000000,N'123 Nguyễn Thị thập',N'thanh khe',N'Cho Thuê','11-22-2020'
	exec YC_1b null,1,4,50.6,5000000,N'123 Nguyễn Thị thập',N'thanh khe',N'Cho Thuê','11-22-2020'

delete NHATRO where MaNT=0
--o SP thứ ba thực hiện chèn dữ liệu vào bảng DANHGIA
create proc YC_1c(
	@mand smallint,@mant smallint,
	@like_dis bit,@noidung nvarchar(100))
as
begin
	if @mand is null or @mant is null or @like_dis is null or @noidung is null 
	print'ban nhap sai'
else
	insert into DANHGIA values(@mand,@mant,@like_dis,@noidung)
end
	exec YC_1c 0,7,'1',N'tốt'
	exec YC_1c null,7,'1',N'tốt'


--2. Truy vấn thông tin
--a. Viết một SP với các tham số đầu vào phù hợp. SP thực hiện tìm kiếm thông tin các 
--phòng trọ thỏa mãn điều kiện tìm kiếm theo: Quận, phạm vi diện tích, phạm vi ngày đăng
--tin, khoảng giá tiền, loại hình nhà trọ.

create proc YC_2a
	@Quan nvarchar(100)='%',-- % Đại diên Cho 1 chuỗi Nòa Đó 
	@DienTichMax float=null,
	@DienTichMin float = null,
	@GiaPhongMax float = null,
	@GiaPhongMin float =null,
	@NgayDangMax date=null,
	@NgayDangMin date = null,
	@LoaiNha nvarchar(50)='%'
	as
	begin
	if(@DienTichMax is null) select @DienTichMax=max(DIENTICH) from NHATRO;
	if(@DienTichMin is null) select @DienTichMin=min(DIENTICH) from NHATRO;
	if(@GiaPhongMax is null)select @GiaPhongMax=max(GIAPHONG) from NHATRO;
	if(@GiaPhongMin is null)select @GiaPhongMin=min(GIAPHONG) from NHATRO;
	if(@NgayDangMax is null ) select @NgayDangMax=max(NGAYDANG) from NHATRO;
	if(@NgayDangMin is null ) select @NgayDangMin=min(NGAYDANG) from NHATRO;

select 
	-- hiện thi Dia chi nha tro
(NGUOIDUNG.DiaChi+' '+nguoidung.Quan) as 'cho thue tai',
	-- hiện thi Diên tích
REPLACE(DienTich,'.',',')+' '+'m2' as'dien tich' ,
  	-- HT giá phòng theoe đinh dang chuẩn VN
FORMAT(GiaPhong,'#,###')+' '+N'VNĐ' as 'gia thanh',

MoTa,
	--hT ngày theo Dang chuẩn 
CONVERt(varchar,NgayDang,105) as 'ngay dang',
	-- Tên Liên hê nếu nam Thi +A nữ +C
CASE NGUOIDUNG.GioiTinh
	when 'nam' then 'A. ' + NGUOIDUNG.TenND
	when N'nữ' then 'C. ' + NGUOIDUNG.TenND
	END as N'Người đăng tin',

DienThoai,
	  -- hiện thi Dia chi nha tro
NGUOIDUNG.DiaChi as 'dia chi nguoi lien he'
from NHATRO inner join NGUOIDUNG on NGUOIDUNG.MaND = NHATRO.MaND
inner join LOAINHA  on NHATRO.MaNT=LOAINHA.MaLoaiNha
where NHATRO.QUAN like @Quan
         and DIENTICH >=@DienTichMin and DIENTICH <=@DienTichMax
		 and GIAPHONG >=@GiaPhongMin and GIAPHONG <=@GiaPhongMax
		 and NGAYDANG >=@NgayDangMin and NGAYDANG <=@NgayDangMax
		 and LOAINHA.TenLoaiNha like @LoaiNha;
end
	exec YC_2a '%',100,50,27000000,null,null,null,'%'
drop proc YC_2a
--b. Viết một hàm có các tham số đầu vào tương ứng với tất cả các cột của bảng 
--NGUOIDUNG. Hàm này trả về mã người dùng (giá trị của cột khóa chính của bảng 
--NGUOIDUNG) thỏa mãn các giá trị được truyền vào tham số
drop function YC_2b
go
create function  YC_2b 
	(@tennd nvarchar(50),@gioitinh nvarchar(5),
	@dienthoai varchar(15),@diachi nvarchar(50),@quan nvarchar(50),@email nvarchar(50))
returns table 
return(select * from NGUOIDUNG
	where TenND like @tennd
	and DiaChi like @diachi)

select * from dbo.YC_2b (N'trần xuân chiến','nam','036225235',N'Nguyễn Thị thập, phường 12',
N'liên triểu','dung@fpt.edu.vn')
--c. Viết một hàm có tham số đầu vào là mã nhà trọ (cột khóa chính của bảng 
--NHATRO). Hàm này trả về tổng số LIKE và DISLIKE của nhà trọ này.
drop function YC_2clike
drop function YC_2cdislike
go
create function YC_2clike (@mant smallint)
returns int 
as
begin
	return(select count(Like_Dislike) from DANHGIA where Like_Dislike=1
	and MaNT=@mant)
end
--tong dislike
go
create function YC_2cdislike (@mant smallint)
returns int 
as
begin
	return(select count(Like_Dislike) from DANHGIA where Like_Dislike=0
	and MaNT=@mant)
end

select
	dbo.YC_2clike(MaNT) as N'Tổng Like',
	dbo.YC_2cdislike(MaNT) as N'Tổng disLike'
	from DANHGIA 
	--d. Tạo một View lưu thông tin của TOP 10 nhà trọ có số người dùng LIKE nhiều nhất gồm 
--các thông tin sau:
--- Diện tích
--- Giá
--- Mô tả
--- Ngày đăng tin
--- Tên người liên hệ
--- Địa chỉ
--- Điện thoại
--- Email
drop view YC_2d
go
create view YC_2d
as
	select top 5
	dbo.YC_2clike(MaNT) as'tong like',MaNT
	from NHATRO inner join NGUOIDUNG on NGUOIDUNG.MaND=NHATRO.MaND 
	order by 'tong like' desc

select * from YC_2d


--e. Viết một Stored Procedure nhận tham số đầu vào là mã nhà trọ (cột khóa chính của
--bảng NHATRO). SP này trả về tập kết quả gồm các thông tin sau:
--- Mã nhà trọ
--- Tên người đánh giá
--- Trạng thái LIKE hay DISLIKE
--- Nội dung đánh giá
drop proc YC_2e
go
create proc YC_2e (@mant smallint)
as
	if not exists(select * from NHATRO where MaNT=@mant)
	print 'khong ton tai'
else 
	select NHATRO.MaNT,TenND,
	case DANHGIA.Like_Dislike
		when 1 then 'Like'
		when 0 then 'Dislike'
	end as N'Đánh giá',
	NoiDung 
	from NHATRO inner join DANHGIA on DANHGIA.MaNT= NHATRO.MaNT
	inner join NGUOIDUNG on NGUOIDUNG.MaND=DANHGIA.MaND 
where NHATRO.MaNT=@mant

exec YC_2e 1

--3. Xóa thông tin
--1. Viết một SP nhận một tham số đầu vào kiểu int là số lượng DISLIKE. SP này thực hiện
--thao tác xóa thông tin của các nhà trọ và thông tin đánh giá của chúng, nếu tổng số lượng
--DISLIKE tương ứng với nhà trọ này lớn hơn giá trị tham số được truyền vào.
--Yêu cầu: Sử dụng giao dịch trong thân SP, để đảm bảo tính toàn vẹn dữ liệu khi một thao tác 
--xóa thực hiện không thành công.
create proc YC_3a 
@Dislike int
as
begin
		declare @Thongke table (MaNT char(10));
		insert into @Thongke 
		select MaNT
		from DANHGIA
		group by MaNT
		having sum(iif(Like_Dislike=0,1,0))>@Dislike
			 begin transaction;--bắt dâu giao dich cho đền khi găp 1 commit (Hoàn Tất GD) 2 rollback(Lỗi và hủy bỏ giao Dich  )
			  begin try
				delete from DANHGIA where MaNT in (Select MaNT from @Thongke); -- xoa nha tro khoi danh gia 
				delete from NHATRO where MANT in (Select MANT from @Thongke); -- xoa nha tro khoi bang nha tro
				print N'đã Xóa Nhà Trò Theo Luợt DisLike !! '
			--	commit tran -- goi commit tran để hoàn tất -- vì đã comet commit nền dữ liễu xe chuă dc xóa 
			rollback tran -- nhay ra try cart bawt loi
			end try
			begin catch 
			rollback tran -- neué có lỗi thì rollback để thức Hiẹn Phục hồi trang thái csql trước thư hiẹn các HD  
			declare @ErrorMessage varchar(200);
			select @ErrorMessage = ERROR_MESSAGE(); --để lấy Thông Báo Lỗi 
			Raiserror (@ErrorMessage,16,1);
			end catch;
end;
exec YC_3a 0
--2. Viết một SP nhận hai tham số đầu vào là khoảng thời gian đăng tin. SP này thực hiện
--thao tác xóa thông tin những nhà trọ được đăng trong khoảng thời gian được truyền vào 
--qua các tham số.
--Lưu ý: SP cũng phải thực hiện xóa thông tin đánh giá của các nhà trọ này.
--Yêu cầu: Sử dụng giao dịch trong thân SP, để đảm bảo tính toàn vẹn dữ liệu khi một thao tác 
--xóa thực hiện không thành công
create proc YC_3b
      @NgayDangMin date,
	  @NgayDangMax date
	  as
begin
   begin tran 
   begin try 
     declare @MaList table (MaNT char(10));
	 insert into @MaList
     select MANT from NHATRO where NGAYDANG >= @NgayDangMin and NGAYDANG <= @NgayDangMax

	 delete from DANHGIA where MaNT in (Select *from @MaList);
	 delete from NHATRO where MaNT in (Select *from @MaList);
	 print N' Thông Tin Nhà Trò Đã Đc Xóa ';
	-- commit tran -- để nó ko xoa
	   rollback tran 
	 end try 

	 begin catch 
	   rollback tran 
	   declare @ErrorMessage varchar(200)
    select @ErrorMessage = ERROR_MESSAGE(); --để lấy Thông Báo Lỗi 
     Raiserror (@ErrorMessage,16,1);
	 end catch ;

end;
exec YC_3b '2021-02-18' , '2021-05-22';
select *from NHATRO

drop proc YC_3b
