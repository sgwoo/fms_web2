<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" /> 
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta name="robots" content="noindex, nofollow">
<style type="text/css">

/* body 공통 속성 */ 
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '나눔고딕';}
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0;}

/* 레이아웃 큰박스 속성 */
#wrap {float:left; margin:0 auto; width:100%; background-color:#f3f3f6;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%; height:500px;}
#footer {float:left; width:100%; height:50px; background:#C3C3C3; margin-top:20px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* 로고 */
#gnb_box {float:left; width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_logo {float:left; height:34px; padding:12px 0 0 24px; color:#fff; font-weight:bold;}
#gnb_right{float:right;}

/* 로그인 */
#ub_login {float:center; width:100%; height:70px;}
#ub_loginbox { height:70px; border:2px solid #c9c9c9; margin: 0px 10px; 0px 10px; padding:10px 0px;}
#ub_login dd {width:90%; float:left; vertical-align:top; color:#000; font-size:13px; margin:0px 10px;}
#ub_login dd.upw {margin-top:6px;}
#ub_login .input_text{border:1px solid #c9c9c9; width:100%; height:18px; color:#444; font-size:13px; margin:0px 10px;}
#ub_login #uid {background:#fff; margin=0px -10px;}
#ub_login #upw {background:#fff;  margin=0px -10px;}
#ub_login p.keeping {float:right;}
#ub_login p.log_in_etc {float:right; padding:7px 0 0 0px; .padding:3px 0 0 0; color:#000; font-size:13px; width:100%;}
#ub_login p.log_in_etc input {vertical-align:-2px;}
#ub_login_img {float:left; margin:45px 0 0 70px;}


/* Login */
#Login fieldset {border:1px solid #e5e5e5; background-color:#f8f8f8; padding:20px 20px;}
#Login .error {text-align:center; margin-bottom:25px;}

#Login .userform {width:100%; overflow:hidden; position:relative;}
#Login .userform li {line-height:100%;} 
#Login .userform .userinput {padding-right:92px;}
#Login .userform .userinput input.text {border:1px solid #c9c9c9; width:100%; height:22px; font-weight:bold; font-size:0.95em; vertical-align:top;}
#Login .userform .userid {margin-bottom:2px; width:100%; height:30px;}
#Login .userform .userpw {width:100%; height:34px;}
#Login .userform .submit {position:absolute; right:0; top:0;}



#Login .userform .userid.alt input.text {background:url(/images/common/login/bg_input_id2.gif) no-repeat 10px 50% #fff;}
#Login .userform .userpw.alt input.text {background:url(/images/common/login/bg_input_pw2.gif) no-repeat 10px 50% #fff; font-size:0.95em;}
* html #Login .userform .userid {margin-bottom:2px;}
* html #Login .userform .userid {margin-bottom:6px;}

#Login p.log_in_etc {float:right; padding:7px 0 0 0px; .padding:3px 0 0 0; color:#000; font-size:13px; width:100%;}
#Login p.log_in_etc input {vertical-align:-2px;}


</style>

<script language="JavaScript" src="/smart/include/info.js"></script>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="acar.database.* ,acar.util.*, acar.user_mng.*, acar.off_anc.*, acar.attend.*"%>



<%
	LoginBean login 	= LoginBean.getInstance();
	OffAncDatabase oad 	= OffAncDatabase.getInstance();	
	SecurityUtil securityUtil 	= new SecurityUtil();

	String login_yn = "";
	String user_nm = "";
	String end_dt = "";
	String cur_dt = "";
	String attend_login_dt = "";
	String loan_st = "";

	String s_width 	= request.getParameter("s_width")==null?	"":request.getParameter("s_width");
	String s_height = request.getParameter("s_height")==null?	"":request.getParameter("s_height");
	String name 	= request.getParameter("name")==null?		"":request.getParameter("name");
	String passwd 	= request.getParameter("passwd")==null?		"":request.getParameter("passwd");
	String open_type= request.getParameter("open_type")==null?	"1":request.getParameter("open_type");
	String user_id 	= "";
	String dept_id = "";
	String en_pass="";

	if(login.hasCookie(request, "acar_id")){
	    	         
		if((name.length() > 0) && (passwd.length() > 0)){
		
			int result = login.getLogin(name, passwd, response, request);
		//	int result = login.getLogin(name, passwd, response);
			
			if(result == 1){
				login_yn="r_ok";
			
	//			user_nm=login.getAcarName(request, "acar_id");
				user_id 		= login.getSessionValue(request, "USER_ID");	
			    dept_id 		= login.getSessionValue(request, "DEPT_ID");	
			    user_nm			= login.getSessionValue(request, "USER_NM");
							
				login.setDisplayCookie(s_width, s_height, response);//디스플레이 사이즈 쿠키설정
				//로그인처리----------------------------------------------------------------------------------
				String login_time 	= Util.getLoginTime();//로그인시간
				String login_ip 	= request.getRemoteAddr();//로그인IP
		//		String user_id 		= login.getCookieValue(request, "acar_id");
				System.out.println("[로그인 smart] DT:"+login_time+", ID:"+user_id+"("+login.getAcarName(request, "acar_id")+")");
				//ip_log 등록
				int count = oad.insertLoginLog(login_ip, user_id, login_time);
				//로그인처리----------------------------------------------------------------------------------
			}else if( result == 2){
				login_yn="db_error";
			}else{
				login_yn="no_id";
			}
		
		}else{
			login_yn="no";
		}
		end_dt=login.getEndDt(request,"acar_id");
		cur_dt=Util.getDate(4);		
		user_nm			= login.getSessionValue(request, "USER_NM");
	}else{
		if( (name.length() > 0) && (passwd.length() > 0)){
			
		//      out.println("ccc"+ name);
		//	int result = login.getLogin(name, passwd, response);
			int result = login.getLogin(name, passwd, response, request);
	//	     System. out.println("ddd"+ result);
			if(result == 1){
				login_yn="ok";
				user_nm			= login.getSessionValue(request, "USER_NM");				
			}else if( result == 2){
				login_yn="db_error";
			}else{
				login_yn="no_id";
			}
		
		}else{
			login_yn="no";
		}
	}
	
