-- 1. Tạo cơ sở dữ liệu QuanLyThietBi gồm các bảng sau:
Create database QuanLyThietBi
use QuanLyThietBi
    -- NhanVien(MaNV, TenNV, NgaySinh, GioiTinh, MaPB)
Create table NhanVien
(
MaNV varchar(10) not null,
TenNV nvarchar(50) not null,
NgaySinh date,
GioiTinh nvarchar(3),
MaPB varchar(10),
Primary key (MaNV)
)
    -- SuDungThietBi(MaThietBi, MaNV, SoLuong, NgayBatDau, NgayKetThuc)
Create table SuDungThietBi
(
MaThietBi varchar(10) not null,
MaNV varchar(10) not null,
SoLuong numeric,
NgayBatDau date,
NgayKetThuc date,
Primary key (MaThietBi),
Foreign key (MaNV) references NhanVien
)
-- 2. Thêm mới mỗi bảng 2-3 dòng dữ liệu
insert into NhanVien values ('NV01', N'Trần Nguyễn Khánh Cường', '1999-05-08', 'Nam', 'PB01')
insert into NhanVien values ('NV02', N'Lê Hồ Đạt', '1999-12-14', 'Nam', 'PB02')
insert into NhanVien values ('NV03', N'Nguyễn Văn A', '1998-06-12', 'Nam', 'PB03')

insert into SuDungThietBi values ('TB01', 'NV02', 2, '2019-12-12', '2019-12-14')
insert into SuDungThietBi values ('TB02', 'NV03', 4, '2019-11-02', '2019-11-10')
insert into SuDungThietBi values ('TB03', 'NV01', 5, '2019-11-15', '2019-11-19')

-- 3. Viết hàm trả về tên nếu biết mã sinh nhân viên
create function fMaNV(@MaNV varchar(10))
returns nvarchar(50)
as
begin
	Declare @TenNV nvarchar(50)
	Set @TenNV = (Select TenNV from NhanVien where MaNV = @MaNV)
	return @TenNV
end
-- Test
select dbo.fMaNV('NV02')
-- 4. Viết hàm trả về số lượng thiết bị mà nhân viên đang sử dụng nếu biết tên nhân viên và mã thiết bị
Create function fTenMa(@TenNV nvarchar(50), @MaThietBi varchar(10))
returns numeric
as
begin
	Declare @SL numeric
	Set @SL = (Select SoLuong from SuDungThietBi join NhanVien on SuDungThietBi.MaNV = NhanVien.MaNV 
			   where TenNV = @TenNV and MaThietBi = @MaThietBi)
	return @SL
end
Select dbo.fTenMa(N'Trần Nguyễn Khánh Cường', 'TB03')
-- 5. Viết thủ tục thêm mới dữ liệu vào bảng SuDungThietBi như mô tả dưới đây:

--Input: MaThietBi, MaNV, SoLuong, NgayBatDau

--Output: 0 nếu bị lỗi, 1 nếu thành công
Create proc pThemMoi @MaThietBi varchar(10),
					 @MaNV varchar(10),
					 @SoLuong int,
					 @NgayBatDau date,
					 @KT char(1) out
as
begin
--Các bước thực hiện:
--B1. Kiểm tra SoLuong có hợp lệ không (hợp lệ: SoLuong > 0). Nếu không hợp lệ, kết thúc thủ tục và trả về giá trị 0
	if @SoLuong <= 0
	begin
		Set @KT = 0
		return
	end
--B2: Kiểm tra MaNV đã tồn tại trong bảng NhanVien chưa. Nếu chưa tồn tại, kết thúc thủ tục và trả về giá trị 0.
	Declare @dem int
	Set @dem = (select Count(*) from NhanVien where MaNV = @MaNV)
	if @dem is null
	begin
		Set @KT = 0
		return
	end
--Bước 3. Thêm mới dữ liệu với các giá trị input (NgayKetThuc có giá trị NULL)
	insert into  SuDungThietBi(MaThietBi, MaNV, SoLuong, NgayBatDau, NgayKetThuc) values (@MaThietBi, @MaNV, @SoLuong, @NgayBatDau, '')
--Bước 4. Nếu thêm mới thành công thì trả về 1, ngược lại trả về 0.
	if @@ROWCOUNT > 0
		Set @KT = 1
	else
		Set @KT = 0
end
Declare @a char(1)
exec pThemMoi 'TB05', 'NV01', '0', '2019-12-14', @a out
Print @a
Select * from NhanVien
-- 6. Khi thêm mới dữ liệu vào bảng NhanVien hãy đảm bảo rằng tuổi của nhân viên lớn hơn hoặc bằng 18.
Create trigger tcheckTuoi
on NhanVien for insert
as
begin
	Declare @NgaySinh date, @Tuoi int
	Set @NgaySinh = (Select NgaySinh from inserted)
	Set @Tuoi = DATEDIFF(year,@NgaySinh,Getdate())
	if @Tuoi < 18
	begin
		Print N'Bạn chưa đủ tuổi'
		rollback
	end
end
insert into NhanVien values ('NV04', N'Nguyễn Thị B', '2001-05-05', N'Nữ', 'PB04')