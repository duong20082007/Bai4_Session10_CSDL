-- 1. Tạo bảng Pharmacy_Inventory
CREATE TABLE Pharmacy_Inventory (
    Inventory_ID INT AUTO_INCREMENT PRIMARY KEY,
    Drug_Name VARCHAR(255),
    Batch_Number VARCHAR(50),
    Expiry_Date DATE,
    Quantity INT
);

-- 2. (Tùy chọn) Procedure sinh nhanh 2 triệu dòng dữ liệu để Test hiệu năng
INSERT INTO Pharmacy_Inventory (Drug_Name, Batch_Number, Expiry_Date, Quantity)
SELECT 
    CONCAT('Patient ', t.n),
    CONCAT('090', t.n),
    FLOOR(RAND() * 100),
    'Ho Chi Minh City'
FROM (    
    SELECT a.N + b.N * 10 + c.N * 100 + 1 AS n    
    FROM         
        (SELECT 0 N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a,
        (SELECT 0 N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b,
        (SELECT 0 N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c
) t
WHERE t.n <= 1000;
-- 2 Index đơn độc lập và 1 Composite Index
SELECT * FROM Pharmacy_Inventory 
WHERE Drug_Name = 'Paracetamol' AND Expiry_Date <= '2026-06-01';

-- 3
CREATE INDEX idx_name ON Pharmacy_Inventory(Drug_Name);
CREATE INDEX idx_date ON Pharmacy_Inventory(Expiry_Date);

-- Lý do Index bị vô hiệu hóa:
-- Index được cấu trúc dưới dạng cây tìm kiếm (B-Tree) sắp xếp từ trái qua phải (Ví dụ vần A rồi mới đến B, C)
SELECT * FROM Pharmacy_Inventory WHERE Drug_Name LIKE '%cetamol%';

-- giai phap:
-- Chỉ dùng Wildcard ở đuôi
SELECT * FROM Pharmacy_Inventory WHERE Drug_Name LIKE 'Para%';

-- so sanh
-- Tiêu chí				2 Index Đơn							1 Composite Index
-- Cơ chế				Tìm riêng lẻ từng cây B-Tree 		Duyệt qua 1 cây B-Tree 
-- 						-> Giao thoa kết quả				có cấu trúc phân cấp
-- Tốc độ				Trung bình							nhanh
-- Tiêu hao				Tốn CPU và RAM						Rất ít tốn tài nguyên

