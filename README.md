# ☕ dns

![validate](https://github.com/theobori-cafe/dns/actions/workflows/validate.yml/badge.svg)

## 📖 Build and run

You only need the following requirements:
- [Terraform](https://www.terraform.io/downloads.html) 1.4.6+

Before operating with Terraform, the OVH provider requires the following environment variables, you can create a sh file like this:

```sh
cat <<EOF > .ovhrc
#!/bin/sh

export OVH_ENDPOINT=""
export OVH_APPLICATION_KEY=""
export OVH_APPLICATION_SECRET=""
export OVH_CONSUMER_KEY=""
EOF

source .ovhrc
```

Now you can use the Terraform project.