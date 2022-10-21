<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//주요차종 월대여료 리스트 페이지
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String base_dt 		= request.getParameter("base_dt")==null?"":request.getParameter("base_dt");
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");	
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	
	
	EstiJuyoDatabase ej_db = EstiJuyoDatabase.getInstance();
	Vector vt = ej_db.getJuyoHotCars();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="../estimate_mng/esti_mng_u.jsp" name="form1" method="POST">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<table width="600" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > <span class=style5>인기차종 (48개월 기준)</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
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
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width=10% class="title">인기차량</td>					
                    <td width=45% class="title">차종</td>
                    <td width=15% class="title">차량가격</td>
                   
                    <td width=15% class="title">렌트기본식</td>
                     <td width=15% class="title">리스기본식</td>
                </tr>	
		<% if(vt.size()>0){
			for(int i=0; i<vt.size(); i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String auto_yn = (String)ht.get("AUTO_YN");
				String diesel_yn = (String)ht.get("DIESEL_YN"); %>
                <tr> 
                    <td <%if(String.valueOf(ht.get("EST_FAX")).substring(0,1).equals("2")) out.println("class=is");%> align="center"><%= ht.get("EST_FAX") %></td>
                    <td <%if(String.valueOf(ht.get("EST_FAX")).substring(0,1).equals("2")) out.println("class=is");%>>&nbsp;<%= ht.get("CAR_NM") %> <%= ht.get("CAR_NAME") %></td>
                    <td <%if(String.valueOf(ht.get("EST_FAX")).substring(0,1).equals("2")) out.println("class=is");%> align="right"><%= AddUtil.parseDecimal((String)ht.get("O_1")) %>원</td>					
                    				
                    <td <%if(String.valueOf(ht.get("EST_FAX")).substring(0,1).equals("2")) out.println("class=is");%> align="right"><%= AddUtil.parseDecimal((String)ht.get("RB_FEE_S_AMT")) %>원<br><font color='#999999'><%= ht.get("RB_EST_ID") %></font></td>					
               		<td <%if(String.valueOf(ht.get("EST_FAX")).substring(0,1).equals("2")) out.println("class=is");%> align="right"><%= AddUtil.parseDecimal((String)ht.get("LB_FEE_S_AMT")) %>원<br><font color='#999999'><%= ht.get("LB_EST_ID") %></font></td>	
               </tr>
        		<%	}
        		 }else{ %>
        		<% } %>
            </table>
        </td>
    </tr>
    <tr>
        <td align=right><a href=javascript:self.close();><img src=../images/center/button_close.gif border=0></td>
    </tr>
</table>
</form>
</body>
</html>
