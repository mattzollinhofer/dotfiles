// ==UserScript==
// @name         Shortcut: hide story sidebar in narrow windows
// @namespace    https://github.com/mattzollinhofer/dotfiles
// @match        https://app.shortcut.com/*
// @run-at       document-end
// @grant        GM_addStyle
// @version      1.2
// @description  Hide the metadata sidebar on Shortcut story views so the description fills the modal in narrow browser windows.
// ==/UserScript==

(function () {
  'use strict';

  GM_addStyle(`
    @media (max-width: 899px) {
      .story-dialog .right-column { display: none !important; }

      /* Constrain the modal and its wrappers to the available viewport
         instead of their intrinsic widths. */
      .scrollable-content,
      .story-container,
      .modal-dialog,
      .story-dialog {
        max-width: 100% !important;
        min-width: 0 !important;
        box-sizing: border-box !important;
      }

      /* Inner content fills the modal width. width:100% (not just
         max-width) is needed to override narrower width rules. */
      .story-dialog,
      .story-dialog .story-details,
      .story-dialog .left-column,
      .story-dialog .title-container,
      .story-dialog .async-details,
      .story-dialog .story-information {
        width: 100% !important;
        max-width: 100% !important;
        margin-right: 0 !important;
        padding-right: 0 !important;
        box-sizing: border-box !important;
      }
    }
  `);
})();
