<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<link rel="stylesheet" type="text/css" href="/css/main/2_floor/category.css">  

</head>
<body>

<form name="form1" method="get">
    	<input type="hidden" name="categoryName" id="categoryName">  <!-- 숨겨진 input 필드 추가 -->
            <aside class="menu-container">
                <ul class = "menu">
            <li>
                <button type="button" onclick = "submitCategory('TV')">
                    <span class="img">
                        <img src="/img/category_picture/tv.png" alt="tv 아이콘">
                    </span>
                    TV
                </button>
            </li>
            
            <li>
                <button type="button" onclick = "submitCategory('Notebook')">
                    <span class="img">
                        <img src="/img/category_picture/laptop.png" alt="laptop 아이콘">
                    </span>
                    노트북
                </button>
            </li>
            <li>
                <button type="button" onclick = "submitCategory('Moniter')">
                    <span class="img">
                        <img src="/img/category_picture/moniter.png" alt="moniter 아이콘">
                    </span>
                    모니터
                </button>
            </li>
            <li>
                <button type="button" onclick = "submitCategory('Phone')">
                    <span class="img">
                        <img src="/img/category_picture/mobile.png" alt="mobile 아이콘">
                    </span>
                    스마트폰
                </button>
            </li>
           
            <li>
                <button type="button" onclick = "submitCategory('Refrigerator')">
                    <span class="img">
                        <img src="/img/category_picture/refrigerator.png" alt="refrigerator 아이콘">
                    </span>
                    냉장고
                </button>
            </li>
            <li>
                <button type="button" onclick = "submitCategory('Kimchi')">
                    <span class="img">
                        <img src="/img/category_picture/kimchi.png" alt="kimchi 아이콘">
                    </span>
                    김치냉장고
                </button>
            </li>
           
            
                    <!-- 다른 카테고리들도 추가 가능 -->
        	   </ul>
</aside>
</form>

</body>
</html>