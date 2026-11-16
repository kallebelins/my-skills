---
name: git-sync-develop
description: "Safely syncs the current Git branch with the remote base branch (default develop): authenticates without exposing secrets, fetches, creates a local recovery point, merges the base into the current branch, resolves only unambiguous conflicts and asks the user about semantic ones, detects and runs the project's build/tests, fixes only verifiable failures, pushes the current branch and offers to open a pull request to the base. WHEN: sync with develop, update branch from develop, merge develop into my branch, resolve conflicts with develop, prepare branch for PR. DO NOT USE FOR: modifying develop directly, rebasing or force-pushing, merging pull requests."
argument-hint: "Optional: repository path/URL, base_branch (default develop), remote (default origin), build_command, test_command, pr_title, pr_body"
---

# Git Sync Develop

## Purpose

Update the current branch from `<remote>/<base_branch>` without ever modifying the base branch, keeping the human in control of every ambiguous decision, and finish with a validated, pushed branch and an optional pull request.

## When to Use

- The user asks to sync/update the current branch with `develop` (or another base).
- The user asks to merge the base into the current branch and fix resulting conflicts/build failures.

## When Not to Use

- The user wants to change `develop` itself, rebase, squash or force-push.
- The user wants to merge or approve a pull request.

## Inputs

| Input | Required | Default | If missing |
|---|---|---|---|
| `repository` (path or URL) | No | Current directory | Use the current directory if it is a Git repo; if a URL does not match and the clone destination cannot be inferred → ask. |
| `directory` | No | — | Ask only when cloning is needed. |
| `base_branch` | No | `develop` | — |
| `remote` | No | `origin` | — |
| `build_command` | No | Detected (Step 7) | Ask if several or none are plausible. |
| `test_command` | No | Detected (Step 7) | Ask if several or none are plausible. |
| `pr_title`, `pr_body` | No | Generated from the summary | — |

Never hardcode repository name, path, feature branch, language, framework, package manager or build command.

## Preconditions

- [ ] Exactly one repository is selected (if nested Git repositories exist, list them and ask which one).
- [ ] Current branch is not detached and is not the base branch.
- [ ] No merge, rebase, cherry-pick or revert is in progress (otherwise ask whether to continue or abort it first).

## Procedure

### 1. Locate and validate the repository

1. If `repository` is a local path → enter it. If it is a URL not matching the current directory → ask where to clone, unless it can be inferred safely.
2. Run `git rev-parse --show-toplevel`.
3. Run `git branch --show-current`. If detached HEAD → stop; ask the user to choose or create a branch.
4. If the current branch equals `base_branch` → stop; ask the user to switch to a work branch.
5. Run `git status --short`, `git remote -v`; record the chosen remote URL.
6. If an operation is in progress → stop and ask.
7. Show a short plan: current branch, remote, base, detected commands.

### 2. Protect local work

1. If there are uncommitted changes → do not proceed silently. Offer: (a) commit, (b) named stash, (c) cancel.
2. Execute only the option approved.
3. If stashed → record the stash id and restore it at the end. If restoring conflicts → apply the same human-decision rules as Step 6.

### 3. Authenticate without exposing secrets

1. Test access: `git ls-remote <remote> HEAD`.
2. GitHub with `gh` available → `gh auth status`; if not authenticated → `gh auth login` (interactive) and configure Git to use the credentials approved by the user.
3. GitHub Enterprise → derive the hostname from the remote URL and use it for login.
4. SSH → test via the remote. Do not create or upload keys without consent.
5. Other providers → use the installed credential manager or official CLI. If no secure mechanism exists → explain the requirement and stop.
6. Repeat `git ls-remote <remote> HEAD`. Proceed only if it succeeds.

### 4. Update remote references

```bash
git fetch --prune <remote>
git show-ref --verify --quiet refs/remotes/<remote>/<base_branch>
```

- If `<remote>/<base_branch>` does not exist → list similar remote branches and ask. Never create `develop` automatically.
- Record for the summary:

```bash
git rev-parse HEAD
git rev-parse <remote>/<base_branch>
git log --oneline --decorate --max-count=10 HEAD..<remote>/<base_branch>
```

### 5. Create a recovery point

1. Record the current SHA.
2. Create a local backup reference (prefer branch `backup/sync-develop-<timestamp>`), unless it violates repository conventions.
3. Tell the user. Never push the backup reference.

### 6. Merge into the current branch

```bash
git merge --no-commit --no-ff <remote>/<base_branch>
```

1. No conflicts → go to Step 7 (validate before committing the merge).
2. Conflicts → list them: `git diff --name-only --diff-filter=U`.
3. For each file, inspect base, ours, theirs and related context.
4. Classify each conflict as **mechanical** (compatible changes, intent fully preserved) or **semantic** (both versions plausible).
5. Resolve automatically only unambiguous mechanical conflicts; show what was done.
6. For each semantic conflict, ask using exactly:

```text
Conflict in <file>, region <symbol/lines>.
- Current branch: <objective summary>
- develop: <objective summary>
- Known impact: <verifiable impact>
Options: keep current, keep develop, combine as proposed, or provide other guidance.
Which option should I apply?
```

