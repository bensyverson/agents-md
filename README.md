# agents-md

> The house rules I give coding agents, as modules for [`agents`](https://github.com/bensyverson/agents).

Every repo has an `AGENTS.md` telling coding agents how to work there. This repo holds the shared parts as markdown **modules** (`modules/`) and the files they seed into a repo (`templates/`). The [`agents`](https://github.com/bensyverson/agents) CLI renders the modules a repo asks for into marked regions of its `AGENTS.md` and keeps them in sync.

## Use it

In a repo you want to manage:

```
agents init --source https://github.com/bensyverson/agents-md --with core,principles,stage-build
agents list                 # what this source offers, * on what's enabled
agents add go               # enable another module
agents update               # move the pin and see what changed in the rules
```

The manifest `.agents.yaml` pins this repo to a commit; `agents update` moves the pin and prints the diff of every enabled module before rendering. Nothing here changes what an agent reads without that diff.

## Change it

These modules embody my house style and will always represent my current recommendations. To make changes or extensions, fork the repo and point your manifests at the fork. Module format: see [DOCS.md](https://github.com/bensyverson/agents/blob/main/DOCS.md) in the tool's repo, or enable the tool's own `module-authoring` example module.

## Roll out

After editing a module here:

```
make sync                   # agents sync --all, then agents status --all
make diff                   # review hand-edits and rule feedback from every registered repo
```

`make hooks` (once per clone) installs a post-commit hook that runs `make sync`, so a module commit reaches every registered repo before their own hooks can complain. Each repo then needs its own commit.

## Layout

- `modules/` — the shared rules, one markdown file per module
- `templates/` — files seeded into managed repos (`templates/head.md` seeds a fresh `AGENTS.md` head)
- `project/` — notes about this repo, including `gotchas.md`

---

By [Ben Syverson](https://github.com/bensyverson/). Licensed under the [MIT License](LICENSE).
