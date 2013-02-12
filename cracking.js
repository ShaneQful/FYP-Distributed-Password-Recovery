/*global alert: false, confirm: false, console: false,
	$:false,  Debug: false, opera: false, prompt: false, WSH: false */
var progressInterval , checkPasswordInterval, calcPerSecond;

function stopFakingIt() {
	'use strict';
	clearInterval(progressInterval);
	$('div').removeClass('animate');
}

function togglePassword() {
	'use strict';
	var btnName;
	$('#pass').toggle('blind');
	btnName = $('#pass-btn').html();
	if(btnName.indexOf('Show') === -1) {
		btnName = btnName.replace('Hide','Show');
		$('#pass-btn').html(btnName);
	} else {
		btnName = btnName.replace('Show','Hide');
		$('#pass-btn').html(btnName);
	}
}

function checkPassword() {
	'use strict';
	$.getJSON('done.json', function(data) {
		if(!$.isEmptyObject(data)){
			if(data.finished){
				stopFakingIt();
				clearInterval(checkPasswordInterval);
				if(data.found){
					$('#found').show('blind');
					$('#stop-btn').hide('blind');
					$('#pass').html(data.password);
					alert('The password for the file was found');
				}else{
					alert('Sorry the entire dictionary'
						+'has been attempted but no password has been found');
				}
			}
		}
	});
}

$(document).ready(function () {
		'use strict';
		var i, wordsTried;
		i = 0;
		wordsTried = 0;
		//TODO:Dyanically change this depending on parameters passed from other.
		progressInterval = setInterval(function () {
				var percent = 100 * (i / 300);
				if (percent >= 100) {
						stopFakingIt();
						percent = 100;
				}
				$('#bar').css('width', percent + '%');
				$('#cs').text(calcPerSecond + (Math.random() * 20) + ' c/s');
				$('#words').text(wordsTried + ' words');
				wordsTried += calcPerSecond / 2;
				i += 1;
		}, 500);
		checkPassword();//Useful the file has already been cracked
		checkPasswordInterval = setInterval(checkPassword, 5000);
});
