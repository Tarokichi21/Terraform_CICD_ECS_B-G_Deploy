### CI/CD for Amazon ECS(BlueGreenDeploy)

ECSへの自動B/Gデプロイプラットフォームを構築するコードです

参考サイト

[①ECS Blue/GreenデプロイメントのCI/CDパイプライン構築 by Terraform](https://qiita.com/tomokon/items/eea60082e3210a2cf6b6/)

[②TerraformでECS FargateのBlue/Greenデプロイを構築する](https://qiita.com/ys1/items/c6ee6a0d8474a7dfdd49/)

[③AWS CI/CD for Amazon ECSハンズオン](https://pages.awscloud.com/rs/112-TZM-766/images/AWS_CICD_ECS_Handson.pdf)


### .tfstate用s３作成
```
aws s3 mb s3://cicd-ecs0001
```

### Terraform基本コマンド
```
cd env
terraform init
terraform plan
terraform apply
terraform output
```

### RemoteSSHでEC2からDockerImageをpushする場合の環境構築
```
sudo su
yum update -y
yum install -y docker && yum install -y httpd && yum install git
systemctl start docker && systemctl start httpd
```
### AWS　CLI設定
```
aws configure
```

### DockerImageをECRにPushする手順
```
cd ../../
docker build -t cicd-ecs-dev-ecr-repositry .
docker images
aws ecr get-login-password | docker login --username AWS --password-stdin https://<aws_account_id>.dkr.ecr.<region>.amazonaws.com
docker tag cicd-ecs-dev-ecr-repositry:latest <aws_account_id>.dkr.ecr.<region>.amazonaws.com/cicd-ecs-dev-ecr-repositry:latest
docker push <aws_account_id>.dkr.ecr.<region>.amazonaws.com/cicd-ecs-dev-ecr-repositry:latest
```

### CodeCommitへのpush
### AWS CodeCommit の HTTPS Git 認証情報を事前に生成する
```
cd sample
git init
git remote add origin https://git-codecommit.ap-northeast-1.amazonaws.com/v1/repos/cicd-ecs-dev-repository
git add .
git commit -m "initial commit"
git push origin master
```

### (補足)コンフリクトが起きたら以下コマンドを実施する
```
git config pull.rebase true
```

