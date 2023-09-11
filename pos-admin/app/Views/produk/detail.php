<?php
  echo $this->include('default/header');
?>

      
        <div class="container-fluid">
          <div class="card">
            <div class="card-body">

              <?php if(session()->getFlashData('danger')){ ?>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <?= session()->getFlashData('danger') ?>
                    </div>
                  <?php } ?>
                  
              <h5 class="card-title fw-semibold mb-4">Informasi Produk</h5>
              <div class="card">
                
                  <div class="card-body">
                    
                    <table class="table" id="table-informasi-produk">
                      <tbody>
                        <tr>
                          <td class="col-md-2">Nama Produk</td>
                          <td>
                            <?= $produk_data->nama_produk ?>
                          </td>
                        </tr>

                        <tr>
                          <td>Kategori</td>
                          <td>
                            <?= $produk_data->nama_kategori ?>
                          </td>
                        </tr>


                        <tr>
                          <td>Supplier</td>
                          <td>
                            <?= $produk_data->nama_supplier ?>
                          </td>
                        </tr>

                        <tr>
                          <td>Satuan Terkecil</td>
                          <td>
                            <?= $produk_data->satuan_terkecil ?>
                          </td>
                        </tr>

                        <tr>
                          <td>Jumlah/Netto per Carton</td>
                          <td>
                            <?= number_format($produk_data->netto, 0).' '.$produk_data->satuan_terkecil ?>
                          </td>
                        </tr>

                        <tr>
                          <td>Total Stok</td>
                          <td>
                            <?= $produk_model->getStok($produk_data->produk_id) ?>
                          </td>
                        </tr>

                        <tr>
                          <td>Stok Minimal</td>
                          <td>
                            <?= $produk_stok_model->convertStok($produk_data->stok_min, $produk_data->netto, $produk_data->satuan_terkecil) ?>
                          </td>
                        </tr>

                        <tr>
                          <td>Produk Sebanding</td>
                          <td>
                            <?php
                              $tmp = [];
                              foreach ($related_produk as $p) {
                                array_push($tmp, $p->nama_produk);
                              }

                              echo implode(', ', $tmp);
                            ?>
                          </td>
                        </tr>
                      </tbody>
                    </table>

                    <br />

                    <div class="row">
                      <div class="col-md-5">
                        <h4>Stok & Tanggal Kadaluarsa</h4>
                        <table class="table dynamic-table" id="table-produk-stok">
                          <thead>
                            <tr>
                              <th>Tanggal Kadaluarsa</th>
                              <th>Stok</th>
                            </tr>
                          </thead>

                          <tbody>
                            <?php if($produk_stok) { ?>

                              <?php foreach($produk_stok as $d) { ?>

                                <tr>
                                  <td class="col-md-5"><?= date('d M Y', strtotime($d->tgl_kadaluarsa)) ?></td>
                                  <td><?= $produk_stok_model->convertStok($d->stok, $produk_data->netto, $produk_data->satuan_terkecil) ?></td>
                                </tr>

                              <?php } ?>

                            <?php } else { ?>
                              <tr>
                                <td colspan=2>Tidak ada data</td>
                              </tr>
                            <?php } ?>
                            

                          </tbody>
                        </table>
                      </div>


                      <div class="col-md-7">
                        <h4>Penjualan</h4>
                        <table class="table dynamic-table" id="table-produk-stok">
                          <thead>
                            <tr>
                              <th>Satuan</th>
                              <th>Netto/Jumlah</th>
                              <th>Harga Beli</th>
                              <th>Harga Jual</th>
                            </tr>
                          </thead>

                          <tbody>
                            <?php if($produk_harga) { ?>

                              <?php foreach($produk_harga as $d) { ?>

                                <tr>
                                  <td><?= $d->satuan ?></td>
                                  <td><?= number_format($d->netto, 0).' '.$produk_data->satuan_terkecil ?></td>
                                  <td><?= number_format($d->harga_beli, 2) ?></td>
                                  <td><?= number_format($d->harga_jual, 2) ?></td>
                                </tr>

                              <?php } ?>

                            <?php } else { ?>
                              <tr>
                                <td colspan=4>Tidak ada data</td>
                              </tr>
                            <?php } ?>
                            

                          </tbody>
                        </table>
                      </div>
                    </div>

                  </div>


              </div> <!-- end of card -->
            </div>
          </div>
        </div>
    

<?php
  echo $this->include('default/footer');
?>