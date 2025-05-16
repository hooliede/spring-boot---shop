<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전자제품 구매 가이드 안내</title>

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
   <h2>전자제품 구매 가이드 안내</h2>
   <div class="post-info">
      <span>작성자: 관리자</span>
      <span>작성일: 2025-01-06</span>
      <span>조회수: 100</span>
   </div>
   <div class="post-content">
      📢 전자제품 구매 가이드 안내<br>   
        안녕하세요, 고객님! 😊<br>
        전자제품을 구매하시기 전 알아두시면 좋은 정보를 모아 가이드를 준비했습니다.<br>
        고객님께서 최적의 제품을 선택하시고 후회 없는 쇼핑 경험을 하실 수 있도록 아래 내용을 참고해 주세요.<br><br>
        💡 전자제품 구매 전 확인해야 할 사항<br>
        1.사용 목적과 필요 기능 정리<br>
        <span class="indent">• 전자제품의 사용 목적과 필요한 기능을 미리 정리해 보세요.</span>
        <span class="indent">• 예: TV를 구매한다면 화면 크기, 해상도, 스마트 기능 여부 등을 고려하세요.</span>
        2.예산 설정<br>
        <span class="indent">• 구매 가능한 가격대를 정해두면 선택지가 줄어들어 더욱 효율적입니다.</span>
        <span class="indent">• 추가 비용(배송비, 설치비 등)을 염두에 두세요.</span>
        3.제품 사양 비교<br>
        <span class="indent">• 브랜드별, 모델별로 제공되는 사양(성능, 에너지 효율 등)을 비교해 보세요.</span>
        <span class="indent">• 예: 냉장고를 구매할 경우 용량과 에너지 등급을 확인하세요.</span><br>
        🛠️ 구매 후 꼭 확인하세요<br>
        1.배송 및 설치 상태 점검<br>
        2.보증 및 A/S 정보 확인<br>
        3.사용 설명서 읽기<br><br>
        📞 문의<br>
        고객님의 구매 결정을 돕기 위해 상세 상담을 지원합니다 구매와 관련하여 궁금한 점이 있으시면 고객센터로 문의해 주세요.<br>
        • 고객센터: 1234-1148<br>
        • 이메일: byunghoon@naver.com<br><br><br><br>
        전자제품 구매는 오랜 시간 함께할 중요한 선택입니다.<br>
        저희 쇼핑몰에서 제공하는 다양한 가이드를 통해 자신에게 딱 맞는 제품을 찾으시길 바랍니다!<br>
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
