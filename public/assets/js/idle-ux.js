// public/assets/js/idle-ux.js
(function () {
  'use strict';

  // Optional config via window.IdleUXConfig
  const cfg = window.IdleUXConfig || {};
  const INACTIVITY_THRESHOLD = Number(cfg.threshold || 7200); // seconds
  const LOGIN_URL = String(cfg.loginUrl || '/login');
  const COUNTDOWN_SELECTOR = String(cfg.countdownSelector || '#session-countdown');
  const EXCLUDE_URLS = (cfg.excludeKeepAlive || []) // array of regex or strings to ignore as "activity"
    .map(p => (p instanceof RegExp) ? p : new RegExp(String(p)));
  const LOGOUT_URL = String(cfg.logoutUrl || ''); // optional: call this when idle expires

  let lastActivityTs = Date.now();
  let expiredShown = false;

  function markActivity(source) {
    lastActivityTs = Date.now();
    // console.debug('[IdleUX] activity:', source);
  }

  function shouldExclude(url) {
    try {
      const u = String(url || '');
      return EXCLUDE_URLS.some(rx => rx.test(u));
    } catch (_) {
      return false;
    }
  }

  function updateCountdown() {
    const el = COUNTDOWN_SELECTOR ? document.querySelector(COUNTDOWN_SELECTOR) : null;
    if (!el) return;
    const idleSeconds = Math.floor((Date.now() - lastActivityTs) / 1000);
    const remaining = Math.max(0, INACTIVITY_THRESHOLD - idleSeconds);
    if (remaining <= 0) {
      el.textContent = '00:00'; // show zero when expired
      return;
    }
    const mm = String(Math.floor(remaining / 60)).padStart(2, '0');
    const ss = String(remaining % 60).padStart(2, '0');
    el.textContent = `${mm}:${ss}`;
  }

  function idleTick() {
    const idleSeconds = Math.floor((Date.now() - lastActivityTs) / 1000);
    if (idleSeconds >= INACTIVITY_THRESHOLD && !expiredShown) {
      expiredShown = true;
      // Redirect preference: explicit logout if provided, otherwise to login
      if (LOGOUT_URL) {
        window.location.href = LOGOUT_URL;
      } else {
        window.location.href = LOGIN_URL;
      }
      return; // stop further processing after redirect intent
    }
    updateCountdown();
  }

  // Hook common user events
  const userEvents = ['mousemove', 'mousedown', 'keydown', 'scroll', 'touchstart', 'pointerdown'];
  userEvents.forEach(evt => window.addEventListener(evt, () => markActivity(evt), { passive: true }));

  // Treat returning to tab as activity
  document.addEventListener('visibilitychange', () => {
    if (document.visibilityState === 'visible') markActivity('visibility');
  });

  // Patch fetch to both detect timeouts and optionally count as activity
  if (window.fetch) {
    const originalFetch = window.fetch.bind(window);
    window.fetch = async (...args) => {
      try {
        const res = await originalFetch(...args);
        // If server bounced us (e.g., auth filter), follow to login
        if (res.redirected) {
          window.location.href = res.url;
          return res;
        }
        if (res.status === 401 || res.status === 403) {
          window.location.href = LOGIN_URL;
          return res;
        }
        // Count as activity unless excluded
        const req = args[0];
        const url = (typeof req === 'string') ? req : (req && req.url);
        if (!shouldExclude(url)) {
          markActivity('fetch');
        }
        return res;
      } catch (e) {
        // Network errors: ignore for activity; rethrow for caller
        throw e;
      }
    };
  }

  // Optional: legacy XHR patch
  (function patchXHR() {
    if (!('XMLHttpRequest' in window)) return;
    const OrigXHR = window.XMLHttpRequest;
    function XHR() {
      const xhr = new OrigXHR();
      const open = xhr.open;
      let reqUrl = '';
      xhr.open = function (method, url, async, user, password) {
        reqUrl = url || '';
        return open.apply(xhr, arguments);
      };
      xhr.addEventListener('load', function () {
        // If not excluded, count as activity
        if (!shouldExclude(reqUrl)) {
          markActivity('xhr');
        }
        // If the server redirected to login (heuristic)
        try {
          if (this.responseURL && this.responseURL !== window.location.href && (this.status === 200 || this.status === 302)) {
            if (/\/login(\?|$|\/)/.test(this.responseURL)) {
              window.location.href = this.responseURL;
            }
          }
          if (this.status === 401 || this.status === 403) {
            window.location.href = LOGIN_URL;
          }
        } catch (_) { /* noop */ }
      });
      return xhr;
    }
    XHR.prototype = OrigXHR.prototype;
    window.XMLHttpRequest = XHR;
  })();

  // Start local timer
  setInterval(idleTick, 1000);
  updateCountdown();
})();
