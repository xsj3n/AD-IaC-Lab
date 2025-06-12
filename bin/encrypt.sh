check_for_gpg() {
  if [[ ${1: -3} == "gpg" ]]; then
    return 0
  else
    return 1
  fi
}

for file in *.tfstate*; do
  check_for_gpg "$file" && continue 
  gpg --encrypt --recipient xsj3n@tutanota.com --yes --trust-model always --output "$file.gpg" "$file"
  rm "$file"
done

for file in *.xml; do
  check_for_gpg "$file" && continue 
  gpg --encrypt --recipient xsj3n@tutanota.com --yes --trust-model always --output "$file.gpg" "$file"
  rm "$file"
done

for file in secrets*; do
  check_for_gpg "$file" && continue 
  gpg --encrypt --recipient xsj3n@tutanota.com --yes --trust-model always --output "$file.gpg" "$file"
  rm "$file" 
done
