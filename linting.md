# Code checks and linting

A linter is a tool that reads code and reports likely mistakes, without running the code. This guide lists the tools that Excentric WordPress sites use, and the reason for each. It also explains how to set them up on your computer and in your editor, and how to adopt them on an existing site.

The site template (`excentric-wp-site-template`) contains the settings files. The **Checks** workflow runs the same tools on each pull request, before the code reaches staging.

## The tools

| Code | Tool | What it finds | Settings file |
|---|---|---|---|
| PHP | `php -l` | Syntax errors. A syntax error shows a white screen | none |
| PHP | PHP_CodeSniffer with the WordPress Coding Standards | Security issues only: output that is not escaped, form data that is not sanitized, missing nonces, SQL that is not prepared | `phpcs.xml.dist` |
| PHP | PHPCompatibilityWP | Code that does not work on PHP 8.1 or later | `phpcs.xml.dist` |
| PHP | PHPStan | Bugs: wrong types, undefined variables, conditions that are always true or always false. Optional | `phpstan.neon.dist` |
| CSS and JavaScript | Biome | Likely mistakes, for example duplicate properties, unused variables and `==` instead of `===`. Also formatting | `biome.json` |
| CSS | Brace count | A missing `}`. All the rules after it stop working | none |

Escaping changes text so that a browser shows it and does not run it. A nonce is a single-use token that WordPress adds to a form to stop forged requests.

PHPCompatibilityWP 2.1 uses PHPCompatibility 9.3, which knows PHP versions up to 8.0. It does not find all the changes in PHP 8.1 and later. When PHPCompatibility 10 is stable, change the version in `composer.json`.

## Why these tools

| Decision | Reason |
|---|---|
| PHP_CodeSniffer for PHP security | It is the only tool with the WordPress security rules. WordPress core and the plugin review team use the same rules |
| Security rules only, not the full WordPress standard | The full standard also checks spacing and naming. On an existing theme, it reports thousands of formatting issues and hides the security issues. The `.editorconfig` file covers spacing |
| PHPStan for bugs | It finds bugs that the security rules do not find. The `szepeviktor/phpstan-wordpress` extension tells it the WordPress functions, and `php-stubs/acf-pro-stubs` the ACF functions |
| PHPStan level 5 | Levels go from 0 to 10. Level 5 finds real bugs. Level 6 and higher ask for type notes on most functions, which older code does not have |
| PHPStan is optional | On a page builder site, most of the PHP is not ours. Delete `phpstan.neon.dist` there |
| Biome for CSS and JavaScript | One program finds mistakes and formats both languages. It replaces ESLint, Stylelint and Prettier, with one settings file. Editors find it in the project, at the version in `package.json` |

### Tools that we do not use

