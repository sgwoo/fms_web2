<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.database.* ,acar.util.*, acar.user_mng.*, acar.off_anc.*, acar.attend.*"%>

<%!
  public String[] mobileTags = { "cellphone",
                                  "iemobile",
                                  "midp",
                                  "mini",
                                  "mmp",
                                  "mobile",
                                  "nokia",
                                  "pda",
                                  "phone",
                                  "pocket",
                                  "ppc",
                                  "psp",
                                  "symbian",
                                  "up.browser",
                                  "up.link",
                                  "wap",
                                  "android",
                                  "iPhone",                                                           
                                  "windows ce" };
  
  public Boolean isMobile( String browserInfo )
  {
    for ( int n=0; n<mobileTags.length; n++ )
    {
      if ( browserInfo.toLowerCase().contains( mobileTags[n].toLowerCase() ) )
      {
        return true;
      }
    }
    return false;
  }
%>

<%
	Enumeration e;	
	e = request.getHeaderNames();

  	String bInfo = request.getHeader( "user-agent" );
    
%>

<%
	LoginBean login = LoginBean.getInstance();
	OffAncDatabase oad = OffAncDatabase.getInstance();	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	SecurityUtil securityUtil = new SecurityUtil();
	
	String login_yn = "";
	String user_nm = "";
	String end_dt = "";
	String cur_dt = "";
	String attend_login_dt = "";
	String loan_st = "";
	int kakao_count = 0;

	String s_width = request.getParameter("s_width")==null?	"":request.getParameter("s_width");
	String s_height = request.getParameter("s_height")==null?"":request.getParameter("s_height");
	String name = request.getParameter("name")==null?"":request.getParameter("name");
	String passwd = request.getParameter("passwd")==null?"":request.getParameter("passwd");
	String kakao_id = request.getParameter("kakao_id")==null?"":request.getParameter("kakao_id");
	String kakao_email = request.getParameter("kakao_email")==null?"":request.getParameter("kakao_email");
	String use_yn = request.getParameter("use_yn")==null?"N":request.getParameter("use_yn");
	String open_type = request.getParameter("open_type")==null?	"1":request.getParameter("open_type");
	String new_menu = request.getParameter("new_menu")==null?	"":request.getParameter("new_menu");
	
	String user_id = "";
	String dept_id = "";
	String en_pass = "";	
	
	if (use_yn.equals("N")) {
	
		if (login.isLogin(request)) {
		
			if ((name.length() > 0) && (passwd.length() > 0)) {
			  
				int result = login.getLogin(name, passwd, response, request);
				
				//로그인처리----------------------------------------------------------------------------------
				if (result == 1) {
				
				    user_id = login.getSessionValue(request, "USER_ID");
				    dept_id = login.getSessionValue(request, "DEPT_ID");
				    user_nm = login.getSessionValue(request, "USER_NM");
						
					String return_kakao_id = umd.getKakao(kakao_id);
					if (return_kakao_id.equals("")) {
						login_yn="r_ok";
					} else {
						login_yn="duplicate";
					}
					
					// 에이전트 및 협력업체는 등록하지 않도록 한다.
					if(dept_id.equals("") || dept_id.equals("1000") || dept_id.equals("8888")){
						login_yn = "chk_agent_off";
					}
				
				} else if ( result == 2) {
					login_yn="db_error";
				} else {
					login_yn="no_id";
				}
			
			} else {
				login_yn="no";
			}
		} else {
			
			if ((name.length() > 0) && (passwd.length() > 0)) {
			
				int result = login.getLogin(name, passwd, response, request);
				
				if (result == 1) {
					login_yn="ok";
				} else if ( result == 2) {
					login_yn="db_error";
				} else {
					login_yn="no_id";
				}
			
			} else {
				login_yn="no";
			}
		}
		
	} else if (use_yn.equals("Y")) {
		
		user_id = login.getSessionValue(request, "USER_ID");
	    dept_id = login.getSessionValue(request, "DEPT_ID");
	    user_nm = login.getSessionValue(request, "USER_NM");
	    
	 	// 에이전트 및 협력업체는 등록하지 않도록 한다.
 		if(dept_id.equals("") || dept_id.equals("1000") || dept_id.equals("8888")){
 			login_yn = "chk_agent_off";
 		} else { 			
			String return_kakao_id = umd.getKakao(kakao_id);
			if (return_kakao_id.equals("")) {
				kakao_count = umd.insertKakaoMap(user_id, name, kakao_id, kakao_email, use_yn);
			} else {
				kakao_count = -1;
			}
 		}
		
	}
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>::: FMS 로그인 - 카카오계정등록:::</title>
</head>
<script language="JavaScript" src="/include/info_fms2.js"></script>
<script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
<script src="https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script> 
<link rel="stylesheet" href="https://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type='text/javascript'>
//<![CDATA[
// 사용할 앱의 JavaScript 키를 설정해 주세요.
Kakao.init("4419b2a3a6bac750d7b19ffd37d7b995");
function loginWithKakao() {
	
	var theForm = document.flogin;
   	if(theForm.name.value==""){
		alert("ID를 입력하십시요.");
		theForm.name.focus();
  		return;
	}
	
  	if(theForm.passwd.value==""){
		alert("패스워드를 입력하십시요.");
		theForm.passwd.focus();
  		return;
	}
	
	// 로그인 창을 띄웁니다.
	Kakao.Auth.loginForm({ //loginForm, login
		success: function(authObj) {
			Kakao.API.request({
				url: '/v2/user/me',
				success: function(res) {
					//alert(JSON.stringify(res)); //<---- kakao.api.request 에서 불러온 결과값 json형태로 출력
					//alert(res.id);
					//alert(res.kakao_account.email);
					var kakao_id = res.id;
					var kakao_email = res.kakao_account.email;
					$("#kakao_id").val(kakao_id);
					$("#kakao_email").val(kakao_email);
					submitgo();
				},
				fail: function(err) {
					alert("정보제공에 동의 설정후 다시 요청부탁드립니다.");
				}
			})
		},
		fail: function(err) {
		  alert("관리자에게 문의해주세요.");
		}
	});
};
</script>
<script type="text/javascript">
$(document).bind("mobileinit", function(){
	$.mobile.ajaxLinksEnabled = false;
	$.mobile.ajaxFormsEnabled = false;
	$.mobile.ajaxEnabled = false;
});
</script>

