### Requirements:
Ubuntu with `apt install`

The follow dependencies will be installed:
`aws-cli`
`imagemagick`
`unzip`

The following directories in the given s3 bucket will be created:
* `upload` - The folder you will upload your photos to for processing
* `thumbnail` - Contains generated thumbnail images
* `full` - Contains the full size images
* `site` - Contains the generated html and css for static site hosting

### Usage:
1. Copy `.env.example` to `.env` and fill in the variables.
2. Run `setup.sh`
3. Configure the `full` and `thumbnail` s3 folder to be publicly accessible. 

That's it! After you upload your files to the s3 `upload` folder, the `site` folder will be re-created and will be ready to upload to the web host of your choice.