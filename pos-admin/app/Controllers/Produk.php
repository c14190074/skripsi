<?php

namespace App\Controllers;
use App\Models\ProdukModel;
use App\Models\KategoriModel;
use App\Models\SupplierModel;
use App\Models\ProdukStokModel;
use App\Models\ProdukHargaModel;
use App\Models\RelatedProdukModel;

class Produk extends BaseController
{
    protected $helpers = ['form'];
    
    public function add()
    {
        if(!session()->logged_in) {
            return redirect()->to(base_url('user/login')); 
        }

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

        $produk_model = new ProdukModel();

        if ($this->request->is('post')) {
            if ($this->validate($rules)) {
                $data = [
                    'supplier_id' => $_POST['supplier_id'],
                    'kategori_id' => $_POST['kategori_id'],
                    'nama_produk' => $_POST['nama_produk'],
                    'satuan_terkecil' => $_POST['satuan_terkecil'],
                    'netto' => $_POST['netto'],
                    'tgl_dibuat' => date('Y-m-d H:i:s'),
                    'dibuat_oleh' => session()->user_id,
                    'tgl_diupdate' => null,
                    'diupdate_oleh' => 0
                ];

                $hasil = $produk_model->insert($data);

                if($hasil) {
                    // input data ke tabel stok dan tgl kadaluarsa
                    if(isset($_POST['tgl_kadaluarsa']) && isset($_POST['stok'])) {
                        $index = 0;
                        $produk_stok_model = new ProdukStokModel();
                        foreach($_POST['tgl_kadaluarsa'] as $tgl) {
                            $total_stok = $_POST['stok'][$index] * $_POST['netto'];
                            $data = [
                                'produk_id' => $produk_model->insertID,
                                'tgl_kadaluarsa' => date('Y-m-d', strtotime($tgl)),
                                'stok' => $total_stok,
                                'tgl_dibuat' => date('Y-m-d H:i:s'),
                                'dibuat_oleh' => session()->user_id,
                                'tgl_diupdate' => null,
                                'diupdate_oleh' => 0
                            ];

                            $produk_stok_model->insert($data);
                            $index++;
                        }    
                    }

                    // input data ke tabel harga
                    if(isset($_POST['satuan_penjualan']) && isset($_POST['jumlah_penjualan']) && isset($_POST['harga_beli']) && isset($_POST['harga_jual'])) {
                        $index = 0;
                        $produk_harga_model = new ProdukHargaModel();
                        foreach($_POST['satuan_penjualan'] as $satuan) {
                            $data = [
                                'produk_id' => $produk_model->insertID,
                                'satuan' => $satuan,
                                'netto' => $_POST['jumlah_penjualan'][$index],
                                'harga_beli' => $_POST['harga_beli'][$index],
                                'harga_jual' => $_POST['harga_jual'][$index],
                                'tgl_dibuat' => date('Y-m-d H:i:s'),
                                'dibuat_oleh' => session()->user_id,
                                'tgl_diupdate' => null,
                                'diupdate_oleh' => 0
                            ];

                            $produk_harga_model->insert($data);
                            $index++;
                        }    
                    }

                    // input produk sebanding
                    if(isset($_POST['related_produk_ids'])) {
                        $related_produk_model = new RelatedProdukModel();
                        foreach($_POST['related_produk_ids'] as $produk_child_id) {
                            $data = [
                                'produk_parent_id' => $produk_model->insertID,
                                'produk_child_id' => $produk_child_id,
                                'tgl_dibuat' => date('Y-m-d H:i:s'),
                                'dibuat_oleh' => session()->user_id,
                                'tgl_diupdate' => null,
                                'diupdate_oleh' => 0   
                            ];

                            $related_produk_model->insert($data);
                        }
                    }

                    session()->setFlashData('danger', 'Data produk berhasil ditambahkan');
                    return redirect()->to(base_url('produk/list'));
                } 
            }
        }
        
        // get daftar kategori
        $kategori_model = new KategoriModel();
        $kategori_data = $kategori_model->where('is_deleted', 0)
                                        ->findAll();

        // get daftar supplier
        $supplier_model = new SupplierModel();
        $supplier_data = $supplier_model->where('is_deleted', 0)
                                        ->findAll();

        // get daftar produk
        $daftar_produk = $produk_model->where('is_deleted', 0)
                                    ->findAll();


        return view('produk/form', array(
            'form_action' => base_url().'produk/create',
            'is_new_data' => true,
            'data' => $produk_model,
            'supplier_data' => $supplier_data,
            'kategori_data' => $kategori_data,
            'daftar_produk'   => $daftar_produk,
        ));
    }

