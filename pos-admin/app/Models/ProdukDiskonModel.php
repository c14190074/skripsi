<?php

namespace App\Models;

use CodeIgniter\Model;

class ProdukDiskonModel extends Model
{
    protected $table = 'tbl_produk_diskon';
    protected $primaryKey = 'produk_diskon_id';
    protected $foreignKey = ['produk_id'];
    protected $allowedFields = ['produk_id', 'tipe_diskon', 'jumlah', 'start_diskon', 'end_diskon', 'tgl_dibuat', 'dibuat_oleh', 'tgl_diupdate', 'diupdate_oleh', 'is_deleted'];
   
}