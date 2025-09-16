// Minimal Node test using the built-in test runner (Node 18+)
// To run via npm, add to your package.json:
//   "scripts": { "test": "node --test" }

import test from 'node:test'
import assert from 'node:assert/strict'

test('node smoke passes', () => {
  assert.equal(1 + 1, 2)
})

