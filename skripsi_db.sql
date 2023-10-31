-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 31, 2023 at 09:50 AM
-- Server version: 10.4.20-MariaDB
-- PHP Version: 8.0.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `skripsi_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_kategori`
--

CREATE TABLE `tbl_kategori` (
  `kategori_id` int(11) NOT NULL,
  `nama_kategori` varchar(255) DEFAULT NULL,
  `tgl_dibuat` datetime DEFAULT NULL,
  `dibuat_oleh` int(11) DEFAULT NULL,
  `tgl_diupdate` datetime DEFAULT NULL,
  `diupdate_oleh` int(11) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT 0 COMMENT '0=No; 1=Yes'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_kategori`
--

INSERT INTO `tbl_kategori` (`kategori_id`, `nama_kategori`, `tgl_dibuat`, `dibuat_oleh`, `tgl_diupdate`, `diupdate_oleh`, `is_deleted`) VALUES
(1, 'Margarine', '2023-08-16 05:19:53', 0, '2023-08-23 06:59:57', 1, 0),
(2, 'Tepung', '2023-08-17 05:30:47', 1, NULL, 0, 0),
(3, 'Selai', '2023-08-17 05:32:35', 1, '2023-08-27 07:11:06', 1, 0),
(4, 'Meses', '2023-08-17 05:33:38', 1, NULL, 0, 0),
(5, 'Pewarna', '2023-08-17 05:33:59', 1, NULL, 0, 0),
(6, 'Pasta', '2023-08-17 05:34:15', 1, NULL, 0, 0),
(7, 'Mentega / Butter', '2023-08-17 05:34:47', 1, '2023-08-23 07:03:35', 1, 0),
(8, 'Glaze', '2023-08-17 05:40:28', 1, NULL, 0, 1),
(9, 'Keju', '2023-08-17 05:40:38', 1, NULL, 0, 0),
(10, 'Susu Kental Manis', '2023-08-17 05:41:53', 1, NULL, 0, 0),
(11, 'Saus', '2023-08-17 05:42:14', 1, NULL, 0, 0),
(12, 'UHT', '2023-08-17 05:42:51', 1, NULL, 0, 0),
(13, 'Frozen Food', '2023-08-17 05:43:22', 1, NULL, 0, 0),
(14, 'SP', '2023-08-17 05:50:50', 1, NULL, 0, 0),
(15, 'Ragi', '2023-08-27 03:58:06', 1, NULL, 0, 0),
(16, 'Pasta', '2023-08-30 03:23:21', 1, NULL, 0, 0),
(17, 'Essence', '2023-08-30 03:24:01', 1, NULL, 0, 0),
(18, 'Bumbu', '2023-08-30 03:24:34', 1, NULL, 0, 0),
(19, 'Minuman', '2023-08-30 03:24:53', 1, NULL, 0, 0),
(20, 'G', '2023-08-30 03:25:15', 1, NULL, 0, 1),
(21, 'Glaze', '2023-08-30 03:25:36', 1, NULL, 0, 0),
(22, 'Abon', '2023-08-30 03:25:45', 1, NULL, 0, 0),
(23, 'Agar-Agar', '2023-08-30 03:26:18', 1, NULL, 0, 0),
(24, 'Jelly', '2023-08-30 03:26:30', 1, NULL, 0, 0),
(25, 'Mayonaise', '2023-08-30 03:26:48', 1, NULL, 0, 0),
(26, 'Compound', '2023-08-30 03:28:04', 1, NULL, 0, 0),
(27, 'Coklat Bubuk', '2023-08-30 03:28:20', 1, NULL, 0, 0),
(28, 'Bumbu Tabur', '2023-09-06 05:19:45', 1, NULL, 0, 0),
(29, 'Wippy Cream', '2023-09-10 02:40:56', 1, NULL, 0, 0),
(30, 'pengembang', '2023-10-31 02:27:36', 1, NULL, 0, 0),
(31, 'susu bubuk', '2023-10-31 02:46:54', 1, NULL, 0, 0),
(32, 'CV. tiga berlian', '2023-10-31 02:58:50', 1, NULL, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pembelian`
--

CREATE TABLE `tbl_pembelian` (
  `pembelian_id` int(11) NOT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `total_invoice` int(11) DEFAULT NULL,
  `tgl_datang` date DEFAULT NULL,
  `tgl_jatuh_tempo` date DEFAULT NULL,
  `status_pembayaran` varchar(15) DEFAULT NULL,
  `metode_pembayaran` varchar(25) DEFAULT NULL,
  `tgl_bayar` datetime DEFAULT NULL,
  `bukti_pembayaran` varchar(255) DEFAULT NULL,
  `status` int(1) NOT NULL DEFAULT 0,
  `tgl_dibuat` datetime DEFAULT NULL,
  `dibuat_oleh` int(11) DEFAULT NULL,
  `tgl_diupdate` datetime DEFAULT NULL,
  `diupdate_oleh` int(11) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT 0 COMMENT '0=No; 1=Yes'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_pembelian`
--

INSERT INTO `tbl_pembelian` (`pembelian_id`, `supplier_id`, `total_invoice`, `tgl_datang`, `tgl_jatuh_tempo`, `status_pembayaran`, `metode_pembayaran`, `tgl_bayar`, `bukti_pembayaran`, `status`, `tgl_dibuat`, `dibuat_oleh`, `tgl_diupdate`, `diupdate_oleh`, `is_deleted`) VALUES
(1, 10, 9205000, '0000-00-00', '2023-10-29', '0', NULL, '2023-10-28 00:00:00', '', 0, '2023-10-29 06:02:37', 1, NULL, 0, 0),
(2, 9, 5270000, '2023-10-30', '2023-10-29', '1', 'transfer', '2023-10-29 00:00:00', '1698653338_e5b189c98d99b25f184b.jpg', 1, '2023-10-29 06:05:04', 1, NULL, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pembelian_detail`
--

CREATE TABLE `tbl_pembelian_detail` (
  `pembelian_detail_id` int(11) NOT NULL,
  `pembelian_id` int(11) DEFAULT NULL,
  `produk_id` int(11) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `harga_beli` decimal(16,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_pembelian_detail`
--

INSERT INTO `tbl_pembelian_detail` (`pembelian_detail_id`, `pembelian_id`, `produk_id`, `qty`, `harga_beli`) VALUES
(1, 1, 14, 20, '263000.00'),
(2, 1, 15, 10, '263000.00'),
(3, 1, 17, 5, '263000.00'),
(4, 2, 28, 10, '311000.00'),
(5, 2, 38, 5, '432000.00');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_penjualan`
--

CREATE TABLE `tbl_penjualan` (
  `penjualan_id` int(11) NOT NULL,
  `total_bayar` int(11) DEFAULT NULL,
  `metode_pembayaran` varchar(50) DEFAULT NULL,
  `status_pembayaran` varchar(50) DEFAULT NULL,
  `midtrans_id` varchar(255) DEFAULT NULL,
  `midtrans_status` varchar(255) DEFAULT NULL,
  `tgl_dibuat` datetime DEFAULT NULL,
  `dibuat_oleh` int(11) DEFAULT NULL,
  `tgl_diupdate` datetime DEFAULT NULL,
  `diupdate_oleh` int(11) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT 0 COMMENT '0=No; 1=Yes'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_penjualan`
--

INSERT INTO `tbl_penjualan` (`penjualan_id`, `total_bayar`, `metode_pembayaran`, `status_pembayaran`, `midtrans_id`, `midtrans_status`, `tgl_dibuat`, `dibuat_oleh`, `tgl_diupdate`, `diupdate_oleh`, `is_deleted`) VALUES
(1, 124000, 'cash', 'lunas', '0', '', '2023-10-31 04:30:28', 2, NULL, 0, 0),
(2, 244000, 'cash', 'lunas', '0', '', '2023-10-31 04:32:20', 2, NULL, 0, 0),
(3, 195000, 'cash', 'lunas', '0', '', '2023-10-31 04:33:44', 2, NULL, 0, 0),
(4, 81500, 'cash', 'lunas', '0', '', '2023-10-31 04:35:04', 2, NULL, 0, 0),
(5, 62000, 'cash', 'lunas', '0', '', '2023-10-31 04:35:46', 2, NULL, 0, 0),
(6, 211000, 'cash', 'lunas', '0', '', '2023-10-31 04:36:42', 2, NULL, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_penjualan_detail`
--

CREATE TABLE `tbl_penjualan_detail` (
  `penjualan_detail_id` int(11) NOT NULL,
  `penjualan_id` int(11) DEFAULT NULL,
  `produk_id` int(11) DEFAULT NULL,
  `produk_harga_id` int(11) DEFAULT NULL,
  `harga_beli` int(11) DEFAULT NULL,
  `harga_jual` int(11) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `tipe_diskon` varchar(20) NOT NULL,
  `diskon` int(11) NOT NULL,
  `is_deleted` tinyint(1) DEFAULT 0 COMMENT '0=No; 1=Yes'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_penjualan_detail`
--

INSERT INTO `tbl_penjualan_detail` (`penjualan_detail_id`, `penjualan_id`, `produk_id`, `produk_harga_id`, `harga_beli`, `harga_jual`, `qty`, `tipe_diskon`, `diskon`, `is_deleted`) VALUES
(1, 1, 24, 88, 16261, 18500, 1, 'nominal', 0, 0),
(2, 1, 14, 80, 21200, 23500, 1, 'nominal', 0, 0),
(3, 1, 14, 81, 10600, 12000, 1, 'nominal', 0, 0),
(4, 1, 15, 41, 10600, 12000, 1, 'nominal', 0, 0),
(5, 1, 41, 166, 16391, 19000, 1, 'nominal', 0, 0),
(6, 1, 47, 192, 9120, 10500, 2, 'nominal', 0, 0),
(7, 1, 23, 85, 16167, 18000, 1, 'nominal', 0, 0),
(8, 2, 47, 192, 9120, 10500, 2, 'nominal', 0, 0),
(9, 2, 48, 189, 8880, 10000, 2, 'nominal', 0, 0),
(10, 2, 42, 170, 24500, 29000, 1, 'nominal', 0, 0),
(11, 2, 35, 132, 34986, 39000, 2, 'nominal', 0, 0),
(12, 2, 15, 40, 21200, 23500, 1, 'nominal', 0, 0),
(13, 2, 23, 85, 16167, 18000, 1, 'nominal', 0, 0),
(14, 2, 46, 183, 27000, 31500, 1, 'nominal', 0, 0),
(15, 2, 37, 141, 19012, 23000, 1, 'nominal', 0, 0),
(16, 3, 48, 189, 8880, 10000, 5, 'nominal', 0, 0),
(17, 3, 47, 192, 9120, 10500, 4, 'nominal', 0, 0),
(18, 3, 35, 132, 34986, 39000, 1, 'nominal', 0, 0),
(19, 3, 45, 179, 10209, 11500, 2, 'nominal', 0, 0),
(20, 3, 38, 146, 7215, 9500, 1, 'nominal', 0, 0),
(21, 3, 46, 183, 27000, 31500, 1, 'nominal', 0, 0),
(22, 4, 47, 192, 9120, 10500, 2, 'nominal', 0, 0),
(23, 4, 24, 88, 16261, 18500, 1, 'nominal', 0, 0),
(24, 4, 43, 173, 8500, 10500, 1, 'nominal', 0, 0),
(25, 4, 41, 167, 6557, 8000, 1, 'nominal', 0, 0),
(26, 4, 45, 179, 10209, 11500, 1, 'nominal', 0, 0),
(27, 4, 14, 81, 10600, 12000, 1, 'nominal', 0, 0),
(28, 5, 45, 179, 10209, 11500, 2, 'nominal', 0, 0),
(29, 5, 35, 132, 34986, 39000, 1, 'nominal', 0, 0),
(30, 6, 14, 80, 21200, 23500, 1, 'nominal', 0, 0),
(31, 6, 35, 132, 34986, 39000, 1, 'nominal', 0, 0),
(32, 6, 47, 192, 9120, 10500, 8, 'nominal', 0, 0),
(33, 6, 24, 88, 16261, 18500, 2, 'nominal', 0, 0),
(34, 6, 38, 146, 7215, 9500, 1, 'nominal', 0, 0),
(35, 6, 23, 85, 16167, 18000, 1, 'nominal', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_produk`
--

CREATE TABLE `tbl_produk` (
  `produk_id` int(11) NOT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `kategori_id` int(11) DEFAULT NULL,
  `nama_produk` varchar(255) DEFAULT NULL,
  `satuan_terkecil` varchar(255) DEFAULT NULL,
  `netto` int(11) DEFAULT NULL,
  `stok_min` int(11) DEFAULT NULL,
  `tgl_dibuat` datetime DEFAULT NULL,
  `dibuat_oleh` int(11) DEFAULT NULL,
  `tgl_diupdate` datetime DEFAULT NULL,
  `diupdate_oleh` int(11) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT 0 COMMENT '0=No; 1=Yes'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_produk`
--

INSERT INTO `tbl_produk` (`produk_id`, `supplier_id`, `kategori_id`, `nama_produk`, `satuan_terkecil`, `netto`, `stok_min`, `tgl_dibuat`, `dibuat_oleh`, `tgl_diupdate`, `diupdate_oleh`, `is_deleted`) VALUES
(8, 7, 1, 'Palmia Special', 'gram', 15000, NULL, '2023-08-27 03:57:06', 1, '2023-08-30 03:30:46', 1, 1),
(9, 4, 15, 'Fermipan Mini', 'pcs', 240, NULL, '2023-08-27 04:00:02', 1, NULL, 0, 1),
(10, 3, 3, 'Lepatta Stroberi', 'gram', 10000, NULL, '2023-08-27 07:12:52', 1, '2023-08-30 03:31:09', 1, 1),
(11, 8, 2, 'kunci biru', 'gram', 12000, NULL, '2023-08-29 04:29:27', 1, NULL, 0, 1),
(12, 8, 2, 'segitiga biru', 'gram', 12000, NULL, '2023-08-29 04:32:03', 1, NULL, 0, 1),
(13, 9, 2, 'ninja', 'gram', 12000, NULL, '2023-08-29 04:33:06', 1, '2023-08-29 05:50:57', 1, 1),
(14, 10, 4, 'Gogo Coklat', 'gram', 12500, NULL, '2023-08-30 03:51:47', 1, '2023-09-01 04:57:43', 1, 0),
(15, 10, 4, 'Gogo TC', 'gram', 12500, NULL, '2023-08-30 03:55:18', 1, NULL, 0, 0),
(16, 10, 4, 'Gogo Merah', 'gram', 12500, NULL, '2023-08-30 04:00:34', 1, NULL, 0, 0),
(17, 10, 4, 'Gogo Pink', 'gram', 12500, NULL, '2023-08-30 04:05:20', 1, NULL, 0, 0),
(18, 10, 4, 'Gogo Kuning', 'gram', 12500, NULL, '2023-08-30 04:08:03', 1, NULL, 0, 0),
(19, 10, 4, 'Gogo Orange', 'gram', 12500, NULL, '2023-08-30 04:10:45', 1, NULL, 0, 0),
(20, 10, 4, 'Gogo Hijau', 'gram', 12500, NULL, '2023-08-30 04:14:04', 1, NULL, 0, 0),
(21, 10, 4, 'Gogo Ungu', 'gram', 12500, NULL, '2023-08-30 04:16:44', 1, NULL, 0, 0),
(22, 10, 4, 'Gogo Biru', 'gram', 12500, NULL, '2023-08-30 04:18:57', 1, NULL, 0, 0),
(23, 4, 15, 'Fermipan Mini', 'pcs', 240, NULL, '2023-08-30 04:37:36', 1, '2023-09-01 04:58:00', 1, 0),
(24, 7, 1, 'Amanda Kuning', 'gram', 15000, NULL, '2023-09-01 05:01:19', 1, NULL, 0, 0),
(25, 7, 1, 'Simas Kuning', 'gram', 15000, NULL, '2023-09-01 06:25:12', 1, NULL, 0, 0),
(26, 7, 1, 'Palmia Spesial', 'gram', 15000, NULL, '2023-09-01 06:28:25', 1, NULL, 0, 0),
(27, 7, 1, 'Palmia Super Cake', 'gram', 15000, NULL, '2023-09-01 06:31:02', 1, NULL, 0, 0),
(28, 9, 1, 'Mother Choice', 'gram', 15000, NULL, '2023-09-01 06:33:22', 1, NULL, 0, 0),
(29, 7, 1, 'Amanda Putih', 'gram', 15000, NULL, '2023-09-01 06:35:31', 1, NULL, 0, 0),
(30, 7, 1, 'Top White', 'gram', 15000, NULL, '2023-09-01 06:37:22', 1, NULL, 0, 0),
(31, 7, 4, 'Uno', 'gram', 12500, NULL, '2023-09-01 06:41:17', 1, NULL, 0, 1),
(32, 1, 4, 'Jokari  Neon', 'gram', 12000, 36000, '2023-09-01 06:45:11', 1, '2023-09-13 02:45:59', 1, 0),
(33, 1, 4, 'Holland', 'gram', 12500, 0, '2023-09-01 06:47:27', 1, '2023-09-10 06:00:05', 1, 0),
(34, 1, 4, 'Hagel', 'gram', 12500, NULL, '2023-09-01 06:49:30', 1, NULL, 0, 0),
(35, 5, 4, 'Garuda', 'gram', 12500, NULL, '2023-09-01 06:51:53', 1, NULL, 0, 0),
(36, 5, 4, 'Bakery', 'gram', 12500, NULL, '2023-09-01 06:54:24', 1, NULL, 0, 0),
(37, 5, 4, 'Coklat Kacang', 'gram', 12500, NULL, '2023-09-01 06:56:32', 1, NULL, 0, 0),
(38, 9, 7, 'Bos Gold Bullion', 'gram', 15000, NULL, '2023-09-01 07:00:02', 1, NULL, 0, 0),
(39, 13, 29, 'Anchor Wippy Cream', 'pcs', 12, 5, '2023-09-10 02:46:42', 1, NULL, 0, 0),
(40, 8, 2, 'segitiga premium (1 kg)', 'pcs', 12, 36, '2023-09-13 02:54:09', 1, '2023-09-13 02:59:33', 1, 0),
(41, 11, 30, 'ryoto', 'gram', 15000, 30000, '2023-10-31 02:46:12', 1, NULL, 0, 0),
(42, 6, 31, 'vatpro', 'gram', 25000, 250000, '2023-10-31 02:48:21', 1, NULL, 0, 0),
(43, 11, 27, 'dodo', 'gram', 25000, 75000, '2023-10-31 02:52:05', 1, NULL, 0, 0),
(44, 3, 9, 'calf merah', 'pcs', 8, 32, '2023-10-31 02:58:04', 1, NULL, 0, 0),
(45, 15, 9, 'prochiz gold (160 gr)', 'pcs', 48, 480, '2023-10-31 03:01:13', 1, NULL, 0, 0),
(46, 15, 1, 'blueband', 'gram', 15000, 450000, '2023-10-31 03:08:43', 1, NULL, 0, 0),
(47, 14, 2, 'cakra kembar', 'gram', 25000, 75000, '2023-10-31 03:12:16', 1, '2023-10-31 04:17:50', 1, 0),
(48, 14, 2, 'segitiga biru', 'gram', 25000, 75000, '2023-10-31 03:14:52', 1, NULL, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_produk_bundling`
--

CREATE TABLE `tbl_produk_bundling` (
  `produk_bundling_id` int(11) NOT NULL,
  `produk_diskon_id` int(11) DEFAULT NULL,
  `produk_id` int(11) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT 0 COMMENT '0=No; 1=Yes'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_produk_bundling`
--

INSERT INTO `tbl_produk_bundling` (`produk_bundling_id`, `produk_diskon_id`, `produk_id`, `is_deleted`) VALUES
(1, 1, 27, 1),
(2, 1, 39, 1),
(3, 3, 19, 0),
(4, 3, 24, 0),
(5, 1, 27, 0),
(6, 1, 39, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_produk_diskon`
--

CREATE TABLE `tbl_produk_diskon` (
  `produk_diskon_id` int(11) NOT NULL,
  `produk_id` int(11) DEFAULT NULL,
  `tipe_diskon` varchar(15) DEFAULT NULL,
  `nominal` int(11) DEFAULT NULL,
  `tipe_nominal` varchar(10) NOT NULL,
  `start_diskon` date DEFAULT NULL,
  `end_diskon` date DEFAULT NULL,
  `tgl_dibuat` datetime DEFAULT NULL,
  `dibuat_oleh` int(11) DEFAULT NULL,
  `tgl_diupdate` datetime DEFAULT NULL,
  `diupdate_oleh` int(11) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT 0 COMMENT '0=No; 1=Yes'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_produk_diskon`
--

INSERT INTO `tbl_produk_diskon` (`produk_diskon_id`, `produk_id`, `tipe_diskon`, `nominal`, `tipe_nominal`, `start_diskon`, `end_diskon`, `tgl_dibuat`, `dibuat_oleh`, `tgl_diupdate`, `diupdate_oleh`, `is_deleted`) VALUES
(1, 32, 'tebus murah', 5, 'persen', '2023-10-23', '2023-10-25', '2023-10-24 02:29:08', 1, '2023-10-26 05:14:17', 1, 0),
(2, 34, 'diskon langsung', 10, 'persen', '2023-10-20', '2023-12-31', '2023-10-24 02:30:34', 1, NULL, 0, 0),
(3, 32, 'bundling', 5, 'persen', '2023-10-24', '2023-12-31', '2023-10-24 02:31:31', 1, NULL, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_produk_harga`
--

CREATE TABLE `tbl_produk_harga` (
  `produk_harga_id` int(11) NOT NULL,
  `produk_id` int(11) DEFAULT NULL,
  `satuan` varchar(255) DEFAULT NULL,
  `netto` int(11) DEFAULT NULL,
  `harga_beli` int(11) DEFAULT NULL,
  `harga_jual` int(11) DEFAULT NULL,
  `tgl_dibuat` datetime DEFAULT NULL,
  `dibuat_oleh` int(11) DEFAULT NULL,
  `tgl_diupdate` datetime DEFAULT NULL,
  `diupdate_oleh` int(11) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT 0 COMMENT '0=No; 1=Yes'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_produk_harga`
--

INSERT INTO `tbl_produk_harga` (`produk_harga_id`, `produk_id`, `satuan`, `netto`, `harga_beli`, `harga_jual`, `tgl_dibuat`, `dibuat_oleh`, `tgl_diupdate`, `diupdate_oleh`, `is_deleted`) VALUES
(1, 8, 'dos', 15000, 300000, 310000, '2023-08-27 03:57:06', 1, NULL, 0, 1),
(2, 8, 'gram', 1000, 20000, 22000, '2023-08-27 03:57:06', 1, NULL, 0, 1),
(3, 8, 'gram', 500, 10000, 11000, '2023-08-27 03:57:06', 1, NULL, 0, 1),
(4, 8, 'gram', 250, 5000, 6000, '2023-08-27 03:57:06', 1, NULL, 0, 1),
(5, 9, 'dos', 240, 900000, 950000, '2023-08-27 04:00:02', 1, NULL, 0, 0),
(6, 9, 'slop', 40, 150000, 170000, '2023-08-27 04:00:02', 1, NULL, 0, 0),
(7, 9, 'box', 4, 15000, 18000, '2023-08-27 04:00:02', 1, NULL, 0, 0),
(8, 9, 'pcs', 1, 3750, 5000, '2023-08-27 04:00:02', 1, NULL, 0, 0),
(9, 8, 'dos', 15000, 300000, 310000, '2023-08-27 07:07:00', 1, NULL, 0, 1),
(10, 8, 'gram', 1000, 20000, 22000, '2023-08-27 07:07:00', 1, NULL, 0, 1),
(11, 8, 'gram', 500, 10000, 11000, '2023-08-27 07:07:00', 1, NULL, 0, 1),
(12, 8, 'gram', 250, 5000, 6000, '2023-08-27 07:07:00', 1, NULL, 0, 1),
(13, 10, 'dos', 10000, 117000, 125000, '2023-08-27 07:12:52', 1, NULL, 0, 1),
(14, 10, 'bag', 5000, 58500, 62500, '2023-08-27 07:12:52', 1, NULL, 0, 1),
(15, 10, 'gram', 1000, 11700, 15000, '2023-08-27 07:12:52', 1, NULL, 0, 1),
(16, 10, 'gram', 500, 5850, 7500, '2023-08-27 07:12:52', 1, NULL, 0, 1),
(17, 10, 'gram', 250, 2925, 4000, '2023-08-27 07:12:52', 1, NULL, 0, 1),
(18, 11, 'dos', 12000, 120000, 130000, '2023-08-29 04:29:27', 1, NULL, 0, 0),
(19, 11, 'gram', 1000, 10000, 12000, '2023-08-29 04:29:27', 1, NULL, 0, 0),
(20, 12, 'dos', 12000, 120000, 130000, '2023-08-29 04:32:03', 1, NULL, 0, 0),
(21, 12, 'gram', 1000, 10000, 11500, '2023-08-29 04:32:03', 1, NULL, 0, 0),
(22, 13, 'dos', 12000, 120000, 130000, '2023-08-29 04:33:06', 1, NULL, 0, 1),
(23, 13, 'gram', 1000, 10000, 11500, '2023-08-29 04:33:06', 1, NULL, 0, 1),
(24, 13, 'dos', 12000, 120000, 130000, '2023-08-29 05:50:57', 1, NULL, 0, 0),
(25, 13, 'gram', 1000, 10000, 11500, '2023-08-29 05:50:57', 1, NULL, 0, 0),
(26, 8, 'dos', 15000, 300000, 310000, '2023-08-30 03:30:46', 1, NULL, 0, 0),
(27, 8, 'gram', 1000, 20000, 22000, '2023-08-30 03:30:46', 1, NULL, 0, 0),
(28, 8, 'gram', 500, 10000, 11000, '2023-08-30 03:30:46', 1, NULL, 0, 0),
(29, 8, 'gram', 250, 5000, 6000, '2023-08-30 03:30:46', 1, NULL, 0, 0),
(30, 10, 'dos', 10000, 117000, 125000, '2023-08-30 03:31:09', 1, NULL, 0, 0),
(31, 10, 'bag', 5000, 58500, 62500, '2023-08-30 03:31:09', 1, NULL, 0, 0),
(32, 10, 'gram', 1000, 11700, 15000, '2023-08-30 03:31:09', 1, NULL, 0, 0),
(33, 10, 'gram', 500, 5850, 7500, '2023-08-30 03:31:09', 1, NULL, 0, 0),
(34, 10, 'gram', 250, 2925, 4000, '2023-08-30 03:31:09', 1, NULL, 0, 0),
(35, 14, 'dos', 12500, 265000, 272000, '2023-08-30 03:51:47', 1, NULL, 0, 1),
(36, 14, 'gram', 1000, 21200, 23500, '2023-08-30 03:51:47', 1, NULL, 0, 1),
(37, 14, 'gram', 500, 10600, 12000, '2023-08-30 03:51:47', 1, NULL, 0, 1),
(38, 14, 'gram', 250, 5300, 6000, '2023-08-30 03:51:47', 1, NULL, 0, 1),
(39, 15, 'dos', 12500, 265000, 272000, '2023-08-30 03:55:18', 1, NULL, 0, 0),
(40, 15, 'gram', 1000, 21200, 23500, '2023-08-30 03:55:18', 1, NULL, 0, 0),
(41, 15, 'gram', 500, 10600, 12000, '2023-08-30 03:55:18', 1, NULL, 0, 0),
(42, 15, 'gram', 250, 5300, 6000, '2023-08-30 03:55:18', 1, NULL, 0, 0),
(43, 16, 'dos', 12500, 265000, 272000, '2023-08-30 04:00:34', 1, NULL, 0, 0),
(44, 16, 'gram', 1000, 21200, 23500, '2023-08-30 04:00:34', 1, NULL, 0, 0),
(45, 16, 'gram', 500, 10600, 12000, '2023-08-30 04:00:34', 1, NULL, 0, 0),
(46, 16, 'gram', 250, 5300, 6000, '2023-08-30 04:00:34', 1, NULL, 0, 0),
(47, 17, 'dos', 12500, 265000, 272000, '2023-08-30 04:05:20', 1, NULL, 0, 0),
(48, 17, 'gram', 1000, 21200, 23500, '2023-08-30 04:05:20', 1, NULL, 0, 0),
(49, 17, 'gram', 500, 10600, 12000, '2023-08-30 04:05:20', 1, NULL, 0, 0),
(50, 17, 'gram', 250, 5300, 6000, '2023-08-30 04:05:20', 1, NULL, 0, 0),
(51, 18, 'dos', 12500, 265000, 272000, '2023-08-30 04:08:03', 1, NULL, 0, 0),
(52, 18, 'gram', 1000, 21200, 23500, '2023-08-30 04:08:04', 1, NULL, 0, 0),
(53, 18, 'gram', 500, 10600, 12000, '2023-08-30 04:08:04', 1, NULL, 0, 0),
(54, 18, 'gram', 250, 5300, 6000, '2023-08-30 04:08:04', 1, NULL, 0, 0),
(55, 19, 'dos', 12500, 265000, 272000, '2023-08-30 04:10:45', 1, NULL, 0, 0),
(56, 19, 'gram', 1000, 21200, 23500, '2023-08-30 04:10:45', 1, NULL, 0, 0),
(57, 19, 'gram', 500, 10600, 12000, '2023-08-30 04:10:45', 1, NULL, 0, 0),
(58, 19, 'gram', 250, 5300, 6000, '2023-08-30 04:10:45', 1, NULL, 0, 0),
(59, 20, 'dos', 12500, 265000, 272000, '2023-08-30 04:14:04', 1, NULL, 0, 0),
(60, 20, 'gram', 1000, 21200, 23500, '2023-08-30 04:14:04', 1, NULL, 0, 0),
(61, 20, 'gram', 500, 10600, 12000, '2023-08-30 04:14:04', 1, NULL, 0, 0),
(62, 20, 'gram', 250, 5300, 6000, '2023-08-30 04:14:04', 1, NULL, 0, 0),
(63, 21, 'dos', 12500, 265000, 272000, '2023-08-30 04:16:44', 1, NULL, 0, 0),
(64, 21, 'gram', 1000, 21200, 23500, '2023-08-30 04:16:45', 1, NULL, 0, 0),
(65, 21, 'gram', 500, 10600, 12000, '2023-08-30 04:16:45', 1, NULL, 0, 0),
(66, 21, 'gram', 250, 5300, 6000, '2023-08-30 04:16:45', 1, NULL, 0, 0),
(67, 22, 'dos', 12500, 265000, 272000, '2023-08-30 04:18:57', 1, NULL, 0, 0),
(68, 22, 'gram', 1000, 21200, 23500, '2023-08-30 04:18:57', 1, NULL, 0, 0),
(69, 22, 'gram', 500, 10600, 12000, '2023-08-30 04:18:57', 1, NULL, 0, 0),
(70, 22, 'gram', 250, 5300, 6000, '2023-08-30 04:18:57', 1, NULL, 0, 0),
(71, 23, 'dos', 240, 970000, 990000, '2023-08-30 04:37:36', 1, NULL, 0, 1),
(72, 23, 'slop', 40, 161667, 170000, '2023-08-30 04:37:36', 1, NULL, 0, 1),
(73, 23, 'kotak', 4, 16167, 18000, '2023-08-30 04:37:36', 1, NULL, 0, 1),
(74, 23, 'sch', 1, 4042, 5000, '2023-08-30 04:37:36', 1, NULL, 0, 1),
(75, 14, 'dos', 12500, 265000, 272000, '2023-08-30 04:48:55', 1, NULL, 0, 1),
(76, 14, 'gram', 1000, 21200, 23500, '2023-08-30 04:48:55', 1, NULL, 0, 1),
(77, 14, 'gram', 500, 10600, 12000, '2023-08-30 04:48:55', 1, NULL, 0, 1),
(78, 14, 'gram', 250, 5300, 6000, '2023-08-30 04:48:55', 1, NULL, 0, 1),
(79, 14, 'dos', 12500, 265000, 272000, '2023-09-01 04:57:43', 1, NULL, 0, 0),
(80, 14, 'gram', 1000, 21200, 23500, '2023-09-01 04:57:43', 1, NULL, 0, 0),
(81, 14, 'gram', 500, 10600, 12000, '2023-09-01 04:57:43', 1, NULL, 0, 0),
(82, 14, 'gram', 250, 5300, 6000, '2023-09-01 04:57:43', 1, NULL, 0, 0),
(83, 23, 'dos', 240, 970000, 990000, '2023-09-01 04:58:00', 1, NULL, 0, 0),
(84, 23, 'slop', 40, 161667, 170000, '2023-09-01 04:58:00', 1, NULL, 0, 0),
(85, 23, 'kotak', 4, 16167, 18000, '2023-09-01 04:58:00', 1, NULL, 0, 0),
(86, 23, 'sch', 1, 4042, 5000, '2023-09-01 04:58:00', 1, NULL, 0, 0),
(87, 24, 'dos', 15000, 243917, 253000, '2023-09-01 05:01:19', 1, NULL, 0, 0),
(88, 24, 'gram', 1000, 16261, 18500, '2023-09-01 05:01:19', 1, NULL, 0, 0),
(89, 24, 'gram', 500, 8131, 9500, '2023-09-01 05:01:19', 1, NULL, 0, 0),
(90, 24, 'gram', 250, 4066, 5500, '2023-09-01 05:01:19', 1, NULL, 0, 0),
(91, 25, 'dos', 15000, 270618, 279000, '2023-09-01 06:25:12', 1, NULL, 0, 0),
(92, 25, 'gram', 1000, 18042, 20000, '2023-09-01 06:25:12', 1, NULL, 0, 0),
(93, 25, 'gram', 500, 9021, 10000, '2023-09-01 06:25:12', 1, NULL, 0, 0),
(94, 25, 'gram', 250, 4511, 6000, '2023-09-01 06:25:12', 1, NULL, 0, 0),
(95, 26, 'dos', 15000, 295815, 305000, '2023-09-01 06:28:25', 1, NULL, 0, 0),
(96, 26, 'gram', 1000, 19721, 22000, '2023-09-01 06:28:25', 1, NULL, 0, 0),
(97, 26, 'gram', 500, 9861, 11000, '2023-09-01 06:28:25', 1, NULL, 0, 0),
(98, 26, 'gram', 250, 4931, 6500, '2023-09-01 06:28:25', 1, NULL, 0, 0),
(99, 27, 'dos', 15000, 332667, 345000, '2023-09-01 06:31:02', 1, NULL, 0, 0),
(100, 27, 'gram', 1000, 22178, 26000, '2023-09-01 06:31:02', 1, NULL, 0, 0),
(101, 27, 'gram', 500, 11089, 13000, '2023-09-01 06:31:02', 1, NULL, 0, 0),
(102, 27, 'gram', 250, 5545, 7000, '2023-09-01 06:31:02', 1, NULL, 0, 0),
(103, 28, 'dos', 15000, 311500, 320000, '2023-09-01 06:33:22', 1, NULL, 0, 0),
(104, 28, 'gram', 1000, 20767, 23000, '2023-09-01 06:33:22', 1, NULL, 0, 0),
(105, 28, 'gram', 500, 10384, 11500, '2023-09-01 06:33:22', 1, NULL, 0, 0),
(106, 28, 'gram', 250, 5192, 6500, '2023-09-01 06:33:22', 1, NULL, 0, 0),
(107, 29, 'dos', 15000, 294150, 310000, '2023-09-01 06:35:31', 1, NULL, 0, 0),
(108, 29, 'gram', 1000, 19610, 23000, '2023-09-01 06:35:31', 1, NULL, 0, 0),
(109, 29, 'gram', 500, 9805, 11500, '2023-09-01 06:35:31', 1, NULL, 0, 0),
(110, 29, 'gram', 250, 4903, 6500, '2023-09-01 06:35:31', 1, NULL, 0, 0),
(111, 30, 'dos', 15000, 403596, 420000, '2023-09-01 06:37:22', 1, NULL, 0, 0),
(112, 30, 'gram', 1000, 26907, 31000, '2023-09-01 06:37:22', 1, NULL, 0, 0),
(113, 30, 'gram', 500, 13454, 15500, '2023-09-01 06:37:22', 1, NULL, 0, 0),
(114, 30, 'gram', 250, 6727, 8500, '2023-09-01 06:37:22', 1, NULL, 0, 0),
(115, 31, 'dos', 12500, 368270, 383000, '2023-09-01 06:41:17', 1, NULL, 0, 0),
(116, 31, 'gram', 1000, 29462, 34000, '2023-09-01 06:41:17', 1, NULL, 0, 0),
(117, 31, 'gram', 500, 14731, 17000, '2023-09-01 06:41:17', 1, NULL, 0, 0),
(118, 31, 'gram', 250, 7366, 8500, '2023-09-01 06:41:17', 1, NULL, 0, 0),
(119, 32, 'dos', 12000, 269000, 280000, '2023-09-01 06:45:11', 1, NULL, 0, 1),
(120, 32, 'gram', 1000, 22417, 25000, '2023-09-01 06:45:11', 1, NULL, 0, 1),
(121, 32, 'gram', 500, 11209, 12500, '2023-09-01 06:45:11', 1, NULL, 0, 1),
(122, 32, 'gram', 250, 5605, 7000, '2023-09-01 06:45:11', 1, NULL, 0, 1),
(123, 33, 'dos', 12500, 487000, 505000, '2023-09-01 06:47:27', 1, NULL, 0, 0),
(124, 33, 'gram', 1000, 38960, 44000, '2023-09-01 06:47:27', 1, NULL, 0, 0),
(125, 33, 'gram', 500, 19480, 22000, '2023-09-01 06:47:27', 1, NULL, 0, 0),
(126, 33, 'gram', 250, 9740, 11500, '2023-09-01 06:47:27', 1, NULL, 0, 0),
(127, 34, 'dos', 12500, 480000, 495000, '2023-09-01 06:49:30', 1, NULL, 0, 0),
(128, 34, 'gram', 1000, 38400, 44000, '2023-09-01 06:49:30', 1, NULL, 0, 0),
(129, 34, 'gram', 500, 19200, 22000, '2023-09-01 06:49:30', 1, NULL, 0, 0),
(130, 34, 'gram', 250, 9600, 11500, '2023-09-01 06:49:30', 1, NULL, 0, 0),
(131, 35, 'dos', 12500, 437325, 450000, '2023-09-01 06:51:53', 1, NULL, 0, 0),
(132, 35, 'gram', 1000, 34986, 39000, '2023-09-01 06:51:53', 1, NULL, 0, 0),
(133, 35, 'gram', 500, 17493, 19500, '2023-09-01 06:51:53', 1, NULL, 0, 0),
(134, 35, 'gram', 250, 8747, 10000, '2023-09-01 06:51:53', 1, NULL, 0, 0),
(135, 36, 'dos', 12500, 480249, 495000, '2023-09-01 06:54:24', 1, NULL, 0, 0),
(136, 36, 'gram', 1000, 38420, 43000, '2023-09-01 06:54:24', 1, NULL, 0, 0),
(137, 36, 'gram', 500, 19210, 21500, '2023-09-01 06:54:24', 1, NULL, 0, 0),
(138, 36, 'gram', 250, 9605, 11000, '2023-09-01 06:54:24', 1, NULL, 0, 0),
(139, 37, 'dos', 12500, 100000, 120000, '2023-09-01 06:56:32', 1, NULL, 0, 0),
(140, 37, 'gram', 1000, 38024, 46000, '2023-09-01 06:56:32', 1, NULL, 0, 0),
(141, 37, 'gram', 500, 19012, 23000, '2023-09-01 06:56:32', 1, NULL, 0, 0),
(142, 37, 'gram', 250, 9506, 12000, '2023-09-01 06:56:32', 1, NULL, 0, 0),
(143, 38, 'dos', 15000, 432858, 450000, '2023-09-01 07:00:02', 1, NULL, 0, 0),
(144, 38, 'gram', 1000, 28858, 35000, '2023-09-01 07:00:02', 1, NULL, 0, 0),
(145, 38, 'gram', 500, 14429, 17500, '2023-09-01 07:00:02', 1, NULL, 0, 0),
(146, 38, 'gram', 250, 7215, 9500, '2023-09-01 07:00:02', 1, NULL, 0, 0),
(147, 38, 'gram', 100, 2886, 4000, '2023-09-01 07:00:02', 1, NULL, 0, 0),
(148, 39, 'pcs', 1, 96507, 110000, '2023-09-10 02:46:42', 1, NULL, 0, 0),
(149, 39, 'dos', 12, 1158084, 1220000, '2023-09-10 02:46:42', 1, NULL, 0, 0),
(150, 32, 'dos', 12000, 269000, 280000, '2023-09-10 03:53:38', 1, NULL, 0, 1),
(151, 32, 'gram', 1000, 22417, 25000, '2023-09-10 03:53:38', 1, NULL, 0, 1),
(152, 32, 'gram', 500, 11209, 12500, '2023-09-10 03:53:38', 1, NULL, 0, 1),
(153, 32, 'gram', 250, 5605, 7000, '2023-09-10 03:53:38', 1, NULL, 0, 1),
(154, 32, 'dos', 12000, 269000, 280000, '2023-09-13 02:45:59', 1, NULL, 0, 0),
(155, 32, 'gram', 1000, 22417, 25000, '2023-09-13 02:45:59', 1, NULL, 0, 0),
(156, 32, 'gram', 500, 11209, 12500, '2023-09-13 02:45:59', 1, NULL, 0, 0),
(157, 32, 'gram', 250, 5605, 7000, '2023-09-13 02:45:59', 1, NULL, 0, 0),
(158, 40, 'pcs', 1, 12323, 13500, '2023-09-13 02:54:09', 1, NULL, 0, 1),
(159, 40, 'pcs', 1, 12323, 13500, '2023-09-13 02:56:38', 1, NULL, 0, 1),
(160, 40, 'dos', 12, 147875, 155000, '2023-09-13 02:56:38', 1, NULL, 0, 1),
(161, 40, 'pcs', 1, 12323, 13500, '2023-09-13 02:57:47', 1, NULL, 0, 0),
(162, 40, 'dos', 12, 147875, 155000, '2023-09-13 02:57:47', 1, NULL, 0, 0),
(163, 41, 'pail', 15000, 983460, 1015000, '2023-10-31 02:46:12', 1, NULL, 0, 0),
(164, 41, 'gram', 1000, 65564, 75000, '2023-10-31 02:46:12', 1, NULL, 0, 0),
(165, 41, 'gram', 500, 32782, 37500, '2023-10-31 02:46:12', 1, NULL, 0, 0),
(166, 41, 'gram', 250, 16391, 19000, '2023-10-31 02:46:12', 1, NULL, 0, 0),
(167, 41, 'gram', 100, 6557, 8000, '2023-10-31 02:46:12', 1, NULL, 0, 0),
(168, 42, 'gram', 250, 6125, 7500, '2023-10-31 02:48:21', 1, NULL, 0, 0),
(169, 42, 'gram', 500, 12250, 14500, '2023-10-31 02:48:21', 1, NULL, 0, 0),
(170, 42, 'gram', 1000, 24500, 29000, '2023-10-31 02:48:21', 1, NULL, 0, 0),
(171, 42, 'sak', 25000, 612500, 650000, '2023-10-31 02:48:21', 1, NULL, 0, 0),
(172, 43, 'gram', 100, 3400, 5000, '2023-10-31 02:52:05', 1, NULL, 0, 0),
(173, 43, 'gram', 250, 8500, 10500, '2023-10-31 02:52:05', 1, NULL, 0, 0),
(174, 43, 'gram', 500, 17000, 20500, '2023-10-31 02:52:05', 1, NULL, 0, 0),
(175, 43, 'gram', 1000, 34000, 41000, '2023-10-31 02:52:05', 1, NULL, 0, 0),
(176, 43, 'sak', 25000, 850000, 890000, '2023-10-31 02:52:05', 1, NULL, 0, 0),
(177, 44, 'pcs', 1, 88325, 93000, '2023-10-31 02:58:04', 1, NULL, 0, 0),
(178, 44, 'dos', 8, 706600, 725000, '2023-10-31 02:58:04', 1, NULL, 0, 0),
(179, 45, 'pcs', 1, 10209, 11500, '2023-10-31 03:01:13', 1, NULL, 0, 0),
(180, 45, 'dos', 48, 490000, 515000, '2023-10-31 03:01:13', 1, NULL, 0, 0),
(181, 46, 'gram', 250, 6752, 8500, '2023-10-31 03:08:43', 1, NULL, 0, 0),
(182, 46, 'gram', 500, 13500, 16000, '2023-10-31 03:08:43', 1, NULL, 0, 0),
(183, 46, 'gram', 1000, 27000, 31500, '2023-10-31 03:08:43', 1, NULL, 0, 0),
(184, 46, 'dos', 15000, 405000, 445000, '2023-10-31 03:08:43', 1, NULL, 0, 0),
(185, 47, 'gram', 500, 4560, 5500, '2023-10-31 03:12:16', 1, NULL, 0, 1),
(186, 47, 'gram', 1000, 9120, 10500, '2023-10-31 03:12:16', 1, NULL, 0, 1),
(187, 47, 'sak', 25000, 228000, 232000, '2023-10-31 03:12:16', 1, NULL, 0, 1),
(188, 48, 'gram', 500, 4440, 5500, '2023-10-31 03:14:52', 1, NULL, 0, 0),
(189, 48, 'gram', 1000, 8880, 10000, '2023-10-31 03:14:52', 1, NULL, 0, 0),
(190, 48, 'sak', 25000, 222000, 225000, '2023-10-31 03:14:52', 1, NULL, 0, 0),
(191, 47, 'gram', 500, 4560, 5500, '2023-10-31 04:17:50', 1, NULL, 0, 0),
(192, 47, 'gram', 1000, 9120, 10500, '2023-10-31 04:17:50', 1, NULL, 0, 0),
(193, 47, 'sak', 25000, 228000, 232000, '2023-10-31 04:17:50', 1, NULL, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_produk_stok`
--

CREATE TABLE `tbl_produk_stok` (
  `stok_id` int(11) NOT NULL,
  `produk_id` int(11) DEFAULT NULL,
  `tgl_kadaluarsa` date DEFAULT NULL,
  `stok` int(11) DEFAULT NULL,
  `tgl_dibuat` datetime DEFAULT NULL,
  `dibuat_oleh` int(11) DEFAULT NULL,
  `tgl_diupdate` datetime DEFAULT NULL,
  `diupdate_oleh` int(11) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT 0 COMMENT '0=No; 1=Yes'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_produk_stok`
--

INSERT INTO `tbl_produk_stok` (`stok_id`, `produk_id`, `tgl_kadaluarsa`, `stok`, `tgl_dibuat`, `dibuat_oleh`, `tgl_diupdate`, `diupdate_oleh`, `is_deleted`) VALUES
(3, 9, '2023-09-09', 2380, '2023-08-27 04:00:02', 1, NULL, 0, 0),
(6, 8, '2023-08-31', 375000, '2023-08-27 07:07:00', 1, NULL, 0, 1),
(7, 8, '2023-09-30', 750000, '2023-08-27 07:07:00', 1, NULL, 0, 1),
(8, 10, '2023-09-30', 100000, '2023-08-27 07:12:52', 1, NULL, 0, 1),
(9, 10, '2023-10-31', 200000, '2023-08-27 07:12:52', 1, NULL, 0, 1),
(10, 11, '2023-08-31', 120000, '2023-08-29 04:29:27', 1, NULL, 0, 0),
(11, 12, '2023-08-31', 120000, '2023-08-29 04:32:03', 1, NULL, 0, 0),
(12, 13, '2023-08-31', 60000, '2023-08-29 04:33:06', 1, NULL, 0, 1),
(13, 13, '2023-08-31', 60000, '2023-08-29 05:50:57', 1, NULL, 0, 0),
(14, 8, '2023-08-31', 375000, '2023-08-30 03:30:46', 1, NULL, 0, 0),
(15, 8, '2023-09-30', 750000, '2023-08-30 03:30:46', 1, NULL, 0, 0),
(16, 10, '2023-09-30', 100000, '2023-08-30 03:31:09', 1, NULL, 0, 0),
(17, 10, '2023-10-31', 200000, '2023-08-30 03:31:09', 1, NULL, 0, 0),
(18, 14, '2024-08-30', 249750, '2023-08-30 03:51:47', 1, NULL, 0, 1),
(19, 15, '2024-08-30', 250000, '2023-08-30 03:55:18', 1, NULL, 0, 0),
(20, 16, '2024-08-30', 250000, '2023-08-30 04:00:34', 1, NULL, 0, 0),
(21, 17, '2024-08-30', 250000, '2023-08-30 04:05:20', 1, NULL, 0, 0),
(22, 18, '2024-08-30', 250000, '2023-08-30 04:08:03', 1, NULL, 0, 0),
(23, 19, '2024-08-30', 250000, '2023-08-30 04:10:45', 1, NULL, 0, 0),
(24, 20, '2024-08-30', 250000, '2023-08-30 04:14:04', 1, NULL, 0, 0),
(25, 21, '2024-08-30', 250000, '2023-08-30 04:16:44', 1, NULL, 0, 0),
(26, 22, '2024-08-30', 250000, '2023-08-30 04:18:57', 1, NULL, 0, 0),
(27, 23, '2024-03-30', 2120, '2023-08-30 04:37:36', 1, NULL, 0, 1),
(28, 14, '2024-08-30', 249750, '2023-08-30 04:48:55', 1, NULL, 0, 1),
(29, 14, '2024-11-30', 125000, '2023-08-30 04:48:55', 1, NULL, 0, 1),
(30, 14, '2024-08-30', 250000, '2023-09-01 04:57:43', 1, NULL, 0, 0),
(31, 23, '2024-03-30', 2120, '2023-09-01 04:58:00', 1, NULL, 0, 0),
(32, 24, '2024-09-01', 300000, '2023-09-01 05:01:19', 1, NULL, 0, 0),
(33, 25, '2024-09-01', 300000, '2023-09-01 06:25:12', 1, NULL, 0, 0),
(34, 26, '2024-09-01', 300000, '2023-09-01 06:28:25', 1, NULL, 0, 0),
(35, 27, '2024-09-01', 300000, '2023-09-01 06:31:02', 1, NULL, 0, 0),
(36, 28, '2024-09-01', 300000, '2023-09-01 06:33:22', 1, NULL, 0, 0),
(37, 29, '2024-09-01', 300000, '2023-09-01 06:35:31', 1, NULL, 0, 0),
(38, 30, '2024-09-01', 300000, '2023-09-01 06:37:22', 1, NULL, 0, 0),
(39, 31, '2024-09-01', 250000, '2023-09-01 06:41:17', 1, NULL, 0, 0),
(40, 32, '2024-09-01', 24000, '2023-09-01 06:45:11', 1, NULL, 0, 1),
(41, 33, '2024-09-01', 250000, '2023-09-01 06:47:27', 1, NULL, 0, 0),
(42, 34, '2024-09-01', 250000, '2023-09-01 06:49:30', 1, NULL, 0, 0),
(43, 35, '2024-09-01', 250000, '2023-09-01 06:51:53', 1, NULL, 0, 0),
(44, 36, '2024-09-01', 250000, '2023-09-01 06:54:24', 1, NULL, 0, 0),
(45, 37, '2024-09-01', 250000, '2023-09-01 06:56:32', 1, NULL, 0, 0),
(46, 38, '2024-09-01', 300000, '2023-09-01 07:00:02', 1, NULL, 0, 0),
(47, 39, '2023-12-20', 4, '2023-09-10 02:46:42', 1, NULL, 0, 0),
(48, 32, '2024-09-01', 24000, '2023-09-10 03:53:38', 1, NULL, 0, 1),
(49, 32, '2024-12-30', 120000, '2023-09-10 03:53:38', 1, NULL, 0, 1),
(50, 32, '2024-09-01', 24000, '2023-09-13 02:45:59', 1, NULL, 0, 0),
(51, 32, '2024-12-30', 120000, '2023-09-13 02:45:59', 1, NULL, 0, 0),
(52, 40, '2024-08-30', 120, '2023-09-13 02:54:09', 1, NULL, 0, 1),
(53, 40, '2024-08-30', 120, '2023-09-13 02:56:38', 1, NULL, 0, 1),
(54, 40, '2024-08-30', 120, '2023-09-13 02:57:47', 1, NULL, 0, 0),
(55, 41, '2024-06-20', 90000, '2023-10-31 02:46:12', 1, NULL, 0, 0),
(56, 42, '2025-01-23', 500000, '2023-10-31 02:48:21', 1, NULL, 0, 0),
(57, 43, '2025-07-24', 125000, '2023-10-31 02:52:05', 1, NULL, 0, 0),
(58, 44, '2024-09-20', 72, '2023-10-31 02:58:04', 1, NULL, 0, 0),
(59, 45, '2024-08-14', 720, '2023-10-31 03:01:13', 1, NULL, 0, 0),
(60, 46, '2024-05-29', 750000, '2023-10-31 03:08:43', 1, NULL, 0, 0),
(61, 47, '2024-04-17', 625000000, '2023-10-31 03:12:16', 1, NULL, 0, 1),
(62, 48, '2024-05-29', 250000, '2023-10-31 03:14:52', 1, NULL, 0, 0),
(63, 47, '2024-04-17', 625000, '2023-10-31 04:17:50', 1, NULL, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_related_produk`
--

CREATE TABLE `tbl_related_produk` (
  `related_produk_id` int(11) NOT NULL,
  `produk_parent_id` int(11) DEFAULT NULL,
  `produk_child_id` int(11) DEFAULT NULL,
  `tgl_dibuat` datetime DEFAULT NULL,
  `dibuat_oleh` int(11) DEFAULT NULL,
  `tgl_diupdate` datetime DEFAULT NULL,
  `diupdate_oleh` int(11) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT 0 COMMENT '0=No; 1=Yes'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_related_produk`
--

INSERT INTO `tbl_related_produk` (`related_produk_id`, `produk_parent_id`, `produk_child_id`, `tgl_dibuat`, `dibuat_oleh`, `tgl_diupdate`, `diupdate_oleh`, `is_deleted`) VALUES
(1, 13, 11, NULL, NULL, NULL, NULL, 1),
(2, 13, 12, NULL, NULL, NULL, NULL, 1),
(3, 13, 11, '2023-08-29 05:50:57', 1, NULL, 0, 0),
(4, 33, 34, '2023-09-10 06:00:05', 1, NULL, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_supplier`
--

CREATE TABLE `tbl_supplier` (
  `supplier_id` int(11) NOT NULL,
  `nama_supplier` varchar(255) DEFAULT NULL,
  `nama_sales` varchar(255) DEFAULT NULL,
  `alamat` varchar(255) DEFAULT NULL,
  `no_telp` varchar(15) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `tempo_pembayaran` int(11) NOT NULL DEFAULT 0,
  `tgl_dibuat` datetime DEFAULT NULL,
  `dibuat_oleh` int(11) DEFAULT NULL,
  `tgl_diupdate` datetime DEFAULT NULL,
  `diupdate_oleh` int(11) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT 0 COMMENT '0=No; 1=Yes'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_supplier`
--

INSERT INTO `tbl_supplier` (`supplier_id`, `nama_supplier`, `nama_sales`, `alamat`, `no_telp`, `email`, `tempo_pembayaran`, `tgl_dibuat`, `dibuat_oleh`, `tgl_diupdate`, `diupdate_oleh`, `is_deleted`) VALUES
(1, 'CV. Karunia Tiga Putra', 'Burhan', 'Surabaya', '000000000000', 'burhan@gmail.com', 30, '2023-08-17 05:36:43', 1, '2023-10-29 03:05:56', 1, 0),
(2, 'Unggul Bakti', 'Budi', 'Lamongan', '085732314054', 'budi@gmail.com', 0, '2023-08-17 05:37:57', 1, NULL, 0, 1),
(3, 'PT. Erico Indonesia', 'Yunan', 'Surabaya', '000000000000', 'yunan@gmail.com', 0, '2023-08-17 05:39:38', 1, '2023-08-30 03:19:24', 1, 0),
(4, 'CV. Citra Agri', 'Rudy', 'Surabaya', '000000000000', 'rudy@gmail.com', 0, '2023-08-17 05:45:54', 1, '2023-08-30 03:19:49', 1, 0),
(5, 'PT. Wira Sadana Lestari', 'Ita', 'Surabaya', '000000000000', 'ita@gmail.com', 0, '2023-08-17 05:49:21', 1, '2023-08-30 03:20:24', 1, 0),
(6, 'CV. Kendari', 'Edy Sujarwo', 'Surabaya', '000000000000', 'edy@gmail.com', 0, '2023-08-23 07:26:43', 1, '2023-08-30 03:21:55', 1, 0),
(7, 'PT. Aries Centaurus', 'Harto', 'Surabaya', '000000000000', 'harto@gmail.com', 0, '2023-08-27 03:55:46', 1, '2023-08-30 03:21:24', 1, 0),
(8, 'Indomarco', 'Wawan', 'Tuban', '000000000000', 'indomarco@gmail.com', 0, '2023-08-29 04:28:27', 1, '2023-08-30 03:21:41', 1, 0),
(9, 'UD. Kartika', 'Fauzi', 'Bojonegoro', '000000000000', 'kartika@gmail..com', 0, '2023-08-29 04:30:38', 1, '2023-08-30 03:22:26', 1, 0),
(10, 'Pabean', 'Along', 'Surabaya', '000000000000', 'along@gmail.com', 0, '2023-08-30 03:31:57', 1, NULL, 0, 0),
(11, 'Podo Seneng', 'Hendra', 'Surabaya', '000000000000', 'hendra@gmail.com', 0, '2023-09-01 07:02:40', 1, NULL, 0, 0),
(12, 'UD. Sari', 'Acun', 'Surabaya', '000000000000', 'acun@gmail.com', 0, '2023-09-01 07:04:56', 1, NULL, 0, 0),
(13, 'Mulia Raya', 'Angga', 'Surabaya', '0989789678', 'muliaraya@email.com', 0, '2023-09-10 02:41:26', 1, NULL, 0, 0),
(14, 'slamet jaya', 'budi', 'tuban', '000000000000', 'budi@gmail.com', 0, '2023-10-31 02:25:44', 1, NULL, 0, 0),
(15, 'cv. tiga berlian', 'lastri', 'jombang', '0000000', 'tigaberlian@gmail.com', 5, '2023-10-31 03:00:07', 1, NULL, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user`
--

CREATE TABLE `tbl_user` (
  `user_id` int(11) NOT NULL,
  `no_telp` varchar(15) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `nama` varchar(255) DEFAULT NULL,
  `jabatan` varchar(20) DEFAULT NULL,
  `is_superadmin` int(1) DEFAULT 0,
  `tgl_dibuat` datetime DEFAULT NULL,
  `dibuat_oleh` int(11) DEFAULT NULL,
  `tgl_diupdate` datetime DEFAULT NULL,
  `diupdate_oleh` int(11) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT 0 COMMENT '0=No; 1=Yes'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_user`
--

INSERT INTO `tbl_user` (`user_id`, `no_telp`, `password`, `nama`, `jabatan`, `is_superadmin`, `tgl_dibuat`, `dibuat_oleh`, `tgl_diupdate`, `diupdate_oleh`, `is_deleted`) VALUES
(1, '081234567891', 'PPZJ46MYyKQ=', 'Super Admin', 'admin', 1, '2023-08-17 05:08:20', 0, '2023-08-24 05:57:48', 1, 0),
(2, '082123456789', 'PPZJ46MYyKSE', 'Kasir Umum', 'kasir', 0, '2023-08-17 05:13:14', 1, NULL, 0, 0),
(3, '081122334455', 'PPZJ46MYyKSE', 'Kasir 1', 'kasir', 0, '2023-08-17 05:17:14', 1, NULL, 0, 1),
(4, '081234567890', 'PPZJ46MYyKSE', 'Admin', 'admin', 0, '2023-08-17 05:27:38', 1, NULL, 0, 1),
(5, '081112223334', 'PPZJ46MYyKSE', 'Kasir 2', 'kasir', 0, '2023-08-17 05:30:25', 1, NULL, 0, 1),
(6, '081358118511', 'PPZJ46MYyKQ=', 'Kasir Bella', 'kasir', 0, '2023-08-29 03:07:14', 1, '2023-08-29 03:39:56', 1, 1),
(7, '0987235474', 'PPZJ46MYyKQ=', 'Admin 1', 'admin', 0, '2023-09-13 03:40:16', 1, NULL, 0, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_kategori`
--
ALTER TABLE `tbl_kategori`
  ADD PRIMARY KEY (`kategori_id`);

--
-- Indexes for table `tbl_pembelian`
--
ALTER TABLE `tbl_pembelian`
  ADD PRIMARY KEY (`pembelian_id`),
  ADD KEY `supplier_id` (`supplier_id`);

--
-- Indexes for table `tbl_pembelian_detail`
--
ALTER TABLE `tbl_pembelian_detail`
  ADD PRIMARY KEY (`pembelian_detail_id`),
  ADD KEY `pembelian_id` (`pembelian_id`),
  ADD KEY `produk_id` (`produk_id`);

--
-- Indexes for table `tbl_penjualan`
--
ALTER TABLE `tbl_penjualan`
  ADD PRIMARY KEY (`penjualan_id`);

--
-- Indexes for table `tbl_penjualan_detail`
--
ALTER TABLE `tbl_penjualan_detail`
  ADD PRIMARY KEY (`penjualan_detail_id`),
  ADD KEY `penjualan_id` (`penjualan_id`),
  ADD KEY `produk_id` (`produk_id`),
  ADD KEY `produk_harga_id` (`produk_harga_id`);

--
-- Indexes for table `tbl_produk`
--
ALTER TABLE `tbl_produk`
  ADD PRIMARY KEY (`produk_id`),
  ADD KEY `supplier_id` (`supplier_id`),
  ADD KEY `kategori_id` (`kategori_id`);

--
-- Indexes for table `tbl_produk_bundling`
--
ALTER TABLE `tbl_produk_bundling`
  ADD PRIMARY KEY (`produk_bundling_id`),
  ADD KEY `produk_diskon_id` (`produk_diskon_id`),
  ADD KEY `produk_id` (`produk_id`);

--
-- Indexes for table `tbl_produk_diskon`
--
ALTER TABLE `tbl_produk_diskon`
  ADD PRIMARY KEY (`produk_diskon_id`),
  ADD KEY `produk_id` (`produk_id`);

--
-- Indexes for table `tbl_produk_harga`
--
ALTER TABLE `tbl_produk_harga`
  ADD PRIMARY KEY (`produk_harga_id`),
  ADD KEY `produk_id` (`produk_id`);

--
-- Indexes for table `tbl_produk_stok`
--
ALTER TABLE `tbl_produk_stok`
  ADD PRIMARY KEY (`stok_id`),
  ADD KEY `produk_id` (`produk_id`);

--
-- Indexes for table `tbl_related_produk`
--
ALTER TABLE `tbl_related_produk`
  ADD PRIMARY KEY (`related_produk_id`),
  ADD KEY `produk_parent_id` (`produk_parent_id`),
  ADD KEY `produk_child_id` (`produk_child_id`);

--
-- Indexes for table `tbl_supplier`
--
ALTER TABLE `tbl_supplier`
  ADD PRIMARY KEY (`supplier_id`);

--
-- Indexes for table `tbl_user`
--
ALTER TABLE `tbl_user`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_kategori`
--
ALTER TABLE `tbl_kategori`
  MODIFY `kategori_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `tbl_pembelian`
--
ALTER TABLE `tbl_pembelian`
  MODIFY `pembelian_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tbl_pembelian_detail`
--
ALTER TABLE `tbl_pembelian_detail`
  MODIFY `pembelian_detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tbl_penjualan`
--
ALTER TABLE `tbl_penjualan`
  MODIFY `penjualan_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tbl_penjualan_detail`
--
ALTER TABLE `tbl_penjualan_detail`
  MODIFY `penjualan_detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `tbl_produk`
--
ALTER TABLE `tbl_produk`
  MODIFY `produk_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `tbl_produk_bundling`
--
ALTER TABLE `tbl_produk_bundling`
  MODIFY `produk_bundling_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tbl_produk_diskon`
--
ALTER TABLE `tbl_produk_diskon`
  MODIFY `produk_diskon_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tbl_produk_harga`
--
ALTER TABLE `tbl_produk_harga`
  MODIFY `produk_harga_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=194;

--
-- AUTO_INCREMENT for table `tbl_produk_stok`
--
ALTER TABLE `tbl_produk_stok`
  MODIFY `stok_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT for table `tbl_related_produk`
--
ALTER TABLE `tbl_related_produk`
  MODIFY `related_produk_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_supplier`
--
ALTER TABLE `tbl_supplier`
  MODIFY `supplier_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `tbl_user`
--
ALTER TABLE `tbl_user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_pembelian`
--
ALTER TABLE `tbl_pembelian`
  ADD CONSTRAINT `tbl_pembelian_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `tbl_supplier` (`supplier_id`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_pembelian_detail`
--
ALTER TABLE `tbl_pembelian_detail`
  ADD CONSTRAINT `tbl_pembelian_detail_ibfk_1` FOREIGN KEY (`pembelian_id`) REFERENCES `tbl_pembelian` (`pembelian_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tbl_pembelian_detail_ibfk_2` FOREIGN KEY (`produk_id`) REFERENCES `tbl_produk` (`produk_id`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_penjualan_detail`
--
ALTER TABLE `tbl_penjualan_detail`
  ADD CONSTRAINT `tbl_penjualan_detail_ibfk_1` FOREIGN KEY (`penjualan_id`) REFERENCES `tbl_penjualan` (`penjualan_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tbl_penjualan_detail_ibfk_2` FOREIGN KEY (`produk_id`) REFERENCES `tbl_produk` (`produk_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tbl_penjualan_detail_ibfk_3` FOREIGN KEY (`produk_harga_id`) REFERENCES `tbl_produk_harga` (`produk_harga_id`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_produk`
--
ALTER TABLE `tbl_produk`
  ADD CONSTRAINT `tbl_produk_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `tbl_supplier` (`supplier_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tbl_produk_ibfk_2` FOREIGN KEY (`kategori_id`) REFERENCES `tbl_kategori` (`kategori_id`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_produk_bundling`
--
ALTER TABLE `tbl_produk_bundling`
  ADD CONSTRAINT `tbl_produk_bundling_ibfk_1` FOREIGN KEY (`produk_diskon_id`) REFERENCES `tbl_produk_diskon` (`produk_diskon_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tbl_produk_bundling_ibfk_2` FOREIGN KEY (`produk_id`) REFERENCES `tbl_produk` (`produk_id`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_produk_diskon`
--
ALTER TABLE `tbl_produk_diskon`
  ADD CONSTRAINT `tbl_produk_diskon_ibfk_1` FOREIGN KEY (`produk_id`) REFERENCES `tbl_produk` (`produk_id`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_produk_harga`
--
ALTER TABLE `tbl_produk_harga`
  ADD CONSTRAINT `tbl_produk_harga_ibfk_1` FOREIGN KEY (`produk_id`) REFERENCES `tbl_produk` (`produk_id`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_produk_stok`
--
ALTER TABLE `tbl_produk_stok`
  ADD CONSTRAINT `tbl_produk_stok_ibfk_1` FOREIGN KEY (`produk_id`) REFERENCES `tbl_produk` (`produk_id`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_related_produk`
--
ALTER TABLE `tbl_related_produk`
  ADD CONSTRAINT `tbl_related_produk_ibfk_1` FOREIGN KEY (`produk_parent_id`) REFERENCES `tbl_produk` (`produk_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tbl_related_produk_ibfk_2` FOREIGN KEY (`produk_child_id`) REFERENCES `tbl_produk` (`produk_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
