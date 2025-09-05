#!/bin/zsh

source Scripts/define_common.sh
translation_branch=convert_to_xcstrings

for project in ${projects}; do
  echo "Updating $project"
  IFS=":" read user dir branch <<< "$project"
  cd $dir
  if [ -n "$(git branch --list "$translation_branch")" ]; then
        echo "Local branch '$translation_branch' exists."
        git switch ${translation_branch}
  fi
  cd -
done

