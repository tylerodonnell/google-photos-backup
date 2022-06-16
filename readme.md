# Google Photos Backup

Dockerized process to backup Google Photos to [Backblaze B2](https://www.backblaze.com/b2/cloud-storage.html) -- intended to be an ephemeral job every 24 hours (Kubernetes job, cron, etc)

When using volume mounts, this container is idempotent. It can be ran multiple times and only sync new photos. Photos will stay on the host's machine and be used in future runs to determine what new photos need to be uploaded to Backblaze.

The first run of this container will take several hours depending on the number of photos in your Google Photos account, and your Internet speed. Subsequent runs should only take a few seconds.

## Requirements
* [Backblaze account](https://www.backblaze.com/)
  * Backblaze B2 Bucket
  * Backblaze Application Key with write + read access to the bucket.
* [Google Cloud Platform Project](https://bullyrooks.com/index.php/2021/02/02/backing-up-google-photos-to-your-synology-nas/) (with access to download Google photos)

## Instructions

* Create a Google Cloud project and download the project's `client_secret.json` file. Save it to a location that you plan to mount to the Docker container (ex. `/data/config/client_id.json`).
* Create an empty directory on the host to store the Google photos (ex. `/data/photos`).
* Prepare the environment variables
  * `STORAGE_DIR`: Directory to download the Google photos.
  * `CLIENT_SECRET`: Full path to the `client_id.json` file.
  * `B2_BUCKET`: Name of your Backblaze B2 Bucket.
  * `B2_KEY_ID`: Backblaze Application Key ID.
  * `B2_APP_KEY`: Backblaze Application Key.
  * `HEALTH_CHECK_URL` HealthCheck URL to ping when the job completes (not required)
* Start the Docker container with the required environment variables and mount your directory.

### Example

```
docker run --rm \
  -v /data:/data \
  -e B2_BUCKET="my_bucket" \
  -e B2_KEY_ID="my_id" \
  -e B2_APP_KEY="my_secret" \
  -e STORAGE_DIR="/data/photos" \
  -e CLIENT_SECRET="/data/config/client_id.json" \
  -e HEALTH_CHECK_URL="https://hc-ping.com/your-uuid-here" \
  ghcr.io/tylerodonnell/google-photos-backup:latest
```

## Credits
* https://github.com/gilesknap/gphotos-sync
* https://github.com/rclone/rclone
