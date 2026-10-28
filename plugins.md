# Plugins with Composer and Renovate

This guide explains how Excentric sites install, update and deploy WordPress plugins. It also gives the steps to set this up on a new or an existing site. You need Composer, GitHub and a browser.

## How it works

The repository lists the plugins that a site uses, and the exact version of each plugin. Nobody installs or updates plugins in wp-admin.

| Part | Function |
|---|---|
| `composer.json` | The list of plugins and the version of each |
| `composer.lock` | The exact files for those versions. Composer writes this file. Do not edit it |
| [Composer](https://getcomposer.org) | Downloads the plugins in `composer.lock` |
| [WPackagist](https://wpackagist.org) | The source for plugins from the WordPress.org directory, as `wpackagist-plugin/<slug>` |
| Vendor repositories | The source for paid plugins that support Composer, for example ACF Pro |
| [Renovate](https://docs.renovatebot.com) | Finds new plugin versions each Monday and opens a pull request for each |
| Checks (`checks.yml`) | Installs the plugins on each pull request, so that a broken update fails before the merge |
| Deploy (`deploy.yml`) | Installs the plugins and copies the plugins folder to WP Engine |

A plugin update is a normal pull request. When it merges, it goes to staging. When an Excentric developer deploys production, it goes to production. If it causes a problem, you revert it as you revert other changes.

## Setting up a new site

Sites made from `excentric-wp-site-template` already have `composer.json`, `renovate.json` and the two workflows. Complete the `SETUP.md` of the site first.

You need [Composer](https://getcomposer.org) on your computer. Herd includes Composer. If you do not use Herd, install it from getcomposer.org. To check the installation, run `composer --version`.

1. Open `composer.json` and remove the example plugins that the site does not use.
2. In the site root, add each plugin at the version that the site uses:
   ```bash
   composer require wpackagist-plugin/<slug>:<version>
   ```
   The slug is the last part of the WordPress.org address of the plugin. For `wordpress.org/plugins/wordpress-seo/`, the slug is `wordpress-seo`. For example: `composer require wpackagist-plugin/wordpress-seo:28.5`.
3. Add the paid plugins, as described in [Paid plugins](#paid-plugins). If the site does not use ACF Pro, remove the ACF Pro repository and `require` line from `composer.json`. Also remove its `hostRules` entry from `renovate.json`.
4. If a paid plugin has a Composer repository, add its credentials to `auth.json` on your computer and to the GitHub secret `COMPOSER_AUTH`. See [Credentials](#credentials). The checks on the next pull request need the secret.
5. Run `composer install` and check the site. The plugins folder now contains only the listed plugins.
6. Commit `composer.json` and `composer.lock` in a pull request with the title `Plugins: manage with Composer`. When the checks pass, merge it.
7. In the repository, go to **Settings → Secrets and variables → Actions → Variables**. Add `DEPLOY_PLUGINS` with the value `true`.
8. Run the deploy for staging and check the site.
9. Set up Renovate, as described in [Setting up Renovate](#setting-up-renovate).
10. Optional: lock the plugin buttons in wp-admin on staging and production. Ask WP Engine support to add this line to `wp-config.php`, or add it through SFTP:
    ```php
    define( 'DISALLOW_FILE_MODS', true );
    ```
    This line removes the install and update buttons from wp-admin, so that nobody updates a plugin there by mistake.

## Moving an existing site

The steps are the same as for a new site, with one more precaution.

> [!WARNING]
> Before the first plugin deploy, add every plugin that the site uses to `composer.json`. A plugin deploy copies the plugins folder exactly. It deletes each plugin on the server that is not in the repository.

1. In wp-admin on production, go to **Plugins**. Write down each plugin and its version. Do the same on staging.
2. Add each plugin that the site keeps to `composer.json`, at the version that production uses.
3. Deactivate each plugin that the site does not keep. The first plugin deploy deletes it.
4. Merge the pull request. At this point, deploys do not include plugins yet.
5. Set `DEPLOY_PLUGINS` to `true`. Deploy staging and check the site. Then deploy production.

## Setting up Renovate

Do these steps one time for each repository.

1. An organization owner installs the app. Open [github.com/apps/renovate](https://github.com/apps/renovate) and select **Configure**. Select Excentric-Agency. Under **Repository access**, select **Only select repositories** and add the repository. To add more repositories later, go back to the same page.
2. Check `renovate.json`. The file from the template is ready to use. If the site has a paid plugin with a Composer repository, add its credentials as in the next step.
3. Add the credentials for paid plugins in the settings of Mend. Mend is the company that makes Renovate, and [developer.mend.io](https://developer.mend.io) is the settings page for Renovate. Renovate runs on the servers of Mend, not on GitHub, so it cannot read GitHub secrets. It has its own secrets.
   1. Sign in to developer.mend.io with GitHub.
   2. Open the Excentric-Agency organization and go to its settings.
   3. Add each secret that `renovate.json` names. For example, add `ACF_PRO_LICENSE_KEY` with the licence key as its value. A secret for the organization works on all repositories.
   4. In `renovate.json`, set the ACF `password` to the production address of the site.
4. Wait for the first run. Renovate makes an issue with the title **Dependency Dashboard**. The issue lists each plugin and the updates that are available. After the first run, Renovate opens pull requests each Monday before 9 a.m.

## Reviewing a plugin update

Each update comes as a pull request with a title such as `Plugins: update contact-form-7 to 6.1.8` and the label `plugins`. Security fixes come immediately, with the label `security`.

1. Read the release notes in the description of the pull request. Look for breaking changes, new PHP or WordPress requirements and database updates.
2. Wait for the checks. The **Plugins install** check shows that the new version downloads and installs.
3. Select **Squash and merge**. The update deploys to staging.
4. Check staging. Use the "Check after updating" column in the plugin table of the README. In wp-admin, look for notices and for a database update prompt.
5. Deploy production and do the same check on the live site.

Merge major versions (for example 28.x to 29.0) one at a time. Do not merge them immediately before a launch.

| Condition | Action |
|---|---|
| The update breaks something on staging | Select **Revert** on the merged pull request. Merge the revert, then deploy. |
| Renovate opens the update again after a revert | Close that pull request without a merge. Renovate then skips that version and waits for the next release. |
| A plugin must never update | In `renovate.json`, add this rule inside `packageRules`: `{ "matchPackageNames": ["wpackagist-plugin/<slug>"], "enabled": false }`. |

## Updating a plugin before Renovate does

Renovate runs on Monday. To update a plugin before then, use one of these two methods.

With the Dependency Dashboard:

1. Open the **Dependency Dashboard** issue.
2. Find the plugin under **Awaiting Schedule** and select its checkbox. Renovate opens the pull request in a few minutes.

With the command line:

1. In the site root, run:
   ```bash
   composer require wpackagist-plugin/<slug>:<new-version>
   ```
2. Commit `composer.json` and `composer.lock` in a pull request with the title `Plugins: update <slug> to <new-version>`.

## Keeping a plugin on the latest version

For a low-risk plugin, Renovate can merge the updates when the checks pass. Add a rule to `packageRules` in `renovate.json`:

```json
{
    "matchPackageNames": ["wpackagist-plugin/simple-history"],
    "automerge": true
}
```

The update still goes through a pull request and the checks. If the checks pass, Renovate merges the pull request, and the update deploys to staging. Production gets the update at the next production deploy, because production deploys are always manual. To merge the minor and patch releases of all plugins automatically, use `"matchUpdateTypes": ["minor", "patch"]` in place of `matchPackageNames`.

Do not use automerge for plugins that change the database or the front end in ways that the checks cannot find. Examples are page builders, forms, SEO and e-commerce plugins.

## Adding and removing plugins

| Task | Steps |
|---|---|
| Add | Run `composer require wpackagist-plugin/<slug>:<version>`. Commit the two Composer files in a pull request, merge and deploy. Then activate the plugin in wp-admin. |
| Remove | Deactivate the plugin in wp-admin on staging and production. Then run `composer remove wpackagist-plugin/<slug>` and commit the two files in a pull request. The deploy deletes the folder of the plugin. |

## Plugins that are not in a directory

Some plugins have no WordPress.org listing. Excentric builds some of them, and some are only on GitHub. The method depends on how many sites use the plugin.

| Plugin | Location | Updates |
|---|---|---|
| Built for one site | In the repository of the site | Edited as the theme is, in pull requests |
| Built by Excentric, used on more than one site | Its own repository, installed by Composer | Release a new version. Renovate then opens a pull request on each site |
| Third-party, on GitHub | Its GitHub repository, installed by Composer | Renovate, if the author tags releases |

### Built for one site

Keep the plugin in the repository of the site, next to the theme. Start the folder name with the client prefix, for example `wp-content/plugins/<client>-booking/`. The `.gitignore` of the template already includes `wp-content/plugins/<client>-*/`, with `<client>` replaced by the short name of the client. For code that must always run and that nobody can deactivate, use `wp-content/mu-plugins/` with the same prefix.

The checks and the deploy include the plugin with the other files. The plugin is not in `composer.json`, and no other step is necessary.

### Built by Excentric, used on more than one site

Make a repository for the plugin from `excentric-wp-plugin-template`, with the name `excentric-<name>`. The template includes the files below. It also has a workflow that attaches an installable zip file to each release. The `composer.json` of the plugin is:

```json
{
    "name": "excentric-agency/excentric-<name>",
    "description": "What the plugin does, in one line.",
    "type": "wordpress-plugin",
    "require": {
        "composer/installers": "^2.3"
    }
}
```

To release a version:

1. Change the version number in the main PHP file of the plugin, and merge the change.
2. On GitHub, select **Releases → Draft a new release**, and add a tag with the version, for example `1.2.0`.

On each site that uses the plugin, add the repository and the version to `composer.json`:

```json
"repositories": [
    {
        "type": "vcs",
        "url": "https://github.com/Excentric-Agency/excentric-<name>"
    }
],
"require": {
    "excentric-agency/excentric-<name>": "1.2.0"
}
```

The repository is private, so Composer needs a GitHub token to download it:

1. On github.com, go to **Settings → Developer settings → Fine-grained tokens** and make a token. Set Excentric-Agency as the owner. Give it access to the plugin repositories only, with **Contents: Read-only**.
2. Add the token to `COMPOSER_AUTH` and to `auth.json`:
   ```json
   "github-oauth": {
       "github.com": "<token>"
   }
   ```
3. Give the Renovate app access to the repository of the plugin, as described in [Setting up Renovate](#setting-up-renovate). Renovate can then find new releases.

Tokens expire. Add a calendar reminder for the expiry date, and replace the token in the two locations before that date.

### Third-party, on GitHub

If the repository of the plugin has a `composer.json`, add it as a `vcs` repository, as in the previous section. A public repository does not need a token.

If the repository has no `composer.json`, install the plugin from its release zip with a `package` repository, as in [Option 3](#option-3-a-zip-on-a-private-web-address). Use the address of the zip on the GitHub releases page. Renovate cannot find new versions of a `package` repository, so look for new releases manually.

## Paid plugins

Use the first option that applies.

| Option | Condition | Updates |
|---|---|---|
| 1. The Composer repository of the vendor | The vendor has one, for example ACF Pro, Yoast SEO Premium, WP Migrate or Admin Columns Pro. Look in the documentation of the vendor | Renovate, as for other plugins |
| 2. Commit the plugin to the repository | The plugin is only available from the portal of the vendor | Manually, in a pull request |
| 3. A zip on a private web address | More than one site uses the plugin, and you do not want to commit it to each repository | Manually: upload the zip, then change the version and the address |
| 4. SatisPress | The agency uses many portal-only plugins on many sites | Automatic, through SatisPress |

### Option 1: the Composer repository of the vendor

The Composer instructions of the vendor give a repository address, a package name and credentials.

1. Add the repository to `composer.json`. Use the ACF Pro entry as a model.
2. Add the credentials to `COMPOSER_AUTH` and to `auth.json` on your computer.
3. Add a `hostRules` entry with a secret to `renovate.json`, so that Renovate can find new versions.

### Option 2: commit the plugin to the repository

Use this option for a plugin that is only available from the site of the vendor. It replaces the old method of uploading the zip to an FTP link.

1. Download the zip from the portal of the vendor. Unzip it into `wp-content/plugins/`, so that you have a folder such as `wp-content/plugins/wp-rocket/`.
2. In `.gitignore`, in the plugins section, add a line for the folder: `!/wp-content/plugins/wp-rocket/`.
3. Commit the folder in a pull request with the title `Plugins: add WP Rocket 3.17.2`.
4. In the plugin table of the README, write that the plugin updates manually, and where to download it.

To update the plugin, delete the folder and unzip the new version in its place. Open a pull request with the title `Plugins: update WP Rocket to 3.18.0`. Renovate cannot find these plugins. Subscribe to the release emails of the vendor, or look in the portal each month.

### Option 3: a zip on a private web address

Upload the zip to a web address that is not public, for example a password-protected folder on the agency server. Composer needs an `https://` address. Then add the plugin to `composer.json`:

```json
"repositories": [
    {
        "type": "package",
        "package": {
            "name": "excentric/wp-rocket",
            "version": "3.17.2",
            "type": "wordpress-plugin",
            "dist": {
                "type": "zip",
                "url": "https://<private-host>/plugins/wp-rocket-3.17.2.zip"
            },
            "require": {
                "composer/installers": "^2.3"
            }
        }
    }
]
```

Then require it with `"excentric/wp-rocket": "3.17.2"`. If the address has a password, add the credentials to `COMPOSER_AUTH` and `auth.json` under `http-basic`. To update the plugin, upload the new zip. Then change `version`, `url` and the `require` line at the same time.

### Option 4: SatisPress

[SatisPress](https://github.com/cedaro/satispress) is a WordPress plugin. It changes a small, separate WordPress site into a private Composer repository. You install the paid plugins on that site with their licences, and WordPress keeps them up to date. SatisPress then gives each version to Composer and Renovate. This option suits an agency that uses many portal-only plugins on many sites. If the licence of a plugin does not allow updates on that site, you must still upload that plugin manually.

## Credentials

A paid plugin with a Composer repository needs its credentials in three locations. The table uses ACF Pro as the example. Other vendors use the same pattern with their own host name.

| Location | Content | Used by |
|---|---|---|
| `auth.json` in the site root, on your computer | The credentials file. Git ignores it | `composer install` on your computer |
| GitHub: **Settings → Secrets and variables → Actions → Secrets**, `COMPOSER_AUTH` | The content of `auth.json`, on one line | Checks and deploys |
| [developer.mend.io](https://developer.mend.io): **Settings → Secrets** of the repository | The licence key, with the name in `renovate.json` | Renovate |

For ACF Pro, get `auth.json` from the ACF account, under **Licenses → Install using Composer**. The format is:

```json
{
    "http-basic": {
        "connect.advancedcustomfields.com": {
            "username": "<licence key>",
            "password": "<https://live-domain>"
        }
    }
}
```

The password is the production address of the site, with `https://`. If a renewed licence has a new key, update the key in all three locations.

## Troubleshooting

| Problem | Cause and solution |
|---|---|
| **Plugins install** fails with "401" or "403" | The credentials are missing or incorrect. Check `COMPOSER_AUTH`, and check that the licence is active. |
| **Plugins install** fails with "lock file is not up to date" | Somebody edited `composer.json` and did not update the lock file. Run `composer update <package>` and commit `composer.lock`. |
| Composer cannot find a plugin version | WPackagist can need a few hours to list a new WordPress.org release. Wait, or use the previous version. |
| Renovate opens no pull requests | Look for errors in the Dependency Dashboard issue. Check that the app has access to the repository. |
| Renovate cannot find ACF Pro versions | The secret in developer.mend.io is missing, or its name is different from the name in `renovate.json`. |
| A plugin is not on the server after a deploy | The plugin was not in `composer.json`. Add it and deploy again. The database keeps its settings. |
