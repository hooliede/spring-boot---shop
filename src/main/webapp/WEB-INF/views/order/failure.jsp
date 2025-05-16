<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>결제 실패</title>
</head>
<body>
    <h1>결제 실패</h1>
    <p>오류 메시지: ${message}</p> <!-- ✅ 컨트롤러에서 받은 message 사용 가능 -->
    <a href="/">메인 페이지로 이동</a>
</body>
</html>