%>
<SCRIPT LANGUAGE="JavaScript">
<!--
	var s_width = screen.width;
	var s_height = screen.height;

	function EnterDown(){
		var keyValue = event.keyCode;
		if (keyValue =='13') submitgo();
	}
	function submitgo(){
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
		theForm.action = "index.jsp";
		theForm.submit();
	}		
//-->
</SCRIPT>


<BODY BGCOLOR=#FFFFFF LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0
<%	if(login_yn.equals("no_id")){%>
	onLoad="javascript:document.flogin.name.focus();"
<%	}else if(login_yn.equals("ok")){%>
	onLoad="javascript:submitgo();"
<%	}else if(login_yn.equals("r_ok")){%>
	onLoad="javascript:OpenAmazonCAR('1','<%=end_dt%>','<%=cur_dt%>','<%=session.getAttribute("USER_ID") %>','<%=attend_login_dt%>','<%=loan_st%>','<%=dept_id%>');"
<%	}else if(login_yn.equals("db_error")){%>
	onLoad="javascript:OpenAmazonCAR('4','<%=end_dt%>','<%=cur_dt%>','<%=session.getAttribute("USER_ID") %>','','','<%=dept_id%>');"
<%	}else{%>
	onLoad="javascript:document.flogin.name.focus();"
<%	}%>>
<!--	onLoad="javascript:document.flogin.name.focus();"-->
<form name="flogin" method="post" action='index.jsp'>
  <input type='hidden' name="s_width" value="">     
  <input type='hidden' name="s_height" value="">
  <input type='hidden' name="login_yn" value="<%=login_yn%>">
  <input type="hidden" name="cv" value="<%= securityUtil.encodeAES(Webconst.Common.FMS3_COOKIE_VALUE+name+"|"+user_id) %>" />
<div id="wrap">
    <div id="header">
        <div id="gnb_box">
        	<div id="gnb_logo"></div>
        </div>
    </div>
    <div id="contents">
    	<div id="Login">
	        <fieldset>
				<div class="userform">
				<div class="userinput">
					<p class="userid"><input type="text"     name="name"   id="name"    class="text"  value='<%=name%>'    title="아이디를 입력하세요."/></p>
					<p class="userpw"><input type="password" name="passwd" id="passwd"  class="text"  value='<%=passwd%>'  title="비밀번호를 입력하세요."/></p>
				</div>
				<div class="submit"><a onClick='submitgo();' style='cursor:hand'><img src="images/btn_log_in.jpg" alt="로그인" value="로그인"></a></div>
				</div>
				
			</fieldset>
		</div>
		<p>
		<div id="ment">
			<center>시스템 로그인 ID <b><font color=red>도용 및 외부유출</font></b>로 피해를 주는 경우가 있어, 이에 대한 IP추적, 해킹시도 등이 발견될 시에는 형사고발 조치될 수 있습니다.</center>
		</div>
    </div>
    <div id="footer"></div>
</div>
<br>
<br>
<script language="javascript">
<%	if(login_yn.equals("no_id")){	%>
	alert('등록된 사용자가 아닙니다. ID, PASSWORD를 확인하십시요.');
<%	}	%>
<%	if(login_yn.equals("db_error")){	%>
	alert('데이타베이스 에러입니다.');
<%	}	%>


</script>
</form>
</body>
</html>