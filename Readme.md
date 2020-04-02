# lib_pipeline

A python package which wraps the aws cli, docker, and terraform commands.

## Usage

1. Run `pip install git+https://gitlab.com/sharebuilder401k/lib-pipeline`
2. Import the package using `from lib_pipeline.terraforn import Terraform`
3. Initialize the class with `terraform = Terraform()`
4. Call `terraform.deploy(bucket, region, environment)` to deploy infrastructure to AWS
