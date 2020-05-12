This dockerfile will add following php extensions to the base image:
* intl
* mysqli
* pdo_mysql
* zmq
* zip
* gd

Also, the given locale will be generated

## Supported php images
All php images based on debian are supported. Tested with php 7

## Supported ENV
* production
* development
