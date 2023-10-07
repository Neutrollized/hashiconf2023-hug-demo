# README

```console
vault write auth/token/roles/nomad-cluster @nomad-cluster-role.json

vault policy write nomad-server nomad-server-policy.hcl
```


Create token with: `vault token create -policy nomad-server -period 240h -orphan` (this will last 10 days)
