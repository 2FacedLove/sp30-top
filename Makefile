PROJ_ROOT=$(shell pwd)
DEPLOY_DIR=$(PROJ_ROOT)/target/add-ons
SPOND_REPOS_REF=https://github.com/Spondoolies-Tech
PACKAGES_SUBDIR=packages
TARGETS=get build init

PKG_LIST = $(patsubst $(PACKAGES_SUBDIR)/%/, %, $(dir $(wildcard $(PACKAGES_SUBDIR)/*/Makefile)))

image: do_deploy
do_deploy: build deploy

$(TARGETS):
	set -e; for d in $(PKG_LIST); do make -C $(PACKAGES_SUBDIR)/$$d $@ SPOND_REPOS_REF="$(SPOND_REPOS_REF)" ; done
	@echo "$@ completed"

deploy:
	if [ -a $(HOME)/spond_next_ver ]; \
	then \
		mv $(HOME)/spond_next_ver $(DEPLOY_DIR)/../add-ons/fs/fw_ver; \
	else \
		vi $(DEPLOY_DIR)/../add-ons/fs/fw_ver; \
	fi
	echo $(PROJ_ROOT) > packages/buildroot/root-dir
	set -e; for d in $(filter-out buildroot, $(PKG_LIST)) buildroot; do make -C $(PACKAGES_SUBDIR)/$$d $@ DEPLOY_DIR=$(DEPLOY_DIR); done
	cp packages/buildroot/uImage ./
	cp packages/buildroot/spondoolies.dtb ./
	@echo "$@ completed"
