<?php

namespace App\Controllers;
use App\Models\KategoriModel;
use App\Models\PenjualanModel;
use App\Models\PenjualanDetailModel;

class Penjualan extends BaseController
{
    protected $helpers = ['form'];
    

    public function list()
    {
        if(!session()->logged_in) {
            return redirect()->to(base_url('user/login')); 
        }
        
        $db      = \Config\Database::connect();
        $builder = $db->table('tbl_penjualan');
        $builder->select('tbl_penjualan.*, tbl_user.nama');
        $builder->where('tbl_penjualan.is_deleted', 0);
        $builder->join('tbl_user', 'tbl_penjualan.dibuat_oleh = tbl_user.user_id');
        $penjualan_data   = $builder->get();

        return view('penjualan/list', array(
            'data' => $penjualan_data->getResult()
        ));
    }

    public function detail($id)
    {
        if(!session()->logged_in) {
            return redirect()->to(base_url('user/login')); 
        }

        $db      = \Config\Database::connect();

        $builder = $db->table('tbl_penjualan');
        $builder->select('tbl_penjualan.*, tbl_user.nama');
        $builder->where('tbl_penjualan.is_deleted', 0);
        $builder->where('tbl_penjualan.penjualan_id', pos_decrypt($id));
        $builder->join('tbl_user', 'tbl_penjualan.dibuat_oleh = tbl_user.user_id');
        $penjualan_data   = $builder->get();

       
        $builder = $db->table('tbl_penjualan_detail');
        $builder->select('tbl_produk.nama_produk, tbl_produk.satuan_terkecil, tbl_penjualan_detail.*, tbl_produk_harga.satuan, tbl_produk_harga.netto');
        $builder->where('tbl_penjualan_detail.penjualan_id', pos_decrypt($id));
        $builder->join('tbl_produk', 'tbl_penjualan_detail.produk_id = tbl_produk.produk_id');
        $builder->join('tbl_produk_harga', 'tbl_penjualan_detail.produk_harga_id = tbl_produk_harga.produk_harga_id');
        $penjualan_detail   = $builder->get();

        return view('penjualan/detail', array(
            'penjualan_data' => $penjualan_data->getResult(),
            'penjualan_detail' => $penjualan_detail->getResult(),
        ));
    }
}
