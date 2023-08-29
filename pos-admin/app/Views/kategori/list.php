<?php 
  echo $this->include('default/header');
?>
      <div class="container-fluid">
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
                    <h5 class="card-title fw-semibold">Daftar Kategori</h5>
                  </div>
                  <div>
                    <a href="<?= base_url('kategori/create') ?>" class="btn btn-danger"><i class="ti ti-plus"></i></a>
                  </div>
                </div>

              <div class="card">
                <div class="card-body">
                  <div class="table-responsive">
                  	<table class="table table-striped active-table">
                  		<thead>
                  			<tr>
                          <td>No</td>
                  				<td>Nama Kategori</td>
                  				<td>Tanggal Dibuat</td>
                  				<td>Tanggal Diubah</td>
                          <td>Action</td>
                  			</tr>
                  		</thead>
                  		<tbody>
                  			<?php $ctr = 0; ?>
                  			<?php foreach($data as $d) { ?>
                  			<?php $ctr++; ?>
                  			<tr>
                  				<td><?php echo $ctr; ?></td>
                  				<td><?php echo $d['nama_kategori']; ?></td>

                  				<td><?php echo date('d M Y H:i:s', strtotime($d['tgl_dibuat'])); ?></td>
                  				<td>
                  					<?php 
                  						if($d['tgl_diupdate']) {
                  							echo date('d M Y H:i:s', strtotime($d['tgl_diupdate'])); 
                  						} else {
                  							echo '';
                  						}
                  					?>
                  				</td>
                          <td>
                            <a href="update/<?= pos_encrypt($d['kategori_id']) ?>"><i role="button" class="ti ti-edit btn-edit-table"></i></a>
                            <i role="button" class="ti ti-trash btn-delete-table" data-modul="kategori" data-id="<?= pos_encrypt($d['kategori_id']) ?>" data-label="<?= $d['nama_kategori'] ?>"></i>
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

      <!-- </div> -->
    
<?php
  echo $this->include('default/footer');
?>