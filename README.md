amimoto Cookbook
================



Requirements
------------

Attributes
----------

Usage
-----


Test
----

### Setup


```
gem install bundler
bundle
```

### Configuration

Create .kitchen.local.yml. This file will override credincial settings.

!! Don't add.kitchen.local.yml to git !!

```
---
driver_plugin: ec2
driver_config:
  aws_access_key_id: YOUR_AWS_KEY
  aws_secret_access_key: YOUR_AWS_SECRET
  aws_ssh_key_id: SSH_KEY_NAME_OF_NEW_INSTANCE
  ssh_key: FULL_PATH_TO_KEY
```


### Test


```
# to create instance

kitchen create

# to run chef

kitchen converge

# to run serverspec

kitchen verify

# terminate instance

kitchen destroy
```



Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: TODO: List authors
