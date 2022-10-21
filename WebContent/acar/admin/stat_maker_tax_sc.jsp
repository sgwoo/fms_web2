<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	//검색구분
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");

	Vector vt = ad_db.getStatMakerCarTax(gubun2, gubun3, gubun4, st_dt, end_dt);
	int vt_size = vt.size();
	
	long total_amt1 =0;
	long total_amt2 =0;
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">

<script language='javascript'>
<!--

//-->
</script>
</head>
<body leftmargin="15" rightmargin=0>
<form name="form1">
<table border="0" cellspacing="0" cellpadding="0" width=500>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width="30%" class="title">구분</td>
                    <td width="30%" class="title">대수</td>
                    <td width="40%" class="title">금액</td>
                </tr>
                <%	for(int i=0; i<vt_size; i++){
    					Hashtable ht = (Hashtable)vt.elementAt(i); 
    					
    					total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("CNT")));
			            total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("CAR_F_AMT")));		
    			%>
                <tr> 
                    <td align="center"><%= ht.get("CAR_COM_ST") %></td>
                    <td align="center"><%= ht.get("CNT") %></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CAR_F_AMT"))) %></td>                    
                </tr>
                <%} %>
                <tr>
                    <td class='title'>합계</td>
                    <td align="center"><%=total_amt1%></td>                    
                    <td align="right"><%=AddUtil.parseDecimal(total_amt2)%></td>
                </tr>	
            </table>
        </td>
    </tr>	
</table>
</form>
</body>
</html>
