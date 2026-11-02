# Writing documentation

This guide applies to everything written in Excentric repositories: READMEs, guides, setup steps, issues, pull request descriptions, code comments and the text that site editors see in wp-admin. It applies to people and to AI tools. If an AI tool or plugin has its own writing rules, this guide takes priority.

The rules are based on ASD-STE100 Simplified Technical English, a controlled language for technical manuals. The aim is text that a reader outside the project understands on the first read, and that reads as written by a person.

## Structure

1. Put what the reader looks for first at the top. A README starts with the facts about the project (links, status, team, stack). Then it explains how to work on it (setup, workflow, checks, the things that are unusual about the project). Reference detail comes last (deployment, structure, secrets, history).
2. Use headings that name the topic: `Deployment`, `Adding a plugin`. Do not use questions or conversational headings such as "I want to".
3. Use sentence case for headings.
4. Put reference information in tables: environments, team, tools, settings, secrets.
5. Use a numbered list for steps that must be done in order. Use a bulleted list for three or more items that are alike. Write two items as a sentence.
6. Keep one topic in each paragraph, with six sentences at most.

## Sentences

1. Write instructions in the imperative, one instruction in each sentence or step: "Run `composer install`."
2. Put the condition before the instruction: "If the checks fail, open the log."
3. Keep instructions to 20 words or fewer, and descriptions to 25 words or fewer.
4. Use the active voice, and name who does the action: "An Excentric developer deploys production", not "Production is deployed".
5. Use simple tenses. Write "the deploy finished", not "the deploy has finished".
6. Do not join a second idea with a comma and an "-ing" verb. Write "The script sets the merge options. This removes a manual step.", not "The script sets the merge options, removing a manual step."
7. Give the reader each fact before the step that needs it: the folder to work in, the account to sign in with, or the earlier step that must be complete.
8. In a warning, put the instruction first and the risk second: "Do not push a database to production. It replaces the content that clients entered."
9. Write full sentences, with a subject, a verb and the articles. Do not put a list of nouns after a colon in place of a sentence. Write "The pause button sits at the bottom right.", not "Pause / play: bottom right."

## Words

1. Do not use contractions. Write "do not", "it is" and "cannot".
2. Use Canadian spelling: colour, behaviour, centre, licence (noun), license (verb), catalogue, cancelled. Use the "-ize" endings: organization, customize. Write the names of buttons and settings exactly as the software shows them, even when they use American spelling.
3. Use "can" for a possibility, "must" for a requirement and "do not" for a prohibition. Do not use should, would, may, might or could. If a "should" is a requirement, write "must". If it is optional, say that it is optional.
4. Use one word for one meaning throughout a document. The Excentric terms are in the table below.
5. Define a technical term the first time you use it, in fewer than ten words. Do not define product names (WordPress, GitHub, Composer).
6. Do not use words that add no fact: simply, just, easily, seamlessly, robust, powerful, comprehensive, leverage, crucial, "in order to", "it is worth noting", "please note". Do not tell the reader that something is important. Give the fact, and the reader can see why it matters.
7. Name the items instead of writing "etc." Write "for example" instead of "e.g." and "that is" instead of "i.e."
8. Break a chain of more than three nouns with a preposition: "the deploy key for WP Engine", not "the WP Engine SSH deploy key secret".

| Use | Instead of |
|---|---|
| check | verify, confirm, validate, ensure, make sure |
| settings | configuration, config, options |
| repository | repo |
| pull request | PR |
| Excentric developers | maintainers, the dev team |
| contractors | freelancers, external developers |
| production, staging, local (the environments) | prod, dev, live environment |
| deploy | push live, upload |
| Excentric Agency | Excentric Creative |
| so | thus, hence |

## Punctuation and formatting

1. Do not use semicolons or em-dashes. Write two sentences, or use a word that names the relation: because, but, so, for example.
2. Use bold only for the names of buttons, menus and fields (**Squash and merge**, **Settings → Branches**), and for the labels in the first column of a fact table without a header row. Do not use bold for emphasis or as a lead-in at the start of a list item.
3. Put code, commands, file names, folder names, branch names and settings values in backticks: `composer.json`, `main`, `DEPLOY_PLUGINS`.
4. Do not use emoji or exclamation marks.
5. Use GitHub's alert blocks (`> [!IMPORTANT]`, `> [!WARNING]`) only for a warning that can cause damage or data loss. Use one or two in a document at most.
6. Write placeholders as `<description>` in angle brackets, so they are easy to find and replace: `<client>-website`.

## Code comments

A comment is for the developer who changes the code next. The other rules in this guide apply to comments too.

1. Say why the code does something, and how to change it safely. Say what the code does only when the code does not show it clearly.
2. Do not repeat the code. Delete a comment that says the same as the line under it.
3. Do not copy the design into comments. Do not write Figma node IDs or lists of sizes and colours. The values are in the code, and the design is in Figma.
4. When you change code, change its comment in the same commit. Name files, functions, settings and blocks as they are now. A wrong comment is worse than no comment.
5. Keep comments short. A section heading in a long stylesheet can be a short label, but explanations are full sentences.

Before:

> // Fields of the Page Header block: page header, numbers, home slider and page options. The block saves them to the page (post meta). title.php, slider.php, footer.php and the body class read them.

After:

> // The fields of the Page Header block: the header, the numbers, the slideshow and the page options. WordPress saves them with the page. The templates title.php, slider.php and footer.php use them.

## Text in the admin

These rules apply to the text that site editors see in wp-admin: field labels, help text, block names and descriptions, notices and settings pages.

1. Write for the site editor. Do not use file names, function names or code words.
2. Name blocks, pages, menus and settings as the editor sees them in wp-admin, not by their code names.
3. Use sentence case for labels: "Background image", not "Background Image".
4. A label names the field. Put the explanation in the help text, not in brackets in the label.
5. Help text says what the field does or what to enter, in one or two sentences. Put it below the field.
6. Show an on/off setting as a switch, with a sentence that says what "on" does.

| Before | After |
|---|---|
| Label: Decorative image (no description for screen readers) | Label: Decorative image. Help text: Switch this on if the image is only decoration. Screen readers then skip it. |
| Help text: One line per row. | Help text: Put each line of the address on its own line. |
| Help text: The sign-up box in the Display Posts block. | Help text: The sign-up box in the News & Events block. |

## What does not change

Code, commands, file paths, error messages, quotations and product names stay exactly as they are. Pull request titles keep their own format, `Area: what changed`, from [CONTRIBUTING.md](CONTRIBUTING.md#commit-messages-and-pull-request-titles).

Changelogs, QA reports and other dated records are not rewritten after they are written. New entries follow this guide.

## Example

Before:

> **Plugin updates.** Renovate will automatically open PRs for plugin updates — just review them on staging and merge; you shouldn't ever need to update plugins in wp-admin, since the next deploy will overwrite any changes made there.

After:

> ## Plugin updates
>
> Renovate opens a pull request for each plugin update.
>
> 1. Merge the pull request. This deploys the update to staging.
> 2. Check the pages that use the plugin on staging.
>
> Do not update plugins in wp-admin. The next deploy replaces the plugins folder and removes the change.

## Before you publish

1. Search for `'` (contractions), `;`, `—`, `should`, `may`, `could`, `would`, `has been`, `etc.`, `e.g.`, `thus` and `**`. Fix each one that is not in code or a button name.
2. Find the three longest sentences. If one has more than 25 words, split it.
3. Read each step. If it depends on a folder, an account or an earlier step, name it.
4. Search for American spellings: color, behavior, center, license (as a noun).
