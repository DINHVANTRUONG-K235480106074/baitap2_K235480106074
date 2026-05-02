# baitap2_K235480106074
Họ tên: Đinh Văn Trường

MSSV:K235480106074

LỚP: K59kmt.k01

PHẦN 1:Thiết kế và Khởi tạo Cấu trúc Dữ liệu (Kiến thức 6, 7)
- tạo database với quanlybanhang_K235480106074
  <img width="1919" height="1079" alt="Screenshot 2026-05-01 223419" src="https://github.com/user-attachments/assets/b8b6ebb8-553d-43ba-bed1-f959f3bde2da" />
- KhachHang: lưu thông tin khách
- SanPham: lưu sản phẩm
- HoaDon: lưu hóa đơn
- ChiTietHoaDon: chi tiết từng hóa đơn
*PK
maKhachHang
maSanPham
maHoaDon
(maHoaDon, maSanPham) (khóa kép)
*FK (Foreign Key)
HoaDon → KhachHang
ChiTietHoaDon → HoaDon
ChiTietHoaDon → SanPham
*CK (Check Constraint)
gia > 0
soLuongTon >= 0
soLuong > 0
* Kiểu dữ liệu đã dùng
INT (số nguyên)
FLOAT (số thực)
NVARCHAR (chuỗi Unicode)
DATE (ngày tháng)
<img width="1919" height="1079" alt="Screenshot 2026-05-01 224648" src="https://github.com/user-attachments/assets/afba8297-698a-442c-bc1b-6287a5ab3fb3" />
<img width="1919" height="1079" alt="Screenshot 2026-05-01 224749" src="https://github.com/user-attachments/assets/a52ce57d-7315-4906-9e74-fb66ad75db2b" />
<img width="1919" height="1079" alt="Screenshot 2026-05-01 224826" src="https://github.com/user-attachments/assets/ced82943-0934-462d-8734-0032fbb6cae0" />
<img width="1919" height="1079" alt="Screenshot 2026-05-01 225047" src="https://github.com/user-attachments/assets/8f41cfc3-3ee6-4bae-93cd-85949caa0473" />
PHẦN 2: Xây dựng Function

* Các loại hàm có sẵn trong SQL Server
  
Hàm xử lý chuỗi: LEN, LOWER, UPPER

Hàm số học: ABS, ROUND

Hàm ngày giờ: GETDATE, DATEDIFF

Hàm hệ thống: @@VERSION, SUSER_NAME

*Một số hàm đặc sắc:

SELECT GETDATE() AS NgayHienTai

SELECT LEN(N'Xin chào') AS DoDaiChuoi

SELECT ABS(-100) AS GiaTriTuyetDoi

SELECT @@VERSION AS ThongTinSQL

*Mục đích:

Tái sử dụng logic

Tính toán phức tạp

Làm code gọn hơn

  * Các loại:
  * 
Scalar Function → trả 1 giá trị

Inline Table Function → trả bảng đơn giản

Multi Table Function → xử lý logic phức tạp

<img width="1919" height="1079" alt="Screenshot 2026-05-01 231037" src="https://github.com/user-attachments/assets/b8c5da54-129e-4b21-a786-2bc31073d572" />
2.1. SCALAR FUNCTION

Tạo hàm có tên fn_TinhTongTien với tham số truyền vào là @maHoaDon.

Hàm này thực hiện tính toán tổng giá trị của một hóa đơn cụ thể bằng cách lấy Gia từ bảng SanPham nhân với SoLuong từ bảng ChiTietHoaDon, sau đó dùng hàm SUM() để cộng dồn lại.
Giá trị trả về là kiểu FLOAT.
<img width="1919" height="1079" alt="Screenshot 2026-05-01 230214" src="https://github.com/user-attachments/assets/35b96370-a163-46b8-bc08-45363e91c5da" />
ọi hàm
<img width="1919" height="1079" alt="Screenshot 2026-05-01 230434" src="https://github.com/user-attachments/assets/8d4d7fdb-201b-433b-a927-bfd544952365" />
2.2 INLINE TABLE FUNCTION

    Tạo hàm fn_SanPhamGiaCao nhận tham số đầu vào là @gia (kiểu FLOAT).
    
