// aws generic vars
AWS_REGION = "{{cookiecutter.aws_region}}"

// single instance vars
iam_instance_profile = "{{cookiecutter.iam_instance_profile}}"
network_name = "{{cookiecutter.network_name}}"
private_key_path = "{{cookiecutter.ssh_key_name}}"
public_key_path = "{{cookiecutter.ssh_key_name}}.pub"
create_sg = {{cookiecutter.create_sg}}
create = {{cookiecutter.create}}
create_ebs_volume = {{cookiecutter.create_ebs_volume}}
domain_name = "{{cookiecutter.domain_main}}"
hostname = ""

