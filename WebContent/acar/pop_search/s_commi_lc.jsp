<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.beans.*"%>
<jsp:useBean id="CodeDb" class="acar.ma.CodeDatabase" scope="page" />
<jsp:useBean id="OeOffDb" scope="page" class="acar.oe.OeOffDatabase"/>
<jsp:useBean id="OeOffBn" scope="page" class="acar.beans.OeOffBean"/>
<jsp:useBean id="OeEmpDb" scope="page" class="acar.oe.OeEmpDatabase"/>
<jsp:useBean id="OeEmpBn" scope="page" class="acar.beans.OeEmpBean"/>
<jsp:useBean id="LcCommiDb" scope="page" class="acar.lc.LcCommiDatabase"/>
<%@ include file="/acar/cookies_base.jsp" %>

<%
	String emp_id = request.getParameter("emp_id")==null?"":request.getParameter("emp_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	//지급수수료 리스트
	Vector OeEmpList1 = LcCommiDb.getOeEmpLcListSearch(emp_id, "", "", "1");
//out.println(query);	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../include/table.css">
<script language='javascript'>
<!--
	function sel_lc(rent_mng_id, rent_l_cd, commi_st, firm_nm, car_no, car_nm, car_type, car_amt, commi_per){
	<%if(mode.equals("reg")){%>	
		opener.document.form1.rent_mng_id.value = rent_mng_id;
		opener.document.form1.rent_l_cd.value = rent_l_cd;
		opener.document.form1.firm_nm.value = firm_nm;
		opener.document.form1.car_no.value = car_no;
		opener.document.form1.car_nm.value = car_nm;
		opener.document.form1.car_type.value = car_type;
		opener.document.form1.car_amt.value = car_amt;
		opener.document.form1.commi_per.value = commi_per;	
		opener.setCommi();	
	<%}%>
		this.close();
	}
//-->
</script>
</head>
<body>
<table width="850" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td colspan="2" class="line"> 
        
      <table border="0" cellspacing="1" cellpadding="0" width=100%>
        <tr> 
          <td class="title" width="3%">연번</td>
          <td class="title" width="12%">계약번호</td>
          <td class="title" width="12%">차량번호</td>
          <td class="title" width="20%">차명</td>
          <td class="title" width="10%">계약일</td>
          <td class="title" width="10%">출고일</td>
          <td class="title" width="15%">상호</td>
          <td class="title" width="8%">대여구분</td>
          <td class="title" width="10%">차량가격</td>
        </tr>
        <% if(OeEmpList1.size()>0){
				for(int i=0; i<OeEmpList1.size(); i++){ 
					Hashtable ht1 = (Hashtable)OeEmpList1.elementAt(i); %>
        <tr> 
          <td align='center' width="3%"><%= i+1 %></td>
          <td align='center' width="12%"><a href="javascript:sel_lc('<%= ht1.get("RENT_MNG_ID") %>','<%= ht1.get("RENT_L_CD") %>','<%= ht1.get("COMMI_ST") %>','<%= ht1.get("FIRM_NM") %>','<%= ht1.get("CAR_NO") %>','<%= ht1.get("CAR_NM")+" "+ht1.get("CAR_NAME") %>','<%= ht1.get("CAR_TYPE") %>','<%= Util.parseDecimal((String)ht1.get("CAR_AMT")) %>','<%= ht1.get("COMMI_PER") %>');"><%= ht1.get("RENT_L_CD") %></a></td>
          <td align='center' width="12%"><%= ht1.get("CAR_NO") %></td>
          <td align='center' width="20%"><span title='<%= ht1.get("CAR_NM")+" "+ht1.get("CAR_NAME") %>'><%= Util.subData((String)ht1.get("CAR_NM")+" "+(String)ht1.get("CAR_NM"),10) %></span></td>
          <td align='center' width="10%"><%= Util.ChangeDate2((String)ht1.get("RENT_DT")) %></td>
          <td align='center' width="10%"><%= Util.ChangeDate2((String)ht1.get("DLV_DT")) %></td>
          <td align='center' width="15%"><span title='<%= ht1.get("FIRM_NM") %>'><%= Util.subData((String)ht1.get("FIRM_NM"),8) %></span></td>
          <td align='center' width="8%"><%= ht1.get("CAR_TYPE") %></td>
          <td align='center' width="10%"><%= Util.parseDecimal((String)ht1.get("CAR_AMT")) %>원</td>
        </tr>
        <% 		}
			}else{ %>
        <tr> 
          <td colspan="9" align='center'>해당 데이터가 없습니다.</td>
        </tr>
        <% } %>
      </table>
      </td>
    </tr>
</table>
</body>
</html>
