Chef Workstation Cookbook
=========================
This cookbook is used to setup base workstations for students attending Chef Training courses when required.  This cookbook only contains the student workstation configuration and is intended as a reference point so that anyone can easily rebuild their instructional environment.

Additional classroom infrastructure (deployment, portals, etc) is handled by the [chef classroom][classroom_repo] cookbook.

### About Chef Training
Chef Training courses are available via [Creative Commons Share-Alike][ccsa_license] licensing.  This repo is freely available for anyone to use and is released under the [MIT license][license].  You may use any of Chef's training material in conjunction with a training classroom environment per their respective licensing agreements.  Go teach more awesome!

Instructor-led training is also available and sessions cover a variety of Chef topics in locations across the globe.  For more details, visit the [Chef Training Calendar][chef_training] to find a location near you.

TODO: Add CCSA link

Requirements
------------
### Supported Operating Systems
- Centos 6

Roadmap:

- Amazon Linux 6
- Windows

At present, only CentOS instances are used as base student workstations, though these recipes should work on other RHEL platform family distros.


### Generating AMIs
During Chef-led training sessions, student workstations typically run in EC2.  Chef typically discourages use of "pre-baked" AMIs (i.e. golden images), except when use of such artifacts is warranted.  It may be more efficient for classroom environments to build one AMI and spin up many of those as opposed to spinning up dozens of instances all building in parallel (YMMV).  Begining Chef students may also prefer use of a static AMI to get started quickly.  The ``packer.json`` and ``ami_create.sh`` script provided in this repo are used to periodically update static AMIs.

[Packer][packer] must be installed and the following ENV variables must be set

- $AWS_ACCOUNT_ID
- $AWS_ACCESS_KEY_ID
- $AWS_SECRET_ACCESS_KEY
- $AWS_X509_CERT_PATH
- $AWS_X509_KEY_PATH
- $AWS_S3_BUCKET (must be an existing S3 bucket name)

Follow this wonderful [packer_tutorial] to set up your own automatic AMI generation.

TODO: replace with a proper chef-provisioning image workflow.

Attributes
----------
For ease of classroom use, this cookbook creates a named user account and enables password auth via SSH.

* `chef_workstation['user']` - Named user account to create 
* `chef_workstation['password']` - Plaintext password for auth
* `['chef_workstation']['docker']['rpm']` - URI for the docker-engine rpm to install

Use of this cookbook is (obviously) not recommended for production or anything other than an inconsequential classroom setting.

Cookbook Recipes
----------------
### default
This recipe does common things that happen to every type of classroom workstation instance.  This recipe configures a named user account, enables password auth, installs a current Chef DK, and eases default security settings (for quick on-ramp to automation concepts).

### docker
When delving into test-kitchen, Chef training utilizes Docker containers for testing.  This recipe preps our base workstation as a docker host and installs the ``kitchen-docker`` gem.

### aws_workshop
Single day AWS related workshops make use of [Chef Provisioning][provisioning] and the [Chef Provisioning AWS driver][c-p-aws] to focus on platform integration between Chef and AWS.  This recipe ensures required gems are up-to-date (sometimes ahead of what's in Chef DK) and sets up placeholders for required AWS credentials.

### full_stack
Deploys all workstation permutations onto a single node.

TODO: consider only exposing wrapper recipes that build each type of workstation permutation and internalizing these specifics.

Deploying a training classroom
------------------------------
The [chef classroom][classroom_repo] cookbook makes use of this [repo] by wrapping deployment logic around individual student workstations.  Deployment instructions may be found there.

TODO: create instructions on how to stitch together the various components

Contributing
------------
Take a look at open [issues] first.

1. Fork it
2. Change it
3. **Write tests for it**
4. Submit a PR

License & Authors
-----------------
- Author:: Ned Harris (<ned@chef.io>)
- Author:: George Miranda (<gmiranda@chef.io>)

Chef Software, Inc. 2015.  Released under the [MIT license][license].

[repo]:				https://github.com/gmiranda23/chef_workstation/
[classroom_repo]:	http://github.com/gmiranda23/chef_classroom
[ccsa_license]:		http://link.to.creative.commons
[license]:			https://github.com/gmiranda23/chef_workstation/blob/master/LICENSE
[chef_training]:	http://chef.io/training
[issues]:			https://github.com/gmiranda23/chef_workstation/issues
[provisioning]:		https://github.com/chef/chef-provisioning
[c-p-aws]: 			https://github.com/chef/chef-provisioning-aws
[packer]:			https://github.com/mitchellh/packer
[packer_tutorial]: http://engineering.cotap.com/post/78783269747/hello-world-using-packer-chef-and-berkshelf-on