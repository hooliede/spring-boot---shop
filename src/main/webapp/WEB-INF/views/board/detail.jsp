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
    padding: 6px 12px; /* 크기 조정 */
    font-size: 14px;
    border: none;
    cursor: pointer;
    border-radius: 5px;
    transition: background 0.3s ease, transform 0.1s ease;
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
/* 게시글 수정 */
function editBoard(boardIdx) {
	location.href = "/board/edit/"+boardIdx;
}

/* 게시글 삭제 */
function deleteBoard(boardIdx) {
    if (!confirm("정말로 게시글을 삭제하시겠습니까?")) {
        return;
    }

    fetch("/board/delete/" + boardIdx, {
        method: "POST", // 또는 DELETE 사용 가능
        headers: { "Content-Type": "application/json" }
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            alert(result.message);
            window.location.href = "/board/listAll"; // ✅ 삭제 후 목록으로 이동
        } else {
            alert(result.message);
        }
    })
    .catch(error => {
        console.error("Error:", error);
        alert("서버 오류로 게시글 삭제에 실패했습니다.");
    });
}


/* ✅ 댓글 삭제 요청 */
function deleteReply(replyIdx) {
    if (!confirm("정말로 댓글을 삭제하시겠습니까?")) {
        return;
    }

    fetch("/reply/delete/" + replyIdx, {
        method: "POST", // 또는 DELETE 사용 가능
        headers: { "Content-Type": "application/json" }
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            alert(result.message);
            location.reload();
        } else {
            alert(result.message);
        }
    })
    .catch(error => {
        console.error("Error:", error);
        alert("서버 오류로 댓글 삭제에 실패했습니다.");
    });
}


/* 수정 버튼 클릭 시, 입력 폼 활성화 */
function editReply(replyIdx) {
    document.getElementById("replyText-" + replyIdx).style.display = "none";
    document.getElementById("editBox-" + replyIdx).style.display = "block";
    document.getElementById("editBtn-" + replyIdx).style.display = "none";
}

/* 수정 취소 버튼 클릭 시, 원래 상태로 복귀 */
function cancelEdit(replyIdx) {
    document.getElementById("replyText-" + replyIdx).style.display = "block";
    document.getElementById("editBox-" + replyIdx).style.display = "none";
    document.getElementById("editBtn-" + replyIdx).style.display = "inline-block";
}

/* 댓글 수정 요청 */
function updateReply(replyIdx) {
    const newContent = document.getElementById("editContent-" + replyIdx).value.trim();

    if (!newContent) {
        alert("댓글 내용을 입력하세요.");
        return;
    }

    fetch("/reply/update/" + replyIdx, {
        method: "POST", // ✅ 또는 PATCH 가능
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ replyContent: newContent })
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            alert(result.message);
            location.reload();
        } else {
            alert(result.message);
        }
    })
    .catch(error => {
        console.error("Error:", error);
        alert("서버 오류로 댓글 수정에 실패했습니다.");
    });
}



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
	.then(response => {
    	if (response.status === 401) {
        	throw new Error("로그인이 필요합니다. 다시 로그인해주세요.");
    	}
    	if (!response.ok) {
        	throw new Error("HTTP 오류! 상태 코드:" +response.status);
    	}
    	return response.json();
	})
	.then(result => {
		if (result.success) {
			alert(result.message);
			location.reload();
		} else {
			alert(result.message || "댓글 등록 실패!");
		}
	})
	.catch(error => {
		console.error("Error:", error);
		alert(error.message);
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
   			<c:if test = "${not empty attachList}">
   				<c:forEach var="attach" items ="${attachList}">
   				<img src="${attach.filePath}" alt="게시물 이미지" width = "200"><br>
   				</c:forEach>
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
            <button class="delete-btn" onclick="deleteBoard(${board.boardIdx})">🗑️ 삭제</button>
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
                            <strong>
                            ${reply.member.nickname}<span><c:if test="${reply.edited}">(수정됨)</c:if></span>
                            </strong> 
                            <span class="reply-date">${reply.regdate}</span>
                        </div>
                        
                        <!-- 일반 모드 -->
                        <div class="reply-content" id="replyText-${reply.replyIdx}">
                            ${reply.replyContent}
                        </div>
                        
                        <!-- 수정 모드(숨김 상태) -->
                        <div class="edit-reply-box" id="editBox-${reply.replyIdx}" style="display: none;">
                        	<textarea id="editContent-${reply.replyIdx}">${reply.replyContent}</textarea>
                        	<button onclick="updateReply(${reply.replyIdx})">💾 수정 완료</button>
                        	<button onclick="cancelEdit(${reply.replyIdx})">❌ 취소</button>
                        </div>
                        
                        <!-- ✅ 버튼 영역 (수정/삭제) -->
                    	<div class="action-bar">
                        	<!-- ✅ 수정 버튼 (본인만 가능) -->
                        	<c:if test="${sessionScope.userid == reply.member.userid}">
                        	    <button class="edit-btn" id="editBtn-${reply.replyIdx}" onclick="editReply(${reply.replyIdx})">✏️ 수정</button>
                        	</c:if>
                        	<!-- ✅ 삭제 버튼 (본인 또는 관리자만 가능) -->
                        	<c:if test="${sessionScope.userid == reply.member.userid || sessionScope.level == 'ADMIN'}">
                        	    <button class="delete-btn" onclick="deleteReply(${reply.replyIdx})">🗑️ 삭제</button>
                        	</c:if>
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
