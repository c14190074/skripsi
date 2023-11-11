<?php

namespace Config;

// Create a new instance of our RouteCollection class.
$routes = Services::routes();

/*
 * --------------------------------------------------------------------
 * Router Setup
 * --------------------------------------------------------------------
 */
$routes->setDefaultNamespace('App\Controllers');
$routes->setDefaultController('Home');
$routes->setDefaultMethod('index');
$routes->setTranslateURIDashes(false);
$routes->set404Override();
// The Auto Routing (Legacy) is very dangerous. It is easy to create vulnerable apps
// where controller filters or CSRF protection are bypassed.
// If you don't want to define all routes, please use the Auto Routing (Improved).
// Set `$autoRoutesImproved` to true in `app/Config/Feature.php` and set the following to true.
// $routes->setAutoRoute(false);

/*
 * --------------------------------------------------------------------
 * Route Definitions
 * --------------------------------------------------------------------
 */

// We get a performance increase by specifying the default
// route since we don't have to scan directories.
$routes->get('/', 'Home::index');
$routes->group("user", function ($routes) {
    $routes->get('login', 'User::login');
    $routes->post('login', 'User::login');
    $routes->get('logout', 'User::logout');
    $routes->get('create', 'User::add');
    $routes->post('create', 'User::add');
    $routes->get('list', 'User::list');
    $routes->get('delete/(:any)', 'User::delete/$1');
    $routes->get('update/(:any)', 'User::update/$1');
    $routes->post('update/(:any)', 'User::update/$1');
});
$routes->group("supplier", function ($routes) {
    $routes->get('create', 'Supplier::add');
    $routes->post('create', 'Supplier::add');
    $routes->get('list', 'Supplier::list');
    $routes->get('delete/(:any)', 'Supplier::delete/$1');
    $routes->get('update/(:any)', 'Supplier::update/$1');
    $routes->post('update/(:any)', 'Supplier::update/$1');
});
$routes->group("pembelian", function ($routes) {
    $routes->get('list', 'Pembelian::list');
    $routes->get('create', 'Pembelian::add');
    $routes->post('create', 'Pembelian::add');
    $routes->get('detail/(:any)', 'Pembelian::detail/$1');
    $routes->get('getproduk/(:any)', 'Pembelian::getProduk/$1');
    $routes->get('getprodukinfopenjualan/(:any)', 'Pembelian::getProdukInfoPenjualan/$1');
    $routes->post('updatetgldatang', 'Pembelian::updateTglDatang');
    $routes->post('updatepembayaran', 'Pembelian::updatePembayaran');
    $routes->get('update/(:any)', 'Pembelian::update/$1');
    $routes->post('update/(:any)', 'Pembelian::update/$1');
    $routes->get('getdetail/(:any)', 'Pembelian::getDetail/$1');
    $routes->get('delete/(:any)', 'Pembelian::delete/$1');
    
});
$routes->group("kategori", function ($routes) {
    $routes->get('create', 'Kategori::add');
    $routes->post('create', 'Kategori::add');
    $routes->get('list', 'Kategori::list');
    $routes->get('update/(:any)', 'Kategori::update/$1');
    $routes->post('update/(:any)', 'Kategori::update/$1');
    $routes->get('delete/(:any)', 'Kategori::delete/$1');
});
$routes->group("produk", function ($routes) {
    $routes->get('test', 'Produk::test');
    $routes->get('create', 'Produk::add');
    $routes->post('create', 'Produk::add');
    $routes->get('update/(:any)', 'Produk::update/$1');
    $routes->post('update/(:any)', 'Produk::update/$1');
    $routes->get('list', 'Produk::list');
    $routes->get('listbystock', 'Produk::listByMinStok');
    $routes->get('listbyed', 'Produk::listByEd');
    $routes->get('listdiskon', 'Produk::listDiskon');
    $routes->get('detail/(:any)', 'Produk::detail/$1');
    $routes->get('delete/(:any)', 'Produk::delete/$1');
    $routes->get('diskon/(:any)', 'Produk::diskon/$1');
    $routes->post('diskon/(:any)', 'Produk::diskon/$1');
    $routes->get('updatediskon/(:any)', 'Produk::updatediskon/$1');
    $routes->post('updatediskon/(:any)', 'Produk::updatediskon/$1');
    $routes->get('deletediskon/(:any)', 'Produk::deleteDiskon/$1');
});
$routes->group("penjualan", function ($routes) {
    $routes->get('list', 'Penjualan::list');
    $routes->get('report', 'Penjualan::report');
    $routes->get('detail/(:any)', 'Penjualan::detail/$1');
    $routes->get('analisa', 'Penjualan::analisa');
    $routes->post('analisa', 'Penjualan::analisa');
    $routes->get('getreport/(:any)', 'Penjualan::getReport/$1');
});

// routes untuk API
$routes->group("api/produk", function ($routes) {
    $routes->get('getall', 'ProdukApi::getAllProduk');
    $routes->get('getprice/(:any)', 'ProdukApi::getProdukHarga/$1');
    $routes->get('getdiskon', 'ProdukApi::getProdukDiskon');

    // $routes->post('logout', 'User::logout');
    // $routes->post('test-post/(:any)/(:any)', 'Employee::testpost/$1/$2');
});

$routes->group("api/user", function ($routes) {
    $routes->post('login', 'UserApi::login');
});

$routes->group("setting", function ($routes) {
    $routes->get('update', 'Setting::update');
    $routes->post('update', 'Setting::update');
});

$routes->group("api/penjualan", function ($routes) {
    $routes->post('simpanpenjualan', 'PenjualanApi::simpanPenjualan');
    $routes->get('getall/(:any)', 'PenjualanApi::getAllPenjualan/$1');
    $routes->post('hitungdiskon', 'PenjualanApi::hitungDiskon');
    $routes->get('getheader/(:any)', 'PenjualanApi::getPenjualan/$1');
    $routes->get('getdetail/(:any)', 'PenjualanApi::detailPenjualan/$1');
    $routes->get('testsuggestion', 'PenjualanApi::testProdukRekomendasi');
    $routes->post('getsuggestion', 'PenjualanApi::
        ');

    // $routes->post('logout', 'User::logout');
    // $routes->post('test-post/(:any)/(:any)', 'Employee::testpost/$1/$2');
});
/*
 * --------------------------------------------------------------------
 * Additional Routing
 * --------------------------------------------------------------------
 *
 * There will often be times that you need additional routing and you
 * need it to be able to override any defaults in this file. Environment
 * based routes is one such time. require() additional route files here
 * to make that happen.
 *
 * You will have access to the $routes object within that file without
 * needing to reload it.
 */
if (is_file(APPPATH . 'Config/' . ENVIRONMENT . '/Routes.php')) {
    require APPPATH . 'Config/' . ENVIRONMENT . '/Routes.php';
}
