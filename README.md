# scp-ssh-resource
A Concourse resource to run commands on hosts or copy files to them using SSH or SCP. This resource is based on https://github.com/Karunamon/concourse-ssh-scp-resource, but supports adding a custom port. I could not get the changes to work in Python so rewrote it in PHP.
It also changes the format of the files to upload.

## Resource Configuration
All items are required, and go under the `source` key:

* `user`: SSH username
* `host`: Host to log into
* `port`: Port to connect to (default: 22)
* `private_key`:  Private key for `user`

## Behavior
* `check`: Not implemented
* `get`: Not implemented
* `put`: Run a command or copy a file to the configured `user@host`

### SCP

To copy files, add the `files` key to `params`, and under it, pass an list of file pairs (prefixed with a `-`) to copy with `:` as the separator between source and destination. It is recommended to quote both the source and destination to avoid any YAML parsing surprises. The source directory should be an `output` name from a previous build step. This is represented in the example as `outfiles`. The destination directory should be an absolute path (beginning with a `/`).

```yaml
- put: scp-ssh-resource
  params:
    files:
      - "outfiles/index.html:/var/www/public_html/index.html"
      - "outfiles/page.html:/var/www/public_html/page.html"
 ```

To run commands, add the `commands` key to `params`, and under that, give the commands to run as list items (prefixed with a `-`). Again, quotes are recommended to avoid YAML surprises. Note that all commands run in a `&&` chain from top to bottom, so failure or a nonzero exit of any command will result in all later commands on this step not executing.

```yaml
- put: scp-ssh-resource
  params:
    commands:
      - "ls /var/www/public_html"
      - "free -m"
      - "/bin/false"
      - "/bin/true"  # Will not run
```

You may copy files and run commands as part of the same step. **Note that file copies will always be run first**.

```yaml
params:
  files:
    - "outfiles/main.py:/var/www/public_html/main.py"
  commands:
    - 'ls /var/www/public_html`
    - `md5sum /var/www/public_html/*`
    - `systemctl restart nginx`
```

## Installation
Add a new resource type to your pipeline:
```yaml
resource_types:
- name: ssh-scp
  type: registry-image
  source: { repository: meezaan/concourse-ssh-scp-resource }
```

Then, define a resource targeting the system you want to run commands on or copy files to:
```yaml
resources:
- name: website-html-scp
  type: ssh-scp
  icon: web
  source:
    user: someuser
    host: mywebserver.com
    port: 22
    private_key: |
      -----BEGIN OPENSSH PRIVATE KEY-----
      ...
      -----END OPENSSH PRIVATE KEY-----
```

**Please use a credential manager for your private key, and do not check it into source control.**

## Thanks
[Dan Spencer (@danrspencer)](https://github.com/danrspencer) for writing this. All I've done is minor bug fixing and documentation.
[Mike Parks (@Karunamon)](https://github.com/Karunamon) for the bug fixing and docs.

