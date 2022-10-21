<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.database.* ,acar.util.*, acar.user_mng.*, acar.off_anc.*, acar.attend.*"%>
<jsp:useBean id="aa_db" scope="page" class="acar.attend.AttendDatabase"/>


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

  	String bInfo = request.getHeader("user-agent");
  	
  	String mobileCheck = "";
    String userAgent = request.getHeader("user-agent");
    //System.out.println("userAgent"+userAgent);
    
    String[] browser = {"iPhone", "iPad", "iPod", "Android", "BlackBerry", "IEMobile", "Opera Mini"};
	for (int i = 0; i < browser.length; i++) {
		if (userAgent.matches(".*"+browser[i]+".*")) {
			mobileCheck = "1";
			break;
		}
	}	
//	System.out.println(mobileCheck);
    
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
	
	String user_id = "";
	String dept_id = "";
	String en_pass = "";

	String s_width = request.getParameter("s_width")==null?"":request.getParameter("s_width");
	String s_height = request.getParameter("s_height")==null?"":request.getParameter("s_height");
	String name = request.getParameter("name")==null?"":request.getParameter("name");
	String passwd = request.getParameter("passwd")==null?"":request.getParameter("passwd");
	String kakao_id = request.getParameter("kakao_id")==null?"":request.getParameter("kakao_id");
	String kakao_email = request.getParameter("kakao_email")==null?"":request.getParameter("kakao_email");
	String open_type = request.getParameter("open_type")==null?"1":request.getParameter("open_type");
	String new_menu = request.getParameter("new_menu")==null?"":request.getParameter("new_menu");	
	
	String return_user_id = umd.getKakaoMap(kakao_id);
	String return_kakao_id = umd.getKakao(kakao_id);
	
	if (name.equals("")) {
		name = return_user_id;
	}
		
	if (login.isLogin(request)) {
		
		if (name.length() > 0) {
		  
			int result = login.getKakaoLogin(name, response, request);
			
			if (result == 1) {
			
				user_id = login.getSessionValue(request, "USER_ID");
			    dept_id = login.getSessionValue(request, "DEPT_ID");
			    user_nm = login.getSessionValue(request, "USER_NM");
			   
			    login_yn="r_ok";
				
				//디스플레이 사이즈 쿠키설정
				login.setDisplayCookie(s_width, s_height, response);
				
				//로그인처리----------------------------------------------------------------------------------
				String login_time = Util.getLoginTime();//로그인시간
				String login_ip = request.getRemoteAddr();//로그인IP
				String mobile_status = mobileCheck;
				//System.out.println(mobile_status);
				int count = 0;
			
				if (!user_id.equals("")) {
					String attend_dt1 = "";
					String attend_dt2 = "";
					attend_dt1 = aa_db.getAttendDate(user_id);
					//ip_log 등록
					String mobile_yn = mobileCheck.equals("1") ? "Y" : "N";
					// count = oad.insertLoginLog2(login_ip, user_id, login_time, kakao_id, kakao_email);
					count = oad.insertLoginLog2(login_ip, user_id, login_time, kakao_id, kakao_email, mobile_yn);
					int chk_count = oad.attendChk(user_id);//7시이후 로그인
					//출근관리
					if (chk_count ==0) {
						//count = oad.attend(login_ip, user_id, login_time);
						count = oad.attend2(login_ip, user_id, login_time, mobile_status);
						System.out.println("[로그인 FMS] DT:"+login_time+", ID:"+user_id+"("+user_nm+")");
					}
					//출근시간 체크
					attend_dt2 = aa_db.getAttendDate(user_id);
					if (attend_dt1.equals("") && !attend_dt2.equals("")) {
						attend_login_dt = attend_dt2;
						//자체탁송 지원자 대상여부
						UsersBean user_bean = umd.getUsersBean(user_id);
						loan_st = user_bean.getLoan_st();
					}
				}
				
			//로그인처리----------------------------------------------------------------------------------
			} else if ( result == 2) {
				login_yn="db_error";
			} else {
				login_yn="no_id";
			}
		
		} else {
			//login_yn="no";
			if (kakao_id.equals("")) {
				login_yn = "no";
			} else {
				login_yn = "no_kakao";
			}
		}
		
	} else {

		if (return_kakao_id.equals("")) {
			//System.out.println("가입X");
			if (kakao_id.equals("")) {
				login_yn = "no";
			} else {
				login_yn = "no_kakao";
			}
		} else {
			//System.out.println("가입O");
			//등록된 kakao_id로 저장된 FMS ID return
			return_user_id = umd.getKakaoMap(kakao_id);
			
			int result = login.getKakaoLogin(return_user_id, response, request);
			if (result == 1) {
				login_yn="ok";
			} else if (result == 2) {
				login_yn="db_error";
			} else {
				login_yn="no_id";
			}
		}
	}
	
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>::: FMS 로그인:::</title>
</head>
<script language="JavaScript" src="/include/info_fms2.js"></script>
<script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
<script src="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script> 
<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css">
<script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>

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
	var broswerInfo = navigator.userAgent;
		
	if (broswerInfo.indexOf("MY_HYBRID_APP") != -1) {
		window.location.href = 'https://accounts.kakao.com/login?continue=https%3A%2F%2Fkauth.kakao.com%2Foauth%2Fauthorize%3Fproxy%3DeasyXDM_Kakao_ym4l41zl87o_provider%26ka%3Dsdk%252F1.39.6%2520os%252Fjavascript%2520sdk_type%252Fjavascript%2520lang%252Fko-KR%2520device%252FWin32%2520origin%252Fhttp%25253A%25252F%25252F211.52.73.106%25253A8088%26origin%3Dhttp%253A%252F%252F211.52.73.106%253A8088%26response_type%3Dcode%26redirect_uri%3Dkakaojs%26state%3Dforukn36o7dxlk5ozzkpsd%26client_id%3D4419b2a3a6bac750d7b19ffd37d7b995';
		return;
		
	} else {
		//open login
		
		if (!Kakao.Auth.getAccessToken()) {
			
			Kakao.Auth.loginForm({ //loginForm, login
				//throughTalk: true,
				success: function(authObj) {
					Kakao.API.request({	
						url: '/v2/user/me',		
						success: function(res) {
							//alert(JSON.stringify(res)); //kakao.api.request 에서 불러온 결과값 json형태로 출력
							//alert(res.id);
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
			
		} else {
			
			Kakao.Auth.login({ //loginForm, login
				throughTalk: true,
				success: function(authObj) {
					Kakao.API.request({	
						url: '/v2/user/me',		
						success: function(res) {
							//alert(JSON.stringify(res)); //kakao.api.request 에서 불러온 결과값 json형태로 출력
							//alert(res.id);
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
			
		}
		
	}	
};    

function logoutWithKakao() {
	/* if (!Kakao.Auth.getAccessToken()) {
		console.log('Not logged in.');
	  	return;
	} */
	
	/* Kakao.Auth.logout(function() {
		console.log(Kakao.Auth.getAccessToken());
	}); */
	
	/* Kakao.API.request({
		url: '/v1/user/unlink',
		success: function(response) {
			console.log(response);
		},
		fail: function(error) {
			console.log(error);
		},
	}); */	
}
</script>
<script type="text/javascript"> 
$(document).bind("mobileinit", function(){
	$.mobile.ajaxLinksEnabled=false;
	$.mobile.ajaxFormsEnabled=false;
	$.mobile.ajaxEnabled=false;
});
</script>
<SCRIPT LANGUAGE="JavaScript">
<!--
	
	var s_width = screen.width;
	var s_height = screen.height;

	/* function EnterDown(){
		var keyValue = event.keyCode;
		if (keyValue =='13') submitgo();
	} */
	
	function submitgo() {
   		var theForm = document.flogin;

	   	theForm.s_width.value = s_width;		
		theForm.s_height.value = s_height;
		
		if (theForm.name.value == "2002010") {
			theForm.s_height.value = s_height-40;
		}
	
		theForm.submit();
	}
	
	function updPass() {
		var SUBWIN="/acar/menu/pass_u.jsp?info=<%=user_id%>";	
		window.open(SUBWIN, "InfoUpPhoto", "left=300, top=250, width=430, height=300, scrollbars=no");
	}
	
	//kakao 계정등록
	function reg_users() {
		var SUBWIN="/fms2/reg_users.jsp";	
		window.open(SUBWIN, "kakaoRegUsers", "left=300, top=250, width=800, height=600, scrollbars=no");
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
	/* padding:20px; */
	width:350px;
	height:150px;
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
.form-control{
	margin:10px 0px;
}

/* button-div */
.custom-control{
	width: 100%;
	height: 60%;
	padding-top: 5%;
}
.left-control{
	float: left;
	width: 225px;
}
.right-control{
	float: right;
	width: 225px;
}
.kakao_button{
	background-color: #f7e317; 
	color: #3c1e1e;
	font-weight: bold;
	text-align: center; 
	border-radius: 5px; 
	padding: 15px; 
	margin: 10px;
	cursor: pointer;
}
.kakao_button2{
	background-color: #349BD4; 
	color: #FFF;
	font-weight: bold;
	text-align: center; 
	border-radius: 5px; 
	padding: 30px; 
	margin: 10px;
	cursor: pointer;
	font-size: 20px;
    letter-spacing: 0.5;
}
.info_button{
	/* background-color: #1ebb30;  */
	/* color: #FFF; */
	color: #000;
	font-weight: bold;
	text-align: left; 
	border-radius: 5px; 
	/* padding: 15px; */ 
    padding: 5px 0px 5px 15px;
	margin: 10px;
	cursor: pointer;
}
.text_bold_title{
	font-weight: bold;
}
.text_bold{
	font-weight: bold;
	color: #349BD4;
}
.text_bold_red{
	font-weight: bold;
	color: red;
}
.ui-loader-default{
	display: none !important;
}
</STYLE>
<BODY BGCOLOR=#FFFFFF LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0
<%if (login_yn.equals("no_id")) {%>
	onLoad="javascript:document.flogin.name.focus();"
<%} else if(login_yn.equals("ok")) {%>
	onLoad="javascript:submitgo();"
<%} else if(login_yn.equals("r_pass")) {%>
	onLoad="javascript:updPass();"	
<%} else if(login_yn.equals("r_ok")) {%>
	onLoad="javascript:OpenAmazonCAR('1','<%=session.getAttribute("USER_ID") %>','<%=open_type%>','<%=dept_id%>');"
<%} else if(login_yn.equals("db_error")) {%>
	onLoad="javascript:OpenAmazonCAR('4','<%=session.getAttribute("USER_ID") %>','<%=open_type%>','<%=dept_id%>');"
<%} else {%>
	onLoad="javascript:document.flogin.name.focus();"
<%}%>>

<form name="flogin" method="post">
	<input type="hidden" name="cv" value="<%= securityUtil.encodeAES(Webconst.Common.FMS3_COOKIE_VALUE+name+"|"+user_id) %>" />
	<input type='hidden' name="s_width" value="">     
	<input type='hidden' name="s_height" value="">
	<input type='hidden' name="login_yn" value="<%=login_yn%>">
	<input type='hidden' name="open_type" value="">
	<input type='hidden' name="kakao_id" id="kakao_id" value="<%=kakao_id%>">
	<input type='hidden' name="kakao_email" id="kakao_email" value="<%=kakao_email%>">
	<input type="hidden" name="name" value="<%=name%>">
     
	<div class="top-header">
		<h2><!-- <img src="/fms2/images/login_img.png"/>FMS 로그인--></h2>
	</div>
	
	<div style="text-align: center !important; padding-top: 40px;">
		<h2>아마존카 FMS에 오신것을 환영합니다 !!</h2>
	</div>
	
	<div class="login-area">
		<div class="form-control custom-control">
			<!-- <div class="left-control">
				<div class="kakao_button" onclick="reg_users();">
					설정(카카오계정)
					○ 최초계정등록
				</div>
			</div> -->
			<!-- <div class="right-control"> -->
			<div>
				<!-- <a onclick="loginWithKakao();" style="cursor: pointer;">
					<img class="login-social-image" src="/images/kakao_login_btn.png"/>
				</a> -->
				<div class="kakao_button2" onclick="loginWithKakao();">
					FMS<br>로그인
				</div>
			</div>
		</div>
	</div>
	<div class="ment" style="text-align: center !important; width: 350px; margin: 0 auto;">
		<div class="kakao_button" onclick="reg_users();">
			설정(카카오계정) - 최초계정등록
		</div>
		<div class="info_button" onclick="window.open('/fms2/fms_used.pdf')">
			1. FMS 카카오 연동 및 로그인 가이드(PDF)
		</div>
		<div class="info_button" onclick="window.open('/fms2/fms_used_help.pdf')">
			2. 브라우저별 문제 해결 가이드(PDF)
		</div>
		<div class="info_button" onclick="window.open('/fms2/fms_auto_com.pdf')">
			3. 브라우저별 자동 완성 가이드(PDF)
		</div>
	</div>
</form>
<br>
<br>

<script language="javascript">
<%if ( isMobile( bInfo ) ) {%>
	document.flogin.open_type.value = "2";
<%} else {%>
	document.flogin.open_type.value = "1";
<%}%>

<%if (login_yn.equals("no_id")) {%>
	alert('등록된 사용자가 아닙니다. ID, PASSWORD를 확인하십시요.');
<%}%>

<%if (login_yn.equals("no_kakao")) {%>
	alert('카카오계정이 등록된 사용자가 아닙니다.\n카카오계정을 등록 후 로그인하세요.');
	location.replace("/fms2/login_step1.jsp");
<%}%>

<%if (login_yn.equals("db_error")) {%>
	alert('데이타베이스 에러입니다.');
<%}%>
</script>
</body>
</html>
