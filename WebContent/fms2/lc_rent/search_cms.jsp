<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//자동이체 조회 페이지
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String swd 	= request.getParameter("swd")==null?"":request.getParameter("swd");
	String idx 	= request.getParameter("idx")==null?"":request.getParameter("idx");
	String str 	= request.getParameter("str")==null?"":request.getParameter("str");
	String from_page= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
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
					
	function set_cms(cms_acc_no, cms_bank, cms_dep_nm, cms_day, cms_dep_ssn, cms_dep_post, cms_dep_addr, cms_tel, cms_m_tel, cms_email, bank_cd)
	
	{
		var fm = document.form1;
		var idx = fm.idx.value;
		var str = fm.str.value;

		window.opener.form1.cms_acc_no.value 		= cms_acc_no;
		window.opener.form1.cms_bank.value 			= cms_bank;
		window.opener.form1.cms_dep_nm.value 		= cms_dep_nm;
		window.opener.form1.cms_dep_ssn.value 	= cms_dep_ssn;
		window.opener.form1.cms_tel.value 			= cms_tel;
		window.opener.form1.cms_m_tel.value 		= cms_m_tel;
		window.opener.form1.cms_email.value 		= cms_email;
		window.opener.form1.cms_bank_cd.value 	= bank_cd;
		
		<%if(idx.equals("")){%>
			window.opener.form1.t_zip.value 	= cms_dep_post;
			window.opener.form1.t_addr.value 	= cms_dep_addr;
		<%}else{%>
			window.opener.form1.cms_day.value 	= cms_day;
			window.opener.form1.t_zip[idx].value 	= cms_dep_post;
			window.opener.form1.t_addr[idx].value 	= cms_dep_addr;
		<%}%>
		window.close();
	}
//-->
</script>
</head>
<body>
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 고객관리 > <span class=style5>자동이체검색</span></span> : 자동이체검색</td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
<%	
		Vector vt = a_db.getSearchCmsList(client_id);
		int size = vt.size();
		if(size > 0){			%>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
				    <td width='5%' class='title'>연번</td>
				    <td width="15%" class='title'>계약번호</td>
				    <td width="10%" class='title'>계약일자</td>
				    <td width="10%" class='title'>은행명</td>
				    <td width="15%" class='title'>계좌번호</td>
				    <td width="15%" class='title'>예금주</td>
				    <td width="10%" class='title'>결제일자</td>
				    <td width="10%" class='title'>시작일</td>
				    <td width="10%" class='title'>종료일</td>
				</tr>
<%			for(int i = 0 ; i < size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);	%>												
				<tr>
				    <td align='center'><%=i+1%></td>
				    <td align="center"><%=ht.get("RENT_L_CD")%></td>
				    <td align="center"><%=ht.get("RENT_DT")%></td>					
				    <td align="center"><%=ht.get("CMS_BANK")%></td>
				    <td align="center"><a href="javascript:set_cms('<%=ht.get("CMS_ACC_NO")%>', '<%=ht.get("CMS_BANK")%>', '<%=ht.get("CMS_DEP_NM")%>', '<%=ht.get("CMS_DAY")%>', '<%=ht.get("CMS_DEP_SSN2")%>', '<%=ht.get("CMS_DEP_POST")%>', '<%=ht.get("CMS_DEP_ADDR")%>', '<%=ht.get("CMS_TEL")%>', '<%=ht.get("CMS_M_TEL")%>', '<%=ht.get("CMS_EMAIL")%>', '<%=ht.get("BANK_CD")%>')"><%=ht.get("CMS_ACC_NO")%></a></td>
				    <td align="center"><%=ht.get("CMS_DEP_NM")%></a></td>
				    <td align="center"><%=ht.get("CMS_DAY")%></td>
				    <td align="center"><%=ht.get("CMS_START_DT")%></td>
				    <td align="center"><%=ht.get("CMS_END_DT")%></td>
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