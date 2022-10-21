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
							
				user_id 		= login.getSessionValue(request, "USER_ID");	
			    dept_id 		= login.getSessionValue(request, "DEPT_ID");	
			    user_nm			= login.getSessionValue(request, "USER_NM");

				login.setDisplayCookie(s_width, s_height, response);//디스플레이 사이즈 쿠키설정
				//로그인처리----------------------------------------------------------------------------------
				String login_time 	= Util.getLoginTime();//로그인시간
				String login_ip 	= request.getRemoteAddr();//로그인IP
			
				int count = 0;
				if(!user_id.equals("")){
					//ip_log 등록
					count = oad.insertLoginLog(login_ip, user_id, login_time);									
				}
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
		
		//	int result = login.getLogin(name, passwd, response);
			int result = login.getLogin(name, passwd, response, request);
			
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

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>:::인트라넷 로그인:::</title>
<script language="JavaScript" src="/acct/include/info.js"></script>
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
		

		if(theForm.name.value == "2002010"){
			theForm.s_height.value = s_height-40;
		}

		theForm.action = "index.jsp";
		theForm.submit();
	}
	
//-->
</SCRIPT>
<style>
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
	border:1px solid #b7bac0; 
	background-color:#fff;
	text-align:center;
}
input{
	width:300px !important;
	height:30px !important;
}
label{
	color:#6c7382;
	line-height:22px;
	font-size:13px;
	font-weight:bold;
}
button{
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
</style>
</head>
<BODY BGCOLOR=#FFFFFF LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0
<%	if(login_yn.equals("no_id")){%>
	onLoad="javascript:document.flogin.name.focus();"
<%	}else if(login_yn.equals("ok")){%>
	onLoad="javascript:submitgo();"
<%	}else if(login_yn.equals("r_ok")){%>
	onLoad="javascript:OpenAmazonCAR('5','<%=end_dt%>','<%=cur_dt%>','<%=login.getCookieValue(request, "acar_id")%>');"
<%	}else if(login_yn.equals("db_error")){%>
	onLoad="javascript:OpenAmazonCAR('4','<%=end_dt%>','<%=cur_dt%>','<%=login.getCookieValue(request, "acar_id")%>');"
<%	}else{%>
	onLoad="javascript:document.flogin.name.focus();"
<%	}%>>

<form name="flogin" method="post">
	<input type="hidden" name="cv" value="<%= securityUtil.encodeAES(Webconst.Common.FMS3_COOKIE_VALUE+name+"|"+user_id) %>" />
  <input type='hidden' name="s_width" value="">     
  <input type='hidden' name="s_height" value="">
  <input type='hidden' name="login_yn" value="<%=login_yn%>">
  <input type='hidden' name="open_type"	value="">    

	<div class="top-header">
		<h2><!--<img src="/agent/images/login_img.png"/>에이전트 인트라넷 로그인--></h2>
	</div>
	<div class="login-area">
		<div class="login-form-control">
			<div class="form-control">
				<label>아이디</label><br/>
				<input type="text" name="name" value="<%=name%>" class=text onKeydown="EnterDown()" tabindex=1><br/>
			</div>
			<div class="form-control">
				<label>비밀번호</label><br/>
				<input type="password" name="passwd" value="<%=passwd%>" class=text onKeydown="EnterDown()" tabindex=2><br/>
			</div>
			<div class="form-control">
				<button type="button" onclick="javascript:submitgo();">로그인</button>
			</div>
		</div>
	</div>
    <p>
	<div class="ment">
		<h3><center>시스템 로그인 ID <b><font color=red>도용 및 외부유출</font></b>로 피해를 주는 경우가 있어 <br><br>
		이에 대한 IP추적, 해킹시도 등이 발견될 시에는 <b>형사고발 조치</b>될 수 있습니다.</center>
		</h3>
	</div>
	<!-- 
<table width="478" border="0" cellpadding="0" cellspacing="0" background="images/login_bg.gif" align="center">
    <tr>
        <td height="156">&nbsp;</td>
    </tr>
    <tr>
        <td height="156" valign=top>
			<table width=428 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td colspan=4 height=35></td>
                </tr>
                <tr>
                    <td width=135 align=right><img src=http://fms1.amazoncar.co.kr/fms2/images/login_id.gif width=40 height=11></td>
                    <td width=11 rowspan=2>&nbsp;</td>
                    <td width=163 rowspan=2>
                        <table width=163 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td><input type="text" name="name" value="<%=name%>" size=19 class=text onKeydown="EnterDown()" tabindex=1></td>
                            </tr>
                            <tr>
                                <td height=2></td>
                            </tr>
                            <tr>
                                <td><input type="password" name="passwd" value="<%=passwd%>" size=20 class=text onKeydown="EnterDown()" tabindex=2></td>
                            </tr>
                        </table>
                    </td>
                    <td width=119 rowspan=2><a href="javascript:submitgo()"><img src=http://fms1.amazoncar.co.kr/fms2/images/login_button.gif width=66 height=43 border=0></a></td>
                </tr>
                <tr>
                    <td align=right><img src=http://fms1.amazoncar.co.kr/fms2/images/login_pw.gif width=40 height=11></td>
                </tr>
    	        <tr>
                    <td height=14 colspan=4></td>
                </tr>
                <tr>
            </table>
		</td>
    </tr>
</table>
 -->
</form>
<br>
<br>

<script language="javascript">
<% if ( isMobile( bInfo ) ) { %>
	document.flogin.open_type.value = "2";
<% } else { %>
	document.flogin.open_type.value = "1";
<% } %>

<%	if(login_yn.equals("no_id")){	%>
	alert('등록된 사용자가 아닙니다. ID, PASSWORD를 확인하십시요.');
<%	}	%>
<%	if(login_yn.equals("db_error")){	%>
	alert('데이타베이스 에러입니다.');
<%	}	%>
</script>
</body>
</html>
