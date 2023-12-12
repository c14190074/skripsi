<?php 

namespace App\Controllers;
use CodeIgniter\RESTful\ResourceController;
use CodeIgniter\API\ResponseTrait;
use App\Models\UserModel;
use App\Models\ProdukModel;
use App\Models\ProdukHargaModel;
use App\Models\ProdukStokModel;
use App\Models\ProdukDiskonModel;
use App\Models\ProdukBundlingModel;
use App\Models\PenjualanModel;
use App\Models\PenjualanDetailModel;
use App\Models\SettingModel;
use Phpml\Association\Apriori;
use App\Models\UserApiLoginModel;


class PenjualanApi extends ResourceController
{
    use ResponseTrait;
   
    public function simpanPenjualan($user_token){
        $response = array(
            'status' => 404,
             'msg' => 'Data tidak ditemukan',
            'data' => []
        );

        $api_model = new UserApiLoginModel();
        if($api_model->isTokenValid($user_token)) {
            $user_id = $this->request->getVar('user_id');
            $data = $this->request->getVar('dataBelanja');
            $metode_pembayaran = $this->request->getVar('metode_pembayaran');
            $no_telp_pelanggan = $this->request->getVar('no_telp_pelanggan');
            $data = json_decode($data);
            $jumlahDataTersimpan = 0;
            $total_belanja = 0;

            $tgl_dibuat = date('Y-m-d H:i:s');

            $min_jumlah_data = 7;
            $max_jumlah_data = 20;

            $rand_jumlah_data = rand($min_jumlah_data, $max_jumlah_data);

            if(count($data) > 0) {
                for($a = 0; $a < $rand_jumlah_data; $a++) {
                    $total_belanja = 0;
                    $jumlahDataTersimpan = 0;
                    $min_day = 1;
                    $max_day = 30;
                    $tmp_day = rand($min_day,$max_day);

                    $min_month = 8;
                    $max_month = 11;
                    $tmp_month = rand($min_month,$max_month);

                    $tmp_tgl = date('Y-m-d H:i:s', strtotime('2023-'.$tmp_month.'-'.$tmp_day));

                    $penjualan_model = new PenjualanModel();
                    $dataToSave = [
                        'total_bayar' => 0,
                        'metode_pembayaran' => $metode_pembayaran,
                        'status_pembayaran' => $metode_pembayaran == 'tunai' ? 'lunas' : 'pending',
                        'midtrans_id' => 0,
                        'midtrans_status' => '',
                        // 'tgl_dibuat' => $tgl_dibuat,
                        'tgl_dibuat' => $tmp_tgl,
                        'dibuat_oleh' => $user_id,
                        'tgl_diupdate' => null,
                        'diupdate_oleh' => 0,
                        'is_deleted' => 0,
                    ];

                    $penjualan_model->insert($dataToSave);

                    if($penjualan_model) {
                        $penjualan_id = $penjualan_model->insertID;

                        for($i = 0; $i < count($data); $i++) {
                            $produk_id = $data[$i]->produk_id;
                            $produk_harga_id = $data[$i]->produk_harga_id;
                            $nama_produk = $data[$i]->nama_produk;
                            $satuan_terkecil = $data[$i]->satuan_terkecil;
                            $netto = $data[$i]->netto;
                            $satuan = $data[$i]->satuan;
                            $harga_jual = $data[$i]->harga_jual;
                            $qty = $data[$i]->qty;
                            $tipe_diskon = $data[$i]->tipe_diskon;
                            $diskon = $data[$i]->diskon;

                            $produk_model = new ProdukModel();
                            $produk_harga_model = new ProdukHargaModel();

                            $produk_data = $produk_model->find($produk_id);
                            $produk_harga_data = $produk_harga_model->find($produk_harga_id);

                            $dataToSave = [
                                'penjualan_id' => $penjualan_id,
                                'produk_id' => $produk_id,
                                'produk_harga_id' => $produk_harga_id,
                                'harga_beli' => $produk_harga_data['harga_beli'],
                                'harga_jual' => $produk_harga_data['harga_jual'],
                                'qty' => $qty,
                                'tipe_diskon' => $tipe_diskon,
                                'diskon' => $diskon,
                                'is_deleted' => 0,
                            ];

                            $penjualan_detail_model = new PenjualanDetailModel();
                            if($penjualan_detail_model->insert($dataToSave)) {
                                $qty_terjual = $produk_harga_data['netto'] * $qty;

                                $produk_stok_model = new ProdukStokModel();
                                $produk_stok = $produk_stok_model->where('is_deleted', 0)
                                                                ->where('produk_id', $produk_id)
                                                                ->orderBy('tgl_kadaluarsa', 'asc')
                                                                ->findAll();

                                $stop_pengurangan_stok = false;
                                if($produk_stok) {
                                    foreach($produk_stok as $p) {
                                        if(!$stop_pengurangan_stok) {
                                            $stok_skrg = $p['stok'] - $qty_terjual;
                                            if($stok_skrg < 0) {
                                                $produk_stok_model->update($p['stok_id'], ['stok' => 0]);
                                                $qty_terjual = $qty_terjual - $p['stok'];
                                            } else {
                                                $produk_stok_model->update($p['stok_id'], ['stok' => $stok_skrg]);
                                                $stop_pengurangan_stok = true;
                                            }

                                        }
                                        
                                    }
                                }


                                $jumlahDataTersimpan++;
                                $subtotal = $qty * $harga_jual;
                                if($diskon > 0) {
                                    if($tipe_diskon == 'persen') {
                                        $jumlahDiskon = $subtotal * $diskon / 100;
                                        $subtotal -= $jumlahDiskon;
                                    } else {
                                        $subtotal -= $diskon;
                                    }
                                }

                                $total_belanja = $total_belanja + $subtotal;
                            }     

                        }

                        if(count($data) == $jumlahDataTersimpan) {
                            $midtrans_id = time().'#'.$penjualan_id;
                            $penjualan_model->update($penjualan_id, ['total_bayar' => $total_belanja, 'midtrans_id' => $midtrans_id]);

                            if($metode_pembayaran == 'tunai') {
                                $response = array(
                                    'status' => 200,
                                    'tgl_transaksi' => date('d M Y H:i', strtotime($tgl_dibuat)),
                                );
                            } else {
                                // Set your Merchant Server Key
                                \Midtrans\Config::$serverKey = 'SB-Mid-server-3_qu33TmZWNNOLJ-Isb5Fafi';
                                // Set to Development/Sandbox Environment (default). Set to true for Production Environment (accept real transaction).
                                \Midtrans\Config::$isProduction = false;
                                // Set sanitization on (default)
                                \Midtrans\Config::$isSanitized = true;
                                // Set 3DS transaction for credit card to true
                                \Midtrans\Config::$is3ds = true;

                                
                                $params = array(
                                    'transaction_details' => array(
                                        'order_id' => $midtrans_id,
                                        'gross_amount' => $total_belanja,
                                    ),
                                    'customer_details' => array(
                                        'first_name' => 'Pelanggan umum',
                                        'phone' => $no_telp_pelanggan
                                    ),
                                );

                                $snapToken = \Midtrans\Snap::getSnapToken($params);
                                $penjualan_model->update($penjualan_id, ['midtrans_id' => $midtrans_id]);
                                $response = array(
                                    'status' => 200,
                                    'tgl_transaksi' => date('d M Y H:i', strtotime($tgl_dibuat)),
                                    'midtrans_url' => 'https://app.sandbox.midtrans.com/snap/v2/vtweb/'.$snapToken
                                );
                            }

                        }

                    } else {
                        $response = array(
                            'status' => 401,
                            'msg' => 'Data penjualan header gagal tersimpan',
                            'data' => []
                        );
                    }
                } // end if for

            } else {
                $response = array(
                    'status' => 401,
                    'msg' => 'Tidak ada produk terpilih',
                    'data' => []
                );
            }
        } else {
            $response = array(
                'status' => 403,
                'msg' => 'Token tidak valid',
                'data' => []
            );
        }
        

        return $this->respond($response);

    }

