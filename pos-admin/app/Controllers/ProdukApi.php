<?php 

namespace App\Controllers;
use CodeIgniter\RESTful\ResourceController;
use CodeIgniter\API\ResponseTrait;
use App\Models\ProdukModel;
use App\Models\ProdukHargaModel;
use App\Models\ProdukDiskonModel;


class ProdukApi extends ResourceController
{
	use ResponseTrait;
   
   	public function getAllProduk() {
        $response = array();
        $model = new ProdukModel();
        $data = $model->where('is_deleted', 0)->findAll();

        $response = array(
            'status' => 404,
            'data' => []
        );

        if($data) {
        	$response = array(
                'status' => 200,
                'data' => $data
            );
        }

        return $this->respond($response);

        
   	}

    public function getProdukHarga($produk_id) {
        $response = array();

        $db      = \Config\Database::connect();
        $builder = $db->table('tbl_produk_harga');
        $builder->select('tbl_produk_harga.*, tbl_produk.nama_produk, tbl_produk.satuan_terkecil');
        $builder->where('tbl_produk_harga.is_deleted', 0);
        $builder->where('tbl_produk_harga.produk_id', $produk_id);
        $builder->join('tbl_produk', 'tbl_produk.produk_id = tbl_produk_harga.produk_id');
        $query   = $builder->get();


        $produk_model = new ProdukModel();
        $produk = $produk_model->find($produk_id);

        $produk_diskon_model = new ProdukDiskonModel();
        $produk_diskon = $produk_diskon_model->where('is_deleted', 0)
                                            ->where('produk_id', $produk_id)->findAll();

        $data_diskon = [];
        if($produk_diskon) {
            foreach($produk_diskon as $d) {
                $status_diskon = 1;
                $tgl_skrg = date('Y-m-d H:i:s');
                $start_diskon = date('Y-m-d H:i:s', strtotime($d['start_diskon']));
                $end_diskon = date('Y-m-d H:i:s', strtotime($d['end_diskon']));

                if($tgl_skrg > $end_diskon) {
                    $status_diskon = 0;
                }

                if($tgl_skrg < $start_diskon) {
                    $status_diskon = 0;
                }

                if($status_diskon) {
                    $produk_diskon_model = new ProdukDiskonModel();
                    $key = '';
                    $total_diskon = 0;
                    if($d['tipe_nominal'] == 'persen') {
                        $total_diskon = $d['nominal'].'%';
                    }

                    if($d['tipe_nominal'] == 'nominal') {
                        $total_diskon = number_format($d['nominal']);
                    }

                    if($d['tipe_diskon'] == 'bundling') {
                        $produkBundled = $produk_diskon_model->getBundlingProduk($d['produk_diskon_id']);
                        $ket = 'Bundling disc '.$total_diskon.' dengan penambahan '.$produkBundled;
                    }

                    if($d['tipe_diskon'] == 'tebus murah') {
                        $produkBundled = $produk_diskon_model->getBundlingProduk($d['produk_diskon_id']);
                        $ket = 'Tebus murah '.$produk['nama_produk']. ' (Disc '.$total_diskon.') dengan penambahan '.$produkBundled;
                    }

                    if($d['tipe_diskon'] == 'diskon langsung') {
                        $ket = 'Disc '.$total_diskon;
                    }

                    $data_diskon[] = array(
                        'list_diskon' => $ket
                    );

                }

            }
        }

        $response = array(
            'status' => 404,
            'data' => []
        );

        if($query) {
            $response = array(
                'status' => 200,
                'data' => $query->getResult(),
                'data_diskon' => $data_diskon,
            );
        }

        return $this->respond($response);
    }

    public function getProdukDiskon() {
        $response = array();
       
        $db      = \Config\Database::connect();
        $builder = $db->table('tbl_produk');
        $builder->select('tbl_produk.produk_id, tbl_produk.nama_produk, tbl_produk_diskon.*');
        $builder->where('tbl_produk_diskon.is_deleted', 0);
        $builder->join('tbl_produk_diskon', 'tbl_produk.produk_id = tbl_produk_diskon.produk_id');
        $query   = $builder->get();

        $response = array(
            'status' => 404,
            'data' => []
        );

        if($query) {
            $tmp_data = [];
            foreach($query->getResult() as $d) {
                $status_diskon = 1;
                $tgl_skrg = date('Y-m-d H:i:s');
                $start_diskon = date('Y-m-d H:i:s', strtotime($d->start_diskon));
                $end_diskon = date('Y-m-d H:i:s', strtotime($d->end_diskon));

                if($tgl_skrg > $end_diskon) {
                    $status_diskon = 0;
                }

                if($tgl_skrg < $start_diskon) {
                    $status_diskon = 0;
                }

                if($status_diskon) {
                    $total_diskon = 0;
                    if($d->tipe_nominal == 'persen') {
                        $total_diskon = $d->nominal.'%';
                    }

                    if($d->tipe_nominal == 'nominal') {
                        $total_diskon = number_format($d->nominal);
                    }

                    $produkBundled = '-';
                    if($d->tipe_diskon == 'bundling' || $d->tipe_diskon == 'tebus murah') {
                        $produk_diskon_model = new ProdukDiskonModel();
                        $produkBundled = $produk_diskon_model->getBundlingProduk($d->produk_diskon_id);
                    }

                    $tmp_data[] = array (
                        "produk_id" => $d->produk_id,
                        "nama_produk" => $d->nama_produk,
                        "produk_diskon_id" => $d->produk_diskon_id,
                        "tipe_diskon" => ucwords(strtolower($d->tipe_diskon)),
                        "nominal" => $total_diskon,
                        "tipe_nominal" => $d->tipe_nominal,
                        "start_diskon" => date('d M Y', strtotime($d->start_diskon)),
                        "end_diskon" => date('d M Y', strtotime($d->end_diskon)),
                        'produk_bundled' => $produkBundled,
                        "tgl_dibuat" => date('d M Y H:i:s', strtotime($d->tgl_dibuat)),
                        "dibuat_oleh" => $d->dibuat_oleh,
                        "tgl_diupdate" => $d->tgl_diupdate,
                        "diupdate_oleh" => $d->diupdate_oleh,
                        "is_deleted" => $d->is_deleted
                    );

                }
            }

            $response = array(
                'status' => 200,
                'data' => $tmp_data,
            );
        }

        return $this->respond($response);
    }
}