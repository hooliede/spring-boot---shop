<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h2>카테고리 리스트 입니당.</h2><br>

<h2>entity 호출 어케하누</h2><br>
<div>
	<c:forEach var="cateogry" items="${list}">
		<h2>${cateogry.categoryName}</h2>
	</c:forEach>
</div>
</body>
</html>