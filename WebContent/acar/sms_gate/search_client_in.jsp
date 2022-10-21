<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<script language='javascript'>
<!--
-->
</script>
</head>

<body>
<%
	String s_kd 	= request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	if(t_wd.equals("")) return;
	
	String rent_st = "1";
	String cust_st = "1";
	
	Vector clients = rs_db.getClientList(rent_st, cust_st, s_kd, t_wd);
	int client_size = clients.size();
%>
<form name='form1' action='' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
	    <td class='line'>		  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              	<%if(client_size > 0){
    				for(int i = 0 ; i < client_size ; i++){
    					Hashtable client = (Hashtable)clients.elementAt(i);
    					String gubun = (String)client.get("GUBUN");
    					String rank = (String)client.get("RANK");%>
                <tr> 
                    <td width='5%' align='center'><%=i+1%></td>                    
                    <td width='35%' align='center'><a href="javascript:parent.select('<%= client.get("CUST_ID")%>','<%= client.get("FIRM_NM")%>','<%= client.get("CUST_NM")%>','<%= client.get("M_TEL")%>')" onMouseOver="window.status=''; return true"><span title='<%=client.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(client.get("FIRM_NM")), 8)%></span></a></td>
                    <td width='20%' align='center'><span title='<%=client.get("CUST_NM")%>'><%=AddUtil.subData(String.valueOf(client.get("CUST_NM")), 10)%></span></td>
                    <td width='20%' align='center'><%=client.get("ENP_NO")%></td>
                    <td width='20%' align='center'><%=client.get("M_TEL")%></td>
                </tr>                
              	<%	}%>
    			<%}else{%>
                <tr> 
                    <td colspan="5" align='center'>등록된 데이타가 없습니다</td>
                </tr>
              	<%}%>
            </table>
	    </td>
	</tr>
</table>
</form>
</body>
</html>
