#!/usr/bin/env node
/**
 * cmux-notify: Claude Code Notification → cmux 알림 브리지
 *
 * Claude Code settings.json Notification 훅에 등록하면
 * Claude 작업 완료 시 cmux 사이드바에 알림을 표시합니다.
 *
 * 설정 방법 (settings.json):
 *   "hooks": {
 *     "Notification": [{
 *       "hooks": [{
 *         "type": "command",
 *         "command": "node /path/to/cmux-notify.mjs"
 *       }]
 *     }]
 *   }
 */

import { execFileSync } from "node:child_process";
import { execSync } from "node:child_process";

const MAX_LENGTH = 2000;

function cmuxAvailable() {
  try {
    execSync("which cmux", { stdio: "ignore" });
    return true;
  } catch {
    return false;
  }
}

let raw = "";
process.stdin.on("data", (chunk) => (raw += chunk));
process.stdin.on("end", () => {
  if (!cmuxAvailable()) return;

  try {
    const data = JSON.parse(raw);
    // 길이 제한 + 문자열 강제 변환 (타입 검증)
    const message = String(data.message ?? data.title ?? "작업 완료").slice(0, MAX_LENGTH);
    const title = "Claude Code";

    // argv 리스트 방식 — shell injection 없음
    execFileSync("cmux", ["notify", "--title", title, "--body", message], { stdio: "ignore" });
    execFileSync("cmux", ["clear-progress"], { stdio: "ignore" });
  } catch {
    // 알림 실패는 무시 (Claude 작업에 영향 없어야 함)
  }
});
