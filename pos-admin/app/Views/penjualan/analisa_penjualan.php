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
                <p><i>Persentase jumlah kemunculan produk dalam transaksi (dalam decimal)</i></p>
                
              </div>

              <div class="mb-3">
                <label for="nama_kategori" class="form-label">Confidence</label>
                <input type="text" class="form-control" id="confidence" name="confidence" value="<?= $confidence ?>" placeholder="Contoh: 0.5">
                <p><i>Persentase seberapa kuat hubungan antar produk (dalam decimal)</i></p>
              </div>


              <div class="mb-3">
                <label for="nama_kategori" class="form-label">Produk</label>
                <select name="produk_ids[]" class="form-control acive-dropdown" multiple="multiple">
                  <?php foreach($produk_data as $produk) : ?>
                    <option value="<?= $produk['produk_id'] ?>"><?= ucwords(strtolower($produk['nama_produk'])) ?></option>
                  <?php endforeach; ?>
                </select>
                <p><i>Plih produk yang akan dianalisa atau tinggalkan kosong untuk melihat hubungan antar produk secara keseluruhan</i></p>
              </div>

              <button type="submit" class="btn btn-primary">Analisa</button>
            </form>
            
            <br />
            <hr />

            <h5 class="card-title fw-semibold mb-4">Prediksi Penjualan</h5>

            <?php if(count($target_prediksi) > 0 || count($prediksi) > 0) : ?>

                <div class="table-responsive">
                  <div class="mb-3">
                    <label for="target_prediksi" class="form-label">Target Prediksi: <?= implode(', ', $target_prediksi) ?></label>
                  </div>
                  
                  <div class="mb-3">
                    <label for="hasil_prediksi" class="form-label">Hasil Prediksi: </label>
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
                        endif; 
                    ?>
                  </div>
                </div>


            <?php else: ?>
                
                <div class="table-responsive">
                  <p>Tidak ada data</p>
                </div>


            <?php endif; ?>
            <br />
           
            <hr />
            <h5 class="card-title fw-semibold mb-2">Asosiasi Produk</h5>
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
                      <?php } ?>
                      
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