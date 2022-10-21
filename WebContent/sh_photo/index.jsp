<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.database.* ,acar.util.*, acar.user_mng.*, acar.off_anc.*, acar.attend.*"%>
<!DOCTYPE HTML>
<%
	SecurityUtil securityUtil 	= new SecurityUtil();
%>
<html>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta name="viewport" content="width=device-width, user-scalable=no">
<head>
<script src="https://code.jquery.com/jquery-3.1.1.min.js"
	integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8="
	crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.css" />
<link rel="stylesheet" href="/sh_photo/sh_photo.css" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<script>
function validation(cellphone){
	var flag = true;
	
	var regNumber = /^[0-9]*$/;
	
	if(!regNumber.test(cellphone)){
		flag = false;
		alert("핸드폰번호는 숫자만 입력해주세요");
		$("#cellphone").val(cellphone.replace("-",""));
		$("#cellphone").focus();
	}

	return flag;
}

$(document).ready(function(){
	
	$("#leaderBtn").click(function(){
		
		var name = $("#empName").val();
		var cellphone = $("#cellphone").val();
		
		//이름, 핸드폰번호 validation 
		if(name != "" && cellphone != ""){
			var flag = validation(cellphone);
			if(flag){	
				var cookievalue = $("#cv").val();
				$.cookie("sh_photo_login",[name,cellphone],{path:'/',expires:1});
				var cookies = "fmsCookie" + '=' + escape(cookievalue) + '; path=/ ; domain=.amazoncar.co.kr;';
		    	document.cookie = cookies;
		    	
		    	$(".container").slideToggle();
				//$("form").submit();
				return false;
			}
		}else{
			alert("이름, 핸드폰번호를 모두 입력해주세요");
			return false;
		}

	})
	
	$("#submitBtn").click(function(){
		$("input[name='empName']").each(function(){
			if($(this).val() == "" || $(this).val() == null){
				$(this).remove();
			}
		})
		$("form").submit();
	})
})
</script>
</head>
<body>
	<form class="ui form" action="reg_coworker.jsp" method="post">
		<input type="hidden" name="cv" value="<%=securityUtil.encodeAES(Webconst.Common.FMS3_COOKIE_VALUE+"2016006|000263") %>" id="cv" />
		<input type="hidden" name="name" value="tspict" />
		<input type="hidden" name="passwd" value="tspict" />
		<input type="hidden" name="login_yn" value="ok"/>
		<input type="hidden" name="open_type" value="1"/>
		<p style="text-align:center;">
			<img src="http://www.amazoncar.co.kr/acar/images/logo_1.png"/>
		</p>
		<div class="container">	
			<div class="ui stacked segment">
				<div id="step1" >
					<div class="field">
						<label>대표 작업자 이름</label> <input type="text" name="empName" id="empName"/>
					</div>
					<div class="field">
						<label>핸드폰번호</label> <input type="text" name="cellphone" id="cellphone" placeholder="숫자만 입력해주세요"/>
					</div>
			    </div>
				<br/>
				<input class="ui green button" type="button" style="width:100%;" id="leaderBtn" value="확인" />	
			</div>
		</div>
		<div class="container" style="display:none;">
			<div class="ui ignored message">
		    	공동작업자가 있는 경우, 작업자 정보를 입력해주세요.
		    </div>
			<!-- 공동작업자 1 -->
			<div class="ui stacked segment">
				<span class="ui red ribbon label" style="margin-bottom:10px;">공동작업자1</span>
				<div id="step1" >
					<div class="field">
						<input type="text" name="empName"  placeholder="이름"/>
						<input type="hidden" name="cellphone"  placeholder="휴대폰번호"/>
					</div>
			    </div>
			</div>
			<!-- 공동작업자 2 -->
			<div class="ui stacked segment">
				<span class="ui orange ribbon label" style="margin-bottom:10px;">공동작업자2</span>
				<div id="step1" >
					<div class="field">
						<input type="text" name="empName"  placeholder="이름"/>
						<input type="hidden" name="cellphone"  placeholder="휴대폰번호"/>						
					</div>
			    </div>
			</div>
			<!-- 공동작업자 3 -->
			<div class="ui stacked segment">
				<span class="ui teal ribbon label" style="margin-bottom:10px;">공동작업자3</span>
				<div id="step1" >
					<div class="field">
						<input type="text" name="empName"  placeholder="이름"/>
						<input type="hidden" name="cellphone"  placeholder="휴대폰번호"/>						
					</div>
			    </div>
			</div>
			<!-- 공동작업자 4 -->
			<div class="ui stacked segment">
				<span class="ui blue ribbon label" style="margin-bottom:10px;">공동작업자4</span>
				<div id="step1" >
					<div class="field">
						<input type="text" name="empName"  placeholder="이름"/>
						<input type="hidden" name="cellphone"  placeholder="휴대폰번호"/>						
					</div>
			    </div>
			</div>
			<button class="ui green button" id="submitBtn" type="button" style="width:100%;">입력 완료</button>	
		</div>
	</form>
</body>

</html>
