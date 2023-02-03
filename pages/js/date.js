function datePluginInit() {
	var $date = $(".date");	
	$date.flatpickr(
		{
		    onReady: function(dateObj, dateStr, instance) {
		        $('.flatpickr-calendar').each(function() {
		            var $this = $(this);
		            if ($this.find('.flatpickr-clear').length < 1) {
		                $this.append('<div class="flatpickr-clear">清除</div>');
		                $this.find('.flatpickr-clear').on('click', function() {
		                    instance.clear();
		                    instance.close();
		                });
		            }
		        });
		    },
		    dateFormat: "Y/m/d"
		}
	);
	
	var $dateTime = $(".dateTime");	
	$dateTime.flatpickr(
		{
			enableTime: true,
			dateFormat: "Y/m/d H:i",
			onReady: function(dateObj, dateStr, instance) {
		        $('.flatpickr-calendar').each(function() {
		            var $this = $(this);
		            if ($this.find('.flatpickr-clear').length < 1) {
		                $this.append('<div class="flatpickr-clear">清除</div>');
		                $this.find('.flatpickr-clear').on('click', function() {
		                    instance.clear();
		                    instance.close();
		                });
		            }
		        });
		    }
		}
	);
	
	var $dateTimeSec = $(".dateTimeSec");
	$dateTimeSec.flatpickr(
		{
			enableTime: true,
			enableSeconds : true,
			dateFormat: "Y/m/d H:i:s",
			static:true,
			onReady: function(dateObj, dateStr, instance) {
		        $('.flatpickr-calendar').each(function() {
		            var $this = $(this);
		            if ($this.find('.flatpickr-clear').length < 1) {
		                $this.append('<div class="flatpickr-clear">清除</div>');
		                $this.find('.flatpickr-clear').on('click', function() {
		                    instance.clear();
		                    instance.close();
		                });
		            }
		        });
		    }
		}
	);
}