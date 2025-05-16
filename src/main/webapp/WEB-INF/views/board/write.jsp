<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>게시글 작성</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 20px;
        }
        .form-container {
            width: 50%;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            color: #333;
        }
        label {
            font-weight: bold;
            display: block;
            margin-top: 10px;
        }
        input, textarea {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .submit-btn {
            width: 100%;
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 20px;
        }
        .submit-btn:hover {
            background-color: #0056b3;
        }
        select {
    width: 100%;
    padding: 8px;
    border: 1px solid #ccc;
    border-radius: 5px;
    background-color: #ffffff;
    font-size: 16px;
    cursor: pointer;
    appearance: none; /* 기본 브라우저 스타일 제거 */
    background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16"><path fill="black" d="M7 10l5 5 5-5z"/></svg>');
    background-repeat: no-repeat;
    background-position: right 10px center;
    background-size: 16px;
}

/* 선택 시 스타일 */
select:focus {
    border-color: #007bff;
    outline: none;
    box-shadow: 0px 0px 5px rgba(0, 120, 255, 0.5);
}
        
    </style>
</head>
<body>
    <div class="form-container">
        <h2>게시글 작성</h2>
        <form id = "uploadForm" action="/board/insertBoard" method="post" enctype="multipart/form-data">
            <label for="boardType">게시판 유형 :</label>
            <select name="boardType" required>
            	<c:if test = "${sessionScope.level eq 'ADMIN'}">
            	<option value="NOTICE">공지사항</option>
            	</c:if>
            	<option value="FREE">자유게시판</option>
            	<option value="REVIEW">리뷰게시판</option>
            </select>
            <label for="title">제목:</label>
            <input type="text" id="title" name="title" required>

            <label>작성자:</label>
            <p>${sessionScope.nickName}</p>

            <label for="contents">내용:</label>
            <textarea id="contents" name="contents" rows="10" required></textarea>

            <label for="files">파일 첨부:</label>
            <input type="file" name = "files" id="fileInput" multiple accept=".jpg,.png,.pdf,.docx" />
            <ul id="fileList"></ul>

            <input type="submit" class="submit-btn" value="등록">
        </form>
    </div>
<script>
    const fileInput = document.getElementById("fileInput");
    const fileList = document.getElementById("fileList");
    const form = document.getElementById("uploadForm");
    let uploadedFiles = [];

    fileInput.addEventListener("change", function(event) {
        const files = Array.from(event.target.files);

        files.forEach(file => {
            // 같은 파일 중복 방지
            if (!uploadedFiles.some(f => f.name === file.name && f.size === file.size)) {
                uploadedFiles.push(file);
                updateFileList();
            }
        });

        // input 초기화 (같은 파일 다시 선택 가능하도록)
        fileInput.value = "";
    });

    function updateFileList() {
        fileList.innerHTML = ""; // 기존 리스트 초기화
        uploadedFiles.forEach((file, index) => {
            const listItem = document.createElement("li");
            listItem.textContent = file.name;

            // 삭제 버튼 추가
            const removeBtn = document.createElement("button");
            removeBtn.textContent = "삭제";
            removeBtn.addEventListener("click", function() {
                uploadedFiles.splice(index, 1);
                updateFileList();
            });

            listItem.appendChild(removeBtn);
            fileList.appendChild(listItem);
        });
    }

    form.addEventListener("submit", function(event) {
        event.preventDefault(); // 기본 제출 방지

        const formData = new FormData();
        formData.append("boardType", document.querySelector("select[name='boardType']").value);
        formData.append("title", document.getElementById("title").value);
        formData.append("contents", document.getElementById("contents").value);

        // 선택된 파일 여러 개 추가
        uploadedFiles.forEach(file => {
            formData.append("files[]", file); // 서버에서 배열로 받을 수 있도록 "files[]"로 설정
        });

        fetch("/board/insertBoard", {
            method: "POST",
            body: formData
        }).then(response => {
            if (!response.ok) {
                throw new Error("서버 응답 오류: " + response.status);
            }
            return response.text(); // JSON이 아닐 수도 있으므로 text로 변환
        }).then(text => {
            try {
                const data = JSON.parse(text); // JSON 형식이면 변환
                alert("게시글이 성공적으로 등록되었습니다!");
                window.location.href = "/board/listAll";
            } catch (e) {
                console.error("서버에서 JSON이 아닌 응답을 받았습니다:", text);
                alert("게시글 등록 후 리다이렉트합니다.");
                window.location.href = "/board/listAll"; // 리다이렉트 처리
            }
        }).catch(error => {
            alert("오류 발생: " + error);
        });
    });
</script>

</body>
</html>