<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>가전제품 쇼핑몰</title>


<link rel="stylesheet" type="text/css" href="/css/main/main.css">
<link rel="stylesheet" type="text/css" href="/css/board/board.css">
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

   .action-bar {
      display: flex;
      justify-content: flex-end;
      gap: 10px;
      margin-top: 20px;
   }

   .action-bar a, button {
      display: inline-block;
      padding: 10px 20px;
      background-color: #007bff;
      color: white;
      text-decoration: none;
      font-size: 16px;
      border-radius: 5px;
      text-align: center;
   }

   .action-bar a, button:hover {
      background-color: #0056b3;
   }

   .action-bar .delete-btn {
      background-color: #dc3545;
   }

   .action-bar .delete-btn:hover {
      background-color: #a71d2a;
   }
</style>
<script>
/* 댓글 등록 */
function submitReply() {
	const boardIdx = document.querySelector('input[name="boardIdx"]').value;
	const replyContent = document.getElementById("replyContent").value.trim();
	
	console.log("boardIdx = " +boardIdx);
	console.log("replyContent = "+replyContent);
	
	if(!replyContent) {
		alert("댓글을 입력해주세요.");
		return;
	}
	
	fetch("/reply/insert", {
		method: "POST",
		headers: {"Content-Type": "application/json"},
		body: JSON.stringify({boardIdx, replyContent}),
	})
	.then(response => response.json())
	.then(result => {
		if (result.success) {
			location.reload();
		} else {
			alert(result.message || "댓글 등록 실패!");
		}
	})
	.catch(error => {
		console.error("Error:", error);
		alert("서버 오류로 댓글 등록에 실패했습니다.");
	});
}
</script>
</head>
<body>
<!-- 상단 네비게이션 -->
<%@ include file="/WEB-INF/views/include/main/1_floor/header.jsp" %>
<div class="main-container">
   <div class="main-layout">
      <div id ="board-section" >
      	<div class="board-container">
      	<h2>${board.title}</h2>
      	
      	<div class="post-info">
      		<span>작성자: ${board.member.nickname}</span>
      		<span>작성일: ${board.formattedRegdate}</span>
      		<span>조회수: ${board.hit}</span>
   		</div>
   		
   		<div class="post-content">
      		<c:if test="${dto.attachList.size() > 0}">
            <div class="file-container">
                <h3>📎 첨부 파일</h3>
                <c:forEach items="${attachList}" var="attach">
                    <img src="/upload/display_file?file_name=${attach.fileName}" alt="${attach.fileName}" />
                </c:forEach>
            </div>
        	</c:if>
        	
        	${board.contents}
        	
   		</div>
   		
      </div>
      
   <!-- 버튼 영역 -->
   <div class="action-bar">
        <!-- 수정 버튼(본인만) -->
        <c:if test="${sessionScope.userid == board.member.userid}">
        	<button class="edit-btn" onclick="editBoard(${board.boardIdx})">✏️ 수정</button>
        </c:if>
        <!-- 삭제 버튼(본인+관리자) -->
        <c:if test="${sessionScope.userid == board.member.userid || sessionScope.level == 'ADMIN'}">
            <button class="delete-btn" onclick="deletePost(${board.boardIdx})">🗑️ 삭제</button>
        </c:if>
      	<a href="/board/listAll" class="back-btn">목록</a>
   </div>

   </div>
      
     	 <!-- 우측 광고 -->
		<div id="product-section">
		<%@ include file="/WEB-INF/views/include/main/2_floor/product.jsp" %>
   		</div>
   </div>
   
   <!-- ✅ 댓글 섹션 추가 -->
<div id="reply-section">
    <h2>💬 댓글</h2>
    
    <!-- ✅ 댓글 목록 -->
    <div class="reply-list">
        <c:choose>
            <c:when test="${empty replyList}">
                <p class="no-replies">아직 등록된 댓글이 없습니다.</p>
            </c:when>
            <c:otherwise>
                <c:forEach var="reply" items="${replyList}">
                    <div class="reply-item">
                        <div class="reply-header">
                            <strong>${reply.member.nickname}</strong> 
                            <span class="reply-date">${reply.regdate}</span>
                        </div>
                        <div class="reply-content">
                            ${reply.replyContent}
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- ✅ 댓글 작성 폼 -->
    <div class="reply-form">
        <form id="replyForm">
        <c:choose>
            <c:when test="${not empty sessionScope.userid}">
            	<input type="hidden" name="boardIdx" value="${board.boardIdx}" />
                <textarea name="replyContent" id="replyContent" placeholder="댓글을 입력하세요..."></textarea>
                <button onclick="submitReply()">댓글 등록</button>
            </c:when>
            <c:otherwise>
                <p class="login-warning">로그인 후 댓글을 작성할 수 있습니다.</p>
            </c:otherwise>
        </c:choose>
        </form>
    </div>
</div>

</div>
</body>

</html>
