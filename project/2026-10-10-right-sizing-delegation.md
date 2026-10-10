# 2026-10-10 — Right-sizing delegation: agents per job, not agents per leaf

Feedback on `modules/delegation.md` (and the parts of `modules/jobs.md` it leans on) from a
managed repo, a cross-platform Swift package. Nothing here is decided; it is a proposal for
the next review of the shared rules.

## The observation

When the tracker holds N open leaves, a dispatching agent tends to launch N agents. The
modules already say the opposite in prose — "merge cost, not task count, decides the
split", "agents are assigned by file ownership; leaves are units of work" — but the
structure around those lines pulls the other way, and structure wins.

The case that surfaced it: an audit of a CLI produced eight leaves. Sized by the files each
touches, they fell into three natural jobs — what the CLI accepts and how it refuses (a
three-leaf dependency chain), how it prints (three leaves rewriting the same formatters and
their golden expectations), and a set of small, scattered write-path fixes. Eight agents
would have cost eight builds, briefs and integrations, and the three printing leaves would
have collided on nearly every file. Nothing in the module led there; it took a direct
question from the user.

## Why the module produces one agent per leaf

1. **The briefing template is singular.** "You are working in worktree … on leaf `<id>`"
   and "Claim: `job claim <id>`". The dispatcher fills the template once per leaf; N leaves
   become N briefs. This is the strongest pull in the file.
2. **Every carving rule is about conflict, none about size.** *Map the file surface*,
   *parallelize only the disjoint set*, *carve the contention out* all answer "when must I
   not split?". Nothing asks "is this leaf big enough to be worth an agent?". A small leaf
   whose files touch nothing else passes every test and gets an agent of its own.
3. **The cost of an agent is never stated.** Each one pays a brief, a fresh worktree (in
   compiled languages, a cold build and the machine load that comes with it), a full suite
   run, a squash-merge and a whole-diff review, and a slot under any concurrency cap. A
   twenty-minute fix pays all of it. Without the cost on the page, splitting looks free.
4. **One rule pushes chains away from agents.** *Keep on the main thread … a chain of
   sequential dependencies* is right for a chain of decisions and wrong for a chain of
   buildable leaves: the main thread should not build them, and three serial dispatches
   are the worst carve. A dependent chain is the best possible single-agent job.
5. **The bundling rule only names files.** *One agent carries several leaves when they live
   in the same files* misses shared *context*: two leaves in different files of one
   subsystem, reading the same docs and the same tests, are cheaper for one agent than
   for two who each ramp up.

## Proposed changes

**In *Carving the work*, a sizing step whose output is a roster of agents:**

> **Carve into a roster of agents, not a list of leaves.** Group leaves by the files they
> own; then merge small groups that share context — the same subsystem, the same docs, the
> same test suite — until each agent holds about a session of work. A leaf too small to
> justify its own build, review and integration rides with a neighbor. Default to fewer
> agents and justify each extra one; record the roster (agent → leaves, in order) as a note
> on the container before dispatching.

> **An agent costs a brief, a worktree and its first build, a suite run, and an
> integration with a full-diff review.** Weigh every split against that, not against zero.

**In *What to delegate*, split the chain rule:**

> **Keep on the main thread** a design decision, a question for the user, or a single
> tool call. **A chain of dependent leaves goes to one agent, in order** — not to the main
> thread, and not to one agent per link.

**Widen the bundling rule:**

> **One agent carries several leaves when they share files *or context*.**

**Make the template plural:**

```
You are working in worktree <abs path> on leaves <id>, <id>, … — in this order. Identity: --as <name>.
…
Claim each: job claim <id> <ttl> --as <name>.
```

and in the report: "per leaf: what changed, and whether its criteria pass".

**In `modules/jobs.md`**, the existing *Leaves are units of work; agents are assigned by
file ownership* line could link forward to the roster step, so a reader arriving from the
tracker side meets the sizing rule too.

## What would show it worked

Fan-outs whose agent count is visibly smaller than their leaf count, with a roster note on
the container explaining the grouping; fewer integrations whose diffs collide.
