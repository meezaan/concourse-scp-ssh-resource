# concourse-helloworld-resource
A super simple exmaple of Concourse Resource. Just say "Hello World" on your Concourse!

```yaml
# save this file as helloworld.yaml
resource_types:
- name: helloworld
  type: docker-image
  source:
    # set repo of your helloworld resource
    repository: {{YOUR_ACCOUNT/HELLOWORLD_RESOURCE}}
    ## or use my helloworld resource
    # repository: yoshiyuki/concourse-helloworld-resource

resources:
- name: helloworld
  type: helloworld

jobs:
- name: Hello World
  plan:
  - get: helloworld
  - put: helloworld
```

```shell
$ fly -t ci set-pipeline helloworld -c helloworld.yaml
```