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

  	String bInfo = request.getHeader( "user-agent" );
    
%>

<%
	LoginBean login 			= LoginBean.getInstance();
	OffAncDatabase oad 			= OffAncDatabase.getInstance();	
	UserMngDatabase umd 		= UserMngDatabase.getInstance();
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
	String new_menu= request.getParameter("new_menu")==null?	"":request.getParameter("new_menu");
	
	String user_id 	= "";
	String dept_id = "";
	String en_pass="";
	
	
	if(login.isLogin(request)){
	
		if((name.length() > 0) && (passwd.length() > 0)){
		  
			int result = login.getLogin(name, passwd, response, request);
			
			if(result == 1){
			
				user_id 		= login.getSessionValue(request, "USER_ID");	
			    dept_id 		= login.getSessionValue(request, "DEPT_ID");	
			    user_nm			= login.getSessionValue(request, "USER_NM");
			    		    
			   
			    //암호 8자리미만인경우... - 당사직원만 해당 ( 협력업체 아님.
			    if  ( passwd.length() < 8  && !dept_id.equals("8888") && !dept_id.equals("1000") ) {
			      login_yn="r_pass";			   			   	    
			    } else { 			
						login_yn="r_ok";												
					
						//디스플레이 사이즈 쿠키설정
						login.setDisplayCookie(s_width, s_height, response);
						
						//로그인처리----------------------------------------------------------------------------------
						String login_time = Util.getLoginTime();//로그인시간
						String login_ip = request.getRemoteAddr();//로그인IP						
						int count = 0;
					
						if(!user_id.equals("")){
							String attend_dt1 = "";
							String attend_dt2 = "";
							attend_dt1 = aa_db.getAttendDate(user_id);
							//ip_log 등록
							count = oad.insertLoginLog(login_ip, user_id, login_time);
							int chk_count = oad.attendChk(user_id);//7시이후 로그인
							//출근관리
							if(chk_count ==0){
								count = oad.attend(login_ip, user_id, login_time);
								System.out.println("[로그인 FMS] DT:"+login_time+", ID:"+user_id+"("+user_nm+")");
							}
							//출근시간 체크
							attend_dt2 = aa_db.getAttendDate(user_id);
							if(attend_dt1.equals("") && !attend_dt2.equals("")){
								attend_login_dt = attend_dt2;							
								//자체탁송 지원자 대상여부
								UsersBean user_bean = umd.getUsersBean(user_id);
								loan_st = user_bean.getLoan_st();
							}						
						}
				
			    }	//암호8자리
				
			//로그인처리----------------------------------------------------------------------------------
			}else if( result == 2){
				login_yn="db_error";
			}else{
				login_yn="no_id";
			}
		
		}else{
			login_yn="no";
		}
	}else{
		
		if( (name.length() > 0) && (passwd.length() > 0)){
		
			int result = login.getLogin(name, passwd, response, request);
			
			if(result == 1){
				login_yn="ok";
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
<title>::: FMS 로그인:::</title>
</head>
<script language="JavaScript" src="/include/info_fms2.js"  charset='utf-8'></script>
<script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
<script src="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script> 
<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css">
<script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>
<script type="text/javascript">
//acar접속시 fms2 리다이렉트
var href = window.location.href;
var path_name = window.location.pathname;

if (path_name.indexOf("acar") != -1) {
	location.replace("/fms2/index.jsp");
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
	var serverId = "109";
	
	window.status = serverId + " 서버 입니다."
	
	if( parent.top_menu ){
		parent.location.href = '/fms2/index.jsp';
	}
	
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
   		
   		//보안서버 적용된 서버에서 조회하도록 변경 - 20180920
   		if(theForm.name.value=="speedmate" || theForm.name.value=="speedmateers" ||  theForm.name.value=="mastercar" ||  theForm.name.value=="krma"  ){
   			//alert("접속 URL이 변경되었습니다. 문의바랍니다. !!!!");
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
		
			if(theForm.name.value == "2002010"){
				theForm.s_height.value = s_height-40;
			}
		
			theForm.submit();
	}
	
	
	function updPass(){
			var SUBWIN="/acar/menu/pass_u.jsp?info=<%=user_id%>";	
			window.open(SUBWIN, "InfoUpPhoto", "left=300, top=250, width=430, height=300, scrollbars=no");
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
	text-align:center;
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
.center{
	text-align:center;
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

</STYLE>
<BODY BGCOLOR=#FFFFFF LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0
<%	if(login_yn.equals("no_id")){%>
	onLoad="javascript:document.flogin.name.focus();"
<%	}else if(login_yn.equals("ok")){%>
	onLoad="javascript:submitgo();"
<%	}else if(login_yn.equals("r_pass")){%>
	onLoad="javascript:updPass();"	
<%	}else if(login_yn.equals("r_ok")){%>
	onLoad="javascript:OpenAmazonCAR('1','<%=session.getAttribute("USER_ID") %>','<%=open_type%>','<%=dept_id%>');"
<%	}else if(login_yn.equals("db_error")){%>
	onLoad="javascript:OpenAmazonCAR('4','<%=session.getAttribute("USER_ID") %>','<%=open_type%>','<%=dept_id%>');"
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
		<h2><!--<img src="/fms2/images/login_img.png"/>FMS 로그인--></h2>
	</div>
	<div class="center">
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
	</div>
    <p>
	<div class="ment">
		<h3><center>시스템 로그인 ID <b><font color=red>도용 및 외부유출</font></b>로 피해를 주는 경우가 있어 <br><br>
		이에 대한 IP추적, 해킹시도 등이 발견될 시에는 <b>형사고발 조치</b>될 수 있습니다.</center>
		</h3>
	</div>

<!-- <table width=478 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td width=25 rowspan=4><img src=/fms2/images/login_1.gif width=25 height=312></td>
        <td width=428><img src=/fms2/images/login_img.gif width=428 height=149></td>
        <td width=25 rowspan=4><img src=/fms2/images/login_2.gif width=25 height=312></td>
    </tr>
    <tr>
        <td>
            <table width=428 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td colspan=4 height=10></td>
                </tr>
                <tr>
                    <td width=110 align=right><img src=/fms2/images/login_id.gif width=40 height=11></td>
                    <td width=11 rowspan=2>&nbsp;</td>
                    <td width=163 rowspan=2>
                        <table width=163 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td>
                                <input type="text" name="name" value="<%=name%>" size=19 class=text onKeydown="EnterDown()" tabindex=1> </td>
                            </tr>
                            <tr>
                                <td height=2></td>
                            </tr>
                            <tr>
                                <td>
                                <input type="password" name="passwd" value="<%=passwd%>" size=20 class=text onKeydown="EnterDown()" tabindex=2>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td width=144 rowspan=2><a href="javascript:submitgo()"><img src=/fms2/images/login_button.gif width=66 height=43 border=0></a>     
                    </td>
                </tr>
                <tr>
                    <td align=right><img src=/fms2/images/login_pw.gif width=40 height=11></td>
                </tr>
    	        <tr>
                    <td height=14 colspan=4></td>
                </tr>
                <tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
            <div id="fmsloginFlashLoc" style="width: 426px; height: 67px;" >
                <script id="fmslogin_elementid" src="/fms2/js/fmsloginFlashControl.js"></script> 
            </div>
        </td>
    </tr>
    <tr>
        <td><img src=/fms2/images/login_4.gif width=428 height=23></td>
    </tr>
</table>
 -->

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

<%	if(login_yn.equals("no_id")){ 	%>
	alert('등록된 사용자가 아닙니다. ID, PASSWORD를 확인하십시요.');
<%	}	%>
<%	if(login_yn.equals("db_error")){ %>
	alert('데이타베이스 에러입니다.');
<%	}	%>
</script>
</body>
</html>
