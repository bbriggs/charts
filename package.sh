#! /bin/sh

helm package ./charts/${1}
helm repo index --url https://bbriggs.github.io/charts .
