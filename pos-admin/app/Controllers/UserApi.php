<?php 

namespace App\Controllers;
use CodeIgniter\RESTful\ResourceController;
use CodeIgniter\API\ResponseTrait;
use App\Models\UserModel;
use App\Models\UserApiLoginModel;


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
            $api_model = new UserApiLoginModel();
            if($api_model->isLogin($user['user_id'])) {
                $response = array(
                    'status' => 403,
                    'data' => []
                );
            } else {
                $data = [
                    'user_id' => $user['user_id'],
                    'no_telp' => $user['no_telp'],
                    'nama' => $user['nama'],
                    'jabatan' => $user['jabatan'],
                    'is_superadmin' => $user['is_superadmin'],
                    'logged_in' => true,
                ];

                $user_token = $api_model->checkIn($user['user_id']);

                $response = array(
                    'status' => 200,
                    'user_token' => $user_token,
                    'data' => $data
                );
            }
            
           
        } else {
            $response = array(
                'status' => 401,
                'data' => $no_telp,
                // 'error' => No telp dan password tidak cocok!
            );
        }

        return $this->respond($response);
    }

    public function logout($user_token) {
        $api_model = new UserApiLoginModel();
        $user_logout = $api_model->checkOut($user_token);

        $response = array(
            'status' => 404,
        );

        if($user_logout) {
            $response = array(
                'status' => 200,
            );
        }

        return $this->respond($response);
    }

}