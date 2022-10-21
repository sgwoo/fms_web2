<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String serv_st = request.getParameter("serv_st")==null?"":request.getParameter("serv_st");
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	Serv_ItemBean[] siBns = cr_db.getServ_item(car_mng_id, serv_id, "desc");
	
	double amt_sum = 0;
	double labor_sum = 0;
	
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
function setting(){
	var fm = document.form1;
	var pfm = parent.document.form1;
	
	pfm.seq_no.value	= fm.seq_no.value;
	pfm.item_st.value	= fm.item_st.value;
	pfm.item_id.value	= fm.item_id.value;	
	pfm.item_cd.value	= fm.item_cd.value;		
	pfm.item.value 		= fm.item.value;
	pfm.wk_st.value		= fm.wk_st.value;
	pfm.count.value 	= fm.count.value;
	pfm.price.value 	= fm.price.value;
	pfm.amt.value 		= fm.amt.value;
	pfm.labor.value 	= fm.labor.value;
	pfm.bpm.value		= fm.bpm.value;
}
function setting2(idx){
	var fm = document.form1;
	var pfm = parent.document.form1;
	
	pfm.seq_no.value	= fm.seq_no[idx].value;
	pfm.item_st.value	= fm.item_st[idx].value;
	pfm.item_id.value	= fm.item_id[idx].value;	
	pfm.item_cd.value	= fm.item_cd[idx].value;		
	pfm.item.value 		= fm.item[idx].value;
	pfm.wk_st.value		= fm.wk_st[idx].value;
	pfm.count.value 	= fm.count[idx].value;
	pfm.price.value 	= fm.price[idx].value;
	pfm.amt.value 		= fm.amt[idx].value;
	pfm.labor.value 	= fm.labor[idx].value;
	pfm.bpm.value		= fm.bpm[idx].value;
}
//-->
</script>
<script language="JavaScript">
<!--
function set_tot_amt(){
	fm = document.form1;
	var sup_amt = toInt(parseDigit(fm.amt_sum.value)) + toInt(parseDigit(fm.labor_sum.value));
	var add_amt = sup_amt/10;
	
	parent.form1.item_sum.value = parseDecimal(sup_amt);  //부가세포함여부
	
	parent.form1.r_labor.value = parseDecimal(toInt(parseDigit(fm.r_labor_sum.value)));   //공임
	parent.form1.r_amt.value = parseDecimal(toInt(parseDigit(fm.r_amt_sum.value)));  //부품

	//if(toInt(parseDigit(fm.amt_sum2.value)) > 0   &&  toInt(parseDigit(parent.form1.r_j_amt.value)) < 1 ){
	if(toInt(parseDigit(fm.amt_sum2.value)) > 0   ){  //금액이 있다면	   	
		 parent.chk_add_amt();
	} 
		
//	parent.form1.r_j_amt.value = parseDecimal(toInt(parseDigit(fm.r_amt_sum.value)));  //부품정산
	
//	if(toInt(parseDigit(fm.amt_sum2.value))==toInt(parseDigit(parent.form1.r_j_amt.value))){
		
//	}else{
//	 	parent.form1.add_amt_yn[0].checked = true;         
	 	
	//         parent.chk_add_amt();
//	}
}

//-->
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="car_mng_id" value="<%= car_mng_id %>">
<input type="hidden" name="serv_id" value="<%= serv_id %>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td> 
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
                			  	<input type="hidden" name="seq_no" value="<%= siBn.getSeq_no() %>">
                				<input type="hidden" name="item_id" value="<%= siBn.getItem_id() %>">
                				<input type="hidden" name="bpm" value="<%= siBn.getBpm() %>">
                                <td width=5% align="center"><input type="checkbox" name="pr" value="<%= siBn.getSeq_no() %>" ></td>
                                <td width=5% align="center"><%= siBns.length-i %></td>
                                <td width=7% align="center"><input type="text" name="item_st" size="6" class=whitetext value="<%= siBn.getItem_st() %>"></td>
                                <td width=20%>&nbsp;&nbsp;<% if(siBns.length>1){ %>
                													<a href="javascript:setting2(<%= i %>)"><%= siBn.getItem() %><% if(siBn.getItem().equals("")){ %>-<%}%></a>
                											  <% }else{ %>
                											  		<a href="javascript:setting()"><%= siBn.getItem() %><% if(siBn.getItem().equals("")){ %>-<%}%></a>
                											  <% } %>		
                								<input type="hidden" name="item" value="<%= siBn.getItem() %>"></td>
                                <td width=7% align="center"><input type="text" name="wk_st" size="6" class=whitetext value="<%= siBn.getWk_st() %>"></td>
                                <td width=5% align="right"><input type=text name="count" size=2 class=whitenum value="<%= AddUtil.parseDecimal(siBn.getCount()) %>">&nbsp;</td>
                                <td width=12% align="right"><input type=text name="price" size=7 class=whitenum value="<%= AddUtil.parseDecimal(siBn.getPrice()) %>">&nbsp;</td>
                                <td width=10% align="center"><input type="text" name="item_cd" size="10" class=whitetext value="<%= siBn.getItem_cd() %>"></td>				
                                <td width=10% align="right"><input type=text name="amt" size=8 class=whitenum value="<%= AddUtil.parseDecimal(siBn.getAmt()) %>">&nbsp;</td>
                                <td width=10% align="right"><input type=text name="labor" size=8 class=whitenum value="<%= AddUtil.parseDecimal(siBn.getLabor()) %>">&nbsp;</td>
                                <td width=9% align="center"><input type=text name="bpm_nm" size=6 class=whitetext value="<% if(siBn.getBpm().equals("1")) out.print("자가");
                				  					else if(siBn.getBpm().equals("2"))	out.print("업체"); %>"></td>
                            </tr>
              <%	}
				}else{ %>
			                <tr><td colspan="11" align="center">선택한 작업이나 부품이 없습니다.</td></tr>
			  <% } %>
			  
			  <tr> 
                                <td colspan="8" class='title' style='text-align:right'>합 계&nbsp;&nbsp;<input type="text" name="amt_sum2" size="10" value="<%= AddUtil.parseDecimal(amt_sum+labor_sum) %>" class=num>&nbsp;</td>
                                <td class='title' style='text-align:right'><input type="text" name="amt_sum" size="9" value="<%= AddUtil.parseDecimal(amt_sum) %>" class=num>&nbsp;</td>
                                <td class='title' style='text-align:right'><input type="text" name="labor_sum" size="9" value="<%= AddUtil.parseDecimal(labor_sum) %>" class=num>&nbsp;</td>
                                  <td class='title'>(공급가)</td>
                            </tr>
                            <input type="hidden" name="r_amt_sum"  size="10" value="<%= AddUtil.parseDecimal(r_amt_sum) %>" > 
                            <input type="hidden" name="r_labor_sum" size="10" value="<%= AddUtil.parseDecimal(r_labor_sum) %>" > 
                            
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>  
</body>
</html>
<%if(siBns.length >0){%>
<script language="JavaScript">
	set_tot_amt()
</script>
<% } %>