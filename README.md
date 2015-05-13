# GINA-SMOG
## What is it?
CLI wrapper around http://fog.io to interact with our libvirt hosts.


## External dependencies

### libvirt

For OSX run:

    brew install libvirt

## How to use it

### Clone the repo

```
git clone https://github.com/gina-alaska/gina-smog
cd gina-smog
bundle install
```

### Create a .smog.yml file

```
cp .smog.yml.example .smog.yml
$EDITOR .smog.yml
**add your libvirt hosts to the file**
```

### Get info on a domain

```
bin/smog domain info -h HOST GUEST
```

### Create a domain

```
bin/smog domain create --host HOST --cpu=2 --memory=2048 -b=public_bridge --unique -t template-image  GUEST_NAME
```

## Bugs
There are lots of them. Some listed commands aren't implemented yet.

## TODO
* [ ] Implement status/info commands
* [ ] Add domain migration
* [ ] Add chef bootstrapping of nodes
