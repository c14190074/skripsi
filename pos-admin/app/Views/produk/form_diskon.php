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
                  
              <h5 class="card-title fw-semibold mb-4">Pengaturan Diskon Produk</h5>
              <div class="card">
                  <form method="POST" action="<?= $form_action ?>">
                    <div class="card-body">
                      <div class="mb-3">
                        <input type="hidden" name="produk_id" value="<?= $produk_data->produk_id ?>">
                        <label for="nama_produk" class="form-label">Nama Produk</label>
                        <input type="text" class="form-control" id="nama_produk" name="nama_produk" value="<?= set_value('nama_produk', $produk_data->nama_produk) ?>" placeholder="Nama Produk" disabled>
                        
                      </div>

                      <div class="mb-3">
                          <label for="tipe_diskon" class="form-label">Tipe Diskon</label>
                          <select id="tipe_diskon" name="tipe_diskon" class="form-select" required>
                            <option value='bundling'>Bundling</option>
                            <option value='persen'>Diskon Langsung</option>
                            <option value='tebus-murah'>Tebus Murah</option>
                          </select>
                      </div>

                      <div class="mb-3">
                        <label for="nominal" class="form-label">Nominal</label>
                        <div class="input-group">
                          <input type="text" class="form-control" id="nominal" name="nominal" value="" placeholder="Nominal">
                          <span class="input-group-text">
                            <select id="tipe_nominal" name="tipe_nominal" class="form-select" required>
                              <option value='persen'>%</option>
                              <option value='nominal'>Rp</option>
                            </select>
                          </span>
                        </div>
                        <p class="error-msg"><?= \Config\Services::validation()->getError('nominal') ?></p>
                      </div>


                      <div class="mb-3">
                          <label for="produk_bundling" class="form-label">Produk Bundling</label>
                          <select id="produk_bundling" name="produk_bundling_ids[]" class="form-select" multiple="multiple">
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
                        <label for="start_diskon" class="form-label">Start Diskon</label>
                        <div class="input-group">
                          <input type="text" class="form-control input-date" id="start_diskon" name="start_diskon" value="" placeholder="Start Diskon">
                          <span class="input-group-text">
                            <i class="ti ti-calendar fs-5"></i>
                          </span>
                          
                        </div>
                        <p class="error-msg"><?= \Config\Services::validation()->getError('start_diskon') ?></p>
                      </div>

                      <div class="mb-3">
                        <label for="end_diskon" class="form-label">End Diskon</label>
                        <div class="input-group">
                          <input type="text" class="form-control input-date" id="end_diskon" name="end_diskon" value="" placeholder="End Diskon">
                          <span class="input-group-text">
                              <i class="ti ti-calendar fs-5"></i>
                          </span>
                        </div>
                        <p class="error-msg"><?= \Config\Services::validation()->getError('end_diskon') ?></p>
                      </div>

                      <button type="submit" class="btn btn-primary">Submit</button>
                    </div>
                  </form>

                
              </div> <!-- end of card -->
            </div>
          </div>
        </div>
      

<?php
  echo $this->include('default/footer');
?>