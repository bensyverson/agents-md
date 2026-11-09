---
kind: file
when: When running as a subagent, before your first tool call
---
# Working as a subagent

Your brief is your scope: its TASK, VERIFIED FACTS and DO NOT BUILD sections bind you, and you don't delegate further. These rules hold for every brief; the brief only adds to them.

## Never

- **Commit, or run `job done`.** You hand back a branch and a report; the integrator commits and closes.
- **`git stash`.** Every worktree shares one stash stack.
- **`cd` into the main checkout,** or write to it by absolute path. Work in your worktree; every path you use is absolute or `git -C <worktree>`.
- **Change product behavior or appearance to make a test, probe or capture pass.** Report the conflict instead.

## Start

1. **Sync:** `git merge --ff-only main`; if it fails, `git rebase main`. Two separate calls.
2. **Read `project/agents/harness.md`** (sandbox, `$TMPDIR`, worktree isolation) and **`project/gotchas.md`**, where this repo's worktree setup lives: toolchain paths, fixtures a worktree lacks, files that must not be touched. Skip `job orient`; your brief names your leaves.
3. **Claim each leaf for longer than your builds take:** `job --as <name> --db <main checkout>/.jobs.db claim <id> 2h`. Every `job` call carries `--as` and the absolute `--db`, never the worktree's copy (`project/agents/jobs.md`). Note findings as you go; release each claim when you report.

## While working

- **One plain command per Bash call;** write file bodies with the Write tool. Compound commands and heredocs trip the harness's checks.
- **Prefix scratch files with your leaf id;** parallel agents share one scratch directory.
- **TDD, red first:** see every new test fail before the code that passes it. A test green on its first run is a claim about rigor, so report it. A test that asserts a new refusal also asserts what must still work.
- **Fix minor bugs you meet in or near your files;** report the major ones.
- **A duration that spans a machine sleep is not a hang:** check whether the machine slept before reporting anything as slow.

## Your report

1. **Per leaf:** what changed and why, and whether each criterion passes (not the diff; the branch carries it). Then the suite command you ran and its result, and your worktree path and branch.
2. **Every new file, by path.** `git diff` omits untracked files.
3. **A proposed commit message:** a subject completing "This commit…" (present-tense verb first), and a body that says why.
4. **DEVIATIONS** from the brief, and why.
5. **WHAT IN THIS BRIEF IS WRONG?** Answer explicitly. Briefs contain errors at a rate that makes this the cheapest check available. If a seam doesn't work the way the brief says, say so rather than working around it.
