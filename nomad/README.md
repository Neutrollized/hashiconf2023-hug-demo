# README

## Nomad Variables

- cli
```console
nomad var put nomad/jobs/redis-server-v1/redis/server password="s3cr3t!"
```

```console
nomad var get nomad/jobs/redis-server-v1/redis/server

or 

nomad var get -item=password nomad/jobs/redis-server-v1/redis/server
```
