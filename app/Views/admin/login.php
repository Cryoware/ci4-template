<!DOCTYPE html>
<html lang="<?= esc(session('lang') ?? 'en') ?>" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= esc($PageTitle ?? 'Admin Login') ?></title>
    <meta name="csrf-token-name" content="<?= csrf_token() ?>">
    <meta name="csrf-token-hash" content="<?= csrf_hash() ?>">
    <style>
        /* Reuse PIN UI styling to keep visuals consistent for both modes */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); color: #fff; min-height: 100vh; display: flex; flex-direction: column; justify-content: center; align-items: center; padding: 20px; }
        #loading-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(13,17,23,0.6); display: none; justify-content: center; align-items: center; z-index: 9999; transition: opacity 0.3s ease; }
        .spinner { width: 40px; height: 40px; border: 4px solid rgba(255,255,255,0.3); border-radius: 50%; border-top-color: #4e73df; animation: spin 1s ease-in-out infinite; }
        @keyframes spin { to { transform: rotate(360deg); } }
        .login-container { background: rgba(30,30,46,0.9); border-radius: 10px; box-shadow: 0 15px 35px rgba(0,0,0,0.5); width: 100%; max-width: 800px; padding: 30px; }
        .logo-section { text-align: center; margin-bottom: 30px; }
        .logo-section img { max-width: 180px; height: auto; }
        .login-form { display: flex; flex-wrap: wrap; gap: 30px; }
        .login-left, .login-right { flex: 1; min-width: 300px; }
        .login-middle { flex: 1; min-width: 300px; }
        h2 { text-align: center; margin-bottom: 20px; font-size: 26px; font-weight: 400; color: #e0e0e0; }
        .input-group { margin-bottom: 16px; }
        .input-group label { display: block; margin-bottom: 8px; font-size: 14px; color: #a0a0a0; }
        .pin-input, .text-input { width: 100%; padding: 15px; background: rgba(255,255,255,0.07); border: 1px solid rgba(255,255,255,0.1); border-radius: 5px; color: white; font-size: 18px; outline: none; transition: all 0.3s; }
        .pin-input { text-align: center; letter-spacing: 8px; }
        .pin-input:focus, .text-input:focus { border-color: #4e73df; box-shadow: 0 0 0 3px rgba(78,115,223,0.3); }
        .keypad { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin-top: 20px; }
        .keypad button { padding: 15px 0; background: rgba(255,255,255,0.08); border: 1px solid rgba(255,255,255,0.1); border-radius: 5px; color: white; font-size: 18px; cursor: pointer; transition: all 0.2s; }
        .keypad button:hover { background: rgba(255,255,255,0.15); transform: translateY(-2px); }
        .keypad button:active { transform: translateY(0); }
        .action-buttons { display: flex; justify-content: space-between; margin-top: 15px; gap: 10px; }
        .action-buttons button { flex: 1; padding: 12px; border: none; border-radius: 5px; font-size: 16px; cursor: pointer; transition: all 0.2s; }
        .btn-clear { background: #6c757d; color: white; }
        .btn-enter { background: #4e73df; color: white; }
        .btn-clear:hover { background: #5a6268; }
        .btn-enter:hover { background: #2e59d9; }
        .notification { padding: 15px; border-radius: 5px; margin-bottom: 20px; display: none; }
        .notification.error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .agreement { margin-top: 30px; padding: 20px; background: rgba(255,255,255,0.05); border-radius: 5px; display: none; }
        .agreement-content { max-height: 200px; overflow-y: auto; margin: 15px 0; padding: 15px; background: rgba(0,0,0,0.2); border-radius: 5px; font-size: 14px; line-height: 1.6; }
        footer { margin-top: 30px; text-align: center; font-size: 14px; color: #a0a0a0; width: 100%; max-width: 800px; }
        @media (max-width: 768px) { .login-form { flex-direction: column; } .login-left, .login-right { min-width: 100%; } }
    </style>
</head>
<body>
<div id="loading-overlay"><div class="spinner"></div></div>
<div class="login-container" id="login-container">
    <div class="logo-section">
        <img src="/assets/images/oilcop-g2-logo.png" height="150" alt="<?= config('App')->appName ?>"/>
    </div>

    <div class="login-form">
        <?php if (!empty($usePinLogin)): ?>
        <div class="login-left">
            <h2><?= esc(($usePinLogin ?? true) ? (lang('Lang.secure_login_portal') ?? 'Secure Login Portal') : 'Sign in') ?></h2>
            <?php if (!empty($agree)): ?>
                <p style="text-align:center;margin-bottom:12px;color:#a0a0a0;">By signing in you agree to the Terms of Use and Privacy Policy.</p>
            <?php endif; ?>

            <div class="notification error" id="error-notification" role="alert" aria-live="assertive" <?= empty($flashError) ? 'style="display:none;"' : '' ?>>
                <div class="error-message" id="error-message"><?= esc($flashError ?? '') ?></div>
            </div>

                <p style="text-align:center;margin-bottom:20px;color:#a0a0a0;"><?= lang('Lang.enter_secure_pin') ?? 'Enter your secure PIN' ?></p>
                <div class="input-group">
                    <label for="pin-input"><?= lang('Lang.enter_pin_label') ?? 'PIN'?></label>
                    <input type="password" id="pin-input" class="pin-input" maxlength="10" autocomplete="one-time-code" inputmode="numeric" pattern="[0-9]*" enterkeyhint="done">
                </div>
                <div class="action-buttons">
                    <button class="btn-clear" id="btn-clear" type="button"><?= lang('Lang.clear') ?? 'Clear' ?></button>
                    <button class="btn-enter" id="btn-enter" type="button" aria-busy="false"><?= lang('Lang.enter') ?? 'Enter' ?></button>
                </div>
        </div>
        <div class="login-right">
            <h2><?= lang('Lang.keypad') ?? 'Keypad' ?></h2>
            <div class="keypad">
                <button data-key="1" type="button">1</button>
                <button data-key="2" type="button">2</button>
                <button data-key="3" type="button">3</button>
                <button data-key="4" type="button">4</button>
                <button data-key="5" type="button">5</button>
                <button data-key="6" type="button">6</button>
                <button data-key="7" type="button">7</button>
                <button data-key="8" type="button">8</button>
                <button data-key="9" type="button">9</button>
                <button data-key="backspace" type="button" aria-label="Backspace">⌫</button>
                <button data-key="0" type="button">0</button>
                <button data-key="clear" type="button"><?= lang('Lang.clear') ?? 'Clear' ?></button>
            </div>
        </div>
        <?php else: ?>
        <div class="login-middle">
            <div class="notification error" id="error-notification" role="alert" aria-live="assertive" <?= empty($flashError) ? 'style="display:none;"' : '' ?>>
                <div class="error-message" id="error-message"><?= esc($flashError ?? '') ?></div>
            </div>
            <form id="login-form" method="post" action="<?= site_url('admin/v2/check_login') ?>">
                <?= csrf_field() ?>
                <div class="input-group">
                    <label for="email">Email</label>
                    <input name="email" type="email" id="email" class="text-input" autocomplete="username" value="<?= esc(old('email') ?? '') ?>">
                </div>
                <div class="input-group">
                    <label for="password">Password</label>
                    <input name="password" type="password" id="password" class="text-input" autocomplete="current-password">
                </div>
                <div class="action-buttons">
                    <button class="btn-clear" id="btn-clear" type="button">Clear</button>
                    <button class="btn-enter" id="btn-enter" type="submit" aria-busy="false">Sign In</button>
                </div>
            </form>
        </div>
        <?php endif; ?>
    </div>

    <div class="agreement" id="agreement" role="dialog" aria-modal="true" aria-labelledby="agreement-title" tabindex="-1" style="display:none;">
        <h3 id="agreement-title"><?= lang('Lang.user_agreement') ?? 'User Agreement' ?></h3>
        <div class="agreement-content">
            <p><?= lang('Lang.user_agreement_p1') ?? 'Terms ...' ?></p>
            <p><?= lang('Lang.user_agreement_p2') ?? '' ?></p>
            <p><?= lang('Lang.user_agreement_p3') ?? '' ?></p>
        </div>
        <div class="action-buttons">
            <button class="btn-clear" id="btn-decline" type="button"><?= lang('Lang.decline') ?? 'Decline' ?></button>
            <button class="btn-enter" id="btn-accept" type="button"><?= lang('Lang.accept') ?? 'Accept' ?></button>
        </div>
    </div>
</div>

<footer>
    <div class="footer-content"><?= config('App')->appName ?> | <?= lang('Lang.version') ?? 'Version' ?>: <?= get_app_version() ?></div>
    <div class="footer-content">© <?= lang('Lang.copyright') ?? 'Copyright' ?> 2014-2025 | <?= lang('Lang.all_rights_reserved') ?? 'All rights reserved' ?></div>
</footer>

<script>
const USE_PIN = <?= !empty($usePinLogin) ? 'true' : 'false' ?>;
const csrfNameMeta = document.querySelector('meta[name="csrf-token-name"]');
const csrfHashMeta = document.querySelector('meta[name="csrf-token-hash"]');
const getCsrfPair = () => ({ name: csrfNameMeta?.getAttribute('content') || '<?= csrf_token() ?>', hash: csrfHashMeta?.getAttribute('content') || '<?= csrf_hash() ?>' });

// Element references
const overlay = document.getElementById('loading-overlay');
const errorBox = document.getElementById('error-notification');
const errorMsg = document.getElementById('error-message');
const btnEnter = document.getElementById('btn-enter');
const btnClear = document.getElementById('btn-clear');
const keypadButtons = document.querySelectorAll('.keypad button');
const agreementSection = document.getElementById('agreement');
const btnDecline = document.getElementById('btn-decline');
const btnAccept  = document.getElementById('btn-accept');

// Display constants
const DISPLAY_BLOCK = 'block';
const DISPLAY_NONE = 'none';

// Visibility helper
function setVisible(el, visible) {
  if (!el) return;
  el.style.display = visible ? (el.id === 'loading-overlay' ? 'flex' : 'block') : 'none';
}

function showGlobalLoading(dim = true) {
  if (overlay) {
    overlay.style.background = dim ? 'rgba(13,17,23,0.6)' : overlay.style.background;
    setVisible(overlay, true);
  }
}

function hideGlobalLoading() { setVisible(overlay, false); }

function showError(message) {
  if (!errorBox || !errorMsg) return;
  errorMsg.textContent = String(message || 'An error occurred');
  setVisible(errorBox, true);
  errorBox.setAttribute('role', 'alert');
  errorBox.setAttribute('aria-live', 'assertive');
}

function clearErrors() { if (errorBox) setVisible(errorBox, false); }

function disableUI(disabled){
  btnEnter && (btnEnter.disabled = disabled);
  btnClear && (btnClear.disabled = disabled);
  keypadButtons.forEach(b => b.disabled = disabled);
}

btnClear?.addEventListener('click', () => {
  if (USE_PIN){ document.getElementById('pin-input').value=''; }
  else { document.getElementById('email').value=''; document.getElementById('password').value=''; }
  clearErrors();
});

// Unified login via API for both PIN and Email/Password
const API_LOGIN_URL = "<?= site_url('api/v1/auth/login') ?>";
const API_AGREE_URL = "<?= site_url('api/v1/auth/agreement/accept') ?>";
let lastLoginPayload = null;

async function submitLogin(payload) {
  clearErrors();
  showGlobalLoading(true);
  disableUI(true);
  lastLoginPayload = payload;

  // include CSRF if available (harmless for API; useful if filters are on)
  const csrf = getCsrfPair();
  const body = { ...payload, [csrf.name]: csrf.hash };

  try {
    const resp = await fetch(API_LOGIN_URL, {
      method:'POST',
      headers:{
        'Content-Type':'application/json; charset=UTF-8',
        'Accept':'application/json',
        'X-Requested-With':'XMLHttpRequest'
      },
      credentials:'same-origin',
      body: JSON.stringify(body)
    });

    const data = await resp.json().catch(() => ({}));

    if (resp.status === 428 && (data?.data?.agreement_required || data?.agreement_required)) {
      setVisible(agreementSection, true);
      return;
    }

    if (!resp.ok || data?.success === false) {
      const msg = data?.message || data?.error || 'Login failed';
      showError(msg);
      return;
    }

    // Success path: redirect is provided in data.data.redirect or data.redirect
    const redirect = data?.data?.redirect || data?.redirect || "<?= site_url('/dashboard') ?>";
    window.location.href = redirect;
  } catch (e) {
    showError('Network error');
  } finally {
    disableUI(false);
    hideGlobalLoading();
  }
}

async function submitAgreementAccept() {
  if (!lastLoginPayload) {
    setVisible(agreementSection, false);
    return;
  }
  clearErrors();
  showGlobalLoading(true);
  disableUI(true);

  try {
    const csrf = getCsrfPair();
    const resp = await fetch(API_AGREE_URL, {
      method:'POST',
      headers:{
        'Content-Type':'application/json; charset=UTF-8',
        'Accept':'application/json',
        'X-Requested-With':'XMLHttpRequest'
      },
      credentials:'same-origin',
      body: JSON.stringify({ ...lastLoginPayload, [csrf.name]: csrf.hash })
    });

    const data = await resp.json().catch(() => ({}));
    if (!resp.ok || data?.success === false) {
      const msg = data?.message || data?.error || 'Could not accept agreement';
      showError(msg);
      return;
    }

    const redirect = data?.data?.redirect || data?.redirect || "<?= site_url('/dashboard') ?>";
    window.location.href = redirect;
  } catch (e) {
    showError('Network error while accepting agreement');
  } finally {
    disableUI(false);
    hideGlobalLoading();
    setVisible(agreementSection, false);
  }
}

// Wire agreement buttons for BOTH flows (PIN and Email/Password)
btnDecline?.addEventListener('click', () => {
  setVisible(agreementSection, false);
  clearErrors();
});
btnAccept?.addEventListener('click', () => {
  submitAgreementAccept();
});

// Progressive enhancement: intercept email/password form submit and send via API
document.getElementById('login-form')?.addEventListener('submit', (e) => {
  e.preventDefault();
  const email = (document.getElementById('email')?.value || '').trim();
  const password = (document.getElementById('password')?.value || '');
  submitLogin({ email, password });
});

if (USE_PIN) {
  // keypad input UX
  keypadButtons.forEach(btn => btn.addEventListener('click', () => {
    const input = document.getElementById('pin-input');
    if (!input) return;
    const key = btn.getAttribute('data-key');
    if (key === 'backspace'){ input.value = input.value.slice(0,-1); clearErrors(); return; }
    if (key === 'clear'){ input.value=''; clearErrors(); return; }
    if (/^\d$/.test(key) && input.value.length < 10){ input.value += key; clearErrors(); }
  }));

  // PIN submit uses the same API as email/password
  btnEnter?.addEventListener('click', () => {
    const pin = (document.getElementById('pin-input').value || '').replace(/\D/g,'').slice(0,10);
    submitLogin({ pin });
  });

  btnDecline?.addEventListener('click', () => {
    setVisible(agreementSection, false);
    clearErrors();
  });

  // Note: btnDecline/btnAccept listeners are now global (above).
}
</script>
</body>
</html>
