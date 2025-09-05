#!/bin/zsh

set -e
set -u

# this script pushes special convert_to_xcstrings branch to GitHub
# for each submodule currently in that branch and opens a PR

source Scripts/define_common.sh

# use convert_to_xcstrings as the translation_branch
translation_branch="convert_to_xcstrings"

section_divider
echo "    **** Start of script *** "

for project in ${projects}; do
    section_divider
    IFS=":" read user dir branch <<< "$project"

    cd $dir
    current_branch=$(git branch --show-current 2>/dev/null)
    echo "In $dir, current_branch = $current_branch"

    # for now, detect and skip: DanaKit
    if [[ "${dir}" == "DanaKit" ]]; then
        echo "    Skipping DanaKit"
        cd -
        continue
    fi

    if [[ "${current_branch}" == "${translation_branch}" ]]; then
        echo "    Preparing the PR for ${current_branch}"
        git push --set-upstream origin ${translation_branch}
        pr=$(gh pr create -B $branch -R $user/$dir --title "Convert to String Catalogs" --body "Use the automatic conversion in Xcode" 2>&1 | grep http)
        echo "    PR = $pr"
        open $pr
        # After PR is created, return to standard branch for this dir
        echo "    returning $dir to $branch"
        git switch $branch
    else
        echo "    Not in branch: ${translation_branch}"
        echo "    Do not prepare the PR for this submodule"
    fi
    cd -
done

section_divider
