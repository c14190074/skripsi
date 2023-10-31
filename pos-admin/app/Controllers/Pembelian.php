<?php

namespace App\Controllers;
use CodeIgniter\RESTful\ResourceController;
use CodeIgniter\API\ResponseTrait;
use App\Models\ProdukModel;
use App\Models\KategoriModel;
use App\Models\SupplierModel;
use App\Models\ProdukStokModel;
use App\Models\ProdukHargaModel;
use App\Models\RelatedProdukModel;
use App\Models\ProdukDiskonModel;
use App\Models\ProdukBundlingModel;
use App\Models\PembelianModel;
use App\Models\PembelianDetailModel;
use CodeIgniter\Files\File;

class Pembelian extends BaseController
{
    use ResponseTrait;
    protected $helpers = ['form'];

    public function list()
    {
        if(!session()->logged_in) {
            return redirect()->to(base_url('user/login')); 
        }
        
        $db      = \Config\Database::connect();
        $builder = $db->table('tbl_pembelian');
        $builder->select('tbl_pembelian.*, tbl_user.nama, tbl_supplier.nama_supplier');
        $builder->where('tbl_pembelian.is_deleted', 0);
        $builder->join('tbl_supplier', 'tbl_supplier.supplier_id = tbl_pembelian.supplier_id');
        $builder->join('tbl_user', 'tbl_pembelian.dibuat_oleh = tbl_user.user_id');
        $builder->orderBy('tbl_pembelian.tgl_dibuat', 'DESC');
        $pembelian_data   = $builder->get();

        return view('pembelian/list', array(
            'data' => $pembelian_data->getResult()
        ));
    }
    
    public function add()
    {
        if(!session()->logged_in) {
            return redirect()->to(base_url('user/login')); 
        }

        $rules = [
            'supplier_id' => [
                'rules'=> 'required',
                'errors' => [
                    'required'=> 'Supplier wajib diisi.'
                ]
            ],
           
        ];

        // get daftar supplier
        $supplier_model = new SupplierModel();
        $supplier_data = $supplier_model->where('is_deleted', 0)
                                        ->findAll();

        $pembelian_model = new PembelianModel();
        if ($this->request->is('post')) {

            if ($this->validate($rules)) {
                $selected_supplier = $supplier_model->find($_POST['supplier_id']);
                $today = date('Y-m-d');
                $tgl_jatuh_tempo = date('Y-m-d', strtotime($today . ' +'.$selected_supplier['tempo_pembayaran'].' day'));
                $total_invoice = 0;

                $data = [
                    'supplier_id' => $_POST['supplier_id'],
                    'total_invoice' => $total_invoice,
                    'tgl_datang' => '',
                    'tgl_jatuh_tempo' => $tgl_jatuh_tempo,
                    'status_pembayaran' => '0',
                    'tgl_bayar' => '',
                    'bukti_pembayaran' => '',
                    'tgl_dibuat' => date('Y-m-d H:i:s'),
                    'dibuat_oleh' => session()->user_id,
                    'tgl_diupdate' => null,
                    'diupdate_oleh' => 0
                ];


                $hasil = $pembelian_model->insert($data);
                if($hasil) {
                     if(isset($_POST['produk_id']) && isset($_POST['qty']) && isset($_POST['harga_beli'])) {
                        $index = 0;
                        $pembelian_detail_model = new PembelianDetailModel();
                        foreach($_POST['produk_id'] as $produk_id) {
                            $total_invoice += $_POST['qty'][$index] * $_POST['harga_beli'][$index];

                            $data = [
                                'pembelian_id' => $pembelian_model->insertID,
                                'produk_id' => $produk_id,
                                'qty' => $_POST['qty'][$index],
                                'harga_beli' => $_POST['harga_beli'][$index],
                            ];

                            $pembelian_detail_model->insert($data);
                            $index++;
                        } 

                        $pembelian_model->update($pembelian_model->insertID, ['total_invoice' => $total_invoice]);   
                    }



                    session()->setFlashData('danger', 'Data pembelian berhasil ditambahkan');
                    return redirect()->to(base_url('pembelian/create'));
                }
             
            }
        }
        
        

        return view('pembelian/form', array(
            'form_action' => base_url().'pembelian/create',
            'supplier_data' => $supplier_data,
            
        ));
    }

