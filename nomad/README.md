# README

## Nomad Variables (via CLI)

- write
```console
nomad var put nomad/jobs/redis-server/redis/server password="s3cr3t!"
```

- read
```console
nomad var get nomad/jobs/redis-server/redis/server

or 

nomad var get -item=password nomad/jobs/redis-server/redis/server
```

- update
```console
nomad var put -force nomad/jobs/redis-server/redis/server password="n0t@s3cr3t"
```


## Note
In order to run `spring-boot.nomad` example, Java JRE will need to be installed.
