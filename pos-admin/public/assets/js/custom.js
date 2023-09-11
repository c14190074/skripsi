$(document).ready(function() {
	$('.input-date').datepicker({
		format: 'dd-M-yy',
		autoclose: true,
        todayHighlight: true,
	});

	let table = new DataTable('.active-table');

	$('.acive-dropdown').select2();
	$('#related_produk').select2({
		placeholder: 'Pilih produk sebanding'
	});

	$('#produk_bundling').select2({
		placeholder: 'Pilih produk bundling'
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
});