# git-test

```
[Unit]
Description=mysvc
After=network.target network-online.target local-fs.target multi-user.target graphical.target swap.target slices.target sshd.service user.slice systemd-user-sessions.service multi-user.target final.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/bin/longstart
ExecStop=/usr/local/bin/longstop
StandardOutput=file:/var/tmp/out
StandardError=file:/var/tmp/err

[Install]
WantedBy=multi-user.target user.slice final.target
```
