# Contributing to Excentric repositories

These standards apply to every repository in the Excentric-Agency organization, unless the README of a repository says otherwise. Write documentation and issues as described in [writing.md](writing.md).

## New repositories

1. Name the repository `<client>-<project>`, in lowercase with hyphens. Put the client first, so that the repositories of a client sort together: `<client>-website`, `<client>-careers-microsite`. For a one-off campaign, add the year: `<client>-holiday-campaign-<year>`. Internal tools and shared plugins start with `excentric-`.
2. Do not put domains or WP Engine install names in the repository name. They can change, so they go in the README.
3. Create the repository from a template. Select **New repository → Repository template**, select the template for the kind of project, and set it to **Private**.

   | Project | Template |
   |---|---|
   | WordPress site on WP Engine | `excentric-wp-site-template` |
   | WordPress plugin, for one client or for all Excentric sites | `excentric-wp-plugin-template` |
   | Other projects: static or JavaScript sites, apps, tools | `excentric-project-template` |

4. Apply the standard settings with the setup script in this repository: `scripts/setup-repo.sh <repository> <kind>`. GitHub does not copy settings from templates.
5. Complete the steps in `SETUP.md`, then delete the file. It covers the `.gitignore`, repository settings, deploy secrets, team access and topics.
6. Add a description on the home page of the repository, as described in [Repository descriptions](#repository-descriptions).
7. Fill in the README, and replace each `<placeholder>`. The README is the first file that a person reads when they work on the project later.

## Repository descriptions

Each repository has a one-line description. To edit it, select the gear icon beside **About** on the home page of the repository. The description shows in repository lists and in search, so all repositories use the same pattern:

`<Kind> for <client or purpose>. <Stack>, <host>.`

| Kind of repository | Pattern |
|---|---|
| WordPress site | `Website for <client>. Custom WordPress theme, hosted on WP Engine.` |
| Microsite or campaign | `<Campaign> microsite for <client>. <Stack>, hosted on <host>.` |
| WordPress plugin | `WordPress plugin for <client or "Excentric sites">: <what it does>.` |
| Other project | `<App, tool or site> for <client>: <what it does>. <Stack>, <host>.` |
| Template | `Template for <kind of project>: <what it includes>.` |

Start with the kind of project, not with "This repository" or the name of the client. Write the name of the client as the client writes it. Keep the description to about 100 characters, so that lists do not cut it off. Put the address of the site in the **Website** field, not in the description.

## Access

| Who | Access through | Role | Responsibilities |
|---|---|---|---|
| Excentric developers (full-time) | The `developers` team | Admin | Review and merge pull requests, deploy production, manage repository settings |
| Contractors | Outside collaborator on each repository that they work on | Write | Branches and pull requests |
| Design | The `design` team | Read | Comments on issues and pull requests |

When the work of a contractor on a repository ends, an Excentric developer removes their access.

## Issues and tasks

GitHub Issues holds all Excentric work. The **Excentric work** project board shows the issues from all repositories. To open it, go to the **Projects** tab of the organization.

| Work | Repository for the issue |
|---|---|
| A change, bug or task on a site | The repository of the site |
| Other work: admin, operations, client requests that are not yet for a specific site | `excentric-tasks` |

1. Select the form for the issue: **Bug report**, **Change request** or **Task**. Each form sets the issue type.
2. Write one deliverable in each issue. Write the title as the result: `Contact page: map shows the new office`, not `map`.
3. Assign one person. If more than one person works on it, assign the person who does the next step.
4. If a client sends a request by email, make an issue for it. Copy the request from the email into the issue, and add a link to the thread.
5. If the issue has a client, a priority or a due date, set them on the project board.
6. In the pull request for the issue, write `Fixes #12` in the description. When the pull request merges, GitHub closes the issue. For an issue in a different repository, write `Fixes Excentric-Agency/excentric-tasks#12`.
7. Close an issue when the work is complete. For code, the `Fixes` line closes it, because only work that is ready to go live is merged. For other work, close it when you deliver the work.
8. Write questions and decisions in the comments of the issue, so that the reason stays with the work.

To get notifications for new issues in a repository, select **Watch → Custom → Issues** on the repository.

## Making changes

1. Make all changes through a pull request into `main`, including one-line fixes. The checks run on the pull request, staging shows the change before production, and the pull request records the reason for the change.
2. Start each branch from an up-to-date `main`. Name it `feature/…`, `fix/…` or `update/…`.
3. Keep each pull request to one change.
4. Complete the pull request template. For a small change, the two required lines are sufficient.
5. Merge with **Squash and merge**. This is the only merge method that the repositories allow. The pull request becomes one commit on `main`, with the title of the pull request, and you can revert it in one step. Before you merge, shorten the pre-filled description to one or two sentences.
6. Merge only work that is ready to go live. A merge deploys to staging, and the next production deploy includes all of `main`. Work that waits for approval stays in an open pull request.
7. An Excentric developer deploys production: **Actions → Deploy to WP Engine → Run workflow → production**.

Excentric developers can merge their own small pull requests when the checks pass. A second person reviews larger changes.

Do not start a pull request from a branch that is not merged yet. With squash merging, the first pull request goes onto `main` as a new commit. The second pull request then conflicts with `main`, even where the content is the same. If a change needs a change that is not merged yet, merge that one first, or put both changes in one pull request.

Merge a pull request soon after its approval. While a branch stays open, `main` continues to change. If GitHub shows a conflict, select **Update branch**, or **Resolve conflicts** for a small conflict. If you are not sure, ask an Excentric developer.

Code moves up through Git, from local to staging to production. Content moves down. Do not push a database to production. It replaces the content that the client entered.

## Commit messages and pull request titles

With squash merging, the title of the pull request becomes the commit message on `main`. Commits on a branch can be informal.

The format is `Area: what changed`. It describes the result, in about 70 characters or fewer.

| Good | Not useful |
|---|---|
| `Footer: newsletter form shows a confirmation message` | `fix` |
| `Contact form: phone field uses the number keypad on mobile` | `updates` |
| `Plugins: update ACF Pro to 6.8.7` | `changes from Monday`, `wip` |

The area is the part of the site or code that changed: a page, a block or a component (`Header`, `Footer`, `Contact form`), or `Plugins`, `Deploy` or `Docs`. Describe what a person can see, not how you did it. Put issue numbers in the description, not in the title. In the description, write what changed and why, how you checked it, and any manual steps after the merge.

## Authorship

Commit with your `@excentric.ca` address. To set it one time for all Excentric repositories, follow the steps below. Commits and pull requests do not include AI attribution lines, such as `Co-Authored-By: Claude` or "Generated with".

Merges and edits on github.com use the commit email of your GitHub account. If your email is private on GitHub, these commits show a `…@users.noreply.github.com` address. GitHub still links that address to your account.

### Your agency email for all Excentric repositories

1. Keep all Excentric repositories in one folder, for example `~/Projects/Excentric/`.
2. Add these lines to `~/.gitconfig`:

   ```ini
   [includeIf "gitdir:~/Projects/Excentric/"]
       path = ~/.gitconfig-excentric
   ```

3. Make the file `~/.gitconfig-excentric` with these lines:

   ```ini
   [user]
       email = you@excentric.ca
   ```

Repositories outside that folder continue to use your personal email.

## Plugins

The `composer.json` file of each site lists its plugins. Composer installs them, and Renovate opens a pull request for each update. Do not install or update plugins in wp-admin. For the full steps, see [plugins.md](plugins.md).

## Files that are never committed

Do not commit `wp-config.php`, `.env` files, passwords, keys, database dumps or uploads. The `.gitignore` of each template excludes them. Do not remove lines from it.

## Topics

Add topics to each repository with the gear icon beside **About** on its home page: `wordpress`, `wpengine`, `custom-theme` or `page-builder`, the page builder (`elementor`, `divi`), `acf`, `woocommerce`, and `maintenance` for sites on a retainer.

## Changing the templates and these guides

The template repositories (`excentric-wp-site-template`, `excentric-wp-plugin-template`, `excentric-project-template`) and this `.github` repository are the master copies. Change them through pull requests, as for all repositories. Do not edit a local copy and upload it.

A change to a template applies only to repositories that are made from it after the change. Existing repositories do not change. If the change is also necessary for them, for example a fix to a workflow, make the same change in each repository with its own pull request.

A change to the guides, pull request template or issue forms in this repository applies to all repositories immediately. Repositories that have their own copy of a file keep their copy.

Write template changes in the pull request description, so that the person who starts the next project knows what changed.

## Help

If you are new to Git, start with [git-basics.md](git-basics.md). GitHub Desktop and the Source Control panel in VS Code can do all of the steps in this guide. Before you force-push, rewrite history or change repository settings, ask an Excentric developer.
