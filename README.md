# VMware-Infra-Disaster-Recovery

VMware 기반의 멀티 OS 환경을 구축하고, 데이터 무결성을 보장하기 위한 하드웨어 레벨의 데이터 보존 전략(RAID) 및 보안 격리 환경을 설계한 프로젝트입니다.

## 🚀 주요 성과
- **시스템 장애 시 복구 목표 시간(RTO) 90% 단축** (30분 → 3분 이내)
- 스냅숏 및 RAID 기반의 복구 프로세스 수립을 통한 서비스 가동률 극대화

## 🛠 사용 기술 및 환경
- **Virtualization:** VMware Workstation
- **OS:** Linux (Ubuntu/CentOS), Windows Server
- **Storage:** mdadm (Software RAID 1, 5, 1+0)
- **Network:** VMnet8 (NAT Mode) 보안 격리 및 게이트웨이 설계

## 📋 핵심 설계 내용

### 1. 데이터 무결성을 위한 RAID 설계
서비스의 특성에 맞춰 세 가지 RAID 레벨을 적용하여 디스크 결함에 대비했습니다.
- **RAID 1:** 시스템 OS 및 핵심 설정 파일 보호 (Mirroring)
- **RAID 5:** 대용량 데이터의 가용성과 저장 효율성 확보 (Parity)
- **RAID 10:** 고성능 I/O가 필요한 데이터베이스 환경 대응

### 2. 보안 격리 및 네트워크 설계
- **VMnet8 (NAT)** 설계를 통해 외부 망과의 직접적인 연결을 차단하고, 가상 네트워크 내에서 보안 격리 환경을 구축했습니다.
- 내부 서브넷 구성을 통한 가상 머신 간 통신 최적화

### 3. 장애 대응 프로세스
- **Snapshot 관리:** 서비스 업데이트 전후 정기적인 스냅숏 지점 수립
- **RAID 복구 테스트:** 디스크 장애 발생 시나리오를 가정한 `mdadm` fail/remove/add 복구 실습 수행

## 📂 파일 구조
- `/scripts`: RAID 구성 및 모니터링 자동화 스크립트
- `/docs`: 네트워크 구성도 및 RAID 상세 설계 문서

## 🖥 실습 방법
1. VMware에서 추가 가상 디스크(vmdk)를 할당합니다.
2. `scripts/raid_setup.sh`를 실행하여 원하는 레벨의 RAID를 구성합니다.
3. `cat /proc/mdstat` 명령어로 동기화 상태를 확인합니다.
