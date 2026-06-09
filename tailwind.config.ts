import type { Config } from "tailwindcss";

const config: Config = {
  content: ["./src/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        ink: { DEFAULT: "#15121E", 2: "#1F1A2C", 3: "#2A2440" },
        gospel: {
          gold: "#E3B23C",
          ink: "#2A2440",
          crimson: "#C9402F",
          parch: "#F5F1E8",
          green: "#5AA476",
          violet: "#9B8CC4",
        },
        muted: "#938CA8",
      },
      fontFamily: {
        serif: ["var(--font-serif)", "Noto Serif KR", "serif"],
        sans: [
          "-apple-system",
          "Apple SD Gothic Neo",
          "Pretendard",
          "system-ui",
          "sans-serif",
        ],
      },
    },
  },
  plugins: [],
};

export default config;
