# git-test

```
/usr/local/bin/user-services
#!/bin/bash
usersvc=$(find /sys/fs/cgroup/systemd/user.slice -name user@*.service -type d|awk -F/ '{print $NF}' ORS=' ')
echo $usersvc
cat - <<EOF > /etc/systemd/system/user-services.service
[Unit]
Description=keep user sessions
After=$usersvc

[Service]
Type=oneshot
ExecStart=/bin/true
ExecStop=/bin/true
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable user-services.service
systemctl start user-services.service
```

```
/etc/systemd/system/mysvc.service
[Unit]
Description=mysvc
After=network.target network-online.target local-fs.target multi-user.target graphical.target swap.target slices.target sshd.service user.slice systemd-user-sessions.service multi-user.target user-services.service
Before=shutdown.target reboot.target halt.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/bin/longstart
ExecStop=/usr/local/bin/longstop
StandardOutput=file:/var/tmp/out
StandardError=file:/var/tmp/err

[Install]
WantedBy=multi-user.target
```

```
/etc/systemd/system/aftermysvc.service 
[Unit]
After=mysvc.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/user-services
ExecStop=/usr/bin/true
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```
```
import sys
import unittest
from unittest.mock import patch
#sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
from pdict import pdict, NotFound
#from unittest.mock import MagicMock, Mock, patch

class PdictTest(unittest.TestCase):
    """tests"""

    def test_tree1(self):
        """test"""
        print()
        a = pdict({
            'a': 1,
            'b': [{'info': 'ok'}, {'info': 'ko'}],
            'c': [], 
            'd': None,
            'f': {},
        })
        self.assertEqual(a.get('e.*'), None)
        self.assertEqual(a.get('e.*', NotFound), NotFound)
        self.assertEqual(a.get('e.*', 'toto'), 'toto')
        self.assertEqual(a['e.*'], None)
        self.assertEqual(a['e'], None)
        self.assertEqual(a['b.*.info'], ['ok', 'ko'])
        self.assertEqual(a['c.*'], None)
        self.assertEqual(a['d.*'], None)
        self.assertEqual(a['f.*'], None)

        h = pdict({
            'info': [
                {
                    'ip': '192.168.0.1',
                    'mac': '00:FF:00:FF:00'
                },
                {
                    'ip': '192.168.0.2',
                    'mac': 'FF:00:FF:00:FF'
                }
            ],
            'info2': {
                'en0': { 'ip': '192'},
                'en1': { 'ip': '193'},
            }
        })
        print(h['info.*.ip'])
        self.assertEqual(h['info.*.ip'], ['192.168.0.1', '192.168.0.2'])
        print(h['info2.*.ip'])    
        self.assertEqual(h['info2.*.ip'], {'en0': '192', 'en1': '193'})
        print(h['*.*.ip'])
        self.assertEqual(h['*.*.ip'], {'info': ['192.168.0.1', '192.168.0.2'], 'info2': {'en0': '192', 'en1': '193'}})
```

```

def pwsegment(argv):
    parser = ArgumentParser()
    parser.add_argument('-f', '--fg', nargs='*', choices=_COLORS)
    parser.add_argument('-b', '--bg', nargs='*', choices=_COLORS)
    parser.add_argument('segments', nargs='+')
    args = parser.parse_args(args=argv)
    #print(args)
    args.bg = [f'LIGHT{v[1:].upper()}_EX' if v.startswith('l') else v.upper() for v in args.bg] if args.bg else None
    args.fg = [f'LIGHT{v[1:].upper()}_EX' if v.startswith('l') else v.upper() for v in args.fg] if args.fg else None
    print(Segment(args.segments, args.bg, args.fg))

def bash_prompt():
    print(r"""
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}
parse_git_clean() {
  [[ $(git status 2> /dev/null |tail -n1) =  "nothing to commit"* ]] && echo green || echo magenta
}
exit_status_color() {
    [ "$1" = 0 ] && echo green || echo red
}
PS1='$(s="$?";pwsegment "$s" "\u@\h" "\w" "$(parse_git_branch)" -b $(exit_status_color "$s") blue lblack $(parse_git_clean) -f white white white black)\n$ '
""")

_COLORS = (
    'black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white',
    'lblack', 'lred', 'lgreen', 'lyellow', 'lblue', 'lmagenta', 'lcyan', 'lwhite'
)

if __name__ == '__main__':
    import sys
    if(len(sys.argv)==1):
        bash_prompt()
        sys.exit(0)
    pwsegment(sys.argv[1:])
```

