<?php

namespace App\Controllers;
use CodeIgniter\RESTful\ResourceController;
use CodeIgniter\API\ResponseTrait;
use App\Models\KategoriModel;
use App\Models\PenjualanModel;
use App\Models\PenjualanDetailModel;
use App\Models\ProdukModel;
use App\Models\RelatedProdukModel;
use App\Models\SupplierModel;
use App\Models\UserModel;
use App\Models\SettingModel;
use Phpml\Association\Apriori;

class Penjualan extends BaseController
{
    use ResponseTrait;
    protected $helpers = ['form'];
    
    public function report()
    {
        if(!session()->logged_in) {
            return redirect()->to(base_url('user/login')); 
        }

        $produk_model = new ProdukModel();
        $produk_count = $produk_model->where('is_deleted', 0)
                                        ->findAll();

        $supplier_model = new SupplierModel();
        $supplier_count = $supplier_model->where('is_deleted', 0)
                                        ->findAll();

        $user_model = new UserModel();
        $admin_count = $user_model->where('is_deleted', 0)
                                    ->where('jabatan', 'admin')
                                    ->findAll();

        
        $kasir_count = $user_model->where('is_deleted', 0)
                                    ->where('jabatan', 'kasir')
                                    ->findAll();

        return view('penjualan/report', array(
            'produk_count' => count($produk_count),
            'supplier_count' => count($supplier_count),
            'admin_count' => count($admin_count),
            'kasir_count' => count($kasir_count),

        ));
    }


    public function getReport($tahun_laporan) {
        $omset_penjualan = [];
        $jumlah_penjualan = [];
        $periode_penjualan = [];
        $profit_penjualan = [];
        $omset_tertinggi = 0;
        // $bulan_penjualan = [];


        $db      = \Config\Database::connect();
        $builder = $db->table('tbl_penjualan');
        $builder->select('Month(tgl_dibuat) as periode_bulan, Year(tgl_dibuat) as periode_tahun');
        $builder->selectSum('total_bayar');
        $builder->selectCount('penjualan_id');
        $builder->where('tbl_penjualan.is_deleted', 0);
        $builder->where('Year(tbl_penjualan.tgl_dibuat)', $tahun_laporan);
        $builder->orderBy('tgl_dibuat', 'asc');
        $builder->groupBy('Month(tgl_dibuat)');
        $penjualan_data   = $builder->get();


        $builder = $db->table('tbl_penjualan_detail d');
        $builder->selectSum('((d.harga_jual * d.qty) - (d.harga_beli * d.qty))', 'profit');
        $builder->select('Month(tgl_dibuat) as periode_bulan, Year(tgl_dibuat) as periode_tahun');
        $builder->where('Year(p.tgl_dibuat)', $tahun_laporan);
        $builder->where('p.is_deleted', 0);
        $builder->where('d.is_deleted', 0);
        $builder->join('tbl_penjualan p', 'd.penjualan_id = p.penjualan_id');
        $builder->orderBy('p.tgl_dibuat', 'asc');
        $builder->groupBy('Month(p.tgl_dibuat)');
        $profit_data = $builder->get();

        $current_month = date('m');
        $profit_bulan_ini = 0;
        $profit_bulan_lalu = 0;

        if($penjualan_data) {
            foreach($penjualan_data->getResult() as $row) {
                $tmp_data = $row->periode_bulan.'/'.$row->periode_tahun;

                array_push($omset_penjualan, $row->total_bayar/1000);
                array_push($jumlah_penjualan, $row->penjualan_id);
                array_push($periode_penjualan, $tmp_data);
                // array_push($bulan_penjualan, $row->periode_bulan);
            }
        }

        if($profit_data) {
            foreach($profit_data->getResult() as $row) {
                array_push($profit_penjualan, $row->profit);

                if((int)$current_month == $row->periode_bulan) {
                    $profit_bulan_ini =$row->profit;
                }

                if((int)($current_month - 1) == $row->periode_bulan) {
                    $profit_bulan_lalu =$row->profit;
                }                
            }
        }

        $status_profit = 1;
        $persentase_profit = 0;
        $selisih_profit = 0;

        if($profit_bulan_lalu > 0 && $profit_bulan_ini > 0) {
            if($profit_bulan_ini < $profit_bulan_lalu) {
                $status_profit = 0;
                $selisih_profit = $profit_bulan_lalu - $profit_bulan_ini;
                $persentase_profit = $selisih_profit / $profit_bulan_lalu * 100;
            }

            if($profit_bulan_ini > $profit_bulan_lalu) {
                $status_profit = 1;
                $selisih_profit = $profit_bulan_ini - $profit_bulan_lalu;
                $persentase_profit = $selisih_profit / $profit_bulan_ini * 100;
            }
            
        }

        if(count($omset_penjualan) > 0) {
            $omset_tertinggi = max($omset_penjualan);
        }
        

        $response = array(
            'status' => 200,
            'data' => [
                'omset_penjualan' => $omset_penjualan,
                'jumlah_penjualan' => $jumlah_penjualan,
                'periode_penjualan' => $periode_penjualan,
                'omset_tertinggi' => $omset_tertinggi,
                'profit' => $profit_penjualan,
                'profit_bulan_ini' => number_format($profit_bulan_ini, 0),
                'status_profit' => $status_profit,
                'persentase_profit' => number_format($persentase_profit, 0),
                'tahun_laporan' => $tahun_laporan
            ]
        );


    

        return $this->respond($response);
    }

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
        $produk_sebanding = [];
        $support = '';
        $confidence = '';


        $setting_model = new SettingModel();
        $setting_support = $setting_model->where('setting_name', 'support')->first();
        $setting_confidence = $setting_model->where('setting_name', 'confidence')->first();

        $support = $setting_support['setting_value'];
        $confidence = $setting_confidence['setting_value'];

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

                            if(count($prediksi) < 1) {
                                $related_produk_model = new RelatedProdukModel();
                                foreach ($produk_ids as $produk_id) {
                                    $produk_parent = $produk_model->find($produk_id); 

                                    $builder = $db->table('tbl_related_produk');
                                    $builder->select('tbl_related_produk.*, tbl_produk.nama_produk');
                                    $builder->where('tbl_related_produk.is_deleted', 0);
                                    $builder->where('tbl_related_produk.produk_parent_id', $produk_id);
                                    $builder->join('tbl_produk', 'tbl_related_produk.produk_child_id = tbl_produk.produk_id');
                                    $related_produk_data   = $builder->get();                                           

                                    $tmp_data = [];
                                    if($related_produk_data) {
                                        foreach($related_produk_data->getResult() as $d) {
                                            array_push($tmp_data, $d->nama_produk);
                                        }

                                        $produk_sebanding[ucwords(strtolower($produk_parent['nama_produk']))] = $tmp_data;
                                    }                                         
                                }
                            }
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
            'produk_sebanding' => $produk_sebanding,
            'rules_by_kategori' => []
        ));
    }
}
