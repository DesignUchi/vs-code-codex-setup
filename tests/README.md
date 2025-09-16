Test scaffolds

- Python (pytest):
  - File: tests/test_sanity.py
  - Runs automatically in ci-local if pytest is available; otherwise skipped.

- Node (built-in test runner):
  - File: tests/node/smoke.test.js
  - To enable via npm scripts, set in package.json:
    {
      "scripts": { "test": "node --test" }
    }
  - ci-local runs `npm test` only if package.json exists and has a test script.

