# Canonical skills and agent adapters

Each `skills/*/SKILL.md` is the canonical, agent-neutral procedure. Product
metadata and installation mechanics are adapters; they must not redefine the
procedure or its safety boundary.

An adapter maps four concepts supported by the target agent:

- discovery trigger from canonical `name` and `description`;
- instruction body from canonical Markdown;
- explicit invocation syntax, if the agent supports one;
- UI metadata and dependency declarations specific to that product.

The `agents/openai.yaml` files are the OpenAI/Codex adapter. Future Claude,
Gemini, OpenCode, or other adapters may use different paths or schemas, but
should be generated from the canonical skill rather than maintained as
independent instructions.

Validate an adapter by giving a fresh agent the same task and comparing the
observable workflow and safety decisions, not wording. A product that cannot
express an adapter field should omit that field rather than move product-specific
details into canonical `SKILL.md`.

## What the transfer test returned, once

Three skills were validated the way this repository asks: a fresh agent, a
scenario from an unrelated domain, no hint of the source project or the expected
conclusion. All three transferred — the interesting part is that each fresh agent
returned something the skill did not say.

One noticed that reversibility is a property of the moment rather than of the
decision, so "expensive to undo" argues for deciding *now* while it is still
cheap. One found the hazard that sits beside a migration rather than inside it:
an intake path that deduplicates by recomputing an identifier will silently
create a second copy rather than fail. One replaced reading with a test, because
one test that reproduces a disputed behaviour settles several findings at once.

The test is worth running for that alone. A skill that survives contact with an
unfamiliar domain usually comes back with the paragraph it was missing.
