# Git basics for the Excentric team

This guide covers the usual tasks with GitHub Desktop and github.com. You do not need the command line. Nothing in this workflow changes the live site directly. If something looks unusual, ask Kristy or Chris.

## Git compared with SFTP

| SFTP | Git |
|---|---|
| An uploaded file is live immediately | You propose a change. It goes to staging for a check, then an Excentric developer deploys it |
| If two people edit one file, the second upload replaces the first | Each person works on a separate branch, and Git combines the changes |
| There is no record of who changed what, or why | Git records each change with its author and its reason |
| To undo a change, you must find an old copy of the file | You can revert each merged change in one step |
| An error in a file can stop the site | Automatic checks find PHP errors before the deploy |

## Terms

| Term | Meaning |
|---|---|
| Repository | The files of the project and their full history. Each website has one. |
| `main` | The approved version of the code. It deploys to staging, then to production. |
| Branch | A separate copy of the code for one piece of work. Its name describes the work: `fix/footer-spacing`, `feature/team-page`. |
| Commit | A saved step on a branch, with a short message that describes it. |
| Pull request | A request to merge a branch into `main`. It shows the changes, runs the checks and holds the discussion. |
| Merge | The step that adds the changes of a pull request to `main`. Excentric always uses **Squash and merge**. |
| Staging | A private copy of the website. You check changes there before they go live. |

## One-time setup

The setup takes about 20 minutes. Kristy or Chris can do it with you.

1. Sign up at github.com, or use your existing account.
2. On github.com, go to **Settings → Password and authentication** and turn on two-factor authentication.
3. Send your username to Kristy or Chris. They give you access.
4. On github.com, go to **Settings → Emails** and add your `@excentric.ca` address.
5. Install [GitHub Desktop](https://desktop.github.com) and sign in. Under **Settings → Git**, set your name and your `@excentric.ca` address.
6. Install [Visual Studio Code](https://code.visualstudio.com), or use a different editor.
7. Kristy or Chris sets up the local site with you the first time, because each site has a different setup. After that, the site shows in the repository list of GitHub Desktop.

## Making a small change on github.com

Use this method for a one-line CSS change or a typo.

1. On github.com, open the file in the repository, for example `wp-content/themes/…/blocks/faq/style.css`.
2. Select the pencil icon (**Edit**) and make the change.
3. Select **Commit changes…**. Enter a title, for example `FAQ: more space between questions`.
4. Select **Create a new branch for this commit and start a pull request**, then select **Propose changes**.
5. Complete **What changed** and **Pages to check**, then select **Create pull request**.
6. Wait for the checks to pass. This takes about one minute. An Excentric developer merges the pull request, and the change goes to staging a short time later.

## Making a change on your computer

Use this method with GitHub Desktop for larger changes.

1. Check that **Current branch** shows `main`. Select **Fetch origin**. If GitHub Desktop shows **Pull origin**, select it.
2. Select **Current branch → New branch**. Name the branch `fix/…` or `feature/…`.
3. Edit the files and check the result on your local site. GitHub Desktop lists each changed file.
4. Enter a summary in the format `Area: what changed`, for example `Header: logo is sharp on phones`. Select **Commit to fix/…**. You can commit as many times as you want.
5. The first time, select **Publish branch**. After that, select **Push origin**.
6. Select **Create Pull Request**. On github.com, complete **What changed** and **Pages to check**, then select **Create pull request**.
7. After the merge, change back to `main` and select **Pull origin**. GitHub deletes the branch on github.com automatically. To delete your local copy, select **Branch → Delete**.

## After you open a pull request

1. The checks run (PHP syntax and CSS). A green check mark shows that they passed.
2. An Excentric developer reviews the pull request if necessary, then selects **Squash and merge**.
3. The merge deploys to staging. Check the changed pages there.
4. When the change is ready to go live, an Excentric developer deploys production.

## Pull request titles

The title becomes the permanent record of the change. Use the format `Area: what changed`, in about 70 characters. Describe what a person can see:

- `Contact form: phone field uses the number keypad on mobile`
- `Plugins: update ACF Pro to 6.8.7`
- `Footer: newsletter form shows a confirmation message`

Do not use titles such as `fix`, `updates` or `wip`. The description needs only its two required lines. For larger changes, add more.

## Common problems

| Condition | Action |
|---|---|
| You started to edit while you were on `main` | Before you commit, select **Current branch → New branch**. GitHub Desktop offers to move your changes to the new branch. |
| The pull request shows "This branch has conflicts" | Another person changed the same lines. If the change is small, select **Resolve conflicts**. If not, ask an Excentric developer. |
| A check failed (red cross) | Select **Details** to see which check failed. Fix the file and commit to the same branch. The checks run again. |
| You want to remove your local edits | In GitHub Desktop, right-click the file and select **Discard changes**. |
| A merged change is incorrect | Open the merged pull request on github.com and select **Revert**. GitHub makes a pull request that removes the change. |
| A different problem | Stop and ask an Excentric developer. Git does not lose committed work. |

## Files that are never committed

Do not commit `wp-config.php`, `.env` files, passwords, keys, database exports or uploads. The repository ignores these files, so they do not show in GitHub Desktop. If one of them shows, ask an Excentric developer before you commit.
