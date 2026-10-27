# Plugins with Composer and Renovate

How Excentric sites install, update and deploy WordPress plugins, and how to set it up on a new or existing site. No special tools are needed beyond Composer, GitHub and a browser.

## How it works

The plugins a site runs, and the exact version of each, are listed in the repository. Nobody installs or updates plugins in wp-admin.

| Piece | What it does |
|---|---|
| `composer.json` | The list of plugins and the version of each |
| `composer.lock` | The exact files for those versions. Composer writes it, nobody edits it |
| [Composer](https://getcomposer.org) | Downloads the plugins listed in `composer.lock` |
| [WPackagist](https://wpackagist.org) | Where Composer finds plugins from the WordPress.org directory, as `wpackagist-plugin/<slug>` |
| Vendor repositories | Where Composer finds paid plugins that support it, such as ACF Pro |
| [Renovate](https://docs.renovatebot.com) | Checks for new plugin versions every Monday and opens a pull request for each |
| Checks (`checks.yml`) | Install the plugins on every pull request, so a broken update fails before it is merged |
| Deploy (`deploy.yml`) | Installs the plugins and mirrors the plugins folder to WP Engine |

A plugin update is an ordinary pull request. It goes to staging when merged and to production when an Excentric developer deploys, like any other change. If it causes a problem, it is reverted like any other change.

## Setting up a new site

Sites created from `excentric-wp-site-template` already have `composer.json`, `renovate.json` and both workflows. Complete the site's `SETUP.md` first.

You need [Composer](https://getcomposer.org) on your computer. Herd includes it. Otherwise, install it from getcomposer.org. Check with `composer --version`.

1. **List the plugins.** Edit `composer.json`. Remove the example plugins the site doesn't use, then add each plugin from the command line in the site root:
   ```bash
   composer require wpackagist-plugin/<slug>:<version>
   ```
   The slug is the last part of the plugin's WordPress.org address. For `wordpress.org/plugins/wordpress-seo/` it is `wordpress-seo`. Use the version the site should run, for example `composer require wpackagist-plugin/wordpress-seo:28.5`.
2. **Add paid plugins.** See [Paid plugins](#paid-plugins). If the site doesn't use ACF Pro, remove its repository and `require` line from `composer.json`, and its `hostRules` entry from `renovate.json`.
3. **Add credentials** for any paid plugin with a Composer repository: `auth.json` on your computer and the GitHub secret `COMPOSER_AUTH` (see [Credentials](#credentials)). The checks on the next pull request need the secret.
4. **Install locally.** Run `composer install` and check the site. The plugins folder now contains exactly the listed plugins.
5. **Commit** `composer.json` and `composer.lock` in a pull request titled `Plugins: manage with Composer`, and merge it once the checks pass.
6. **Turn on plugin deploys.** In the repository, go to **Settings → Secrets and variables → Actions → Variables** and add `DEPLOY_PLUGINS` with the value `true`. Run the deploy for staging and check the site.
7. **Turn on Renovate** (see [Setting up Renovate](#setting-up-renovate)).
8. **Lock wp-admin** (optional, recommended). Ask WP Engine support, or edit `wp-config.php` over SFTP, to add this line on staging and production:
   ```php
   define( 'DISALLOW_FILE_MODS', true );
   ```
   This removes the install and update buttons from wp-admin, so nobody updates a plugin there by mistake.

## Moving an existing site

The steps are the same, with one precaution. Plugin deploys mirror the plugins folder, so **any plugin on the server that isn't in the repository is deleted** by the first plugin deploy.

1. In wp-admin on production, go to **Plugins** and list every plugin with its version. Do the same on staging.
2. Add every plugin you want to keep to `composer.json` at the version production runs.
3. Deactivate any plugin you don't want to keep. The first plugin deploy deletes it.
4. Merge the pull request. Deploys still skip plugins at this point.
5. Set `DEPLOY_PLUGINS` to `true`, deploy staging and check the site. Then deploy production.

## Setting up Renovate

Do this once per repository.

1. **Install the app** (organization owner): open [github.com/apps/renovate](https://github.com/apps/renovate), select **Configure**, choose Excentric-Agency, and under **Repository access** select **Only select repositories**. Add the repository. To add later repositories, return to the same page.
2. **Check the configuration.** The template's `renovate.json` is ready to use. If the site has a paid plugin with a Composer repository, add its credentials as below.
3. **Add credentials for paid plugins.** Renovate is made by Mend, and [developer.mend.io](https://developer.mend.io) is its settings page. Renovate runs on Mend's servers, not GitHub's, so it can't read GitHub's secrets and keeps its own. Sign in there with GitHub, open the Excentric-Agency organization, go to its settings, and add each secret named in `renovate.json`, for example `ACF_PRO_LICENSE_KEY` with the licence key as its value. A secret stored for the organization works on every repository. In `renovate.json`, set the ACF `password` to the site's live URL.
4. **Wait for the first run.** Shortly after, Renovate creates an issue called **Dependency Dashboard** listing every plugin and any pending updates. From then on it opens pull requests each Monday before 9 a.m.

## Reviewing and approving a plugin update

Each update arrives as a pull request titled like `Plugins: update contact-form-7 to 6.1.8`, labelled `plugins`. Security fixes arrive straight away, labelled `security`.

1. **Read the release notes** in the pull request description. Look for breaking changes, new PHP or WordPress requirements, and database updates.
2. **Wait for the checks.** **Plugins install** confirms the new version downloads and installs.
3. **Squash and merge.** The update deploys to staging.
4. **Check staging.** Use the "Check after updating" column of the plugin table in the site's README, and look in wp-admin for notices or a database update prompt.
5. **Deploy production** and repeat the check on the live site.

Merge major versions (for example 28.x to 29.0) one at a time, and not right before a launch.

| If | Do this |
|---|---|
| The update breaks something on staging | Select **Revert** on the merged pull request, merge the revert, and deploy. |
| Renovate reopens the update after a revert | Close that pull request without merging. Renovate then skips that version and waits for the next release. |
| You never want updates for a plugin | Add a rule to `renovate.json`: `{ "matchPackageNames": ["wpackagist-plugin/<slug>"], "enabled": false }` inside `packageRules`. |

## Updating a plugin yourself

To update before Renovate's Monday run, use either:

- **The Dependency Dashboard:** open the issue, find the plugin under **Awaiting Schedule**, and tick its box. Renovate opens the pull request within minutes.
- **The command line:** in the site root, run
  ```bash
  composer require wpackagist-plugin/<slug>:<new-version>
  ```
  Commit `composer.json` and `composer.lock` in a pull request titled `Plugins: update <slug> to <new-version>`.

## Keeping a plugin on the latest version

For low-risk plugins, Renovate can merge updates itself once the checks pass. Add a rule to `packageRules` in `renovate.json`:

```json
{
    "matchPackageNames": ["wpackagist-plugin/simple-history"],
    "automerge": true
}
```

The update still goes through a pull request and the checks. If they pass, Renovate merges it, and it deploys to staging. Production gets it at the next production deploy, because production deploys are always manual. To automerge every plugin's minor and patch releases instead, use `"matchUpdateTypes": ["minor", "patch"]` in place of `matchPackageNames`.

Keep automerge off for plugins that change the database or the front end in ways the checks can't see, such as page builders, forms, SEO and e-commerce.

## Adding and removing plugins

| Task | Steps |
|---|---|
| Add | `composer require wpackagist-plugin/<slug>:<version>`. Commit both Composer files in a pull request, merge and deploy, then activate the plugin in wp-admin. |
| Remove | Deactivate the plugin in wp-admin on staging and production. Then run `composer remove wpackagist-plugin/<slug>` and commit both files in a pull request. The deploy deletes the plugin's folder. |

## Plugins that aren't in a directory

Plugins built in-house, or published only on GitHub, have no WordPress.org listing. Choose by how widely the plugin is used.

| Plugin | Where it lives | Updates |
|---|---|---|
| Built for one site only | In the site's repository | Edited like the theme, in pull requests |
| Built in-house, used on several sites | Its own repository, installed by Composer | Release a new version, then Renovate opens a pull request on each site |
| Third-party, published on GitHub | Its GitHub repository, installed by Composer | Renovate, if the author tags releases |

### Built for one site only

Keep it in the site's repository, next to the theme. Name the folder with the client prefix, for example `wp-content/plugins/<client>-booking/`. The template's `.gitignore` already tracks `wp-content/plugins/<client>-*/` (with `<client>` replaced by the client's short name). For code that must always run and can't be deactivated, use `wp-content/mu-plugins/` with the same prefix.

The plugin is checked (PHP syntax) and deployed with everything else. It isn't in `composer.json`, and nothing else is needed.

### Built in-house, used on several sites

Give the plugin its own repository, created from `excentric-wp-plugin-template` and named `excentric-<name>`. The template includes everything below, plus a workflow that attaches an installable zip to each release. Its `composer.json` looks like this:

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

To release a version, update the version number in the plugin's main PHP file, merge, then create a release on GitHub (**Releases → Draft a new release**) with a tag such as `1.2.0`.

On each site that uses it, add the repository and require the version:

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

Because the repository is private, Composer needs a GitHub token to download it:

1. Create a fine-grained personal access token on github.com (**Settings → Developer settings → Fine-grained tokens**), with the Excentric-Agency organization as the owner, access to the plugin repositories only, and **Contents: Read-only**.
2. Add it to `COMPOSER_AUTH` and `auth.json` as:
   ```json
   "github-oauth": {
       "github.com": "<token>"
   }
   ```
3. Give the Renovate app access to the plugin's repository as well (see [Setting up Renovate](#setting-up-renovate)), so it sees new releases.

Tokens expire. Set a calendar reminder for the expiry date, and replace the token in both places before then.

### Third-party, published on GitHub

If the plugin's repository has a `composer.json`, add it as a `vcs` repository as above. Public repositories need no token. If it has no `composer.json`, install it from its release zip with a `package` repository, as in [Option 3](#option-3-a-zip-on-a-private-web-address), using the zip's address on the GitHub releases page. Renovate can't see new versions of a `package` repository, so check for releases by hand.

## Paid plugins

Choose the first option that applies.

| Option | Use when | Updates |
|---|---|---|
| 1. The vendor's Composer repository | The vendor offers one, for example ACF Pro, Yoast SEO Premium, WP Migrate or Admin Columns Pro. Check the vendor's documentation | Renovate, like any other plugin |
| 2. Commit the plugin to the repository | The plugin can only be downloaded from the vendor's portal | By hand, in a pull request |
| 3. A zip on a private web address | Several sites share the plugin and you'd rather not commit it to each | By hand: upload the zip, change the version and address |
| 4. SatisPress | The agency uses many portal-only plugins across many sites | Automatic, through SatisPress |

### Option 1: the vendor's Composer repository

Follow the vendor's Composer instructions, which give a repository address, a package name and credentials. Add the repository to `composer.json` (copy the ACF Pro entry), add the credentials to `COMPOSER_AUTH` and to `auth.json` on your computer, and add a `hostRules` entry with a secret to `renovate.json` so Renovate can see new versions.

### Option 2: commit the plugin to the repository

This is the simplest option for a plugin that can only be downloaded from the vendor's site. It replaces the old practice of uploading the zip to an FTP link.

1. Download the zip from the vendor's portal and unzip it into `wp-content/plugins/`, so you have, for example, `wp-content/plugins/wp-rocket/`.
2. In `.gitignore`, under the plugins section, add a line for it: `!/wp-content/plugins/wp-rocket/`.
3. Commit the folder in a pull request titled `Plugins: add WP Rocket 3.17.2`.
4. In the README's plugin table, note that it is updated by hand and where to download it.

To update it, delete the folder, unzip the new version in its place and open a pull request titled `Plugins: update WP Rocket to 3.18.0`. Renovate doesn't see these plugins, so subscribe to the vendor's release emails or check the portal monthly.

### Option 3: a zip on a private web address

Upload the zip to a web address that isn't public, such as a password-protected folder on the agency's server. Composer needs an `https://` address. Then describe the plugin in `composer.json`:

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

and require it with `"excentric/wp-rocket": "3.17.2"`. If the address is password-protected, add its credentials to `COMPOSER_AUTH` and `auth.json` under `http-basic`. To update, upload the new zip, then change `version`, `url` and the `require` line together.

### Option 4: SatisPress

[SatisPress](https://github.com/cedaro/satispress) is a WordPress plugin that turns a small, separate WordPress site into a private Composer repository. You install the paid plugins there with their licences, WordPress keeps them updated, and SatisPress offers each version to Composer and Renovate. It suits an agency with many portal-only plugins across many sites. Plugins whose licences don't allow updates on that site still need uploading by hand.

## Credentials

Paid plugins with a Composer repository need credentials in three places. ACF Pro is shown here. Other vendors follow the same pattern with their own host name.

| Where | What | Used by |
|---|---|---|
| `auth.json` in the site root, on your computer | The credentials file. Git ignores it | `composer install` locally |
| GitHub: **Settings → Secrets and variables → Actions → Secrets**, `COMPOSER_AUTH` | The contents of `auth.json` on one line | Checks and deploys |
| [developer.mend.io](https://developer.mend.io): the repository's **Settings → Secrets** | The licence key, named as in `renovate.json` | Renovate |

For ACF Pro, generate `auth.json` in the ACF account under **Licenses → Install using Composer**. Its format is:

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

The password is the site's live address, including `https://`. When a licence is renewed with a new key, update all three places.

## Troubleshooting

| Problem | Cause and fix |
|---|---|
| **Plugins install** fails with "401" or "403" | The credentials are missing or wrong. Check `COMPOSER_AUTH`, and that the licence is active. |
| **Plugins install** fails with "lock file is not up to date" | `composer.json` was edited without updating the lock. Run `composer update <package>` and commit `composer.lock`. |
| A plugin version isn't found | WPackagist can take a few hours to list a new WordPress.org release. Wait, or use the previous version. |
| Renovate opens no pull requests | Check the Dependency Dashboard issue for errors, and that the app has access to the repository. |
| Renovate can't see ACF Pro versions | The secret in developer.mend.io is missing or named differently from `renovate.json`. |
| A plugin disappeared after a deploy | It wasn't in `composer.json`. Add it and deploy again. Its settings in the database are kept. |
