
resource "azurerm_linux_virtual_machine" "agent_vm" {
  name                = "agent-machine"
  resource_group_name = azurerm_resource_group.imp_rg.name
  location            = azurerm_resource_group.imp_rg.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.ansible_network_interf.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("${path.module}/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.imp_sc.primary_blob_endpoint
  }

  
}

resource "null_resource" "provisioning" {
  triggers = {
    always_run = "${timestamp()}"
  }

  connection {
    type        = "ssh" 
    host        = azurerm_linux_virtual_machine.agent_vm.public_ip_address
    user        = azurerm_linux_virtual_machine.agent_vm.admin_username
    private_key = file("${path.module}/.ssh/id_rsa.pem")
  }

  provisioner "local-exec" {
    command     = "echo ${azurerm_linux_virtual_machine.agent_vm.public_ip_address} >> creation-time.txt"
    working_dir = "outputs/"
  }
  provisioner "file" {
    source = "scripts/apps.sh"
    #content = "Hello World" ##We can also use the content to be displayed at dest path
    destination = "apps.sh" #remote destination
    #on_failure = continue/fail
  }

  provisioner "file" {
    source = "scripts/agent.sh"
    #content = "Hello World" ##We can also use the content to be displayed at dest path
    destination = "agent.sh" #remote destination
    #on_failure = continue/fail
  }

  provisioner "file" {
    source = "scripts/azure_setup.yml"
    destination = "azure_setup.yml" #remote destination
 
  }

  provisioner "remote-exec" {
    inline = [
      # "pwd",
      # "chmod +x apps.sh",
      # "sudo ./apps.sh",
      "chmod +x azure_setup.yml",
      "ansible-playbook azure_setup.yml",
      # "sudo groupadd docker",
      # "sudo usermod -aG docker $USER",
      # "newgrp docker",
      "chmod +x agent.sh",
      "sudo ./agent.sh",
      "sudo docker run -d --name sonarqube -p 9000:9000 sonarqube:latest"
    ]
  }


}

