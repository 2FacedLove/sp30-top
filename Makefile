PROJ_ROOT=${PWD}
DEPLOY_DIR=${PROJ_ROOT}/target/add-ons
SPOND_REPOS_REF=https://github.com/Spondoolies-Tech
PACKAGES_SUBDIR=packages
GEN_TARGETS=get build

PKG_LIST = $(patsubst ${PACKAGES_SUBDIR}/%/, %, $(dir $(wildcard ${PACKAGES_SUBDIR}/*/Makefile)))

image: do_deploy
do_deploy: build deploy

init:
	set -e; for d in kernel $(filter-out kernel, ${PKG_LIST}); do make -C ${PACKAGES_SUBDIR}/$$d $@; done
	@echo "init completed"

deploy:
	if [ -a ${HOME}/spond_next_ver ] ; then mv ${HOME}/spond_next_ver ${DEPLOY_DIR}/../add-ons/fs/fw_ver; else vi ${DEPLOY_DIR}/../add-ons/fs/fw_ver; fi
	echo ${PROJ_ROOT} > packages/buildroot/root-dir
	for d in $(filter-out kernel buildroot, ${PKG_LIST}) buildroot kernel; do make -C ${PACKAGES_SUBDIR}/$$d $@ DEPLOY_DIR=${DEPLOY_DIR}; done
	cp packages/kernel/uImage ./
	cp packages/kernel/spondoolies.dtb ./

$(GEN_TARGETS):
	for d in ${PKG_LIST}; do make -C ${PACKAGES_SUBDIR}/$$d $@ SPOND_REPOS_REF="${SPOND_REPOS_REF}" ; done


