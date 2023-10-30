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
              
              <div class="d-sm-flex d-block align-items-center justify-content-between mb-9">
                  <div class="mb-3 mb-sm-0">
                    <h5 class="card-title fw-semibold">Daftar Penjualan</h5>
                  </div>
                  
                </div>

              <div class="card">
                <div class="card-body">
                  <div class="table-responsive">
                  	<table class="table table-striped active-table">
                  		<thead>
                  			<tr>
                          <td>No</td>
                  				<td>Total Belanja</td>
                          <td>Metode Pembayaran</td>
                          <td>Status Pembayaran</td>
                          <td>Midtrans ID</td>
                          <td>Midtrans Status</td>
                  				<td>Tanggal Transaksi</td>
                          <td>Kasir</td>
                          <td>Action</td>
                  			</tr>
                  		</thead>
                  		<tbody>
                  			<?php $ctr = 0; ?>
                  			<?php foreach($data as $d) { ?>
                  			<?php $ctr++; ?>
                  			<tr>
                  				<td><?php echo $ctr; ?></td>
                  				<td style="text-align: right;"><?php echo number_format($d->total_bayar, 0); ?></td>
                          <td><?php echo ucwords($d->metode_pembayaran); ?></td>
                          <td><?php echo ucwords($d->status_pembayaran); ?></td>
                          <td><?php echo $d->midtrans_id; ?></td>
                          <td><?php echo $d->midtrans_status; ?></td>
                  				<td><?php echo date('d M Y H:i:s', strtotime($d->tgl_dibuat)); ?></td>
                          <td><?php echo ucwords(strtolower($d->nama)) ?></td>
                  				<td>
                           <a href="detail/<?= pos_encrypt($d->penjualan_id) ?>"><i role="button" class="ti ti-info-circle fa-2y"></i></a>
                          </td>
                  			</tr>
                  			<?php } ?>
                  		</tbody>
                  	</table>
                  </div>

                </div>
              </div>
            <!-- </div>
          </div> -->
        </div>

    
<?php
  echo $this->include('default/footer');
?>