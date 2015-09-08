# Docker DNS Local

## `run.sh`

`./run.sh container-name someSecretPassword`

For a clean run first do: `rm -rf bind-data/*`

### Docker host IP

Find it with: `docker-machine ip $(docker-machine active)`

Place it in the `DNS Servers` configuration of the machine being used for development work, e.g. a mac laptop which is running local Docker hosts via `docker-machine`.

## webmin

`open http://192..:10000`

Login: root
-> Servers
-> BIND DNS Server

### Forwarding and Transfers

Servers to forward queries to

`8.8.8.8`, `8.8.4.4`

#### Edit Config File

##### /etc/bind/named.conf

*--no changes--*

##### /etc/bind/named.conf.options

```
options {

    ...

    allow-query { any; };
    allow-query-cache { any; };
    allow-recursion { any; };
};
```

##### /etc/bind/named.conf.local

*--no changes--*

##### /etc/bind/named.conf.default-zones

*--no changes--*

### Create master zone

**Zone type:** *Reverse*

Domain name / Network: `IP address of docker host (e.g. 192..)`

Master server: `ns.sub.example.com`

Email address: `some@email`

-> Create

**Zone type:** *Forward*

Domain name / Network: `sub.example.com`

Master server: `ns.sub.example.com`

Email address: `some@email`

-> Create

### Zone page for `sub.example.com`

#### Address

**Name:** `ns`

Time-To-Live: *--default or custom--*

Address: `IP address of docker host (e.g. 192..)`

**Name:** `somehost`

Time-To-Live: *--default or custom--*

Address: `IP address of docker host (e.g. 192..)`

#### Check Records

*--run check for any problems--*

### Module Index (a.k.a. Module Config)

#### Check BIND Config

*--run check for any problems--*

#### Apply Configuration

*--output from config change should appear in the docker logs terminal--*

### Verify

Now, from the development machine (e.g. a mac running the vbox docker host), try running:

```
host somehost.sub.example.com 192..
host google.com 192..

dig @192.. somehost.sub.example.com
dig @192.. google.com

ping somehost.sub.example.com
```

Now restart the container, to make sure the changes properly persist:

```
docker stop container-name
docker start container-name
docker logs -f container-name
```

The `host` and `dig` command given above should work as before.
