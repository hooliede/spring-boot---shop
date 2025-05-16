<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>[공지] 사칭 문자 사기에 주의하세요!</title>

<style>
   /* 기본 스타일 */
   body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f3f3f3;
      color: #333;
      height: 100%;
   }

   .header-container {
      width: 100%;
      display: flex;
      justify-content: space-between;
      align-items: center;
      height: 70px;
      padding: 0 20px;
      background-color: #ffffff;
      border-bottom: 1px solid #ddd;
      box-sizing: border-box;
   }

   .logo {
      font-size: 24px;
      font-weight: bold;
      color: #0078ff;
   }

   .logo a {
      text-decoration: none;
      color: inherit;
   }

   .nav-links {
      display: flex;
      gap: 10px;
   }

   .nav-links a {
      text-decoration: none;
      color: #333;
      font-size: 16px;
      font-weight: bold;
   }

   .nav-links a:hover {
      color: #0078ff;
   }

   .main-container {
      width: 100%;
      max-width: 1600px; /* 중앙 컨테이너 너비 확장 */
      margin: 20px auto;
      padding: 30px 5%; /* 좌우 여백을 줄여 공간을 확보 */
      background-color: #fff;
      box-sizing: border-box;
      border: 1px solid #ddd;
      border-radius: 5px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
      min-height: calc(100vh - 120px); /* 헤더를 제외한 화면 전체 높이 */
      overflow: hidden;
   }

   h2 {
      margin-top: 0;
      font-size: 28px;
      color: #333;
      border-bottom: 2px solid #0078ff; /* 검은 계열의 색으로 설정 */
      padding-bottom: 10px;
      white-space: nowrap; /* 텍스트를 한 줄로 표시 */
      overflow: hidden;
   }

   .post-info {
      margin-bottom: 20px;
   }

   .post-info span {
      display: inline-block;
      margin-right: 20px;
      font-size: 14px;
      color: #666;
   }

   .post-content {
      margin-bottom: 20px;
      font-size: 16px;
      line-height: 1.6;
      background-color: #f9f9f9;
      padding: 20px;
      border-radius: 5px;
      border: 1px solid #ddd;
      white-space: nowrap; /* 텍스트를 한 줄로 표시 */
      overflow: hidden;
   }
   .indent {
       display: block;
       text-indent: 10px; /* 들여쓰기 공간 설정 */
   }

   .action-bar {
      display: flex;
      justify-content: flex-end;
      gap: 10px;
      margin-top: 20px;
   }

   .action-bar a {
      display: inline-block;
      padding: 10px 20px;
      background-color: #007bff;
      color: white;
      text-decoration: none;
      font-size: 16px;
      border-radius: 5px;
      text-align: center;
   }

   .action-bar a:hover {
      background-color: #0056b3;
   }

   .action-bar .delete-btn {
      background-color: #dc3545;
   }

   .action-bar .delete-btn:hover {
      background-color: #a71d2a;
   }
</style>
</head>
<body>
<!-- 상단 헤더 -->
<header class="header-container">
   <div class="logo">
      <a href="../../shop/test_main/test_main1.jsp">병훈전자</a>
   </div>
   <div class="nav-links">
      <a href="../../shop/user/logout.jsp">로그아웃</a>
      <span>|</span>
      <a href="../../shop/cart1.jsp">마이페이지</a>
      <span>|</span>
      <a href="../../shop/test_main/ordered.jsp">장바구니</a>
   </div>
</header>

<!-- 메인 컨텐츠 -->
<div class="main-container">
   <h2>[공지] 설 연휴 배송 및 고객센터 운영 안내</h2>
   <div class="post-info">
      <span>작성자: 관리자</span>
      <span>작성일: 2025-01-06</span>
      <span>조회수: 100</span>
   </div>
   <div class="post-content">
      📢 사칭 문자 사기에 주의하세요!<br>
      최근 저희 쇼핑몰을 사칭한 문자 메시지나 이메일로 인한 사기 피해 사례가 발생하고 있어 안내드립니다.<br>
      고객님의 소중한 개인정보와 안전한 쇼핑 환경을 위해 아래 내용을 반드시 숙지하시기 바랍니다.<br><br>
      ❗  사칭 문자 및 이메일 특징<br>
      1.가짜 링크 포함<br>
      <span class="indent">• "배송 조회", "결제 오류", "쿠폰 발급" 등의 명목으로 클릭을 유도하는 URL 포함.(예: http://fake-link-example.com)</span>
      2.금전 요구<br>
      <span class="indent">• 소액 결제, 추가 비용 요청 등 금전 거래를 요구하는 내용.</span>
      3.개인정보 요구<br>
      <span class="indent"> • 주민등록번호, 계좌번호, 카드 정보 등을 입력하라는 요청.</span><br>
      ✅ 안전한 쇼핑을 위한 수칙<br>
      1.URL 확인하기<br>
      <span class="indent">• 도메인이 있다면 누르지 마세요!</span>
      2.개인정보 제공 금지<br>
      <span class="indent">• 병훈전자는 절대 문자, 이메일로 개인 정보나 결제 정보를 요청하지 않습니다.</span>
      3.의심스러운 경우 즉시 문의<br>
      <span class="indent">• 출처가 불분명하거나 의심스러운 메시지를 받으셨다면 바로 저희 고객센터로 연락해 주세요.</span><br>
      📞 문의 및 신고<br>          
     • 고객센터: 1234-1148<br>
     • 이메일: byunghoon@naver.com<br>
     • 신고: 사칭 문자 또는 이메일을 받은 경우 캡처 화면과 함께 고객센터로 신고해 주세요.<br><br><br><br>
     고객님의 신뢰와 안전한 쇼핑 경험을 위해 최선을 다하겠습니다. 항상 저희 쇼핑몰을 이용해 주셔서 감사합니다. 😊<br>
     병훈전자 드림     
   </div>

   <!-- 버튼 영역 -->
   <div class="action-bar">
      <%-- 작성자 확인 로직 --%>
      <%
         String loggedInUser = (String) session.getAttribute("username");
         String postAuthor = "관리자"; // 게시글 작성자 (예제용)

         if ("관리자".equals(loggedInUser)) { // 관리자일 경우에만 버튼 표시
      %>
         <a href="edit.jsp?id=1" class="edit-btn">수정</a>
         <a href="delete.jsp?id=1" class="delete-btn">삭제</a>
      <% } %>
      <a href="gaesipan.jsp" class="back-btn">목록</a>
   </div>
</div>
</body>
</html>
