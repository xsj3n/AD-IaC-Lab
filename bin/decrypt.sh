ls | grep '\.gpg$' &>/dev/null || exit  
for file in *.gpg; do
  gpg --decrypt "$file" > "${file:0:-4}"
  rm "$file"
done
