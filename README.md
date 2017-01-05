# haproxy concourse pipeline

## a concourse pipeline which wrape omg-cli/haproxy-plugin & oss bosh release
## for haproxy

- https://github.com/enaml-ops/haproxy-plugin
- https://github.com/enaml-ops/omg-cli
- https://bosh.io/d/github.com/cloudfoundry-community/haproxy-boshrelease?v=8.0.9

### Using this pipeline

```
# clone this repo
$ git clone git@github.com:c0-ops/haproxy-concourse.git

# move into the dir
$ cd haproxy-concourse

# setup your pipeline vars and imput your desired values
$ cp pipeline-vars-template.yml pipeline-vars.yml
$ vim pipeline-vars.yml

# using the concourse fly client push up your pipeline
$ fly -t my-concourse set-pipeline -p deploy-haproxy -c ci/pivotal-haproxy-service-pipeline.yml -l pipeline-vars.yml

```
