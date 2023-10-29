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
                                  echo "<option value='".$supplier['supplier_id']."'>".$supplier['nama_supplier']."</option>";
                                }
                              }

                            ?>
                          </select>
                          <p class="error-msg"><?= \Config\Services::validation()->getError('supplier_id') ?></p>
                      </div>

                      
                    </div>



                    <div class="card-body">
                      <h4 class="btn d-flex btn-light-secondary w-100 d-block text-secondary font-medium">Produk</h4>
                      <table class="table dynamic-table" id="table-pembelian">
                        <thead>
                          <tr>
                            <th>Produk</th>
                            <th>QTY</th>
                            <th>Harga Beli</th>
                            <th>Data Penjualan</th>
                            <th>Action</th>
                          </tr>
                        </thead>

                        <tbody>
                          <tr>
                              <td>
                                <select class="form-control produk-data" name="produk_id[]"></select>
                                <label class="label-netto"></label>
                              </td>

                              <td>
                                <input type="text" class="form-control" name="qty[]" />
                              </td>

                              <td>
                                <input type="text" class="form-control" name="harga_beli[]" />
                                
                              </td>

                              <td><label class="label-ket"></label></td>
                              <td>
                                <i role="button" class="ti ti-plus btn-add-row"></i>
                                <i role="button" class="ti ti-trash btn-delete-row"></i>
                              </td>
                            </tr>
                           
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