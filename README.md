# 🛒 전자기기 쇼핑몰 웹 프로젝트

> **Spring Boot + AWS EC2 배포 + JSP 기반의 전자기기 쇼핑몰**  
> 실무형 웹 서비스를 목표로 기획하고 개발한 팀 프로젝트입니다.

---

## 🔗 배포 링크

[👉 EC2에서 실행 중인 프로젝트 바로가기](http://54.253.237.37:8080/)
(현재 연결은 끊겨있습니다.)
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
| **Web/Was** | Apache Tomcat 10 |
| **Language** | Java(JDK21), JavaScript, HTML, CSS  |
| **Database** | MySQL |
| **Framework/Libraries** | Spring Boot, Spring MVC, Spring Security, JPA, JSP, jQuery |
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
```
src
 └── main
      ├── java
      │     └── com.example.sp
      ├── resources
      └── webapp
            └── WEB-INF
                  └── views
build.gradle
settings.gradle
```


## ⚠️ 개발 중 어려웠던 점 및 해결 과정 (로그인 보안 강화)

### 문제 및 원인 (Problem & Root Cause)
* **문제**: 회원가입 시 암호화된 비밀번호가 DB에 저장되지만, 이후 로그인 검증 시도 시 사용자가 입력한 평문 비밀번호와 DB의 암호화된 비밀번호를 **단순 문자열 비교**하여 항상 인증에 실패했습니다.
* **원인**: 인증 로직이 암호화 로직의 원리를 고려하지 않았습니다. 암호화된 문자열은 동일한 평문으로 생성해도 솔트(Salt) 등의 이유로 매번 다른 값이 나오기 때문에, 평문 비교는 불가능했습니다.

### 해결 및 교훈 (Solution & Lesson Learned)
* **해결**: Spring Security의 **`PasswordEncoder`** 인터페이스를 도입하여 안전한 비밀번호 검증 방식을 적용했습니다.
    * **적용 메서드**: `PasswordEncoder.matches(rawPassword, encodedPassword)`
    * **원리**: 입력된 평문 비밀번호와 DB에 저장된 암호화된 비밀번호를 인수로 받아, 내부적으로 평문 비밀번호를 DB의 암호화 방식과 동일하게 처리하여 안전하게 비교하도록 로직을 수정했습니다.
* **교훈**: 인증 시스템의 기능 오류를 해결하고, 안전하고 표준화된 방식으로 비밀번호 검증을 구현하여 보안 수준을 향상시켰습니다. 이 경험을 통해 암호화 및 해싱 원리를 깊이 이해하고, Spring Security의 인증 처리 원칙을 준수하는 **보안 표준 코드 작성의 중요성**을 체득했습니다.

---

## 📌 실행 방법 (로컬)

```bash
git clone https://github.com/taehun927/shoppingmall.git
cd shoppingmall
./gradlew bootRun
