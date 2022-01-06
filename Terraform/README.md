# Ansible

### Table des matières
I. [Installation](#install)<br />
&nbsp;&nbsp;&nbsp;A. [Installation sur mac](#mac)<br />
&nbsp;&nbsp;&nbsp;B. [Installation sur linux](#linux)<br />
II. [Deployer des ressources](#deploy)<br />
&nbsp;&nbsp;&nbsp;A. [local_file](#local_file)<br />
&nbsp;&nbsp;&nbsp;B. [Module Copy](#copy)<br />
III. [Playbook](#playbook)<br />
&nbsp;&nbsp;&nbsp;A. [Utilisation du playbook](#useplaybook)<br />
&nbsp;&nbsp;&nbsp;B. [Templating Jinja](#jinja)<br />




## I- Installation <a name="install"></a>

### A – Installation sur mac <a name="mac"></a>


Sur Mac

dl terraform
sudo mv terraform /usr/local/bin


### B – Installation sur linux <a name="linux"></a>

Sur Ubuntu
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform


![screenshot001](./images/IMG-001.png)


## II- Deployer des ressources <a name="deploy"></a>


### A – local_file <a name="loacal_file"></a>

<details>
<summary><code>file.tf</code></summary>

'''tf
resource "local_file" "file1" {
    filename="/Users/renaudsautour/Downloads/DEVOPS/Terraform/TP2/Renaud.txt"
    content="Bonjour Renaud"
}
'''
</details>
<br>

<details>
<summary><code>terraform init</code></summary>

```sh
Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/local...
- Installing hashicorp/local v2.1.0...
- Installed hashicorp/local v2.1.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
</details>
<br>

<details>
<summary><code>terraform plan</code></summary>

```sh
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # local_file.file1 will be created
  + resource "local_file" "file1" {
      + content              = "Bonjour Renaud"
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "/Users/renaudsautour/Downloads/DEVOPS/Terraform/TP2/Renaud.txt"
      + id                   = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```
</details>
<br>

<details>
<summary><code>terraform apply</code></summary>

```sh
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # local_file.file1 will be created
  + resource "local_file" "file1" {
      + content              = "Bonjour Renaud"
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "/Users/renaudsautour/Downloads/DEVOPS/Terraform/TP2/Renaud.txt"
      + id                   = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only "yes" will be accepted to approve.

  Enter a value: yes

local_file.file1: Creating...
local_file.file1: Creation complete after 0s [id=52d29d313a281835e468f21725ac02a39039ce7f]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
'''
</details>
<br>


















ACCCESS KEY AWS

Access key ID
AKIAXXXNTM5FEKXLHC3M

Secret access key
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



<br />

<details>
<summary><code>résulat</code></summary>

</details>
<br />
