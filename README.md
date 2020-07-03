# About

The goal of this repo is to orchestrate a private "per-environment" customization on the generic cqdg orchestration.

A reference to a specific verion of the orchestration repo should be kept in each environment and a kustomization file should also be there to handle things that are unlikely to converge between environments (secrets, replication values, etc).

# Future Plans

The short to medium term plan is to be able to deploy from pipelines on the bastion when mergin to master.