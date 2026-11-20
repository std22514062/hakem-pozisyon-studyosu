/* Hakem Pozisyon Stüdyosu — servis çalışanı
   Uygulama kabuğu ve 3D kütüphanesi ilk açılışta önbelleğe alınır; sonra internet olmadan da çalışır.
   Sayfa ağdan önce denenir (yeni sürüm hemen gelsin), kütüphane ve yazı tipleri önce önbellekten gelir. */
const VERSION = '20261120103606';
const CACHE = 'hps-' + VERSION;
const SHELL = ['./', './index.html', './pwa.js?v=20261120103606', './pwa.css?v=20261120103606', './manifest.webmanifest', './icons/icon.svg', './icons/icon-192.png', './icons/icon-512.png', './icons/maskable-512.png', './icons/apple-touch-icon.png'];
const CDN = [
  'https://cdn.jsdelivr.net/npm/three@0.147.0/build/three.min.js',
  'https://cdn.jsdelivr.net/npm/three@0.147.0/examples/js/controls/OrbitControls.js'
];

self.addEventListener('install', e => {
  e.waitUntil((async () => {
    const c = await caches.open(CACHE);
    await c.addAll(SHELL);
    await Promise.all(CDN.map(async u => { try { const r = await fetch(new Request(u, { mode: 'cors' })); if (r.ok) await c.put(u, r); } catch (_) { } }));
  })());
});

self.addEventListener('activate', e => {
  e.waitUntil((async () => {
    for (const k of await caches.keys()) if (k.startsWith('hps-') && k !== CACHE) await caches.delete(k);
    await self.clients.claim();
  })());
});

self.addEventListener('message', e => { if (e.data === 'skipWaiting') self.skipWaiting(); });

const putSafe = async (req, res) => { if (res && (res.ok || res.type === 'opaque')) { const c = await caches.open(CACHE); await c.put(req, res.clone()); } return res; };

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);
  // sayfanın kendisi: önce ağ, olmazsa önbellek
  if (req.mode === 'navigate') {
    e.respondWith((async () => {
      try { return await putSafe('./index.html', await fetch(req)); }
      catch (_) { return (await caches.match('./index.html')) || (await caches.match('./')) || Response.error(); }
    })());
    return;
  }
  // sürümü sabit kütüphaneler ve yazı tipi dosyaları: önce önbellek
  if (url.hostname === 'cdn.jsdelivr.net' || url.hostname === 'fonts.gstatic.com' || url.origin === self.location.origin) {
    e.respondWith((async () => (await caches.match(req)) || putSafe(req, await fetch(req)))());
    return;
  }
  // yazı tipi CSS'i: önbellekten hemen ver, arkada tazele
  if (url.hostname === 'fonts.googleapis.com') {
    e.respondWith((async () => {
      const hit = await caches.match(req);
      const net = fetch(req).then(r => putSafe(req, r)).catch(() => null);
      return hit || (await net) || Response.error();
    })());
  }
});
