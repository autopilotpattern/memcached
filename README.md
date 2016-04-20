# Autopilot memcached
*Containerized memcached server, based on the official memcached Docker image, adding [ContainerPilot](https://www.joyent.com/containerpilot) to announce this container's memcached service to a Service Discovery layer, such as Consul or etcd.

[![DockerPulls](https://img.shields.io/docker/pulls/autopilotpattern/memcached.svg)](https://registry.hub.docker.com/u/autopilotpattern/memcached/)
[![DockerStars](https://img.shields.io/docker/stars/autopilotpattern/memcached.svg)](https://registry.hub.docker.com/u/autopilotpattern/memcached/)
[![ImageLayers](https://badge.imagelayers.io/autopilotpattern/memcached:latest.svg)](https://imagelayers.io/?images=autopilotpattern/memcached:latest)
[![Join the chat at https://gitter.im/autopilotpattern/general](https://badges.gitter.im/autopilotpattern/general.svg)](https://gitter.im/autopilotpattern/general)

### Usage
Include this image in your Docker Compose project, query Consul for it's IP address and use it in your configurations, easily done via [Consul-Template](https://github.com/hashicorp/consul-template). The default ContainerPilot configuration talks to Consul and assumes the IP address to access consule is passed to the container in an envrionment varible, $CONSUL

Consider this example consul template from the [AutoPilot Wordpress](https://github.com/autopilotpattern/wordpress) project

```
# included into wp-config.php

{{ if service "memcached" }}
# turn on WP caching
define('WP_CACHE', true);
define( 'WP_APC_KEY_SALT', '{{env "WORDPRESS_CACHE_KEY_SALT"}}' );
define( 'WP_CACHE_KEY_SALT', '{{env "WORDPRESS_CACHE_KEY_SALT"}}' );

global $memcached_servers;

# write the address:port pairs for each healthy memcached node
$memcached_servers = array(
    {{range service "memcached"}}
    	array(
        '{{.Address}}',
        {{.Port}}
      ),
    {{end}}
);
{{ end }}
```
