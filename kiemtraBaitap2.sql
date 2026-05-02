CREATE DATABASE QuanLyBanHang_K235480106074
CREATE TABLE [KhachHang] (
    [maKhachHang] INT PRIMARY KEY,
    [tenKhachHang] NVARCHAR(100),
    [soDienThoai] VARCHAR(15)
)
CREATE TABLE [SanPham] (
    [maSanPham] INT PRIMARY KEY,
    [tenSanPham] NVARCHAR(100),
    [gia] FLOAT CHECK (gia > 0),
    [soLuongTon] INT
)
CREATE TABLE [HoaDon] (
    [maHoaDon] INT PRIMARY KEY,
    [maKhachHang] INT,
    [tongTien] FLOAT,
    FOREIGN KEY ([maKhachHang]) REFERENCES [KhachHang]([maKhachHang])
)

CREATE TABLE [ChiTietHoaDon] (
    [maHoaDon] INT,
    [maSanPham] INT,
    [soLuong] INT CHECK (soLuong > 0),
    PRIMARY KEY ([maHoaDon], [maSanPham]),
    FOREIGN KEY ([maHoaDon]) REFERENCES [HoaDon]([maHoaDon]),
    FOREIGN KEY ([maSanPham]) REFERENCES [SanPham]([maSanPham])
)
INSERT INTO KhachHang VALUES (1, N'Nam', '0123')
INSERT INTO SanPham VALUES (1, N'Bút', 10, 100)
INSERT INTO HoaDon VALUES (1, 1, 0)
INSERT INTO ChiTietHoaDon VALUES (1, 1, 2)
CREATE FUNCTION fn_TinhTongTien (@maHoaDon INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @tong FLOAT

    SELECT @tong = SUM(sp.gia * ct.soLuong)
    FROM ChiTietHoaDon ct
    JOIN SanPham sp ON ct.maSanPham = sp.maSanPham
    WHERE ct.maHoaDon = @maHoaDon

    RETURN @tong
END
SELECT dbo.fn_TinhTongTien(1)
SELECT dbo.fn_TinhTongTien(1)

SELECT GETDATE() AS NgayHienTai
SELECT LEN(N'Xin chào') AS DoDaiChuoi
SELECT ABS(-100) AS GiaTriTuyetDoi
SELECT @@VERSION AS ThongTinSQL

CREATE FUNCTION fn_SanPhamGiaCao (@gia FLOAT)
RETURNS TABLE
AS
RETURN (
    SELECT * FROM SanPham
    WHERE gia > @gia
)

SELECT * FROM fn_SanPhamGiaCao(1)

CREATE FUNCTION fn_ThongKeBanHang()
RETURNS @bang TABLE (
    tenSanPham NVARCHAR(100),
    tongSoLuong INT
)
AS
BEGIN
    INSERT INTO @bang
    SELECT sp.tenSanPham, SUM(ct.soLuong)
    FROM ChiTietHoaDon ct
    JOIN SanPham sp ON ct.maSanPham = sp.maSanPham
    GROUP BY sp.tenSanPham

    RETURN
END
SELECT * FROM fn_ThongKeBanHang()
EXEC sp_help 'SanPham'
CREATE PROCEDURE sp_ThemSanPham
    @ma INT,
    @ten NVARCHAR(100),
    @gia FLOAT,
    @soLuong INT
AS
BEGIN
    IF @gia <= 0
    BEGIN
        PRINT N'Giá không hợp lệ'
    END
    ELSE
    BEGIN
        INSERT INTO SanPham
        VALUES (@ma, @ten, @gia, @soLuong)

        PRINT N'Thêm thành công'
    END
END

EXEC sp_ThemSanPham 5, N'Balo', 100, 10

CREATE PROCEDURE sp_TinhTongTien
    @maHoaDon INT,
    @tong FLOAT OUTPUT
AS
BEGIN
    SELECT @tong = SUM(sp.gia * ct.soLuong)
    FROM ChiTietHoaDon ct
    JOIN SanPham sp ON ct.maSanPham = sp.maSanPham
    WHERE ct.maHoaDon = @maHoaDon
END
DECLARE @kq FLOAT

EXEC sp_TinhTongTien 1, @kq OUTPUT

SELECT @kq AS TongTien

CREATE PROCEDURE sp_DanhSachHoaDon
AS
BEGIN
    SELECT 
        hd.maHoaDon,
        kh.tenKhachHang,
        hd.tongTien
    FROM HoaDon hd
    JOIN KhachHang kh 
        ON hd.maKhachHang = kh.maKhachHang
END
EXEC sp_DanhSachHoaDon

CREATE TRIGGER trg_GiamSoLuongTon
ON ChiTietHoaDon
AFTER INSERT
AS
BEGIN
    UPDATE SanPham
    SET soLuongTon = soLuongTon - i.soLuong
    FROM SanPham sp
    JOIN inserted i ON sp.maSanPham = i.maSanPham
END

SELECT * FROM SanPham

INSERT INTO ChiTietHoaDon VALUES (1, 1, 5)

SELECT * FROM SanPham

ALTER TABLE KhachHang ADD soLanMua INT DEFAULT 0

CREATE TRIGGER trg_HoaDon_Insert
ON HoaDon
AFTER INSERT
AS
BEGIN
    UPDATE KhachHang
    SET soLanMua = soLanMua + 1
    FROM KhachHang kh
    JOIN inserted i ON kh.maKhachHang = i.maKhachHang
END

CREATE TRIGGER trg_KhachHang_Update
ON KhachHang
AFTER UPDATE
AS
BEGIN
    UPDATE HoaDon
    SET tongTien = tongTien
    FROM HoaDon hd
    JOIN inserted i ON hd.maKhachHang = i.maKhachHang
END
INSERT INTO HoaDon VALUES (2, 1, 0)

DECLARE cur_SanPham CURSOR
FOR
SELECT maSanPham, tenSanPham, soLuongTon
FROM SanPham

OPEN cur_SanPham

DECLARE @ma INT
DECLARE @ten NVARCHAR(100)
DECLARE @sl INT

FETCH NEXT FROM cur_SanPham INTO @ma, @ten, @sl

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @sl < 50
        PRINT N'Sản phẩm ' + @ten + N' sắp hết hàng'

    FETCH NEXT FROM cur_SanPham INTO @ma, @ten, @sl
END

CLOSE cur_SanPham
DEALLOCATE cur_SanPham

SELECT 
    tenSanPham,
    soLuongTon,
    CASE 
        WHEN soLuongTon < 50 
        THEN N'Sắp hết hàng'
        ELSE N'Đủ hàng'
    END AS TrangThai
FROM SanPham

SET STATISTICS TIME ON
DECLARE cur_TangGia CURSOR
FOR
SELECT maSanPham, gia
FROM SanPham

OPEN cur_TangGia

DECLARE @ma INT
DECLARE @gia FLOAT

FETCH NEXT FROM cur_TangGia INTO @ma, @gia

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @gia < 20
        UPDATE SanPham SET gia = gia + 5 WHERE maSanPham = @ma
    ELSE
        UPDATE SanPham SET gia = gia + 2 WHERE maSanPham = @ma

    FETCH NEXT FROM cur_TangGia INTO @ma, @gia
END

CLOSE cur_TangGia
DEALLOCATE cur_TangGia