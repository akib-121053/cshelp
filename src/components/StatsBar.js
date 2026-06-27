import React from "react";

export default function StatsBar({ total, filtered, critical, favCount }) {
  const stats = [
    { label: "মোট টার্ম",  value: total,    icon: "📚", color: "text-cyan-400",   bg: "from-cyan-500/10 to-cyan-500/5",   border: "border-cyan-500/20" },
    { label: "ফলাফল",      value: filtered,  icon: "🔎", color: "text-green-400",  bg: "from-green-500/10 to-green-500/5", border: "border-green-500/20" },
    { label: "Critical",   value: critical,  icon: "🔴", color: "text-red-400",    bg: "from-red-500/10 to-red-500/5",     border: "border-red-500/20" },
    { label: "Favorites",  value: favCount,  icon: "⭐", color: "text-yellow-400", bg: "from-yellow-500/10 to-yellow-500/5",border: "border-yellow-500/20" },
  ];

  return (
    <div className="flex gap-3 overflow-x-auto pb-1 mt-4 scrollbar-hide">
      {stats.map((s) => (
        <div
          key={s.label}
          className={`flex-shrink-0 flex items-center gap-2.5 bg-gradient-to-br ${s.bg} border ${s.border} rounded-2xl px-4 py-3 min-w-[110px]`}
        >
          <span className="text-xl">{s.icon}</span>
          <div>
            <div className={`text-2xl font-extrabold leading-none ${s.color}`}>{s.value}</div>
            <div className="text-[11px] text-gray-500 mt-0.5">{s.label}</div>
          </div>
        </div>
      ))}
    </div>
  );
}