Thay vì trả về 1 con số đơn lẻ, hàm này trả về một tập hợp dữ liệu (bảng) gồm tất cả các cột từ bảng SanPham thỏa mãn điều kiện giá lớn hơn giá trị tham số truyền vào.

Bên dưới hàm, lệnh SELECT * FROM fn_SanPhamGiaCao(1) được dùng để khai thác hàm: Lọc ra các sản phẩm có giá lớn hơn 1.
<img width="1919" height="1079" alt="Screenshot 2026-05-01 231356" src="https://github.com/user-attachments/assets/6c8d77fe-166c-42c3-acb6-69454069eb13" />
Tạo hàm fn_ThongKeBanHang không cần tham số đầu vào.

Khác với hàm Inline, hàm này khai báo một biến bảng tạm @bang với cấu trúc cột rõ ràng (tenSanPham, tongSoLuong) ngay tại phần RETURNS.

Sử dụng khối lệnh BEGIN...END để thực hiện tính toán: Dùng lệnh INSERT INTO @bang kết hợp với truy vấn SELECT...GROUP BY để thống kê tổng số lượng đã bán của từng sản phẩm thông qua việc JOIN giữa bảng ChiTietHoaDon và SanPham.

Cuối cùng dùng lệnh RETURN để trả về nội dung đã nạp vào biến bảng @bang.
<img width="1919" height="1079" alt="Screenshot 2026-05-01 231548" src="https://github.com/user-attachments/assets/0a8bbe6b-0b94-4ba0-bc12-f01288d13c56" />
Phần 3 : Xây dựng Store Procedure
Một vài system sp trong SQL Server
sp_help : Hiển thị thông tin chi tiết của bảng (cột, ràng buộc, khóa)
sp_columns : Chỉ hiển thị thông tin các cột của bảng
sp_rename : Đổi tên bảng, cột hoặc ràng buộc
sp_who : Xem ai đang kết nối đến SQL Server
sp_helpdb : Xem thông tin database (kích thước, ngày tạo)
sp_tables : Liệt kê tất cả bảng trong database

