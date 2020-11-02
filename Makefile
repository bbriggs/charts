#############################################################
# Turn a directory containing helm charts into a helm repo. #
#############################################################

# How to use: set SOURCES_DIRECTORY and OUTPUT_DIRECTORY.
# `make repo`, commit in the OUTPUT_DIRECTORY, push.

# Configuration

SOURCES_DIRECTORY=./sources# Note: you can link your helm in this directory
OUTPUT_DIRECTORY=./site

SIGN_PACKAGES="yes"# Add anything, probably "yes" to sign packages. ("no" would work too though, as stupid of a choice it would be.)
#KEY_NAME= In case you want to change the defaults.
#KEYRING=

# Procedures

.PHONY: all

all: repo

repo: packages
	helm repo index $(OUTPUT_DIRECTORY)

packages: preparation
	[ "$(SIGN_PACKAGES)" != "" ] && \
		helm package --sign --key $(KEY_NAME) --keyring $(KEYRING) \
			$(SOURCES_DIRECTORY)/* -d $(OUTPUT_DIRECTORY) || \
		helm package $(SOURCES_DIRECTORY)/* -d $(OUTPUT_DIRECTORY)


preparation: envcheck
	helm lint $(SOURCES_DIRECTORY)/*
	ls $(OUTPUT_DIRECTORY)/robots.txt >/dev/null || \
		echo -e "User-Agent: *\nDisallow: /" > $(OUTPUT_DIRECTORY)/robots.txt

envcheck:
	helm version > /dev/null
	ls $(SOURCES_DIRECTORY) > /dev/null
	mkdir -p $(OUTPUT_DIRECTORY)
