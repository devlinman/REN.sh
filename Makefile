install:
	@commands="convert zip file"; \
	missing=""; \
	for cmd in $$commands; do \
		if ! which $$cmd >/dev/null 2>&1; then \
			missing="$$missing $$cmd"; \
		fi; \
	done; \
	if [ ! -z "$$missing" ]; then \
		echo -e "\e[1;31mError: The following command(s) are missing in PATH: $$missing.\n\e[0m"; \
		echo -e "\e[1;32mTrying to install...\e[0m"; \
		yes | yay -S $$missing; \
	fi; \
	if [ -d "/usr/share/REN" ]; then \
		sudo rm -Rf /usr/share/REN; \
	fi; \
	sudo install -m755 ./REN.sh /usr/bin/REN; \
	sudo mkdir -p /usr/share/REN; \
	sudo cp ./LICENSE /usr/share/REN/REN.LICENSE; \
	sudo install -m755 ./ex-pdf.sh /usr/bin/ex-pdf; \
	echo -e "\e[1;32mApp Installation Successful!\nInstalled Apps:\tREN, ex-pdf.\
	\nLISENCE CAN BE FOUND AT /usr/share/REN/REN.LICENSE\e[0m"; \


remove:
	@sudo rm /usr/bin/REN
	@sudo rm /usr/bin/ex-pdf
	@sudo rm -Rf /usr/share/REN
	@echo -e "\e[1;32mRemoved Apps:\tREN, ex-pdf, REN.LICENSE\e[0m"

reinstall: remove install

