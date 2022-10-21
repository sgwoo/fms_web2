<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="p_db" scope="page" class="cust.pay.PayDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String member_id = request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site = request.getParameter("r_site")==null?"":request.getParameter("r_site");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String tax_no = request.getParameter("tax_no")==null?"":request.getParameter("tax_no");
	String item_id = request.getParameter("item_id")==null?"":request.getParameter("item_id");	
	
	Vector conts = p_db.getPrintList(member_id, tax_no, item_id);
	int cont_size = conts.size();
	
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post' action='tax_c.jsp' target='d_content'>
  <input type='hidden' name="member_id" value="<%=member_id%>">
  <input type='hidden' name="client_id" value="<%=client_id%>">
  <input type='hidden' name="r_site" value="<%=r_site%>">
  <input type='hidden' name="auth_rw" value="<%=auth_rw%>">
  <input type='hidden' name="tax_no" value="<%=tax_no%>">
<table border="0" cellspacing="0" cellpadding="0" width=400>
    <tr> 
        <td width='400'>&nbsp;<%if(!tax_no.equals("")){%><img src=../images/center/arrow_sggss_print.gif border=0><%}%><%if(!item_id.equals("")){%><img src=../images/center/arrow_grmss_print.gif border=0><%}%></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line' width='400'> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='30' class='title'>연번</td>
                    <td width='185' class='title'>인쇄일시</td>
                    <td width='185' class='title'>고객 IP</td>
                </tr>
                  <%	if(cont_size > 0){	%>
                  <%		for(int i = 0 ; i < cont_size ; i++){
        					Hashtable cont = (Hashtable)conts.elementAt(i);%>
                <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(cont.get("PRINT_DT")))%></td>
                    <td align='center'><%=cont.get("PRINT_IP")%></td>
                </tr>
                  <%		}%>
                  <%	}else{%>
                <tr> 
                    <td align='center' colspan="3">해당 데이타가 없습니다.</td>
                </tr>
                <%	}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td width='400' align="right"><a href="javascript:window.close()">닫기</a></td>
    </tr>	  
</table>
</form>
</body>
</html>

