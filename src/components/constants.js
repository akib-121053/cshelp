export const RISK_COLORS = {
  critical: { bg: "bg-red-500/20",    text: "text-red-400",    border: "border-red-500/40",    dot: "bg-red-400"    },
  high:     { bg: "bg-orange-500/20", text: "text-orange-400", border: "border-orange-500/40", dot: "bg-orange-400" },
  medium:   { bg: "bg-yellow-500/20", text: "text-yellow-400", border: "border-yellow-500/40", dot: "bg-yellow-400" },
  low:      { bg: "bg-green-500/20",  text: "text-green-400",  border: "border-green-500/40",  dot: "bg-green-400"  },
};

export const CATEGORY_GRADIENTS = {
  "Web Security":       "from-cyan-500 to-blue-600",
  "Network Attack":     "from-red-500 to-pink-600",
  "Cryptography":       "from-purple-500 to-violet-600",
  "Defense":            "from-green-500 to-emerald-600",
  "Malware":            "from-orange-500 to-red-600",
  "Identity":           "from-blue-500 to-indigo-600",
  "Access Control":     "from-indigo-500 to-purple-600",
  "Social Engineering": "from-yellow-500 to-orange-600",
  "Attack Vector":      "from-pink-500 to-rose-600",
  "Vulnerability":      "from-rose-500 to-red-700",
  "Reconnaissance":     "from-teal-500 to-cyan-600",
};

export const TAB_LIST = [
  { id: "definition", label: "📖 সংজ্ঞা"    },
  { id: "analogy",    label: "🎯 অ্যানালজি" },
  { id: "usecase",    label: "💡 ব্যবহার"    },
  { id: "code",       label: "💻 কোড"        },
];