| Tool | What it is | Reason |
|---|---|---|
| Psalm | A bug finder like PHPStan, with taint analysis: it follows user input to unsafe output | It does the same job as PHPStan, and its WordPress support is smaller. The WordPress security rules already cover unsafe output. Two tools for one job double the settings |
| PSR-12 and PER Coding Style | Style rules for PHP from the wider PHP community | They conflict with the WordPress style: tabs, spaces inside brackets, and snake_case names. All WordPress code and examples use the WordPress style |
| Laravel Pint | A PHP formatter, with presets for Laravel, PSR-12 and PER | It has no WordPress preset, and it only formats. For the WordPress style, `phpcbf` from PHP_CodeSniffer can fix spacing |
| Prettier | A formatter for CSS and JavaScript, with a community plugin for PHP | It only formats. It does not find mistakes. Biome formats CSS and JavaScript, and the PHP plugin does not follow the WordPress style |
| ESLint and Stylelint | Linters for JavaScript and for CSS | Biome covers the rules that we use, with one tool and one settings file. A theme with an npm build can use them through `@wordpress/scripts`. See [Themes with an npm build](#themes-with-an-npm-build) |

These tools are good choices in other kinds of projects, for example Pint and PSR-12 in a Laravel application.

## Setting up your computer

Do these steps one time for each site. You need PHP, Composer and Node.js. Laravel Herd and Local include PHP. Install Composer and Node.js if you do not have them.

1. Open a terminal in the root folder of the site, the folder with `composer.json` and `package.json`.
2. If the site has paid plugins, add `auth.json` first, as described in `plugins.md`. Then run `composer install` to install the PHP tools and the plugins.
3. Run `npm install` to install Biome.

Both commands install the exact versions in `composer.lock` and `package-lock.json`, into `vendor/` and `node_modules/` in the site folder. They install nothing on the rest of your computer.

## Running the checks

Run these commands in the root folder of the site.

| Check | Command |
|---|---|
| PHP security and compatibility, for all our PHP files | `composer lint` |
| PHP bugs (PHPStan) | `composer analyse` |
| CSS and JavaScript | `npm run lint` |
| Fix the formatting and the safe issues in CSS and JavaScript | `npm run format` |

## Editors

Each site contains shared settings for Zed and VS Code, so that the editor shows the same issues as the checks. Use these settings. Do not change them for one person. Personal settings go in the user settings of your editor.

| What the editor does | Zed | VS Code |
|---|---|---|
| Shows Biome issues as you type | Yes | Yes |
| Formats CSS and JavaScript on save, with Biome | Yes | Yes |
| Shows PHPStan issues as you type | Yes, through Phpactor. It also shows the issues in the baseline | Yes |
| Shows the WordPress security issues as you type | No. Run the task **Check: PHP security and compatibility** | Yes |
| Formats PHP on save | No, on purpose | No, on purpose |

### Zed

The site contains `.zed/settings.json`, `.zed/tasks.json` and `.phpactor.json`.

1. Do the steps in [Setting up your computer](#setting-up-your-computer).
2. In Zed, open the command palette and run `zed: extensions`. Install **Biome**, from the Biome team, and **PHP**, from Zed Industries.
3. Open the root folder of the site in Zed.
4. When Phpactor asks if you trust the folder, select trust. Phpactor reads `.phpactor.json` only in a trusted folder, and this file turns on PHPStan.
5. To run a check, open the command palette, run `task: spawn`, and select a **Check:** task.

Zed has no reliable extension for the WordPress security rules. Do not install a third-party extension for them. Use the task instead. The pull request checks run them too.

### VS Code

The site contains `.vscode/settings.json` and `.vscode/extensions.json`.

1. Do the steps in [Setting up your computer](#setting-up-your-computer).
2. Open the root folder of the site in VS Code.
3. When VS Code shows **Do you want to install the recommended extensions**, select **Install**. To see them later, open the Extensions view and type `@recommended`.

| Extension | ID | Purpose |
|---|---|---|
| Biome | `biomejs.biome` | Biome issues and formatting. Published by the Biome team |
| PHP Sniffer & Beautifier | `valeryanm.vscode-phpsab` | The WordPress security issues. The settings point it to `vendor/bin/phpcs`, and it finds `phpcs.xml.dist` |
| PHPStan | `sanderronde.phpstan-vscode` | PHPStan issues |
| PHP Intelephense | `bmewburn.vscode-intelephense-client` | PHP completion and navigation. The free features are enough |

The settings turn off the fixer of PHP Sniffer & Beautifier, so that it does not change PHP files on save.

### PhpStorm

PhpStorm settings are not shared in the repository. Set them one time for each site:

1. In **Settings → PHP → Quality Tools**, turn on PHP_CodeSniffer and PHPStan. Select the files in `vendor/bin/` of the site, and the settings files `phpcs.xml.dist` and `phpstan.neon.dist`.
2. Install the **Biome** plugin from the JetBrains Marketplace. Set it to use the Biome in `node_modules/` of the site.

### Other editors

Use the tasks in the table in [Running the checks](#running-the-checks), or an editor extension from the publisher of the tool.

## On a pull request

The **Checks** workflow runs on each pull request:

- PHP syntax and the CSS braces, in all the files of our theme and plugins.
- The PHP security and compatibility rules, in the PHP files that the pull request adds or changes.
- PHPStan, if the site has `phpstan.neon.dist`. The issues in `phpstan-baseline.neon` do not fail the check.
- Biome, in all the CSS and JavaScript files of our theme and plugins.

If a check fails, open the **Checks** tab of the pull request. The issues also show on their lines in the **Files changed** tab.

GitHub Free does not block a merge when a check fails. Do not merge a pull request with a failed check unless an Excentric developer agrees. Write the reason in the pull request.

## Adopting the checks on an existing site

An existing theme usually has many issues. Adopt the checks in this order. Make a separate pull request for each step.

1. Run `npm run format` one time to format the CSS and JavaScript. The pull request changes only spacing and safe fixes. Title it `Code: format CSS and JavaScript with Biome`.
2. Fix the other issues that Biome reports. If a rule does not suit the site, turn it off in `biome.json`, and write the reason in the pull request.
3. To record the existing PHPStan issues, run `composer analyse -- --generate-baseline`. Commit `phpstan-baseline.neon`. After that, only new issues fail the check.
4. Fix the PHP security issues in a file when you work on that file. The check looks only at the files that a pull request changes. To see all the issues, run `composer lint`.

Exclude code that we did not write, for example a library in a `vendor/` folder or a font file in CSS. Add it to `biome.json`, `phpcs.xml.dist` and `phpstan.neon.dist`.

## Ignoring an issue

If an issue is not a mistake, add a comment on the line, with the reason:

```php
// phpcs:ignore WordPress.Security.EscapeOutput.OutputNotEscaped -- An editor pastes this widget code on purpose.
```

```php
/** @phpstan-ignore variable.undefined (WordPress sets $post in the loop) */
```

```css
/* biome-ignore lint/suspicious/noDuplicateProperties: fallback for browsers without dvh */
```

Do not turn off a rule for a whole file to hide its issues.

## Updating the tools

Renovate opens a pull request with the title `Checks: update <tool> to <version>` for each new version of a tool. The version of each tool is in `composer.lock` or `package-lock.json`, so every computer and the checks use the same version. Merge the pull request when the checks pass.

## Themes with an npm build

If a theme has a `package.json` with a build step in its own folder, it can use `@wordpress/scripts` for linting, with `npm run lint:js` and `npm run lint:css`. Then remove `biome.json`, the Biome lines in `package.json`, and the Biome steps in `checks.yml`. Write this in the README of the site.
