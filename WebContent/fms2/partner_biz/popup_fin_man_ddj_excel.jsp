<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=popup_fin_man_ddj_excel.xls");
%>
<%@ page import="java.util.*, acar.util.*, acar.partner.* "%>
<jsp:useBean id="pd_db" scope="page" class="acar.partner.PartnerDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
</script>

<body>
<%  
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String mail_yn = request.getParameter("mail_yn")==null?"":request.getParameter("mail_yn");
	String use_yn = request.getParameter("use_yn")==null?"Y":request.getParameter("use_yn");
	
	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();
	
	Vector vt =  new Vector();
	vt = se_dt.getServ_offList_ddj(s_kd, t_wd, gubun1, gubun2, sort_gubun, sort, "1", br_id, mail_yn);
	int vt_size = vt.size();
%>
<table border="1" cellspacing="0" cellpadding="0" width=1220>
  	<tr> 
    	<td colspan="12" align="center">
    		<font face="돋움" size="4" ><b>거래금융기관</b> </font>
    	</td>
  	</tr>
  	<tr align="center"> 
	    <td width='50' style="font-size : 9pt;">연번</td>
	    <td width='100' style="font-size : 9pt;">관리구분</td>	
	    <td width='150' style="font-size : 9pt;">상호</td>
	    <td width='100' style="font-size : 9pt;">성명</td>
	    <td width='150' style="font-size : 9pt;">부서</td>
		<td width='150' style="font-size : 9pt;">직책</td>
		<td width='150' style="font-size : 9pt;">직통전화번호</td>   
		<td width='150' style="font-size : 9pt;">휴대폰</td>
	    <td width='200' style="font-size : 9pt;">E-MAIL</td>
	    <td width='100' style="font-size : 9pt;">담당업무</td>
	    <td width='150' style="font-size : 9pt;">최초등록일</td>
	    <td width='150' style="font-size : 9pt;">변경등록일</td>  
	</tr>
<%if (vt_size > 0) {%>	
	<%for (int i = 0; i < vt_size; i++) {%>
	<%
		Hashtable ht = (Hashtable)vt.elementAt(i);
	%>	
  	<tr> 
	    <td width='50' align='center' style="font-size : 8pt;"><%=i+1%></td>
	    <td width='100' align='center' style="font-size : 8pt;"><%=ht.get("NM_CD")%>&nbsp;</td>	
	    <td width='150' align='center' style="font-size : 8pt;"><%=ht.get("OFF_NM")%>&nbsp;</td>
	    <td width='100' align='center' style="font-size : 8pt;"><%=ht.get("EMP_NM")%>&nbsp;</td>   
		<td width='150' align='center' style="font-size : 8pt;"><%=ht.get("DEPT_NM")%>&nbsp;</td>   
	    <td width='150' align='center' style="font-size : 8pt;"><%=ht.get("EMP_POS")%>&nbsp;</td>
		<td width='150' align='center' style="font-size : 8pt;"><%=ht.get("EMP_HTEL")%>&nbsp;</td>
		<td width='150' align='center' style="font-size : 8pt;"><%=ht.get("EMP_MTEL")%>&nbsp;</td>
	    <td width='200' align='center' style="font-size : 8pt;"><%=ht.get("EMP_EMAIL")%>&nbsp;</td>
	    <td width='100' align='center' style="font-size : 8pt;"><%=ht.get("EMP_ROLE")%>&nbsp;</td>
	    <td width='150' align='center' style="font-size : 8pt;"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>&nbsp;</td>
	    <td width='150' align='center' style="font-size : 8pt;"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("UPT_DT")))%>&nbsp;</td>
    </tr>
	<%}%>
<%}%>
</table>
</body>
</html>
