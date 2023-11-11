<?php 

namespace App\Controllers;
use CodeIgniter\RESTful\ResourceController;
use CodeIgniter\API\ResponseTrait;
use App\Models\UserModel;


class UserApi extends ResourceController
{
	use ResponseTrait;
   
   	public function login(){
        $no_telp = $this->request->getVar('no_telp');
        $password = $this->request->getVar('password');

        $model = new UserModel();
        $user = $model->where('no_telp', $no_telp)
                        // ->where('password', pos_encrypt($password))
                        ->where('is_deleted', 0)
                        ->where('jabatan', 'kasir')->first();

        $response = array(
            'status' => 404,
            'data' => []
        );

        if($user) {
            $data = [
                'user_id' => $user['user_id'],
                'no_telp' => $user['no_telp'],
                'nama' => $user['nama'],
                'jabatan' => $user['jabatan'],
                'is_superadmin' => $user['is_superadmin'],
                'logged_in' => true,
            ];

            $response = array(
                'status' => 200,
                'data' => $data
            );

           
        } else {
            $response = array(
                'status' => 401,
                'data' => $no_telp,
                // 'error' => No telp dan password tidak cocok!
            );
        }

        return $this->respond($response);
    }

}