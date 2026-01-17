-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 14 Jan 2026 pada 08.21
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dbpegawai_alif`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `absensi_ali`
--

CREATE TABLE `absensi_ali` (
  `id_absensi_ali` int(11) NOT NULL,
  `nip_ali` char(10) DEFAULT NULL,
  `tanggal_ali` date DEFAULT NULL,
  `status_ali` enum('Hadir','Izin','Sakit','Alpha') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `absensi_ali`
--

INSERT INTO `absensi_ali` (`id_absensi_ali`, `nip_ali`, `tanggal_ali`, `status_ali`) VALUES
(1, 'P001', '2024-01-02', 'Hadir'),
(2, 'P001', '2024-01-03', 'Hadir'),
(3, 'P002', '2024-01-02', 'Izin'),
(4, 'P003', '2024-01-02', 'Hadir'),
(5, 'P004', '2024-01-02', 'Sakit');

--
-- Trigger `absensi_ali`
--
DELIMITER $$
CREATE TRIGGER `tr_cegah_absen_ganda` BEFORE INSERT ON `absensi_ali` FOR EACH ROW BEGIN
    DECLARE total_absen INT;
    
    -- Menggunakan nama field yang sesuai dengan gambar: nip_ali dan tanggal_ali
    SELECT COUNT(*) INTO total_absen 
    FROM absensi_ali 
    WHERE nip_ali = NEW.nip_ali 
      AND tanggal_ali = NEW.tanggal_ali;
    
    -- Jika ditemukan data dengan NIP dan Tanggal yang sama, batalkan input
    IF total_absen > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Pegawai sudah melakukan absensi pada tanggal tersebut!';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `departemen_ali`
--

CREATE TABLE `departemen_ali` (
  `id_departemen_ali` int(11) NOT NULL,
  `nama_departemen_ali` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `departemen_ali`
--

INSERT INTO `departemen_ali` (`id_departemen_ali`, `nama_departemen_ali`) VALUES
(1, 'IT'),
(2, 'SDM'),
(3, 'Keuangan'),
(4, 'Operasional'),
(5, 'Marketing');

-- --------------------------------------------------------

--
-- Struktur dari tabel `gaji_ali`
--

CREATE TABLE `gaji_ali` (
  `id_gaji_ali` int(11) NOT NULL,
  `nip_ali` char(10) DEFAULT NULL,
  `bulan_ali` varchar(20) DEFAULT NULL,
  `total_gaji_ali` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `gaji_ali`
--

INSERT INTO `gaji_ali` (`id_gaji_ali`, `nip_ali`, `bulan_ali`, `total_gaji_ali`) VALUES
(1, 'P001', 'Januari', 8000000.00),
(2, 'P002', 'Januari', 6000000.00),
(3, 'P003', 'Januari', 4000000.00),
(4, 'P004', 'Januari', 3500000.00),
(5, 'P005', 'Januari', 2500000.00);

--
-- Trigger `gaji_ali`
--
DELIMITER $$
CREATE TRIGGER `tr_set_gaji_jabatan` BEFORE INSERT ON `gaji_ali` FOR EACH ROW BEGIN
    DECLARE v_jabatan VARCHAR(50);
    
    -- Ambil jabatan dari tabel pegawai
    SELECT jabatan_ali INTO v_jabatan FROM pegawai_ali WHERE nip_ali = NEW.nip_ali;
    
    -- Tentukan nominal gaji
    IF v_jabatan = 'Manager' THEN
        SET NEW.total_gaji_ali = 8000000;
    ELSEIF v_jabatan = 'Staff' THEN
        SET NEW.total_gaji_ali = 4000000;
    ELSE
        SET NEW.total_gaji_ali = 2500000;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `jabatan_ali`
--

CREATE TABLE `jabatan_ali` (
  `id_jabatan_ali` int(11) NOT NULL,
  `nama_jabatan_ali` varchar(50) DEFAULT NULL,
  `gaji_pokok_ali` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `jabatan_ali`
--

INSERT INTO `jabatan_ali` (`id_jabatan_ali`, `nama_jabatan_ali`, `gaji_pokok_ali`) VALUES
(1, 'Manager', 8000000.00),
(2, 'Supervisor', 6000000.00),
(3, 'Staff', 4000000.00),
(4, 'Admin', 3500000.00),
(5, 'Intern', 2500000.00);

-- --------------------------------------------------------

--
-- Struktur dari tabel `pegawai_ali`
--

CREATE TABLE `pegawai_ali` (
  `nip_ali` char(10) NOT NULL,
  `nama_pegawai_ali` varchar(100) DEFAULT NULL,
  `jenis_kelamin_ali` enum('L','P') DEFAULT NULL,
  `id_departemen_ali` int(11) DEFAULT NULL,
  `id_jabatan_ali` int(11) DEFAULT NULL,
  `tanggal_masuk_ali` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pegawai_ali`
