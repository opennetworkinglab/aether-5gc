#### Variables ####

export 5GC_ROOT_DIR ?= ./
export K8S_ROOT_DIR ?= $(5GC_ROOT_DIR)/deps/k8s

export ANSIBLE_NAME ?= ansible-5gc
export ANSIBLE_CONFIG ?= $(K8S_ROOT_DIR)/ansible.cfg
export HOSTS_INI ?= hosts.ini

#### Provisioning k8s ####

include $(K8S_ROOT_DIR)/Makefile
