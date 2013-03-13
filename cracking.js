/*jslint browser: true, devel: true */
/*global $, jQuery*/
var progressInterval, checkPasswordInterval, calcPerSecond, dictionarySize, timeouts;

function stopFakingIt() {
    'use strict';
    clearInterval(progressInterval);
    $.each(timeouts, function () {
        clearTimeout(this);
    });
    $('div').removeClass('animate');
}

function togglePassword() {
    'use strict';
    var btnName;
    $('#pass').toggle('blind');
    btnName = $('#pass-btn').html();
    if (btnName.indexOf('Show') === -1) {
        btnName = btnName.replace('Hide', 'Show');
        $('#pass-btn').html(btnName);
    } else {
        btnName = btnName.replace('Show', 'Hide');
        $('#pass-btn').html(btnName);
    }
}

function checkPassword() {
    'use strict';
    $.getJSON('done.json', function (data) {
        if (!$.isEmptyObject(data)) {
            if (data.finished) {
                stopFakingIt();
                clearInterval(checkPasswordInterval);
                if (data.found) {
                    $('#found').show('blind');
                    $('#stop-btn').hide('blind');
                    $('#pass').html(data.password);
                    alert('The password for the file was found');
                } else {
                    alert('Sorry the entire dictionary'
                        + 'has been attempted but no password has been found');
                }
            }
        }
    });
}

function changeStatus() {
    'use strict';
    timeouts.push(setTimeout(function () {
        $('#wh').text('Searching for worker nodes');
    }, 1000));
    timeouts.push(setTimeout(function () {
        $('#wh').text('Sending file to discovered nodes');
    }, 17000));
    timeouts.push(setTimeout(function () {
        $('#wh').text('Starting to crack document');
    }, 21000));
    timeouts.push(setTimeout(function () {
        $('#wh').text('Cracking document ...');
    }, 22000));
}

function startCracking(){
    'use strict';
    var wordsTried;
    wordsTried = 0;
    progressInterval = setInterval(function () {
        var percent = 100 * (wordsTried / dictionarySize);
        if (percent >= 100) {
            stopFakingIt();
            percent = 100;
        }
        $('#bar').css('width', percent + '%');
        $('#cs').text(calcPerSecond + (Math.random() * 20) + ' c/s');
        $('#words').text(wordsTried + ' words');
        wordsTried += calcPerSecond / 2;
    }, 500);
    checkPassword();//Useful the file has already been cracked
    checkPasswordInterval = setInterval(checkPassword, 5000);
}

$(document).ready(function () {
    'use strict';
    timeouts = [];
    changeStatus();
    timeouts.push(setTimeout(function () {
        startCracking();
    },21000));
});
