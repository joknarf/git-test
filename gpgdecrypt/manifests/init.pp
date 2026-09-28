class gpgdecrypt(
  $cryptpass,
  $crypt,
)
{
  notify{ "Hello": }
  $shdecrypt = gpgdecrypt::gpgdecrypt($cryptpass.unwrap, $crypt)
  notice($shdecrypt)
  exec { "gpgdecrypt":
    command   => Sensitive("echo $(${shdecrypt})"),
    provider  => 'shell',
    logoutput => true,
  }
}