    public function getAllPenjualan($user_id, $date_filter, $user_token) {
        $response = array(
            'status' => 404,
            'data' => []
        );

        $api_model = new UserApiLoginModel();
        if($api_model->isTokenValid($user_token)) {
            $date_filter = $date_filter == '1' ? date('Y-m-d') : date('Y-m-d', strtotime($date_filter));
            
            $model = new PenjualanModel();
            $data = $model->where('is_deleted', 0)
                            ->where('DATE(tgl_dibuat)', $date_filter)
                            ->where('dibuat_oleh', $user_id)
                            ->orderBy('tgl_dibuat', 'desc')->findAll();

            if($data) {
                $tmp_data = [];

                foreach($data as $d) {
                    $tmp_data[] = array(
                        "penjualan_id" => $d['penjualan_id'],
                        "total_bayar" => $d['total_bayar'],
                        "metode_pembayaran" => $d['metode_pembayaran'],
                        "status_pembayaran" => $d['status_pembayaran'],
                        "midtrans_id" => $d['midtrans_id'],
                        "midtrans_status" => $d['midtrans_status'],
                        "tgl_dibuat" => date("d M Y H:i:s", strtotime($d['tgl_dibuat'])),
                        "dibuat_oleh" => $d['dibuat_oleh'],
                        "tgl_diupdate" => $d['tgl_diupdate'],
                        "diupdate_oleh" => $d['diupdate_oleh'],
                        "is_deleted" => $d['is_deleted']
                    );
                }

                $response = array(
                    'status' => 200,
                    'data' => $tmp_data
                );
            }
        } else {
            $response = array(
                'status' => 403,
                'msg' => 'Token tidak valid',
                'data' => []
            );
        }

        return $this->respond($response);

        
    }

