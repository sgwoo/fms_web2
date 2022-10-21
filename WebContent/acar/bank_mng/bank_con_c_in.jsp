<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="bl_db" scope="session" class="acar.bank_mng.BankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--
	/* Title ���� */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
//-->
</script>
</head>
<%
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	Vector cons = bl_db.getContList(lend_id);
	int cons_size = cons.size();
%>
<body onLoad="javascript:init()">
<table border="0" cellspacing="0" cellpadding="0" width='820'>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='500' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='500'>
				<tr>
					<td width='80'  class=title>�����û����</td>
            		<td width='100' class=title>����ȣ</td>
            		<td width='100' class=title>��ü</td>
            		<td width='120' class=title>����</td>
            		<td width='100' class=title>������ȣ</td>
				</tr>
			</table>
		</td>
		<td class='line' width='320'>
			<table border="0" cellspacing="1" cellpadding="0" width=320>
				<tr>
            		<td width='80'  class=title>���ް���</td>
            		<td width='80' class=title>����ݾ�</td>
            		<td width='80' class=title>���������</td>
            		<td width='80' class=title>�����Ա���</td>
				</tr>
			</table>
		</td>
	</tr>
<%
	if(cons_size > 0)
	{
%>
	<tr>
		<td class='line' width='500' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='500'>
<%
		for(int i = 0 ; i < cons_size ; i++)
		{
			Hashtable con = (Hashtable)cons.elementAt(i);

%>
				<tr>
					<td width='80'  align='center'><%=con.get("LOAN_ST_DT")%></td>
            		<td width='100' align='center'><a href="javascript:parent.view_mapping('<%=con.get("CAR_MNG_ID")%>')"  onMouseOver="window.status=''; return true"><%=con.get("RENT_L_CD")%></a></td>
            		<td width='100' align='center'><span title='<%=con.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(con.get("FIRM_NM")), 6)%></span></td>
            		<td width='120' align='center'><span title='<%=con.get("CAR_NM")%>'><%=Util.subData(String.valueOf(con.get("CAR_NM")), 7)%></span></td>
            		<td width='100' align='center'><%=con.get("CAR_NO")%></td>
				</tr>
<%
		}
%>
			</table>
		</td>
		<td class='line' width='320'>
			<table border="0" cellspacing="1" cellpadding="0" width=320>
<%
		for(int i = 0 ; i < cons_size ; i++)
		{
			Hashtable con = (Hashtable)cons.elementAt(i);
%>			
				<tr>
					
            		<td width='80' align='center'><%=Util.parseDecimal(String.valueOf(con.get("SUP_AMT")))%>��</td>
            		<td width='80' align='center'><%=Util.parseDecimal(String.valueOf(con.get("LOAN_AMT")))%>��</td>
            		<td width='80' align='center'><%=con.get("LOAN_ACK_DT")%></td>
            		<td width='80' align='center'><%=con.get("LOAN_REC_DT")%></td>
				</tr>
<%
		}
%>
			</table>
		</td>
<%	}                  
	else               
	{
%>                     
	<tr>
		<td class='line' width='500' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width=500>
				<tr>
					<td align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
				</tr>
			</table>
		</td>
		<td class='line' width='320'>
			<table border="0" cellspacing="1" cellpadding="0" width='320'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%                     
	}                  
%>
</table>
</body>
</html>