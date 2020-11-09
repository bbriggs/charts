#! /bin/sh

helm package ./charts/*
helm repo index --url https://bbriggs.github.io/charts .