    public function detail($id)
    {
        if(!session()->logged_in) {
            return redirect()->to(base_url('user/login')); 
        }

        $db      = \Config\Database::connect();

         
        $builder = $db->table('tbl_pembelian');
        $builder->select('tbl_pembelian.*, tbl_user.nama, tbl_supplier.nama_supplier');
        $builder->where('tbl_pembelian.is_deleted', 0);
        $builder->where('tbl_pembelian.pembelian_id', pos_decrypt($id));
        $builder->join('tbl_supplier', 'tbl_supplier.supplier_id = tbl_pembelian.supplier_id');
        $builder->join('tbl_user', 'tbl_pembelian.dibuat_oleh = tbl_user.user_id');
        $builder->orderBy('tbl_pembelian.tgl_dibuat', 'DESC');
        $pembelian_header   = $builder->get();

       
        $builder = $db->table('tbl_pembelian_detail');
        $builder->select('tbl_produk.nama_produk, tbl_produk.satuan_terkecil, tbl_produk.netto, tbl_pembelian_detail.*');
        $builder->where('tbl_pembelian_detail.pembelian_id', pos_decrypt($id));
        $builder->join('tbl_produk', 'tbl_pembelian_detail.produk_id = tbl_produk.produk_id');
        $pembelian_detail   = $builder->get();

        return view('pembelian/detail', array(
            'pembelian_header' => $pembelian_header->getResult(),
            'pembelian_detail' => $pembelian_detail->getResult(),
        ));
    }

    public function getProduk($supplier_id) {
        $response = array(
            'status' => 404,
            'data' => []
        );


        $produk_model = new ProdukModel();
        $produk_data = $produk_model->where('is_deleted', 0)
                                    ->where('supplier_id', $supplier_id)
                                    ->findAll();

        if($produk_data) {
            $response = array(
                'status' => 200,
                'data' => $produk_data
            );
        }

        return $this->respond($response);
    }

    public function getProdukInfoPenjualan($produk_id) {
        $response = array(
            'status' => 404,
            'data' => []
        );


        $produk_model = new ProdukModel();
        $data_penjualan = $produk_model->getRataRataPenjualan($produk_id);
        $data_stok = $produk_model->getStok($produk_id);
        $data_produk = $produk_model->find($produk_id);
        $netto_produk = number_format($data_produk['netto'], 0).' '.$data_produk['satuan_terkecil'].' / dos';

        if($data_penjualan) {
            $response = array(
                'status' => 200,
                'data_penjualan' => $data_penjualan,
                'data_stok' => $data_stok,
                'netto_produk' => $netto_produk
            );
        }

        return $this->respond($response);
    }

    public function updateTglDatang() {
        if ($this->request->is('post')) {
            $pembelian_id = $_POST['pembelian_id'];
            $tgl_datang = $_POST['tgl_datang'];

            $pembelian_model = new PembelianModel();
            $hasil = $pembelian_model->update($pembelian_id, ['tgl_datang' => date('Y-m-d', strtotime($tgl_datang))]);

            if($hasil) {
                session()->setFlashData('danger', 'Tanggal pembelian berhasil diupdate');
                
            } else {
                session()->setFlashData('danger', 'Update tanggal pembelian gagal.');
            }

            return redirect()->to(base_url('pembelian/detail/'.pos_encrypt($pembelian_id)));
        }
    }

    public function updatePembayaran() {
        if ($this->request->is('post')) {
            $pembelian_id = $_POST['pembelian_id'];
            $validationRule = [
                'bukti_pembayaran' => [
                    'label' => 'Image File',
                    'rules' => [
                        'uploaded[bukti_pembayaran]',
                        'is_image[bukti_pembayaran]',
                        'mime_in[bukti_pembayaran,image/jpg,image/jpeg,image/gif,image/png,image/webp]',
                        'max_size[bukti_pembayaran,100]',
                        'max_dims[bukti_pembayaran,1024,768]',
                    ],
                ],
            ];

            $pembelian_id = $_POST['pembelian_id'];
            $tgl_pembayaran = $_POST['tgl_pembayaran'];
            $metode_pembayaran = $_POST['metode_pembayaran'];
            $url_bukti_bayar = '';

            
            if (!empty($_FILES['bukti_pembayaran']['name'])) {
                $img = $this->request->getFile('bukti_pembayaran');

                if($this->validate($validationRule)) {
                    $newName = $img->getRandomName();
                    if($img->move(FCPATH . 'uploads', $newName)) {
                        $url_bukti_bayar = $newName;
                    }
                } else {
                    session()->setFlashData('danger', $this->validator->getErrors()['bukti_pembayaran']);
                }
            }


            
            $data = array(
                'metode_pembayaran' => $metode_pembayaran,
                'tgl_bayar' => date('Y-m-d', strtotime($tgl_pembayaran)),
                'status_pembayaran' => 1,
                'bukti_pembayaran' => $url_bukti_bayar 
            );

            $pembelian_model = new PembelianModel();
            $hasil = $pembelian_model->update($pembelian_id, $data);

            if($hasil) {
                session()->setFlashData('danger', 'Status pembayaran berhasil diupdate.');
                
            } else {
                session()->setFlashData('danger', 'Update pembayaran gagal.');
            }

            return redirect()->to(base_url('pembelian/detail/'.pos_encrypt($pembelian_id)));
        }
    }
}