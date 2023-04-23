# maintenance_scripts
Collection of server maintenance scripts.

Uses the [Twillio SendGrid](https://www.twilio.com/en-us/sendgrid/email-api) API to email alert of errors. The API key, mail addresses and error log location must be put in a `config.sh`  file, following the format of `config_example.sh`. All scripts output results to a single `error_scripts.log` file. These scripts can be added to e.g. `cron` for scheduling. They must be marked as executable to run, e.g.
1. `chmod +x zpool_status.sh`
2. `./zpool_status.sh`

Scripts:
- `zpool_status.sh`: runs `zpool status` and warns of any error in a ZFS pool. 