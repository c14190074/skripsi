<?php 

namespace App\Controllers;
use CodeIgniter\RESTful\ResourceController;
use CodeIgniter\API\ResponseTrait;
use App\Models\UserModel;
use App\Models\ProdukModel;
use App\Models\ProdukHargaModel;
use App\Models\PenjualanModel;
use App\Models\PenjualanDetailModel;


class PenjualanApi extends ResourceController
{
	use ResponseTrait;
   
   	public function simpanPenjualan(){
        $user_id = $this->request->getVar('user_id');
        $data = $this->request->getVar('dataBelanja');
        $data = json_decode($data);
        $jumlahDataTersimpan = 0;
        $total_belanja = 0;

        $response = array(
            'status' => 404,
             'msg' => 'Data tidak ditemukan',
            'data' => []
        );

        if(count($data) > 0) {
            $penjualan_model = new PenjualanModel();
            $dataToSave = [
                'total_bayar' => 0,
                'metode_pembayaran' => 'cash',
                'status_pembayaran' => 'lunas',
                'midtrans_id' => 0,
                'midtrans_status' => '',
                'tgl_dibuat' => date('Y-m-d H:i:s'),
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
                        'is_deleted' => 0,
                    ];

                    $penjualan_detail_model = new PenjualanDetailModel();
                    if($penjualan_detail_model->insert($dataToSave)) {
                        $jumlahDataTersimpan++;
                        $total_belanja = $total_belanja + ($qty * $harga_jual);
                    }     

                }

                if(count($data) == $jumlahDataTersimpan) {
                    $penjualan_model->update($penjualan_id, ['total_bayar' => $total_belanja]);

                    $response = array(
                        'status' => 200
                    );

                }

            } else {
                $response = array(
                    'status' => 401,
                    'msg' => 'Data penjualan header gagal tersimpan',
                    'data' => []
                );
            }

        } else {
            $response = array(
                'status' => 401,
                'msg' => 'Tidak ada produk terpilih',
                'data' => []
            );
        }

        return $this->respond($response);

    }

    public function getAllPenjualan($user_id) {
        $response = array();
        $model = new PenjualanModel();
        $data = $model->where('is_deleted', 0)
                        ->where('dibuat_oleh', $user_id)->findAll();

        $response = array(
            'status' => 404,
            'data' => []
        );

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

        return $this->respond($response);

        
    }

}