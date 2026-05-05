// ==UserScript==
// @name         Shortcut: hide story sidebar
// @namespace    z-dev/dotfiles
// @match        https://app.shortcut.com/*
// @run-at       document-end
// @grant        GM_addStyle
// @version      0.4-debug
// @description  Hide the right-hand metadata column on the story view so the description fills the width.
// ==/UserScript==

(function () {
  'use strict';

  console.log('[shortcut-hide-sidebar] v0.4-debug loaded');

  GM_addStyle(`
    /* CANARY — remove once confirmed loading. If you see a lime outline
       around the page, the script is running and CSS injection works. */
    body { outline: 4px solid lime !important; outline-offset: -4px !important; }

    /* Try several selector shapes; whichever matches wins. */
    .right-column.r_react,
    .story-dialog .right-column,
    .modal-dialog .right-column {
      display: none !important;
    }

    /* Sidebar is position:absolute, so reset margin/padding on whatever
       holds the content so it can fill the width. */
    .story-dialog .story-information,
    .story-dialog .title-container,
    .story-dialog .async-details,
    .story-dialog .story-details,
    .story-details .left-column {
      margin-right: 0 !important;
      padding-right: 0 !important;
    }
  `);
})();
