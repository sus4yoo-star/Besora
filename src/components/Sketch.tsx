"use client";

import type { CSSProperties, ReactNode } from "react";

/**
 * 도구별 도표 일러스트.
 * schema.sql 의 sketch_key 값에 맞춰 그림을 그린다.
 *  - 사영리:   circle · two-circles · cross · throne
 *  - 다리예화: two-sides · gap · bridge · cross-over
 *  - 세개의원: circle · circle-broken · circle-gospel · arrows
 * 선은 그려지듯, 요소는 떠오르듯 등장한다 (prefers-reduced-motion 시 정지).
 */

const C = {
  gold: "#E3B23C",
  crimson: "#C9402F",
  green: "#5AA476",
  parch: "#F5F1E8",
  violet: "#9B8CC4",
  muted: "#938CA8",
};

// 선이 그려지는 효과 (요소에 pathLength={1} 함께 부여)
// 기본 상태는 '보임'(offset 0). 애니메이션이 그 위에 얹힌다 → 동작 줄이기 시에도 그림은 보임.
const draw = (delay = 0, dur = 0.9): CSSProperties => ({
  strokeDasharray: 1,
  strokeDashoffset: 0,
  animation: `sk-draw ${dur}s cubic-bezier(0.4,0,0.2,1) ${delay}s both`,
});
// 톡 떠오르며 등장 (기본 상태 '보임')
const pop = (delay = 0): CSSProperties => ({
  opacity: 1,
  transformOrigin: "center",
  animation: `sk-pop 0.5s cubic-bezier(0.2,0.7,0.2,1) ${delay}s both`,
});

function Frame({ children }: { children: ReactNode }) {
  return (
    <div className="relative mx-auto mb-6 w-full max-w-[270px]">
      <svg
        viewBox="0 0 260 150"
        className="h-auto w-full overflow-visible"
        fill="none"
        strokeLinecap="round"
        strokeLinejoin="round"
      >
        {children}
      </svg>
    </div>
  );
}

// 작은 사람(전도 대상) 픽토그램
function Person({ x, y, color }: { x: number; y: number; color: string }) {
  return (
    <g stroke={color} strokeWidth={4} fill="none">
      <circle cx={x} cy={y - 16} r={7} pathLength={1} style={draw(0.5)} />
      <path
        d={`M${x} ${y - 9} L${x} ${y + 8} M${x} ${y - 4} L${x - 9} ${y + 2} M${x} ${y - 4} L${x + 9} ${y + 2} M${x} ${y + 8} L${x - 8} ${y + 20} M${x} ${y + 8} L${x + 8} ${y + 20}`}
        pathLength={1}
        style={draw(0.6)}
      />
    </g>
  );
}

function CrossMark({
  cx,
  cy,
  s = 1,
  color = C.gold,
  delay = 0.2,
}: {
  cx: number;
  cy: number;
  s?: number;
  color?: string;
  delay?: number;
}) {
  return (
    <g stroke={color} strokeWidth={6} fill="none">
      <line
        x1={cx}
        y1={cy - 26 * s}
        x2={cx}
        y2={cy + 30 * s}
        pathLength={1}
        style={draw(delay)}
      />
      <line
        x1={cx - 18 * s}
        y1={cy - 8 * s}
        x2={cx + 18 * s}
        y2={cy - 8 * s}
        pathLength={1}
        style={draw(delay + 0.35)}
      />
    </g>
  );
}

function ground(yLeft: number, yRight: number) {
  // 좌/우 절벽(다리예화)
  return (
    <>
      <path
        d={`M8 ${yLeft} L92 ${yLeft} L92 142 L8 142 Z`}
        fill="rgba(245,241,232,0.06)"
        stroke={C.parch}
        strokeWidth={3}
        pathLength={1}
        style={draw(0.1)}
      />
      <path
        d={`M168 ${yRight} L252 ${yRight} L252 142 L168 142 Z`}
        fill="rgba(227,178,60,0.08)"
        stroke={C.gold}
        strokeWidth={3}
        pathLength={1}
        style={draw(0.25)}
      />
    </>
  );
}

