const CACHE_NAME = 'memo-pwa-v8';
const PRECACHE = [
  './',
  './index.html',
  './manifest.webmanifest',
  './icon-192.png',
  './icon-512.png',
  './maskable-512.png',
  './apple-touch-icon.png'
];

self.addEventListener('install', e => {
  e.waitUntil(
    caches.open(CACHE_NAME).then(cache => cache.addAll(PRECACHE)).catch(() => {})
  );
  self.skipWaiting();
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k)))
    ).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;

  // 页面导航：网络优先，保证线上总是最新版；离线时回退到缓存主页面
  if (req.mode === 'navigate' || req.headers.get('accept').includes('text/html')) {
    e.respondWith(
      fetch(req).then(res => {
        const copy = res.clone();
        caches.open(CACHE_NAME).then(c => c.put('./index.html', copy)).catch(() => {});
        return res;
      }).catch(() => caches.match('./index.html').then(r => r || fetch(req)))
    );
    return;
  }

  // 静态资源：缓存优先，命中后后台更新
  e.respondWith(
    caches.match(req).then(resp => {
      if (resp) {
        fetch(req).then(res => caches.open(CACHE_NAME).then(c => c.put(req, res.clone())).catch(() => {})).catch(() => {});
        return resp;
      }
      return fetch(req).then(res => {
        if (res && res.ok) {
          const copy = res.clone();
          caches.open(CACHE_NAME).then(c => c.put(req, copy)).catch(() => {});
        }
        return res;
      }).catch(() => resp);
    })
  );
});
