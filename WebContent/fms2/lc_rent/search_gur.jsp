<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//연대보증인 페이지
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String swd 	= request.getParameter("swd")==null?"":request.getParameter("swd");
	String idx 	= request.getParameter("idx")==null?"":request.getParameter("idx");
	String str 	= request.getParameter("str")==null?"":request.getParameter("str");
	
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
	
	function set_mgr(gur_nm, gur_ssn, gur_zip, gur_addr, gur_tel, gur_rel)
	
	{
		var fm = document.form1;
		var idx = fm.idx.value;
		var str = fm.str.value;

		window.opener.form1.gur_nm[idx].value 		= gur_nm;
		window.opener.form1.gur_ssn[idx].value 		= gur_ssn;
		window.opener.form1.gur_tel[idx].value 		= gur_tel;
		window.opener.form1.gur_rel[idx].value 		= gur_rel;
		window.opener.form1.t_zip[idx+2].value 		= gur_zip;
		window.opener.form1.t_addr[idx+2].value 	= gur_addr;

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
<form name='form1' action='search_gur.jsp' method='post'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='str' value='<%=str%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=750>
	<tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>연대보증인검색</span></span> : 연대보증인검색</td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width="100" class='title'>성명</td>
					<td>&nbsp;
						<input type='text' name='swd' size='10' class='text' value='<%=swd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
						<a href='javascript:save()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
				  </td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td></td>
	</tr>
<%	Vector vt = a_db.getSearchGurList(client_id, swd);
	int size = vt.size();%>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class='title' width='7%'> 연번 </td>
					<td width="13%" class='title'>계약번호</td>
				    <td width="13%" class='title'>차량번호</td>
				    <td width="13%" class='title'>차명</td>					
				    <td width="13%" class='title'>성명</td>
				    <td width="13%" class='title'>생년월일</td>
				    <td width="13%" class='title'>연락처</td>
				    <td width="15%" class='title'>관계</td>
				</tr>
<%			for(int i = 0 ; i < size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);	%>
				<tr>
					<td align='center'><%=i+1%></td>
					<td align="center"><%=ht.get("RENT_L_CD")%></td>
				    <td align="center"><%=ht.get("CAR_NO")%></td>
				    <td align="center"><%=ht.get("CAR_NM")%></td>
				    <td align="center"><a href="javascript:set_mgr('<%=ht.get("GUR_NM")%>', '<%=ht.get("GUR_SSN")%>', '<%=ht.get("GUR_ZIP")%>', '<%=ht.get("GUR_ADDR")%>', '<%=ht.get("GUR_TEL")%>', '<%=ht.get("GUR_REL")%>')"><%=ht.get("GUR_NM")%></a></td>
				    <td align="center"><%=AddUtil.ChangeEnpH(String.valueOf(ht.get("SSN")))%></td>
				    <td align="center"><%=ht.get("GUR_TEL")%></td>
				    <td align="center"><%=ht.get("GUR_REL")%></td>
				</tr>
<%			}%>
<%			if(!swd.equals("")){
				Vector vt2 = a_db.getSearchGurClientList(client_id, swd);
				int size2 = vt2.size();
				size = size + size2;%>
<%				for(int i = 0 ; i < size2 ; i++){
					Hashtable ht = (Hashtable)vt2.elementAt(i);%>
				<tr>
					<td align='center'><%=size+i+1%></td>
					<td align="center">고객<%//=ht.get("RENT_L_CD")%></td>
				    <td align="center"><%//=ht.get("CAR_NO")%></td>
				    <td align="center"><%//=ht.get("CAR_NM")%></td>
				    <td align="center"><a href="javascript:set_mgr('<%=ht.get("FIRM_NM")%>', '<%=ht.get("ENP_NO")%>', '<%=ht.get("O_ZIP")%>', '<%=ht.get("O_ADDR")%>', '<%=ht.get("O_TEL")%>', '')"><%=ht.get("FIRM_NM")%></a></td>
				    <td align="center"><%=AddUtil.ChangeEnpH(String.valueOf(ht.get("SSN")))%></td>
				    <td align="center"><%=ht.get("O_TEL")%></td>
				    <td align="center"><%=ht.get("O_ADDR")%></td>
				</tr>				
<%				}%>
<%			}%>

<%		if(size == 0){			%>				
				<tr>
					<td colspan='8' align=center> 검색된 결과가 없습니다 </td>
				</tr>
<%		}					%>
		  </table>
		</td>
	</tr>
</table>
</body>
</html>