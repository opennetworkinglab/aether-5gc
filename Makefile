#### Variables ####

export ROOT_DIR ?= $(PWD)
export 5GC_ROOT_DIR ?= $(ROOT_DIR)
export K8S_ROOT_DIR ?= $(5GC_ROOT_DIR)/deps/k8s

export ANSIBLE_NAME ?= ansible-5gc
export ANSIBLE_CONFIG ?= $(K8S_ROOT_DIR)/ansible.cfg
export HOSTS_INI_FILE ?= $(5GC_ROOT_DIR)/hosts.ini

export EXTRA_VARS ?= "@$(5GC_ROOT_DIR)/vars/main.yml"

#### Provisioning k8s ####

include $(K8S_ROOT_DIR)/Makefile

#### a. Debugging ####

debug:
	ansible-playbook -i $(HOSTS_INI_FILE) $(5GC_ROOT_DIR)/debug.yml \
		--extra-vars "ROOT_DIR=$(ROOT_DIR)" --extra-vars $(EXTRA_VARS)

#### b. Provision router ####
router-install: 
	ansible-playbook -i $(HOSTS_INI_FILE) $(5GC_ROOT_DIR)/router.yml --tags install \
		--extra-vars "ROOT_DIR=$(ROOT_DIR)" --extra-vars $(EXTRA_VARS)
router-uninstall:
	ansible-playbook -i $(HOSTS_INI_FILE) $(5GC_ROOT_DIR)/router.yml --tags uninstall \
		--extra-vars "ROOT_DIR=$(ROOT_DIR)" --extra-vars $(EXTRA_VARS)
