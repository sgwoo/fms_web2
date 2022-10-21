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

	Vector vt = ej_db.getJuyoCars_20090901(car_comp_id, base_dt, "");
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function main_car_upd(est_id, base_dt, car_comp_id, cng_st, diesel_yn){
		opener.location.href = "./main_car_upd_20090901.jsp?est_id="+est_id+"&base_dt="+base_dt+"&car_comp_id="+car_comp_id+"&cng_st="+cng_st+"&diesel_yn="+diesel_yn+"&t_wd=<%=t_wd%>";
	}
//-->
</script>
</head>
<body>
<form action="../estimate_mng/esti_mng_u.jsp" name="form1" method="POST">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width=10% class="title">우선순위</td>
                    <td width=40% class="title">차종</td>
                    <td width=10% class="title">변속기</td>
                    <td width=10% class="title">연료</td>
                    <td width=10% class="title">차량가격</td>
                    <td width=20% class="title">등록일시</td>
                </tr>	
		<% if(vt.size()>0){
			for(int i=0; i<vt.size(); i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				int rb36_amt = AddUtil.parseInt((String)ht.get("RB36_AMT"));
				int rs36_amt = AddUtil.parseInt((String)ht.get("RS36_AMT"));
				int lb36_amt = AddUtil.parseInt((String)ht.get("LB36_AMT"));
				int ls36_amt = AddUtil.parseInt((String)ht.get("LS36_AMT"));
				String auto_yn = (String)ht.get("AUTO_YN");
				String diesel_yn = (String)ht.get("DIESEL_YN"); %>
                <tr> 
                    <td><div align="center"><a href="javascript:main_car_upd('<%= ht.get("EST_ID") %>','<%= base_dt %>','<%= car_comp_id %>','<%= ht.get("CNG_ST") %>','<%= ht.get("DIESEL_YN") %>')"><%= ht.get("SEQ") %></a></div></td>
                    <td>&nbsp;<%= ht.get("CAR_NM") %> <%= ht.get("CAR_NAME") %></td>
                    <td><div align="center">
                    <% if(auto_yn.equals("Y")){ out.print("오토"); }else{ out.print("수동"); } %></div></td>
                    <td><div align="center"><% if(diesel_yn.equals("Y")){
		  											out.print("디젤"); 
		  										}else if(diesel_yn.equals("1")||diesel_yn.equals("0")){
													out.print("휘발유");
												}else if(diesel_yn.equals("2")){
													out.print("LPG");
												}else if(diesel_yn.equals("3")){
													out.print("휘발유");
												}else if(diesel_yn.equals("4")){
													out.print("전기+휘발유");
												}else if(diesel_yn.equals("5")){
													out.print("전기");
												}else if(diesel_yn.equals("6")){
													out.print("수소");	
												} %></div></td>
                    <td><div align="right"><%= AddUtil.parseDecimal((String)ht.get("O_1")) %>원&nbsp;</div></td>
                    <td width=7% align="center">					
					<%if(String.valueOf(ht.get("RENT_DT_ST")).equals("Y")){%><font color=red><%}%>
					<%= AddUtil.ChangeDate3(String.valueOf(ht.get("REG_DT"))) %>
					<%if(String.valueOf(ht.get("RENT_DT_ST")).equals("Y")){%></font><%}%>					
					</td>
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