    public function hitungDiskon($user_token){
        $data = $this->request->getVar('dataBelanja');
        $data = json_decode($data);
        $response = array(
            'status' => 404,
            'msg' => 'Data tidak ditemukan',
            'data' => []
        );


        $api_model = new UserApiLoginModel();
        if($api_model->isTokenValid($user_token)) {
            $result = [];
            $list_produk_id = [];

            if(count($data) > 0) {
                $produk_diskon_model = new ProdukDiskonModel();

                for($i = 0; $i < count($data); $i++) {
                    array_push($list_produk_id, $data[$i]->produk_id);
                }

                for($i = 0; $i < count($data); $i++) {
                    $produk_id = $data[$i]->produk_id;
                    $produk_diskon = $produk_diskon_model->where('is_deleted', 0)
                                                        ->where('produk_id', $produk_id)
                                                        ->orderBy('start_diskon', 'desc')
                                                        ->first();
                    if($produk_diskon) {
                        $status_diskon = 1;
                        $tgl_skrg = date('Y-m-d H:i:s');
                        $start_diskon = date('Y-m-d H:i:s', strtotime($produk_diskon['start_diskon']));
                        $end_diskon = date('Y-m-d H:i:s', strtotime($produk_diskon['end_diskon']));

                        if($tgl_skrg > $end_diskon) {
                            $status_diskon = 0;
                        }

                        if($tgl_skrg < $start_diskon) {
                            $status_diskon = 0;
                        }

                        if($status_diskon) {
                            if($produk_diskon['tipe_diskon'] == 'diskon langsung') {
                                $result[] = array(
                                    'produk_id' => $produk_id,
                                    'nominal' => $produk_diskon['nominal'],
                                    'tipe_nominal' => $produk_diskon['tipe_nominal'],
                                );
                            }

                            if($produk_diskon['tipe_diskon'] == 'tebus murah' || $produk_diskon['tipe_diskon'] == 'bundling') {
                                $ctr = 0;
                                $produk_bundling_model = new ProdukBundlingModel();
                                $produk_bundling = $produk_bundling_model->where('is_deleted', 0)
                                                                        ->where('produk_diskon_id', $produk_diskon['produk_diskon_id'])
                                                                        ->findAll();

                                if($produk_bundling) {
                                    foreach($produk_bundling as $d) {
                                        if (in_array($d['produk_id'], $list_produk_id)) {
                                            $ctr++;
                                        }
                                    }
                                }


                                if($ctr == count($produk_bundling)) {
                                    if($produk_diskon['tipe_diskon'] == 'tebus murah') {
                                        $result[] = array(
                                            'produk_id' => $produk_id,
                                            'nominal' => $produk_diskon['nominal'],
                                            'tipe_nominal' => $produk_diskon['tipe_nominal'],
                                        );
                                    }

                                    if($produk_diskon['tipe_diskon'] == 'bundling') {
                                        $result[] = array(
                                            'produk_id' => $produk_id,
                                            'nominal' => $produk_diskon['nominal'],
                                            'tipe_nominal' => $produk_diskon['tipe_nominal'],
                                        );

                                        foreach($produk_bundling as $d) {
                                            $result[] = array(
                                                'produk_id' => $d['produk_id'],
                                                'nominal' => $produk_diskon['nominal'],
                                                'tipe_nominal' => $produk_diskon['tipe_nominal'],
                                            );
                                        }   
                                    }

                                }

                            }

                            
                        }
                    }   
                }

                $response = array(
                    'status' => 200,
                    'numData' => count($result),
                    'data' => $result,

                );
            } else {
                $response = array(
                    'status' => 401,
                    'msg' => 'Tidak ada produk terpilih',
                    'data' => []
                );
            }
        } else {
            $response = array(
                'status' => 403,
                'msg' => 'Token tidak valid',
                'data' => []
            );
        }

        return $this->respond($response);

    }


