# Git basics for the Excentric team

This guide covers the everyday tasks using GitHub Desktop and github.com. No command line is needed. If anything looks unexpected, ask Kristy or Chris. Nothing in this workflow publishes to the live site directly.

## Git compared with SFTP

| SFTP | Git |
|---|---|
| An uploaded file is live immediately | A change is proposed, checked on staging, then deployed by an Excentric developer |
| Two people editing one file overwrite each other | Each person works on a separate branch, and Git combines the changes |
| No record of who changed what, or why | Every change is recorded with its author and reason |
| Undoing means finding an old copy of the file | Any merged change can be reverted in one step |
| A typo can take the site down | Automatic checks catch PHP errors before deployment |

## Terms

| Term | Meaning |
|---|---|
| Repository | The project's files and their full history. One per website. |
| `main` | The approved version of the code. It deploys to staging, then to production. |
| Branch | A separate copy of the code for one piece of work, named after it: `fix/footer-spacing`, `feature/team-page`. |
| Commit | A saved step on a branch, with a short message describing it. |
| Pull request | A request to merge a branch into `main`. It shows the changes, runs the checks and holds the discussion. |
| Merge | Adding a pull request's changes to `main`. We always use **Squash and merge**. |
| Staging | A private copy of the website for checking changes before they go live. |

## One-time setup

Allow about 20 minutes. Kristy or Chris can walk you through it.

1. **GitHub account.** Sign up at github.com or use an existing account. Turn on two-factor authentication (**Settings → Password and authentication**), then send your username to Kristy or Chris to be given access.
2. **Work email.** In github.com, go to **Settings → Emails** and add your `@excentric.ca` address.
3. **GitHub Desktop.** Install [GitHub Desktop](https://desktop.github.com) and sign in. Under **Settings → Git**, set your name and your `@excentric.ca` email.
4. **Editor.** Install [Visual Studio Code](https://code.visualstudio.com), or use your preferred editor.
5. **The project.** Kristy or Chris sets up the local site with you the first time, as this depends on the site's setup. Afterwards it appears in GitHub Desktop's repository list.

## Making a small change on github.com

For a one-line CSS change or a typo.

1. Open the file in the repository on github.com, for example `wp-content/themes/…/blocks/faq/style.css`.
2. Select the pencil icon (**Edit**) and make the change.
3. Select **Commit changes…**. Enter a title such as `FAQ: more space between questions`, choose **Create a new branch for this commit and start a pull request**, and confirm.
4. Complete **What changed** and **Pages to check**, then select **Create pull request**.
5. Wait for the checks to pass (about a minute). An Excentric developer merges it, and it reaches staging shortly after.

## Making a change on your computer

For anything larger, using GitHub Desktop.

1. **Update.** Check that **Current branch** shows `main`, then select **Fetch origin**, and **Pull origin** if offered.
2. **Branch.** Select **Current branch → New branch** and name it `fix/…` or `feature/…`.
3. **Work.** Edit the files and check the result on your local site. GitHub Desktop lists each changed file.
4. **Commit.** Enter a summary in the form `Area: what changed`, for example `Header: logo no longer blurry on phones`, and select **Commit to fix/…**. Commit as often as you like.
5. **Publish.** Select **Publish branch** the first time, and **Push origin** after that.
6. **Open a pull request.** Select **Create Pull Request**. On github.com, complete **What changed** and **Pages to check**, then select **Create pull request**.
7. **After the merge.** Switch back to `main` and select **Pull origin**. GitHub deletes the branch on github.com automatically. Delete your local copy with **Branch → Delete**.

## After you open a pull request

1. The checks run (PHP syntax and CSS). A green check mark means they passed.
2. An Excentric developer reviews it if needed, then merges it with **Squash and merge**.
3. Merging deploys to staging. Check the affected pages there.
4. When it is ready to go live, an Excentric developer deploys production.

## Pull request titles

The title becomes the permanent record of the change. Use the form `Area: what changed`, in about 70 characters, describing what someone would notice:

- `Contact form: phone field uses the number keypad on mobile`
- `Plugins: update ACF Pro to 6.8.7`

Avoid titles such as `fix`, `updates` or `wip`. The description needs only its two required lines. Add more for larger changes.

## Common problems

| Situation | What to do |
|---|---|
| You started editing while on `main` | Before committing, select **Current branch → New branch**. GitHub Desktop offers to bring your changes to the new branch. |
| The pull request says "This branch has conflicts" | Someone else changed the same lines. Select **Resolve conflicts** if the change is simple, or ask an Excentric developer. |
| A check failed (red cross) | Select **Details** to see which check failed. Fix the file, commit to the same branch, and the checks run again. |
| You want to discard your local edits | In GitHub Desktop, right-click the file and select **Discard changes**. |
| A merged change is wrong | Open the merged pull request on github.com and select **Revert**. This creates a pull request that undoes it. |
| Anything else | Stop and ask an Excentric developer. Committed work is never lost. |

## Never commit

`wp-config.php`, `.env` files, passwords or keys, database exports, or uploads. The repository ignores these, so they should not appear in GitHub Desktop. If one does, ask an Excentric developer before committing.
