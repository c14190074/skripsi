<?php

namespace App\Models;

use CodeIgniter\Model;

class ProdukModel extends Model
{
    protected $table = 'tbl_produk';
    protected $primaryKey = 'produk_id';
    protected $foreignKey = ['supplier_id', 'kategori_id'];
    protected $allowedFields = ['supplier_id', 'kategori_id', 'nama_produk', 'satuan_terkecil', 'netto', 'stok_min', 'tgl_dibuat', 'dibuat_oleh', 'tgl_diupdate', 'diupdate_oleh', 'is_deleted'];
   

    public function getFormRules() {
        $rules = [
            'nama_produk' => [
                'rules'=> 'required',
                'errors' => [
                    'required'=> 'Nama produk wajib diisi!'
                ]
            ],
            'satuan_terkecil' => [
                'rules'=> 'required',
                'errors' => [
                    'required'=> 'Satuan terkecil wajib diisi!'
                ]
            ],
            'netto' => [
                'rules'=> 'required',
                'errors' => [
                    'required'=> 'Netto wajib diisi!'
                ]
            ],
        ];

        return $rules;
    }

    public function getStok($produk_id) {
        $db      = \Config\Database::connect();
        $builder = $db->table('tbl_produk_stok');
        $builder->where('tbl_produk_stok.produk_id', $produk_id);
        $builder->where('tbl_produk_stok.is_deleted', 0);
        $builder->join('tbl_produk', 'tbl_produk.produk_id = tbl_produk_stok.produk_id');
        $query   = $builder->get();

        $total_stok = 0;
        $nett_per_carton = 0;
        $satuan_terkecil = 'pcs';

        foreach ($query->getResult() as $row) {
            $total_stok += $row->stok;
            $nett_per_carton = $row->netto;
            $satuan_terkecil = $row->satuan_terkecil;
        }

        $stok_carton = floor($total_stok / $nett_per_carton);
        $stok_ecer = $total_stok - ($nett_per_carton * $stok_carton);

        if($stok_ecer > 0) {
            if($stok_carton > 0) {
                return $stok_carton.' dos '.number_format($stok_ecer, 0).' '.$satuan_terkecil;
            } else {
                return number_format($stok_ecer, 0).' '.$satuan_terkecil;
            }
        } else {
            return $stok_carton.' dos';
        }

        
    }
}