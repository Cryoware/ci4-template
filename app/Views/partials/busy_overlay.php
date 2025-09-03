<!-- Busy overlay -->
<div id="pageBusyOverlay" aria-hidden="true">
    <div class="ai-busy-spinner" role="status" aria-live="polite" aria-label="Loading"></div>
</div>

<style>
    #pageBusyOverlay {
        position: fixed;
        inset: 0;
        background: rgba(0,0,0,0.35);
        display: none;
        align-items: center;
        justify-content: center;
        z-index: 2000; /* above navbar/sidebar/cards */
        transition: opacity .15s ease-in-out;
    }
    #pageBusyOverlay.show { display: flex; }
    .ai-busy-spinner {
        width: 3rem;
        height: 3rem;
        border: .35rem solid rgba(255,255,255,0.5);
        border-top-color: #ffffff;
        border-radius: 50%;
        animation: ai-spin 1s linear infinite;
    }
    @keyframes ai-spin { to { transform: rotate(360deg); } }
</style>

<script>
    (function () {
        const overlay = document.getElementById('pageBusyOverlay');
        const show = () => { if (overlay) overlay.classList.add('show'); };
        const hide = () => { if (overlay) overlay.classList.remove('show'); };

        // Show overlay on any form submit and prevent double-submits
        document.addEventListener('submit', function (e) {
            const form = e.target;
            if (!(form instanceof HTMLFormElement)) return;

            // prevent double submit
            if (form.dataset.submitting === '1') {
                e.preventDefault();
                return;
            }
            form.dataset.submitting = '1';
            show();
        }, true);

        // Optional: show overlay for refresh triggers
        document.addEventListener('click', function (e) {
            const trigger = e.target.closest('[data-action="refresh"]');
            if (trigger) {
                show();
                // If it's a button (not a link), perform a reload
                if (trigger.tagName === 'BUTTON') {
                    location.reload();
                }
                // If it's a link, the navigation will happen naturally
            }
        });

        // When navigating back from bfcache, ensure overlay is hidden and flags reset
        window.addEventListener('pageshow', function () {
            hide();
            document.querySelectorAll('form[data-submitting="1"]').forEach(f => f.dataset.submitting = '0');
        });
    })();
</script>
