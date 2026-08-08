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
