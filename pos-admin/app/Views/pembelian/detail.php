<?php
  echo $this->include('default/header');
?>

      
        <div class="container-fluid">

          <?php if(session()->getFlashData('danger')){ ?>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <?= session()->getFlashData('danger') ?>
            </div>
          <?php } ?>
              
          <div class="d-sm-flex d-block align-items-center justify-content-between mb-9">
            <div class="mb-3 mb-sm-0">
              <h5 class="card-title fw-semibold">Informasi Pembelian</h5>
            </div>
            
            <div>
              <a href="javascript:;" class="btn btn-primary" id="btn_pembelian_datang"><i class="ti ti-calendar"></i> Datang</a>
              <a href="javascript:;" class="btn btn-danger" id="btn_pembelian_bayar"><i class="ti ti-cash"></i> Bayar</a>
            </div>
          </div>


          <div class="card">
              <div class="card-body">
                
                <table class="table" id="table-informasi-produk">
                  <tbody>
                    <tr>
                      <td>Supplier</td>
                      <td>
                        <?= ucwords(strtolower($pembelian_header[0]->nama_supplier)) ?>
                      </td>
                    </tr>

                    <tr>
                      <td class="col-md-2">Total Pembelian</td>
                      <td>
                        <?= number_format($pembelian_header[0]->total_invoice, 0) ?>
                      </td>
                    </tr>

                    <tr>
                      <td class="col-md-2">Status</td>
                      <td>
                        <?php
                            if($pembelian_header[0]->status == 0) {
                              echo "Menunggu kedatangan";
                            } else {
                              echo "Selesai";
                            }
                          ?>
                      </td>
                    </tr>

                    <tr>
                      <td>Tanggal Jatuh Tempo</td>
                      <td>
                        <?php echo date('d M Y', strtotime($pembelian_header[0]->tgl_jatuh_tempo)); ?>
                      </td>
                    </tr>

                    <tr>
                      <td>Status Pembayaran</td>
                      <td>
                        <?php echo $pembelian_header[0]->status_pembayaran == 0 ? 'Outstanding' : 'Lunas'; ?>
                      </td>
                    </tr>

                    

                    <tr>
                      <td>Tanggal Datang</td>
                      <td>
                        <?php
                          if($pembelian_header[0]->tgl_datang == '0000-00-00') {
                            echo "-";
                          } else {
                            echo date('d M Y', strtotime($pembelian_header[0]->tgl_datang)); 
                            
                          }
                          
                        ?>
                      </td>
                    </tr>

                    <tr>
                      <td>Tanggal Transaksi</td>
                      <td>
                        <?= date('d M Y H:i:s', strtotime($pembelian_header[0]->tgl_dibuat)); ?>
                      </td>
                    </tr>

                    <tr>
                      <td>Admin</td>
                      <td>
                        <?= ucwords(strtolower($pembelian_header[0]->nama)) ?>
                      </td>
                    </tr>

                    
                  </tbody>
                </table>

                <br />

                <div class="row">
                  <div class="col-md-12">
                    <h4 class="btn d-flex btn-light-warning w-100 d-block text-warning font-medium">Informasi Item Pembelian</h4>
                    <table class="table dynamic-table" id="table-produk-stok">
                      <thead>
                        <tr>
                          <th>Produk</th>
                          <th>Netto</th>
                          <th style="text-align: right;">QTY</th>
                          <th style="text-align: right;">Harga Beli</th>
                          <th style="text-align: right;">Subtotal</th>
                        </tr>
                      </thead>

                      <tbody>
                        <?php if($pembelian_detail) { ?>

                          <?php foreach($pembelian_detail as $d) { ?>

                            <tr>
                              <td><?= ucwords(strtolower($d->nama_produk)) ?></td>
                              <td><?= number_format($d->netto, 0).' '.$d->satuan_terkecil ?></td>
                              <td style="text-align: right;"><?= $d->qty ?></td>
                              <td style="text-align: right;"><?= number_format($d->harga_beli, 0) ?></td>
                              
                              <td style="text-align: right;">
                                <?php
                                  $subtotal = $d->qty * $d->harga_beli;
                                  
                                ?>
                                <?= number_format($subtotal , 0) ?></td>
                            </tr>

                          <?php } ?>

                        <?php } else { ?>
                          <tr>
                            <td colspan=6>Tidak ada data</td>
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