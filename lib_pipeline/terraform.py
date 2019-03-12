import subprocess
from lib_pipeline.docker import Docker
from lib_pipeline.singleton import Singleton
from lib_pipeline.helpers import execute, remove_files


class Terraform(object):
    __metaclass__ = Singleton

    def __init__(self):
        self.docker = Docker()
        self.image = "hashicorp/terraform:light"
        self.docker_env_args = '-e "HOME=/home" -v $HOME/.aws:/home/.aws'

    def exec(self, command, options=None, cwd=None):
        options = " ".join(options)
        self.docker.run(
            self.image, command, options=options, cwd=cwd, env_args=self.docker_env_args
        )

    def init(self, bucket, env, region, cwd):
        backend_options = [
            f"""--backend-config="profile={env}" """,
            f"""--backend-config="region={region}" """,
            f"""--backend-config="bucket={self.bucket}" """,
        ]
        self.exec("init", options=backend_options, cwd=cwd)

    def plan(self, bucket, env, region, options, cwd=None):
        vars = [
            f"""--var-file="{env}/{region}.tfvars" """,
            f"""--var="profile={env}" {options} """,
        ]
        self.exec("plan", options=vars, cwd=cwd)

    def apply(self, bucket, env, region, options, cwd=None):
        vars = [
            f"""--var-file="{env}/{region}.tfvars" """,
            f"""--var="profile={env}" {options} """,
            "--auto-approve",
        ]

        self.exec("apply", options=vars, cwd=cwd)

    def deploy(self, bucket, profile, region, env, *args, cwd=None):
        options = " ".join(args)
        remove_files(".terraform", cwd=cwd)
        self.init(env, region, cwd=cwd)
        self.plan(env, region, options, cwd=cwd)
        self.apply(env, region, options, cwd=cwd)

    def taint(self, bucket, profile, region, env, *args, cwd=None):
        options = " ".join(args)
        self.init(env, region, cwd=cwd)
        self.plan(env, region, options, cwd=cwd)
        self.exec("taint", options=options, cwd=cwd)
