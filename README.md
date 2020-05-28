# Terraform Handson

---

#### 1. Terraform 도커 컨테이너에서 실행
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
** attach로 접속하거나 exec명령어로 컨테이너 안에서 인자로 주어진 명령어가 실행하게 하는 등 편한대로 하면 될 것 같다.

---

#### 2. Terraform

Terraform은 Infrastructure as Code(IAC)를 기반으로 HashiCorp에서 제공하는 IAC 도구이다. 먼저, IAC를 이해해보자.

##### IAC란?
- AWS를 예를 들면, 콘솔과 같은 사용자 인터페이스에서 수동으로 구성 및 관리하는 프로세스와 인프라 구성값들을 지정된 파일형식에 맞춰 코드화하고 작성된 파일들로 특정 도구를 통해 인프라가 생성, 변경 및 관리되도록 한 개념으로서, 리소스들은 주어진 환경의 인프라, 즉 가상머신, 보안그룹, 네트워크 인터페이스 등이 포함된다.

- IAC의 장점
    ** 영어번역을 바로하지 않고, 내생각을 녹여 번역했다
    - easily repeatable ( 반복가능한 코드 )
    - easily readable ( 가독 및 쉬운 이해 )
    - operational certainty with "terraform plan" ( terraform plan을 통해 예측가능한 운영확실성 )
    - standardized environment builds ( 표준화된 환경 구축 )
    - quickly provisioned development environment ( 신속하게 프로비저닝되는 인프라 환경 )
    - disaster recovery ( 재해 발생시 빠른 복구 가능 )

    DevOps 도구들을 사용하다보면, 인프라에 대한 인식이 변화되면서 인프라 장애시 오류를 찾아 고치는 것이 아니라, 필요할 땐 쓰고 바로 버리는 추세와 Immutable infrastructure의 철학을 가진 개념이 많이 녹아있는데, IAC 또한 그러하다는 시각으로 바라보고 있다.

##### Terraform이란?

- HashiCorp에서는 Terraform을 안전하고 반복가능한 방식으로 인프라를 구축, 변경 및 관리하기 위한 도구로 정의하고 있으며, aws CloudFormation와 함께 대표적인 IAC도구로 사용되고 있다.
Terraform은 providers의 인프라나 서비스(리소스)들을 코드로 관리할 수 있도록 하므로 providers로 정의된 aws, gcp, azure, github, docker etc가 있다.

HashiCorp에서 정의한 Terraform 장점은 다음과 같다.
- Terraform 장점
    - Platform Agnostic ( 하나의 플랫폼에만 구애받지 않고 여러 플랫폼에서 동일하게 실행이 가능 )
    - State management ( State file로 인프라 상태를 비교 및 확인하여 관리 )
    - Operator confidence ( terraform apply할 때, 사용자 또는 운영자는 변경/추가 사항을 미리 검토하고 실행할 수 있으므로 안정적, 신뢰성의 특징을 가지며 검토단계에서 오류가 있으면, 제안된 plan을 적용하지 않을 수도 있다 )

- HCL ( HashiCorp Configuration Language )
    HCL은 HashiCorp의 iac 도구에 사용된다. 인간과 기계 모두에게 친숙하게 느껴질 수 있도록 작성되었으며 JSON과 호환되므로 Terraform과 다른시스템의 호환이 가능하다.
    ( * HCL에 대해서는 추후 재 정리할 예정 )


테라폼에서 일부 중요한 용어들을 살펴보자.

- Providers
    provider는 특정 인프라 제공자의 리소스 생성 및 관리를 위해 응답가능한 서비스들을 의미하며, 해당 제공자와 Terraform은 API를 통한 상호작용을 한다. 단일 provider뿐 아니라 복수 providers ( Multi providers ) 제공도 가능한데 예를 들면, AWS EC2 인스턴스 ID를 DataDog 모니터링 값으로 전달할 수 있다.

- Resources
    리소스 블록은 인프라를 정의한다. 2가지 요소로 정의가 가능한데 EC2 인스턴스와 같은 물리적 요소 또는 Heroku Application과 같은 논리적 요소가 포함된다.
    리소스 블록에는 2가지 문자열; 자원유형( Resource Type )과 자원이름( Resource Name )로 생성, 수정 및 관리할 리소스를 정의할 수 있다.
    리소스에 대한 인자( Argument )는 블록 내에 저장된다. 머신 크기, 이미지 종류, VPC ID와 같이 리소스 구성을 명시할 수 있다.

- Modules

- Input variables

- Interpolation

---

참고
[inctoduction to HCL](https://www.linode.com/docs/applications/configuration-management/introduction-to-hcl/#:~:text=HCL%20is%20a%20configuration%20language,both%20human%20and%20machine%20friendly)
[terraform practice](https://learn.hashicorp.com/terraform?track=getting-started#getting-started)