<SCRIPT LANGUAGE="JavaScript">
<!--
	
	var s_width = screen.width;
	var s_height = screen.height;

	function EnterDown() {
		var keyValue = event.keyCode;
		//if (keyValue =='13') submitgo();
		if (keyValue =='13') {
			loginWithKakao();
		}
	}
	
	function submitgo() {
   		var theForm = document.flogin;
	   	if(theForm.name.value==""){
   			alert("ID를 입력하십시요.");
   			theForm.name.focus();
	   		return;
   		}
   		
	   	if(theForm.passwd.value==""){
   			alert("패스워드를 입력하십시요.");
   			theForm.passwd.focus();
	   		return;
   		}

	   	theForm.s_width.value = s_width;
		theForm.s_height.value = s_height;
		
		if(theForm.name.value == "2002010"){
			theForm.s_height.value = s_height-40;
		}
	
		theForm.submit();
	}	
	
	function updPass() {
		var SUBWIN="/acar/menu/pass_u.jsp?info=<%=user_id%>";
		window.open(SUBWIN, "InfoUpPhoto", "left=300, top=250, width=430, height=300, scrollbars=no");
	}
	
	//kakao 중복체크
	function duplicate_kakao() {
		alert("이미 카카오계정이 등록되어 있는 사용자 입니다. 로그인하세요.");
		location.replace("/fms2/reg_users.jsp");
		return;
	}
	
	//kakao 등록
	function reg_kakao(name, kakao_id, kakao_email) {
		if(confirm("현재 카카오 정보로 등록하시겠습니까?")){
			//alert("name: " + name + " kakao_id: " + kakao_id + " kakao_email: " + kakao_email);
			location.replace("/fms2/reg_users.jsp?name=" + name + "&kakao_id=" + kakao_id + "&kakao_email=" + kakao_email + "&use_yn=Y");
		}else{
			return false;
		}
	}
	
