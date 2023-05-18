# local-k8s-multi-cluster

![License](https://img.shields.io/github/license/Y0sh1dk/local-k8s-multi-cluster)

`local-k8s-multi-cluster` is a repository that provides a simple setup for running multiple Kubernetes clusters locally using kind. It aims to simplify the process of managing and experimenting with multiple Kubernetes clusters for development, testing, or learning purposes.

## Prerequisites

To use this repository, ensure that you have the following prerequisites installed on your machine:

- [Docker](https://www.docker.com/get-started)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [taskfile](https://taskfile.dev/)

## Getting Started

To get started with `local-k8s-multi-cluster`, follow these steps:

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/Y0sh1dk/local-k8s-multi-cluster.git
   ```

2. Provision:

   ```bash
   task all
   ```

## License

This project is licensed under the [MIT License](LICENSE).
