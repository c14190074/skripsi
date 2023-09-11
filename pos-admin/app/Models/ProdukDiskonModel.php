<?php

namespace App\Models;

use CodeIgniter\Model;

class ProdukDiskonModel extends Model
{
    protected $table = 'tbl_produk_diskon';
    protected $primaryKey = 'produk_diskon_id';
    protected $foreignKey = ['produk_id'];
    protected $allowedFields = ['produk_id', 'tipe_diskon', 'nominal', 'tipe_nominal', 'start_diskon', 'end_diskon', 'tgl_dibuat', 'dibuat_oleh', 'tgl_diupdate', 'diupdate_oleh', 'is_deleted'];


    public function getFormRules() {
        $rules = [
            'nominal' => [
                'rules'=> 'required',
                'errors' => [
                    'required'=> 'Nominal diskon wajib diisi!'
                ]
            ],
            'start_diskon' => [
                'rules'=> 'required',
                'errors' => [
                    'required'=> 'Tanggal mulai diskon wajib diisi!'
                ]
            ],
            'end_diskon' => [
                'rules'=> 'required',
                'errors' => [
                    'required'=> 'Tanggal berakhir diskon wajin diisi!'
                ]
            ],
        ];

        return $rules;
    }
   
}