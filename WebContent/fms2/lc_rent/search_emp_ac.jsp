<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*"%>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, "01", "01", "09");


	//중고차 딜러 및 판매처 조회 페이지
	
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");	//DEL=중고차딜러/AUC=중고차판매처
	String mode 	= request.getParameter("mode")==null?"0":request.getParameter("mode"); 	//1=검색
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd"); 	//검색어
	String idx 	= request.getParameter("idx")==null?"":request.getParameter("idx");
	String off_id 	= request.getParameter("h_off_id")==null?"":request.getParameter("h_off_id");
	String one_self = request.getParameter("one_self")==null?"":request.getParameter("one_self");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String pur_bus_st = request.getParameter("pur_bus_st")==null?"":request.getParameter("pur_bus_st");
	String bus_id = request.getParameter("bus_id")==null?"":request.getParameter("bus_id");
	
	String jg_w = "";
	
	if(AddUtil.parseInt(car_comp_id) > 5)	jg_w = "1";
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//영업사원 검색하기
	function set_com(){
		document.form1.mode.value = '1';
		document.form1.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') set_com();
	}
		
	
	//영업소-사원명 셋팅
	function set_emp(emp_id, emp_nm, car_off_nm, car_off_id, car_off_st, cust_st, emp_bank, emp_acc_no, emp_acc_nm, bank_cd){
		var idx=0;
		if(document.form1.gubun.value == 'DEL'){
			opener.document.form1.emp_id[0].value 		= emp_id;
			opener.document.form1.emp_nm[0].value 		= emp_nm;
			opener.document.form1.car_off_nm[0].value = car_off_nm;
			opener.document.form1.car_off_id[0].value = car_off_id;
			opener.document.form1.car_off_st[0].value = '';
			opener.document.form1.emp_bank.value 			= emp_bank;
			opener.document.form1.emp_bank_cd.value 	= bank_cd;
			opener.document.form1.emp_acc_no.value 		= emp_acc_no;
			opener.document.form1.emp_acc_nm.value 		= emp_acc_nm;
		}else{
			opener.document.form1.emp_id[1].value 		= emp_id;
			opener.document.form1.emp_nm[1].value 		= emp_nm;
			opener.document.form1.car_off_nm[1].value = car_off_nm;
			opener.document.form1.car_off_id[1].value = car_off_id;
			opener.document.form1.con_bank.value 			= emp_bank;
			opener.document.form1.con_acc_no.value 		= emp_acc_no;
			opener.document.form1.con_acc_nm.value 		= emp_acc_nm;
		}
		self.close();
	}
//-->
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.t_wd.focus();">
<p>
<form name='form1' action='search_emp_ac.jsp' method='post'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='one_self' value='<%=one_self%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='h_off_id' value=''>
<input type='hidden' name='h_emp_id' value=''>
<input type='hidden' name='car_comp_id' value='<%=car_comp_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	      <td>&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 상호/연락처 :	
	          <input type='text' name='t_wd' size='20' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
	          <a href='javascript:set_com()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
        <td align="right"></td>
    </tr>
    <tr>
	<td class=h></td>
    </tr>
    <tr>
	<td class=line2 colspan=2></td>		
    </tr>
    <tr>
	<td class="line" colspan=2>
	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="8%" class='title'>연번</td>
                    <td width="20%" class='title'>소속사</td>
                    <td width="20%" class='title'>근무처</td>
                    <td width="20%" class='title'>성명</td>
                    <td width="12%" class='title'>직위</td>		  
                    <td width="20%" class='title'>연락처</td>
                </tr>
                <%	if(!t_wd.equals("")){
        							CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	        						CarOffEmpBean coe_r [] = umd.getCarOffEmpAll("mix", t_wd, "emp_nm", "asc","");
    	    						if(coe_r.length > 0){
        								for(int i = 0 ; i < coe_r.length ; i++){
        									coe_bean = coe_r[i];
													//근무지역 주소 가져오기
        									Hashtable ht = umd.getCar_off_addr(coe_bean.getCar_off_id());
        				%>
                <tr align="center">
                    <td><%=i+1%></td>
                    <td><%= coe_bean.getCar_comp_nm() %></td>
                    <td><%= coe_bean.getCar_off_nm() %></td>
                    <td>                                           
                        <%if(gubun.equals("DEL")){//출고담당%>
			                  <a href="javascript:set_emp('<%= coe_bean.getEmp_id() %>','<%= coe_bean.getEmp_nm() %>','<%= coe_bean.getCar_off_nm() %>','<%= coe_bean.getCar_off_id() %>','<%= coe_bean.getCar_off_st() %>','<%= coe_bean.getCust_st() %>','<%= ht.get("BANK") %>','<%= ht.get("ACC_NO") %>','<%= ht.get("ACC_NM") %>','<%= ht.get("BANK_CD") %>')" onMouseOver="window.status=''; return true"><%= coe_bean.getEmp_nm() %></a>
			                  <%}else{//영업담당%>
			                  <a href="javascript:set_emp('<%= coe_bean.getEmp_id() %>','<%= coe_bean.getEmp_nm() %>','<%= coe_bean.getCar_off_nm() %>','<%= coe_bean.getCar_off_id() %>','<%= coe_bean.getCar_off_st() %>','<%= coe_bean.getCust_st() %>','<%= coe_bean.getEmp_bank() %>','<%= coe_bean.getEmp_acc_no() %>','<%= coe_bean.getEmp_acc_nm() %>','<%= ht.get("BANK_CD") %>')" onMouseOver="window.status=''; return true"><%= coe_bean.getEmp_nm() %></a>						
			                  <%}%>
		                </td>
                    <td><%= coe_bean.getEmp_pos() %></td>		  
                    <td><%= coe_bean.getEmp_m_tel() %><%if(coe_bean.getEmp_m_tel().equals("")){%><%= coe_bean.getCar_off_tel() %><%}%></td>
                </tr>
                <%			}
        							}else{%>
                <tr align="center">
                    <td colspan="6">등록된 영업사원이 없습니다 </td>
                </tr>
                <%		}%>
        	      <%	}else{%>
                <tr align="center">
                    <td colspan="6">검색어가 없습니다.</td>
                </tr>
		            <%	}%>
            </table>
        </td>
	</tr>
	<tr>
	    <td colspan=2></td>
	</tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>