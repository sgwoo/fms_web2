<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=case_excel.xls");
%>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*" %>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	
	
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	FineBean f_r [] = a_fdb.getForfeitDetailAll(c_id, m_id, l_cd);
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
</head>
<body>
<table border="1" cellspacing="0" cellpadding="0">
  <tr> 
    <td colspan="13" align="center"><font face="돋움" size="5" ><b>과태료 리스트</b></font></td>
  </tr>
  <tr align="center"> 
    <td class=title>연번</td>
    <td class=title>위반일자</td>
    <td class=title>과실여부</td>
    <td class=title>청구기관</td>
    <td class=title>위반장소</td>
    <td class=title>위반내용</td>
    <td class=title>고지서번호</td>
    <td class=title>납부구분</td>
    <td class=title>영수일자</td>
    <td class=title>납부기한</td>
    <td class=title>대납일자</td>
    <td class=title>수금일자</td>
    <td class=title>납부금액</td>
  </tr>
<%	for(int i=0; i<f_r.length; i++){
    	f_bean = f_r[i];%>  <tr> 
    <td align='center' valign="middle"><font size="2"><%=i+1%></font></td>
								<td align="center"><%=f_bean.getVio_dt_view()%></td>
			            		<td align="center"><%=f_bean.getFault_st_nm()%></td>
			            		<td align="left"><%=f_bean.getPol_sta()%></td>
			            		<td align="left"><%=f_bean.getVio_pla()%></td>
								<td align="left"><%=f_bean.getVio_cont()%></td>
			            		<td align="left"><%=f_bean.getPaid_no()%></td>
			            		<td align="center"><%=f_bean.getPaid_st_nm()%></td>
			            		<td align="center"><%=f_bean.getRec_dt()%></td>
			            		<td align="center"><%=f_bean.getPaid_end_dt()%></td>
			            		<td align="center"><%=f_bean.getProxy_dt()%></td>
			            		<td align="center"><%=f_bean.getColl_dt()%></td>
			            		<td align="right"><%=Util.parseDecimal(f_bean.getPaid_amt())%> 원</td>
  </tr>
<%	}
	if(f_r.length == 0){ %>
		    		        <tr>
		            		    
    <td align=center height=25 colspan="13">자료가 없습니다.</td>
			    	        </tr>
<%	}%></table>
<p>&nbsp;</p>
</body>
</html>