    public function list()
    {
        if(!session()->logged_in) {
            return redirect()->to(base_url('user/login')); 
        }


        $db      = \Config\Database::connect();
        $builder = $db->table('tbl_produk');
        $builder->select('tbl_produk.*, tbl_kategori.kategori_id, tbl_kategori.nama_kategori, tbl_supplier.supplier_id, tbl_supplier.nama_supplier');
        $builder->where('tbl_produk.is_deleted', 0);
        $builder->join('tbl_supplier', 'tbl_produk.supplier_id = tbl_supplier.supplier_id');
        $builder->join('tbl_kategori', 'tbl_produk.kategori_id = tbl_kategori.kategori_id');
        $query   = $builder->get();

        
        return view('produk/list', array(
            'produk_data' => $query->getResult(),
            'produk_model' => new ProdukModel()
        ));
    }

    public function detail($id)
    {
        if(!session()->logged_in) {
            return redirect()->to(base_url('user/login')); 
        }


        $db      = \Config\Database::connect();
        $builder = $db->table('tbl_produk');
        // $builder = $db->select('tbl_produk.*');
        $builder->where('tbl_produk.produk_id', pos_decrypt($id));
        $builder->join('tbl_supplier', 'tbl_produk.supplier_id = tbl_supplier.supplier_id');
        $builder->join('tbl_kategori', 'tbl_produk.kategori_id = tbl_kategori.kategori_id');
        $produk_query   = $builder->get();

        // get daftar produk stok
        $builder = $db->table('tbl_produk_stok');
        $builder->where('produk_id', pos_decrypt($id));
        $builder->where('is_deleted', 0);
        $produk_stok_query   = $builder->get();

        // get daftar harga produk
        $builder = $db->table('tbl_produk_harga');
        $builder->where('produk_id', pos_decrypt($id));
        $builder->where('is_deleted', 0);
        $produk_harga_query   = $builder->get();

        // get daftar related produk
        $builder = $db->table('tbl_related_produk');
        $builder->where('tbl_related_produk.produk_parent_id', pos_decrypt($id));
        $builder->where('tbl_related_produk.is_deleted', 0);
        $builder->join('tbl_produk', 'tbl_produk.produk_id = tbl_related_produk.produk_child_id');
        $related_produk_query   = $builder->get();

        return view('produk/detail', array(
            'produk_model' => new ProdukModel(),
            'produk_stok_model' => new ProdukStokModel(),
            'produk_data' => $produk_query->getResult()[0],
            'produk_stok' => $produk_stok_query->getResult(),
            'produk_harga' => $produk_harga_query->getResult(),
            'related_produk' => $related_produk_query->getResult(),
        ));
    }

