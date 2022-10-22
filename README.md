# Images

## Dockerfile.net-tools

```bash
$ docker build -t net-tools -f Dockerfile.net-tools .
$ docker run -it --name net-tools --network host net-tools dig google.com a
```

## Dockerfile.virus-scan

```bash
$ docker build -t clamscan -f Dockerfile.virus-scan .
$ docker run -it --name clamscan -v $PWD:/data:ro clamscan
```

## Dockerfile.dns

```bash
$ docker build -t dns -f Dockerfile.dns .
$ docker run \
  -it \
  -d \
  --name dns \
  -p 127.0.0.1:53:53/udp \
  -p 127.0.0.1:53:53/tcp \
  --restart unless-stopped \
  dns
# or on a higher port (e.g. when another dns sits on port 53)
$ docker run \
  -it \
  -d \
  --name dns \
  -p 127.0.0.1:5300:53/udp \
  -p 127.0.0.1:5300:53/tcp \
  --restart unless-stopped \
  dns
# with custom forward zones:
$ docker run \
  -it \
  -d \
  --name dns \
  -p 127.0.0.1:5300:53/udp \
  -p 127.0.0.1:5300:53/tcp \
  -v /etc/unbound/unbound.conf.d:/etc/unbound/unbound.conf.d:ro \
  --restart unless-stopped \
  dns
```
