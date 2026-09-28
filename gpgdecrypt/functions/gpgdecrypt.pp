function gpgdecrypt::gpgdecrypt(
  $password,
  $crypted,
)
{
  return @("SCRIPT")
  gpg --armor --quiet --no-default-keyring --no-options --batch \
      --yes --cipher-algo AES256 --no-symkey-cache -d \
      --passphrase-fd 3 3<<<'${password}' <(base64 -d <<<'${crypted}')
  |SCRIPT
}
