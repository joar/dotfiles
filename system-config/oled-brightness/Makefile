ACPI_ACTIONS := yoga-brightness-up yoga-brightness-down
ACPI_EVENT_D = /etc/acpi/events
ACPI_SCRIPT_D = /etc/acpi

INSTALL := install --backup=numbered --suffix='.bak'

.PHONY: default
default:

.PHONY: install-acpi-actions
install-acpi-actions: $(ACPI_ACTIONS)
	$(INSTALL) -m 644 \
		$(realpath $(ACPI_ACTIONS)) \
		$(ACPI_EVENT_D)

.PHONY: install-script
install-script:
	$(INSTALL) -m 744 $(realpath yoga-brightness.sh) $(ACPI_SCRIPT_D)


.PHONY: install
install: install-script install-acpi-actions

