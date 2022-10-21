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
