mapfile -t files < <(find . -name "*.secrets.*")
[ "${#files[@]}" -eq 0 ] && exit

for file in "${files[@]}"; do
  sops --output-type json --decrypt "$file" > "${file:0:-4}"
  rm "$file"
done
