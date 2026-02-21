# 5gc

The 5gc repository builds a standalone Aether core with a physical RAN setup.
It depends a k8 cluster which can be deployed using k8 repository that can help to create a multi-node cluster.

To set up the 5gc repository, you need to provide the following:

1. Node configurations with IP addresses in the host.ini file.
   - You can specify both master and worker nodes.
2. Aether configuration parameters, such as RAN_Interface, in the ./var/main.yaml file.

To download the 5gc repository, use the following command:
```
git clone https://gitlab.com/onf-internship/5gc.git
git clone https://gitlab.com/onf-internship/k8s.git
```
### Step-by-Step Installation
To install the 5g-core, follow these steps:
1. Set the configuration variables in the vars/main.yaml file.
   - Set the "standalone" parameter to deploy the core independently from roc.
   - Specify the "data_iface" parameter as the network interface name of the machine.
   - Set the "values_file" parameter:
     - Use "sdcore-5g-values.yaml" for a stateful 5g core.
     - Use "hpa-5g-values.yaml" for a stateless 5g core.
   - The "custom_ran_subnet" parameter if left empty, core will use the subnet of "data_iface" for UPF.
2. Add the hosts to the init file.
3. Run `make ansible`.
4. In the running Ansible docker terminal:
   - Make sure you have dployed a k8 cluster using `k8s-install` from k8s repo.
   - run `make 5gc-install`
   - It creates networking interfaces for UPF, such as access/core, using `5gc-router-install`.
   - Finally, it installs the 5g core using the values specified in `5gc-core-install`.
     - The installation process may take up to 3 minutes.

#### One-Step Installation
To install 5gc in one go, run `make 5gc-install`.
#### Uninstall
   - run `make 5gc-uninstall`

### Confidential Containers Configuration (Optional)

To deploy 5G core network functions in confidential containers, add the following configuration to your `vars/main.yaml` file under the `core` section:

```yaml
core:
  # ... existing configuration ...

  # Confidential Container Configuration
  confidential_containers:
    enabled: false                   # Set to true to enable confidential containers
    runtime_class: "kata-qemu"       # Runtime class (default: kata-qemu)
    annotation:
      enabled: false                 # Enable Kata-specific annotations
      kernel_params: ""              # Custom kernel parameters (leave empty for defaults)
    attestation:
      enabled: false                 # Enable attestation verification
      required: false                # If true, pods fail when attestation fails
      kbs_address: ""                # Key Broker Service address (e.g., "http://kbs-service:8080")
      url: "http://127.0.0.1:8006/aa/token?token_type=kbs"  # Attestation endpoint
      timeout: 300                   # Attestation timeout in seconds
```
#### Confidential Container Prerequisites

Before enabling confidential containers, ensure:

- Kata Containers is installed on all Kubernetes nodes
- Runtime Class is configured in your cluster:

```bash
kubectl get runtimeclass
```

- KBS (Key Broker Service) is deployed if using attestation
- Hardware support for TDX confidential computing

#### Configuration Examples

Basic Confidential Containers (no attestation):

```yaml
confidential_containers:
  enabled: true
  runtime_class: "kata-qemu"
  annotation:
    enabled: false
  attestation:
    enabled: false
```

Full Confidential Containers with Attestation:

```yaml
confidential_containers:
  enabled: true
  runtime_class: "kata-qemu"
  annotation:
    enabled: true
    kernel_params: ""  # Uses default KBS parameters
  attestation:
    enabled: true
    required: true
    kbs_address: "http://kbs-service.kbs-system:8080"
```

#### Verification

After deployment, verify confidential containers are working:

```bash
# Check runtime class assignment
kubectl get pods -n aether-5gc -o custom-columns=NAME:.metadata.name,RUNTIME:.spec.runtimeClassName

# Check pod annotations
kubectl get pod -n aether-5gc <pod-name> -o jsonpath='{.metadata.annotations}' | jq .
```
