# **Deploy Secure Cloud Applications with Containers on Azure**

Este repositório contém a infraestrutura como código (IaC) utilizando Terraform para criar um ambiente seguro na Azure voltado para o deploy de aplicações em contêineres.

## **Descrição**

Este projeto é baseado no livro *Getting Started with Containers in Azure* de Shimon Ifrah. Ele fornece um guia prático para configurar e gerenciar aplicações em contêineres na Azure, focando em segurança e boas práticas. Aqui, implementamos esses conceitos utilizando Terraform para automatizar a criação da infraestrutura.


## **Tabela de Conteúdos**
- [Pré-requisitos](#pré-requisitos)
- [Instalação](#instalação)
- [Uso](#uso)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Capítulos do Livro](#capítulos-do-livro)
- [Autores e Agradecimentos](#autores-e-agradecimentos)

## **Pré-requisitos**

Antes de começar, certifique-se de ter os seguintes itens instalados:
- [Terraform](https://www.terraform.io/downloads.html) = v1.8.5
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) = 2.63.0
- Uma conta ativa no [Azure](https://azure.microsoft.com/)
- Conhecimento básico de Terraform e Azure

## **Instalação**

1. Clone o repositório:

    ```bash
    git clone https://github.com/seuusuario/nome-do-repositorio.git
    cd nome-do-repositorio
    ```

2. Autentique-se no Azure:

    ```bash
    az login
    ```

3. Inicialize o Terraform:

    ```bash
    terraform init
    ```

4. Configure suas variáveis de ambiente (ou edite os arquivos `.tfvars` correspondentes).

5. Aplique o plano Terraform para criar a infraestrutura:

    ```bash
    terraform apply
    ```

## **Uso**

Este projeto provisiona uma infraestrutura completa para o deploy de aplicações em contêineres na Azure, incluindo:
- Recursos de rede (VNet, Subnets, etc.)
- Contas de armazenamento
- Clusters Kubernetes (AKS)
- Regras de segurança e firewall

Após aplicar o plano Terraform, você pode gerenciar seus contêineres utilizando o Azure Kubernetes Service (AKS) e outras ferramentas de gerenciamento da Azure.

## **Estrutura do Projeto**

Cada diretório representa um capítulo do livro à partir do segundo


## **Capítulos do Livro**

Este projeto foi inspirado e construído com base nos conceitos apresentados no livro *Getting Started with Containers in Azure* de Shimon Ifrah. Abaixo estão os títulos dos capítulos que serviram de referência:

1. **Getting Started with Azure and Terraform**
2. **Azure Web App for Containers**
3. **Azure Container Registry**
4. **Azure Container Instances**
5. **Azure Kubernetes Service**
6. **Azure DevOps and Container Service**
7. **Azure Compliance and Security**

## **Autores e Agradecimentos**

- **Autor Principal:** Bruna de Moraes Sousa
- **Baseado no Livro:** *Getting Started with Containers in Azure* de Shimon Ifrah

Agradecimentos especiais a todos que contribuíram com feedback e sugestões para melhorar este projeto.