EXEC sp_help 'SanPham'
<img width="1919" height="1079" alt="Screenshot 2026-05-03 000142" src="https://github.com/user-attachments/assets/ec138802-1270-4305-a01d-35e9b5fe05c8" />
EXEC sp_tables
<img width="1919" height="1079" alt="Screenshot 2026-05-03 000229" src="https://github.com/user-attachments/assets/5aaf6f52-75b8-4f92-b280-a2c83e729e98" />
EXEC sp_helptext 'fn_TinhTongTien'
<img width="1919" height="1079" alt="Screenshot 2026-05-03 000301" src="https://github.com/user-attachments/assets/76e957f8-4a10-4426-a044-0dbce2262d13" />
3.1 STORE PROCEDURE INSERT (CÓ ĐIỀU KIỆN)
Tạo Store Procedure có tên sp_ThemSanPham với các tham số đầu vào: @ma, @ten, @gia, và @soLuong.
Logic kiểm tra: Sử dụng cấu trúc IF...ELSE để kiểm tra giá trị của biến @gia.
Nếu @gia <= 0, hệ thống sẽ không thực hiện thêm dữ liệu và in ra thông báo "Giá không hợp lệ".
Nếu giá hợp lệ, hệ thống mới thực thi lệnh INSERT INTO SanPham và báo "Thêm thành công".
Việc này giúp đảm bảo tính toàn vẹn của dữ liệu ngay từ tầng xử lý, tránh việc nhập dữ liệu rác vào database.
<img width="1919" height="1079" alt="Screenshot 2026-05-01 232717" src="https://github.com/user-attachments/assets/48b8177b-a8a5-4881-ac6f-b967163d9e58" />
<img width="1919" height="1079" alt="Screenshot 2026-05-01 232757" src="https://github.com/user-attachments/assets/7d775d3b-ab31-492e-81a8-575549d61b9f" />
3.2 Stored Procedure có OUTPUT
Tạo Store Procedure sp_TinhTongTien với hai tham số: @maHoaDon (đầu vào) và @tong (đầu ra - kiểu FLOAT OUTPUT).
Bên trong SP, lệnh SELECT @tong = SUM(...) thực hiện tính tổng tiền của hóa đơn bằng cách Join bảng ChiTietHoaDon và SanPham. Kết quả tính toán thay vì in ra màn hình sẽ được gán trực tiếp vào biến @tong.
Cơ chế này cho phép các chương trình bên ngoài hoặc các đoạn script SQL khác nhận lại được kết quả tính toán để tiếp tục xử lý logic.
<img width="1919" height="1078" alt="Screenshot 2026-05-01 232854" src="https://github.com/user-attachments/assets/9c7f0d2c-b57b-4aa5-a3ad-ebe8f57eb791" />
Sử dụng lệnh DECLARE @kq FLOAT để khai báo một biến tạm lưu trữ kết quả.
Lệnh EXEC sp_TinhTongTien 1, @kq OUTPUT thực hiện gọi thủ tục, truyền vào mã hóa đơn là 1 và yêu cầu SP nạp giá trị tính toán được vào biến @kq.
Cuối cùng, lệnh SELECT @kq AS TongTien dùng để xuất giá trị của biến đó ra màn hình dưới dạng một cột kết quả.
<img width="1919" height="1079" alt="Screenshot 2026-05-01 232920" src="https://github.com/user-attachments/assets/04198d6a-518e-451b-ad79-b3ff99cec690" />
3.3 Stored Procedure JOIN nhiều bảng
Tạo Store Procedure sp_DanhSachHoaDon.
Kỹ thuật Join: SP thực hiện kết nối (JOIN) giữa bảng HoaDon (bí danh hd) và bảng KhachHang (bí danh kh) thông qua trường khóa ngoại maKhachHang.
Lệnh này cho phép lấy được thông tin chi tiết: Mã hóa đơn, Tên khách hàng (từ bảng Khách hàng) và Tổng tiền của hóa đơn đó.
Sau khi tạo, lệnh EXEC sp_DanhSachHoaDon được dùng để thực thi và hiển thị kết quả.
<img width="1919" height="1079" alt="Screenshot 2026-05-01 233021" src="https://github.com/user-attachments/assets/b2978b32-f8f4-48e9-96fd-39a4e9725d23" />
Phần 4: Trigger và Xử lý logic nghiệp vụ
4.1 Viết Trigger để tự động cập nhật dữ liệu bảng B khi dữ liệu bảng A thay đổi.
Tạo Trigger có tên trg_GiamSoLuongTon trên bảng ChiTietHoaDon.
Logic xử lý: Trigger này được thiết lập với điều kiện AFTER INSERT (sau khi thêm mới một chi tiết hóa đơn).
Khi có một mặt hàng được bán (insert vào bảng ChiTietHoaDon), Trigger sẽ tự động thực hiện lệnh UPDATE trên bảng SanPham để giảm cột soLuongTon tương ứng với số lượng vừa bán (i.soLuong).
Sử dụng bảng ảo inserted để lấy chính xác dữ liệu của dòng vừa được thêm vào, đảm bảo tính cập nhật tức thời và chính xác.
<img width="1919" height="1079" alt="Screenshot 2026-05-02 221738" src="https://github.com/user-attachments/assets/efd5b231-d79d-4322-a4b6-9b73a2dce4fe" />
Kiểm tra hoạt động của Trigger trg_GiamSoLuongTon và quan sát các ràng buộc dữ liệu (Constraints).
Sử dụng lệnh INSERT INTO ChiTietHoaDon VALUES (1, 1, 5) để giả định một giao dịch bán hàng (Mã HD 1, Mã SP 1, Số lượng 5).
Mục đích là để kích hoạt Trigger tự động trừ số lượng tồn kho ở bảng SanPham.
<img width="1919" height="1079" alt="Screenshot 2026-05-02 221857" src="https://github.com/user-attachments/assets/84711311-7117-460f-9b69-092b1cf4e63d" />
Thực hiện thay đổi cấu trúc bảng để chuẩn bị cho logic xử lý nghiệp vụ nâng cao.
Sử dụng lệnh ALTER TABLE [KhachHang] để thêm một cột mới có tên [soLanMua].
Cột này có kiểu dữ liệu là INT và giá trị mặc định (DEFAULT) là 0.
<img width="1919" height="1079" alt="Screenshot 2026-05-02 222207" src="https://github.com/user-attachments/assets/44b3ce40-6f7b-46db-8b96-26c70070bc1c" />
Tự động hóa cập nhật dữ liệu giữa hai bảng có quan hệ.
Tạo Trigger trg_HoaDon_Insert trên bảng HoaDon với điều kiện AFTER INSERT.
Logic xử lý: Mỗi khi có một hóa đơn mới được chèn vào hệ thống (khách hàng thực hiện mua hàng), Trigger sẽ tự động UPDATE bảng KhachHang.
Cụ thể, nó sẽ tăng giá trị cột soLanMua thêm 1 đơn vị cho đúng khách hàng vừa thực hiện giao dịch đó (dựa trên maKhachHang lấy từ bảng ảo inserted).
<img width="1919" height="1079" alt="Screenshot 2026-05-02 222258" src="https://github.com/user-attachments/assets/91c47664-5e46-466f-8c78-aa95a7630fd1" />
Thiết lập Trigger thứ hai để tạo kịch bản cập nhật vòng lặp (Recursive Trigger).
Tạo Trigger trg_KhachHang_Update trên bảng KhachHang với điều kiện AFTER UPDATE.
Logic xử lý: Khi thông tin khách hàng bị thay đổi, Trigger này sẽ tự động cập nhật lại cột tongTien trong bảng HoaDon.
Mục đích thí nghiệm: Kết hợp với Trigger trg_HoaDon_Insert/Update (đã tạo ở bước trước), việc này tạo ra một vòng lặp: Cập nhật KhachHang -> kích hoạt Trigger cập nhật HoaDon -> Trigger trên HoaDon lại kích hoạt cập nhật ngược lại KhachHang...
<img width="1919" height="1079" alt="Screenshot 2026-05-02 222329" src="https://github.com/user-attachments/assets/ea64e268-e65e-47b9-baba-a63885381260" />
: Kiểm tra tính nhất quán dữ liệu và sự hoạt động liên hoàn của các Trigger trong hệ thống.
Thực hiện lệnh INSERT INTO HoaDon để tạo một giao dịch mới cho khách hàng.
<img width="1919" height="1079" alt="Screenshot 2026-05-02 222407" src="https://github.com/user-attachments/assets/0916cd93-4d2c-4205-b001-84f1d431fe4e" />
Phần 5: Cursor và Duyệt dữ liệu
Duyệt danh sách sản phẩm để đưa ra cảnh báo tồn kho.
Khai báo một con trỏ cur_SanPham để lấy dữ liệu từ bảng SanPham.
Sử dụng vòng lặp WHILE @@FETCH_STATUS = 0 để duyệt qua từng sản phẩm trong kho.
Logic nghiệp vụ: Kiểm tra nếu số lượng tồn (@sl) nhỏ hơn 50, hệ thống sẽ in ra thông báo cảnh báo: "Sản phẩm [Tên] sắp hết hàng".
<img width="1919" height="1079" alt="Screenshot 2026-05-02 222614" src="https://github.com/user-attachments/assets/e83ea168-6161-4977-b00c-424fb7a757e3" />
Viết câu lệnh SQL tương đương với Cursor để so sánh tốc độ và cách xử lý.
Sử dụng lệnh SELECT kết hợp cấu trúc CASE...WHEN để phân loại trạng thái tồn kho của sản phẩm ngay trong lúc truy vấn.
Nếu soLuongTon < 50 thì hiển thị "Sắp hết hàng", ngược lại là "Đủ hàng".
<img width="1919" height="1079" alt="Screenshot 2026-05-02 222713" src="https://github.com/user-attachments/assets/c255ea48-4ab8-405f-9739-7835813c7fe9" />
Sử dụng các thiết lập hệ thống để kiểm tra thời gian thực thi (Execution Time) và thời gian biên dịch (Compile Time) của đoạn mã sử dụng Cursor.
<img width="1919" height="1079" alt="Screenshot 2026-05-02 223153" src="https://github.com/user-attachments/assets/b1cdd9e9-ebc3-4671-a94b-3f1ede2377cc" />
Sử dụng Cursor để duyệt danh sách sản phẩm và thực hiện cập nhật giá bán dựa trên các mức giá khác nhau.
Khai báo con trỏ cur_TangGia để lấy mã sản phẩm và giá hiện tại.
<img width="1919" height="1079" alt="Screenshot 2026-05-02 223703" src="https://github.com/user-attachments/assets/dd480e28-3c39-459e-8c29-b3c192aad644" />
