
# Mosquitto MQTT broker Docker image

This image places teh Mosquitto MQTT broker (https://mosquitto.org/) in a Docker container and pre-configures it for use in my Home Assistant setup. It may be useful to others, and may need changes to suit your needs.

It is however quite generic and could be used for any purpose.

It provides 3 external ports for incoming connections but otherwise its configuration is currently quite simple.

This container does not currently implement ACLs (Access Control Lists) or any other advanced functionality. Feel free to make pull requests and/or raise issues for changes.

It is configured with three listening ports, one with TLS for external use, two without; one for LAN and one for LOCAL. The LOCAL port is configured in the docker-compose to listen only on 1270.0.1.

## Ports

### WAN
Port `2883` is configured for WAN access, this port must be supplied with a CA certificate and a server certificate and key.

The WAN port will listen using TLS given the certificates you provide and can be forwarded through your external router in order to access it from outside your network.

This port is useful for reporting location back from Owntracks on your mobile device to be used in Home Assistant to determine if/when you are home.

> NOTE: It is important that you add users to your mosquitto credentials file using the instructions below AND __restart the server__. If you do not perform both of these actions, it can be accessed anonymously.

### LAN
Port `1883` is configured to LAN access, this port does not use TLS.

The LAN port will listen on all interfaces of the host machine according to the compose file, feel free to change this if you wish to bind a specific address.i

This port is useful for connecting from Home Assistant if it's running on another machine on your network.

### LOCAL
Port `3883` is configured for LOCAL access, this port does not use TLS.

The LOCAL port will listen on 127.0.0.1 of the host machine according to the compose file. It is to be used when connecting from other services on the same machine.

If your other services are running in Docker, however, I would recommend disabling this port and connecting directly on a Docker bridge/private network.

This port is useful for connecting from Home Assistant if it's on this machine but not in Docker, or for other software on this machine. For services inside Docker, follow the suggestion above and disable this port for security.

## Access Control
The container is configured to disallow anonymous access on all ports, but, this will be the case only after you add users. It seems that while the password file is empty, anyone can connect. It may choose to add a randomly generated user to it in the future to prevent people accidently leaving it open. In this case, you will not be able to connect until you add a user yourself.

## Adding users
Once the container is configured correctly with certificates and it starts successfully, you can add users. Run the following command to add a user interactively.

```
docker-compose exec mqtt adduser <username> 
```
you will be prompted for a password, and then to repeat it.

## Deleting users

```
docker-compose exec mqtt deluser <username>
```
