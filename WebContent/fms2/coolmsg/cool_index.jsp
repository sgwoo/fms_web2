<%@page import="org.apache.commons.codec.binary.Base64"%>
<%@page import="org.apache.commons.codec.binary.StringUtils"%>
<%@page import="java.net.URLDecoder"%>
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
	String id 	= request.getParameter("id")==null?		"":request.getParameter("id");
	String direct 	= request.getParameter("direct")==null?		"":request.getParameter("direct");
	String pass 	= request.getParameter("pass")==null?		"":request.getParameter("pass");	

	if (direct.equals("Y")) {
		pass=StringUtils.newStringUtf8(Base64.decodeBase64(pass));
			
	}	
	
	String url	= request.getParameter("url")==null?		"":request.getParameter("url");
	String m_url	= request.getParameter("m_url")==null?"":request.getParameter("m_url");
	String user_id 	= "";
	String dept_id = "";
	String en_pass="";	

	//	System.out.println("=============[쿨메신저로그인]=============");
	//	System.out.println("id=" + id + "&pass = " + pass + "&url="+  url  + "&m_url=" + m_url);
	//	System.out.println("=============[쿨메신저로그인]=============");


	
	if(!id.equals("")){
		dept_id	= login.getDept_id2(id);
	}
			
	/*
		## 쿨메신저에서 링크클릭시 SSO를 이용하는 경우 자동로그인후 해당 게시물로 이동하는 시스템
			
			링크예)http://fms2.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=jhm&pass=19713069&url=/fms2/lc_rent/lc_s_frame.jsp
	*/
	
//	out.println("id="+id);
//	out.println("pass="+pass);
//	out.println("dept_id="+dept_id);
	
if(!id.equals("") && !dept_id.equals("8888") && !dept_id.equals("1000")){
	
	//out.println("로그인 여부="+login.isLogin(request));

	if(login.isLogin(request)){
		
		//out.println("로그인처리 true");
	
		if((id.length() > 0) && (pass.length() > 0)){
		
			
			
			//로그인처리
			int result = login.getLogin(id, pass, response, request);
			
			//out.println("로그인 처리 결과 ="+result);

			if(result == 1){
				user_id 		= login.getSessionValue(request, "USER_ID");	
			    dept_id 		= login.getSessionValue(request, "DEPT_ID");	
			    user_nm			= login.getSessionValue(request, "USER_NM");
			   			    		   
			   //암호 8자리미만인경우... - 당사직원만 해당 ( 협력업체 아님.
			        if  ( pass.length() < 8  ||  id.equals(pass)  ) {
			         	    login_yn="r_pass";	  						   	    
			        } else { 
						
					login_yn="r_ok";

					user_nm=login.getSessionValue(request, "USER_NM");
					login.setDisplayCookie(s_width, s_height, response);//디스플레이 사이즈 쿠키설정
					//로그인처리----------------------------------------------------------------------------------
					String login_time 	= Util.getLoginTime();//로그인시간
					String login_ip 	= request.getRemoteAddr();//로그인IP
					
					int count = 0;
					
					if(user_id.equals("000004")){
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
					
					user_id 		= login.getSessionValue(request, "USER_ID");	
					System.out.println("[로그인메신저]  DT:"+login_time+", ID:"+user_id+"("+login.getAcarName(request, "acar_id")+")");
					//로그인처리----------------------------------------------------------------------------------
			         }		
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
	}else{
		
		//out.println("로그인처리 false");
		
		if( (id.length() > 0) && (pass.length() > 0)){
		
			int result = login.getLogin(id, pass, response, request);
			
			//out.println("로그인 처리 결과 ="+result);

			if(result == 1){
				login_yn="ok";
			}else if( result == 2){
				login_yn="db_error";
			}else{
				login_yn="no";
			}
		}else{
			login_yn="no";
		}
	}
}	
			
			//out.println(login_yn);


%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
<title>:::FMS 로그인:::</title>
<script language="JavaScript" src="/include/info_cool.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--


	var url =window.location.href;
	//반영시에는 꼭 주석을 풀어야함(개발시에는 주석)
	if (document.location.protocol == 'http:') {
		if (url.indexOf("localhost") > -1 || url.indexOf("127.0.0.1") > -1) {
			console.log("localhost");
		} else {
			url =url.replace('http:', 'https:');
			document.location.href =url;
		}
	}          

	var s_width = screen.width;
	var s_height = screen.height;

	
	function onLoad(){
   		var theForm = document.flogin;
	   	theForm.s_width.value = s_width;		
		theForm.s_height.value = s_height;
		
		
		<%if(id.equals("")){%>
		theForm.action = "/acar/index.jsp";
		theForm.submit();
		<%}else{%>
		
<%		if(login_yn.equals("no_id")){%>
		alert('아이디가 없습니다.');
<%	}else if(login_yn.equals("ok")){%>
		theForm.action = "cool_index.jsp";
		theForm.submit();
<%		}else if(login_yn.equals("r_pass")){%>
		theForm.action = "/acar/menu/pass_u.jsp?info=<%=user_id%>";
		theForm.submit();
<%		}else if(login_yn.equals("r_ok")){%>
		OpenAmazonCAR('1','<%=end_dt%>','<%=cur_dt%>','<%=session.getAttribute("USER_ID")%>','<%=url%>','<%=attend_login_dt%>','<%=loan_st%>','<%=m_url%>');
<%		}else if(login_yn.equals("db_error")){%>
		OpenAmazonCAR('4','<%=end_dt%>','<%=cur_dt%>','<%=session.getAttribute("USER_ID")%>','<%=url%>','','','<%=m_url%>');
<%		}else{%>

<%		}%>	

		<%}%>	
	}
	
	function OffonLoad(){
   		var theForm = document.flogin;
	   	theForm.s_width.value = s_width;		
		theForm.s_height.value = s_height;		
		theForm.action = "http://fms1.amazoncar.co.kr/off/coolmsg/cool_index.jsp";
		theForm.submit();
	}
	
	function updPass(){
		var SUBWIN="./acar/menu/pass_u.jsp?cool=Y&info=<%=user_id%>";	
		window.open(SUBWIN, "InfoUpPhoto", "left=300, top=250, width=430, height=300, scrollbars=no");
	}		
//-->
</SCRIPT>
</head>
<BODY BGCOLOR=#FFFFFF LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0 onLoad="javascript:<%if(!dept_id.equals("8888")){%>onLoad();<%}else{%>OffonLoad();<%}%>">
<form name="flogin" method="post">
  <input type='hidden' name="s_width" 	value="">     
  <input type='hidden' name="s_height" 	value="">
  <input type='hidden' name="s_width2" 	value="">     
  <input type='hidden' name="s_height2" value="">
  <input type='hidden' name="id" 	value="<%=id%>">     
  <input type='hidden' name="pass" 	value="<%=pass%>">
  <input type='hidden' name="url" 	value="<%=url%>">
  <input type='hidden' name="m_url" 	value="<%=m_url%>">
  <input type='hidden' name="open_type"	value="">  
  <input type="hidden" name="cv" value="<%= securityUtil.encodeAES(Webconst.Common.FMS3_COOKIE_VALUE+id+"|"+user_id) %>" />
  
</form>
<script language="javascript">

	<%if(!dept_id.equals("8888")){%>
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
	<%}else{%>	
	
	<%}%>
	
	document.flogin.s_width.value = screen.width;		
	document.flogin.s_height.value = screen.height;		
	document.flogin.s_width2.value = screen.width;		
	document.flogin.s_height2.value = screen.height;		

</script>
</body>
</html>
