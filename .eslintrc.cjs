// .eslintrc.cjs — generic JS/TS + Prettier
module.exports = {
  root: true,
  env: { browser: true, node: true, es2023: true },
  parser: "@typescript-eslint/parser",
  parserOptions: { ecmaVersion: "latest", sourceType: "module" },
  plugins: ["@typescript-eslint"],
  extends: [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:prettier/recommended"
  ],
  ignorePatterns: ["dist", "build", ".next", ".astro", "node_modules"]
};
