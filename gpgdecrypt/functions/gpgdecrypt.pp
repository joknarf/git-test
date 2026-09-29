function gpgdecrypt::gpgdecrypt(
  $password,
  $crypted,
)
{
#  return "$(gpg --armor --quiet --no-default-keyring --no-options --batch \
#      --yes --cipher-algo AES256 --no-symkey-cache -d \
#      --passphrase-fd 3 3<<<'${password}' <(base64 -d <<<'${crypted}'))"
#  return @("SCRIPT")
#    `bash -c 'gpg --armor --quiet --no-default-keyring --no-options \
#      --batch --yes --cipher-algo AES256 --no-symkey-cache -d \
#      --passphrase-fd 3 3<<<'"'"'${password}'"'"' <(base64 -d <<<${crypted})'`
#    |SCRIPT

  $gpgcmd = base64('encode', "gpg --armor --quiet --no-default-keyring --no-options \
      --batch --yes --cipher-algo AES256 --no-symkey-cache -d \
      --passphrase-fd 3 3<<<\"\$GPG_PASS\" <(base64 -d <<<${crypted})").split('\n').join('')
  return "$(echo ${gpgcmd} |base64 -d |bash)"

}