    public function getPenjualan($penjualan_id, $user_token)
    {
        $response = array(
            'status' => 404,
            'data' => []
        );

        $api_model = new UserApiLoginModel();
        if($api_model->isTokenValid($user_token)) {
            $db      = \Config\Database::connect();
            $builder = $db->table('tbl_penjualan');
            $builder->select('tbl_penjualan.*, tbl_user.nama');
            $builder->where('tbl_penjualan.is_deleted', 0);
            $builder->where('tbl_penjualan.penjualan_id', $penjualan_id);
            $builder->join('tbl_user', 'tbl_penjualan.dibuat_oleh = tbl_user.user_id');
            $penjualan_data   = $builder->get();


            if($penjualan_data) {
                $response = array(
                    'status' => 200,
                    'penjualan_header' => $penjualan_data->getResult(),
                );
            }
        } else {
            $response = array(
                'status' => 403,
                'msg' => 'Token tidak valid',
                'data' => []
            );
        }
            
        
        return $this->respond($response);
    }

    public function detailPenjualan($penjualan_id, $user_token)
    {
        $response = array(
            'status' => 404,
            'data' => []
        );

        $api_model = new UserApiLoginModel();
        if($api_model->isTokenValid($user_token)) {
            $penjualan_model = new PenjualanModel();
            $penjualan_data = $penjualan_model->find($penjualan_id);

            $db      = \Config\Database::connect();

            $builder = $db->table('tbl_penjualan_detail');
            $builder->select('UPPER(tbl_produk.nama_produk) as nama_produk, tbl_produk.satuan_terkecil, tbl_penjualan_detail.*, tbl_produk_harga.satuan, tbl_produk_harga.netto');
            $builder->where('tbl_penjualan_detail.penjualan_id', $penjualan_id);
            $builder->join('tbl_produk', 'tbl_penjualan_detail.produk_id = tbl_produk.produk_id');
            $builder->join('tbl_produk_harga', 'tbl_penjualan_detail.produk_harga_id = tbl_produk_harga.produk_harga_id');
            $penjualan_detail   = $builder->get();

            if($penjualan_detail) {
                $response = array(
                    'status' => 200,
                    'total_belanja' => $penjualan_data['total_bayar'],
                    'tgl_transaksi' => date('d M Y H:i', strtotime($penjualan_data['tgl_dibuat'])),
                    'penjualan_detail' => $penjualan_detail->getResult(),
                );
            }
        } else {
            $response = array(
                'status' => 403,
                'msg' => 'Token tidak valid',
                'data' => []
            );
        }  
        
        return $this->respond($response);
    }


