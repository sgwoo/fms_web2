<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.settle_acc.*, acar.cont.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st = request.getParameter("r_st")==null?"":request.getParameter("r_st");
	String fee_tm = request.getParameter("fee_tm")==null?"":request.getParameter("fee_tm");
	String tm_st1 = request.getParameter("tm_st1")==null?"":request.getParameter("tm_st1");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector settles = s_db.getTotalTelList(m_id, l_cd);
	int settle_size = settles.size();
%>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td class='line'>
			 <table border="0" cellspacing="1" cellpadding="0" width=100%>
<%	if(settle_size > 0){%>
<%		for (int i = 0 ; i < settle_size ; i++){
			Hashtable settle = (Hashtable)settles.elementAt(i);%>
			    <tr>
					<td width='10%' align='center'><%=AddUtil.ChangeDate2((String)settle.get("REG_DT"))%></td>
					<td width='12%' align='center'><%=settle.get("GUBUN")%><%=settle.get("TM")%></td>					
					<td width='10%' align='center'><%=c_db.getNameById((String)settle.get("REG_ID"), "USER")%></td>
					<td width='10%' align='center'><%=settle.get("SPEAKER")%></td>
					<td width='58%'>
					    <table>
						    <tr>
						        <td><%=Util.htmlBR((String)settle.get("CONTENT"))%></td>
						    </tr>
					    </table>
					</td>
				</tr>
<%		}%>
<%	}else{%>
				<tr>
					<td colspan='5' align='center'>등록된 데이타가 없습니다 </td>
				</tr>
<%	}%>
			</table>
		</td>
	</tr>
</table>
</body>
</html>
