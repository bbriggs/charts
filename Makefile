#############################################################
# Turn a directory containing helm charts into a helm repo. #
#############################################################

# How to use: set SOURCES_DIRECTORY and OUTPUT_DIRECTORY.
# `make repo`, commit in the OUTPUT_DIRECTORY, push.

# Configuration
OUTPUT_DIRECTORY=.

SIGN_PACKAGES="yes"# Add anything, probably "yes" to sign packages. ("no" would work too though, as stupid of a choice it would be.)
#KEY_NAME= In case you want to change the defaults.
#KEYRING=

# Procedures

SRD=""

.PHONY: all

all: repo

repo: packages
	helm repo index ${OUTPUT_DIRECTORY}

packages: preparation
	[ "${SIGN_PACKAGES}" != "" ] && \
		helm package --sign --key ${KEY_NAME} --keyring ${KEYRING} \
			./charts/* -d . || \
		helm package ./charts/* -d .


preparation:
	helm lint ./charts/*
	ls  ./robots.txt >/dev/null || \
		echo -e "User-Agent: *\nDisallow: /" >  ./robots.txt
