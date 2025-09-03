/*
 * UIBusy: Lightweight UI busy/overlay helper for async operations
 * - Shows a full-screen overlay with spinner (reuses #loading-overlay if present)
 * - Disables/enables elements, sets aria-busy, and can swap button text while busy
 * - Provides convenience methods to wrap async functions/promises
 *
 * Usage (global):
 *   <script src="js/ui-busy.js"></script>
 *   // Then use window.UIBusy.showOverlay(), window.UIBusy.start({...}), etc.
 */
(function (window, document) {
  'use strict';

  function toArray(input) {
    if (!input) return [];
    if (Array.isArray(input)) return input.filter(Boolean);
    // Accept single selector or element or NodeList
    if (typeof input === 'string') return Array.from(document.querySelectorAll(input));
    if (input instanceof NodeList || input instanceof HTMLCollection) return Array.from(input);
    return [input];
  }

  function ensureOverlay() {
    // If an overlay exists in the DOM already, use it
    let el = document.getElementById('loading-overlay');
    if (el) return el;

    // Create a minimal overlay and spinner if none exists
    el = document.createElement('div');
    el.id = 'loading-overlay';
    el.style.position = 'fixed';
    el.style.top = '0';
    el.style.left = '0';
    el.style.width = '100%';
    el.style.height = '100%';
    el.style.background = '#0d1117';
    el.style.display = 'none';
    el.style.justifyContent = 'center';
    el.style.alignItems = 'center';
    el.style.zIndex = '9999';
    el.style.transition = 'opacity 0.3s ease';

    const spinner = document.createElement('div');
    spinner.className = 'spinner';
    spinner.style.width = '50px';
    spinner.style.height = '50px';
    spinner.style.border = '5px solid rgba(255, 255, 255, 0.3)';
    spinner.style.borderRadius = '50%';
    spinner.style.borderTopColor = '#4e73df';
    spinner.style.animation = 'ui-busy-spin 1s ease-in-out infinite';

    // Fallback keyframes if page doesn't define them
    const styleEl = document.createElement('style');
    styleEl.textContent = '@keyframes ui-busy-spin { to { transform: rotate(360deg); } }';
    document.head.appendChild(styleEl);

    el.appendChild(spinner);
    document.body.appendChild(el);
    return el;
  }

  function setAriaBusy(el, busy) {
    try {
      el.setAttribute('aria-busy', busy ? 'true' : 'false');
    } catch (_) { /* no-op */ }
  }

  const UIBusy = {
    _overlayEl: null,

    showOverlay(options) {
      const opts = options || {};
      const dim = opts.dim !== false; // default true
      const el = this._overlayEl = ensureOverlay();
      if (dim) {
        el.style.background = 'rgba(13, 17, 23, 0.6)';
      }
      el.style.display = 'flex';
      // Force reflow before setting opacity for transition
      // eslint-disable-next-line no-unused-expressions
      el.offsetHeight;
      el.style.opacity = '1';
    },

    hideOverlay() {
      const el = this._overlayEl || document.getElementById('loading-overlay');
      if (!el) return;
      el.style.opacity = '0';
      setTimeout(function () {
        el.style.display = 'none';
        el.style.background = '#0d1117';
      }, 300);
    },

    /**
     * Disables given elements and optionally swaps their text content while busy.
     * Returns an unlock() function that restores original state.
     * @param elements array|selector|Element
     * @param options { busyText?: string }
     */
    lock(elements, options) {
      const opts = options || {};
      const busyText = opts.busyText; // string applied to all textual elements
      const list = toArray(elements);
      const originals = [];

      list.forEach(function (el) {
        if (!el || typeof el !== 'object') return;
        const original = {
          el: el,
          disabled: !!el.disabled,
          ariaBusy: el.getAttribute && el.getAttribute('aria-busy'),
        };
        // Store original textContent only for elements that are likely to display text
        if (typeof el.textContent === 'string') {
          original.text = el.textContent;
        }
        originals.push(original);

        try { el.disabled = true; } catch (_) { }
        setAriaBusy(el, true);
        if (busyText && typeof el.textContent === 'string') {
          el.textContent = busyText;
        }
      });

      // Return unlock
      return function unlock() {
        originals.forEach(function (o) {
          try { o.el.disabled = o.disabled; } catch (_) { }
          if (o.ariaBusy == null) {
            o.el.removeAttribute && o.el.removeAttribute('aria-busy');
          } else {
            o.el.setAttribute && o.el.setAttribute('aria-busy', o.ariaBusy);
          }
          if (Object.prototype.hasOwnProperty.call(o, 'text') && typeof o.text === 'string') {
            try { o.el.textContent = o.text; } catch (_) { }
          }
        });
      };
    },

    /**
     * Convenience: starts overlay/lock and returns a controller with stop(success)
     */
    start(options) {
      const opts = options || {};
      const elements = opts.elements || [];
      const overlay = opts.overlay !== false; // default true
      const dim = opts.dim !== false;         // default true
      const keepLockedOnSuccess = !!opts.keepLockedOnSuccess;
      const unlock = this.lock(elements, { busyText: opts.busyText });
      if (overlay) this.showOverlay({ dim: dim });

      const self = this;
      return {
        stop: function (success) {
          if (!success || !keepLockedOnSuccess) {
            try { unlock(); } catch (_) { }
          }
          if (overlay) self.hideOverlay();
        }
      };
    },

    /**
     * Wrap a promise or async function with overlay + element lock.
     * @param task function|Promise
     * @param options same as start()
     */
    async run(task, options) {
      const ctrl = this.start(options);
      try {
        const result = (typeof task === 'function') ? await task() : await task;
        ctrl.stop(true);
        return result;
      } catch (e) {
        ctrl.stop(false);
        throw e;
      }
    }
  };

  // Expose globally
  window.UIBusy = UIBusy;

})(window, document);
