# Rubric: Ruby on Rails (Rails Way first, SOLID adapted)

Primary lens: the Rails Way as practiced by DHH / 37signals ("Vanilla Rails is plenty").
Secondary lens: SOLID, only as reinterpreted below. When the two conflict, the Rails Way wins:
report the tension under "Tensions", never as a finding.

Do not recommend patterns because they are popular. Recommend a change only when it removes
a concrete problem you can point to (duplication, bugs, change amplification, confusion).
Adding abstractions is a cost, not a win.

## Slices

| Slice | Paths |
|---|---|
| models | app/models (including concerns) |
| controllers | app/controllers, config/routes.rb |
| frontend | app/views, app/javascript, app/components, app/helpers |
| backend-other | app/jobs, app/mailers, app/services, app/lib, lib, any other app/* folder |
| data | db/schema.rb or db/structure.sql, the last 20 migrations, Gemfile, Gemfile.lock |
| tests | test/ or spec/ |

## Rules

### R. Rails Way

- R1. Rich domain models. Business logic lives in models and concerns, not in service objects, interactors, operations or "managers". Flag service-like classes whose logic reads naturally as a model method or concern. Plain Ruby objects in app/models for domain concepts without a table are fine.
- R2. Concerns are cohesive roles (Quote::Pricing, Contract::Signable), not junk drawers split by file size.
- R3. Thin, RESTful controllers with the standard CRUD actions. Custom actions (approve, publish, send_pdf) are usually a missing resource: suggest e.g. Quotes::ApprovalsController#create. Flag business logic in controllers.
- R4. Callbacks are fine for keeping a model's own state consistent. Flag callbacks that trigger hidden cross-model workflows, external calls or emails.
- R5. Conventions over configuration. Flag custom solutions for things Rails ships: Active Job / Solid Queue, Action Mailer, Active Storage, Current attributes, has_secure_password, normalizes, enums, delegated types, encrypts, generates_token_for.
- R6. Hotwire first. Flag heavy custom JavaScript where Turbo Frames/Streams or a small Stimulus controller would do.
- R7. Dependencies. Flag gems that duplicate Rails features, are unmaintained, or are used once for something trivial.
- R8. Tests: Minitest with fixtures. Flag untested domain logic, tests that only test mocks, and missing system tests for critical flows.

### S. SOLID, adapted to Rails

- S1. Single Responsibility at the level of roles: a large cohesive model is fine. Flag god objects where unrelated reasons to change live together. Suggest concerns or a new model, not service objects.
- S2. Open/Closed: flag the same case/if chain on a type or status repeated in several places. Suggest STI, delegated types or a model method.
- S3. Liskov: STI subclasses or delegated types that break the parent's contract.
- S4. Interface Segregation: concerns that force unrelated methods onto every includer.
- S5. Dependency Inversion ONLY at boundaries with external systems (payments, PDF engines, WhatsApp/email APIs). Suggest one small adapter per external system. Never repositories, interfaces or injection for Active Record.

### X. Cross-cutting

- X1. Security: authorization on every action, strong params, SQL interpolation, unsafe redirects, html_safe/raw on user data, secrets in code.
- X2. Data: N+1 queries, missing indexes, missing DB constraints for validated uniqueness/presence, unsafe migrations, money stored as float.
- X3. Dead code: unused routes, actions, methods, partials, jobs, gems.

## Review focus (for a single change)

Authorization and strong params on touched actions; N+1 and missing indexes for new queries; migration safety; logic that belongs in the model but landed in a controller or a new service object; missing Minitest coverage for new model behavior.

## Verification

1. `bin/rails test` (and `bin/rails test:system` if system tests exist and the change touches UI)
2. `bin/rubocop` if present
3. `bin/brakeman --no-pager` if present
