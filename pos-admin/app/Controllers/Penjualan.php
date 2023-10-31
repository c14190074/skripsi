<?php

namespace App\Controllers;
use App\Models\KategoriModel;
use App\Models\PenjualanModel;
use App\Models\PenjualanDetailModel;
use App\Models\ProdukModel;
use Phpml\Association\Apriori;

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
        $builder->orderBy('tgl_dibuat', 'DESC');
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

    public function analisa()
    {
        if(!session()->logged_in) {
            return redirect()->to(base_url('user/login')); 
        }
        
        $produk_model = new ProdukModel();
        $produk_data = $produk_model->where('is_deleted', 0)
                                    ->orderBy('nama_produk', 'asc')
                                    ->findAll();

        $rules = [];
        $prediksi = [];
        $target_prediksi = [];
        $support = '';
        $confidence = '';

        if ($this->request->is('post')) {
            $support = $_POST['support'];
            $confidence = $_POST['confidence'];
            $produk_ids = isset($_POST['produk_ids']) ? $_POST['produk_ids'] : [];


            if($support > 0 && $confidence > 0) {
                $db      = \Config\Database::connect();
                $builder = $db->table('tbl_penjualan_detail');
                $builder->select('tbl_penjualan_detail.*, tbl_produk.nama_produk');
                $builder->where('tbl_penjualan_detail.is_deleted', 0);
                $builder->join('tbl_produk', 'tbl_penjualan_detail.produk_id = tbl_produk.produk_id');
                $builder->orderBy('tbl_penjualan_detail.penjualan_id', 'asc');
                $penjualan_detail   = $builder->get();

                if($penjualan_detail) {
                    $data = [];
                    $current_penjualan_id = 0;
                    $result = $penjualan_detail->getResult();    

                    if($result) {
                        $current_penjualan_id = $result[0]->penjualan_id;
                        $tmp_data = [];
                        foreach($result as $d) {
                            if($current_penjualan_id == $d->penjualan_id) {
                                if(!in_array(ucwords(strtolower($d->nama_produk)), $tmp_data)) {
                                    array_push($tmp_data, ucwords(strtolower($d->nama_produk)));
                                    
                                }
                                
                            } else {
                                array_push($data, $tmp_data);
                                $tmp_data = [];
                                $current_penjualan_id = $d->penjualan_id;

                                if(!in_array(ucwords(strtolower($d->nama_produk)), $tmp_data)) {
                                    array_push($tmp_data, ucwords(strtolower($d->nama_produk)));
                                    
                                }
                            } 
                            
                        }

                        if(count($tmp_data) > 0) {
                            array_push($data, $tmp_data);
                        }
                    }


                    if(count($produk_ids) > 0) {
                        foreach($produk_ids as $produk_id) {
                            $produk = $produk_model->find($produk_id);
                            array_push($target_prediksi, ucwords(strtolower($produk['nama_produk'])));
                        }
                    }
                    
                    if(count($data) > 0) {
                        $labels  = [];
                        $associator = new Apriori($support, $confidence);
                        $associator->train($data, $labels);
                        $rules = $associator->getRules();

                        if(count($target_prediksi) > 0) {
                            $prediksi = $associator->predict($target_prediksi);
                        }
                    }
                }
            } else {
                session()->setFlashData('danger', 'Nilai support dan confidence wajib diisi.');
            }
            

         }

        return view('penjualan/analisa_penjualan', array(
            'produk_data' => $produk_data,
            'rules' => $rules,
            'support' => $support,
            'confidence' => $confidence,
            'prediksi' => $prediksi,
            'target_prediksi' => $target_prediksi,
        ));
    }
}
