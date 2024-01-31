v0.8.1
- Bug fix: relax ex_aws requirement https://github.com/kyleaa/libcluster_ec2/pull/34

v0.8.0
- Enhancement: Support IMDSv2 (Requires ExAws 2.3.2 minimum) https://github.com/kyleaa/libcluster_ec2/pull/33

v0.7.0
- Enhancement: auto reconnect when disconnected by some reason https://github.com/kyleaa/libcluster_ec2/pull/27
- Dependency Cleanup: Remove Poison dependency https://github.com/kyleaa/libcluster_ec2/pull/23

v0.6.0
- Enhancement: block on startup while attempting first load https://github.com/kyleaa/libcluster_ec2/pull/20
- Enhancement: allow optional disable of debug logging https://github.com/kyleaa/libcluster_ec2/pull/21/files

v0.5.0
- Enhancement: add ability to configure ip_to_nodename function. https://github.com/kyleaa/libcluster_ec2/pull/17

v0.4.2
- Bug fix: correct public IP address detection with tags strategy https://github.com/kyleaa/libcluster_ec2/pull/16

v0.4.1
- Bug fix: skip EC2 instances that are not running

v0.4.0
- Updated to Tesla 1.0 and support for libcluster 3.0)

v0.3.0
- Moved to ex_aws 2.0 https://github.com/kyleaa/libcluster_ec2/issues/8

v0.2.1
- Bug fix: Reconnection error handling. https://github.com/kyleaa/libcluster_ec2/pull/6

v0.2.0
- Enhancement: Add error handling for AWS/EC2 API calls. In the event of a failure to communicate, maintain current node list. https://github.com/kyleaa/libcluster_ec2/pull/4

v0.1.3
- Enhancement: automatically determine instance region.  https://github.com/kyleaa/libcluster_ec2/pull/3

v0.1.2
- Enhancement: add default config values.  https://github.com/kyleaa/libcluster_ec2/pull/2
