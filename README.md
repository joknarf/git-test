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
