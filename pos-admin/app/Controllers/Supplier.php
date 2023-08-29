<?php

namespace App\Controllers;
use App\Models\SupplierModel;

class Supplier extends BaseController
{
    protected $helpers = ['form'];
    
    public function add()
    {
        if(!session()->logged_in) {
            return redirect()->to(base_url('user/login')); 
        }
        
        $supplier_model = new SupplierModel();
        $rules = $supplier_model->getFormRules();

        if ($this->request->is('post')) {
            if ($this->validate($rules)) {
                $data = [
                    'nama_supplier' => $_POST['nama_supplier'],
                    'nama_sales' => $_POST['nama_sales'],
                    'alamat' => $_POST['alamat'],
                    'no_telp' => $_POST['no_telp'],
                    'email' => $_POST['email'],
                    'tgl_dibuat' => date('Y-m-d H:i:s'),
                    'dibuat_oleh' => session()->user_id,
                    'tgl_diupdate' => null,
                    'diupdate_oleh' => 0
                ];

                $hasil = $supplier_model->insert($data);

                if($hasil) {
                   session()->setFlashData('danger', 'Data supplier berhasil ditambahkan');
                    return redirect()->to(base_url('supplier/list'));
                } 
            }
        }
        
        return view('supplier/form', array(
            'form_action' => base_url().'supplier/create',
            'is_new_data' => true,
            'data' => $supplier_model
        ));
    }

    public function update($id)
    {
        if(!session()->logged_in) {
            return redirect()->to(base_url('user/login')); 
        }
        
        $id = pos_decrypt($id);

        $supplier_model = new SupplierModel();
        $supplier_data = $supplier_model->find($id);
        $rules = $supplier_model->getFormRules();

        if ($this->request->is('post')) {
            if ($this->validate($rules)) {
                $supplier_model = new SupplierModel();
                $data = [
                    'nama_supplier' => $_POST['nama_supplier'],
                    'nama_sales' => $_POST['nama_sales'],
                    'alamat' => $_POST['alamat'],
                    'no_telp' => $_POST['no_telp'],
                    'email' => $_POST['email'],
                    // 'tgl_dibuat' => date('Y-m-d H:i:s'),
                    // 'dibuat_oleh' => session()->user_id,
                    'tgl_diupdate' => date('Y-m-d H:i:s'),
                    'diupdate_oleh' => session()->user_id
                ];

                $hasil = $supplier_model->update($id, $data);

                if($hasil) {
                    session()->setFlashData('danger', 'Data supplier berhasil diubah');
                    return redirect()->to(base_url('supplier/list'));
                } 
            }
        }
        
        return view('supplier/form', array(
            'form_action' => base_url().'supplier/update/'.pos_encrypt($id),
            'is_new_data' => false,
            'data' => (object) $supplier_data
        ));
    }

    public function list()
    {
        if(!session()->logged_in) {
            return redirect()->to(base_url('user/login')); 
        }

        $supplier_model = new SupplierModel();
        $supplier_data = $supplier_model->where('is_deleted', 0)
                                ->findAll();
        return view('supplier/list', array(
            'data' => $supplier_data
        ));
    }

    public function delete($id) {
        if(!session()->logged_in) {
            return redirect()->to(base_url('user/login')); 
        }

        $supplier_model = new SupplierModel();
        $data = [
            'is_deleted' => 1,
        ];

        
        if($supplier_model->update(pos_decrypt($id), $data)) {
            session()->setFlashData('danger', 'Data supplier berhasil dihapus!');      
        } else {
            session()->setFlashData('danger', 'Internal server error');
        }

        return redirect()->to(base_url('supplier/list')); 
    }
}
