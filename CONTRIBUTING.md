# Contributing to Excentric repositories

These standards apply to every repository in the Excentric-Agency organization unless its README says otherwise.

## New repositories

1. **Name** the repository `<client>-<project>`, in lowercase with hyphens, client first so a client's repositories sort together, for example `<client>-website` or `<client>-careers-microsite`. Add the year to one-off campaigns: `<client>-holiday-campaign-<year>`. Internal tools and shared plugins start with `excentric-`, for example `excentric-wp-site-template`. Keep domains and WP Engine install names out of repository names. They change, and belong in the README.
2. **Create** it from a template: **New repository → Repository template**, then the template for the kind of project, set to Private.

   | Project | Template |
   |---|---|
   | WordPress site on WP Engine | `excentric-wp-site-template` |
   | WordPress plugin, for one client or shared across sites | `excentric-wp-plugin-template` |
   | Anything else (static or JavaScript site, app, tool) | `excentric-project-template` |

3. **Apply the standard settings** with `scripts/setup-repo.sh` from this repository (`setup-repo.sh <repository> <kind>`). GitHub doesn't copy settings from templates.
4. **Complete `SETUP.md`**, then delete it. It covers the `.gitignore`, repository settings, deploy secrets, team access and topics.
5. **Describe it** on its home page, following [Repository descriptions](#repository-descriptions).
6. **Fill in the README.** Replace every `<placeholder>`. It is the first thing anyone reads when they pick the site up later.

## Repository descriptions

Every repository has a one-line description (the gear icon beside **About** on its home page). It shows in repository lists and search, so keep the same pattern everywhere:

`<Kind> for <client or purpose>. <Stack>, <host>.`

| Kind of repository | Example pattern |
|---|---|
| WordPress site | `Website for <client>. Custom WordPress theme, hosted on WP Engine.` |
| Microsite or campaign | `<Campaign> microsite for <client>. <Stack>, hosted on <host>.` |
| WordPress plugin | `WordPress plugin for <client or "Excentric sites">: <what it does>.` |
| Other project | `<App, tool or site> for <client>: <what it does>. <Stack>, <host>.` |
| Template | `Template for <kind of project>: <what it includes>.` |

- Start with the kind of project, not with "This repository" or the client's name alone.
- Name the client as the client calls itself.
- Keep it under about 100 characters, so it isn't cut off in lists.
- Put the live address in the **Website** field beside the description, not in the description.

## Access

| Who | How they get access | Access | Responsibilities |
|---|---|---|---|
| Excentric developers (full-time) | `developers` team | Admin | Review and merge pull requests, deploy production, manage repository settings |
| Contractors and freelancers | Outside collaborator on each repository they work on | Write | Branches and pull requests |
| Design | `design` team | Read | Comments on issues and pull requests |

Outside collaborators are removed from a repository when their work on it ends.

## Making changes

- **Every change goes through a pull request into `main`,** including one-line fixes. The checks run on it, staging shows it before production does, and the reason for the change is recorded.
- **Branch names:** `feature/…`, `fix/…` or `update/…`.
- **Keep pull requests small:** one change each.
- **Complete the pull request template.** For small changes, the two required lines are enough.
- **Merge with Squash and merge,** the only method the repositories allow. The pull request becomes one commit on `main`, named after its title, and can be reverted in one step. Before confirming, shorten the pre-filled extended description to a sentence or two.
- **Merge only work that is ready to go live.** Merging deploys to staging, and the next production deploy includes everything on `main`. Work awaiting approval stays in an open pull request.
- **Review:** Excentric developers may merge their own small pull requests once the checks pass. Larger changes get a second reviewer.
- **Production** is deployed by an Excentric developer: **Actions → Deploy to WP Engine → Run workflow → production**.
- **Start every branch from an up-to-date `main`, and don't build a pull request on another unmerged one.** With squash merging, the first pull request lands on `main` as a new commit, so a second one built on it conflicts with `main` even where nothing really differs. If a change needs another that isn't merged yet, merge that one first, or put both in one pull request.
- **Merge pull requests soon after they're approved.** The longer a branch stays open, the more `main` moves on underneath it. If GitHub reports a conflict, select **Update branch** (or **Resolve conflicts** for a simple one), or ask an Excentric developer.
- **Code moves up** (local, staging, production) through Git. **Content moves down.** Never push a database to production.

## Commit messages and pull request titles

With squash merging, the pull request title becomes the commit on `main`, so it matters most. Commits on a branch can be informal.

Format: **`Area: what changed`**, describing the result, in about 70 characters or fewer.

| Good | Avoid |
|---|---|
| `Footer: newsletter form shows a confirmation message` | `fix` |
| `Contact form: phone field uses the number keypad on mobile` | `updates` |
| `Plugins: update ACF Pro to 6.8.7` | `changes from Monday`, `wip` |

- **Area** is the part of the site or code affected: a page, block or component (`Header`, `Footer`, `Contact form`), or `Plugins`, `Deploy`, `Docs`.
- Describe what someone would notice, not how it was done.
- Ticket numbers go in the description, not the title.
- The description covers what changed and why, how it was checked, and any manual steps after merging.

## Authorship

- Commit with your `@excentric.ca` address. To set it once for every Excentric repository, see below.
- Commits and pull requests carry no AI attribution lines (`Co-Authored-By: Claude`, "Generated with …").
- Merges and edits made on github.com use your GitHub account's commit email. If your email is private on GitHub, these show a `…@users.noreply.github.com` address, which is still linked to your account.

### Using your agency email for every Excentric repository

Keep Excentric repositories in one folder, for example `~/Projects/Excentric/`, and add this to `~/.gitconfig`:

```ini
[includeIf "gitdir:~/Projects/Excentric/"]
    path = ~/.gitconfig-excentric
```

Then create `~/.gitconfig-excentric`:

```ini
[user]
    email = you@excentric.ca
```

Repositories outside that folder keep your personal email.

## Plugins

Plugins are listed in each site's `composer.json`, installed by Composer and updated through Renovate's pull requests, never in wp-admin. See [plugins.md](plugins.md).

## Never commit

`wp-config.php`, `.env` files, passwords or keys, database dumps, or uploads. The template's `.gitignore` excludes them. Do not loosen it.

## Topics

Tag each repository from the gear icon beside **About** on its home page: `wordpress`, `wpengine`, `custom-theme` or `page-builder`, the builder (`elementor`, `divi`), `acf`, `woocommerce`, and `maintenance` for sites on a retainer.

## Changing the templates and these guides

The template repositories (`excentric-wp-site-template`, `excentric-wp-plugin-template`, `excentric-project-template`) and this `.github` repository are the master copies. Change them through pull requests, like any other repository. Don't edit local copies and upload them.

- A change to a template applies only to repositories created from it afterwards. Existing repositories don't update. If the change matters to them too (a workflow fix, for example), make the same change in each one in its own pull request.
- A change to this repository's guides, pull request template or issue forms applies to every repository straight away, except repositories that have their own copy of that file.
- Mention template changes in the pull request description, so whoever starts the next project knows what's new.

## Help

New to Git: start with [git-basics.md](git-basics.md). GitHub Desktop and the Source Control panel in VS Code cover everything above. Ask an Excentric developer before force-pushing, rewriting history or changing repository settings.
