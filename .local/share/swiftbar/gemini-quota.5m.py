#!/usr/bin/env python3
# <xbar.title>Gemini (Antigravity) quota</xbar.title>
# <xbar.desc>Remaining quota per model as progress bars. Refreshes every 5 min.</xbar.desc>
import base64, json, os, subprocess, sys, urllib.error, urllib.request
from datetime import datetime, timezone

# Keychain item written by agy (account "antigravity"). Prints a raw token or a JSON blob.
TOKEN_CMD = ["security", "find-generic-password", "-a", "antigravity", "-w"]
PROJECT_FILE = os.path.expanduser("~/.gemini/antigravity-cli/cache/default_project_id.txt")
URL = "https://cloudcode-pa.googleapis.com/v1internal:fetchAvailableModels"
SUMMARY_URL = "https://daily-cloudcode-pa.googleapis.com/v1internal:retrieveUserQuotaSummary"
WIDTH = 14


def bar(frac):
    filled = round(max(0.0, min(1.0, frac)) * WIDTH)
    return "█" * filled + "░" * (WIDTH - filled)


def color(frac):
    return "#e5534b" if frac < 0.2 else "#d29922" if frac < 0.5 else "#3fb950"


def until(iso, now):
    secs = (datetime.fromisoformat(iso.replace("Z", "+00:00")) - now).total_seconds()
    if secs <= 0:
        return "now"
    h, m = divmod(int(secs) // 60, 60)
    if h >= 24:
        return f"{h // 24}d{h % 24:02d}h"
    return f"{h}h{m:02d}m" if h else f"{m}m"


AGY = os.path.expanduser("~/.local/bin/agy")


def agy_models():
    """{id: display name} of what agy offers, e.g. gemini-4-argon-medium."""
    try:
        out = subprocess.run([AGY, "models"], capture_output=True, text=True, timeout=60).stdout
    except Exception:
        return {}
    return dict(l.split("\t", 1) for l in out.splitlines() if "\t" in l)


def render(models, now, summary=None, listed=None):
    head, lows = [], []
    for g in (summary or {}).get("groups", []):
        head.append(f"{g.get('displayName', '?')} | size=12")
        for b in g.get("buckets", []):
            frac = b.get("remainingFraction", 0.0)
            reset = until(b["resetTime"], now) if b.get("resetTime") else "?"
            lows.append(frac)
            head.append(f"  {b.get('window', '?'):<24} {bar(frac)} {frac:4.0%}  ↻ {reset} | font=Menlo size=12 color={color(frac)}")
    rows, seen = [], set()
    for key, m in models.items():
        q = m.get("quotaInfo")
        name = m.get("displayName") or (key if key.startswith("gemini-") else None)
        # skip unnamed internal models and duplicate variants sharing a display name
        if not q or not name or name in seen:
            continue
        seen.add(name)
        frac = q.get("remainingFraction", 0.0)  # API omits it when exhausted
        reset = until(q["resetTime"], now) if q.get("resetTime") else "?"
        rows.append((frac, f"{name:<26} {bar(frac)} {frac:4.0%}  ↻ {reset}"))
    # The quota API drops a model entirely once it is exhausted, while agy still
    # lists it. Match by family (id minus the -low/-medium/-high suffix).
    for mid, mname in (listed or {}).items():
        family, short = mid.rsplit("-", 1)[0], mname.split(" (")[0]
        if any(k.startswith(family) for k in models) or short in seen:
            continue
        seen.add(short)
        rows.append((0.0, f"{short:<26} {bar(0)}   0%  ↻ ? (used up)"))
    if not rows and not head:
        return ["Gemini ?", "---", "No quota data returned"]
    low = min([f for f, _ in rows] + lows)
    out = [f"✦ {low:.0%} | color={color(low)}", "---"] + head + (["---"] if head else [])
    out += [f"{line} | font=Menlo size=12 color={color(f)}" for f, line in sorted(rows, key=lambda r: r[1])]
    return out + ["---", "Refresh | refresh=true"]


def decode_keyring(raw):
    # go-keyring on macOS wraps values as "go-keyring-base64:<b64>" or "go-keyring-encoded:<hex>"
    if raw.startswith("go-keyring-base64:"):
        return base64.b64decode(raw.split(":", 1)[1]).decode().strip()
    if raw.startswith("go-keyring-encoded:"):
        return bytes.fromhex(raw.split(":", 1)[1]).decode().strip()
    return raw


def fetch(url=URL):
    try:
        return _fetch(url)
    except urllib.error.HTTPError as e:
        if e.code != 401:
            raise
        # ponytail: let agy refresh its own token instead of re-implementing Google OAuth
        subprocess.run([os.path.expanduser("~/.local/bin/agy"), "models"], capture_output=True, timeout=60)
        return _fetch(url)


def _fetch(url):
    token = subprocess.run(TOKEN_CMD, capture_output=True, text=True, check=True).stdout.strip()
    token = decode_keyring(token)
    if token.startswith("{"):  # ponytail: guessing key names; widen if agy stores it differently
        blob = json.loads(token)
        token = blob.get("access_token") or blob.get("accessToken") or blob.get("token", {}).get("access_token", "")
    project = open(PROJECT_FILE).read().strip()
    req = urllib.request.Request(
        url, data=json.dumps({"project": project}).encode(), method="POST",
        headers={"Authorization": f"Bearer {token}", "Content-Type": "application/json",
                 "User-Agent": "antigravity"})
    with urllib.request.urlopen(req, timeout=15) as r:
        return json.load(r)


def demo():
    now = datetime(2026, 1, 1, tzinfo=timezone.utc)
    out = render({
        "a": {"displayName": "Gemini 4 Argon", "quotaInfo": {"remainingFraction": 0.5, "resetTime": "2026-01-01T03:15:00Z"}},
        "b": {"displayName": "Flash", "quotaInfo": {"resetTime": "2025-12-31T00:00:00Z"}},
        "c": {"displayName": "no quota"},
        "d": {"quotaInfo": {"remainingFraction": 0.1}},
        "e": {"displayName": "Flash", "quotaInfo": {"remainingFraction": 0.9}},
    }, now)
    assert len(out) == 6, out  # header, ---, 2 rows, ---, Refresh
    assert out[0].startswith("✦ 0%") and "#e5534b" in out[0], out[0]
    assert "███████░░░░░░░" in out[3] and "3h15m" in out[3], out[3]
    assert "↻ now" in out[2], out[2]
    assert decode_keyring("go-keyring-base64:" + base64.b64encode(b'{"a":1}').decode()) == '{"a":1}'
    assert decode_keyring("go-keyring-encoded:7b7d") == "{}"
    assert decode_keyring("ya29.x") == "ya29.x"
    out = render({}, now, {"groups": [{"displayName": "Claude", "buckets": [
        {"window": "weekly", "remainingFraction": 0.3, "resetTime": "2026-01-08T02:00:00Z"}]}]})
    assert out[0].startswith("✦ 30%") and "weekly" in out[3] and "7d02h" in out[3], out
    out = render({"gemini-3.8-flash-tiered": {"quotaInfo": {"remainingFraction": 1}}}, now, None,
                 {"gemini-4-argon-low": "Gemini 4 Argon (Low)", "gemini-4-argon-high": "Gemini 4 Argon (High)",
                  "gemini-3.8-flash-high": "Gemini 3.8 Flash (High)"})
    assert out[0].startswith("✦ 0%"), out
    assert sum("Gemini 4 Argon" in l and "used up" in l for l in out) == 1, out
    assert any("gemini-3.8-flash-tiered" in l and "100%" in l for l in out), out
    assert bar(1.2) == "█" * WIDTH and bar(-1) == "░" * WIDTH
    print("ok")


if __name__ == "__main__":
    if "--test" in sys.argv:
        demo()
    elif "--raw" in sys.argv:  # dump the plan-level summary agy uses for "wait N days"
        print(json.dumps(fetch(SUMMARY_URL), indent=2))
    else:
        try:
            print("\n".join(render(fetch().get("models", {}), datetime.now(timezone.utc), fetch(SUMMARY_URL), agy_models())))
        except Exception as e:
            print(f"✦ ! | color=#e5534b\n---\n{type(e).__name__}: {e}")
