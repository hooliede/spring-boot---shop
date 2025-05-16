<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>가전제품 쇼핑몰</title>


  <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .success-container {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
            text-align: center;
            width: 400px;
            animation: fadeIn 0.8s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .success-container h1 {
            font-size: 22px;
            color: #2b8a3e;
            margin-bottom: 10px;
        }

        .success-container p {
            font-size: 16px;
            color: #555;
            margin-bottom: 20px;
        }

        .success-container .order-number {
            font-weight: bold;
            font-size: 18px;
            color: #333;
        }

        .home-button {
            display: inline-block;
            padding: 12px 20px;
            background-color: #0078ff;
            color: white;
            text-decoration: none;
            font-weight: bold;
            border-radius: 8px;
            transition: background 0.3s ease-in-out;
        }

        .home-button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="success-container">
        <h1>🎉 결제가 성공적으로 완료되었습니다!</h1>
        <p>주문 번호: <span class="order-number">${orderIdx}</span></p>
        <a href="/" class="home-button">🏠 쇼핑몰 홈으로 이동</a>
    </div>
</body>

</html>
