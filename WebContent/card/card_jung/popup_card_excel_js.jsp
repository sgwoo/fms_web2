<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=popup_card_excel_js.xls");
%>

<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
</script>

<body>
<%  String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");	

	String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");	

	long t_amt1[] = new long[1];
    long t_amt2[] = new long[1];
    long t_amt3[] = new long[1];
    long t_amt4[] = new long[1];
    long t_amt5[] = new long[1];
    long t_amt6[] = new long[1];
    long t_amt7[] = new long[1];
    long t_amt8[] = new long[1];
    long t_amt9[] = new long[1];
    long t_amt10[] = new long[1];
    long t_amt11[] = new long[1];   
   	long t_amt12[] = new long[1];  
   	int  t_amt13  = 0;  
	
%>
<table border="1" cellspacing="0" cellpadding="0" width=720>
  <tr> 
    <td colspan="4" align="center"><font face="돋움" size="4" > 
      <b>기간: <%=ref_dt1%> ~ <%=ref_dt2%>  식대 </b> </font></td>
  </tr>
  <tr align="center"> 
    <td width='50'>연번</td>
    <td width='80'>사번</td>
    <td width='70'>이름</td>
    <td width='100'>정산액</td>
   </tr>
  <%
   
    Vector vts2 = CardDb.getCardJungDtStatI(dt, ref_dt1, ref_dt2, br_id, dept_id, user_nm);
    
    int vt_size2 = vts2.size();

  	if(vt_size2 > 0){
		for(int i = 0 ; i < vt_size2 ; i++){
			Hashtable ht = (Hashtable)vts2.elementAt(i);%>

			
  <tr> 
    <td width='50' align='center'><%= i + 1 %></td>
    <td width='80' align='center'><%=ht.get("ID")%></td>	
    <td width='70' align='center'><%=ht.get("USER_NM")%>&nbsp;</td>
    <td width='100' align='right'><%=Util.parseDecimal(AddUtil.sl_th_rnd(String.valueOf(ht.get("REMAIN_AMT"))))%></td>
  </tr>
  <%		
  		}
	}%>

</table>
</body>
</html>
