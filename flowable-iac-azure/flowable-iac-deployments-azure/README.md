# Flowable Infrastructure as Code - Deployments - Azure

This folder contains example Terragrunt configurations for deploying Flowable on a Kubernetes cluster on Azure.

## How do you deploy the infrastructure in this repo?

Deploying the Flowable infrastructure basically consists of 3 steps;

1. [Install and configure the tooling](#tooling) (required once)
2. [Configure the provisioning resources](#provisioning)  (required once)
3. [Deploy the infrastructure](#deploy)

### Pre-requisites

<a name="tooling"></a>
#### Required Tooling

Before we can start deploying the infrastructure components and applications we need to have a few tools and settings in place.
We need that have the Terraform, Terragrunt and Azure CLI tools installed. Follow the steps below.

> For the current configuration Terraform will authenticate to Azure via a Microsoft account. In `step 4` the account that will be used is verified (or configured). 
Next iterations will also provide support using a dedicated service account.

*The examples below are based on a `macos` environment with the package manager `brew` installed. More info how to install `brew` can be found [here](https://brew.sh). Instructions on how to install the tooling on other platforms can be found in the links below.*

1. Install `Terraform` version `v1.0.0` or newer. More info can be found [here](https://learn.hashicorp.com/tutorials/terraform/install-cli).

```console
    brew install terraform
```

2. Install `Terragrunt` version `v0.32.0` or newer. More info can be found [here](https://terragrunt.gruntwork.io/docs/getting-started/install/).

```console
    brew install terragrunt
```

3. Install `Azure CLI` version `v2.30.0` or newer. More info can be found [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).

```console
    brew install azure-cli
```

4. Verify the default Azure subscription

    1. Open a command line that has access to the Azure CLI.

    2. Run `az login` without any parameters and follow the instructions to log in to Azure.

    ```console
    az login
    ```

    *Upon successful login, az login displays a list of the Azure subscriptions associated with the logged-in Microsoft account, including the default subscription.*

    3. To confirm the current Azure subscription, run `az account show`.

    ```console
    az account show
    ```

    4. To view all the Azure subscription names and IDs for a specific Microsoft account, run `az account list`.

    ```console
    az account list
    ```

    5. To use a specific Azure subscription, run `az account set`.

    ```console
    az account set --subscription "<subscription_id_or_subscription_name>"
    ```

<a name="tooling"></a>
#### Required infrastructure resources

##### Remote State

Terraform must store state about your managed infrastructure and configuration. By default, Terraform stores state locally in a file named terraform.tfstate. When working with Terraform in a team, use of a local file makes Terraform usage complicated because each user must make sure they always have the latest state data before running Terraform and make sure that nobody else runs Terraform at the same time.

With remote state, Terraform writes the state data to a remote data store, which can then be shared between all members of a team. 

In order to store this remote state a `storage account` and `storage container` must be created or provided.

> The values used in the examples below reflect the current configuration. When changing resource names please update the corresponding configuration files.

1. Create a 'provisioning' `resouce group`
> It can be consired a best practice to create a seperate resource group which will contain the Terraform state and other resources that will be used to provision the different enviroments. This will prevent having to recreate these resources when a specific environment (like `dev` or `qa`) is removed.

```console
az group create --location northeurope --resource-group flowable-iac-tf-prov
```

> Used in `/<account>/<region>/<env>/env.hcl: state_storage_resource_group_name`

2. Create a storage account

```console
az storage account create --resource-group flowable-iac-tf-prov --name flowableiactfstate --sku Standard_LRS --encryption-services blob
```

> Used in `/<account>/<region>/<env>/env.hcl: state_storage_account_name`

3. Get storage account keys 
```console
az storage account keys list --resource-group flowable-iac-tf-prov --account-name flowableiactfstate
```

3. Create storage container with account key (retrieved with previous command)
```console
az storage container create --name tfstate --account-name flowableiactfstate --account-key <ACCOUNT_KEY>
```

> Used in `/<account>/<region>/<env>/env.hcl: state_storage_container_name`

4. Update `/<account>/<region>/<env>/env.hcl` when needed.

##### Secrets

Several components use security sensitive resources like authentication creditials and license files. It's not preferable to have the contents of these resources stored in the configuration repository.
A way to avoid this is to put them in the 'provision resource group' as `keyvault secrets`. This provides a more fine grained control on who can access them. One could for example choose to create ser
During the deployment and configuration of the infrastructure components the keyvault secrets will be used to create `Kubenetes secrets`. The infrastructure components are configured to make use of these secrets.

1. Create a `key vault`

```console
az keyvault create --location northeurope --name kv-flowable-iac --resource-group flowable-iac-tf-prov
```

> Used in `/<account>/<region>/<env>/env.hcl: keyvault_name`

> Used in `/<account>/<region>/<env>/env.hcl: keyvault_resource_group_name`

2. Create credential secrets

    1. Flowable artifacts (https://artifacts.flowable.com) repository username

    ```console
    az keyvault secret set --name flowable-repo-username --vault-name kv-flowable-iac --value <repo_username>
    ```

    > Used in `/<account>/<region>/<env>/env.hcl: keyvault_secret_name_flowable_repo_username`

    2. Flowable artifacts (https://artifacts.flowable.com) repository password

    ```console
    az keyvault secret set --name flowable-repo-password --vault-name kv-flowable-iac --value <repo_password>
    ```

    > Used in `/<account>/<region>/<env>/env.hcl: keyvault_secret_name_flowable_repo_password`

    3. Flowable DB username

    ```console
    az keyvault secret set --name flowable-db-username --vault-name kv-flowable-iac --value <db_username>
    ```

    > Used in `/<account>/<region>/<env>/env.hcl: keyvault_secret_name_flowable_db_username`

    4. Flowable DB password

    ```console
    az keyvault secret set --name flowable-db-password --vault-name kv-flowable-iac --value <db_password>
    ```

    > Used in `/<account>/<region>/<env>/env.hcl: keyvault_secret_name_flowable_db_password`

    5. Flowable DB admin password

    ```console
    az keyvault secret set --name flowable-db-admin-password --vault-name kv-flowable-iac --value <db_admin_password>
    ```

    > Used in `/<account>/<region>/<env>/env.hcl: keyvault_secret_name_flowable_db_admin_password`

    6. Flowable License file

    ```console
    az keyvault secret set --name flowable-license --vault-name kv-flowable-iac --file <license file location>
    ```

    > Used in `/<account>/<region>/<env>/env.hcl: keyvault_secret_name_flowable_license`

### Deploy

#### Reposistory hierachy 

The Flowable infrastructure consists of several components. These components can be deployed with different configurations as different environments. For example; the sizing requirements of the Kubernetes cluster in production will probably be different in a `prod` environment than in a `qa` environment.
Also; the cloud provider account that will be used for deployments in `prod` and `non-prod` environments will often be different. And the region can be different too.
To accomodate these deployment scenarios the following repository structure was chosen.

```
account
└ region
    └ environment
        └ resource
```

When a requirements are different; for example; there is no need to deploy `prod` and `non-prod` in different regions or with different accounts these folders can be removed from the hierachy.


#### Deploy a full environment

Currently this example deployment configuration consists of a `dev` and a `prod` environment.
To deploy (or update) the `dev` environment execute the following commands;

```
> cd <git_checkout>/azure/non-prod/northeurope/dev/
> terragrunt run-all apply
```

Terragrunt with pull the Flowable Terraform modules from the repository and determine required execution order based on the internal dependencies.

```
> INFO[0000] The stack at /Users/yvoswillens/Developer/projects/flowable-iac/flowable-infrastructure-deployments/azure/non-prod/northeurope/dev will be processed in the following order for command apply:
Group 1
- Module /Users/yvoswillens/Developer/projects/flowable-iac/flowable-infrastructure-deployments/azure/non-prod/northeurope/dev/foundation/resource-group

Group 2
- Module /Users/yvoswillens/Developer/projects/flowable-iac/flowable-infrastructure-deployments/azure/non-prod/northeurope/dev/foundation/k8s/aks-cluster
- Module /Users/yvoswillens/Developer/projects/flowable-iac/flowable-infrastructure-deployments/azure/non-prod/northeurope/dev/foundation/postgres-flexible-server

Group 3
- Module /Users/yvoswillens/Developer/projects/flowable-iac/flowable-infrastructure-deployments/azure/non-prod/northeurope/dev/foundation/k8s/ingress-nginx
- Module /Users/yvoswillens/Developer/projects/flowable-iac/flowable-infrastructure-deployments/azure/non-prod/northeurope/dev/foundation/k8s/k8s-config
- Module /Users/yvoswillens/Developer/projects/flowable-iac/flowable-infrastructure-deployments/azure/non-prod/northeurope/dev/foundation/elk

Group 4
- Module /Users/yvoswillens/Developer/projects/flowable-iac/flowable-infrastructure-deployments/azure/non-prod/northeurope/dev/app/postgres-flexible-databases

Group 5
- Module /Users/yvoswillens/Developer/projects/flowable-iac/flowable-infrastructure-deployments/azure/non-prod/northeurope/dev/app/flowable-app
 
Are you sure you want to run 'terragrunt apply' in each folder of the stack described above? (y/n) 
```

After confirming that you want to execute the described stack will be deployed.

#### Deploy seperate components

In the previous example a complete environment was deployed in one go. In some cases you want control over each step. And the ability the verify the planned changes to the infrasture before actually applying them.
`Terragrunt plan` can be used for that. But there is an important caveat. The complete infrastructure for an environment has internal dependencies. In order for Terraform to determine what the required changes are it needs to compare the deployed infrastrure against the `terraform state` file. When executing a `terragrunt plan` on a complete stack that has not been 'applied' before this would fail because there isn't a 'state' yet.
Therefore it is important that it is only possible to execute a `terraform plan` on components that have no dependencies or on components that have been 'applied' (/have state) before.

Another import aspect to take into account is that when making chances to `foundation` components; for example changing the name of the resource group; that would result in re-creating that component will have affect on other components.

#### Infrastructure Components

##### ELK Stack (Elasticsearch, Kibana)

The infrastructure includes an optional ELK stack module that provisions Elasticsearch and Kibana for centralized logging and search functionality. This replaces the embedded Bitnami Elasticsearch images previously used in the Flowable Helm chart.

**Key Features:**
- Official Elastic Helm charts instead of Bitnami images
- Persistent storage with configurable storage class and size
- Configurable resource limits for different environments
- Production-ready configuration with sysctl init container
- Isolated namespace deployment

**Configuration:**
The ELK stack is deployed as part of the foundation infrastructure and can be enabled/disabled via the `es_enabled` flag in the `app.hcl` file:

```hcl
# In <env>/app/app.hcl
locals {
  es_enabled = true  # Set to false to disable Elasticsearch
}
```

When enabled:
- Dev environments use minimal resources (1 replica, 10Gi storage)
- Prod environments use high-availability configuration (3 replicas, 50Gi storage)
- The Flowable application automatically connects to the external Elasticsearch instance

**Module Location:** `flowable-iac-modules-azure/elk/`

For detailed module documentation, see the [ELK module README](../../flowable-iac-modules-azure/elk/README.md).

##### Review and deploy Flowable App

The configuration of the Flowable Helm chart is done in the `values.yaml` file. 

>`<git_checkout>/azure/non-prod/northeurope/dev/app/flowable-app/values.yaml`

In the default configuration the `Flowable Control` component is not deployed. This can be changed by changing the following property;

```
control:
  enabled: true
```

To review this change before actually deploying it run the following command;

```
> cd <git_checkout>/azure/non-prod/northeurope/dev/app/flowable-app/
> terragrunt plan
```

After you have verified the indicated changes you can apply them by;

```
> cd <git_checkout>/azure/non-prod/northeurope/dev/app/flowable-app/
> terragrunt apply
```

This will apply the updates to `Flowable app` only.