if [[ "push" != "$1" ]] ; then
  git "$@"
  exit "$?"
fi


commit_files=("$(git diff --name-only --cached)")


echo "Starting secrets check..."
encrypt_check_on_name() {
  for file in $(find . -type f -name "$1"); do
    [[ ! "${commit_files[@]}" =~ "$file.gpg" ]] && continue 
    echo "Encrypting $file before push..."
    gpg --encrypt --recipient xsj3n@tutanota.com --yes --trust-model always --output "$file.gpg" "$file"
    rm "$file"

    echo "Staging newly encrypted $file.gpg"
    git reset HEAD "$file" &>/dev/null
    git add "$file.gpg"
  done
}


script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mapfile -t lines < "$script_dir/../.gitsecret"
for line in "${lines[@]}"; do
  encrypt_check_on_name $line
done
git commit --amend --no-edit
git push
ls | grep "*.gpg" && "$script_dir/decrypt.sh"
