<?php
  echo $this->include('default/header');
?>

      
        <div class="container-fluid">

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



                <br />

                <div class="row">
                  <div class="col-md-12">
                    <h4>Program Diskon</h4>
                    <table class="table dynamic-table" id="table-produk-diskon">
                      <thead>
                        <tr>
                          <th>Tipe Diskon</th>
                          <th>Diskon</th>
                          <th>Bundling</th>
                          <th>Tanggal Mulai</th>
                          <th>Tanggal Berakhir</th>
                          <th>Action</th>
                        </tr>
                      </thead>

                      <tbody>
                        <?php if($produk_diskon) { ?>

                          <?php foreach($produk_diskon as $d) { ?>

                            <tr>
                              <td><?= ucwords($d->tipe_diskon) ?></td>
                              <td>
                                <?php
                                  if(strtolower($d->tipe_nominal) == 'nominal') {
                                    echo number_format($d->nominal, 2);
                                  } else {
                                    echo $d->nominal.' %';
                                  }
                                ?>
                              </td>
                              <td>
                                <?php
                                  if($d->tipe_diskon == 'bundling' || $d->tipe_diskon == 'tebus murah') {
                                      echo $produk_diskon_model->getBundlingProduk($d->produk_diskon_id);
                                  } else {
                                      echo '-';
                                  }
                                ?>

                              </td>
                              <td><?= date('d M Y', strtotime($d->start_diskon)) ?></td>
                              <td><?= date('d M Y', strtotime($d->end_diskon)) ?></td>
                              <td>
                                <a href="<?= base_url().'produk/updatediskon/'.pos_encrypt($d->produk_diskon_id) ?>"><i role="button" class="ti ti-edit btn-edit-table fa-2y"></i></a>
                                <a href="<?= base_url().'produk/deletediskon/'.pos_encrypt($d->produk_diskon_id) ?>" onclick="return confirm('Apakah anda yakin untuk menghapus program diskon ini?')"><i role="button" class="ti ti-trash fa-2y"></i></a>
                              </td>
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
                </div>

              </div>
          </div> <!-- end of card -->
        </div> <!-- end of container -->
    

<?php
  echo $this->include('default/footer');
?>