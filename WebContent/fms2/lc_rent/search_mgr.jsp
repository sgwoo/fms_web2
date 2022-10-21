<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//관계자조회 페이지
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st");
	
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String swd 	= request.getParameter("swd")==null?"":request.getParameter("swd");
	String idx 	= request.getParameter("idx")==null?"":request.getParameter("idx");
	String str 	= request.getParameter("str")==null?"":request.getParameter("str");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
%>
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">

<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	function save()
	{
		document.form1.mode.value = 'AFTER';
		document.form1.submit();
	}
	
	function set_mgr(mgr_st, com_nm, mgr_dept, mgr_nm, mgr_title, mgr_tel, mgr_m_tel, mgr_email, mgr_zip, mgr_addr, mgr_ssn, mgr_lic_no, mgr_etc)
	
	{
		var fm = document.form1;
		var idx = fm.idx.value;
		var str = fm.str.value;
		
		<%if(car_st.equals("4")){%>
		
			window.opener.form1.mgr_nm[idx].value 		= mgr_nm;
			window.opener.form1.mgr_ssn[idx].value 		= mgr_ssn;
			window.opener.form1.mgr_addr[idx].value 	= mgr_addr;			
			window.opener.form1.mgr_tel[idx].value 		= mgr_tel;
			window.opener.form1.mgr_m_tel[idx].value 	= mgr_m_tel;
			window.opener.form1.mgr_lic_no[idx].value 	= mgr_lic_no;
			window.opener.form1.mgr_etc[idx].value 		= mgr_etc;
			

		<%}else{%>

		if (fm.from_page.value == '/fms2/cooperation/cooperation_i.jsp' ){
			window.opener.form1.agnt_nm.value 		= mgr_nm;
			window.opener.form1.agnt_m_tel.value 		= mgr_m_tel;			
			window.opener.form1.agnt_email.value 		= mgr_email;
			if(mgr_email.indexOf('@') != -1){
				var mails = mgr_email.split('@');
				window.opener.form1.email_1.value 	= mails[0];
				window.opener.form1.email_2.value 	= mails[1];
			}
					
		}else{	
			window.opener.form1.mgr_com[idx].value 		= com_nm;
			window.opener.form1.mgr_dept[idx].value 	= mgr_dept;
			window.opener.form1.mgr_nm[idx].value 		= mgr_nm;
			window.opener.form1.mgr_title[idx].value 	= mgr_title;
			window.opener.form1.mgr_tel[idx].value 		= mgr_tel;
			window.opener.form1.mgr_m_tel[idx].value 	= mgr_m_tel;
			window.opener.form1.mgr_email[idx].value 	= mgr_email;
			
			//if(idx==0){
			//	window.opener.form1.lic_no.value 	= mgr_lic_no;
			//}
			
			if(mgr_email.indexOf('@') != -1){
				var mails = mgr_email.split('@');
				window.opener.form1.email_1[idx].value 		= mails[0];
				window.opener.form1.email_2[idx].value 		= mails[1];
			}
				
			<%if(from_page.equals("lc_c_u")){%>	
			if(idx == '0'){
				window.opener.form1.t_zip.value			= mgr_zip;
				window.opener.form1.t_addr.value	 	= mgr_addr;
			}
			<%}else{%>
			if(idx == '0'){
				window.opener.form1.t_zip[1].value 		= mgr_zip;
				window.opener.form1.t_addr[1].value 	= mgr_addr;
			}		
			<%}%>
		}
		<%}%>
		window.close();
	}
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') save();
	}	
//-->
</script>
</head>
<body onload="javascript:document.form1.swd.focus();">
<p>
<form name='form1' action='search_mgr.jsp' method='post'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='str' value='<%=str%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 고객관리 > <span class=style5>관계자검색</span></span> : 관계자검색</td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width="13%" class='title'> 성명 </td>
					<td>&nbsp;
						<input type='text' name='swd' size='10' class='text' value='<%=swd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
						&nbsp;<a href='javascript:save()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
				  </td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td></td>
	</tr>
<%	
		Vector vt = a_db.getSearchMgrList(client_id, swd);
		int size = vt.size();
		if(size > 0){			%>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class='title' width='5%'> 연번 </td>
					<td width="13%" class='title'>차량번호</td>
					<td width="21%" class='title'>구분</td>
				    <td width="14%" class='title'>근무처</td>
				    <td width="12%" class='title'>부서</td>
				    <td width="10%" class='title'>성명</td>
				    <td width="10%" class='title'>직위</td>
				    <td width="15%" class='title'>휴대폰</td>
				</tr>
<%			for(int i = 0 ; i < size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);	%>
				<tr>
					<td align='center'><%=i+1%></td>
					<td align="center"><%=ht.get("CAR_NO")%></td>
					<td align="center"><%=ht.get("MGR_ST")%></td>					
				    <td align="center"><%=ht.get("COM_NM")%></td>
				    <td align="center"><%=ht.get("MGR_DEPT")%></td>
				    <td align="center"><a href="javascript:set_mgr('<%=ht.get("MGR_ST")%>', '<%=ht.get("COM_NM")%>', '<%=ht.get("MGR_DEPT")%>', '<%=ht.get("MGR_NM")%>', '<%=ht.get("MGR_TITLE")%>', '<%=ht.get("MGR_TEL")%>', '<%=ht.get("MGR_M_TEL")%>', '<%=ht.get("MGR_EMAIL")%>', '<%=ht.get("MGR_ZIP")%>', '<%=ht.get("MGR_ADDR")%>','<%=ht.get("SSN")%>','<%=ht.get("LIC_NO")%>','<%=ht.get("ETC")%>')"><%=ht.get("MGR_NM")%></a></td>
				    <td align="center"><a href="javascript:set_mgr('<%=ht.get("MGR_ST")%>', '<%=ht.get("COM_NM")%>', '<%=ht.get("MGR_DEPT")%>', '<%=ht.get("MGR_NM")%>', '<%=ht.get("MGR_TITLE")%>', '<%=ht.get("MGR_TEL")%>', '<%=ht.get("MGR_M_TEL")%>', '<%=ht.get("MGR_EMAIL")%>', '<%=ht.get("MGR_ZIP")%>', '<%=ht.get("MGR_ADDR")%>','<%=ht.get("SSN")%>','<%=ht.get("LIC_NO")%>','<%=ht.get("ETC")%>')"><%=ht.get("MGR_TITLE")%></a></td>
				    <td align="center"><%=ht.get("MGR_M_TEL")%></td>
				</tr>
<%			}
		}else{		%>
				<tr>
					<td colspan='7'> 검색된 결과가 없습니다 </td>
				</tr>
<%		}
					%>
		  </table>
		</td>
	</tr>
</table>
</body>
</html>