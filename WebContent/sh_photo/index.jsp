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
		alert("�ڵ�����ȣ�� ���ڸ� �Է����ּ���");
		$("#cellphone").val(cellphone.replace("-",""));
		$("#cellphone").focus();
	}

	return flag;
}

$(document).ready(function(){
	
	$("#leaderBtn").click(function(){
		
		var name = $("#empName").val();
		var cellphone = $("#cellphone").val();
		
		//�̸�, �ڵ�����ȣ validation 
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
			alert("�̸�, �ڵ�����ȣ�� ��� �Է����ּ���");
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
						<label>��ǥ �۾��� �̸�</label> <input type="text" name="empName" id="empName"/>
					</div>
					<div class="field">
						<label>�ڵ�����ȣ</label> <input type="text" name="cellphone" id="cellphone" placeholder="���ڸ� �Է����ּ���"/>
					</div>
			    </div>
				<br/>
				<input class="ui green button" type="button" style="width:100%;" id="leaderBtn" value="Ȯ��" />	
			</div>
		</div>
		<div class="container" style="display:none;">
			<div class="ui ignored message">
		    	�����۾��ڰ� �ִ� ���, �۾��� ������ �Է����ּ���.
		    </div>
			<!-- �����۾��� 1 -->
			<div class="ui stacked segment">
				<span class="ui red ribbon label" style="margin-bottom:10px;">�����۾���1</span>
				<div id="step1" >
					<div class="field">
						<input type="text" name="empName"  placeholder="�̸�"/>
						<input type="hidden" name="cellphone"  placeholder="�޴�����ȣ"/>
					</div>
			    </div>
			</div>
			<!-- �����۾��� 2 -->
			<div class="ui stacked segment">
				<span class="ui orange ribbon label" style="margin-bottom:10px;">�����۾���2</span>
				<div id="step1" >
					<div class="field">
						<input type="text" name="empName"  placeholder="�̸�"/>
						<input type="hidden" name="cellphone"  placeholder="�޴�����ȣ"/>						
					</div>
			    </div>
			</div>
			<!-- �����۾��� 3 -->
			<div class="ui stacked segment">
				<span class="ui teal ribbon label" style="margin-bottom:10px;">�����۾���3</span>
				<div id="step1" >
					<div class="field">
						<input type="text" name="empName"  placeholder="�̸�"/>
						<input type="hidden" name="cellphone"  placeholder="�޴�����ȣ"/>						
					</div>
			    </div>
			</div>
			<!-- �����۾��� 4 -->
			<div class="ui stacked segment">
				<span class="ui blue ribbon label" style="margin-bottom:10px;">�����۾���4</span>
				<div id="step1" >
					<div class="field">
						<input type="text" name="empName"  placeholder="�̸�"/>
						<input type="hidden" name="cellphone"  placeholder="�޴�����ȣ"/>						
					</div>
			    </div>
			</div>
			<button class="ui green button" id="submitBtn" type="button" style="width:100%;">�Է� �Ϸ�</button>	
		</div>
	</form>
</body>

</html>