    public function getProdukRekomendasi($user_token) {
        $data = $this->request->getVar('dataBelanja');
        $data = json_decode($data);
        $list_belanja = [];

        $response = array(
            'status' => 404,
            'data_rekomendasi' => []
        );

        $api_model = new UserApiLoginModel();
        if($api_model->isTokenValid($user_token)) {
            $support = 0.5;
            $confidence = 0.5;

            $setting_model = new SettingModel();
            $setting_data = $setting_model->findAll();

            foreach($setting_data as $setting) {
                if($setting['setting_name'] == 'support') {
                    $support = $setting['setting_value'];
                }

                if($setting['setting_name'] == 'confidence') {
                    $confidence = $setting['setting_value'];
                }
            }

            if(count($data) > 0) {
                for ($i=0; $i < count($data); $i++) { 
                    if(!in_array(strtolower($data[$i]->nama_produk), $list_belanja)) {
                        array_push($list_belanja, strtolower($data[$i]->nama_produk));
                    }
                }


                $db      = \Config\Database::connect();

                $builder = $db->table('tbl_penjualan_detail');
                $builder->select('tbl_penjualan_detail.*, tbl_produk.nama_produk');
                $builder->where('tbl_penjualan_detail.is_deleted', 0);

                $builder->join('tbl_produk', 'tbl_penjualan_detail.produk_id = tbl_produk.produk_id');
                $builder->orderBy('tbl_penjualan_detail.penjualan_id', 'asc');
                $penjualan_detail   = $builder->get();

                if($penjualan_detail) {
                    $data = [];
                    $rekomendasi = [];
                    $data_produk = [];
                    $current_penjualan_id = 0;
                    $result = $penjualan_detail->getResult();
                    
                    if($result) {
                        $current_penjualan_id = $result[0]->penjualan_id;

                        $tmp_data = [];
                        foreach($result as $d) {
                            if($current_penjualan_id == $d->penjualan_id) {
                                if(!in_array(strtolower($d->nama_produk), $tmp_data)) {
                                    array_push($tmp_data, strtolower($d->nama_produk));
                                    $data_produk[strtolower($d->nama_produk)] = $d->produk_id;
                                }
                                
                            } else {
                                array_push($data, $tmp_data);
                                $tmp_data = [];
                                $current_penjualan_id = $d->penjualan_id;

                                if(!in_array(strtolower($d->nama_produk), $tmp_data)) {
                                    array_push($tmp_data, strtolower($d->nama_produk));
                                    $data_produk[strtolower($d->nama_produk)] = $d->produk_id;
                                }
                            } 
                            
                        }

                        if(count($tmp_data) > 0) {
                            array_push($data, $tmp_data);
                        }
                    }

                    if(count($data) > 0) {
                        $produk_model = new ProdukModel();

                        $labels  = [];
                        $associator = new Apriori($support, $confidence);
                        $associator->train($data, $labels);
                        $rekomendasi = $associator->predict($list_belanja);
                        // $rekomendasi = $associator->predict(['amanda kuning', 'gogo coklat']);
                        // $rekomendasi = $associator->getRules();

                        $unique_rekomendasi = [];
                        $tmp_rekomendasi = [];
                        foreach ($rekomendasi as $rek) {
                            foreach($rek as $r) {
                                if(!in_array($r, $tmp_rekomendasi)) {
                                    array_push($tmp_rekomendasi, $r);
                                    $produk_data = $produk_model->find($data_produk[$r]);


                                    $r_info = [
                                        'produk_id' => $data_produk[$r],
                                        'nama_produk' => ucwords($r),
                                        'satuan_terkecil' => $produk_data['satuan_terkecil'],
                                        'total_stok' => $produk_model->getStok($data_produk[$r])
                                    ];

                                    array_push($unique_rekomendasi, $r_info);
                                }

                            }
                        }

                        $rekomendasi = $unique_rekomendasi;
                    }


                    $response = array(
                        'status' => 200,
                        'data_rekomendasi' => $rekomendasi,
                        // 'data_produk' => $data_produk
                    );
                }

            }
        } else {
            $response = array(
                'status' => 403,
                'msg' => 'Token tidak valid',
                'data' => []
            );
        }
            
        
        return $this->respond($response);
    }
}