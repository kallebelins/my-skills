---
name: qa-sonar-quality-gate
description: "Fixes SonarQube issues from a SonarQube project link until the Quality Gate is Success: reads failing conditions in the browser, applies minimal fixes, adds tests so every production Java class changed in the session has at least 80% line coverage (bundled PowerShell script), builds, commits, pushes and re-checks the refreshed analysis in a loop. WHEN: user provides a SonarQube URL, fix Sonar quality gate, fix Sonar issues from link. DO NOT USE FOR: requests without a SonarQube URL (pasted issue lists or descriptions), non-Java projects, general unit test creation."
argument-hint: "SonarQube project Overview URL"
---

# SonarQube Quality Gate Fixer

## Purpose

Bring the project's SonarQube `Quality Gate Status` to `Success` with minimal, safe changes, without introducing new Sonar problems, and with ≥ 80% line coverage for every production Java class changed in this agent session.

## When to Use

- The user provides a SonarQube link (project Overview page) and asks to fix issues or the quality gate.

## When Not to Use

- No SonarQube URL was given (copied issue lists, messages or descriptions) → do not use; ask for the link.
- Non-Java/Maven modules (the coverage script supports Maven `src/main/java` + JaCoCo XML only).

## Inputs

| Input | Required | Source | If missing |
|---|---|---|---|
| SonarQube project Overview URL | Yes | User | Stop; ask for the URL. |
| Maven module directory | Yes | Folder containing `pom.xml` whose `src/main/java` holds the files reported by Sonar | Detect by matching Sonar file paths to the workspace; if none or several match → ask. |
| Base branch for diffs | No | `origin/develop` (script default) | Ask if the repository uses another base. |

## Preconditions

- [ ] A browser tool is available to open the SonarQube page; if not → stop and tell the user.
- [ ] JaCoCo is configured in the module (`target/site/jacoco/jacoco.xml` is produced by `mvn test`); if not → ask before adding it.
- [ ] Current branch is a feature branch (not `develop`/`main`/`master`).
- [ ] `<skill-dir>` is known: the folder that contains this `SKILL.md`. The script is `<skill-dir>\scripts\check-changed-classes-coverage.ps1`.

## Procedure

1. Open the SonarQube Overview page from the link in the integrated browser. If it is already open → refresh it before reading.
2. Tell the user the page is open and wait for them to finish authentication.
3. After confirmation, read `Quality Gate Status`, every failing condition and the last analysis time. If the gate is not `Success` → open `Issues` and `Measures` as needed and record, per cause: file, line, rule, severity and message.
4. Group the fixes by file; plan only changes that remove the causes of failing conditions.
5. From the module directory, before editing any file, create the session baseline:
   - `powershell -ExecutionPolicy Bypass -File <skill-dir>\scripts\check-changed-classes-coverage.ps1 -CreateSessionBaseline -SessionBaselineFile .\.sonar-correction-session-baseline.json`
6. Apply the fixes. If a production class (`src/main/java`) is touched → add/adjust unit tests for the relevant branches.
7. Run the focused tests for the changed set: `mvn -q -Dtest=<TestClass> test`.
8. Run the module test suite: `mvn -q test`.
9. Validate coverage per class changed in this session:
   - `powershell -ExecutionPolicy Bypass -File <skill-dir>\scripts\check-changed-classes-coverage.ps1 -MinimumCoverage 80 -SessionBaselineFile .\.sonar-correction-session-baseline.json`
10. If any class is below 80% → add tests and repeat steps 8–9.
11. Compile the module (`mvn -q compile`) to confirm nothing broke.
12. Commit only the files related to the Sonar fix (never the baseline JSON) and push to the current branch.
13. Return to the Overview page and refresh until the last analysis time is later than the push. Never treat a pre-push result as validation.
14. Re-read every Quality Gate condition. If any still fails → identify the current cause, fix it, run steps 7–12, and repeat from step 13.
15. Stop the loop only when the refreshed `Quality Gate Status` is exactly `Success`.

## Rules

### MUST

- Work only in the detected module.
- Prefer extracting constants, simplifying flow and targeted unit tests.
- Keep changes surgical.
- In new or changed tests, avoid duplicated code and repeated mock literals; extract fixtures, helpers or well-named constants.

### MUST NOT

- Request, read, record or fill passwords, tokens or other secrets.
- Change functional behavior without explicit need.
- Make broad refactors.
- Commit unrelated files or the session baseline file.
- Push to `develop`, `main` or `master`.
- Invent Sonar issues, rules or results not read from the page.

## Resources

| File | When to read |
|---|---|
| [scripts/check-changed-classes-coverage.ps1](scripts/check-changed-classes-coverage.ps1) | Steps 5 and 9. Parameters: `-BaseRef` (default `origin/develop`), `-MinimumCoverage` (default 80), `-CreateSessionBaseline`, `-SessionBaselineFile`. Must run from the module directory (expects `src/main/java` and `target/site/jacoco/jacoco.xml`). |

## Output

Respond exactly with:

```
# Sonar Fix Result

## Files Changed
- objective list of files.

## Issues Fixed
- item -> how it was fixed.

## Coverage per Changed Class
- summarized script output (class and percentage).

## Final Status
- "Done: Quality Gate Status = Success and coverage >= 80% on changed classes."
```

Output language: English.

## Done Criteria

- [ ] Last analysis time is later than the last push.
- [ ] Refreshed `Quality Gate Status` is `Success`.
- [ ] All issues and conditions that caused the failure are fixed.
- [ ] Tests pass.
- [ ] Coverage script succeeds for the changed classes.
