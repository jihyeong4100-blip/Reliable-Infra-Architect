#!/bin/bash

# 가상화 인프라 RAID 구성 자동화 스크립트
# 주의: 실제 디스크 경로(/dev/sdb 등)는 환경에 맞게 수정해야 합니다.

echo "--- RAID 구성 및 데이터 무결성 테스트 시작 ---"

# 1. RAID 1 구성 (Mirroring - 데이터 보호)
echo "RAID 1 구성을 시작합니다..."
sudo mdadm --create /dev/md1 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
sudo mkfs.ext4 /dev/md1
sudo mkdir -p /mnt/raid1
sudo mount /dev/md1 /mnt/raid1

# 2. RAID 5 구성 (Striping with Parity - 효율 및 복구)
echo "RAID 5 구성을 시작합니다..."
sudo mdadm --create /dev/md5 --level=5 --raid-devices=3 /dev/sdd1 /dev/sde1 /dev/sdf1
sudo mkfs.ext4 /dev/md5
sudo mkdir -p /mnt/raid5
sudo mount /dev/md5 /mnt/raid5

# 3. RAID 10 구성 (Performance & Fault Tolerance)
echo "RAID 10 구성을 시작합니다..."
sudo mdadm --create /dev/md10 --level=10 --raid-devices=4 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1
sudo mkfs.ext4 /dev/md10
sudo mkdir -p /mnt/raid10
sudo mount /dev/md10 /mnt/raid10

# 4. 구성 확인
cat /proc/mdstat
df -h | grep raid

echo "RAID 구성 완료. /etc/fstab에 등록하여 영구 마운트 설정을 권장합니다."
