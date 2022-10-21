<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	
	Vector vt = ad_db.getStatOffBlackbox();
	int vt_size = vt.size();

%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
  <table border="0" cellspacing="0" cellpadding="0" width=500>
    <tr>
		  <td class=line2 ></td>
	  </tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr align="center"> 
            <td width=100 class=title>날짜</td>
            <td width=100 class=title>구분</td>
            <td width=100 class=title>입고</td>
            <td width=100 class=title>출고</td>
            <td width=100 class=title>잔고</td>
          </tr>
				  <%
				  	for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
					%>
          <tr> 
            <td align="center"><%=ht.get("SUP_DT")%></td>
            <td align="center"><%=ht.get("ST")%></td>
            <td align="right"><%=ht.get("C_SU")%></td>
            <td align="right"><%=ht.get("D_SU")%></td>
            <td align="right"><%=ht.get("J_SU")%></td>                        
          </tr>          
					<%}%>
        </table>
      </td>    
    </tr>
  </table>
</form>
</body>
</html>
