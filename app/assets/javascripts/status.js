$(document).on('change','.change_status',function() {
	var $this = $(this),
		status = $this.val().toLowerCase(),
		campaign = $this.attr('campaign')

		if( status == 'destroy' && ! confirm('Are you sure you want to delete this campaign?') ) return false;

		$.ajax({
			url: '/campaigns/'+campaign,
			data: { status: status},
			type: status == 'destroy' ? 'DELETE' : 'PUT',
			dataType: 'JSON'
		})

})