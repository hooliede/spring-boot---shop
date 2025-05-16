<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="/css/main/2_floor/banner.css">
</head>
<body>
<div class="banner-container">      
        <img src="/img/banner_picture/tv1.jpg" alt="tv1 banner">        
        <img src="/img/banner_picture/tv2.jpg" alt="tv2 banner">      
        <img src="/img/banner_picture/washing1.jpg" alt="washing1 banner">       
        <img src="/img/banner_picture/washing2.jpg" alt="washing2 banner">
        <img src="/img/banner_picture/refrigerator1.jpg" alt="refrigerator1 banner">
        <img src="/img/banner_picture/refrigerator2.jpg" alt="refrigerator2 banner">
        <img src="/img/banner_picture/desktop1.jpg" alt="desktop1 banner">
        <img src="/img/banner_picture/desktop2.jpg" alt="desktop2 banner">
        <img src="/img/banner_picture/laptop1.jpg" alt="laptop1 banner">
        <img src="/img/banner_picture/laptop2.jpg" alt="laptop2 banner">
        <img src="/img/banner_picture/cleaner1.jpg" alt="cleaner1 banner">
        <img src="/img/banner_picture/cleaner2.jpg" alt="cleaner2 banner">
        <img src="/img/banner_picture/smart1.jpg" alt="smart1 banner">
        <img src="/img/banner_picture/smart2.jpg" alt="smart2 banner">    
</div>
<script>
        document.addEventListener("DOMContentLoaded", () => {
            let currentIndex = 0; // 현재 보여지는 슬라이드의 첫 번째 이미지 인덱스
            const slides = document.querySelectorAll('.banner-container img'); // 모든 슬라이드 이미지
            const totalSlides = slides.length; // 전체 슬라이드 개수
            const slidesToShow = 2; // 한 번에 보여줄 슬라이드 개수
            // 슬라이드를 초기화 (첫 번째 슬라이드 세팅)
            const updateSlides = () => {
                slides.forEach((slide, index) => {
                    if (index >= currentIndex && index < currentIndex + slidesToShow) {
                        slide.style.display = 'block'; // 보이기
                    } else {
                        slide.style.display = 'none'; // 숨기기
                    }
                });
            };
            // 초기 슬라이드 표시
            updateSlides();
            // 자동 슬라이드 전환 (3초마다)
            setInterval(() => {
                currentIndex += slidesToShow; // 다음 슬라이드로 이동
                if (currentIndex >= totalSlides) {
                    currentIndex = 0; // 슬라이드가 끝나면 처음으로
                }
                updateSlides();
            }, 3000);
        });
</script>
</body>
</html>