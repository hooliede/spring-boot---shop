<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>RTX 5000 시리즈 판매 안내</title>

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
   <h2>RTX 5000 시리즈 판매 안내</h2>
   <div class="post-info">
      <span>작성자: 관리자</span>
      <span>작성일: 2025-01-06</span>
      <span>조회수: 100</span>
   </div>
   <div class="post-content">
      📢 RTX 5000 시리즈 판매 관련 안내<br>
      안녕하세요, 고객님. 😊<br>
      최근 출시된 RTX 5000 시리즈 그래픽 카드에 대한 많은 관심과 문의를 주셔서 감사드립니다.<br>
      현재 저희 홈쇼핑에서는 RTX 5000 시리즈 제품의 판매 계획이 없습니다.<br><br>
      ❓ 왜 판매하지 않나요?<br>
      1.유통 계약 미체결<br>
      <span class="indent">• 저희 홈쇼핑은 고객님께 믿을 수 있는 상품만을 제공하기 위해 공식 유통 계약이 체결된 제품만을 취급하고 있습니다.</span>
      2.제품 안정성 확인 중<br>
      <span class="indent">• 출시 초기 제품 특성상 안정성과 고객 만족도를 검토하고 있으며, 향후 판매 여부를 신중히 결정할 예정입니다.</span><br>
      📞 문의사항이 있으신가요?<br>
      • 고객센터: 1234-1148<br>
        • 이메일: byunghoon@naver.com<br><br><br><br>
        앞으로도 더 다양한 상품과 서비스를 제공하기 위해 최선을 다하겠습니다. 지속적인 관심과 성원 부탁드립니다.<br>
        감사합니다. 😊<br>
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
