![](https://github.com/Ferlab-Ste-Justine/cqdg-environments/workflows/Commit%20Lint%20Check/badge.svg)

# About

The goal of this repo is where the orchestration for cqdg environments will live (at least the pre-prod).

They are automatically deployed upon change in the master branch on this repo (which should follow proper pull request procedures).

# Security Note

Secrets (not matter the environment) do not belong in this repo. Any password, access key or other authentication value should be generated and managed elsewhere.

This repo should **only reference pre-existing secrets** for the purpose of orchestration. Their values should not be made available in this repo.

# Repo Structure

Each environment has its own directory.

The directory of each environment has the following components:
- A gitsubmodule link to this repo to keep things DRY: https://github.com/Ferlab-Ste-Justine/cqdg-orchestrations
- A directory per service with a **kustomization.yaml** file to customize anything that needs to be specific to the environment
- A global **Kustomization.yaml** file to put them all together.
- A **.flux.yaml** file so that flux can scrape the repo.

# Adding an Environment

For a new persistent environment, beyond creating a new directory for it in this repo, you also need to follow the procedures detailed in the following repo: https://github.com/Ferlab-Ste-Justine/kubernetes-cd

# Access Considerations

Because deployments are done from the master branch, the master branch should be protected to require a pull request and a code review before changes are affected to it.

Because flux needs to commit deployments automatically, users with administrative access to the repo need to remain exempt from the above (not a big security concession since they can disable it at any time anyways).

As a good practice however, even users with admin access to the repo should submit pull requests (only bots are exempt).

# Technological Choices

Beyond plain kubernetes manifests, **Kustomize** is used to obstain the finalized manifests and **Flux** is use to automatically scrape orchestration updates and apply them on the Kubernetes cluster.

Realistically, anybody working with this repo will need to grok those tools at least at a basic level. The good news is that they are pretty simple to figure out.

## Kustomize

The rationale for using any kind of manifests processing tool is to keep things DRYer and limit repetition errors, especially as things change (at the cost of being less readable).

The rationale for using Kustomize (instead of Helm) can be found here: https://github.com/Ferlab-Ste-Justine/cqdg-orchestrations#considered-alternatives

**Important Note**: 

We are using a recent version of Kustomize (3.7.x at the time of this writing which is the version packaged in the fluxcd image). 

The version of Kustomize bundled with **kubectl** is old in comparison (2.x last time I checked) and will not work with our orchestrations. Be mindful of that when you look at tutorials and documentation.

If in doubt, download a recent **kustomize** binary and experiment (it is safe, kustomize by itself will only generate manifests, not apply them).

## FluxCD

The rationale for continuous deployment is self-evident.

The rationale for using a CD that pulls the orchestration from the kubernetes cluster instead of using a pipeline in the repo to push it are as follow:
- Any pipeline error would usually entail a manual intervention to re-trigger it and deploy properly. A deployment service that pulls the orchestration from the cluster will keep retrying and will thus be more resilient. If at any point, the k8 cluster runs and Github is available, it will do the deployment.
- An internal cluster service that does the deployment will not expose potentially sensitive information in pipeline logs which would be accessible by anyone with access to the repo
- A lot of pipeline solutions (such as Github Actions) are dependent on configuration files directly in the repo. Any developper with write access to the repo could potentially edit those files, change the trigger to happen in their feature branch and cause a deployment without following proper code review procedures. 

The rationale for using FluxCD (instead of ArgoCD or JenkinsX) can be found here: https://www.notion.so/ferlab/Kubernetes-CD-Tools-Analysis-7efdc05e32b047f58bd0762ce0a098ed