# CrushFTP for Kubernetes

Share your files securely with FTP, Implicit FTPS, SFTP, HTTP, or HTTPS using CrushFTP using Helm and docker.

See the full documentation at https://greggbjensen.github.io/helm-crushftp/.

# Getting started with helm

Add the helm repository and install the chart.

```
helm repo add crushftp https://greggbjensen.github.io/helm-crushftp
helm repo update

helm install crushftp crushftp/crushftp
```

## Helm chart values

Override helm chart values with the settings you want.

| Parameter                    | Description                                                                                                | Default      |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------- | ------------ |
| admin.username               | Username for the initial admin account.                                                                    | crushadmin   |
| admin.password               | Password for the initial admin account.                                                                    | *generated*  |
| admin.protocol               | Protocol for health checks and probs.                                                                      | http         |
| admin.port                   | Port for health checks and probs.                                                                          | 8080         |
| tls.secretName               | Name of the secret to use for the TLS certificate.                                                         | crushftp-tls |
| volumes                      | Set of volumes from other sites or containers to mount.<br> Requires `name`, `claimName`, and `mountPath`. | [ ]          |
| configVolume.size            | Size of the CrushFTP configuration volume.                                                                 | 8Gi          |
| loadBalancerIp               | IP address of the ingress to use.                                                                          | 127.0.0.1    |
| shared.hosts.crushFtp.root   | Root domain of the sftp site.                                                                              | .local.com   |
| shared.hosts.crushFtp.prefix | Prefix or sub-domain of the sftp site.                                                                     | ftp          |
| shared.ingress.clusterIssuer | Used to enable a cluster certificate issuer such as cert-manager and lets-encrypt.                         | ''           |
| shared.storageClassName      | Sets the storage class to use for the config volume.                                                       | default      |

# Docker Image

Docker image instructions if used separately from helm chart.

## Volumes

| Volume                | Required | Function                                       | Example                                  |
| --------------------- | -------- | ---------------------------------------------- | ---------------------------------------- |
| `/var/opt/CrushFTP10` | Yes      | Persistent storage for CrushFTP config         | `/your/config/path/:/var/opt/CrushFTP10` |
| `/mnt/FTP/Shared`     | No       | Shared host folder for file sharing with users | `/your/host/path/:/mnt/FTP/Shared`       |

* You can add as many volumes as you want between host and the container and change their mount location within the container. You will configure individual folder access and permissions for each user in CrushFTPs User Manager. The "/mnt/FTP/Shared" in the table above is just one such example.

## Ports

| Port        | Proto | Required | Function          | Example               |
| ----------- | ----- | -------- | ----------------- | --------------------- |
| `21`        | TCP   | Yes      | FTP Port          | `21:21`               |
| `443`       | TCP   | Yes      | HTTPS Port        | `443:443`             |
| `2000-2100` | TCP   | Yes      | Passive FTP Ports | `2000-2100:2000-2100` |
| `2222`      | TCP   | Yes      | SFTP Port         | `2222:2222`           |
| `8080`      | TCP   | Yes      | HTTP Port         | `8080:8080`           |
| `9090`      | TCP   | Yes      | HTTP Alt Port     | `9090:9090`           |

* If you wish to run certain protocols on different ports you will need to change these to match the CrushFTP config. If you enable implicit or explicit FTPS those ports will also need to be opened.

## Environment Variables

| Variable               | Description               | Default      |
| :--------------------- | :------------------------ | :----------- |
| `CRUSH_ADMIN_USER`     | Admin user of CrushFTP    | `crushadmin` |
| `CRUSH_ADMIN_PASSWORD` | Password for admin user   | `crushadmin` |
| `CRUSH_ADMIN_PROTOCOL` | Protocol for health cecks | `http`       |
| `CRUSH_ADMIN_PORT`     | Port for health cecks     | `8080`       |

## Installation

Run this container and mount the containers `/var/opt/CrushFTP10` volume to the host to keep CrushFTP's configuration persistent. Open a browser and go to `http://<IP>:8080`. Note that the default username and password are both `crushadmin` unless the default environment variables are changed.

This command will create a new container and expose all ports. Remember to change the `<volume>` to a location on your host machine.

```
docker run -p 21:21 -p 443:443 -p 2000-2100:2000-2100 -p 2222:2222 -p 8080:8080 -p 9090:9090 -v <volume>:/var/opt/CrushFTP10 greggbjensen/crushftp:latest
```

# CrushFTP Configuration

Visit the [CrushFTP 10 Wiki](https://www.crushftp.com/crush10wiki/)


# Contributing

1. Install Docker from https://www.docker.com/get-started
2. Build and start the image by running the following command:

    ```bash
    docker-compose up --build
    ```

## Publishing docker image

1. Set the `.env` file `DOCKER_TAG` variable to the new version
2. Build the image:

    ```bash
    docker-compose build --no-cache
    ```
3. Push the image to Dockerhub

    ```bash
    docker push greggbjensen/crushftp:0.1.0-preview5
    ```

## Publishing helm chart

1. Switch to the docs directory:
    ```bash
    cd docs
    ```
2. Create a new helm package:

    ```bash
    helm package ../charts/crushftp
    ```
3. Copy the contents of `index.yaml` to `index-previous.yaml`
4. Update index.yaml:

    ```bash
    helm repo index --url https://github.com/greggbjensen/helm-crushftp/releases/download/0.1.0-preview5 --merge index-previous.yaml .
    ```
5. Create a new release on GitHub
6. Upload helm package to release

# References

- Docker image based on https://github.com/MarkusMcNugen/docker-CrushFTP
- [CrushFTP - Linux Install](https://www.crushftp.com/crush10wiki/Wiki.jsp?page=Linux%20Install)
