--➢ Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc một tuần của tất cả các nhân viên 
--tham dự đề án đó. 
--o Xuất định dạng “tổng số giờ làm việc” kiểu decimal với 2 số thập phân.
select TENDEAN,CAST(SUM(THOIGIAN)as decimal(6,2))as 'tong gio' from DEAN
inner join CONGVIEC on CONGVIEC.MADA=DEAN.MADA
inner join PHANCONG on PHANCONG.MADA=CONGVIEC.MADA
group by TENDEAN

select TENDEAN,CONVERT(decimal(6,2),SUM(THOIGIAN))as 'tong gio' from DEAN
inner join CONGVIEC on CONGVIEC.MADA=DEAN.MADA
inner join PHANCONG on PHANCONG.MADA=CONGVIEC.MADA
group by TENDEAN

--o Xuất định dạng “tổng số giờ làm việc” kiểu varchar
select TENDEAN,CAST(SUM(THOIGIAN)as varchar(10))as 'tong gio' from DEAN
inner join CONGVIEC on CONGVIEC.MADA=DEAN.MADA
inner join PHANCONG on PHANCONG.MADA=CONGVIEC.MADA
group by TENDEAN


select TENDEAN,CONVERT(varchar(10),SUM(THOIGIAN))as 'tong gio' from DEAN
inner join CONGVIEC on CONGVIEC.MADA=DEAN.MADA
inner join PHANCONG on PHANCONG.MADA=CONGVIEC.MADA
group by TENDEAN

--➢ Với mỗi phòng ban, liệt kê tên phòng ban và lương trung bình của những nhân viên làm 
--việc cho phòng ban đó.
--o Xuất định dạng “luong trung bình” kiểu decimal với 2 số thập phân, sử dụng dấu 
--phẩy để phân biệt phần nguyên và phần thập phân.
select TENPHG,CAST(AVG(LUONG) as decimal(10,2)) as'luong tb' from PHONGBAN
inner join NHANVIEN on NHANVIEN.PHG=PHONGBAN.MAPHG
group by TENPHG

select TENPHG,CONVERT(decimal(10,2),AVG(LUONG)) as'luong tb' from PHONGBAN
inner join NHANVIEN on NHANVIEN.PHG=PHONGBAN.MAPHG
group by TENPHG

--o Xuất định dạng “luong trung bình” kiểu varchar. Sử dụng dấu phẩy tách cứ mỗi 3 
--chữ số trong chuỗi ra, gợi ý dùng thêm các hàm Left, Replace
select TENPHG,CAST(AVG(LUONG) as varchar(10)) as'luong tb',
(left(CAST(AVG(LUONG) as varchar(10)),3) + 
REPLACE(CAST(AVG(LUONG) as varchar(10)),LEFT(CAST(AVG(LUONG) as varchar(10)),3),',')) as 'ket qua'
from PHONGBAN
inner join NHANVIEN on NHANVIEN.PHG=PHONGBAN.MAPHG
group by TENPHG


select TENPHG,CONVERT(varchar(10),AVG(LUONG))as 'luong tb',
left(CONVERT(varchar(10),AVG(LUONG)),3)+
REPLACE(CONVERT(varchar(10),AVG(LUONG)),LEFT(CONVERT(varchar(10),AVG(LUONG)),3),',')
from PHONGBAN
inner join NHANVIEN on NHANVIEN.PHG=PHONGBAN.MAPHG
group by TENPHG

--Bài 2: (2 điểm)
--Sử dụng các hàm toán học
--➢ Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc một tuần của tất cả các nhân viên 
--tham dự đề án đó.
--o Xuất định dạng “tổng số giờ làm việc” với hàm CEILING
select TENDEAN,SUM(THOIGIAN)as 'tong gio',
CEILING(SUM(THOIGIAN)) as 'tong gio lam viec'
from DEAN
inner join CONGVIEC on CONGVIEC.MADA=DEAN.MADA
inner join PHANCONG on PHANCONG.MADA=CONGVIEC.MADA
group by TENDEAN

--o Xuất định dạng “tổng số giờ làm việc” với hàm FLOOR
select TENDEAN,SUM(THOIGIAN)as 'tong gio',
FLOOR(sum(THOIGIAN)) AS 'tong gio lam viec'
from DEAN
inner join CONGVIEC on CONGVIEC.MADA=DEAN.MADA
inner join PHANCONG on PHANCONG.MADA=CONGVIEC.MADA
group by TENDEAN 

--o Xuất định dạng “tổng số giờ làm việc” làm tròn tới 2 chữ số thập phân
select TENDEAN,SUM(THOIGIAN)as 'tong gio',
ROUND(sum(THOIGIAN),2) AS 'tong gio lam viec'
from DEAN
inner join CONGVIEC on CONGVIEC.MADA=DEAN.MADA
inner join PHANCONG on PHANCONG.MADA=CONGVIEC.MADA
group by TENDEAN

--➢ Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương 
--trung bình (làm tròn đến 2 số thập phân) của phòng "Nghiên cứu"
select HONV+' '+TENLOT+' '+TENNV as 'ho va ten',LUONG from NHANVIEN
where LUONG>=(Select ROUND(AVG(LUONG),2) from NHANVIEN
inner join PHONGBAN on PHONGBAN.MAPHG=NHANVIEN.PHG
where TENPHG like N'Nghiên cứu')

