<?php
  echo $this->include('default/header');
?>

      
    <div class="container-fluid">

      <?php if(session()->getFlashData('danger')){ ?>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <?= session()->getFlashData('danger') ?>
        </div>
      <?php } ?>
          
      <h5 class="card-title fw-semibold mb-4">Analisa Penjualan</h5>
      <div class="card">
          <div class="card-body">
            <form method="POST" action="analisa">
              <div class="mb-3">
                <label for="nama_kategori" class="form-label">Support</label>
                <input type="text" class="form-control" id="support" name="support" value="<?= $support ?>" placeholder="Contoh: 0.5">
                <p><i>Persentase jumlah kemunculan produk dalam transaksi (dalam decimal | max. 1)</i></p>
                
              </div>

              <div class="mb-3">
                <label for="nama_kategori" class="form-label">Confidence</label>
                <input type="text" class="form-control" id="confidence" name="confidence" value="<?= $confidence ?>" placeholder="Contoh: 0.5">
                <p><i>Persentase seberapa kuat hubungan antar produk (dalam decimal | max. 1)</i></p>
              </div>


              <div class="mb-3">
                <label for="nama_kategori" class="form-label">Produk</label>
                <select name="produk_ids[]" class="form-control acive-dropdown" multiple="multiple">
                  <?php foreach($produk_data as $produk) : ?>
                    <option value="<?= $produk['produk_id'] ?>"><?= ucwords(strtolower($produk['nama_produk'])) ?></option>
                  <?php endforeach; ?>
                </select>
                <p><i>Pilih produk yang akan dianalisa atau tinggalkan kosong untuk melihat hubungan antar produk secara keseluruhan</i></p>
              </div>

              <button type="submit" class="btn btn-primary">Analisa</button>
            </form>
            
            
            <hr />
            <br />
            <h5 class="btn d-flex btn-light-warning w-100 d-block text-warning font-medium mb-3">Prediksi Penjualan</h5>

            <?php if(count($target_prediksi) > 0 || count($prediksi) > 0) : ?>

                <div class="table-responsive">
                  <div class="mb-3">
                    <label for="target_prediksi" class="form-label">Target Prediksi: <?= implode(', ', $target_prediksi) ?></label>
                  </div>
                  
                  <div class="mb-3">
                    <label for="hasil_prediksi" class="form-label text-danger">Hasil Prediksi: </label>
                    <br />
                    <?php 
                        if(count($prediksi) > 0) :
                        
                          $index = 0;
                          foreach($prediksi as $hasil) { 
                              $index++;
                              echo "<p>Kemungkinan ".$index.": ".implode(', ', $hasil)."</p>";
                           } 

                        else:
                          echo "<p>Tidak ditemukan</p>";

                          echo "<label for='alternatif_prediksi' class='form-label text-primary'><i>Alternatif dengan produk sebanding: </i></label>";
                          if(count($produk_sebanding) > 0) {
                            foreach($produk_sebanding as $key => $value) {
                              if(count($value) > 0) {
                                echo "<p class='mb-1'>".$key.": ".implode(',', $value)."</p>";
                              } 
                              
                            }
                          } else {
                            echo "<p>Tidak ditemukan</p>"; 
                          }

                        endif; 
                    ?>
                  </div>
                </div>


            <?php else: ?>
                
                <div class="table-responsive">
                  <p>Tidak ada data</p>
                </div>


            <?php endif; ?>
           
            <hr />
            <br />
            <h5 class="btn d-flex btn-light-secondary w-100 d-block text-secondary font-medium mb-3">Asosiasi Produk</h5>
            <p class="md-4"><i>Asosiasi produk berdasarkan analisa data penjualan</i></p>
             <?php if(count($rules) > 0) : ?>

                <div class="table-responsive">
                  <table class="table table-striped active-table">
                    <thead>
                      <tr>
                        <td>No</td>
                        <td>Antecedent</td>
                        <td>Consequent</td>
                        <td>Support</td>
                        <td>Confidence</td>
                      </tr>
                    </thead>
                    <tbody>
                      <?php $ctr = 0; ?>
                      <?php foreach($rules as $rule) { ?>
                      <?php $ctr++; ?>
                      <tr>
                        <td><?php echo $ctr; ?></td>
                        <td><?= implode(', ', $rule['antecedent']) ?></td>
                        <td><?= implode(', ', $rule['consequent']) ?></td>
                        <td><?= $rule['support'] ?></td>
                        <td><?= $rule['confidence'] ?></td>
                      </tr>

                      <?php
                        $kategori_antecedent = [];
                        $kategori_consequent = [];

                        $db      = \Config\Database::connect();
                        foreach($rule['antecedent'] as $a) {
                          $builder = $db->table('tbl_kategori k');
                          $builder->select('k.*');
                          $builder->like('p.nama_produk', $a);
                          $builder->where('k.is_deleted', 0);
                          $builder->join('tbl_produk p', 'p.kategori_id = k.kategori_id');
                          $kategori_data   = $builder->get();
                          if($kategori_data) {
                            foreach($kategori_data->getResult() as $kategori) {
                              if (!in_array($kategori->nama_kategori, $kategori_antecedent)) {
                                array_push($kategori_antecedent, $kategori->nama_kategori);
                              }
                            }
                          }
                        }


                        foreach($rule['consequent'] as $c) {
                          $builder = $db->table('tbl_kategori k');
                          $builder->select('k.*');
                          $builder->like('p.nama_produk', $c);
                          $builder->where('k.is_deleted', 0);
                          $builder->join('tbl_produk p', 'p.kategori_id = k.kategori_id');
                          $kategori_data   = $builder->get();
                          if($kategori_data) {
                            foreach($kategori_data->getResult() as $kategori) {
                              if (!in_array($kategori->nama_kategori, $kategori_consequent)) {
                                array_push($kategori_consequent, $kategori->nama_kategori);
                              }
                            }
                          }
                        }

                        if(count($kategori_antecedent) > 0 && count($kategori_consequent) > 0) {
                          $rules_by_kategori[] = array(
                            'antecedent' => $kategori_antecedent,
                            'consequent' => $kategori_consequent
                          );
                        }

                      ?>

                      <?php } ?>
                      
                    </tbody>
                  </table>
                </div>


            <?php else: ?>
                
                <div class="table-responsive">
                  <p>Tidak ada data</p>
                </div>


            <?php endif; ?>


            <hr />
            <br />
            <h5 class="btn d-flex btn-light-danger w-100 d-block text-danger font-medium mb-3">Asosiasi Kategori Produk</h5>
            <p class="md-4"><i>Rekomendasi penataan barang pada rak berdasarkan kategori produk</i></p>
             <?php if(count($rules_by_kategori) > 0) : ?>

                <div class="table-responsive">
                  <table class="table table-striped active-table">
                    <thead>
                      <tr>
                        <th>Rekomendasi</th>
                      </tr>
                    </thead>
                    <tbody>
                      <?php
                        $printed_rules = [];
                        
                        foreach($rules_by_kategori as $r) {
                          $string_antecedent = implode(', ', $r['antecedent']);
                          $string_consequent = implode(', ', $r['consequent']);


                          if(!in_array(pos_encrypt($string_antecedent.$string_consequent), $printed_rules)) {
                            echo '<tr><td>Produk dengan kategori <span><b>'.$string_antecedent.'</b></span> berdekatan dengan <span><b>'.$string_consequent.'</b></span></td></tr>';
                          }
                          
                          array_push($printed_rules, pos_encrypt($string_antecedent.$string_consequent));
                        }

                      ?>
                      
                    </tbody>
                  </table>
                </div>


            <?php else: ?>
                
                <div class="table-responsive">
                  <p>Tidak ada data</p>
                </div>


            <?php endif; ?>

            

            

          </div>
      </div> <!-- end of card -->
    </div> <!-- end of container -->
    

<?php
  echo $this->include('default/footer');
?>