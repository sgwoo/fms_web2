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
	LoginBean login 			= LoginBean.getInstance();
	OffAncDatabase oad 			= OffAncDatabase.getInstance();	
	SecurityUtil securityUtil 	= new SecurityUtil();
	

	String login_yn = "";
	String user_nm 	= "";				

	String s_width 		= request.getParameter("s_width")==null?	"":request.getParameter("s_width");
	String s_height 	= request.getParameter("s_height")==null?	"":request.getParameter("s_height");
	
	String name 		= request.getParameter("name")==null?		"":request.getParameter("name");
	String passwd 		= request.getParameter("passwd")==null?		"":request.getParameter("passwd");
	
	String open_type	= request.getParameter("open_type")==null?	"1":request.getParameter("open_type");
	String user_id 		= "";
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
					System.out.println("[협력업체 로그인] DT:"+login_time+", ID:"+user_id+"("+login.getAcarName(request, "acar_id")+")"  );
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
		user_nm			= login.getSessionValue(request, "USER_NM");
	
	}else{
		if( (name.length() > 0) && (passwd.length() > 0)){
		
			int result = login.getLogin(name, passwd, response, request);
		//	int result = login.getLogin(name, passwd, response);
			
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
	
	if(!dept_id.equals("") && !dept_id.equals("8888")){
		login_yn = "not_off";
	}	
%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>::: 협력업체 인트라넷 로그인:::</title>
<script language="JavaScript" src="/off/include/info.js"></script>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css">
<script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
<script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>
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
		
		//
		nowDate=new Date();
		
		//현재 시간파악
		NH = nowDate.getHours();
		NM = nowDate.getMinutes();
			
		if(theForm.name.value==""){
			alert("ID를 입력하십시요.");
			theForm.name.focus();
			return;
		}
		
		//보안서버 적용된 서버에서 조회하도록 변경 - 20180920
		if(theForm.name.value=="speedmate" || theForm.name.value=="speedmateers" ||  theForm.name.value=="mastercar" ||  theForm.name.value=="krma" ){
   			
   			$('#dialog').dialog({
                position:"center", //"center", "left", "right", "top", "bottom"
                modal:true, //모달대화상자
                resizable:false, //크기 조절 못하게
                buttons:{
                    "확인":function(){
                        $(this).dialog("close");
                    }
                }
   			});
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
.ui-dialog{
	width: 500px !important;
}
#dialog{
	padding-top: 30px !important;
	display: none; 
}
.ui-widget-content {
    border: 0px !important;
}
.ui-dialog-titlebar{
	border: 0px !important;
    background: #349BD4 !important;
    color: #000 !important;
    font-weight: bold !important;
}
.ui-dialog-buttonpane{
	border: 0px !important;
    background: #FFF !important;
    color: #000 !important;
}
.ui-button-text-only{
	border: 1px solid #349BD4 !important;
	background: #349BD4 !important;
	color: #FFF !important;
	line-height:22px !important;
	font-size:13px !important;
	font-weight:bold !important;
    width: 100px !important;
    height: 40px !important;
}
</style>
</head>
<BODY BGCOLOR=#FFFFFF LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0
<%	if(login_yn.equals("no_id")){%>
	onLoad="javascript:document.flogin.name.focus();"
<%	}else if(login_yn.equals("ok")){%>
	onLoad="javascript:submitgo();"
<%	}else if(login_yn.equals("r_ok")){%>
	onLoad="javascript:OpenAmazonCAR('1','<%=open_type%>','<%=dept_id%>','<%=session.getAttribute("USER_ID") %>');"
<%	}else if(login_yn.equals("db_error")){%>
	onLoad="javascript:OpenAmazonCAR('4','<%=open_type%>','<%=dept_id%>','<%=session.getAttribute("USER_ID") %>');"
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
		<h2><!--<img src="/off/images/login_img.png"/>협력업체 인트라넷 로그인--></h2>
	</div>
	<div class="login-area">
		<div class="login-form-control">
			<div class="form-control">
				<label>아이디</label><br/>
				<input type="text" name="name" value="<%=name%>" class="text" onKeydown="EnterDown()" tabindex=1><br/>
			</div>
			<div class="form-control">
				<label>비밀번호</label><br/>
				<input type="password" name="passwd" value="<%=passwd%>" class="text" onKeydown="EnterDown()" tabindex=2><br/>
			</div>
			<div class="form-control">
				<button type="button" class="input_btn" onclick="javascript:submitgo();">로그인</button>
			</div>
		</div>
	</div>
    <p>
	<div class="ment">
		<h3><center>시스템 로그인 ID <b><font color=red>도용 및 외부유출</font></b>로 피해를 주는 경우가 있어 <br><br>
		이에 대한 IP추적, 해킹시도 등이 발견될 시에는 <b>형사고발 조치</b>될 수 있습니다.</center>
		</h3>
	</div>
	
</form>

<div id="dialog">
    <label class="label_css">접속 URL이 변경 되었습니다.<br>
    https://fms.amazoncar.co.kr/off_web/index.jsp<br>
    으로 접속 부탁드립니다.
    </label>
</div>

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
<%	if(login_yn.equals("not_off")){	%>
	alert('협력업체 사용자가 아닙니다.');
<%	}	%>
</script>
</body>
</html>
