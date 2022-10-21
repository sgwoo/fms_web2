<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=popup_fin_man_excel.xls");
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
<%  String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String use_yn = request.getParameter("use_yn")==null?"Y":request.getParameter("use_yn");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	
	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();
	Vector vt =  new Vector();
	
	if(gubun1.equals("0001")){
		vt = se_dt.getServ_empMailing(gubun1, gubun2);
	}else{
		vt = pd_db.getFinMan(s_kd, use_yn , "E");
	}
	int vt_size = vt.size();
			
%>
<table border="1" cellspacing="0" cellpadding="0" width=1220>
  <tr> 
    <td colspan="10" align="center"><font face="돋움" size="4" > 
      <b>거래금융기관</b> </font></td>
  </tr>
  <tr align="center"> 
    <td width='50' style="font-size : 9pt;">연번</td>
    <td width='100' style="font-size : 9pt;">금융기관명</td>	
    <td width='130' style="font-size : 9pt;">지점명</td>
    <td width='110' style="font-size : 9pt;">담당자</td>
    <td width='150' style="font-size : 9pt;">직책</td>
	<td width='150' style="font-size : 9pt;">이메일주소</td>
	<td width='100' style="font-size : 9pt;">핸드폰</td>   
	<td width='120' style="font-size : 9pt;">전화</td>
    <td width='100' style="font-size : 9pt;">FAX</td>
    <td width='60' style="font-size : 9pt;">우편번호</td>
    <td width='300' style="font-size : 9pt;">주소</td>

  
   </tr>
  <%
  	if(vt_size > 0){
		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	
  <tr> 
    <td width='50' align='center' style="font-size : 8pt;"><%= i + 1 %></td>
    <td width='100' align='center' style="font-size : 8pt;"><%=ht.get("COM_NM")%></td>	
    <td width='130' align='center' style="font-size : 8pt;"><%=ht.get("BR_NM")%></td>
    <td width='110' align='center' style="font-size : 8pt;"><%=ht.get("AGNT_NM")%></td>   
	<td width='110' align='center' style="font-size : 8pt;"><%=ht.get("AGNT_TITLE")%>&nbsp;</td>   
    <td width='150' align='center' style="font-size : 8pt;"><%=ht.get("FIN_EMAIL")%>&nbsp;</td>
	<td width='100' align='center' style="font-size : 8pt;"><%=ht.get("FIN_M_TEL")%>&nbsp;</td>
	<td width='120' align='center' style="font-size : 8pt;"><%=ht.get("FIN_TEL")%>&nbsp;</td>
    <td width='100' align='center' style="font-size : 8pt;"><%=ht.get("FIN_FAX")%>&nbsp;</td>
    <td width='60' align='center' style="font-size : 8pt;"><%=ht.get("FIN_ZIP")%>&nbsp;</td>
    <td width='300' align='left' style="font-size : 8pt;"><%=ht.get("FIN_ADDR")%>&nbsp;</td>
 
    </tr>
<% } %>       
 <% } %>       
</table>
</body>
</html>
