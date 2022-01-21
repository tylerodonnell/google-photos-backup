# Google Photos Backup

Backup all of your Google Photos to [Backblaze B2](https://www.backblaze.com/b2/cloud-storage.html) -- intended to be used as a scheduled cron job every 24 hours.

Photos will be stored on the host machine in addition to Backblaze. The host machine's directory is used to know what new photos need to be downloaded from Google, and what new photos need to be uploaded to Backblaze. During the first run, it'll download and upload all photos, which will take several hours. Subsequent runs will only sync new photos and should only take a few seconds.

## Requirements
* Backblaze account
  * Backblaze B2 Bucket
  * Backblaze Application Key
* [Google Cloud Platform Project](https://bullyrooks.com/index.php/2021/02/02/backing-up-google-photos-to-your-synology-nas/) (with access to download Google photos)

## Instructions

* Follow the instructions to create a Google Cloud project. Save the project's `client_secret.json` file to a safe location. You'll need to mount it to the Docker container later.
* Create an empty directory on the host to store the Google photos.
* Supply the needed environment variables
  * `STORAGE_DIR`: Host directory where the Google photos are downloaded
  * `CLIENT_SECRET`: Google Cloud Project's json file
  * `B2_BUCKET`: Name of the S3 Bucket
  * `B2_KEY_ID`: Backblaze Application Key ID
  * `B2_APP_KEY`: Backblaze Application Key
* Start the Docker container with the required params

### Example

```
# Fill these in
STORAGE_DIR="/YOUR_LOCAL/PATH/TO_PHOTOS"
CLIENT_SECRET="/YOUR_LOCAL/PATH/TO_CONFIG/client_id.json"
B2_BUCKET="my-bucket"
B2_KEY_ID="my_id"
B2_APP_KEY="my_secret"

# Run
docker run --rm \
-v $STORAGE_DIR:/storage \
-v $CLIENT_SECRET:/config/client_secret.json:ro \
-e B2_BUCKET=$B2_BUCKET \
-e B2_KEY_ID=$B2_KEY_ID \
-e B2_APP_KEY=$B2_APP_KEY \
tylerodonnell/google-photos-backup
```