//-->
</SCRIPT>
<STYLE>
@import url(//cdn.jsdelivr.net/font-nanum/1.0/nanumbarungothic/nanumbarungothic.css);
@font-face {
  font-family: 'Nanum Square';
  font-style: normal;
  font-weight: 400;
  src: url(/fms2/menu/font/NanumSquareR.eot);
  src: local('Nanum Square Regular'),
       local('NanumSquareR'),
       url(/fms2/menu/font/NanumSquareR.eot?#iefix) format('embedded-opentype'),
       url(/fms2/menu/font/NanumSquareR.woff2) format('woff2'),
       url(/fms2/menu/font/NanumSquareR.woff) format('woff'),
       url(/fms2/menu/font/NanumSquareR.ttf) format('truetype');
}
*{
	font-family:'Nanum Barun Gothic';
}
body{
	background-color:#ebeced;
}
.top-header{
	background-color:#349BD4;
	width:100%;
	color:#fff;
	text-align:center;
	font-size:40px;
	padding:15px;
	margin-bottom:50px;
}
.top-header img{
	margin-bottom:-15px;
	margin-right:10px;
}
.top-header h2{
	font-size:40px;
	font-family:'Nanum Square';
	margin:0px;
}
.login-area{
	padding:20px;
	width:500px;
	height:300px;
	margin:0 auto;
	/* border:1px solid #b7bac0; 
	background-color:#fff; */
	text-align:center;
}
.text{
	width:300px !important;
	height:30px !important;
}
label{
	color:#6c7382;
	line-height:22px;
	font-size:13px;
	font-weight:bold;
}
.label_css{
	color:#000;
	line-height:22px;
	font-size:13px;
	font-weight:bold;
	cursor: text;
}
.input_btn{
	width:300px;
	height:50px;
	background-color:#349BD4;
	color:#fff;
	border:0px;
	outline:0px;
	padding:10px;
	font-size:16px;
	border-radius:5px;
}
.login-form-control{
	ling-height:30px;
	width:300px;
	margin:0 auto;
	margin-top:30px;
	text-align:left;
}
.login-form-control2{
	ling-height:30px;
	width:300px;
	margin:0 auto;
	margin-top:10px;
	text-align:left;
}
.form-control{
	margin:10px 0px;
}

/* 팝업창 스크롤 히든처리 */
html {overflow:hidden;}

/* button-div */
.custom-control{
	width: 100%;
	height: 60%;
	padding-top: 23%;
}
.left-control{
	float: left;
}
.right-control{
	float: right;
}
.kakao_button{
	background-color: #f7e317; 
	color: #3c1e1e;
	font-weight: bold;
	text-align: center; 
	border-radius: 5px; 
	padding: 40px; 
	margin: 10px;
	cursor: pointer;
}
.ui-loader-default{
	display: none !important;
}

</STYLE>
<BODY BGCOLOR=#FFFFFF LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0
<%	if(login_yn.equals("no_id")){%>
	onLoad="javascript:document.flogin.name.focus();"
<%	}else if(login_yn.equals("ok")){%>
	onLoad="javascript:submitgo();"
<%	}else if(login_yn.equals("r_pass")){%>
	onLoad="javascript:updPass();"	
<%	}else if(login_yn.equals("r_ok")){%>
	onLoad="javascript:reg_kakao('<%=name%>','<%=kakao_id%>','<%=kakao_email%>');"
<%	}else if(login_yn.equals("duplicate")){%>
	onLoad="javascript:duplicate_kakao();"
<%	}else if(login_yn.equals("db_error")){%>
	onLoad="javascript:OpenAmazonCAR('4','<%=session.getAttribute("USER_ID") %>','<%=open_type%>','<%=dept_id%>');"
<%	}else{%>
	onLoad="javascript:document.flogin.name.focus();"
<%	}%>
>

<form name="flogin" method="post">
  <input type="hidden" name="cv" value="<%= securityUtil.encodeAES(Webconst.Common.FMS3_COOKIE_VALUE+name+"|"+user_id) %>" />
  <input type='hidden' name="s_width" value="">
  <input type='hidden' name="s_height" value="">
  <input type='hidden' name="login_yn" value="<%=login_yn%>">
  <input type='hidden' name="open_type"	value="">
  <input type='hidden' name="kakao_id" id="kakao_id" value="<%=kakao_id%>">
  <input type='hidden' name="kakao_email" id="kakao_email" value="<%=kakao_email%>">
	<div class="top-header">
		<h2><!-- <img src="/fms2/images/login_img.png"/>FMS 로그인--></h2>
	</div>
	<div class="login-area">		
		<div class="login-form-control">
			<label>아이디</label><br/>
			<input type="text" name="name" value="<%=name%>" class="text" onKeydown="EnterDown()" tabindex=1><br/>
		</div>
		<div class="login-form-control2">
			<label>비밀번호</label><br/>
			<input type="password" name="passwd" value="<%=passwd%>" class="text" onKeydown="EnterDown()" tabindex=2><br/>
		</div>
		<div class="form-control">
			<button type="button" class="input_btn" onclick="javascript:loginWithKakao();" style="cursor: pointer;">로그인</button>
			<!-- <a onclick="loginWithKakao();" style="cursor: pointer;">
				<img class="login-social-image" src="/images/kakao_login_btn.png"/>
			</a> -->
		</div>
	</div>
	<!-- <div class="ment" style="text-align: center !important;">
		<h3>
			<b>
				<font color=red>ID 도용 및 외부유출</font>로 피해가 발생할 경우<br><br>
				이에 대한 불법도용, 해킹시도 등이 발견될 시에는 IP추척을 통하여<br><br>
				형사고발 조치될 수 있습니다.
			</b>
		</h3>
	</div> -->
</form>

<br>
<br>

<script language="javascript">
<% if ( isMobile( bInfo ) ) { %>
	document.flogin.open_type.value = "2";
<% } else { %>
	document.flogin.open_type.value = "1";
<% } %>

<% if (login_yn.equals("no_id")) { %>
	alert('등록된 사용자가 아닙니다. ID, PASSWORD를 확인하십시요.');
	location.replace("/fms2/reg_users.jsp");
<% } %>

<% if (login_yn.equals("db_error")) { %>
	alert('데이타베이스 에러입니다.');
<% } %>

<% if(login_yn.equals("chk_agent_off")){	%>
	alert('에이전트 및 협력업체 사용자는 카카오계정 연동이 불가합니다.\n기존 로그인을 사용 해주세요.');
	location.replace("/fms2/reg_users.jsp");
<% } %>

<% if (kakao_count == 1) { %>
	alert('카카오계정이 정상적으로 등록되었습니다.');
	self.close();
<% } else if (kakao_count == -1) { %>
	alert('이미 등록된 카카오 계정입니다.');
	location.replace("/fms2/reg_users.jsp");
<% } %>
</script>
</body>
</html>
