<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>[공지] 설 연휴 배송 및 고객센터 운영 안내</title>

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
      안녕하세요, 병훈전자 고객 여러분.<br>
      설 명절을 맞아 배송 일정 및 고객센터 운영 시간을 안내드립니다 원활한 쇼핑과 배송을 위해 아래 내용을 꼭 참고해 주세요. <br><br>      
      • 설 연휴 배송 일정<br>
      주문 마감: 2025년 1월 18일(토) 오후 3시<br>
      1월 18일 오후 3시 이전 주문 건은 연휴 전에 배송됩니다. 이후 주문 건은 **1월 25일(토)**부터 순차적으로 발송됩니다.<br>
      2025년 1월 19일(일) ~ 1월 24일(금) 기간 배송은 일시 중단입니다.<br><br>
      • 고객센터 운영 안내<br>
      정상 운영: 2025년 1월 18일(토)까지<br>
      휴무 기간: 2025년 1월 19일(일) ~ 1월 24일(금)<br>
      연휴 기간 중 남겨주신 문의는 **1월 25일(토)**부터 순차적으로 답변드리겠습니다.<br><br>
      항상 저희 쇼핑몰을 이용해 주시는 고객님께 진심으로 감사드리며, 행복하고 따뜻한 설 명절 보내시길 바랍니다.<br>
     감사합니다!<br><br>
     [고객센터]<br>
     • 이메일: byunghoon@naver.com<br>
     • 전화: 1234-1148<br><br><br><br>
     항상 저희 쇼핑몰을 이용해 주시는 고객님께 감사드리며, 더욱 안정적이고 편리한 서비스를 제공하기 위해 최선을 다하겠습니다.<br>
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
