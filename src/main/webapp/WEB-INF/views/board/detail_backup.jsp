<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<html>
<head>
    <title>게시글 상세 보기</title>
  	<link rel="stylesheet" href="/css/board/detail.css">
</head>
<script>
/* 게시글 수정 */
function editBoard(boardIdx) {
	location.href = "/board/edit/"+boardIdx;
}
/* 댓글 등록 */
function submitReply() {
	const boardIdx = document.querySelector('input[name="boardIdx"]').value;
	const replyContent = document.ElementById("replyContent").value.trim;	
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

/* 댓글 삭제 */
function deleteReply(replyIdx) {
	if (!confirm("정말로 댓글을 삭제하시겠습니까?")) {
		return;
	}
	
	fetch("/reply/delete/"+replyIdx, {
		method:"POST",
	})
	.then(response => response.json())
	.then(result => {
		if(result.success) {
			alert(result.message);
			location.reload();
		} else {
			alert(result.message);
		}
	})
	.catch(error => {
		console.error("Error : ",error);
		alert("서버 오류로 댓글 삭제에 실패했습니다.");
	});
}
/* 수정 버튼 클릭 시, 입력 폼 활성화 */
function editReply(replyIdx) {
	document.getElementById("replyText-"+replyIdx).style.display = "none";
	document.getElementById("editBox-"+replyIdx).style.display = "block";
    document.getElementById("editBtn-"+replyIdx).style.display = "none";
}

/* 수정 취소 버튼 클릭 시 , 원래 상태로 복귀 */
function cancelEdit(replyIdx) {
	document.getElementById("replyText-"+replyIdx).style.display = "block";
	document.getElementById("editBox-"+replyIdx).style.display = "none";
    document.getElementById("editBtn-"+replyIdx).style.display = "block";
}

/* 댓글 수정 요청 */
function updateReply(replyIdx) {
	const newContent = document.getElementById("editContent-"+replyIdx).value;
	
	if (!newContent) {
		alert("댓글 내용을 입력하세요.");
		return;
	}
	
	fetch("/reply/update/"+replyIdx, {
		method:"POST",
		headers: {"Content-Type": "application/json"},
		body: JSON.stringify({ replyContent: newContent })
	})
	.then(response => response.json())
	.then(result => {
		if(result.success) {
			alert(result.message);
			location.reload();
		} else {
			alert(result.message);
		}
	})
	.catch(error => {
		console.error("Error : ",error);
		alert("서버 오류로 댓글 삭제에 실패했습니다.");
	});
}
</script>
<body>
<!-- 상단 헤더 -->
<header class="header-container">
	<div class="logo">
		<a href="/">병훈전자</a>
	</div>
	<div class="nav-links">
        	<!-- 로그인 상태 확인 -->
        	<c:choose>
        		<c:when test = "${not empty sessionScope.result}">
        			<p>${sessionScope.result}<br>
        			<a href = "/member/logout">로그아웃</a>
        			<span>|</span>
        			<a href="/member/mypage">마이페이지</a>
        			<span>|</span>
        			<a href="/cart/listCart">장바구니</a>
        			</p>
        		</c:when>
        		<c:otherwise>
           			<a href="/member/login">로그인</a>
          			<span>|</span>
            		<a href="#" onclick="alert('로그인이 필요합니다.'); return false;">마이페이지</a>
            		<span>|</span>
            		<a href="#" onclick="alert('로그인이 필요합니다.'); return false;">장바구니</a>
            	</c:otherwise>
            		
        	</c:choose>
    </div>
</header>
<!-- 메인 컨텐츠 -->
<div class="main-container">
	<h2>${board.title}</h2>
    <div class="post-info">
    	<span class="left-section">작성자: ${board.member.nickname}</span>
    	<span class="right-section">작성일: ${board.regdate} | 조회수: ${board.hit}   </span>
    	<div class ="action-buttons">
        	<!-- 수정 버튼(본인만) -->
        	<c:if test="${sessionScope.userid == board.member.userid}">
        		<button class="edit-btn" onclick="editBoard(${board.boardIdx})">✏️ 수정</button>
        	</c:if>
        	<!-- 삭제 버튼(본인+관리자) -->
        	<c:if test="${sessionScope.userid == board.member.userid || sessionScope.level == 'ADMIN'}">
            	<button class="delete-btn" onclick="deletePost(${board.boardIdx})">🗑️ 삭제</button>
        	</c:if>
        </div>
    </div>
	<div class="post-content">
		<c:if test="${dto.attachList.size() > 0}">
            <div class="file-container">
                <h3>📎 첨부 파일</h3>
                <c:forEach items="${attachList}" var="attach">
                    <img src="/upload/board?file_name=${attach.fileName}" alt="${attach.fileName}" />
                </c:forEach>
            </div>
        </c:if>
	
	${board.contents}
	
	</div>		
		
        
		<div id="replyList">
			<c:choose>
				<c:when test="${empty replyList}">
					<p>💬 아직 등록된 댓글이 없습니다.</p>
				</c:when>
				<c:otherwise>
					<c:forEach var="reply" items="${replyList}">
						<div class="reply">
							<p id="replyText-${reply.replyIdx}">
								<strong>(${reply.replyIdx})${reply.member.nickname}</strong>
								<c:if test="${reply.edited}">(수정됨)</c:if>
								: <span>${reply.replyContent}</span>
							</p>
							
							<!-- 수정 상태 (숨김, 버튼 클릭 시 활성화) -->
							<div id = "editBox-${reply.replyIdx}" style="display: none;">
								<textarea id = "editContent-${reply.replyIdx}">${reply.replyContent}</textarea>
								<button onclick="updateReply(${reply.replyIdx})">💾 수정 완료</button>
								<button onclick="cancelEdit(${reply.replyIdx})">❌ 취소</button>
							</div>
							
							<!-- 댓글 삭제 버튼(댓글 작성자 or 관리자) -->
							<div class ="action-buttons">
							<c:if test="${sessionScope.userid == reply.member.userid || sessionScope.level == 'ADMIN'}">
								<button class="delete-btn" onclick="deleteReply(${reply.replyIdx})">🗑️ 삭제</button>
							</c:if>
							<c:if test="${sessionScope.userid == reply.member.userid}">
								<button class="edit-btn" onclick="editReply(${reply.replyIdx})">✏️ 수정</button>
							</c:if>
							</div>
						</div>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</div>

        <h3>✏️ 댓글 작성</h3>

        <div class="form-container"> 
            	<form id="replyForm">
                	<input type="hidden" name="boardIdx" value="${board.boardIdx}" />
                	<textarea name="replyContent" rows="4" placeholder="댓글을 입력해주세요."></textarea><br>
                	<c:choose>
                	<c:when test = "${not empty sessionScope.userid}">
                		<button type="button" onclick="submitReply()">등록하기</button>
                	</c:when>
                	<c:otherwise>
                		<button onclick="alert('로그인이 필요합니다.'); return false;">등록하기</button>
                	</c:otherwise>
                	</c:choose>
            	</form>
        </div>
        <div class = "action-bar">
        	<a class="back-link" href="/board/listAll">목록</a>
        </div>
        

    
</div>
</body>
</html>
