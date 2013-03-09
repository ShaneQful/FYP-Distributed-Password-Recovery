/*jslint browser: true, devel: true */
/*global $, jQuery*/
function validateForm() {
    'use strict';
    var doc;
    doc = document.forms.fileform;
    if (doc.tocrack.value === null || doc.tocrack.value === '') {
        alert('You need to upload a document file to crack');
        return false;
    }
    if ($('[name="dict"]:checked').val() === 'other') {
        if (doc.wordlist.value === null || doc.wordlist.value === '') {//Jquery is empty?
            alert('You need to upload a wordlist file to be your dictionary');
            return false;
        }
    }
    return true;
}