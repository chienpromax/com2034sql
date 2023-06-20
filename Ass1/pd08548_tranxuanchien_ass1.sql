CREATE DATABASE QLNHATRO

USE	QLNHATRO

CREATE TABLE LOAINHA(
	MaLoaiNha smallint  PRIMARY KEY not null, 
	TenLoaiNha nvarchar(50) NOT NULL
)

CREATE TABLE NGUOIDUNG(
	MaND smallint  PRIMARY KEY NOT NULL,
	TenND nvarchar(50) NULL,
	GioiTinh nvarchar(5) NULL,
	DienThoai varchar(15)  NULL,
	DiaChi nvarchar(50) NOT NULL,
	Quan nvarchar(50) null,
	Email nvarchar(50) null
)

CREATE TABLE NHATRO(
	MaNT smallint  PRIMARY KEY NOT NULL,
	MaLoaiNha smallint  NOT NULL,
	MaND smallint NOT NULL,
	DienTich float check(DienTich > 10) NOT NULL,
	GiaPhong int check(GiaPhong > 0) NOT NULL,
	DiaChi nvarchar(50) NOT NULL,
	Quan nvarchar(20) null,
	MoTa nvarchar(20)  NULL,
	NgayDang date NOT NULL,
	foreign key(MaLoaiNha) references LOAINHA(MaLoaiNha),
	foreign key(MaND)  references NGUOIDUNG(MaND)
)

CREATE TABLE DANHGIA(
	MaND smallint  not null,
	MaNT smallint  not null,
	Like_Dislike bit  NULL,
	NoiDung nvarchar(100)  NULL,
	PRIMARY KEY(MaND,MaNT),
	foreign key(MAND) references NGUOIDUNG(MaND),
	foreign key(MANT) references NHATRO(MaNT)
)

INSERT INTO LOAINHA(MaLoaiNha,TenLoaiNha) VALUES
(1,N'Nhà trọ chung chủ'),
(2,N'thuê nhà'),
(3,N'Chung cư'),
(4,N'Ký túc xá')

INSERT INTO NGUOIDUNG(MaND,TenND,GioiTinh,DienThoai,DiaChi,Quan,Email) VALUES
(1,N'trần xuân chiến','nam','0359690062',N'Nguyễn Thị Thập, Phường 12',N'Liên Triểu','chien@gmail.com'),
(2,N'bùi văn Dũng','nam','0359690063',N'370 Lê Văn Lương, Phường Tân Hưng',N'Quận 7','dung@gmail.com'),
(3,N'trần xuân Đại','nam','0359690064',N'113 Cộng Hoà, Phường 12',N'Tân Bình','dai@gmail.com'),
(4,N'lê thị Hương',N'nữ','0359690065',N'150 Trường Chinh, Phường 12',N'Tân Bình','huong@gmail.com'),
(5,N'nguyễn ngọc Tiến','nam','0359690066',N'233 Đinh Bộ Lĩnh, Phường 26',N'Bình Thạnh','tien@gmail.com'),
(6,N'lê tuấn kiệt Kiệt','nam','0359690067',N'379 Huỳnh Tấn Phát, Phường Tân Thuận Đông',N'Quận 7','kiet@gmail.com'),
(7,N'đặng thị Thu',N'nữ','0359690068',N'29 Nguyễn Trung Ngạn, Phường Bến Nghé',N'Quận 1','thu@gmail.com'),
(8,N'lê văn Kiên','nam','0359690069',N'496 Nguyễn Đình Chiểu, Phường 4',N'Quận 3','kien@gmail.com'),
(9,N'kiều thị Oanh',N'nữ','0359690070',N'124 Nam Kỳ Khởi Nghĩa, Phường Bến Thành',N'Quận 1','oanh@gmail.com'),
(10,N'nguyễn ngọc Hiền',N'nữ','0359690071',N'01 Lương Định Của, Phường An phú',N'Quận 2','hien@gmail.com')

INSERT INTO NHATRO(MaNT,MaLoaiNha,MaND,DienTich,GiaPhong,DiaChi,Quan,MoTa,NgayDang) VALUES
(1,2,3,  25.5,1000000,N'Thống Nhất, Phường 16',N'Gò Vấp',N'Cho thuê','02-12-2021'),
(9,3,7,  30,5000000,N'4 Trần Khắc Chân, Phường Tân Định',N'Quận 1',N'Mặt bằng đẹp','10-02-2021'),
(10,1,4, 40,2000000,N'27B Hoa Sứ, Phường 7',N'Phú Nhuận',N'Ngõ rộng','05-01-2021'),
(8,1,1,  100,3500000,N'Lê Tự Tài, Phường 4',N'Phú Nhuận',N'Cho thuê nguyên căn','08-25-2021'),
(2,2,10, 50,1700000,N'793 Trần Xuân Soạn, Phường Tân Hưng',N'Quận 7',N'Cho thuê dài hạn','11-23-2021'),
(5,3,8,  60,6000000,N'215 Nguyễn Văn Hưởng, Phường Thảo Điền',N'Quận 2',N'Lối đi thông thoáng','03-01-2021'),
(4,4,9,  35,4300000,N'930 Nguyễn Thị Định, Phường Thạnh Mỹ Lợi',N'Quận 2',N'Cho thuê','10-18-2021'),
(3,1,2,  45,4700000,N'31 Bình Phú, Phường 10',N'Quận 6',N'Cho thuê dài hạn','09-14-2021'),
(7,3,6,  70,7200000,N'21 Đỗ Thúc Tịnh, Phường 12',N'Gò Vấp',N'Giá cả phải chăng','05-29-2021'),
(6,2,5, 65,2500000,N'Bùi Đình Túy, Phường 24',N'Bình Thạnh',N'Cho thuê','11-26-2021')


INSERT INTO DANHGIA(MaND,MaNT,Like_Dislike,NoiDung) VALUES
(1,1, 1,N'Nhà trọ tốt'),
(2,2, 0,N'Giá ổn'),
(3,3,1,N'Nhà đẹp'),
(4,4, 1,N'Cổng cao'),
(5,3, 0,N'Xuống cấp'),
(6,4, 0,N'Giá cao'),
(7,2, 0,N'Đường xấu'),
(8,1, 1,N'Nhà đẹp'),
(9,2, 0,N'Mạng kém'),
(10,3,1,N'Ngõ rộng')


select * from LOAINHA
select * from NHATRO
select * from NGUOIDUNG
select * from DANHGIA