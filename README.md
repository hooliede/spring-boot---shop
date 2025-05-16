# 🛒 전자기기 쇼핑몰 웹 프로젝트

> **Spring Boot + AWS EC2 배포 + JSP 기반의 전자기기 쇼핑몰**  
> 실무형 웹 서비스를 목표로 기획하고 개발한 팀 프로젝트입니다.

---

## 🔗 배포 링크

[👉 EC2에서 실행 중인 프로젝트 바로가기](http://54.253.237.37:8080/)

---

## 📌 프로젝트 개요

| 항목 | 내용 |
|------|------|
| 프로젝트명 | 전자기기 쇼핑몰 시스템 |
| 개발 기간 | 2025.02.11 ~ 2025.03.18 |
| 참여 인원 | 4명 |
| 주요 역할 | 관리자 기능, 장바구니, 주문/결제, 게시판 개발 및 배포 전반 |

---

## 🛠 사용 기술 스택

| 분야 | 기술 |
|------|------|
| **Backend** | Java 11, Spring Boot, Spring Security, JPA, MyBatis |
| **Frontend** | JSP, HTML, CSS3, jQuery |
| **Database** | MySQL, HeidiSQL |
| **DevOps** | AWS EC2, Git, GitHub |
| **ETC** | Adobe Photoshop (배너 디자인), CSV 데이터 수집 |

---

## 🧩 주요 기능

- 🔐 **회원 기능**: 회원가입, 로그인, 마이페이지, 비밀번호 변경
- 🛍️ **상품 기능**: 카테고리별 상품 조회, 상세 보기, 장바구니 담기
- 💳 **주문/결제 기능**: 주문서 작성, 결제 완료 처리
- 🧑‍💼 **관리자 기능**: 상품 등록/수정/삭제, 사용자 관리, 주문 목록 관리
- 📝 **게시판 기능**: 공지사항 등록, 댓글 달기, 게시글 상세 보기

---

## 🖼️ 화면 미리보기

> *(이미지 예시는 `static/img/` 경로에 업로드된 배너나 제품 이미지 기준)*

| 메인 화면 | 카테고리별 상품 |
|-----------|----------------|
| ![main](https://user-images.githubusercontent.com/your_image_1.jpg) | ![category](https://user-images.githubusercontent.com/your_image_2.jpg) |

---

## 🗂 프로젝트 구조 일부
src
   main
       java.com.example.sp
       resources
       webapp.WEB-INF.views
   build.gradle
   settings.gradel

## 🧠 개발 중 어려웠던 점과 해결 과정

- **문제**: AWS EC2에서 이미지가 로드되지 않음  
  **해결**: EC2에 `/home/ubuntu/sp-images/` 경로 설정 후 `WebConfig.java`에서 매핑
- **문제**: 상품 속성이 카테고리별로 다름 → DB 설계 어려움  
  **해결**: 속성 테이블과 조인 테이블 분리 설계 + 카테고리 속성 다형성 적용

---

## 📌 실행 방법 (로컬)

```bash
git clone https://github.com/taehun927/shoppingmall.git
cd shoppingmall
./gradlew bootRun
