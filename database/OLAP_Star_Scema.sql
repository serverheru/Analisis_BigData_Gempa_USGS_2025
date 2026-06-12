-- ==========================================
-- DDL: SKEMA DATA WAREHOUSE (STAR SCHEMA)
-- ==========================================

-- 1. Membuat Dimensi Waktu (Dim_Waktu)
CREATE TABLE Dim_Waktu (
    Waktu_ID INT IDENTITY(1,1) PRIMARY KEY,
    tahun INT,
    bulan INT,
    tanggal INT,
    jam INT,
    menit INT
);

-- 2. Membuat Dimensi Lokasi (Dim_Lokasi)
CREATE TABLE Dim_Lokasi (
    Lokasi_ID INT IDENTITY(1,1) PRIMARY KEY,
    wilayah VARCHAR(255),
    kota_terdekat VARCHAR(255),
    arah VARCHAR(50)
);

-- 3. Membuat Dimensi Kategori (Dim_Kategori)
CREATE TABLE Dim_Kategori (
    Kategori_ID INT IDENTITY(1,1) PRIMARY KEY,
    kategori VARCHAR(50)
);

-- 4. Membuat Tabel Fakta (Fakta_Gempa)
CREATE TABLE Fakta_Gempa (
    Fakta_ID INT IDENTITY(1,1) PRIMARY KEY,
    id_gempa VARCHAR(50), 
    Waktu_ID INT,
    Lokasi_ID INT,
    Kategori_ID INT,
    magnitudo FLOAT,
    kedalaman FLOAT,
    jarak_km FLOAT,
    garis_bujur FLOAT,
    garis_lintang FLOAT,
    FOREIGN KEY (Waktu_ID) REFERENCES Dim_Waktu(Waktu_ID),
    FOREIGN KEY (Lokasi_ID) REFERENCES Dim_Lokasi(Lokasi_ID),
    FOREIGN KEY (Kategori_ID) REFERENCES Dim_Kategori(Kategori_ID)
);