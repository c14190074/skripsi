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
                  
              <div class="d-sm-flex d-block align-items-center justify-content-between mb-9">
                  <div class="mb-3 mb-sm-0">
                    <h5 class="card-title fw-semibold">Daftar Stok Produk</h5>
                  </div>
                  <div>
                    <a href="<?= base_url('produk/create') ?>" class="btn btn-danger"><i class="ti ti-plus"></i></a>
                  </div>
                </div>

              <div class="card">
                <div class="card-body">
                  <div class="table-responsive">
                  	<table class="table table-striped active-table">
                  		<thead>
                  			<tr>
                          <td>No</td>
                  				<td>Nama Produk</td>
                  				
                  				<td>Supplier</td>
                          <td>Stok Minimal</td>
                  				<td>Stok</td>
                          <td>Tanggal Kadaluarsa</td>
                          <td>Action</td>
                  			</tr>
                  		</thead>
                  		<tbody>
                  			<?php $ctr = 0; ?>
                  			<?php foreach($produk_data as $produk) { ?>
                  			<?php $ctr++; ?>
                  			<tr>
                  				<td><?php echo $ctr; ?></td>
                  				<td><?php echo $produk->nama_produk; ?></td>
                  				<td><?php echo $produk->nama_supplier; ?></td>
                          <td><?php echo $produk_stok_model->convertStok($produk->stok_min, $produk->netto, $produk->satuan_terkecil); ?></td>
                          <td class="error-msg"><?php echo $produk_stok_model->convertStok($produk->stok, $produk->netto, $produk->satuan_terkecil);; ?></td>
                          <td><?php echo date('d M Y', strtotime($produk->tgl_kadaluarsa)); ?></td>
                          <td>
                            <a href="detail/<?= pos_encrypt($produk->produk_id) ?>"><i role="button" class="ti ti-info-circle"></i></a>
                            
                          </td>
                  			</tr>
                  			<?php } ?>
                  		</tbody>
                  	</table>
                  </div>

                </div>
              </div>
            </div>
          </div>
        </div>
      
   
<?php
  echo $this->include('default/footer');
?>