// ==UserScript==
// @name         Rockstar ID On Job Pages
// @version      0.1
// @description  Shows a member's Social Club ID on their job page
// @match        https://socialclub.rockstargames.com/job/gtav/*
// @grant        none
// @require      https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js
// ==/UserScript==

(function() {
    'use strict';

    function getCookie(e) {
        for (var t = e + "=", r = decodeURIComponent(document.cookie).split(";"), o = 0; o < r.length; o++) {
            for (var n = r[o];
                 " " == n.charAt(0);) n = n.substring(1);
            if (0 == n.indexOf(t)) return n.substring(t.length, n.length)
        }
        return ""
    }

    setTimeout(function() {
        var $span = $('div.UI__PlayerCard__text span.UI__PlayerCard__username span.markedText');
        if (!$span.length) return;
        var username = $span.text().trim();
        if (!username) return;
        $.ajax({
            method: 'GET',
            url: 'https://scapi.rockstargames.com/profile/getprofile?nickname=' + username + '&maxFriends=3',
            beforeSend: function(request) {
                request.setRequestHeader('Authorization', 'Bearer ' + getCookie('BearerToken'));
                request.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
            }
        })
        .done(function(data) {
            if (data.status !== true) return;
            var accounts = data.accounts || [];
            if (!accounts.length) return;
            var rockstarAccount = accounts[0].rockstarAccount;
            if (!rockstarAccount) return;
            var rockstarId = rockstarAccount.rockstarId;
            if (!rockstarId) return;
            $span.text(username + ' (' + rockstarId + ')');
        });
    }, 3000);
})();