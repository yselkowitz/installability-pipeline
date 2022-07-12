# installability-pipeline

This repository contains the tmt plam for the [installability test](https://docs.engineering.redhat.com/pages/viewpage.action?spaceKey=RHELPLAN&title=Installability+Testing).

## Test definition

The generic installability test is described in a [Flexible Metadata Format](https://pagure.io/fedora-ci/metadata).

The actual definition lives in the [installability.fmf](./installability.fmf) file.

## Test execution

Try it locally:
```shell
tmt run -ae REPO_URL="https://centos.softwarefactory-project.io/logs/11/11/9e75bb0c73d34f33b216e278645cb648efc4b929/check/mock-build/d39b3e8/repo/" -d provision --how virtual.testcloud --image centos-9 plan --name /installability
```
