---
name: qa-java-unit-tests
description: "Creates, adjusts or reviews Java unit tests (JUnit 5 + Mockito) for Spring Boot or plain Java code, protecting observable behavior without bugs, flakiness or code smells, and enforcing at least 80% JaCoCo coverage per tested/changed production class. WHEN: create unit tests, add Java tests, fix failing test, increase coverage, review JUnit/Mockito tests. DO NOT USE FOR: integration/Testcontainers tests, frontend tests, fixing SonarQube quality gates from a Sonar link."
argument-hint: "Production class (or changed files) to test and, optionally, the scenarios to cover"
---

# Java Unit Tests (JUnit 5 + Mockito)

## Purpose

Create or adjust unit tests that protect the observable behavior of production code, are easy to maintain, isolated and deterministic, and reach at least 80% coverage per tested or changed production class.

## When to Use

- Create, add, adjust or review Java unit tests.
- A unit test fails and must be fixed.
- Coverage of a production class must be raised without introducing test smells.

## When Not to Use

- Integration tests (`@SpringBootTest`, Testcontainers) or frontend tests.
- Fixing a SonarQube quality gate from a Sonar link.

## Inputs

| Input | Required | Source | If missing |
|---|---|---|---|
| Production class(es) under test | Yes | User or changed files (`git status`/`git diff --name-only`) | Ask the user. |
| Build module | Yes | Nearest ancestor folder of the class containing `pom.xml` or `build.gradle*` | If none or several → ask. |
| Build tool | Yes | `mvnw`/`pom.xml` → Maven; `gradlew`/`build.gradle*` → Gradle | Ask if not detectable. |
| JaCoCo report path | Yes | Maven: `target/site/jacoco/jacoco.xml`; Gradle: `build/reports/jacoco/test/jacocoTestReport.xml` | Check the build file's JaCoCo config; if JaCoCo is not configured → ask before adding it. |
| Scenarios to cover | No | User | Derive from the method contract (Step 2). |

## Preconditions

- [ ] Build module and build tool detected.
- [ ] Current branch is a feature branch (not `develop`/`main`/`master`); otherwise ask before committing.

## Procedure

1. Locate the production class and its existing test class. Read only the changed method(s), their direct dependencies and the scenarios already covered.
2. Define scenarios by contract: expected result, expected error, effects on dependencies.
3. Reuse constants and fixtures already in the test file. For new repetition, extract the smallest well-named helper or constant.
4. Create or adjust tests without changing production code. If a test reveals a production bug or an isolation blocker → report it and ask before changing production code.
5. Run the focused test from the module directory:
   - Maven: `mvn -q -Dtest=<TestClassName> test` (or `./mvnw ...`)
   - Gradle: `./gradlew test --tests <TestClassName>`
6. If the focused test passes → run the module's full test suite (`mvn -q test` / `./gradlew test`).
7. Generate/read the JaCoCo XML report. For each tested or changed production class, check line coverage ≥ 80%.
8. If any class is below 80% → add scenarios for uncovered branches; repeat steps 5–7.
9. Compile the module (`mvn -q compile` / `./gradlew compileJava`) to confirm nothing broke.
10. Commit only the related test (and approved production) files and push to the current feature branch.

## Rules

### MUST

- Use JUnit 5 and Mockito: `@ExtendWith(MockitoExtension.class)`, `@Mock`.
- Instantiate the class under test explicitly, preferably in `@BeforeEach` when shared.
- Place tests in the mirror package under `src/test/java`; mock only the external dependencies of the class under test.
- Name tests by behavior using the pattern `{action}{Condition}{ExpectedResult}` in the same language already used by the project's tests (detect from existing test names; e.g. `updateWithoutRecordThrowsNotFound`).
- Use `assertThrows` for expected errors and assert the result or the interaction that represents the contract.
- Use `ArgumentCaptor` only when the arguments sent to a dependency are part of the protected behavior.
- Use `UUID.randomUUID()` for identities that need not be fixed.
- Validate one rule or observable flow per test; split scenarios that fail for different reasons.
- Extract `private static final` constants for literals reused in `when`, `thenReturn` and `verify`, and expressive factory methods for recurring fixtures.
- Make factory methods produce valid data by default; take parameters only for relevant variations.

### MUST NOT

- Test private details, incidental call order, trivial getters, or Mockito/Spring behavior.
- Use permissive mocks, `any()` or generic `verify()` when a specific argument is essential to the contract; nor add interaction checks that do not increase confidence.
- Duplicate arrangements, domain objects, assertion code or literals.
- Share mutable state between tests or depend on execution order.
- Use real clock, randomness or I/O without control.
- Hide behavior in overly generic helpers; keep the central arrangement and assertion visible.
- Catch or ignore exceptions to make a test pass.
- Remove or weaken existing tests without a clear functional justification.
- Push to `develop`, `main` or `master`.
- Invent build commands, report paths or module names not found in the repository.

## Output

Respond exactly with:

```
# Unit Test Result

## Files Changed
- objective list of files.

## Scenarios Covered
- scenario -> validated behavior.

## Test Quality
- fixtures, constants or helpers extracted to avoid duplication.

## Validation
- focused test, suite and coverage per tested class, with results.

## Final Status
- "Done: unit tests created or adjusted without bugs or code smells and with coverage >= 80% per tested class."
```

Output language: English.

## Done Criteria

- [ ] New or changed scenarios cover the requested contract.
- [ ] No avoidable duplication of code or mock literals.
- [ ] Every tested or changed production class has ≥ 80% coverage.
- [ ] Focused test and module suite pass; module compiles.
- [ ] No existing test was weakened or removed without functional justification.
- [ ] Changes committed and pushed to the current feature branch.
