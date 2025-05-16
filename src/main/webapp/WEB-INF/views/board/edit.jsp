<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>게시글 수정</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 20px;
        }
        .container {
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
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        textarea {
            height: 150px;
        }
        .button-group {
            text-align: center;
            margin-top: 20px;
        }
        .button-group button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }
        .button-group button:hover {
            background-color: #0056b3;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            text-decoration: none;
            color: #007bff;
            font-weight: bold;
        }
        .back-link:hover {
            color: #0056b3;
        }
    </style>
</head>
<script>
function updateBoard() {
	const boardIdx = document.querySelector("input[name='boardIdx']").value;
	const title = document.getElementById("title").value.trim();
	const contents = document.getElementById("contents").value.trim();
	
	if (!title || !contents) {
		alert("제목과 내용을 모두 입력하세요.");
		return;
	}
	
	const requestData = {
		boardIdx: boardIdx,
		title: title,
		contents: contents
	};
	
	fetch("/board/updateBoard", {
		method: "POST",
		headers: {"Content-Type": "application/json"},
		body: JSON.stringify(requestData)
	})
	.then(response => response.json())
	.then(result => {
		if (result.success) {
			document.getElementById("successMessage").style.display = "block";
			
			setTimeout(() => {
				window.location.href = "/board/detail?boardIdx="+boardIdx;
			}, 1500);
		} else {
			alert(result.message);
		}
	})
	.catch(error => {
		console.error("Error: " ,error);
		alert("서버 오류로 수정에 실패했습니다.");
	});
}
</script>
<body>
    <div class="container">
        <h2>게시글 수정</h2>
        <form action="/board/updateBoard" method="post">
            <input type="hidden" name="boardIdx" value="${board.boardIdx}" />
            
            <label for="title">제목</label>
            <input type="text" id="title" name="title" value="${board.title}" required />
            
            <label for="contents">내용</label>
            <textarea id="contents" name="contents" required>${board.contents}</textarea>
            
            <div class="button-group">
                <button type="button" onclick="updateBoard()">수정</button>
            </div>
        </form>
        <p id="successMessage" style="color: green; display: none;">게시글이 성공적으로 수정되었습니다.</p>
        <a class="back-link" href="/board/list">목록으로 돌아가기</a>
    </div>
</body>
</html>