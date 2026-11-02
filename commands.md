# Command cheatsheet

The commands that Excentric developers use most, in one place. Each row links to the guide with the full steps and the reasons. Run the commands in the root folder of the repository, unless a row says otherwise. Replace each `<placeholder>`.

The commands that start with `gh` need the GitHub CLI. Sign in once with `gh auth login`.

## Git and GitHub

[git-basics.md](git-basics.md) explains these steps. [CONTRIBUTING.md](CONTRIBUTING.md) has the rules for branches and pull requests.

| To do this | Run this |
|---|---|
| Copy a repository to your computer | `gh repo clone Excentric-Agency/<repository>` |
| Start a change from an up-to-date `main` | `git switch main && git pull && git switch -c feature/<short-name>` |
| See what changed | `git status`, then `git diff` |
| Undo the changes to one file that you did not commit | `git restore <file>` |
| Save the changes in a commit | `git add -A && git commit -m "Area: what changed"` |
| Send the branch to GitHub | `git push -u origin HEAD` |
| Open a pull request | `gh pr create --fill`, or `gh pr create --web` to write it on github.com |
| Watch the checks of the pull request | `gh pr checks --watch` |
| Bring the newest `main` into your branch | `gh pr update-branch`, or `git pull origin main` |
| List your open pull requests | `gh pr list --author "@me"` |
| Clean up after the merge | `git switch main && git pull && git branch -D feature/<short-name>` |

Use `feature/…`, `fix/…` or `update/…` for branch names. With squash merging, `git branch -d` refuses to delete a merged branch, so use `-D` after GitHub shows the pull request as **Merged**. Do not force-push, and do not start a branch from another branch that is not merged.

## WordPress sites

The README of each site has its checks and its deploy. [linting.md](linting.md) explains the checks, and [plugins.md](plugins.md) explains the plugins.

| To do this | Run this |
|---|---|
| Install the plugins and the tools | `composer install && npm install` |
| Check the PHP security rules | `composer lint` |
| Find PHP bugs (PHPStan) | `composer analyse` |
| Record the existing PHPStan issues again, after you fix some | `composer analyse -- --generate-baseline` |
| Check the CSS and JavaScript | `npm run lint` |
| Fix the formatting of the CSS and JavaScript | `npm run format` |
| Add a free plugin | `composer require wpackagist-plugin/<slug>:<version>` |
| Update one plugin | `composer update <package>` |
| Remove a plugin | `composer remove <package>` |
| List the plugins that have a newer version | `composer outdated --direct` |
| Save a GitHub token for the private Excentric plugins in `auth.json` | `composer config --auth github-oauth.github.com <token>` |
| Copy `auth.json` to the `COMPOSER_AUTH` secret of the repository | `gh secret set COMPOSER_AUTH -R Excentric-Agency/<repository> < auth.json` |
| Deploy `main` to production | `gh workflow run deploy.yml -f target=production` |
| Watch the deploy | `gh run watch` |
| Export the local database | `mysqldump -u root <database> > <file>.sql` |
| Replace a domain in the database (WP-CLI, over SSH on WP Engine) | `wp search-replace '<old URL>' '<new URL>' --skip-columns=guid --all-tables` |
| Clear the object cache (WP-CLI) | `wp cache flush` |

Only the users in `PRODUCTION_DEPLOYERS` can deploy to production. Before you replace a domain on a server, make a backup point in the WP Engine portal.

## Excentric plugins

The README of each plugin repository has its own steps. [plugins.md](plugins.md) explains how sites install them.

| To do this | Run this |
|---|---|
| Install the tools | `composer install && npm install` |
| Run the checks | `composer lint`, `composer analyse` and `npm run lint` |
| Run the browser test, if the plugin has one | `npm test`, with the settings in the README of the plugin |
| Update the translation template, if the plugin has one | `composer pot` |
| Publish a release after the version change is merged | `gh release create <1.2.0> --target main --generate-notes` |

## Excentric ACF UI, on a site

| To do this | Run this |
|---|---|
| Run the health check (WP-CLI) | `wp excentric-acf-ui check`, or `wp excentric-acf-ui check --fields` for the field list |
| Check an ACF folder for the names that the plugin needs, without WordPress | `php wp-content/plugins/excentric-acf-ui/bin/check-acf.php wp-content/plugins/advanced-custom-fields-pro` |

## A new repository

| To do this | Run this |
|---|---|
| Make a repository from a template | `gh repo create Excentric-Agency/<name> --private --template Excentric-Agency/<template>` |
| Apply the standard settings | `~/Projects/Excentric/.github/scripts/setup-repo.sh <name> <wp-site, wp-plugin, project or template>` |

The templates are `excentric-wp-site-template`, `excentric-wp-plugin-template` and `excentric-project-template`. After you make the repository, do the steps in its `SETUP.md`.
