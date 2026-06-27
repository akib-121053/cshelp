import React, { useState, useEffect } from "react";
import { RISK_COLORS, CATEGORY_GRADIENTS, TAB_LIST } from "./constants";

export default function TermModal({ term, isFav, onFav, onClose, activeTab, setActiveTab }) {
  const [copied, setCopied] = useState(false);
  const risk = RISK_COLORS[term.risk] || RISK_COLORS.medium;
  const grad = CATEGORY_GRADIENTS[term.category] || "from-gray-500 to-gray-600";

  // Close on Escape key
  useEffect(() => {
    const handler = (e) => { if (e.key === "Escape") onClose(); };
    document.addEventListener("keydown", handler);
    return () => document.removeEventListener("keydown", handler);
  }, [onClose]);

  // Prevent body scroll when modal open
  useEffect(() => {
    document.body.style.overflow = "hidden";
    return () => { document.body.style.overflow = ""; };
  }, []);

  const copyCode = () => {
    navigator.clipboard.writeText(term.code || "").then(() => {
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    });
  };

  const riskWidth = { critical: "100%", high: "75%", medium: "50%", low: "25%" };

  return (
    <div className="fixed inset-0 z-[100] flex items-end sm:items-center justify-center p-0 sm:p-4">
      {/* Backdrop */}
      <div
        className="absolute inset-0 bg-black/75 backdrop-blur-sm"
        onClick={onClose}
      />

      {/* Modal panel */}
      <div className="relative w-full sm:max-w-2xl max-h-[92vh] overflow-y-auto bg-gray-900 border border-gray-700/80 rounded-t-3xl sm:rounded-2xl shadow-2xl shadow-black/50 flex flex-col">

        {/* ── HERO HEADER ── */}
        <div className={`relative bg-gradient-to-br ${grad} p-5 flex-shrink-0 rounded-t-3xl sm:rounded-t-2xl overflow-hidden`}>
          {/* Background image */}
          {term.image && (
            <div className="absolute inset-0">
              <img src={term.image} alt="" className="w-full h-full object-cover opacity-20" />
              <div className={`absolute inset-0 bg-gradient-to-br ${grad} opacity-80`} />
            </div>
          )}

          <div className="relative">
            {/* Badges row */}
            <div className="flex items-center gap-2 mb-2 flex-wrap">
              <span className="text-xs px-2.5 py-1 rounded-full bg-black/30 text-white/90 font-medium backdrop-blur">
                {term.category}
              </span>
              <span className={`text-xs px-2.5 py-1 rounded-full bg-black/30 font-semibold backdrop-blur ${risk.text}`}>
                ● {term.risk?.toUpperCase()} RISK
              </span>
              <span className="text-xs px-2.5 py-1 rounded-full bg-black/30 text-white/70 backdrop-blur font-mono">
                {term.letter}
              </span>
            </div>

            {/* Title */}
            <div className="flex items-start justify-between gap-3">
              <div>
                <h2 className="text-2xl sm:text-3xl font-extrabold text-white leading-tight">{term.term}</h2>
                <p className="text-white/75 text-sm mt-1 font-medium">{term.short}</p>
              </div>
              <div className="flex gap-2 flex-shrink-0">
                <button
                  onClick={onFav}
                  className={`w-10 h-10 rounded-xl bg-black/25 backdrop-blur flex items-center justify-center text-xl transition-transform hover:scale-110 ${isFav ? "text-yellow-400" : "text-white/60 hover:text-yellow-400"}`}
                >
                  {isFav ? "★" : "☆"}
                </button>
                <button
                  onClick={onClose}
                  className="w-10 h-10 rounded-xl bg-black/25 backdrop-blur flex items-center justify-center text-white/80 hover:text-white transition text-lg"
                >
                  ✕
                </button>
              </div>
            </div>

            {/* Tags */}
            <div className="flex flex-wrap gap-1.5 mt-3">
              {term.tags?.map((tag) => (
                <span key={tag} className="text-[11px] px-2 py-0.5 bg-black/25 text-white/80 rounded-full backdrop-blur">
                  #{tag}
                </span>
              ))}
            </div>
          </div>
        </div>

        {/* ── TAB NAV ── */}
        <div className="flex border-b border-gray-800 overflow-x-auto scrollbar-hide flex-shrink-0 bg-gray-900">
          {TAB_LIST.map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={`flex-shrink-0 px-5 py-3.5 text-sm font-semibold transition-all whitespace-nowrap ${
                activeTab === tab.id
                  ? "text-green-400 border-b-2 border-green-400 bg-green-500/5"
                  : "text-gray-500 hover:text-gray-300 hover:bg-gray-800/50"
              }`}
            >
              {tab.label}
            </button>
          ))}
        </div>

        {/* ── TAB CONTENT ── */}
        <div className="p-5 overflow-y-auto flex-1">

          {/* DEFINITION TAB */}
          {activeTab === "definition" && (
            <div className="space-y-4">
              <div className="bg-gray-800/60 rounded-2xl p-4 border border-gray-700/60">
                <h4 className="text-xs font-bold text-green-400 uppercase tracking-widest mb-3">📚 সংজ্ঞা</h4>
                <p className="text-gray-200 leading-relaxed text-sm">{term.definition}</p>
              </div>

              <div className="bg-blue-500/8 rounded-2xl p-4 border border-blue-500/20">
                <h4 className="text-xs font-bold text-blue-400 uppercase tracking-widest mb-3">💬 বাস্তব উদাহরণ</h4>
                <p className="text-gray-300 text-sm leading-relaxed">{term.example}</p>
              </div>

              {/* Risk meter */}
              <div className={`rounded-2xl p-4 border ${risk.border} ${risk.bg}`}>
                <h4 className={`text-xs font-bold ${risk.text} uppercase tracking-widest mb-3`}>⚠️ ঝুঁকির মাত্রা</h4>
                <div className="flex items-center gap-3">
                  <div className="flex-1 bg-gray-800 rounded-full h-2.5 overflow-hidden">
                    <div
                      className={`h-full rounded-full ${risk.dot} transition-all duration-700`}
                      style={{ width: riskWidth[term.risk] || "50%" }}
                    />
                  </div>
                  <span className={`text-sm font-bold ${risk.text} min-w-[60px] text-right`}>
                    {term.risk?.toUpperCase()}
                  </span>
                </div>
              </div>
            </div>
          )}

          {/* ANALOGY TAB */}
          {activeTab === "analogy" && (
            <div className="space-y-4">
              <div className={`bg-gradient-to-br from-purple-500/10 to-pink-500/10 rounded-2xl p-5 border border-purple-500/25`}>
                <div className="text-5xl mb-4 text-center">🎯</div>
                <h4 className="text-sm font-bold text-purple-400 mb-3 text-center">সহজ অ্যানালজি দিয়ে বুঝুন</h4>
                <p className="text-gray-200 text-base leading-relaxed text-center">{term.analogy}</p>
              </div>

              <div className="bg-gray-800/40 rounded-2xl p-4 border border-gray-700/40">
                <h4 className="text-xs font-bold text-gray-400 uppercase tracking-widest mb-2">📝 কেন এই অ্যানালজি?</h4>
                <p className="text-gray-400 text-xs leading-relaxed">
                  এই উপমাটি <span className="text-white font-semibold">{term.term}</span>-এর মূল ধারণাকে
                  দৈনন্দিন জীবনের সাথে তুলনা করে সহজে বোধগম্য করে তোলে।
                  Technical concept গুলো বাস্তব জীবনের উদাহরণে বোঝা অনেক সহজ।
                </p>
              </div>
            </div>
          )}

          {/* USE CASE TAB */}
          {activeTab === "usecase" && (
            <div className="space-y-4">
              <div className="bg-yellow-500/8 rounded-2xl p-4 border border-yellow-500/25">
                <h4 className="text-xs font-bold text-yellow-400 uppercase tracking-widest mb-3">⚙️ ব্যবহার ক্ষেত্র</h4>
                <p className="text-gray-300 text-sm leading-relaxed">{term.useCase}</p>
              </div>

              <div className="bg-cyan-500/8 rounded-2xl p-4 border border-cyan-500/20">
                <h4 className="text-xs font-bold text-cyan-400 uppercase tracking-widest mb-3">🌍 বাস্তব উদাহরণ</h4>
                <p className="text-gray-300 text-sm leading-relaxed">{term.example}</p>
              </div>

              {/* Category info */}
              <div className="bg-gray-800/40 rounded-2xl p-4 border border-gray-700/40">
                <h4 className="text-xs font-bold text-gray-400 uppercase tracking-widest mb-3">🏷️ ক্যাটাগরি: {term.category}</h4>
                <div className="flex flex-wrap gap-2">
                  {term.tags?.map((tag) => (
                    <span key={tag} className="text-xs px-3 py-1 bg-gray-800 text-gray-300 rounded-lg border border-gray-700">
                      #{tag}
                    </span>
                  ))}
                </div>
              </div>
            </div>
          )}

          {/* CODE TAB */}
          {activeTab === "code" && (
            <div className="space-y-3">
              {/* Code header */}
              <div className="flex items-center justify-between">
                <h4 className="text-xs font-bold text-green-400 uppercase tracking-widest">
                  💻 কোড উদাহরণ
                </h4>
                <button
                  onClick={copyCode}
                  className={`flex items-center gap-1.5 text-xs px-3 py-1.5 rounded-lg border transition ${
                    copied
                      ? "bg-green-500/30 text-green-300 border-green-500/50"
                      : "bg-gray-800 text-gray-400 border-gray-700 hover:bg-gray-700 hover:text-white"
                  }`}
                >
                  {copied ? "✅ Copied!" : "📋 কপি করুন"}
                </button>
              </div>

              {/* Code block */}
              <div className="bg-gray-950 rounded-2xl border border-gray-800 overflow-hidden">
                {/* Traffic lights */}
                <div className="flex items-center gap-2 px-4 py-2.5 border-b border-gray-800 bg-gray-900/80">
                  <div className="flex gap-1.5">
                    <div className="w-3 h-3 rounded-full bg-red-500/80" />
                    <div className="w-3 h-3 rounded-full bg-yellow-500/80" />
                    <div className="w-3 h-3 rounded-full bg-green-500/80" />
                  </div>
                  <span className="text-xs text-gray-500 font-mono ml-1">
                    {term.term.toLowerCase().replace(/\s+/g, "_")}.example
                  </span>
                </div>

                {/* Code */}
                <pre className="p-4 text-xs sm:text-sm text-green-300 overflow-x-auto leading-relaxed font-mono whitespace-pre scrollbar-hide">
                  {term.code}
                </pre>
              </div>

              <p className="text-[11px] text-gray-600 text-center">
                কোডটি educational purpose-এর জন্য। Production-এ নিরাপত্তা best practices অনুসরণ করুন।
              </p>
            </div>
          )}
        </div>

        {/* ── BOTTOM NAV (mobile friendly) ── */}
        <div className="flex border-t border-gray-800 flex-shrink-0 bg-gray-900 rounded-b-3xl sm:rounded-b-2xl">
          {TAB_LIST.map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={`flex-1 py-3 text-xs font-semibold transition ${
                activeTab === tab.id ? "text-green-400" : "text-gray-600 hover:text-gray-400"
              }`}
            >
              {tab.label.split(" ")[0]}
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}
