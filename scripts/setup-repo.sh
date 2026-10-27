#!/usr/bin/env bash
# Applies Excentric's standard settings to a repository: merge options, team access,
# description and topics, and for WordPress sites the deploy variables and secrets.
# GitHub doesn't copy these from templates, so run this once for every new repository.
# Safe to run again: it only sets values, it never deletes anything.
#
# Needs the GitHub CLI (gh), signed in as an organization owner: gh auth login
#
# Usage:   setup-repo.sh <repository> <kind> [--dry-run]
#   kind:  wp-site | wp-plugin | project | template
#   --dry-run shows what would change without changing anything.
# At each question, Enter accepts the suggestion in brackets and "-" skips it.
# Example: setup-repo.sh acme-website wp-site

set -euo pipefail

ORG="Excentric-Agency"
DEPLOYERS_DEFAULT="christhechaiguy, excentrickristy"
WPE_KEY_DEFAULT="$HOME/.ssh/wpe_github_excentric"

if [ $# -lt 2 ]; then
	sed -n '2,14p' "$0" | sed 's/^# \{0,1\}//'
	exit 1
fi
REPO="$1"
KIND="$2"
DRY="${3:-}"
FULL="$ORG/$REPO"

case "$KIND" in
	wp-site)   TOPICS="wordpress,wpengine,acf"; PATTERN="Website for <client>. Custom WordPress theme, hosted on WP Engine." ;;
	wp-plugin) TOPICS="wordpress,wordpress-plugin"; PATTERN="WordPress plugin for <client or Excentric sites>: <what it does>." ;;
	project)   TOPICS=""; PATTERN="<Kind> for <client>: <what it does>. <Stack>, <host>." ;;
	template)  TOPICS="template"; PATTERN="Template for <kind of project>: <what it includes>." ;;
	*) echo "Unknown kind \"$KIND\". Use wp-site, wp-plugin, project or template."; exit 1 ;;
esac

# Runs a command, or only prints it with --dry-run.
run() {
	if [ "$DRY" = "--dry-run" ]; then
		printf '  would run:'; printf ' %q' "$@"; printf '\n'
	else
		"$@"
	fi
}
# Asks a question, with an optional default shown in brackets. Enter accepts the
# default, "-" leaves the setting as it is.
ask() {
	local answer
	read -r -p "$1${2:+ [$2]}: " answer
	answer="${answer:-${2:-}}"
	[ "$answer" = "-" ] && answer=""
	printf '%s' "$answer"
}

gh auth status >/dev/null 2>&1 || { echo "Sign in to GitHub first: gh auth login"; exit 1; }
gh repo view "$FULL" >/dev/null 2>&1 || { echo "Repository $FULL not found, or you can't access it."; exit 1; }
[ "$DRY" = "--dry-run" ] && echo "Dry run: nothing will change."
echo "Setting up $FULL ($KIND)"

echo
echo "1. Merging: squash only, titled after the pull request, branches deleted after merging,"
echo "   and an Update branch button on pull requests that fall behind main"
run gh repo edit "$FULL" --enable-squash-merge --enable-merge-commit=false --enable-rebase-merge=false --delete-branch-on-merge --allow-update-branch
run gh api --silent -X PATCH "repos/$FULL" -f squash_merge_commit_title=PR_TITLE -f squash_merge_commit_message=BLANK

echo
echo "2. Team access"
for pair in developers:admin design:pull; do
	team="${pair%%:*}"; level="${pair##*:}"
	if gh api "orgs/$ORG/teams/$team" >/dev/null 2>&1; then
		run gh api --silent -X PUT "orgs/$ORG/teams/$team/repos/$FULL" -f permission="$level"
		echo "  $team: $level"
	else
		echo "  Team \"$team\" doesn't exist yet. Create it (org-setup.md, section 3) and run this again."
	fi
done
echo "  Contractors: add them by hand as outside collaborators with Write (Settings → Collaborators)."

echo
echo "3. Description, website and topics"
echo "  Pattern: $PATTERN"
current_desc="$(gh repo view "$FULL" --json description -q .description)"
desc="$(ask "  Description" "$current_desc")"
[ -n "$desc" ] && run gh repo edit "$FULL" --description "$desc"
current_home="$(gh repo view "$FULL" --json homepageUrl -q .homepageUrl)"
home="$(ask "  Website (live URL, blank for none)" "$current_home")"
[ -n "$home" ] && run gh repo edit "$FULL" --homepage "$home"
topics="$(ask "  Topics, comma-separated" "$TOPICS")"
[ -n "$topics" ] && run gh repo edit "$FULL" --add-topic "$topics"

if [ "$KIND" = "template" ]; then
	echo
	echo "4. Marking it as a template repository"
	run gh repo edit "$FULL" --template
fi

if [ "$KIND" = "wp-site" ]; then
	echo
	echo "4. WP Engine deploy variables"
	prod="$(ask "  WP Engine production install name")"
	[ -n "$prod" ] && run gh variable set WPE_ENV_PRODUCTION --repo "$FULL" --body "$prod"
	stg="$(ask "  WP Engine staging install name" "${prod:+${prod}stg}")"
	[ -n "$stg" ] && run gh variable set WPE_ENV_STAGING --repo "$FULL" --body "$stg"
	deployers="$(ask "  GitHub usernames allowed to deploy production" "$DEPLOYERS_DEFAULT")"
	run gh variable set PRODUCTION_DEPLOYERS --repo "$FULL" --body "$deployers"
	echo "  DEPLOY_PLUGINS is left unset. Set it to true once the plugin list is complete (plugins.md)."

	echo
	echo "5. Secrets (read from files, never shown)"
	key="$(ask "  WP Engine deploy key file (blank to skip)" "$([ -f "$WPE_KEY_DEFAULT" ] && echo "$WPE_KEY_DEFAULT")")"
	if [ -n "$key" ]; then
		[ -f "$key" ] || { echo "  No file at $key"; exit 1; }
		run gh secret set WPE_SSHG_KEY_PRIVATE --repo "$FULL" < "$key"
	fi
	auth="$(ask "  auth.json for paid plugins (blank to skip)" "$([ -f auth.json ] && echo "$PWD/auth.json")")"
	if [ -n "$auth" ]; then
		[ -f "$auth" ] || { echo "  No file at $auth"; exit 1; }
		run gh secret set COMPOSER_AUTH --repo "$FULL" < "$auth"
	fi
fi

echo
echo "Done. Still to do by hand:"
echo "  - Renovate: add the repository to the app (github.com/apps/renovate → Configure)."
[ "$KIND" = "wp-site" ] && echo "  - The rest of the site's SETUP.md (files, plugins, first deploy)."
echo "  - Security settings apply automatically through the organization's configuration."
