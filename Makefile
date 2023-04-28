install:
	@commands="convert zip file"; \
	missing=""; \
	for cmd in $$commands; do \
		if ! which $$cmd >/dev/null 2>&1; then \
			missing="$$missing $$cmd"; \
		fi; \
	done; \
	if [ -z "$$missing" ]; then \
		install -m755 ./REN.sh /usr/bin/REN; \
		install -m755 ./ex-pdf.sh /usr/bin/ex-pdf; \
		echo -e "\e[1;32mApp Installation Successful!\nInstalled Apps:\tREN, ex-pdf\e[0m"; \
	else \
		echo -e "\e[1;31mError: The following command(s) are missing in PATH: $$missing.\nApp installation aborted!\e[0m"; \
		exit 1; \
	fi

remove:
	@rm /usr/bin/REN
	@rm /usr/bin/ex-pdf
	@echo -e "\e[1;32mRemoved Apps:\tREN, ex-pdf\e[0m"
