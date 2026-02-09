# Gemini Project Overview

This project, "VMware-Infra-Disaster-Recovery," focuses on establishing a multi-OS environment based on VMware. It emphasizes data integrity through hardware-level data preservation strategies (RAID) and the design of a secure, isolated networking environment.

## 🚀 Key Achievements (as per README.md)

-   **Reduced Recovery Time Objective (RTO) by 90%** (from 30 minutes to within 3 minutes) during system failures.
-   Maximized service availability through the implementation of snapshot and RAID-based recovery processes.

## 🛠 Technologies and Environment

-   **Virtualization:** VMware Workstation
-   **Operating Systems:** Linux (Ubuntu/CentOS), Windows Server
-   **Storage Management:** `mdadm` (Software RAID 1, 5, 1+0)
-   **Networking:** VMnet8 (NAT Mode) for security isolation and gateway design.

## 📋 Core Design Principles

### 1. RAID Design for Data Integrity

The project applies three RAID levels to counter disk failures, tailored to service characteristics:
-   **RAID 1 (Mirroring):** Protects system OS and critical configuration files.
-   **RAID 5 (Striping with Parity):** Ensures availability and storage efficiency for large-capacity data.
-   **RAID 10 (Performance & Fault Tolerance):** Addresses high I/O requirements for database environments.

### 2. Security Isolation and Network Design

-   Utilizes **VMnet8 (NAT)** to block direct external network connections, establishing a secure, isolated environment within the virtual network.
-   Optimizes communication between virtual machines through internal subnet configurations.

### 3. Disaster Recovery Process

-   **Snapshot Management:** Establishes regular snapshot points before and after service updates.
-   **RAID Recovery Testing:** Conducts practical recovery exercises using `mdadm` (fail/remove/add) under simulated disk failure scenarios.

## 📂 Project Structure & Usage

### Scripts

The `bash.sh` script provides automation for configuring various RAID levels.

To set up RAID configurations:

1.  Allocate additional virtual disks (vmdk) within VMware.
2.  Execute `bash.sh` to configure the desired RAID levels.
    *   **Note:** The script assumes specific device names (e.g., `/dev/sdb1`). These paths **must be adjusted** to match your environment.
    ```bash
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
    ```
3.  Verify the synchronization status using `cat /proc/mdstat`.
4.  It is recommended to register the RAID configurations in `/etc/fstab` for persistent mounting.

### Documentation

The `README.md` suggests the presence of a `/docs` directory containing network diagrams and detailed RAID design documents, although it was not found in the current directory listing.

## Development Conventions

-   The project heavily utilizes `mdadm` for software RAID configurations.
-   Bash scripting is used for automating infrastructure setup tasks.
-   For persistent mounting of RAID arrays, manual modification of `/etc/fstab` is recommended after initial setup.
