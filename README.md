# Terraform Handson
1년전부터 테라폼의 매력을 느껴 항상 해봐야지 하면서, 간단히 이해만 하고 실무에서는 아직 사용할 일이 없어 거의 손놓고 있었다.
2020년 5월 7일, DevOps 송주영님의 온라인 테라폼 강의를 듣고나서 다시 한번 시작해보자는 마음을 먹게 되어 이렇게 문서로 정리하게 되었다. 서울에서 근무할 당시, 시간날때마다 송주영님의 강의를 찾아 다녔었는데, 개인적으로 기술을 바라보는 그분의 철학을 존경하고 나의 롤모델이다.
핸즈온으로 사용한 코드 또한 송주영님의 [github: aws-provisioning](https://github.com/jupitersong/aws-provisioning)에서 많이 참고했다.

### 1. Terraform 도커 컨테이너에서 실행
- [도커파일](Dockerfile) 작성 및 이미지 생성
```
$ docker build -t haeyoon/terraform:latest
```
** HashiCorp에서 제공하는 공식 [Terraform 도커이미지](https://hub.docker.com/r/hashicorp/terraform/)를 사용해도 된다

- 컨테이너 접속 및 테라폼으로 인프라 구성
```
$ docker run -it -d \
    -v $(pwd):/home/terraform/ \
    --name tfserver \
    haeyoon/terraform:latest

$ docker exec -it tfserver /bin/bash
```
** attach로 접속하거나 exec명령어로 컨테이너 안에서 명령어를 실행하게도 할 수 있다.

---

### 2. Terraform

Terraform은 Infrastructure as Code(IAC)를 기반으로 HashiCorp에서 제공하는 도구이다. 먼저, IAC를 이해해보자.

##### IAC란?
- AWS를 예를 들면, 콘솔과 같은 사용자 인터페이스에서 수동으로 구성 및 관리하는 프로세스와 인프라 구성값들을 지정된 파일형식에 맞춰 코드화하고 작성된 파일들로 특정 도구를 통해 인프라가 생성, 변경 및 관리되도록 한 개념으로서, 리소스들은 주어진 환경의 인프라, 즉 가상머신, 보안그룹, 네트워크 인터페이스 등이 포함된다.


- __IAC의 장점__
( *일부 영어번역은 직역이 아닌, 내 생각을 녹여서 번역을 했다 )
    - __easily repeatable ( 반복가능한 코드 )__
    - __easily readable ( 가독 및 쉬운 이해 )__
    - __operational certainty with "terraform plan" ( terraform plan을 통해 예측가능한 운영확실성 )__
    - __standardized environment builds ( 표준화된 환경 구축 )__
    - __quickly provisioned development environment ( 신속하게 프로비저닝되는 인프라 환경 )__
    - __disaster recovery ( 재해 발생시 빠른 복구 가능 )__

    DevOps 도구들을 사용하다보면, 인프라에 대한 인식이 변화되면서 인프라 장애시 오류를 찾아 고치는 것이 아니라, 필요할 땐 쓰고 바로 버리는 추세와 Immutable infrastructure의 철학을 가진 개념이 많이 녹아있는데, IAC 또한 그러하다는 시각으로 바라보고 있다.

##### Terraform이란?

- HashiCorp에서는 Terraform을 안전하고 반복가능한 방식으로 인프라를 구축, 변경 및 관리하기 위한 도구로 정의하고 있으며, aws CloudFormation와 함께 대표적인 IAC도구로 사용되고 있다.
Terraform은 providers의 인프라나 서비스(리소스)들을 코드로 관리할 수 있도록 하므로 providers로 정의된 aws, gcp, azure, github, docker etc가 있다.

HashiCorp에서 정의한 Terraform 장점은 다음과 같다.
- __Terraform 장점__
    - __Platform Agnostic ( 하나의 플랫폼에만 구애받지 않고 여러 플랫폼에서 동일하게 실행이 가능 )__
    - __State management ( State file로 인프라 상태를 비교 및 확인하여 관리 )__
    - __Operator confidence ( terraform apply할 때, 사용자 또는 운영자는 변경/추가 사항을 미리 검토하고 실행할 수 있으므로 안정적, 신뢰성의 특징을 가지며 검토단계에서 오류가 있으면, 제안된 plan을 적용하지 않을 수도 있다 )__

- HCL ( HashiCorp Configuration Language )
    HCL은 HashiCorp의 제품에서 사용,인간과 기계 모두에게 친숙하게 느껴질 수 있도록 작성되었으며 JSON과 호환되므로 Terraform과 다른시스템의 호환이 가능하다.
    ( * HCL에 대해서는 추후 재 정리할 예정 )

테라폼에서 일부 중요한 용어들을 살펴보자. HashiCorp의 [Terraform Glossary](https://www.terraform.io/docs/glossary.html#policy)페이지에 간략한 설명과 함께 해당 용어 문서로 링크가 되어 있다.

- Providers
    HashiCorp는 Providers를 테라폼과 API 상호작용을 통해 리소스를 제공하는 플러그인으로 정의하고 있다. 즉, 특정 인프라 제공자의 리소스 생성 및 관리를 위해 응답가능한 서비스들을 의미하며, 해당 제공자와 Terraform은 API를 통한 상호작용을 한다. 단일 provider뿐 아니라 복수 providers ( Multi providers ) 제공도 가능한데 예를 들면, AWS EC2 인스턴스 ID를 DataDog 모니터링 값으로 전달할 수 있다.
    [Providers 문서](https://www.terraform.io/docs/providers/index.html)를 보면, Providers로써 사용가능한 서비스 목록을 확인가능하다.

- Resources
    리소스 블록은 인프라를 정의한다. 블록이 뭘까? HashiCorp 공식문서를 읽어보면 리소스는 하나이상의 인프라 객체들을 명시한 블록이라고 했는데 아래의 VPC 블록과 같이 이해하면 된다.
    ```
    # vpc
    resource "aws_vpc" "default" {
      cidr_block       = "10.0.0.0/16"
      instance_tenancy = "default"

      tags = {
        Name = "vpc-${var.vpc_name}"
      }
    }
    ```
    2가지 요소로 정의가 가능한데 EC2 인스턴스와 같은 물리적 요소 또는 Heroku Application과 같은 논리적 요소가 포함된다.
    리소스 블록에는 2가지 문자열; 자원유형( Resource Type )과 자원이름( Resource Name )로 생성, 수정 및 관리할 리소스를 정의할 수 있다.
    리소스에 대한 인자( Argument )는 블록 내에 저장된다. 머신 크기, 이미지 종류, VPC ID와 같이 리소스 구성을 명시할 수 있다.

- Modules

- Input variables

- Interpolation

---

참고
[inctoduction to HCL](https://www.linode.com/docs/applications/configuration-management/introduction-to-hcl/#:~:text=HCL%20is%20a%20configuration%20language,both%20human%20and%20machine%20friendly)
[terraform practice](https://learn.hashicorp.com/terraform?track=getting-started#getting-started)
