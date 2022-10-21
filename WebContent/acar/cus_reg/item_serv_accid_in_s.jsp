<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id 		= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	Serv_ItemBean[] siBns = cr_db.getServ_item(car_mng_id, serv_id, "asc");
	
	double amt_sum 		= 0;
	double labor_sum 	= 0;
	
	//명진, 부경인 경우 :도장을 공임에 포함 (모든공업사에서 도장은 공임으로 한다 20090604)
	double r_amt_sum = 0;
	double r_labor_sum = 0;	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//-->
</script>
</head>

<body>
<form name="form1">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td class=line>
	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <%if(siBns.length >0){
				for(int i=0; i<siBns.length; i++){
					Serv_ItemBean siBn = siBns[i];
					amt_sum += siBn.getAmt();
					labor_sum += siBn.getLabor(); 
					
        							r_labor_sum += siBn.getLabor(); 
        							if ( siBn.getWk_st().equals("도장")) {
        								r_labor_sum += siBn.getAmt();
        							}
        							else {
        								r_amt_sum += siBn.getAmt();
        							}
					
					%>
          <tr> 
            <td width="30" align="center"><%= i+1 %></td>
            <td width="70" align="center">&nbsp;<%= siBn.getItem_st() %> </td>
            <td width="280" align="left">&nbsp;&nbsp;<%= siBn.getItem() %></td>
            <td width="100" align="center">&nbsp;<%= siBn.getWk_st() %> </td>
            <td width="100" align="left">&nbsp;&nbsp;<%= siBn.getItem_cd() %></td>			
            <td width="100" align="right"><input type="text" name="amt1" size="10" value="<%= AddUtil.parseDecimal(siBn.getAmt()) %>" class=whitenum>
			  원&nbsp;</td>
            <td width="100" align="right"><input type="text" name="amt2" size="10" value="<%= AddUtil.parseDecimal(siBn.getLabor()) %>" class=whitenum>
			  원&nbsp;</td>
          </tr>
          <%	}
			}else{ %>
		  <tr>
		    <td align="center">데이타가 없습니다.</td>
		  </tr>	
		  <%}%>	
                            <input type="hidden" name="r_amt_sum"  size="10" value="<%= AddUtil.parseDecimal(r_amt_sum) %>" > 
                            <input type="hidden" name="r_labor_sum" size="10" value="<%= AddUtil.parseDecimal(r_labor_sum) %>" > 		  
        </table>
	  </td>
    </tr>
  </table>
</form>  
</body>
</html>
<%if(siBns.length >0){%>
<script language="JavaScript">
	fm = document.form1;
	
	parent.form1.item_sum.value 	= '<%= AddUtil.parseDecimal(amt_sum+labor_sum) %>';
	parent.form1.amt_sum2.value 	= '<%= AddUtil.parseDecimal(amt_sum+labor_sum) %>';
	parent.form1.amt_sum.value 		= '<%= AddUtil.parseDecimal(amt_sum) %>';
	parent.form1.labor_sum.value 	= '<%= AddUtil.parseDecimal(labor_sum) %>';		
	
	parent.form1.r_labor.value 		= parseDecimal(toInt(parseDigit(fm.r_labor_sum.value)));
	parent.form1.r_amt.value   		= parseDecimal(toInt(parseDigit(fm.r_amt_sum.value)));	
//	parent.form1.r_j_amt.value 		= parseDecimal(toInt(parseDigit(fm.r_amt_sum.value)));
		
	parent.chk_add_amt();
</script>
<% } %>
