<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.user_mng.*, acar.cooperation.*, tax.*"%>
<jsp:useBean id="cp_db" scope="page" class="acar.cooperation.CooperationDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	
	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	
	Vector vt = cp_db.CooperationUserList(user_id, "[��������߼ۿ�û]");
	int vt_size = vt.size();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language='javascript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

//-->
</script>
</head>

<body>
<form action='' name='form1' method='post'>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> �̼���������� > <span class=style5>��������߼ۿ�û �̷�</span></span></td>
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
            <table border=0 cellspacing=1 cellpadding=0 width='100%'>
				<tr>
					<td width='3%' class='title'> ���� </td>
					<td width='7%' class='title'> ��û���� </td>
					<td width='30%' class='title'> ���� </td>
					<td width='30%' class='title'> ���� </td>
					<td width='18%' class='title'> ó����� </td>					
					<td width='5%' class='title'> ����� </td>
					<td width='7%' class='title'> ó������ </td>
				</tr>
<% if(vt.size()>0){
	for(int i=0; i< vt.size(); i++){
	Hashtable ht = (Hashtable)vt.elementAt(i);
	
	%>
				<tr>
					<td align='center'><%=(i+1)%></td>
					<td align='center'><%= AddUtil.ChangeDate2((String)ht.get("IN_DT")) %></td>
					<td>&nbsp;<%=ht.get("TITLE")%></td>
					<td>&nbsp;<%=ht.get("CONTENT")%></td>
					<td>&nbsp;<%=ht.get("OUT_CONTENT")%></td>										
					<td align='center'><%=ht.get("SUB_NM")%></td>
					<td align='center'><%if(ht.get("OUT_DT").equals("")){%>��ó��<%}else{%><%=ht.get("OUT_DT")%><%}%></td>
				</tr>

			<%}
		}
	else
	{
%>
				<tr>
					<td colspan='7' align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
				</tr>
<%
	}%>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 	
	
	<%	vt = cp_db.CooperationUserList(user_id, "[ä���߽��Ƿڿ�û]");
		vt_size = vt.size();%>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> �̼���������� > <span class=style5>ä���߽��Ƿڿ�û �̷�</span></span></td>
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
            <table border=0 cellspacing=1 cellpadding=0 width='100%'>
				<tr>
					<td width='3%' class='title'> ���� </td>
					<td width='7%' class='title'> ��û���� </td>
					<td width='30%' class='title'> ���� </td>
					<td width='30%' class='title'> ���� </td>
					<td width='18%' class='title'> ó����� </td>					
					<td width='5%' class='title'> ����� </td>
					<td width='7%' class='title'> ó������ </td>
				</tr>
<% if(vt.size()>0){
	for(int i=0; i< vt.size(); i++){
	Hashtable ht = (Hashtable)vt.elementAt(i);
	
	%>
				<tr>
					<td align='center'><%=(i+1)%></td>
					<td align='center'><%= AddUtil.ChangeDate2((String)ht.get("IN_DT")) %></td>
					<td>&nbsp;<%=ht.get("TITLE")%></td>
					<td>&nbsp;<%=ht.get("CONTENT")%></td>
					<td>&nbsp;<%=ht.get("OUT_CONTENT")%></td>										
					<td align='center'><%=ht.get("SUB_NM")%></td>
					<td align='center'><%if(ht.get("OUT_DT").equals("")){%>��ó��<%}else{%><%=ht.get("OUT_DT")%><%}%></td>
				</tr>

			<%}
		}
	else
	{
%>
				<tr>
					<td colspan='7' align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
				</tr>
<%
	}%>
            </table>
        </td>
    </tr>	
    <tr>
	    <td align='center'>	    
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
	    </td>
	</tr>			
</form>
</table>
</body>
</html>
			    