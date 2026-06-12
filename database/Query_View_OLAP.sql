-- ==========================================
-- QUERY UNTUK MELIHAT ISI DATA WAREHOUSE (OLAP)
-- ==========================================

-- 1. Cek Tabel Dimensi Waktu (10 Baris Pertama)
SELECT TOP 10 * 
FROM Dim_Waktu;

-- 2. Cek Tabel Dimensi Lokasi (10 Baris Pertama)
SELECT * 
FROM Dim_Lokasi;

-- 3. Cek Tabel Dimensi Kategori
SELECT * 
FROM Dim_Kategori;

-- 4. Cek Tabel Fakta (10 Baris Pertama)
SELECT TOP 10 * 
FROM Fakta_Gempa;

-- ==========================================
-- QUERY PENGUJIAN STAR SCHEMA (JOIN)
-- ==========================================
-- 5. Query Master: Menyatukan Fakta & Semua Dimensi
-- (Ini adalah bentuk data utuh yang biasanya diekstrak oleh Power BI/Tableau)
SELECT TOP 100
    f.id_gempa,
    w.tahun,
    w.bulan,
    w.tanggal,
    w.jam,
    w.menit,
    l.wilayah,
    l.kota_terdekat,
    l.arah,
    k.kategori,
    f.magnitudo,
    f.kedalaman,
    f.jarak_km,
    f.garis_bujur,
    f.garis_lintang
FROM Fakta_Gempa f
JOIN Dim_Waktu w ON f.Waktu_ID = w.Waktu_ID
JOIN Dim_Lokasi l ON f.Lokasi_ID = l.Lokasi_ID
JOIN Dim_Kategori k ON f.Kategori_ID = k.Kategori_ID
ORDER BY w.tahun DESC, w.bulan DESC, w.tanggal DESC;


-- ==========================================
-- CONTOH QUERY ANALITIK OLAP (AGREGASI)
-- ==========================================
-- 6. Menghitung jumlah gempa dan rata-rata magnitudo per wilayah & kategori
SELECT TOP 20
    l.wilayah,
    k.kategori,
    COUNT(f.Fakta_ID) AS total_kejadian_gempa,
    ROUND(AVG(f.magnitudo), 2) AS rata_rata_magnitudo,
    ROUND(MAX(f.magnitudo), 2) AS magnitudo_tertinggi
FROM Fakta_Gempa f
JOIN Dim_Lokasi l ON f.Lokasi_ID = l.Lokasi_ID
JOIN Dim_Kategori k ON f.Kategori_ID = k.Kategori_ID
GROUP BY l.wilayah, k.kategori
ORDER BY total_kejadian_gempa DESC;
