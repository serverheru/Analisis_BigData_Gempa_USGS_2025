-- ==========================================
-- DML: QUERY MIGRASI DARI OLTP KE OLAP (DATA WAREHOUSE)
-- ==========================================

-- 1. Insert Data ke Dimensi Waktu
INSERT INTO Dim_Waktu (tahun, bulan, tanggal, jam, menit)
SELECT DISTINCT tahun, bulan, tanggal, jam, menit
FROM USGS_BIGDATA.dbo.earthquake_2025
WHERE tahun IS NOT NULL;

-- 2. Insert Data ke Dimensi Lokasi
INSERT INTO Dim_Lokasi (wilayah, kota_terdekat, arah)
SELECT DISTINCT wilayah, kota_terdekat, arah
FROM USGS_BIGDATA.dbo.earthquake_2025
WHERE wilayah IS NOT NULL;

-- 3. Insert Data ke Dimensi Kategori
INSERT INTO Dim_Kategori (kategori)
SELECT DISTINCT kategori
FROM USGS_BIGDATA.dbo.earthquake_2025
WHERE kategori IS NOT NULL;

-- 4. Insert Data ke Tabel Fakta (Mencari ID dari tiap dimensi)
INSERT INTO Fakta_Gempa ( id_gempa, Waktu_ID, Lokasi_ID, Kategori_ID, 
    magnitudo, kedalaman, jarak_km, garis_bujur, garis_lintang
)
SELECT o.id, w.Waktu_ID, l.Lokasi_ID, k.Kategori_ID, o.magnitude, 
	   o.depth, o.jarak_km, o.longitude, o.latitude
FROM USGS_BIGDATA.dbo.earthquake_2025 o
LEFT JOIN Dim_Waktu w 
    ON o.tahun = w.tahun 
   AND o.bulan = w.bulan 
   AND o.tanggal = w.tanggal 
   AND o.jam = w.jam 
   AND o.menit = w.menit
LEFT JOIN Dim_Lokasi l 
    ON o.wilayah = l.wilayah 
   AND ISNULL(o.kota_terdekat, '') = ISNULL(l.kota_terdekat, '') 
   AND ISNULL(o.arah, '') = ISNULL(l.arah, '')
LEFT JOIN Dim_Kategori k 
    ON o.kategori = k.kategori;