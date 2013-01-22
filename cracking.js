/*global alert: false, confirm: false, console: false,
	$:false,  Debug: false, opera: false, prompt: false, WSH: false */
var progressInterval , checkPasswordInterval;

function stopFakingIt() {
	'use strict';
	clearInterval(progressInterval);
	$('div').removeClass('animate');
}

function checkPassword() {
	'use strict';
	$.getJSON('password_there.json', function(data) {
		if(!$.isEmptyObject(data)){
			if(data.finished){
				stopFakingIt();
				if(data.found){
					alert("The password is :" + data.password);
				}else{
					alert("Sorry the entire dictionary"
						+"has been attempted but no password has been found");
				}
			}
		}
	});
}

$(document).ready(function () {
		'use strict';
		var i, calcPerSecond, wordsTried;
		i = 0;
		wordsTried = 0;
		calcPerSecond = 6496;
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
		checkPasswordInterval = setInterval(checkPassword, 5000);
});