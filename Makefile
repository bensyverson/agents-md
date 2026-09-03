.PHONY: sync status diff hooks help

# The rollout loop after editing a module: re-render every registered repo,
# then show the fleet. Each repo still needs its own commit.
sync:
	agents sync --all
	agents status --all

status:
	agents status --all

# The review queue: hand-edits inside regions and rule: gotchas, fleet-wide.
diff:
	agents diff --all

# Point git at the checked-in hooks (one-time per clone): pre-commit checks
# this repo's own AGENTS.md, post-commit re-renders every registered repo.
hooks:
	git config core.hooksPath scripts/git-hooks

help:
	@echo "Targets:"
	@echo "  sync     - agents sync --all, then agents status --all"
	@echo "  status   - agents status --all"
	@echo "  diff     - agents diff --all (the review queue)"
	@echo "  hooks    - install the checked-in git hooks (core.hooksPath)"
