Run in docker
```bash
$ git clone http://github.com/mindwm/mindwm-event-bar
$ cd mindwm-event-bar
$ make run NATS_SERVER=nats://root:r00tpass@ubuntu-dev:4222" SUBJECT="user-${USER}.$(hostname -s)-host-broker-kne-trigger._knative"
```
Run on host

```bash
$ git clone http://github.com/mindwm/mindwm-event-bar
$ cd mindwm-event-bar
# install eww lxterminal neovim jq 
$ python3 -m venv .venv
$ . .venv/bin/activate
$ pip3 install -r ./requirements.txt
$ eww --config=`pwd` daemon
$ eww --config=`pwd` open mindwm-bar
$ cp .env.sample .env
# edit .env
$ . ./.env
$ python3 ./mindwm-bar.py
```

[Screencast from 2024-10-11 17-18-02.webm](https://github.com/user-attachments/assets/13dce125-f480-4250-a7c3-2202ca710d6c)

[Screencast from 2024-10-11 18-51-52.webm](https://github.com/user-attachments/assets/22d701f6-d497-47df-bb79-583a87b6e264)
