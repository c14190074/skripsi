var produk_data = [];

function initProduKData() {
	var supplier_id = $('#supplier_id').val();	
	if(typeof supplier_id !== "undefined") {
		$.get("getproduk/"+supplier_id, function( response ) {
			produk_data = response;
			var produk_opsi = '';

			if(typeof response.data !== "undefined") {
				for(var i=0; i<response.data.length; i++) {
					produk_opsi += "<option value='"+ response.data[i]['produk_id'] +"'>"+ response.data[i]['nama_produk'] +"</option>";
				}

			}

			$('#table-pembelian').find('.produk-data:first').html(produk_opsi);
			$('#table-pembelian').find('.produk-data:first').change();
		});
		
	}
}

$(document).ready(function() {
	initProduKData();
	$('.input-date').datepicker({
		format: 'dd-M-yy',
		autoclose: true,
        todayHighlight: true,
	});

	let table = new DataTable('.active-table');

	$('.acive-dropdown').select2({
		placeholder: 'Silahkan pilih'
	});
	$('#related_produk').select2({
		placeholder: 'Pilih produk sebanding'
	});

	$('#produk_bundling').select2({
		placeholder: 'Pilih produk bundling'
	});

	$('.simplebar-content-wrapper').on('click', '.nav.nav-underline', function() {
		return false;
	});
	

	$('.active-table').on('click', 'tbody .btn-delete-table', function() {
		var id = $(this).data('id');
		var label = $(this).data('label');
		var modul = $(this).data('modul');

		if (confirm("Apakah anda yakin untuk menghapus data " + label + "?")) {
		  window.location.href = "delete/"+id;
		} else {
		  return;
		}
	});

	$('#table-produk-stok').on('click', 'tbody .btn-add-row', function() {
		var htmlElement = '';
		htmlElement += '<tr>';
        	htmlElement += '<td>'
          		htmlElement += '<input type="text" class="form-control input-date" name="tgl_kadaluarsa[]" />';
        	htmlElement += '</td>';

        	htmlElement += '<td>';
          		htmlElement += '<input type="text" class="form-control" name="stok[]" />';
        	htmlElement += '</td>';

        	htmlElement += '<td>';
          		htmlElement += '<i role="button" class="ti ti-plus btn-add-row"></i>';
          		htmlElement += '<i role="button" class="ti ti-trash btn-delete-row"></i>';
        	htmlElement += '</td>';
     	htmlElement += '</tr>';
     	
     	$(this).parent().parent().parent().append(htmlElement);
     	$(this).parent().parent().parent().find('tr:last-child').find('.input-date').datepicker({format: 'dd-M-yy', autoclose: true, todayHighlight: true});
	});

	$('#table-produk-stok').on('click', 'tbody .btn-delete-row', function() {
     	if($(this).parent().parent().parent().children().length > 1) {
     		$(this).parent().parent().remove();
     	}
	});


	$('#table-produk-penjualan').on('click', 'tbody .btn-add-row', function() {
		var htmlElement = '';
		htmlElement += '<tr>';
        	htmlElement += '<td>'
          		htmlElement += '<input type="text" class="form-control" name="satuan_penjualan[]" />';
        	htmlElement += '</td>';

        	htmlElement += '<td>';
          		htmlElement += '<input type="text" class="form-control" name="jumlah_penjualan[]" />';
        	htmlElement += '</td>';

        	htmlElement += '<td>';
          		htmlElement += '<input type="text" class="form-control" name="harga_beli[]" />';
        	htmlElement += '</td>';

        	htmlElement += '<td>';
          		htmlElement += '<input type="text" class="form-control" name="harga_jual[]" />';
        	htmlElement += '</td>';

        	htmlElement += '<td>';
          		htmlElement += '<i role="button" class="ti ti-plus btn-add-row"></i>';
          		htmlElement += '<i role="button" class="ti ti-trash btn-delete-row"></i>';
        	htmlElement += '</td>';
     	htmlElement += '</tr>';
     	
     	$(this).parent().parent().parent().append(htmlElement);
	});

	$('#table-produk-penjualan').on('click', 'tbody .btn-delete-row', function() {
     	
     	if($(this).parent().parent().parent().children().length > 1) {
     		$(this).parent().parent().remove();
     	}
	});


	$('#table-pembelian').on('click', 'tbody .btn-add-row', function() {
		var produk_opsi = '';

		if(typeof produk_data.data !== "undefined") {
			for(var i=0; i<produk_data.data.length; i++) {
				produk_opsi += "<option value='"+ produk_data.data[i]['produk_id'] +"'>"+ produk_data.data[i]['nama_produk'] +"</option>";
			}

		}


		var htmlElement = '';
		htmlElement += '<tr>';
        	htmlElement += '<td>'
          		htmlElement += '<select class="form-control produk-data" name="produk_id[]">'+ produk_opsi +'</select>';
          		htmlElement += '<label class="label-netto"></label>';
        	htmlElement += '</td>';

        	htmlElement += '<td>';
          		htmlElement += '<input type="text" class="form-control" name="qty[]" />';
        	htmlElement += '</td>';

        	htmlElement += '<td>';
          		htmlElement += '<input type="text" class="form-control" name="harga_beli[]" />';
        	htmlElement += '</td>';

        	htmlElement += '<td>';
          		htmlElement += '<label class="label-ket"></label>';
        	htmlElement += '</td>';

        	htmlElement += '<td>';
          		htmlElement += '<i role="button" class="ti ti-plus btn-add-row"></i>';
          		htmlElement += '<i role="button" class="ti ti-trash btn-delete-row"></i>';
        	htmlElement += '</td>';
     	htmlElement += '</tr>';
     	
     	var jumlahRow = $('#table-pembelian tbody').children().length;

     	if(typeof produk_data.data !== "undefined" && jumlahRow < produk_data.data.length) {
	     	$(this).parent().parent().parent().append(htmlElement);
	     	// $(this).parent().parent().parent().find('tr:last-child').find('.input-date').datepicker({format: 'dd-M-yy', autoclose: true, todayHighlight: true});
	     }
	});

	$('#table-pembelian').on('click', 'tbody .btn-delete-row', function() {
     	if($(this).parent().parent().parent().children().length > 1) {
     		$(this).parent().parent().remove();
     	}
	});

	$('#supplier_id').on('change', function() {
		var supplier_id = $(this).val();
		$("#table-pembelian tbody tr").slice(1).remove();

		initProduKData();
		$.get("getproduk/"+supplier_id, function( response ) {
			produk_data = response;
		});
	});


	$('#table-pembelian').on('change', 'tbody .produk-data', function() {
		var obj = $(this)
		var produk_id = $(this).val();
		console.log(produk_id);

		$(obj).parent().parent().find('.label-ket').html('');
		$(obj).parent().parent().find('.label-netto').html('');

		$.get("getprodukinfopenjualan/"+produk_id, function( response ) {
			var labelKet = "";
			labelKet += "<p>Mulai: "+response.data_penjualan.start_penjualan+"</p>";
			labelKet += "<p>Akhir: "+response.data_penjualan.end_penjualan+"</p>";
			labelKet += "<p>Total Penjualan: "+response.data_penjualan.total_penjualan+"</p>";
			labelKet += "<p>Penjualan / Hari: "+response.data_penjualan.penjualan_per_hari+"</p>";
			labelKet += "<p>Stok: "+response.data_stok+"</p>";
			
			$(obj).parent().parent().find('.label-ket').html(labelKet);
			$(obj).parent().parent().find('.label-netto').html(response.netto_produk);
			
		});
	});

	$('#btn_pembelian_datang').on('click', function() {
		Swal.fire({
		  title: 'Konfirmasi',
		  text: "Apakah anda yakin barang sudah datang dan sesuai?",
		  icon: 'warning',
		  showCancelButton: true,
		  confirmButtonColor: '#3085d6',
		  cancelButtonColor: '#d33',
		  confirmButtonText: 'Ya',
		  cancelButtonText: 'Batal'
		}).then((result) => {
		  if (result.isConfirmed) {
		    $('#form-tgl-datang').submit();
		  }
		})
	});

	$('#btn_update_pembayaran').on('click', function() {
		Swal.fire({
		  title: 'Konfirmasi',
		  text: "Apakah informasi pembayaran sudah sesuai?",
		  icon: 'warning',
		  showCancelButton: true,
		  confirmButtonColor: '#3085d6',
		  cancelButtonColor: '#d33',
		  confirmButtonText: 'Ya',
		  cancelButtonText: 'Batal'
		}).then((result) => {
		  if (result.isConfirmed) {
		    $('#form-update-pembayaran').submit();
		  }
		})
	});
	
});