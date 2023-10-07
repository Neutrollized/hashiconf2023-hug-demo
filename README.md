# hashiconf-hug-demo

This repo contains some links to various content that was presented at [HashiConf HUG @ HQ](https://www.meetup.com/san-francisco-hashicorp-user-group/events/295805336). 

- [Consul for Multicloud Nomad](https://github.com/jacobmammoliti/consul-multicloud-demo/tree/main/nomad) code


## Resources
#### Packer images
- [GCP Packer images](https://github.com/Neutrollized/packer-gcp-with-githubactions)
- [AWS Packer images](https://github.com/Neutrollized/packer-vm-templates/tree/main/aws)

#### Terraform deployment
- [Nomad on GCP GCE](https://github.com/Neutrollized/nomad-on-gcp-gce)
- [Nomad on AWS EC2](https://github.com/Neutrollized/nomad-on-aws-ec2)
- [Vault on GCP Cloud Run](https://github.com/Neutrollized/hashicorp-vault-with-cloud-run)


### Additional setup steps for WAN Federation
You will want to use the same Gossip key across your Consul clusters (but not a requirement for Nomad).  

You can perform WAN federation in one of two ways:
1. To perform WAN federation across clouds, you will need a VPN connection setup between them (HOW-TO: [Create HA VPN between GCP and AWS](https://cloud.google.com/network-connectivity/docs/vpn/tutorials/create-ha-vpn-connections-google-cloud-aws)).  You will need a VPN if you wish to perform WAN federation in Nomad as well.

2. If you're just looking to federate your Consul clusters, you can use [Mesh Gateways](https://developer.hashicorp.com/consul/tutorials/developer-mesh/service-mesh-gateways) instead of creating a VPN.  Mesh gateway WAN federation is not supported on Nomad though!

An optional (easier) approach is to provision *both* Nomad clusters in separate regions within a Google Cloud VPC.  Subnets within the same Google VPC can communicate internally regardless of region (this is not the case with AWS and Azure).  


## CA & SSL certs (highly recommended)
This is an optional step if you wan to try out [Consul Connect](https://developer.hashicorp.com/consul/docs/connect)'s features.  Consul Connect is a service mesh and hence you will need certs for the mTLS piece. I personally hate having to deal with (generating) certs, but luckily the ability create certs easily built into the [Consul](https://developer.hashicorp.com/consul/commands/tls) and [Nomad](https://developer.hashicorp.com/nomad/docs/commands/tls) binaries.  This is the approach I will be taking, but if you wish to generate certs the hard way, here's a link to my co-presenter, [Jacob Mammoliti's Nomad the Hard Way](https://github.com/jacobmammoliti/nomad-the-hard-way/blob/main/docs/04-certificate-authority.md) repo.

### Consul
#### CA certs
```console
consul tls ca create
```

#### Server certs
```console
consul tls cert create -server -dc [DATACENTER] -additional-ipaddress=[LOAD_BALANCER_IP] -additional-dnsname="*.[OTHER_DATACENTER].consul"
```

You will need to then distribute the certs (i.e. `scp`). On the server you will need to provide the CA cert and the server certs.  On the client side, you need only the CA cert as we will be leveraging Consul's [Auto-Encryption](https://developer.hashicorp.com/consul/tutorials/security/tls-encryption-secure#client-certificate-distribution) feature.
