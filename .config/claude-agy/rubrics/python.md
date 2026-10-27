# Rubric: Python (apps, bots and API integrations)

Primary lens: simple, explicit, Pythonic code. Modules and functions before classes;
a class only when it holds state or models a real concept. Flat is better than nested.
Secondary lens: SOLID, adapted below. When they conflict, simplicity wins: report the
tension under "Tensions".

Do not recommend frameworks, layers or patterns because they are popular. Recommend a change
only when it removes a concrete problem. Adding abstractions is a cost, not a win.

## Slices

| Slice | Paths |
|---|---|
| core | the main package or top-level modules with the domain logic (message handling, replies, flows) |
| integrations | modules that call external APIs (Instagram / Meta Graph API, LLMs, webhooks, databases) |
| entrypoints | main.py, CLI, web server / webhook handlers, schedulers, workers |
| config | pyproject.toml, requirements*.txt, lockfiles, .env.example, Dockerfile, deploy config |
| tests | tests/ |

## Rules

### P. Pythonic design

- P1. Functions and modules first. Flag classes with a single method, manager/helper/util classes that only group functions, and deep inheritance.
- P2. Explicit data. Prefer dataclasses or typed dicts over loose dicts passed across modules. Type hints on public functions.
- P3. Errors. Flag bare `except:`, `except Exception: pass`, swallowed errors, and errors logged without context. Expected failures from external APIs must be handled explicitly.
- P4. Configuration and secrets from environment, never hardcoded. Flag tokens, cookies, session files or passwords committed to the repo.
- P5. Logging with the `logging` module (or structured logging), not print, in anything that runs unattended.
- P6. Dependencies pinned with a lockfile (uv.lock, poetry.lock, pinned requirements). Flag unused or abandoned packages.
- P7. Async correctness if asyncio is used: no blocking calls (requests, time.sleep, sync DB drivers) inside async code; tasks awaited or tracked; no fire-and-forget without error handling.
- P8. Tests with pytest. Flag untested message-handling logic and tests that hit real external APIs.

### B. Bots and API integrations

- B1. Platform policy risk. Flag use of unofficial/private Instagram APIs or scraping clients (e.g. instagrapi-style login with username/password) instead of the official Meta Graph / Instagram Messaging API: account ban and breakage risk. Report as NEEDS PAUL, not as an automatic fix.
- B2. Rate limits and retries: exponential backoff with jitter on 429/5xx, respect for platform limits, no tight retry loops.
- B3. Idempotency: the same incoming event (webhook retry, duplicate delivery, restart) must not produce duplicate replies or actions. Look for dedup by message/event id.
- B4. Webhook security: signature verification (X-Hub-Signature-256 for Meta), verify token handling, fast 200 response with work moved to a queue if processing is slow.
- B5. State: conversation state persisted somewhere durable if the bot must survive restarts; no in-memory-only state that silently resets.
- B6. Personal data: messages and user identifiers not logged in full; retention considered.

### S. SOLID, adapted

- S1. Single Responsibility per module: message parsing, decision logic and API calls should not be tangled in one function.
- S2. Open/Closed: flag long if/elif chains on message type or command repeated in several places; suggest a dispatch dict.
- S5. Dependency Inversion ONLY at the boundary with external APIs: one thin client module per external service, so core logic can be tested with a fake. Do not suggest interfaces or DI containers elsewhere.

### X. Cross-cutting

- X1. Security: injection (SQL, shell via subprocess with shell=True), unsafe deserialization (pickle, yaml.load), SSRF in URL fetching.
- X2. Dead code and unused modules.

## Review focus (for a single change)

Duplicate replies on retries (idempotency); error handling around new API calls; secrets or personal data leaking into logs or the repo; blocking calls in async code; new logic without a pytest test.

## Verification

1. `uv run pytest` if uv.lock exists, else `pytest` / `python -m pytest`
2. `ruff check .` if configured
3. `python -m compileall -q .` as a last-resort syntax check when there are no tests
