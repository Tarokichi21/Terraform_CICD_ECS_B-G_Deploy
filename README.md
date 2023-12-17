### CI/CD for Amazon ECS(BlueGreenDeploy)

ECSへの自動B/Gデプロイするプラットフォームを構築するコードです

参考サイト

[①ECS Blue/GreenデプロイメントのCI/CDパイプライン構築 by Terraform](https://qiita.com/tomokon/items/eea60082e3210a2cf6b6/)

[②TerraformでECS FargateのBlue/Greenデプロイを構築する](https://qiita.com/ys1/items/c6ee6a0d8474a7dfdd49/)

[③AWS CI/CD for Amazon ECSハンズオン](https://pages.awscloud.com/rs/112-TZM-766/images/AWS_CICD_ECS_Handson.pdf)

## 事前準備
### /env/main.tfのaccount_idをご自身のアカウントIDに変更してください

```
locals{
  account_id   = "xxxxxxx"←この部分
}
```

 ### .tfstate用s３作成
```
aws s3 mb s3://ecscicd0001
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
### RemoteSSHで接続しているEC2でAWS　CLI設定
```
aws configure
```

### RemoteSSHで接続しているEC2でDockerImageをECRにPushする手順
```
cd sample
docker build -t ecscicd-dev-ecr-repository .
docker images
aws ecr get-login-password | docker login --username AWS --password-stdin https://<aws_account_id>.dkr.ecr.<region>.amazonaws.com
docker tag ecscicd-dev-ecr-repository:latest <aws_account_id>.dkr.ecr.<region>.amazonaws.com/ecscicd-dev-ecr-repository:latest
docker push <aws_account_id>.dkr.ecr.<region>.amazonaws.com/ecscicd-dev-ecr-repository:latest
```

### RemoteSSHで接続しているEC2でCodeCommitへのpush
### AWS CodeCommit の HTTPS Git 認証情報を事前に生成しておく必要があります
```
cd sample
git init
git remote add origin https://git-codecommit.ap-northeast-1.amazonaws.com/v1/repos/ecscicd-dev-repository
git add .
git commit -m "initial commit"
git push origin master
```

### (補足)コンフリクトが起きたら以下コマンドを実施する
```
git config pull.rebase true
```

