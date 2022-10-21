<!DOCTYPE html>
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
	LoginBean login 	= LoginBean.getInstance();
	OffAncDatabase oad 	= OffAncDatabase.getInstance();	
	UserMngDatabase umd = UserMngDatabase.getInstance();

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
	
	if(login.isLogin(request)){
	
		if((name.length() > 0) && (passwd.length() > 0)){
		  
			int result = login.getLogin(name, passwd, response, request);
			
			if(result == 1){
			    user_id 		= login.getSessionValue(request, "USER_ID");	
			    dept_id 		= login.getSessionValue(request, "DEPT_ID");	
			    user_nm			= login.getSessionValue(request, "USER_NM");
			    		    
		//	    System.out.println("user_id=" + user_id + "&dept_id = " + dept_id);
			   
			   //암호 8자리미만인경우... - 당사직원만 해당 ( 협력업체 아님.
			        if  ( passwd.length() < 8  && !dept_id.equals("8888") && !dept_id.equals("1000") ) {
			         	    login_yn="r_pass";			   
			   //	    user_id 		= login.getCookieValue(request, "acar_id");	
			   	    
			        } else { 
			
					login_yn="r_ok";
					//user_nm=login.getAcarName(request, "acar_id");
					user_nm=login.getSessionValue(request, "USER_NM");
					
					login.setDisplayCookie(s_width, s_height, response);//디스플레이 사이즈 쿠키설정
					//로그인처리----------------------------------------------------------------------------------
					String login_time 	= Util.getLoginTime();//로그인시간
					String login_ip 	= request.getRemoteAddr();//로그인IP
					user_id 		= login.getSessionValue(request, "USER_ID");
					int count = 0;
					
					if(!user_id.equals("")){
						String attend_dt1 = "";
						String attend_dt2 = "";
						attend_dt1 = aa_db.getAttendDate(user_id);
						//ip_log 등록
						count = oad.insertLoginLog(login_ip, user_id, login_time);
						int chk_count = oad.attendChk(user_id);
						//출근관리
						if(chk_count ==0){
							count = oad.attend(login_ip, user_id, login_time);
							System.out.println("[로그인] DT:"+login_time+", ID:"+user_id+"("+login.getAcarName(request, "acar_id")+")");
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
		end_dt=login.getEndDt(request,"acar_id");
		cur_dt=Util.getDate(4);
		user_nm=login.getSessionValue(request, "USER_NM");
	//	user_nm=login.getAcarName(request, "acar_id");
	}else{
		if( (name.length() > 0) && (passwd.length() > 0)){
		
			int result = login.getLogin(name, passwd, response, request);
			
			if(result == 1){
				login_yn="ok";
				user_nm=login.getAcarName(request, "acar_id");
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
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
<title>:::인트라넷 로그인:::</title>
</head>
<script language="JavaScript" src="/include/info.js"></script>
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
   		
   	   		
   		//if(theForm.name.value=="mastercar"   || theForm.name.value=="speedmate"    || theForm.name.value=="anycar"   ||    theForm.name.value=="mj2686"   ||    theForm.name.value=="woo1065" ||    theForm.name.value=="70346"  ||    theForm.name.value=="youngwon"  ){
   		//	alert("http://fms5.amazoncar.co.kr를 이용하세요.");
   		//	theForm.name.focus();
	   	//	return;
   		//}
   		
   		
	   	theForm.s_width.value = s_width;		
		theForm.s_height.value = s_height;
		
//		if(theForm.open_type[1].checked == true){
//			theForm.s_height.value = s_height-40;
//		}

		if(theForm.name.value == "2002010"){
			theForm.s_height.value = s_height-40;
		}

		//theForm.action = "/index.jsp";
		theForm.submit();
	}
	
	
	function updPass(){
		var SUBWIN="./menu/pass_u.jsp?info=<%=user_id%>";	
		window.open(SUBWIN, "InfoUpPhoto", "left=300, top=250, width=430, height=300, scrollbars=no");
	}	
//-->
</SCRIPT>

<BODY BGCOLOR=#FFFFFF LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0
<%	if(login_yn.equals("no_id")){%>
	onLoad="javascript:document.flogin.name.focus();"
<%	}else if(login_yn.equals("ok")){%>
	onLoad="javascript:submitgo();"
<%	}else if(login_yn.equals("r_pass")){%>
	onLoad="javascript:updPass();"	
<%	}else if(login_yn.equals("r_ok")){%>
	onLoad="javascript:OpenAmazonCAR('1','<%=end_dt%>','<%=cur_dt%>','<%=session.getAttribute("USER_ID") %>','<%=attend_login_dt%>','<%=loan_st%>','<%=open_type%>','<%=user_id%>','<%=dept_id%>');"
<%	}else if(login_yn.equals("db_error")){%>
	onLoad="javascript:OpenAmazonCAR('4','<%=end_dt%>','<%=cur_dt%>','<%=session.getAttribute("USER_ID") %>','','','<%=open_type%>','<%=user_id%>','<%=dept_id%>');"
<%	}else{%>
	onLoad="javascript:document.flogin.name.focus();"
<%	}%>>

<form name="flogin" method="post">
  <input type='hidden' name="s_width" value="">     
  <input type='hidden' name="s_height" value="">
  <input type='hidden' name="login_yn" value="<%=login_yn%>">
  <input type='hidden' name="open_type"	value="">    

<table width=478 border=0 cellspacing=0 cellpadding=0 align=center>
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
                                <td>96<input type="text" name="name" value="<%=name%>" size=19 class=text onKeydown="EnterDown()" tabindex=1></td>
                            </tr>
                            <tr>
                                <td height=2></td>
                            </tr>
                            <tr>
                                <td><input type="password" name="passwd" value="<%=passwd%>" size=20 class=text onKeydown="EnterDown()" tabindex=2></td>
                            </tr>
                        </table>
                    </td>
                    <td width=144 rowspan=2><a href="javascript:submitgo()"><img src=/fms2/images/login_button.gif width=66 height=43 border=0></a>
     <!--    	  <a href="javascript:updPass()">암호변경</a> -->
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
            <div id="fmsloginFlashLoc">
                <script id="fmslogin_elementid" src="/fms2/js/fmsloginFlashControl.js"></script> 
            </div>
        </td>
    </tr>
    <tr>
        <td><img src=/fms2/images/login_4.gif width=428 height=23></td>
    </tr>
	
	<!--
    <tr>
        <td colspan='3' align=center>
		  &nbsp;
		</td>
    </tr>
    <tr>
        <td colspan='3' align=center>
		  <input type="radio" name="open_type" value="1" <%if(open_type.equals("1"))%>checked<%%> >팝업창
		  <input type="radio" name="open_type" value="2" <%if(open_type.equals("2"))%>checked<%%> >본인창
		</td>
    </tr>
	-->

</table>
<!--
<p>
<center>
   <font size = '20' color=RED>     !!! 현재 FMS 사용 불가!! 전산 작업 중입니다.!!! </font>
</center>
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

<%	if(login_yn.equals("no_id")){ 	%>
	alert('등록된 사용자가 아닙니다. ID, PASSWORD를 확인하십시요.');
<%	}	%>
<%	if(login_yn.equals("db_error")){ %>
	alert('데이타베이스 에러입니다.');
<%	}	%>
</script>
</body>
</html>
