<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.database.*, cust.member.*"%>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>

<%
	MemberLoginBean login = MemberLoginBean.getInstance();
	
	String var1 = request.getParameter("var1")==null?"":request.getParameter("var1");
	String var2 = request.getParameter("var2")==null?"":request.getParameter("var2");	
	String var3 = request.getParameter("var3")==null?"":request.getParameter("var3");
	String var4 = request.getParameter("var4")==null?"":request.getParameter("var4");	
	String var5 = request.getParameter("var5")==null?"":request.getParameter("var5");//client_id
	String var6 = request.getParameter("var6")==null?"":request.getParameter("var6");
	String view_amt = request.getParameter("view_amt")==null?"":request.getParameter("view_amt");
	String pay_way = request.getParameter("pay_way")==null?"":request.getParameter("pay_way");
	
	String view_good = request.getParameter("view_good")==null?"":request.getParameter("view_good");
	String view_tel = request.getParameter("view_tel")==null?"":request.getParameter("view_tel");
	String view_addr = request.getParameter("view_addr")==null?"":request.getParameter("view_addr");	
	
	String ssn = request.getParameter("ssn")==null?"":request.getParameter("ssn");
	
	String login_yn = "";
	
	if(!ssn.equals("")){//입력값이 있다
		//고객확인
		int result = login.getLoginCustMail(var5, var4, var2, ssn, response);
		
		if(result == 1){
			login_yn="r_ok";			
		}else if( result == 2){
			login_yn="db_error";
		}else{
			login_yn="no_id";
		}
	}else{
		login_yn="no";
	}

%>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>메일확인로그인</title>
</head>
<script language="JavaScript" src="/include/info_email.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function EnterDown(){
	var keyValue = event.keyCode;
	if (keyValue =='13') submitgo();
}

function submitgo(){
   	var fm = document.form1;
	if(fm.ssn.value=="")	{   	alert("사업자/주민등록번호를 입력하십시요.");   fm.ssn.focus();   		return;	}
	fm.action = 'tax_index.jsp';
   	fm.submit();
}
//-->
</SCRIPT>

<BODY bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" 
<%	if(login_yn.equals("ok")){%>
	onLoad="javascript:submitgo();"
<%	}else if(login_yn.equals("r_ok")){%>
	onLoad="javascript:OpenAmazonCAR('1');"
<%	}else if(login_yn.equals("db_error")){%>
	onLoad="javascript:OpenAmazonCAR('2');"
<%	}else{%>
	onLoad="javascript:document.form1.ssn.focus();"
<%	}%>
>

<table width=435 border=0 cellspacing=0 cellpadding=0 align=center>
<form name="form1" action="tax_index.jsp" method="post">
<input type="hidden" name="var1" value="<%= var1 %>">
<input type="hidden" name="var2" value="<%= var2 %>">
<input type="hidden" name="var3" value="<%= var3 %>">
<input type="hidden" name="var4" value="<%= var4 %>">
<input type="hidden" name="var5" value="<%= var5 %>">
<input type="hidden" name="var6" value="<%= var6 %>">
<input type="hidden" name="view_amt" value="<%= view_amt %>">
<input type="hidden" name="pay_way" value="<%= pay_way %>">
<input type="hidden" name="view_good" value="<%= view_good %>">
<input type="hidden" name="view_tel" value="<%= view_tel %>">
<input type="hidden" name="view_addr" value="<%= view_addr %>">
     <tr>
        <td height=40></td>
     </tr>
     <tr>
        <td>
            <table width=435 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td><img src=/mailing/off_doc/images/bar_num.gif width=435 height=41></td>
                </tr>
                <tr>
                    <td height=6></td>
                </tr>
                <tr>
                    <td>
                        <table width=435 border=0 cellpadding=0 cellspacing=0 background=/mailing/login/images/login_bg.gif>
                            <tr>
                                <td colspan=4><img src=/mailing/login/images/login_up.gif width=436 height=6></td>
                            </tr>
                            <tr>
                                <td colspan=4>&nbsp;</td>
                            </tr>
                            <tr>
                                <td width=135 align=center><img src=/mailing/login/images/login_img1.gif width=94 height=86></td>
                                <td width=22><img src=/mailing/login/images/vline.gif width=1 height=67></td>
                                <td width=182>
                                    <input type="text" name="ssn" value="<%=ssn%>" size=18 class=text onKeydown="EnterDown()" tabindex=1>
                                </td>
                                <td width=97><a href="javascript:submitgo()"><img src=/mailing/login/images/button_confirm.gif width=75 height=54></a></td>
                            </tr>
                            <tr align=center>
                                <td height=40 colspan=4><img src=/mailing/off_doc/images/ment.gif width=393 height=11> </td>
                            </tr>
                            <tr>
                                <td colspan=4 height=10></td>
                            </tr>
                            <tr>
                                <td colspan=4><img src=/mailing/login/images/login_dw.gif width=436 height=6></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</form>		
</table>
</body>
</html>
