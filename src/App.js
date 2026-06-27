import React, { useState, useEffect, useCallback, useMemo } from "react";
import { supabase } from "./lib/supabase";
import { SEED_TERMS } from "./data/terms";
import TermCard from "./components/TermCard";
import TermModal from "./components/TermModal";
import Header from "./components/Header";
import StatsBar from "./components/StatsBar";

// Normalize Supabase snake_case → camelCase for UI components
function normalizeTerm(t) {
  return {
    ...t,
    useCase: t.useCase || t.use_case || "",
  };
}


const ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("");

export default function App() {
  const [terms, setTerms] = useState(SEED_TERMS);
  const [search, setSearch] = useState("");
  const [selectedLetter, setSelectedLetter] = useState("ALL");
  const [selectedTerm, setSelectedTerm] = useState(null);
  const [activeTab, setActiveTab] = useState("definition");
  const [view, setView] = useState("grid");
  const [loading, setLoading] = useState(false);
  const [toast, setToast] = useState(null);
  const [isOnline, setIsOnline] = useState(navigator.onLine);
  const [favorites, setFavorites] = useState(() => {
    try { return JSON.parse(localStorage.getItem("cyberFavs") || "[]"); }
    catch { return []; }
  });

  // ── PWA Service Worker registration
  useEffect(() => {
    if ("serviceWorker" in navigator) {
      navigator.serviceWorker.register("/sw.js").catch(() => {});
    }
    window.addEventListener("online",  () => setIsOnline(true));
    window.addEventListener("offline", () => setIsOnline(false));
  }, []);

  // ── Supabase real-time fetch + subscription
  useEffect(() => {
    if (!supabase) return; // no env vars → use seed data

    const fetchTerms = async () => {
      setLoading(true);
      const { data, error } = await supabase
        .from("cyber_terms")
        .select("*")
        .order("term", { ascending: true });

      if (!error && data && data.length > 0) {
        setTerms(data.map(normalizeTerm));
      }
      setLoading(false);
    };

    fetchTerms();

    // Real-time subscription — any INSERT/UPDATE/DELETE in Supabase → UI updates instantly
    const channel = supabase
      .channel("cyber_terms_changes")
      .on(
        "postgres_changes",
        { event: "*", schema: "public", table: "cyber_terms" },
        (payload) => {
          if (payload.eventType === "INSERT") {
            setTerms((prev) => [...prev, normalizeTerm(payload.new)].sort((a, b) => a.term.localeCompare(b.term)));
            showToast("✨ নতুন টার্ম যোগ হয়েছে: " + payload.new.term);
          } else if (payload.eventType === "UPDATE") {
            setTerms((prev) => prev.map((t) => (t.id === payload.new.id ? normalizeTerm(payload.new) : t)));
          } else if (payload.eventType === "DELETE") {
            setTerms((prev) => prev.filter((t) => t.id !== payload.old.id));
          }
        }
      )
      .subscribe();

    return () => supabase.removeChannel(channel);
  }, []);

  const showToast = useCallback((msg, type = "info") => {
    setToast({ msg, type });
    setTimeout(() => setToast(null), 3500);
  }, []);

  const toggleFav = useCallback((id) => {
    setFavorites((prev) => {
      const next = prev.includes(id) ? prev.filter((f) => f !== id) : [...prev, id];
      localStorage.setItem("cyberFavs", JSON.stringify(next));
      showToast(prev.includes(id) ? "Favorites থেকে সরানো হয়েছে" : "⭐ Favorites-এ যোগ হয়েছে!");
      return next;
    });
  }, [showToast]);

  const filtered = useMemo(() => {
    return terms.filter((t) => {
      const matchLetter = selectedLetter === "ALL" || t.letter === selectedLetter;
      const q = search.toLowerCase().trim();
      const matchSearch =
        !q ||
        t.term.toLowerCase().includes(q) ||
        t.short?.toLowerCase().includes(q) ||
        t.definition?.toLowerCase().includes(q) ||
        t.tags?.some((tag) => tag.toLowerCase().includes(q)) ||
        t.category?.toLowerCase().includes(q);
      return matchLetter && matchSearch;
    });
  }, [terms, search, selectedLetter]);

  const availableLetters = useMemo(
    () => new Set(terms.map((t) => t.letter)),
    [terms]
  );

  return (
    <div className="min-h-screen bg-gray-950 text-white font-sans relative overflow-x-hidden">
      {/* Cyberpunk grid background */}
      <div
        className="fixed inset-0 pointer-events-none z-0"
        style={{
          backgroundImage:
            "linear-gradient(rgba(0,255,136,.04) 1px,transparent 1px),linear-gradient(90deg,rgba(0,255,136,.04) 1px,transparent 1px)",
          backgroundSize: "48px 48px",
        }}
      />

      {/* Glow orbs */}
      <div className="fixed top-0 left-1/4 w-96 h-96 bg-green-500/5 rounded-full blur-3xl pointer-events-none z-0" />
      <div className="fixed bottom-0 right-1/4 w-96 h-96 bg-cyan-500/5 rounded-full blur-3xl pointer-events-none z-0" />

      <div className="relative z-10">
        <Header
          search={search}
          setSearch={setSearch}
          selectedLetter={selectedLetter}
          setSelectedLetter={setSelectedLetter}
          availableLetters={availableLetters}
          alphabet={ALPHABET}
          view={view}
          setView={setView}
          favorites={favorites}
          isOnline={isOnline}
          loading={loading}
        />

        <main className="max-w-7xl mx-auto px-4 pb-24">
          <StatsBar
            total={terms.length}
            filtered={filtered.length}
            critical={terms.filter((t) => t.risk === "critical").length}
            favCount={favorites.length}
          />

          {/* Loading shimmer */}
          {loading && (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 mt-4">
              {[...Array(6)].map((_, i) => (
                <div key={i} className="h-52 rounded-2xl bg-gray-900 animate-pulse border border-gray-800" />
              ))}
            </div>
          )}

          {/* Empty state */}
          {!loading && filtered.length === 0 && (
            <div className="flex flex-col items-center justify-center py-24 text-gray-500">
              <div className="text-6xl mb-4">🔍</div>
              <p className="text-lg font-semibold">কোনো ফলাফল পাওয়া যায়নি</p>
              <p className="text-sm mt-1">অন্য শব্দ বা অক্ষর দিয়ে সার্চ করুন</p>
              <button
                onClick={() => { setSearch(""); setSelectedLetter("ALL"); }}
                className="mt-4 px-4 py-2 bg-green-500/20 text-green-400 rounded-xl border border-green-500/30 hover:bg-green-500/30 transition text-sm"
              >
                ফিল্টার রিসেট করুন
              </button>
            </div>
          )}

          {/* Terms grid / list */}
          {!loading && filtered.length > 0 && (
            <div className={
              view === "grid"
                ? "grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 mt-4"
                : "flex flex-col gap-3 mt-4"
            }>
              {filtered.map((term) => (
                <TermCard
                  key={term.id}
                  term={term}
                  isFav={favorites.includes(term.id)}
                  compact={view === "list"}
                  onSelect={() => { setSelectedTerm(term); setActiveTab("definition"); }}
                  onFav={() => toggleFav(term.id)}
                />
              ))}
            </div>
          )}
        </main>
      </div>

      {/* Detail modal */}
      {selectedTerm && (
        <TermModal
          term={selectedTerm}
          isFav={favorites.includes(selectedTerm.id)}
          onFav={() => toggleFav(selectedTerm.id)}
          onClose={() => setSelectedTerm(null)}
          activeTab={activeTab}
          setActiveTab={setActiveTab}
        />
      )}

      {/* Toast */}
      {toast && (
        <div className="fixed bottom-6 left-1/2 -translate-x-1/2 z-[300] px-5 py-3 bg-gray-900/95 backdrop-blur border border-green-500/40 rounded-2xl text-sm text-green-400 shadow-xl shadow-green-500/10 transition-all">
          {toast.msg}
        </div>
      )}
    </div>
  );
}
// NOTE: normalizeTerm is imported at top — see below