    public function update($id) {
        if(!session()->logged_in) {
            return redirect()->to(base_url('user/login')); 
        }

        $id = pos_decrypt($id);

        $produk_model = new ProdukModel();
        $produk_data = $produk_model->find($id);
        
        // get rule validation
        $rules = $produk_model->getFormRules();

        // get data kategori
        $kategori_model = new KategoriModel();
        $kategori_data = $kategori_model->where('is_deleted', 0)
                                        ->findAll();
        // get data supplier
        $supplier_model = new SupplierModel();
        $supplier_data = $supplier_model->where('is_deleted', 0)
                                        ->findAll();

        // init koneksi ke dataase
        $db      = \Config\Database::connect();

        // get daftar stok produk
        $builder = $db->table('tbl_produk_stok');
        $builder->where('produk_id', $id);
        $builder->where('is_deleted', 0);
        $produk_stok_query   = $builder->get();

        // get daftar harga produk
        $builder = $db->table('tbl_produk_harga');
        $builder->where('produk_id', $id);
        $builder->where('is_deleted', 0);
        $produk_harga_query   = $builder->get();

        // daftar semua produk
        $daftar_produk = $produk_model->where('is_deleted', 0)
                                    ->findAll();

        // get daftar related produk
        $related_produk_model = new RelatedProdukModel();
        $related_produk_data = $related_produk_model->where('is_deleted', 0)
                                                    ->where('produk_parent_id', $id)
                                                    ->findAll();

        // ubah data related produk menjadi array
        $related_produk_ids = [];
        if($related_produk_data) {
            foreach($related_produk_data as $d) {
                array_push($related_produk_ids, $d['produk_child_id']);
            }
        }

        if ($this->request->is('post')) {
            if ($this->validate($rules)) {
                $data = [
                    'supplier_id' => $_POST['supplier_id'],
                    'kategori_id' => $_POST['kategori_id'],
                    'nama_produk' => $_POST['nama_produk'],
                    'satuan_terkecil' => $_POST['satuan_terkecil'],
                    'netto' => $_POST['netto'],
                    'tgl_diupdate' => date('Y-m-d H:i:s'),
                    'diupdate_oleh' => session()->user_id,
                ];

                $hasil = $produk_model->update($id, $data);

                if($hasil) {
                    // input data ke tabel stok dan tgl kadaluarsa
                    if(isset($_POST['tgl_kadaluarsa']) && isset($_POST['stok'])) {
                        $builder = $db->table('tbl_produk_stok');
                        $builder->set('is_deleted', 1);
                        $builder->where('produk_id', $id);
                        $builder->update();

                        $index = 0;
                        $produk_stok_model = new ProdukStokModel();
                        foreach($_POST['tgl_kadaluarsa'] as $tgl) {
                            $total_stok = $_POST['stok'][$index] * $_POST['netto'];
                            $data = [
                                'produk_id' => $id,
                                'tgl_kadaluarsa' => date('Y-m-d', strtotime($tgl)),
                                'stok' => $total_stok,
                                'tgl_dibuat' => date('Y-m-d H:i:s'),
                                'dibuat_oleh' => session()->user_id,
                                'tgl_diupdate' => null,
                                'diupdate_oleh' => 0
                            ];

                            $produk_stok_model->insert($data);
                            $index++;
                        }    
                    }

                    // input data ke tabel harga
                    if(isset($_POST['satuan_penjualan']) && isset($_POST['jumlah_penjualan']) && isset($_POST['harga_beli']) && isset($_POST['harga_jual'])) {
                        $builder = $db->table('tbl_produk_harga');
                        $builder->set('is_deleted', 1);
                        $builder->where('produk_id', $id);
                        $builder->update();

                        $index = 0;
                        $produk_harga_model = new ProdukHargaModel();
                        foreach($_POST['satuan_penjualan'] as $satuan) {
                            $data = [
                                'produk_id' => $id,
                                'satuan' => $satuan,
                                'netto' => $_POST['jumlah_penjualan'][$index],
                                'harga_beli' => $_POST['harga_beli'][$index],
                                'harga_jual' => $_POST['harga_jual'][$index],
                                'tgl_dibuat' => date('Y-m-d H:i:s'),
                                'dibuat_oleh' => session()->user_id,
                                'tgl_diupdate' => null,
                                'diupdate_oleh' => 0
                            ];

                            $produk_harga_model->insert($data);
                            $index++;
                        }    
                    }

                    // input produk sebanding
                    if(isset($_POST['related_produk_ids'])) {
                        $builder = $db->table('tbl_related_produk');
                        $builder->set('is_deleted', 1);
                        $builder->where('produk_parent_id', $id);
                        $builder->update();

                        $related_produk_model = new RelatedProdukModel();
                        foreach($_POST['related_produk_ids'] as $produk_child_id) {
                            $data = [
                                'produk_parent_id' => $id,
                                'produk_child_id' => $produk_child_id,
                                'tgl_dibuat' => date('Y-m-d H:i:s'),
                                'dibuat_oleh' => session()->user_id,
                                'tgl_diupdate' => null,
                                'diupdate_oleh' => 0   
                            ];

                            $related_produk_model->insert($data);
                        }
                    }

                    session()->setFlashData('danger', 'Data produk berhasil diubah');
                    return redirect()->to(base_url('produk/list')); 
                }
            }
        }

        
        return view('produk/form', array(
            'form_action' => base_url().'produk/update/'.pos_encrypt($id),
            'is_new_data' => false,
            'data' => (object) $produk_data,
            'supplier_data' => $supplier_data,
            'kategori_data' => $kategori_data,
            'produk_stok' => $produk_stok_query->getResult(),
            'produk_harga' => $produk_harga_query->getResult(),
            'daftar_produk'   => $daftar_produk,
            'related_produk_ids' => $related_produk_ids,

        ));
    }

    public function delete($id) {
        if(!session()->logged_in) {
            return redirect()->to(base_url('user/login')); 
        }

        $produk_model = new ProdukModel();
        $data = [
            'is_deleted' => 1,
        ];

        
        if($produk_model->update(pos_decrypt($id), $data)) {
            session()->setFlashData('danger', 'Data produk berhasil dihapus!');      
        } else {
            session()->setFlashData('danger', 'Internal server error');
        }

        return redirect()->to(base_url('produk/list')); 
    }

}
