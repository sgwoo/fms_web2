<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=master_car_excel_print.xls");
%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.master_car.*"%>
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
</script>

<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	int total_su = 0;
	long total_amt = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	Vector exps = mc_db.Master_CarList(gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int exp_size = exps.size();
	
	
%>
<table border="1" cellspacing="0" cellpadding="0" width=1200>
  <tr> 
    <td colspan="25" align="left"><font face="돋움" size="4" > 긴급출동내역     </font></td>
  </tr>
  <tr align="center"> 
   	
	<td width='8%' class='title'>연번</td>
	<td width='12%' class='title'>업체</td>
	<td width='8%' class='title'>접수일</td>
	<td width='10%' class='title'>계약번호</td>
	<td width='20%' class='title'>상호</td>
	<td width='15%' class='title'>고객명</td>
	<td width='12%' class='title'>차량번호</td>
	<td width='19%' class='title'>차명</td>
    <td width='10%' class='title'>담당자</td>
    <td width='20%' class='title'>서비스항목</td>
    <td width='10%' class='title'>금액</td>
   
   </tr>
  <%
   	if(exp_size > 0){
		for(int i = 0 ; i < exp_size ; i++){
			Hashtable exp = (Hashtable)exps.elementAt(i);
			
			total_amt   = total_amt  + AddUtil.parseLong(String.valueOf(exp.get("SBGB_AMT")));
		%>			
 		 <tr>  
           <td width='8%' align='center'><%=i+1%></td>
           <td width='12%' align='center'>
           <% if ( String.valueOf(exp.get("GUBUN")).equals("1")  )  {  %>마스타자동차<% } %>
           <% if ( String.valueOf(exp.get("GUBUN")).equals("5")  )  {  %>삼성애니카랜드<% } %>
           <% if ( String.valueOf(exp.get("GUBUN")).equals("7")  )  {  %>SK네트웍스<% } %>
           </td>
           <td width='8%' align='center'><%=exp.get("LJS_DT")%></td>
           <td width='10%' align='center'><%=exp.get("RENT_L_CD")%></td>
           <td width='20%' align='center'><span title='<%=exp.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(exp.get("FIRM_NM")), 16)%></span></td>          
           <td width='15%' align='center'><span title='<%=exp.get("GGM")%>'><%=Util.subData(String.valueOf(exp.get("GGM")),6)%></span></td> 
           <td width='12%' align='center'><%=exp.get("CAR_NO")%></td>
           <td width='19%' align='center'><span title='<%=exp.get("CAR_NM")%>%>'><%=Util.subData(String.valueOf(exp.get("CAR_NM")), 12)%></span></td>
           <td width='10%' align='center'><%=exp.get("USER_NM")%></td>
           <td width='20%' align='center'><%=Util.subData(String.valueOf(exp.get("SBSHM")), 10)%></td>
           <td width='10%' align='right'><%=AddUtil.parseDecimal(exp.get("SBGB_AMT"))%></td> 
                  
        </tr>  	 
<%		}	
 }
%>
		  <tr>   
		    <td colspan=9 align="center">총합계</td>
		     <td class="title" colspan="2" style='text-align:right'><%=Util.parseDecimal(total_amt)%></td>	
			
		  </tr>
</table>
</body>
</html>
