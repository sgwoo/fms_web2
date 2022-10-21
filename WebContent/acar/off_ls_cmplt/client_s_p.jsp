<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	function select(client_st, client_id, firm_nm, enp_no, ssn, o_zip, o_addr, email, o_tel, m_tel){		
		var fm = opener.document.form1;
		fm.client_id.value = client_id;
		fm.firm_nm.value = firm_nm;
		if(fm.sui_nm.value == '')			fm.sui_nm.value = firm_nm;
		if(client_st == '1'){
			if(enp_no.length == 10){
				fm.enp_no1.value = enp_no.substring(0,3);
				fm.enp_no2.value = enp_no.substring(3,5);
				fm.enp_no3.value = enp_no.substring(5,10);						
			}
			if(ssn.length == 13){			
				fm.ssn1.value = ssn.substring(0,6);
				fm.ssn2.value = ssn.substring(6);
			}			
		}else if(client_st == '2'){
			if(ssn.length == 13){				
				fm.ssn1.value = ssn.substring(0,6);
				fm.ssn2.value = '';
			}	
		}else{			
			if(enp_no.length == 10){
				fm.enp_no1.value = enp_no.substring(0,3);
				fm.enp_no2.value = enp_no.substring(3,5);
				fm.enp_no3.value = enp_no.substring(5,10);						
			}
			if(ssn.length == 13){			
				fm.ssn1.value = ssn.substring(0,6);
				fm.ssn2.value = '';
			}	
			
			if(ssn.length == 6){			
				fm.ssn1.value = ssn;
				fm.ssn2.value = '';
			}				
		}
	
		if(fm.d_zip.value == '')			fm.d_zip.value 	= o_zip;
		if(fm.d_addr.value == '')			fm.d_addr.value = o_addr;
		if(fm.h_tel.value == '')			fm.h_tel.value 	= o_tel;
		if(fm.m_tel.value == '')			fm.m_tel.value 	= m_tel;
		if(fm.email.value == '')			fm.email.value 	= email;

		if(email.indexOf('@') != -1){
			var mails = email.split('@');
			fm.email_1.value 	= mails[0];
			fm.email_2.value 	= mails[1];
		}		

		window.close();
	}
	
	function search(){
		var fm = document.form1;
		fm.h_con.value = fm.s_con.options[fm.s_con.selectedIndex].value;
		fm.h_wd.value =  fm.t_wd.value;
		fm.action='./client_s_p.jsp';
		fm.target='CLIENT';
		fm.submit();
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	
//-->
</script>
</head>

<body leftmargin="15" onLoad="javascript:document.form1.t_wd.focus();">
<center>
<form name='form1' action='' method='post'>
<input type='hidden' name='h_con' value=''>
<input type='hidden' name='h_wd' value=''>
<%
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	String h_con = request.getParameter("h_con")==null?"1":request.getParameter("h_con");
	String h_wd = request.getParameter("h_wd")==null?"":request.getParameter("h_wd");
%>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>기초정보관리 > 계약관리 > 계약등록 > <span class=style5>고객검색</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=600>
				<tr>
					<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gshm.gif align=absmiddle>&nbsp;
						<select name='s_con'>
							<option value='1' <%if(h_con.equals("1")){%> selected <%}%>> 상호 	</option>
							<option value='2' <%if(h_con.equals("2")){%> selected <%}%>> 고객명	</option>
							<option value='6' <%if(h_con.equals("6")){%> selected <%}%>> 사업자/주민번호	</option>
						</select>
						<input type='text' name='t_wd' size='20' class='text' value='<%=h_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
                	<a href='javascript:search()'><img src=../images/center/button_search.gif align=absmiddle border=0></a></td>					
              	    <td align='right'> <a href='client_i_p.jsp' target='CLIENT'><img src=../images/center/button_reg.gif align=absmiddle border=0></a> 
              	    </td>
				</tr>
			</table>
		</td>
		<td width='20'></td>
	</tr>
	<tr> 
        <td class=h></td>
    </tr>
	<tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line' width='600'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class='title' width='17%'>사업자번호<br>법인(주민)번호</td>
					<td class='title' width='28%'>상호</td>
					<td class='title' width='10%'>고객명</td>
					<td class='title' width='18%'>전화번호</td>
					<td class='title' width='27%'>주소</td>					
				</tr>
			</table>
		</td>
		<td width='20'></td>
	</tr>
	<tr>
		<td colspan='2'>
			<iframe src="./client_s_in.jsp?h_con=<%=h_con%>&h_wd=<%=h_wd%>" name="inner" width="617" height="350" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
		</td>
	</tr>
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>