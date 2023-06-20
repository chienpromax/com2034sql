--1. Tìm các nhân viên làm vi?c ? phòng s? 4
select * from NHANVIEN
where PHG = 4

--2. Tìm các nhân viên có m?c l??ng trên 30000
select * from NHANVIEN
where LUONG >30000

--3. Tìm các nhân viên có m?c l??ng trên 25,000 ? phòng 4 ho?c các nhân
--viên có m?c l??ng trên 30,000 ? phòng 5
select * from NHANVIEN
where LUONG >25000 and PHG = 4 or LUONG >30000 and PHG = 5

--4. Cho bi?t h? tên ??y ?? c?a các nhân viên ? TP HCM
select (HONV+' '+TENLOT+' '+TENNV) as N'Họ Tên',DCHI from NHANVIEN
where DCHI like N'%TP HCM'

--5. Cho bi?t h? tên ??y ?? c?a các nhân viên có h? b?t ??u b?ng ký t?
--'N'
select (HONV+' '+TENLOT+' '+TENNV) as N'Họ Tên',DCHI from NHANVIEN
where HONV like N'N%'
--6. Cho bi?t ngày sinh và ??a ch? c?a nhân viên Dinh Ba Tien
select (HONV+' '+TENLOT+' '+TENNV) as N'H? Tên',NGSINH,DCHI from NHANVIEN
where HONV like N'Đinh' and TENLOT like N'Bá'and TENNV like N'Tiên'