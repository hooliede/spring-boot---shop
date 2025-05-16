<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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
		.url-input textarea {
   			width: 100%;
			height: 150px; /* 필요한 만큼 높이를 조정 */
			border: 1px solid #ccc;
 			border-radius: 4px;
 			padding: 10px;
  			resize: vertical; /* 세로로 크기 조정 가능 */
  			font-size: 14px;
  			color: #333;
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
            margin-top: 20px;
            padding: 12px;
            font-size: 16px;
            color: #fff;
            background-color: #007bff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 10%;
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
            margin-bottom: 20px;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;		
		}
        
    </style>
<script>

function handleCategoryChange() {
	const category = document.getElementById("category").value;
	const additionalFields = document.getElementById("additionalFields");
	
	console.log("받은 카테고리값 : " +category);
	
	if(!category || category === "") {
		console.log("category 값이 유효하지 않음! (빈 값 또는 undefined)");
		additionalFields.innerHTML = '';
		return;
	}
	
	/* URL */
	const requesturl = "/admin/getAttributes?categoryId="+category;
	
	console.log("URL 확인 :" +requesturl);

	/* Ajax 요청을 통해 특성 리스트(이름) 출력 */
	fetch(requesturl)
		.then(response => response.json()) 
		/* json 데이터를 javascript 객체 변환 */
		.then(attributes => {
			console.log("✅ JSON 변환 후 데이터:", attributes);
			attributes.forEach(attr => console.log("받아온 속성이름 리스트 :" +attr.attributeName));
			
			/*  AJAX를 통해 새로운 속성 리스트를 가져올 때, 기존의 입력 필드를 제거하고 새로 추가 */
			additionalFields.innerHTML = '';
			
			if (attributes.length === 0) {
				additionalFields.innerHTML = "<p>해당 카테고리에는 추가 상품 특성이 없습니다.</p>";
				return;
			}
			
			attributes.forEach((attr, index) => {
				
				/* attr: 현재 순회 중인 객체 (attributes 배열의 요소) */
				/* index: 현재 순회 중인 요소의 순서(0부터 시작하는 숫자) */
				
				console.log(`🔥 ${index + 1} 번째 속성 추가 중...`, attr);
				
				const formGroup = document.createElement("div");
				formGroup.classList.add("form-group");

				// 라벨
				const label = document.createElement("label");
				label.textContent = attr.attributeName + " : ";
				
				// attributeValue 입력 필드
				const input = document.createElement("input");
				input.type = "text";
				input.name = "productAttributeList["+index+"].attributeValue";
				input.placeholder = attr.attributeName+"을 입력해주세요";
				
				// attributeId를 hidden으로 추가 (attributeID를 유지해야함)
				const hiddenInput = document.createElement("input");
				hiddenInput.type = "hidden";
				hiddenInput.name = "productAttributeList["+index+"].attributeId";
				hiddenInput.value = attr.attributeId;
				
				
				/* 요소 관리 */
				formGroup.appendChild(label);
				formGroup.appendChild(input);
				formGroup.appendChild(hiddenInput);
				
				additionalFields.appendChild(formGroup);
			});
		})
}

document.addEventListener("DOMContentLoaded", function () {
	const productCodeInput = document.getElementById("productCode");
	const productCodeMessage = document.createElement("span"); //메세지 표시할 요소 생성
	productCodeInput.parentNode.appendChild(productCodeMessage); // productCode 입력창 아래에 메시지 추가
	
	productCodeInput.addEventListener("input", function() {
		let productCode = productCodeInput.value.trim();
		
		if (productCode.length === 0 ) {
			productCodeMessage.textContent = "";
			return;
		}
		
		fetch ("/admin/checkProductCode?productCode="+encodeURIComponent(productCode))
			.then(response => response.json())
			.then(data => {
				if(data.exists) {
					 productCodeMessage.textContent = "❌ 이미 사용 중인 상품 코드입니다.";
	                 productCodeMessage.style.color = "red";
	                 productCodeInput.style.borderColor = "red";
				} else {
                    productCodeMessage.textContent = "✅ 사용 가능한 상품 코드입니다.";
                    productCodeMessage.style.color = "green";
                    productCodeInput.style.borderColor = "green";
                }
			})
			 .catch(error => {
	                console.error("오류 발생:", error);
	                productCodeMessage.textContent = "서버 오류 발생";
	                productCodeMessage.style.color = "red";
	            });
	});
});
</script>



<script type = "text/javascript">
	window.onload = function() {
		var alertMessage = "<%= request.getAttribute("alertMessage") %>";
		if (alertMessage) {
			alert(alertMessage);
		}
	};
</script>


<title>상품 추가</title>
</head>
<body>
<form name="form1" method="post" action = "/admin/insertProduct" enctype="multipart/form-data" >
 <div class="main-container">
        <!-- 좌측 이미지 업로드 -->
        <div class="image-upload">
            <p>이미지 업로드(선택사항)</p>
            <input type="file" name="productImage" id="imageUpload" accept="image/*">
            <label for="imageUpload">파일을 선택해주세요.</label>
            <img id="preview" src="#" alt="이미지 미리보기" style="display: none; width: 100%; height: auto; margin-top: 10px;">
        </div>
        <!-- 우측 입력 폼 -->
        
        <div class="form-container">
            <h2>상품 추가</h2>
            
                <div class = "form-group">
                	<label for="productCode">제품 코드:</label>
                	<input type="text" name="productCode" id="productCode" placeholder="시리얼 넘버를 입력해주세요.">
                </div>
                <div class="form-group">
                    <label for="productName">제품명:</label>
                    <input type="text" name="productName" id="productName" placeholder="제품명을 입력하세요">
                </div>
                <div class ="form-group">
                	<label for="manufacturer">제조사:</label>
                	<input type="text" name="manufacturer" id="manufacturer" placeholder="브랜드를 입력하세요">
                </div>
                <div class="form-group">
                    <label for="price">가격:</label>
                    <input type="text" name="price" id="price" placeholder="가격을 입력하세요">
                </div>
                <div class="form-group">
                    <label for="stock">상품수량:</label>
                    <input type="number" name="stock" id="stock" value="0" min="0">
                </div>                
            
        </div>
        
	</div>
	<div class="category-container">
        <h3>카테고리 상세 정보</h3>
        <div class="form-group">
            <label for="category">카테고리:</label>
            <select name="categoryId" id="category" class="select-fit" onchange="handleCategoryChange()">
                <option value="" disabled selected>카테고리를 선택하세요</option>
                <option value="1">모니터</option>
                <option value="2">TV</option>
                <option value="3">김치냉장고</option>
                <option value="4">노트북</option>
                <option value="5">스마트폰</option>
                <option value="6">냉장고</option>
                <option value="7">건조기</option>
            </select>
        </div>
        <div id="additionalFields"></div>
        <button type="submit" class="submit-button">추가하기</button>
    </div>
</form>
<script>
/* 이미지 미리보기 */
document.getElementById("imageUpload").addEventListener("change", function (event) {
    const file = event.target.files[0];
    if (file) {
        const reader = new FileReader();
        reader.onload = function (e) {
            const preview = document.getElementById("preview");
            preview.src = e.target.result;
            preview.style.display = "block";
        };
        reader.readAsDataURL(file);
    }
});
</script>
</body>
</html>