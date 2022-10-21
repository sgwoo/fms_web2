<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	//우편물주소조회 페이지
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String swd 	= request.getParameter("swd")==null?"":request.getParameter("swd");
	String idx 	= request.getParameter("idx")==null?"":request.getParameter("idx");
	String str 	= request.getParameter("str")==null?"":request.getParameter("str");
	
	
%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	function save()
	{
		document.form1.mode.value = 'AFTER';
		document.form1.submit();
	}
	
	function set_post(zip, addr)
	
	{
		var fm = document.form1;
		var idx = fm.idx.value;
		var str = fm.str.value;

		if(idx == ''){
			window.opener.form1.t_zip.value 		= zip;
			window.opener.form1.t_addr.value 		= addr;
		}else{
			window.opener.form1.t_zip[idx].value 	= zip;
			window.opener.form1.t_addr[idx].value 	= addr;
		}

		window.close();
	}
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<p>
<form name='form1' action='search_mgr.jsp' method='post'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='str' value='<%=str%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=750>
	<tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > 고객관리 > <span class=style5>주소검색</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td></td>
    </tr>
<%	
		Vector vt = a_db.getSearchPostList(client_id);
		int size = vt.size();
		if(size > 0){			%>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=750>
				<tr>
					<td class='title' width='7%'> 연번 </td>
					<td width="17%" class='title'>구분</td>
				    <td width="17%" class='title'>우편번호</td>
				    <td class='title'>주소</td>
				</tr>
<%			for(int i = 0 ; i < size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);	%>
				<tr>
					<td align='center'><%=i+1%></td>
					<td align="center"><%=ht.get("ADDR_ST")%></td>					
				    <td align="center"><a href="javascript:set_post('<%=ht.get("ZIP")%>', '<%=ht.get("ADDR")%>')"><%=ht.get("ZIP")%></a></td>
				    <td align="center"><%=ht.get("ADDR")%></td>
				</tr>
<%			}
		}else{		%>
				<tr>
					<td colspan='4' align='center'> 검색된 결과가 없습니다 </td>
				</tr>
<%		}
					%>
		  </table>
		</td>
	</tr>
</table>
</body>
</html>