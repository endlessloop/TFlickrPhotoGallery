TFlickrPhotoGallery
===================

Fetching Flickr Albums and showing photos in a gallery style - ObjectiveC project

1. Using Flickr apis require an OAuth token. Please follow the below steps to get an OAuth token.

    - Get yourself an OAuth token from http://www.flickr.com/services/apps/create/apply/?
    - Apply for a commercial / non-commercial key based on your need.
    - Fill the form and click submit.
    - Make a note of the generated access token. It will be something similar to “d002a0ef0a9ff9d7009d9689d646c882”

2. Clone and setup XCode project

    - Clone or download the Xcode project. 
    - Launch and build the project. It will show few errors. That is because we need to setup the OAuth token we previously generated.
    - Open URLConstants.h file and replace the text "your api key" with the OAuth token you previously generated.
    - Replace the text “your user name” with your flickr user id where you want to fetch the posts. It will be something similar to “99555817#N03”
    - Remove the #error directive from the lines above the api key and blog name directives.

3. Build and Run.

4. You should now be able to see the list of all the Flickr Albums.

5. Selecting any album will launch the gallery.

6. The photo can also be shared by selecting the share button.

For more information on Flickr Apis, visit - http://www.flickr.com/services/api/

Photo Gallery is an FGallery-iPhone project. Please visit project on https://github.com/gdavis/FGallery-iPhone for more information. I have added the share feature to this project to allow sharing of photos.
