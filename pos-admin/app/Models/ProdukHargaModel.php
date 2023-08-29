<?php

namespace App\Models;

use CodeIgniter\Model;

class ProdukHargaModel extends Model
{
    protected $table = 'tbl_produk_harga';
    protected $primaryKey = 'produk_harga_id';
    protected $foreignKey = ['produk_id'];
    protected $allowedFields = ['produk_id', 'satuan', 'netto', 'harga_beli', 'harga_jual', 'tgl_dibuat', 'dibuat_oleh', 'tgl_diupdate', 'diupdate_oleh', 'is_deleted'];
   
}