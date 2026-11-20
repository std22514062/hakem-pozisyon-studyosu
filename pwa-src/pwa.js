/* Kurulabilir uygulama: servis çalışanı, "Uygulamayı yükle" düğmesi, iPhone yönergesi, güncelleme bildirimi */
(() => {
  const standalone = matchMedia('(display-mode: standalone)').matches || matchMedia('(display-mode: window-controls-overlay)').matches || navigator.standalone === true;
  const ua = navigator.userAgent, ios = /iphone|ipad|ipod/i.test(ua) || (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1);
  const top = document.querySelector('.top');
  let deferred = null;

  const btn = document.createElement('button');
  btn.type = 'button'; btn.className = 'installbtn'; btn.hidden = true;
  btn.innerHTML = '<svg width="14" height="14" viewBox="0 0 14 14" aria-hidden="true"><path d="M7 1v8M3.5 5.5 7 9l3.5-3.5M2 12.5h10" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/></svg><span>Uygulamayı yükle</span>';
  if (top) top.appendChild(btn);

  const sheet = document.createElement('div');
  sheet.className = 'iossheet'; sheet.hidden = true; sheet.setAttribute('role', 'dialog'); sheet.setAttribute('aria-label', 'iPhone ve iPad için yükleme');
  sheet.innerHTML = '<b>Ana ekrana ekle</b><ol><li>Safari\'nin alt çubuğundaki <b>Paylaş</b> düğmesine dokun <svg width="14" height="16" viewBox="0 0 14 16" aria-hidden="true"><path d="M7 1v9M4 4l3-3 3 3M3 7H2v8h10V7h-1" fill="none" stroke="currentColor" stroke-width="1.5"/></svg></li><li>Listeden <b>Ana Ekrana Ekle</b>\'yi seç</li><li>Sağ üstte <b>Ekle</b>\'ye dokun</li></ol><button type="button" class="btn">Tamam</button>';
  document.body.appendChild(sheet);
  sheet.querySelector('button').addEventListener('click', () => { sheet.hidden = true; });

  if (!standalone) {
    window.addEventListener('beforeinstallprompt', e => { e.preventDefault(); deferred = e; btn.hidden = false; });
    if (ios) btn.hidden = false;
  }
  btn.addEventListener('click', async () => {
    if (deferred) { deferred.prompt(); const r = await deferred.userChoice.catch(() => null); deferred = null; if (r && r.outcome === 'accepted') btn.hidden = true; return; }
    if (ios) sheet.hidden = !sheet.hidden;
  });
  window.addEventListener('appinstalled', () => { btn.hidden = true; if (typeof toast === 'function') toast('Uygulama yüklendi'); });

  // çevrimdışı / çevrimiçi bilgisi
  window.addEventListener('offline', () => { if (typeof toast === 'function') toast('İnternet yok: uygulama çevrimdışı çalışmaya devam ediyor'); });

  if (!('serviceWorker' in navigator) || location.protocol === 'file:') return;
  window.addEventListener('load', async () => {
    try {
      const reg = await navigator.serviceWorker.register('sw.js');
      const offer = w => {
        const bar = document.createElement('div'); bar.className = 'updbar'; bar.setAttribute('role', 'status');
        bar.innerHTML = '<span>Yeni sürüm hazır.</span><button type="button">Yenile</button>';
        bar.querySelector('button').addEventListener('click', () => w.postMessage('skipWaiting'));
        document.body.appendChild(bar);
      };
      if (reg.waiting && navigator.serviceWorker.controller) offer(reg.waiting);
      reg.addEventListener('updatefound', () => {
        const w = reg.installing; if (!w) return;
        w.addEventListener('statechange', () => { if (w.state === 'installed' && navigator.serviceWorker.controller) offer(w); });
      });
      let reloaded = false;
      navigator.serviceWorker.addEventListener('controllerchange', () => { if (!reloaded) { reloaded = true; location.reload(); } });
      setInterval(() => reg.update().catch(() => { }), 60 * 60 * 1000);
    } catch (e) { /* servis çalışanı olmadan da uygulama çalışır */ }
  });
})();