7. Never choose `ours` or `theirs` globally.
8. After decisions, remove all markers and validate with `git diff --check` and a search for `<<<<<<<`, `=======`, `>>>>>>>` in the relevant tracked files.

### 7. Detect build, tests and project rules

1. Read repository instructions first: `AGENTS.md`, `CONTRIBUTING.md`, `README`, CI files, versioned scripts. Prefer documented commands.
2. Otherwise detect (never run unknown scripts automatically):

| Ecosystem | Marker | Commands |
|---|---|---|
| Maven | `pom.xml` | `./mvnw` (preferred) or `mvn`; documented goals or defaults |
| Gradle | `build.gradle*` | `./gradlew` (preferred) or `gradle` |
| Node | `package.json` + lockfile | Package manager from the lockfile; only scripts that exist in `package.json` |
| .NET | `*.sln`/`*.csproj` | `dotnet restore`, `dotnet build`, `dotnet test` |
| Python | `pyproject.toml`, `tox.ini`, `noxfile.py` | Project-defined tool (`tox`, `nox`, `pytest`) |
| Go | `go.mod` | `go build ./...`, `go test ./...` |
| Rust | `Cargo.toml` | `cargo build`, `cargo test` |
| Monorepo | workspace config | Run in the documented order |

3. If several commands are plausible or none is reliable → present the options and ask.

### 8. Build, test and fix

1. Install/restore dependencies only through the project's mechanism.
2. Run build, tests, lint and static analysis as documented, in an order that gives useful diagnostics.
3. Record command, exit code and error summary for each run.
4. Classify failures: environment, dependency, compilation, test, lint, static analysis.
5. Fix automatically only when cause and intent are clear and the change is minimal.
6. For ambiguous fixes → present evidence and alternatives; ask.
7. After each fix → rerun the specific failing check first, then the relevant full suite.
8. If the same failure persists after two well-founded attempts → stop, summarize attempts and ask for a decision.
9. Change a test only with evidence that it is obsolete; when in doubt, ask.

### 9. Review and complete the merge

1. Show `git status --short`, `git diff --stat` and a summary of changed files.
2. Check for apparent secrets, unwanted generated artifacts or unrelated files.
3. Create the merge commit only after validation, e.g. `Merge develop into <current-branch>`.
4. Do not register the action as a feature, issue or backlog item unless asked.

### 10. Publish the current branch

1. Check whether the branch has an upstream.
2. Show the target branch and remote before pushing.
3. Push normally (`git push -u <remote> <current-branch>` when needed).
4. If push fails due to divergence → do not overwrite the remote; show the diagnosis and ask.

### 11. Final summary and pull request

1. Present: repository and current branch; integrated base SHA; conflicts and decisions; fixes applied; build/test commands and results; commit and push done; pending items and risks.
2. Ask exactly one authorization question:

```text
The current branch is synced with develop and the checks passed. Do you want me to open a pull request from the current branch to develop?
```

3. Only after a "yes":
   1. Confirm base `develop`, head = current branch, title and summary.
   2. Use the provider CLI; for GitHub:
      ```bash
      gh pr create --base develop --head <current-branch> --title "<title>" --body "<summary>"
      ```
   3. Return the PR link.
   4. Do not approve or merge the PR.

### Failure handling and rollback

- Unresolved conflict → keep the state for analysis or offer `git merge --abort`. Abort only with user approval, unless an automated step failed before any human decision and aborting is required to return safely to the initial state.
- Build/tests fail and the user cancels → offer to keep changes for diagnosis or abort the merge.
- Never delete the backup reference before the user's final confirmation. On success, explain how to remove it; do not remove it automatically.

## Rules

### MUST

- Make all changes on the current branch.
- Show a short plan before changing anything.
- Commit only after build and tests pass, or with explicit user authorization to record an incomplete state.
- Stop safely and preserve diagnostics when unable to continue.

### MUST NOT

- Check out `develop` to modify it, push to `develop`, or merge the PR.
- Discard local changes: no `reset --hard`, `clean -fd`, `checkout -- <file>`, destructive `restore`, force push or rebase without explicit authorization.
- Request, print, store, commit or put in a URL any token, password or secret.
- Resolve semantically ambiguous conflicts alone.
- Change business rules, public contracts, migrations, security configuration, workflows, infrastructure files or main dependencies just to make checks pass; ask instead.
- Skip, disable or weaken tests, linters, static analysis, hooks or security checks; no skip flags without explicit authorization.
- Invent build/test commands or script names not found in the repository.

## Output

- Merged, validated and pushed current branch.
- Final summary (Step 11) and, if authorized, the PR link.
- Output language: English.

## Done Criteria

- [ ] Current branch contains the latest `<remote>/<base_branch>`.
- [ ] No pending conflicts or markers.
- [ ] Relevant build and tests ran and passed, or a limitation was explicitly accepted by the user.
- [ ] No check was skipped silently.
- [ ] Current branch pushed successfully (when needed for the PR).
- [ ] User consulted before creating the PR; if created, it targets current branch → `develop`.