--Bài 3: (2 điểm)
--Sử dụng các hàm xử lý chuỗi
--➢ Danh sách những nhân viên (HONV, TENLOT, TENNV, DCHI) có trên 2 thân nhân, 
--thỏa các yêu cầu
--o Dữ liệu cột HONV được viết in hoa toàn bộ
select (UPPER(substring(HONV,1,1))+LOWER(right(HONV,4))) as 'họ nhân viên',TENLOT,TENNV,DCHI ,COUNT(MA_NVIEN) as'so than nhan' from NHANVIEN
inner join THANNHAN on THANNHAN.MA_NVIEN=NHANVIEN.MANV
group by HONV,TENLOT,TENNV,DCHI
having COUNT(MA_NVIEN)>=2

--o Dữ liệu cột TENLOT được viết chữ thường toàn bộ
select HONV, LOWER(TENLOT) as 'tên lót nhân viên',TENNV,DCHI ,COUNT(MA_NVIEN) as'so than nhan' from NHANVIEN
inner join THANNHAN on THANNHAN.MA_NVIEN=NHANVIEN.MANV
group by HONV,TENLOT,TENNV,DCHI
having COUNT(MA_NVIEN)>=2

--o Dữ liệu chột TENNV có ký tự thứ 2 được viết in hoa, các ký tự còn lại viết 
--thường( ví dụ: kHanh)
select HONV,TENLOT,TENNV,
LOWER(left(TENNV,1))+
--UPPER(substring(TENNV,2,1))+SUBSTRING(TENNV,3,LEN(TENNV)-2),
UPPER(substring(TENNV,2,1))+LOWER(right(TENNV,2)),
DCHI ,COUNT(MA_NVIEN) as'so than nhan' from NHANVIEN
inner join THANNHAN on THANNHAN.MA_NVIEN=NHANVIEN.MANV
group by HONV,TENLOT,TENNV,DCHI
having COUNT(MA_NVIEN)>=2

--o Dữ liệu cột DCHI chỉ hiển thị phần tên đường, không hiển thị các thông tin khác 
--như số nhà hay thành phố.
select HONV,TENLOT,TENNV,DCHI,
substring(DCHI,CHARINDEX(' ',DCHI),CHARINDEX(',',DCHI)-4)as 'ten duong'
from NHANVIEN
inner join THANNHAN on THANNHAN.MA_NVIEN=NHANVIEN.MANV

--➢ Cho biết tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất, 
--hiển thị thêm một cột thay thế tên trưởng phòng bằng tên “Fpoly”
select top 1 TENPHG,TRPHG,b.TENNV,
replace(b.TENNV,b.TENNV,'Fpoly') as 'thay the',
count(a.MANV) as 'so luong'
from NHANVIEN a
inner join PHONGBAN on PHONGBAN.MAPHG= a.PHG
inner join NHANVIEN b on b.MANV= PHONGBAN.TRPHG
group by TENPHG,TRPHG,b.TENNV
order by [so luong] desc



select top 1 TENPHG,TRPHG,(a.HONV+' '+a.TENLOT+' '+a.TENNV) as 'ho va ten',
(a.HONV+' '+a.TENLOT+' '+replace(b.TENNV,b.TENNV,'Fpoly')) as 'ho va ten thay the',
count(a.MANV) as 'so luong'
from NHANVIEN a
inner join PHONGBAN on PHONGBAN.MAPHG= a.PHG
inner join NHANVIEN b on b.MANV= PHONGBAN.TRPHG
group by TENPHG,TRPHG,
b.TENNV,a.HONV,a.TENLOT,a.TENNV
order by [so luong] desc

--Bài 4: (2 điểm)
--Sử dụng các hàm ngày tháng năm
--➢ Cho biết các nhân viên có năm sinh trong khoảng 1960 đến 1965.
select * from NHANVIEN
where year(NGSINH) >=1960 and year(NGSINH) <=1965

--➢ Cho biết tuổi của các nhân viên tính đến thời điểm hiện tại.
select *,year(getdate())-YEAR(NGSINH) as 'tuoi' from NHANVIEN
--➢ Dựa vào dữ liệu NGSINH, cho biết nhân viên sinh vào thứ mấy.
select *,year(getdate())-YEAR(NGSINH) as 'tuoi',
datename(weekday,NGSINH) as 'thu'
from NHANVIEN

--➢ Cho biết số lượng nhân viên, tên trưởng phòng, ngày nhận chức trưởng phòng và ngày 
--nhận chức trưởng phòng hiển thi theo định dạng dd-mm-yy (ví dụ 25-04-2019)select TENPHG,TRPHG,b.TENNV,count(a.MANV) as 'so luong nhan vien',
CONVERt(varchar,NG_NHANCHUC,105) as 'ngay nhan chuc'
from NHANVIEN a
inner join PHONGBAN on PHONGBAN.MAPHG= a.PHG
inner join NHANVIEN b on b.MANV= PHONGBAN.TRPHG
group by TENPHG, TRPHG,NG_NHANCHUC,b.TENNV
order by [so luong nhan vien] desc
