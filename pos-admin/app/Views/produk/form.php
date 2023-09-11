<?php
  echo $this->include('default/header');
?>

     
        <div class="container-fluid">
          <!-- <div class="card">
            <div class="card-body"> -->

              <?php if(session()->getFlashData('danger')){ ?>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <?= session()->getFlashData('danger') ?>
                    </div>
                  <?php } ?>
                  
              <h5 class="card-title fw-semibold mb-4">Tambah Data Produk</h5>
              <div class="card">
                  <form method="POST" action="<?= $form_action ?>">
                    <div class="card-body">
                      <div class="mb-3">
                          <label for="supplier_id" class="form-label">Supplier</label>
                          <select id="supplier_id" name="supplier_id" class="form-select acive-dropdown">
                            <?php
                              if($supplier_data) {
                                foreach($supplier_data as $supplier) {
                                  $is_selected = '';
                                  if($supplier['supplier_id'] == $data->supplier_id) {
                                    $is_selected = ' selected';
                                  }

                                  echo "<option".$is_selected." value='".$supplier['supplier_id']."'>".$supplier['nama_supplier']."</option>";
                                }
                              }

                            ?>
                          </select>
                          <p class="error-msg"><?= \Config\Services::validation()->getError('supplier_id') ?></p>
                      </div>

                      <div class="mb-3">
                          <label for="kategori_id" class="form-label">Kategori</label>
                          <select id="kategori_id" name="kategori_id" class="form-select acive-dropdown">
                            <?php
                              if($kategori_data) {
                                foreach($kategori_data as $kategori) {
                                  $is_selected = '';
                                  if($kategori['kategori_id'] == $data->kategori_id) {
                                    $is_selected = ' selected';
                                  }

                                  echo "<option".$is_selected." value='".$kategori['kategori_id']."'>".$kategori['nama_kategori']."</option>";
                                }
                              }

                            ?>
                          </select>
                          <p class="error-msg"><?= \Config\Services::validation()->getError('kategori_id') ?></p>
                      </div>

                      <div class="mb-3">
                        <label for="nama_produk" class="form-label">Nama Produk</label>
                        <input type="text" class="form-control" id="nama_produk" name="nama_produk" value="<?= set_value('nama_produk', $data->nama_produk) ?>" placeholder="Nama Produk" required>
                        <p class="error-msg"><?= \Config\Services::validation()->getError('nama_produk') ?></p>
                      </div>

                      <div class="mb-3">
                          <label for="related_produk" class="form-label">Produk Sebanding</label>
                          <select id="related_produk" name="related_produk_ids[]" class="form-select" multiple="multiple">
                            <?php
                              if($daftar_produk) {
                                foreach($daftar_produk as $p) {
                                  if(isset($related_produk_ids) && in_array($p['produk_id'], $related_produk_ids)) {
                                    echo "<option selected value='".$p['produk_id']."'>".$p['nama_produk']."</option>";
                                  } else {
                                    echo "<option value='".$p['produk_id']."'>".$p['nama_produk']."</option>";
                                  } 
                                  
                                }
                              }

                            ?>
                          </select>
                      </div>

                      <div class="mb-3">
                          <label for="satuan_terkecil" class="form-label">Satuan Terkecil</label>
                          <select id="satuan_terkecil" name="satuan_terkecil" class="form-select" required>
                            <option value='gram'<?= $data->satuan_terkecil == 'gram' ? ' selected' : '' ?>>Gram</option>
                            <option value='pcs'<?= $data->satuan_terkecil == 'pcs' ? ' selected' : '' ?>>Pcs</option>
                          </select>
                          <p class="error-msg"><?= \Config\Services::validation()->getError('satuan_terkecil') ?></p>
                      </div>

                      <div class="mb-3">
                        <label for="netto" class="form-label">Jumlah / Netto per Carton (Dalam Satuan Terkecil)</label>
                        <input type="text" class="form-control" id="netto" name="netto" value="<?= set_value('netto', $data->netto) ?>" placeholder="Jumlah" required>
                        <p class="error-msg"><?= \Config\Services::validation()->getError('netto') ?></p>
                      </div>

                      <div class="mb-3">
                        <label for="stok_min" class="form-label">Stok Minimal (Dalam Satuan Terkecil)</label>
                        <input type="text" class="form-control" id="stok_min" name="stok_min" value="<?= set_value('stok_min', $data->stok_min) ?>" placeholder="Stok Minimal">
                        <p class="error-msg"><?= \Config\Services::validation()->getError('stok_min') ?></p>
                      </div>

                      <?php if(!$is_new_data) { ?>
                      <div class="mb-0 form-check">
                        <input type="checkbox" class="form-check-input" id="update_stock" name="update_stock" value="1">
                        <label class="form-check-label" for="update_stock">Apakah ada perubahan stok dan harga?</label>
                      </div>
                      <?php } ?>
                    </div>

                    <div class="card-body">
                      <h4>Stok & Tanggal Kadaluarsa</h4>
                      <table class="table dynamic-table" id="table-produk-stok">
                        <thead>
                          <tr>
                            <th>Tanggal Kadaluarsa</th>
                            <th>Stok</th>
                            <th>Action</th>
                          </tr>
                        </thead>

                        <tbody>
                          <?php if(isset($produk_stok) && $produk_stok) { ?>

                            <?php foreach($produk_stok as $p) { ?>

                                <tr>
                                  <td>
                                    <input type="hidden" name="stok_id[]" value="<?= $p->stok_id ?>" />
                                    <input type="text" class="form-control input-date" value="<?= date('d-M-Y', strtotime($p->tgl_kadaluarsa)) ?>" name="tgl_kadaluarsa[]" />
                                  </td>

                                  <td>
                                    <input type="text" class="form-control" value="<?= $p->stok / $data->netto ?>" name="stok[]" />
                                  </td>

                                  <td>
                                    <i role="button" class="ti ti-plus btn-add-row"></i>
                                    <i role="button" class="ti ti-trash btn-delete-row"></i>
                                  </td>
                                </tr>
                            <?php } ?>

                          <?php } else { ?>
                            <tr>
                              <td>
                                <input type="text" class="form-control input-date" name="tgl_kadaluarsa[]" />
                              </td>

                              <td>
                                <input type="text" class="form-control" name="stok[]" />
                              </td>

                              <td>
                                <i role="button" class="ti ti-plus btn-add-row"></i>
                                <i role="button" class="ti ti-trash btn-delete-row"></i>
                              </td>
                            </tr>
                          <?php } ?>

                        </tbody>
                      </table>
                    </div>



                    <div class="card-body">
                      <h4>Penjualan</h4>
                      <table class="table dynamic-table" id="table-produk-penjualan">
                        <thead>
                          <tr>
                            <th>Satuan Penjualan</th>
                            <th>Jumlah / Netto (Dalam Satuan Terkecil)</th>
                            <th>Harga Beli</th>
                            <th>Harga Jual</th>
                            <th>Action</th>
                          </tr>
                        </thead>

                        <tbody>

                           <?php if(isset($produk_harga) && $produk_harga) { ?>

                            <?php foreach($produk_harga as $p) { ?>
                                
                                <tr>
                                  <td>
                                    <input type="hidden" name="produk_harga_id[]" value="<?= $p->produk_harga_id ?>" />
                                    <input type="text" class="form-control" value="<?= $p->satuan ?>" name="satuan_penjualan[]" />
                                  </td>

                                  <td>
                                    <input type="text" class="form-control" value="<?= $p->netto ?>" name="jumlah_penjualan[]" />
                                  </td>

                                  <td>
                                    <input type="text" class="form-control" value="<?= (int)$p->harga_beli ?>" name="harga_beli[]" />
                                  </td>

                                  <td>
                                    <input type="text" class="form-control" value="<?= (int)$p->harga_jual ?>" name="harga_jual[]" />
                                  </td>

                                  <td>
                                    <i role="button" class="ti ti-plus btn-add-row"></i>
                                    <i role="button" class="ti ti-trash btn-delete-row"></i>
                                  </td>
                                </tr>
                            <?php } ?>

                          <?php } else { ?>
                            <tr>
                              <td>
                                <input type="text" class="form-control" name="satuan_penjualan[]" />
                              </td>

                              <td>
                                <input type="text" class="form-control" name="jumlah_penjualan[]" />
                              </td>

                              <td>
                                <input type="text" class="form-control" name="harga_beli[]" />
                              </td>

                              <td>
                                <input type="text" class="form-control" name="harga_jual[]" />
                              </td>

                              <td>
                                <i role="button" class="ti ti-plus btn-add-row"></i>
                                <i role="button" class="ti ti-trash btn-delete-row"></i>
                              </td>
                            </tr>
                          <?php } ?>
                          

                        </tbody>
                      </table>

                      <button type="submit" class="btn btn-primary">Submit</button>
                    </div>

                  </form>

                
              </div> <!-- end of card -->
           <!--  </div>
          </div> -->
        </div>
     

<?php
  echo $this->include('default/footer');
?>