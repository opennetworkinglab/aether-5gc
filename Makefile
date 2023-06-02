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
