<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<style>
        /* 공통 스타일 */
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }

        /* 메인 컨테이너 */
        .main-container {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 40px;
            padding: 40px;
            width: 100%;
            box-sizing: border-box;
        }

        /* 좌측 이미지 업로드 */
        .image-upload {
            width: 40%;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            border: 2px dashed #ccc;
            border-radius: 8px;
            padding: 20px;
            height: 400px;
            text-align: center;
            color: #999;
            background-color: #fff;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .image-upload input {
            display: none;
        }

        .image-upload label {
            cursor: pointer;
            color: #007bff;
            font-weight: bold;
            text-decoration: underline;
        }

        /* 우측 입력 폼 */
        .form-container {
            width: 50%;
            background: #fff;
            border-radius: 8px;            
            padding: 20px 30px;            
            height: 400px;
            display: flex;
            flex-direction: column;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            justify-content: space-between;
        }

        .form-container h2 {
            font-size: 28px;
            color: #333;
            margin-bottom: 20px;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
        }

        .form-group {
            display: flex;
            margin-bottom: 15px;
            align-items: center;
        }

        .form-group label {
            width: 150px;
            font-weight: bold;
            color: #333;
        }

        .form-group input,
        .form-group select {
            flex: 1;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 4px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        .form-group input:focus,
        .form-group select:focus {
            border-color: #007bff;
            box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
            outline: none;
        }

        /* 버튼 스타일 */
        .submit-button {
            margin-top: 10px;
            padding: 3px 8px;
            font-size: 14px;
            
            width: auto;
            height: 40px;
            white-space: nowrap;
            
            display: inline-block;
            
            color: #fff;
            background-color: #007bff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            
            transition: background-color 0.3s ease;
        }

        .submit-button:hover {
            background-color: #0056b3;
        }
        
		
        .category-container {
    		display: flex;
    		flex-direction: column;
    		width: 100%; /* 동일한 너비 설정 */
		    padding: 0 40px; /* 좌우 동일한 패딩 */
		    box-sizing: border-box; /* 테두리와 패딩 포함 */
		}

		.category-container {
		    margin-top: 20px; /* 위쪽 간격 */
		    margin-left: 40px; /* 왼쪽 여백 추가 */
		    margin-right: 40px; /* 오른쪽 여백 추가 */
		    background: #fff; /* 흰색 배경 */
		    border-radius: 8px;
		    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
		    padding: 20px 30px; /* 내부 여백 */
		    box-sizing: border-box;
		    width: calc(100% - 80px); /* 좌우 여백을 제외한 너비 */
		}
        
        .form-group select.select-fit {
   			width: auto; /* 텍스트 길이에 맞춤 */
    		max-width: 250px; /* 최대 너비 제한 */
    		padding: 8px 10px; /* 내부 여백 */
    		font-size: 14px; /* 글자 크기 */
    		border: 1px solid #ccc; /* 테두리 색 */
    		border-radius: 4px; /* 둥근 모서리 */
    		background: #fff; /* 흰색 배경 */
    		appearance: none; /* 기본 브라우저 스타일 제거 */
    		text-align: left; /* 텍스트 정렬 */
		}
		
		.category-container h3 {
		font-size: 28px;
            color: #333;
            margin-bottom: 10px;
            
            padding-bottom: 10px;		
		}
        .category-header{
        	display: flex;
        	justify-content: space-between;
        	algin-items: center;
        	width: 100%;
        	border-bottom: 2px solid #007bff;
        	padding-bottom: 10px;
        }
    </style> 
<script>
window.onload = function() {
	/* attribute-name List */
	const aList = [];
	<c:forEach var="aList" items="${aList}" varStatus = "status">
		aList.push({ "attributeName": "${aList.attributeName}" });
	</c:forEach>
	
	const paList = [];
	<c:forEach var="paList" items="${paList}" varStatus = "status">
		paList.push({ "attributeValue": "${paList.attributeValue}",
			"paIdx": "${paList.paIdx}"});
	</c:forEach>
	
	console.log("특성 이름 리스트 :", JSON.stringify(aList, null, 2));
	console.log("특성 값 리스트:", JSON.stringify(paList, null, 2));

	
	/* 리스트를 additionalFields에 동적으로 추가 */
	const additionalFields = document.getElementById("additionalFields");
	console.log("📌 additionalFields 존재 여부:", additionalFields);
	if (!additionalFields) {
		console.error("addtionalFields 요소를 찾을 수 없음 !");
		return;
	}
	
	additionalFields.innerHTML = "<br>";
	
	
	/* 순서 기준 리스트 매칭하기 (index)*/
	aList.forEach((attr,index) => {
		const attributeValue = paList[index] ? (paList[index].attributeValue || "값 없음") : "값 없음";
		const safePaIdx = String(paList[index].paIdx);
		
		/* attrName-attrValue 출력할 HTML */
		const fieldHTML = 
			'<div class="form-group">'+
				'<label for="attr_'+index+'">'+attr.attributeName+' :</label>' +
				'<input type="hidden" name="paIdx_'+index+'" value= "'+safePaIdx+'">'+
				'<input type="text" id="attr_'+index+'" name="attributeValue_'+index+'" value="'+attributeValue+'" placeholder="'+attributeValue+'">' +
			'</div>';
		
		console.log("🛠 ["+index+"] 추가할 HTML:\n", fieldHTML);
		additionalFields.innerHTML += fieldHTML;
	});
}
</script>
<script>
function updateProduct() {
	/* 기본 데이터 수집 */
	const productCode = document.getElementById("productCode").value;
	const price = document.getElementById("price").value;
	
	/* paIdx, attributeValue 리스트 생성 */
	const attributes = [];
	
	document.querySelectorAll("input[name^='attributeValue_']").forEach(input => {
		const index = input.name.split("_")[1]; /* attributeValue_0 -> '0' */
		
		const paIdx = document.querySelector("input[name='paIdx_"+index+"']").value;
		
		const attributeValue = input.value;
		
		attributes.push({paIdx: parseInt(paIdx), 
						attributeValue: attributeValue });
	});
	
	/* DTO와 데이터 매칭 */
	const data = {
			productCode: productCode,
			price: parseInt(price),
			attributes: attributes
	}
	
	fetch("/admin/updateProduct", {
		method: "POST",
		headers: { "Content-Type": "application/json"},
		body: JSON.stringify(data)
	})
		.then(response => response.text())
		.then(data => {
			console.log("업데이트 성공:", data);
		})
		.catch(error => {
			console.log("업데이트 실패: " ,error);
		});
}

</script>

<title>상품 상세보기</title>

</head>
<body>
<form name="form1" method="post" action="">
 <div class="main-container">
        <!-- 좌측 이미지 업로드 -->
        <div class="image-upload">
            <img src="${product.imageUrl}" alt="상품 이미지" width="100"/>
        </div>

        <!-- 우측 입력 폼 -->
        
        <div class="form-container">
            <h2>상품 수정</h2>
            
                <div class = "form-group">
                	<label for="productCode">제품 코드:</label>
                	<span>${product.productCode}</span>
                	<!-- hidden영역 추가 (product_code, full_name, category) -->
                	<!-- state 편집 영역 추가해야됨 -->
                	<input type="hidden" name="productCode" id = "productCode" value = "${product.productCode}">
                	<input type="hidden" name="categoryId" value="${product.category.categoryId}">
                </div>
                <div class="form-group">
                    <label for="productName">제품명:</label>
                    <span>${product.productName}</span>
                </div>
                <div class ="form-group">
                	<label for="manufacturer">제조사:</label>
                	<span>${product.manufacturer}</span>
                </div>
                <div class="form-group">
                    <label for="price">가격:</label>
                    <input type="text" name="price" id="price" value="${product.price}">
                </div>
                <div class="form-group">
                    <label for="stock">상품수량:</label>
                    <input type="number" name="stock" id="stock" value="${product.stock}" min="0">
                </div>                
            	<div class = "form-group">
            		<label for="state">제품 상태:</label>
            		<input type="text" name = "state" id="state" value = "{state}(준비중)" readonly>
            	</div>
        </div>
        
	</div>
	<div class="category-container">
        <div class="category-header">
        <h3>제품 상세 정보</h3>
        <button type="submit" class="submit-button" onclick="updateProduct()">수정하기</button>
        </div>
        <div class="form-group">
            <label for="category">카테고리:</label>
            <span id = "category">${categoryName}</span>
        </div>
        <div id="additionalFields"></div>
        
    </div>
</form>
</body>
</html>