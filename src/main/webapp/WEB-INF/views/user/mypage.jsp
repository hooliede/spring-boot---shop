<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ko">
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>마이페이지</title>
<link rel="stylesheet" type="text/css" href="/css/user/mypage.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/js/all.min.js"></script>
</head>

<c:if test="${param.message == 'change_nickname'}">
    <script>
        alert("닉네임을 성공적으로 변경했습니다.");
    </script>
</c:if>

<body>

<div class="container">
<div class="logo">
        <a href= "/" style="text-decoration: none; color: inherit;">병훈전자</a>
    </div>
    <h1>마이페이지</h1>

    <div class="profile-header">
        <img src="https://via.placeholder.com/120" alt="프로필 사진">
        <div class="user-info">
            ${member.name}
            <span id="nickname">닉네임: ${member.nickname}</span>
            <span>${member.name}님, 안녕하세요!</span>
        </div>
    </div>

    <div class="info-card">
        <div class="info-row">
            <label for="name">이름:</label>
            <span id="name">${member.name}</span>
        </div>

        <div class="info-row">
            <label for="nickname">닉네임:</label>
            <span id="nickname">${member.nickname}</span>
        </div>

        <div class="info-row">
            <label for="phone">전화번호:</label>
            <span id="phone">${member.phone}</span>
        </div>
    </div>

    <div class="actions-container">
        <div class="action">
            <span><i class="fas fa-lock"></i> 비밀번호</span>
            <button onclick="togglePasswordChangeForm()" class="edit-btn">수정</button>
        </div>
        <div class="action">
            <jsp:include page="/WEB-INF/views/user/pwdChange.jsp" />
        </div>

        <div class="action">
            <span><i class="fas fa-shopping-cart"></i> 주문내역</span>
            <button onclick="loadPurchaseHistory()" class="edit-btn">보기</button>
        </div>

        <!-- 주문 내역 리스트 출력 공간 -->
        <div id="purchase-history-container" style="display: none;"></div>

        <div class="action">
            <span><i class="fas fa-user-edit"></i> 닉네임</span>
            <button onclick="toggleNicknameChangeForm()" class="edit-btn">변경</button>
        </div>
        <div class="action">
            <jsp:include page="/WEB-INF/views/user/changeNickname.jsp" />
        </div>
    </div>
</div>

</body>

<!-- 📌 비밀번호 변경 폼 토글 -->
<script>
    function togglePasswordChangeForm() {
        var pwdForm = document.getElementById("password-change-container");
        var nickForm = document.getElementById("nickname-change-container");

        if (pwdForm.style.display === "none" || pwdForm.style.display === "") {
            pwdForm.style.display = "block";  
            nickForm.style.display = "none";  // 닉네임 변경 폼 닫기
        } else {
            pwdForm.style.display = "none";
        }
    }
</script>

<!-- 📌 닉네임 변경 폼 토글 -->
<script>
    function toggleNicknameChangeForm() {
        var nickForm = document.getElementById("nickname-change-container");
        var pwdForm = document.getElementById("password-change-container");

        if (nickForm.style.display === "none" || nickForm.style.display === "") {
            nickForm.style.display = "block";
            pwdForm.style.display = "none";  // 비밀번호 변경 폼 닫기
        } else {
            nickForm.style.display = "none";
        }
    }
</script>

<!-- 📌 닉네임 변경 AJAX 요청 -->
<script>
function changeNickname() {
    let newNickname = document.getElementById("newNickname").value;
    let messageBox = document.getElementById("nicknameMessage");
    let submitButton = document.querySelector("#nicknameChangeForm input[type='button']");

    submitButton.disabled = true;
    submitButton.value = "변경 중...";

    if (!newNickname.trim()) {
        messageBox.style.color = "red";
        messageBox.innerText = "변경할 닉네임을 입력하세요.";
        submitButton.disabled = false;
        submitButton.value = "닉네임 변경";
        return;
    }


    fetch("/member/changeNickname", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ newNickname })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            messageBox.style.color = "green";
            messageBox.innerText = "✅ 닉네임이 성공적으로 변경되었습니다.";
            document.getElementById("nicknameChangeForm").reset();

            document.getElementById("nickname").innerText = newNickname;

            setTimeout(() => {
                document.getElementById("nickname-change-container").style.display = "none";
            }, 1500);
        } else {
            messageBox.style.color = "red";
            messageBox.innerText = "❌ "+data.message;
        }
    })
    .catch(error => {
        console.error("Error:", error);
        messageBox.style.color = "red";
        messageBox.innerText = "❌ 닉네임 변경에 실패했습니다.";
    })
    .finally(() => {
        submitButton.disabled = false;
        submitButton.value = "닉네임 변경";
    });
}
</script>

<!--  비밀번호 변경 AJAX 요청  -->
<script>
function changePassword() {
    let passwd = document.getElementById("passwd").value;
    let newPasswd = document.getElementById("newPasswd").value;
    let confirmPasswd = document.getElementById("confirmPasswd").value;
    let messageBox = document.getElementById("passwdMessage");
	
    let userid = document.getElementById("userid").value;
    
    if (newPasswd !== confirmPasswd) {
        messageBox.style.color = "red";
        messageBox.innerText = "새 비밀번호가 일치하지 않습니다.";
        return;
    }
	
    fetch("/member/changePwd", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ passwd, newPasswd, userid })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            messageBox.style.color = "green";
            messageBox.innerText = "✅ 비밀번호가 성공적으로 변경되었습니다.";
            document.getElementById("passwordChangeForm").reset();
        } else {
            messageBox.style.color = "red";
            messageBox.innerText = `❌ ${data.message}`;
        }
    })
    .catch(error => {
        console.error("Error:", error);
        messageBox.style.color = "red";
        messageBox.innerText = "❌ 비밀번호 변경에 실패했습니다.";
    });
}
</script>

<script>
/* 구매 내역 불러오기 */
    function loadPurchaseHistory() {
        let historyContainer = document.getElementById("purchase-history-container");

        if (historyContainer.style.display === "block") {
            historyContainer.style.display = "none";
        } else {
            fetch("/member/loadOrderList")
                .then(response => response.text()) 
                .then(data => {
                    historyContainer.innerHTML = data;
                    historyContainer.style.display = "block";
                })
                .catch(error => {
                    console.error("Error:", error);
                    alert("구매 내역을 불러오는 데 실패했습니다.");
                });
        }
    }
</script>
<script>
/* 주문 취소 요청 */
function requestCancelOrder(orderIdx) {
    if (!confirm("정말 주문을 취소하시겠습니까?")) {
        return;
    }

    fetch("/member/requestCancelOrder/"+orderIdx, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        }
    })
    .then(response => response.json())  // JSON 응답 변환
    .then(data => {
        if (data.success) {
            alert(data.message);
            location.reload();
        } else {
            alert(data.message);
        }
    })
    .catch(error => {
        console.error("Error:", error);
        alert("서버 오류가 발생했습니다. 다시 시도해주세요.");
    });
}

</script>
</html>
