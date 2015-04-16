// Modified from markdown.js from Hakim to handle external html files
(function () {
    /*jslint loopfunc: true, browser: true*/
    /*globals alert*/
    'use strict';

    var querySlidingHtml = function () {
        var sections = document.querySelectorAll('[data-html]'),
            section, j, jlen;

        for (j = 0, jlen = sections.length; j < jlen; j++) {
            section = sections[j];

            if (section.getAttribute('data-html').length) {

                var xhr = new XMLHttpRequest(),
                    url = section.getAttribute('data-html'),
                    cb = function () {
                        var backgroundImage;

                        if (xhr.readyState === 4) {
                            if (xhr.status >= 200 && xhr.status < 300) {
                                section.innerHTML = xhr.responseText;
                                if (backgroundImage = section.querySelectorAll("img[data-background-image]").item(0)) {
                                    section.setAttribute(
                                        'data-background-image',
                                        backgroundImage.getAttribute('src')
                                    );

                                    backgroundImage.parentNode.removeChild(backgroundImage);
                                }
                            } else {
                                section.outerHTML = '<section data-state="alert">ERROR: The attempt to fetch ' + url + ' failed with the HTTP status ' + xhr.status + '. Check your browser\'s JavaScript console for more details.</p></section>';
                            }
                        }
                    };

                xhr.onreadystatechange = cb;

                xhr.open('GET', url, false);
                try {
                    xhr.send();
                } catch (e) {
                    alert('Failed to get file' + url + '.' + e);
                }
            }
        }
    };

    querySlidingHtml();
})();