--

INSERT INTO `pegawai_ali` (`nip_ali`, `nama_pegawai_ali`, `jenis_kelamin_ali`, `id_departemen_ali`, `id_jabatan_ali`, `tanggal_masuk_ali`) VALUES
('P001', 'Andi Pratama', 'L', 3, 1, '2022-01-10'),
('P002', 'Siti Aisyah', 'P', 2, 2, '2022-03-15'),
('P003', 'Budi Santoso', 'L', 1, 3, '2023-02-01'),
('P004', 'Rina Kartika', 'P', 4, 4, '2023-07-20'),
('P005', 'Doni Saputra', 'L', 5, 5, '2024-01-01');

--
-- Trigger `pegawai_ali`
--
DELIMITER $$
CREATE TRIGGER `tr_tambah_pegawai_gaji` AFTER INSERT ON `pegawai_ali` FOR EACH ROW BEGIN
    INSERT INTO gaji_ali (nip_ali, bulan_ali, total_gaji_ali)
    VALUES (NEW.nip_ali, 'Januari', 0); 
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `absensi_ali`
--
ALTER TABLE `absensi_ali`
  ADD PRIMARY KEY (`id_absensi_ali`),
  ADD KEY `nip_ali` (`nip_ali`);

--
-- Indeks untuk tabel `departemen_ali`
--
ALTER TABLE `departemen_ali`
  ADD PRIMARY KEY (`id_departemen_ali`);

--
-- Indeks untuk tabel `gaji_ali`
--
ALTER TABLE `gaji_ali`
  ADD PRIMARY KEY (`id_gaji_ali`),
  ADD KEY `nip_ali` (`nip_ali`);

--
-- Indeks untuk tabel `jabatan_ali`
--
ALTER TABLE `jabatan_ali`
  ADD PRIMARY KEY (`id_jabatan_ali`);

--
-- Indeks untuk tabel `pegawai_ali`
--
ALTER TABLE `pegawai_ali`
  ADD PRIMARY KEY (`nip_ali`),
  ADD KEY `id_departemen_ali` (`id_departemen_ali`),
  ADD KEY `id_jabatan_ali` (`id_jabatan_ali`);

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `absensi_ali`
--
ALTER TABLE `absensi_ali`
  ADD CONSTRAINT `absensi_ali_ibfk_1` FOREIGN KEY (`nip_ali`) REFERENCES `pegawai_ali` (`nip_ali`);

--
-- Ketidakleluasaan untuk tabel `gaji_ali`
--
ALTER TABLE `gaji_ali`
  ADD CONSTRAINT `gaji_ali_ibfk_1` FOREIGN KEY (`nip_ali`) REFERENCES `pegawai_ali` (`nip_ali`);

--
-- Ketidakleluasaan untuk tabel `pegawai_ali`
--
ALTER TABLE `pegawai_ali`
  ADD CONSTRAINT `pegawai_ali_ibfk_1` FOREIGN KEY (`id_departemen_ali`) REFERENCES `departemen_ali` (`id_departemen_ali`),
  ADD CONSTRAINT `pegawai_ali_ibfk_2` FOREIGN KEY (`id_jabatan_ali`) REFERENCES `jabatan_ali` (`id_jabatan_ali`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