export default function Sketch({ k }: { k: string | null }) {
  if (!k) return null;

  switch (k) {
    // ── 온전한 원: 하나님의 사랑/디자인 ──
    case "circle":
      return (
        <Frame>
          <circle cx={130} cy={72} r={50} fill={C.gold} opacity={0.16} style={{ ...pop(0.1), animation: "sk-glow 3.4s ease-in-out infinite" }} />
          <circle cx={130} cy={72} r={44} stroke={C.gold} strokeWidth={5} pathLength={1} style={draw(0.15, 1.1)} />
          {[0, 60, 120, 180, 240, 300].map((a, i) => {
            const r1 = 54, r2 = 64;
            const rad = (a * Math.PI) / 180;
            return (
              <line
                key={a}
                x1={130 + r1 * Math.cos(rad)}
                y1={72 + r1 * Math.sin(rad)}
                x2={130 + r2 * Math.cos(rad)}
                y2={72 + r2 * Math.sin(rad)}
                stroke={C.gold}
                strokeWidth={4}
                pathLength={1}
                style={pop(0.9 + i * 0.07)}
              />
            );
          })}
          <path d="M118 70 q12 -16 12 4 q0 -20 12 -4 q0 14 -12 22 q-12 -8 -12 -22 Z" fill={C.parch} opacity={0.85} style={pop(0.7)} />
        </Frame>
      );

    // ── 두 원이 갈라짐: 죄로 인한 단절 ──
    case "two-circles":
      return (
        <Frame>
          <circle cx={72} cy={74} r={34} stroke={C.parch} strokeWidth={5} pathLength={1} style={draw(0.1)} />
          <circle cx={188} cy={74} r={34} stroke={C.gold} strokeWidth={5} pathLength={1} style={draw(0.3)} />
          <Person x={72} y={78} color={C.parch} />
          <CrossMark cx={188} cy={74} s={0.7} delay={0.5} />
          <path
            d="M122 50 L132 70 L120 78 L134 98"
            stroke={C.crimson}
            strokeWidth={5}
            pathLength={1}
            style={draw(0.8, 0.6)}
          />
        </Frame>
      );

    // ── 십자가 ──
    case "cross":
      return (
        <Frame>
          <circle cx={130} cy={72} r={52} fill={C.gold} opacity={0.14} style={{ animation: "sk-glow 3.4s ease-in-out infinite" }} />
          <CrossMark cx={130} cy={74} s={1.25} delay={0.15} />
        </Frame>
      );

    // ── 보좌(마음)에 그리스도: 영접 ──
    case "throne":
      return (
        <Frame>
          <path
            d="M130 118 C70 80 78 34 110 34 c12 0 18 9 20 16 c2 -7 8 -16 20 -16 c32 0 40 46 -20 84 Z"
            stroke={C.crimson}
            strokeWidth={5}
            fill="rgba(201,64,47,0.12)"
            pathLength={1}
            style={draw(0.1, 1.2)}
          />
          <CrossMark cx={130} cy={70} s={0.8} color={C.gold} delay={0.9} />
        </Frame>
      );

    // ── 두 편: 사람과 하나님 ──
    case "two-sides":
      return (
        <Frame>
          {ground(78, 64)}
          <Person x={50} y={62} color={C.parch} />
          <CrossMark cx={210} cy={44} s={0.6} delay={0.5} />
        </Frame>
      );

    // ── 죄가 만든 깊은 간격 ──
    case "gap":
      return (
        <Frame>
          {ground(78, 64)}
          <Person x={50} y={62} color={C.parch} />
          <CrossMark cx={210} cy={44} s={0.6} delay={0.4} />
          <path
            d="M118 84 L128 104 L116 116 L130 138"
            stroke={C.crimson}
            strokeWidth={5}
            pathLength={1}
            style={draw(0.6, 0.7)}
          />
          <text x={130} y={30} fill={C.crimson} fontSize={15} textAnchor="middle" style={pop(1.2)} fontWeight="700">
            ✕
          </text>
        </Frame>
      );

    // ── 십자가라는 다리 ──
    case "bridge":
      return (
        <Frame>
          {ground(78, 78)}
          <line x1={88} y1={70} x2={172} y2={70} stroke={C.gold} strokeWidth={8} pathLength={1} style={draw(0.5, 0.8)} />
          <line x1={130} y1={42} x2={130} y2={92} stroke={C.gold} strokeWidth={8} pathLength={1} style={draw(1.0, 0.5)} />
        </Frame>
      );

    // ── 믿음으로 건너감 ──
    case "cross-over":
      return (
        <Frame>
          {ground(78, 78)}
          <line x1={88} y1={70} x2={172} y2={70} stroke={C.gold} strokeWidth={8} pathLength={1} style={draw(0.3, 0.7)} />
          <line x1={130} y1={44} x2={130} y2={92} stroke={C.gold} strokeWidth={8} pathLength={1} style={draw(0.7, 0.4)} />
          <g style={{ animation: "sk-cross 2.6s ease-in-out 1s infinite" }}>
            <circle cx={120} cy={52} r={7} fill={C.green} />
            <path d="M120 59 L120 74 M120 64 L112 70 M120 64 L128 70" stroke={C.green} strokeWidth={4} />
          </g>
        </Frame>
      );

    // ── 깨어진 원 ──
    case "circle-broken":
      return (
        <Frame>
          <path d="M130 28 A44 44 0 0 1 130 116" stroke={C.muted} strokeWidth={5} pathLength={1} style={draw(0.1)} />
          <g transform="translate(-9 6) rotate(-8 130 72)">
            <path d="M130 28 A44 44 0 0 0 130 116" stroke={C.muted} strokeWidth={5} pathLength={1} style={draw(0.35)} />
          </g>
          <path d="M132 22 L120 60 L140 78 L126 122" stroke={C.crimson} strokeWidth={5} pathLength={1} style={draw(0.7, 0.8)} />
        </Frame>
      );

    // ── 복음으로 회복되는 원 ──
    case "circle-gospel":
      return (
        <Frame>
          <circle cx={130} cy={72} r={50} fill={C.green} opacity={0.14} style={{ animation: "sk-glow 3.4s ease-in-out infinite" }} />
          <circle cx={130} cy={72} r={44} stroke={C.green} strokeWidth={5} pathLength={1} style={draw(0.15, 1.2)} />
          <CrossMark cx={130} cy={72} s={0.78} color={C.gold} delay={1.0} />
        </Frame>
      );

    // ── 돌이킴(회개)과 믿음 ──
    case "arrows":
      return (
        <Frame>
          <circle cx={150} cy={74} r={30} stroke={C.green} strokeWidth={5} pathLength={1} style={draw(0.6)} />
          <CrossMark cx={150} cy={74} s={0.5} color={C.gold} delay={1.0} />
          <path
            d="M96 110 C58 96 58 52 96 38"
            stroke={C.violet}
            strokeWidth={5}
            pathLength={1}
            style={draw(0.1, 0.9)}
          />
          <path d="M96 38 L82 40 M96 38 L92 52" stroke={C.violet} strokeWidth={5} pathLength={1} style={draw(1.0, 0.3)} />
        </Frame>
      );

    default:
      return (
        <Frame>
          <circle cx={130} cy={72} r={44} stroke={C.gold} strokeWidth={5} pathLength={1} style={draw(0.15, 1.1)} />
        </Frame>
      );
  }
}
