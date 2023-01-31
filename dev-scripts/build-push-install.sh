#!/bin/sh

VERSION=1.0.0
DOMAIN='<domain in cloudron to install this app>'
AUTHOR='<your name or docker registry>'

docker build -t $AUTHOR/cloudron-kafka:$VERSION ./ && docker push $AUTHOR/cloudron-kafka:$VERSION

cloudron install --image $AUTHOR/cloudron-kafka:$VERSION -l $DOMAIN

cloudron logs -f --app $DOMAIN
