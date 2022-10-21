<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.database.*, cust.member.*"%>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>

<%
	MemberLoginBean login = MemberLoginBean.getInstance();
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site = request.getParameter("r_site")==null?"":request.getParameter("r_site");
	String s_yy = request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	
	String ssn = request.getParameter("ssn")==null?"":request.getParameter("ssn");
	String passwd = request.getParameter("passwd")==null?"":request.getParameter("passwd");
	String name = request.getParameter("name")==null?"":request.getParameter("name");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	
	String login_yn = "";
	String user_nm = "";
	String member_id = "";
	
	MemberBean bean = m_db.getMemberCase(client_id, r_site, member_id);
	
	//고객지원 로그인
	if(mode.equals("1")){
		if(!passwd.equals("")){//입력값이 있다
			int result = login.getLoginCustPW(client_id, r_site, name, passwd, response);
			if(result == 1){
				login_yn="r_ok";
				user_nm=login.getAcarName(request, "client_id");
			}else if( result == 2){
				login_yn="db_error";
			}else{
				login_yn="no_id";
			}
		}else{
			login_yn="no";
		}
	
	//사업자/주민번호 로그인
	}else if(mode.equals("2")){
		if(!ssn.equals("")){//입력값이 있다
			//고객확인
			int result = login.getLoginCustSsn(client_id, r_site, ssn, response);
			
			if(result == 1){
				login_yn="r_ok";
				user_nm=login.getAcarName(request, "client_id");
			}else if( result == 2){
				login_yn="db_error";
			}else{
				login_yn="no_id";
			}
		}else{
			login_yn="no";
		}
	}
/*	
	out.println("mode     ="+mode+"<br>");
	out.println("client_id="+client_id+"<br>");
	out.println("r_site   ="+r_site+"<br>");
	out.println("ssn      ="+ssn+"<br>");
	out.println("passwd   ="+passwd+"<br>");
	out.println("user_nm  ="+user_nm+"<br>");
	out.println("login_yn ="+login_yn+"<br>");
*/
%>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>메일확인로그인</title>
</head>
<script language="JavaScript" src="/include/info_member.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function EnterDown(idx){
	var keyValue = event.keyCode;
	if (keyValue =='13') submitgo(idx);
}

function submitgo(idx){
   	var fm = document.form1;
	<%if(!bean.getMember_id().equals("") && !bean.getMember_id().equals("amazoncar")){%>		
	if(fm.name.value=="")	{   	alert("ID를 입력하십시요.");   					fm.name.focus();   		return;	}
	if(fm.passwd.value=="")	{   	alert("패스워드를 입력하십시요.");   			fm.passwd.focus();   	return;	}
	<%}else{%>
	if(fm.ssn.value=="")	{   	alert("사업자/주민등록번호를 입력하십시요.");   fm.ssn.focus();   		return;	}
	<%}%>	
	fm.mode.value = idx;
   	fm.submit();
}
//-->
</SCRIPT>

<BODY bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" 
<%	if(login_yn.equals("ok")){%>
	onLoad="javascript:submitgo(<%=mode%>);"
<%	}else if(login_yn.equals("r_ok")){%>
	onLoad="javascript:OpenAmazonCARTax('1','<%=login.getCookieValue(request, "member_id")%>','<%= s_yy %>','<%= s_mm %>');"
<%	}else if(login_yn.equals("db_error")){%>
	onLoad="javascript:OpenAmazonCARTax('2','<%=login.getCookieValue(request, "member_id")%>','','');"
<%	}else{%>
<%		if(!bean.getMember_id().equals("") && !bean.getMember_id().equals("amazoncar")){%>
	onLoad="javascript:document.form1.passwd.focus();"
<%		}else{%>
	onLoad="javascript:document.form1.ssn.focus();"
<%		}%>
<%	}%>
>

<table width=435 border=0 cellspacing=0 cellpadding=0 align=center>
<form name="form1" action="tax_index.jsp" method="post">
<input type="hidden" name="client_id" value="<%= client_id %>">
<input type="hidden" name="r_site" value="<%= r_site %>">
<input type="hidden" name="s_yy" value="<%= s_yy %>">
<input type="hidden" name="s_mm" value="<%= s_mm %>">
<input type="hidden" name="mode" value="">

	<%if(!bean.getMember_id().equals("") && !bean.getMember_id().equals("amazoncar")){%>	
    <tr>
        <td height=50></td>
    </tr>
    <tr>
        <td>
            <table width=435 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td><img src=images/bar_fmslogin.gif width=435 height=41></td>
                </tr>
                <tr>
                    <td height=6></td>
                </tr>
                <tr>
                    <td>
                        <table width=435 border=0 cellpadding=0 cellspacing=0 background=images/login_bg.gif>
                            <tr>
                                <td colspan=4><img src=images/login_up.gif width=436 height=6></td>
                            </tr>
                            <tr>
                                <td colspan=4>&nbsp;</td>
                            </tr>
                            <tr>
                                <td width=135 align=center><img src=images/login_img1.gif width=94 height=86></td>
                                <td width=20><img src=images/vline.gif width=1 height=67></td>
                                <td width=184>
                                    <table width=184 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td width=58><img src=images/id.gif width=48 height=13></td>
                                            <td width=126>
                                                <input type="text" name="name" value="<%=name%>" size=15 class=text onKeydown="EnterDown()" tabindex=1>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=4 colspan=2></td>
                                        </tr>
                                        <tr>
                                            <td><img src=images/pw.gif width=48 height=13></td>
                                            <td>
                                                <input type="password" name="passwd" value="<%=passwd%>" size=15 class=text onKeydown="EnterDown()" tabindex=2>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td width=97><img src=images/button_confirm.gif width=75 height=54></td>
                            </tr>
                            <tr>
                                <td colspan=4>&nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan=4><img src=images/login_dw.gif width=436 height=6></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
         </td>
     </tr>
	<%}else{%>	 
     <tr>
        <td height=40></td>
     </tr>
     <tr>
        <td>
            <table width=435 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td><img src=images/bar_num.gif width=435 height=41></td>
                </tr>
                <tr>
                    <td height=6></td>
                </tr>
                <tr>
                    <td>
                        <table width=435 border=0 cellpadding=0 cellspacing=0 background=images/login_bg.gif>
                            <tr>
                                <td colspan=4><img src=images/login_up.gif width=436 height=6></td>
                            </tr>
                            <tr>
                                <td colspan=4>&nbsp;</td>
                            </tr>
                            <tr>
                                <td width=135 align=center><img src=images/login_img1.gif width=94 height=86></td>
                                <td width=22><img src=images/vline.gif width=1 height=67></td>
                                <td width=182>
                                    <input type="text" name="ssn" value="<%=ssn%>" size=23 class=text onKeydown="EnterDown()" tabindex=1>
                                </td>
                                <td width=97><img src=images/button_confirm.gif width=75 height=54></td>
                            </tr>
                            <tr align=center>
                                <td height=40 colspan=4><img src=images/ment.gif width=393 height=11> </td>
                            </tr>
                            <tr>
                                <td colspan=4 height=10></td>
                            </tr>
                            <tr>
                                <td colspan=4><img src=images/login_dw.gif width=436 height=6></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<%}%>	 	
</form>		
</table>
</body>
</html>
