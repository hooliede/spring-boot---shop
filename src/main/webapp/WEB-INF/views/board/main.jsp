<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>

<html>
<head>
    <%@ include file="/WEB-INF/views/include/board/1_floor/board_header.jsp" %>
    <title>게시판</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- jQuery 추가 -->
    
    <style>
        body {
            background-color: #f8f9fa;
        }
        .board-container {
            width: 80%;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            margin-top: 50px;
            text-align: center;
        }
        h2 {
            color: #343a40;
            margin-bottom: 20px;
        }
        .active {
            background-color: #007bff !important;
            color: white !important;
        }
    </style>
</head>
<body>
    <!-- 📌 게시판 선택 버튼 -->
    <div class="d-flex justify-content-center mb-3">
        <div class="btn-group" role="group">
            <button id="freeBoardBtn" class="btn btn-outline-primary active">자유게시판</button>
            <button id="noticeBoardBtn" class="btn btn-outline-secondary">공지사항</button>
        </div>
    </div>

    <!-- 📌 게시판이 표시될 영역 -->
    <div id="boardContent" class="d-flex justify-content-center">
        <!-- ✅ 최초 로드 시 기존 게시글 유지 -->
        <jsp:include page="list.jsp"/>
    </div>

    <script>
        $(document).ready(function () {
            // 📌 페이지 로드 시 자유게시판 데이터 자동 로드
            $("#boardContent").load("/board/list");

            // 자유게시판 버튼 클릭 시
            $("#freeBoardBtn").click(function () {
                $("#boardContent").load("/board/list");
                $("#freeBoardBtn").addClass("active");
                $("#noticeBoardBtn").removeClass("active");
            });

            // 공지사항 버튼 클릭 시
            $("#noticeBoardBtn").click(function () {
                $("#boardContent").load("/board/notice_list");
                $("#noticeBoardBtn").addClass("active");
                $("#freeBoardBtn").removeClass("active");
            });
        });
    </script>
</body>
</html>
