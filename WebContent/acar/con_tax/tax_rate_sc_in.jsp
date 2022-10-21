<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.con_tax.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">

<script language="JavaScript">
<!--

	function GetTaxRate(tax_nm, dpm, rate_st1, rate_st2, tax_st_dt, tax_rate, reg_dt){
		var fm = parent.document.form1;
		fm.tax_nm.value = tax_nm;
		if(dpm == '0')	fm.dpm[0].selected = true;		
		if(dpm == '3')	fm.dpm[1].selected = true;
		if(dpm == '2')	fm.dpm[2].selected = true;		
		if(dpm == '1')	fm.dpm[3].selected = true;
		if(dpm == '4')	fm.dpm[4].selected = true;				
		
		if(rate_st1 == '')	fm.rate_st1[0].selected = true;		
		if(rate_st1 == '1')	fm.rate_st1[1].selected = true;		
		if(rate_st1 == '2')	fm.rate_st1[2].selected = true;
		if(rate_st1 == '3')	fm.rate_st1[3].selected = true;		
		if(rate_st1 == '4')	fm.rate_st1[4].selected = true;
		if(rate_st1 == '5')	fm.rate_st1[5].selected = true;		
		if(rate_st1 == '6')	fm.rate_st1[6].selected = true;				

		if(rate_st2 == '')	fm.rate_st2[0].selected = true;		
		if(rate_st2 == '1')	fm.rate_st2[1].selected = true;		
		if(rate_st2 == '2')	fm.rate_st2[2].selected = true;
		if(rate_st2 == '3')	fm.rate_st2[3].selected = true;		
		if(rate_st2 == '4')	fm.rate_st2[4].selected = true;
		if(rate_st2 == '5')	fm.rate_st2[5].selected = true;		
		if(rate_st2 == '6')	fm.rate_st2[6].selected = true;				
		if(rate_st2 == '7')	fm.rate_st2[7].selected = true;		
		if(rate_st2 == '8')	fm.rate_st2[8].selected = true;
		if(rate_st2 == '9')	fm.rate_st2[9].selected = true;		
		if(rate_st2 == '10')	fm.rate_st2[10].selected = true;
		if(rate_st2 == '11')	fm.rate_st2[11].selected = true;		
		if(rate_st2 == '12')	fm.rate_st2[12].selected = true;		
						
		fm.tax_st_dt.value = tax_st_dt;
		fm.tax_rate.value = tax_rate;
		fm.reg_dt.value = reg_dt;
	}
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	Vector taxs = t_db.getTaxRateList(s_kd, t_wd);
	int tax_size = taxs.size();
%>
<form action="tax_rate_sc_a.jsp" name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="reg_dt" value="">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr>		
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
		        <tr>					
                    <td class='line'> 
                        <table  border=0 cellspacing=1 width="100%">
                            <tr> 
                                <td class=title width=20%>세금명</td>
                                <td class=title width=15%>배기량</td>
                                <td class=title width=15%>용도별</td>
                                <td class=title width=10%>경과월수</td>
                                <td class=title width=15%>기준일자</td>
                                <td class=title width=10%>세율</td>
                                <td class=title width=15%>등록일자</td>
                            </tr>
                              <%if(tax_size > 0){
                					for(int i = 0 ; i < tax_size ; i++){
                						TaxRateBean bean = (TaxRateBean)taxs.elementAt(i);%>
                            <tr> 
                                <td align="center"><a href="javascript:GetTaxRate('<%=bean.getTax_nm()%>','<%=bean.getDpm()%>','<%=bean.getRate_st1()%>','<%=bean.getRate_st2()%>','<%=AddUtil.ChangeDate2(bean.getTax_st_dt())%>','<%=bean.getTax_rate()%>','<%=AddUtil.ChangeDate2(bean.getReg_dt())%>')" onMouseOver="window.status=''; return true"><%=bean.getTax_nm()%></a></td>
                                <td align="center"> 
                                  <%if(bean.getDpm().equals("1")){%>
                                  1500CC이하 
                                  <%}else if(bean.getDpm().equals("2")){%>
                                  2000CC이하 
                                  <%}else if(bean.getDpm().equals("3")){%>
                                  2000CC초과 
                                  <%}else if(bean.getDpm().equals("4")){%>
                                  800CC이하 
                                  <%}%>
                                </td>
                                <td align="center"> 
                                  <%if(!bean.getRate_st1().equals("")){%>
                                  <%=bean.getRate_st1()%>년이하
                                  <%}%>
                                </td>
                                <td align="center"> 
                                  <%if(!bean.getRate_st2().equals("")){%>
                                  <%=bean.getRate_st2()%>월
                                  <%}%>
                                </td>
                                <td align="center"><%=AddUtil.ChangeDate2(bean.getTax_st_dt())%></td>
                                <td align="center"><%=bean.getTax_rate()%>%</td>
                                <td align="center"><%=AddUtil.ChangeDate2(bean.getReg_dt())%></td>
                            </tr>
                              <%	}
                				}else{%>
                            <tr align="center"> 
                                <td colspan="7">등록된 자료가 없습니다.</td>
                            </tr>
                              <%}%>
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