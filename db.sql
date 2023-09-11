CREATE TABLE IF NOT EXISTS `tbl_user` (
	`user_id` INT(11) NOT NULL AUTO_INCREMENT,
	`no_telp` VARCHAR(15),
	`password` VARCHAR(255),
	`nama` VARCHAR(255),
	`jabatan` VARCHAR(20),
	`tgl_dibuat` DATETIME DEFAULT NULL,
	`dibuat_oleh` INT(11) DEFAULT NULL,
	`tgl_diupdate` DATETIME DEFAULT NULL,
	`diupdate_oleh` INT(11) DEFAULT NULL,
	`is_deleted` TINYINT(1) DEFAULT 0 COMMENT '0=No; 1=Yes',
	PRIMARY KEY (`user_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `tbl_supplier` (
	`supplier_id` INT(11) NOT NULL AUTO_INCREMENT,
	`nama_supplier` VARCHAR(255),
	`nama_sales` VARCHAR(255),
	`alamat` VARCHAR(255),
	`no_telp` VARCHAR(15),
	`email` VARCHAR(255),
	`tgl_dibuat` DATETIME DEFAULT NULL,
	`dibuat_oleh` INT(11) DEFAULT NULL,
	`tgl_diupdate` DATETIME DEFAULT NULL,
	`diupdate_oleh` INT(11) DEFAULT NULL,
	`is_deleted` TINYINT(1) DEFAULT 0 COMMENT '0=No; 1=Yes',
	PRIMARY KEY (`supplier_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `tbl_kategori` (
	`kategori_id` INT(11) NOT NULL AUTO_INCREMENT,
	`nama` VARCHAR(255),
	`tgl_dibuat` DATETIME DEFAULT NULL,
	`dibuat_oleh` INT(11) DEFAULT NULL,
	`tgl_diupdate` DATETIME DEFAULT NULL,
	`diupdate_oleh` INT(11) DEFAULT NULL,
	`is_deleted` TINYINT(1) DEFAULT 0 COMMENT '0=No; 1=Yes',
	PRIMARY KEY (`kategori_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `tbl_produk` (
	`produk_id` INT(11) NOT NULL AUTO_INCREMENT,
	`supplier_id` INT(11),
	`kategori_id` INT(11),
	`nama_produk` VARCHAR(255),
	`satuan_terkecil` VARCHAR(255),
	`netto` INT(11),
	`tgl_dibuat` DATETIME DEFAULT NULL,
	`dibuat_oleh` INT(11) DEFAULT NULL,
	`tgl_diupdate` DATETIME DEFAULT NULL,
	`diupdate_oleh` INT(11) DEFAULT NULL,
	`is_deleted` TINYINT(1) DEFAULT 0 COMMENT '0=No; 1=Yes',
	PRIMARY KEY (`produk_id`),
	FOREIGN KEY(`supplier_id`) REFERENCES `tbl_supplier` (`supplier_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
	FOREIGN KEY(`kategori_id`) REFERENCES `tbl_kategori` (`kategori_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `tbl_stok` (
	`stok_id` INT(11) NOT NULL AUTO_INCREMENT,
	`produk_id` INT(11),
	`tgl_kadaluarsa` DATETIME,
	`stok` INT(11),
	`tgl_dibuat` DATETIME DEFAULT NULL,
	`dibuat_oleh` INT(11) DEFAULT NULL,
	`tgl_diupdate` DATETIME DEFAULT NULL,
	`diupdate_oleh` INT(11) DEFAULT NULL,
	`is_deleted` TINYINT(1) DEFAULT 0 COMMENT '0=No; 1=Yes',
	PRIMARY KEY (`stok_id`),
	FOREIGN KEY(`produk_id`) REFERENCES `tbl_produk` (`produk_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `tbl_produk_harga` (
	`produk_harga_id` INT(11) NOT NULL AUTO_INCREMENT,
	`produk_id` INT(11),
	`satuan` VARCHAR(255),
	`netto` INT(11),
	`harga_beli` DECIMAL(16,2),
	`harga_jual` DECIMAL(16,2),
	`tgl_dibuat` DATETIME DEFAULT NULL,
	`dibuat_oleh` INT(11) DEFAULT NULL,
	`tgl_diupdate` DATETIME DEFAULT NULL,
	`diupdate_oleh` INT(11) DEFAULT NULL,
	`is_deleted` TINYINT(1) DEFAULT 0 COMMENT '0=No; 1=Yes',
	PRIMARY KEY (`produk_harga_id`),
	FOREIGN KEY(`produk_id`) REFERENCES `tbl_produk` (`produk_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `tbl_related_produk` (
	`related_produk_id` INT(11) NOT NULL AUTO_INCREMENT,
	`produk_parent_id` INT(11),
	`produk_child_id` INT(11),
	`tgl_dibuat` DATETIME DEFAULT NULL,
	`dibuat_oleh` INT(11) DEFAULT NULL,
	`tgl_diupdate` DATETIME DEFAULT NULL,
	`diupdate_oleh` INT(11) DEFAULT NULL,
	`is_deleted` TINYINT(1) DEFAULT 0 COMMENT '0=No; 1=Yes',
	PRIMARY KEY (`related_produk_id`),
	FOREIGN KEY(`produk_parent_id`) REFERENCES `tbl_produk` (`produk_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
	FOREIGN KEY(`produk_child_id`) REFERENCES `tbl_produk` (`produk_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `tbl_pembelian` (
	`pembelian_id` INT(11) NOT NULL AUTO_INCREMENT,
	`supplier_id` INT(11),
	`total_invoice` DECIMAL(16,2),
	`tanggal_jatuh_tempo` DATE,
	`status_pembayaran` VARCHAR(15),
	`tanggal_bayar` DATETIME,
	`bukti_pembayaran` VARCHAR(15),
	`tgl_dibuat` DATETIME DEFAULT NULL,
	`dibuat_oleh` INT(11) DEFAULT NULL,
	`tgl_diupdate` DATETIME DEFAULT NULL,
	`diupdate_oleh` INT(11) DEFAULT NULL,
	`is_deleted` TINYINT(1) DEFAULT 0 COMMENT '0=No; 1=Yes',
	PRIMARY KEY (`pembelian_id`),
	FOREIGN KEY(`supplier_id`) REFERENCES `tbl_supplier` (`supplier_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `tbl_pembelian_detail` (
	`pembelian_detail_id` INT(11) NOT NULL AUTO_INCREMENT,
	`pembelian_id` INT(11),
	`produk_id` INT(11),
	`qty` INT(11),
	`harga_beli` DECIMAL(16,2),
	PRIMARY KEY (`pembelian_detail_id`),
	FOREIGN KEY(`pembelian_id`) REFERENCES `tbl_pembelian` (`pembelian_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
	FOREIGN KEY(`produk_id`) REFERENCES `tbl_produk` (`produk_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `tbl_produk_diskon` (
	`produk_diskon_id` INT(11) NOT NULL AUTO_INCREMENT,
	`produk_id` INT(11),
	`tipe_diskon` VARCHAR(15),
	`jumlah` INT(11),
	`start_diskon` DATE,
	`end_diskon` DATE,
	`tgl_dibuat` DATETIME DEFAULT NULL,
	`dibuat_oleh` INT(11) DEFAULT NULL,
	`tgl_diupdate` DATETIME DEFAULT NULL,
	`diupdate_oleh` INT(11) DEFAULT NULL,
	`is_deleted` TINYINT(1) DEFAULT 0 COMMENT '0=No; 1=Yes',
	PRIMARY KEY (`produk_diskon_id`),
	FOREIGN KEY(`produk_id`) REFERENCES `tbl_produk` (`produk_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `tbl_produk_bundling` (
	`produk_bundling_id` INT(11) NOT NULL AUTO_INCREMENT,
	`produk_diskon_id` INT(11),
	`produk_id` INT(11),
	`is_deleted` TINYINT(1) DEFAULT 0 COMMENT '0=No; 1=Yes',
	PRIMARY KEY (`produk_diskon_bundling_id`),
	FOREIGN KEY(`produk_diskon_id`) REFERENCES `tbl_produk_diskon` (`produk_diskon_id`) ON DELETE CASCADE ON UPDATE RESTRICT
	FOREIGN KEY(`produk_id`) REFERENCES `tbl_produk` (`produk_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;