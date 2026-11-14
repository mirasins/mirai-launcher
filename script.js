/* Optional enhancement. Content, downloads and navigation work without JavaScript. */
(() => {
  'use strict';
  const preference = window.matchMedia('(prefers-reduced-motion: reduce)');
  const toggle = document.getElementById('motion-toggle');
  const seen = new WeakSet();
  let paused = false;
  let observer;

  function stop() {
    if (observer) observer.disconnect();
    observer = undefined;
    document.querySelectorAll('.is-entering').forEach(element => element.classList.remove('is-entering'));
  }

  function start() {
    if (observer || !('IntersectionObserver' in window)) return;
    observer = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (!entry.isIntersecting) return;
        const element = entry.target;
        if (!paused && !preference.matches) {
          element.classList.add('is-entering');
          element.addEventListener('animationend', () => element.classList.remove('is-entering'), { once: true });
          seen.add(element);
        }
        observer?.unobserve(element);
      });
    }, { threshold: 0.08 });
    document.querySelectorAll('.reveal').forEach(element => {
      if (!seen.has(element)) observer.observe(element);
    });
  }

  function sync() {
    const reduced = paused || preference.matches;
    document.body.dataset.motion = reduced ? 'off' : 'on';
    if (reduced) stop();
    else start();
    if (toggle) {
      toggle.hidden = preference.matches;
      toggle.setAttribute('aria-pressed', String(paused));
      toggle.textContent = paused ? 'Activar animaciones' : 'Pausar animaciones';
    }
  }

  toggle?.addEventListener('click', () => { paused = !paused; sync(); });
  if (preference.addEventListener) preference.addEventListener('change', sync);
  sync();
})();
