SHAR_NAME			:= 'Spondoolies Software'
SHAR				:= spon.shar
TAR_FILE			:= spon.tar
TAR_LATEST_FILE			:= spon-latest.tar
SCRIPT				:= ./sw-upgrade.sh
PRIVATE_KEY			:= ./security/spondoolies.pem
MAKESELF_FLAGS			:= --nocomp

ifeq ($(PRIVATE_KEY),)
$(warning Set PRIVATE_KEY: make PRIVATE_KEY=<priv key file>)
$(warning Example: make PRIVATE_KEY=spondoolies.pem)
$(error )
endif

all:				shar


shar:	../target/add-ons/fs/fw_ver ../packages/u-boot/src/u-boot.img
	cd ../ ; make build; make deploy
	cp ../uImage data/
	cp ../spondoolies.dtb data/
	cp ../target/add-ons/fs/fw_ver data/
	cp ../packages/u-boot/src/u-boot.img data/
	@echo -------------------------------
	@echo -n "Making SW upgrade version:"
	@cat data/fw_ver
	@echo -------------------------------
	makeself $(MAKESELF_FLAGS) data $(SHAR) "$(SHAR_NAME)" $(SCRIPT)
	../packages/buildroot/provisioning/sign-digest.sh --file=$(SHAR) --private=$(PRIVATE_KEY)
	tar cf $(TAR_FILE) $(SHAR) $(SHAR).sign
	$(RM) -f $(SHAR) $(SHAR).sign
	mv spon.tar spon_`cat ../target/add-ons/fs/fw_ver`.tar

.PHONY:	latest
latest:
	makeself $(MAKESELF_FLAGS) latest $(SHAR) "$(SHAR_NAME)" $(SCRIPT)
	../packages/buildroot/provisioning/sign-digest.sh --file=$(SHAR) --private=$(PRIVATE_KEY)
	tar cf $(TAR_LATEST_FILE) $(SHAR) $(SHAR).sign
	$(RM) -f $(SHAR) $(SHAR).sign
	
