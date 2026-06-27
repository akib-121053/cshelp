/* CyberSec Dictionary — Service Worker (PWA Offline Support) */
const CACHE_NAME = "cybersec-dict-v1";
const STATIC_ASSETS = ["/", "/index.html", "/static/js/main.chunk.js", "/static/css/main.chunk.css", "/manifest.json"];

self.addEventListener("install", (e) => {
  e.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(STATIC_ASSETS))
  );
  self.skipWaiting();
});

self.addEventListener("activate", (e) => {
  e.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener("fetch", (e) => {
  if (e.request.url.includes("supabase.co")) return; // Supabase — always network
  e.respondWith(
    caches.match(e.request).then((cached) => cached || fetch(e.request))
  );
});
