ARG ARGOCD_VERSION=2.7.2
ARG LINKERD_VERSION=2.13.3
ARG TERRAFORM_VERSION=1.4.6
ARG YQ_VERSION=4.33.3
ARG JQ_VERSION=1.6
ARG KUBECTL_VERSION=1.27.2

FROM alpine:3.18.0

ARG ARGOCD_VERSION
ARG LINKERD_VERSION
ARG TERRAFORM_VERSION
ARG YQ_VERSION
ARG JQ_VERSION
ARG KUBECTL_VERSION

# Install Linkerd and add to path
RUN wget -O /usr/local/bin/linkerd https://github.com/linkerd/linkerd2/releases/download/stable-${LINKERD_VERSION}/linkerd2-cli-stable-${LINKERD_VERSION}-linux-amd64
RUN chmod +x /usr/local/bin/linkerd

# Install Argocd and add to path
RUN wget -O /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v${ARGOCD_VERSION}/argocd-linux-amd64
RUN chmod +x /usr/local/bin/argocd

# Install Terraform and add to path
RUN wget -O terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN unzip terraform.zip
RUN mv terraform /usr/local/bin/
RUN chmod +x /usr/local/bin/terraform

# Install yq and add to path
RUN wget -O /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_darwin_arm64
RUN chmod +x /usr/local/bin/yq

# Install jq and add to path
RUN wget -O /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64
RUN chmod +x /usr/local/bin/jq

# Install kubectl
RUN wget -O /usr/local/bin/kubectl https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl
RUN chmod +x /usr/local/bin/kubectl