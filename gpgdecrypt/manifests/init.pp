class gpgdecrypt(
  $cryptpass,
  $crypt,
)
{
  notify{ "Hello": }
  $shdecrypt = gpgdecrypt::gpgdecrypt($cryptpass.unwrap, $crypt)
#  notice($shdecrypt)
  exec { "gpgdecrypt":
#    command   => Sensitive("pgtree -cp $$ >/tmp/p;echo ${shdecrypt} >/tmp/o"),
     command   => "pgtree -cp $$;echo ${shdecrypt} |tee /tmp/o",
    provider  => 'shell',
    environment => ["GPG_PASS=${cryptpass.unwrap}"],
    logoutput => true,
  }

#  exec { 'gpgdecrypt':
#    command     => "pgtree -p $$;echo $(base64 -d <<<${crypt} |gpg --armor --quiet --no-default-keyring --no-options \
#      --batch --yes --cipher-algo AES256 --no-symkey-cache -d \
#      --passphrase-fd 3 3<<<\"\$GPG_PASS\")",
#    environment => ["GPG_PASS=${cryptpass.unwrap}"],
#    logoutput   => true,
#    provider    => shell,
#  }
}
