<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--


	//처음 셋팅하기
	function set_debt(){
		var p_fm = parent.document.form1;			
		var fm = document.form1;
		var c_size = toInt(fm.deb2_size.value);
		fm.tot_size.value = c_size;
		for(i=0; i<c_size; i++){ 
			if(c_size==1){
				fm.c_last_amt.value = parseDecimal(toInt(parseDigit(fm.c_last_amt.value)) + toInt(parseDigit(fm.last_amt.value)));
				fm.c_over_amt.value = parseDecimal(toInt(parseDigit(fm.c_over_amt.value)) + toInt(parseDigit(fm.over_amt.value)));
				fm.c_new_amt.value 	= parseDecimal(toInt(parseDigit(fm.c_new_amt.value)) + toInt(parseDigit(fm.new_amt.value)));
				fm.c_plan_amt.value = parseDecimal(toInt(parseDigit(fm.c_plan_amt.value)) + toInt(parseDigit(fm.plan_amt.value)));
				fm.c_pay_amt.value 	= parseDecimal(toInt(parseDigit(fm.c_pay_amt.value)) + toInt(parseDigit(fm.pay_amt.value)));
				fm.c_jan_amt.value 	= parseDecimal(toInt(parseDigit(fm.c_jan_amt.value)) + toInt(parseDigit(fm.jan_amt.value)));
			}else{
				fm.c_last_amt.value = parseDecimal(toInt(parseDigit(fm.c_last_amt.value)) + toInt(parseDigit(fm.last_amt[i].value)));
				fm.c_over_amt.value = parseDecimal(toInt(parseDigit(fm.c_over_amt.value)) + toInt(parseDigit(fm.over_amt[i].value)));
				fm.c_new_amt.value 	= parseDecimal(toInt(parseDigit(fm.c_new_amt.value)) + toInt(parseDigit(fm.new_amt[i].value)));
				fm.c_plan_amt.value = parseDecimal(toInt(parseDigit(fm.c_plan_amt.value)) + toInt(parseDigit(fm.plan_amt[i].value)));
				fm.c_pay_amt.value 	= parseDecimal(toInt(parseDigit(fm.c_pay_amt.value)) + toInt(parseDigit(fm.pay_amt[i].value)));
				fm.c_jan_amt.value 	= parseDecimal(toInt(parseDigit(fm.c_jan_amt.value)) + toInt(parseDigit(fm.jan_amt[i].value)));
				
			}
		}
	}
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String st = "1";
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//은행 부채현황
	Vector deb1s = new Vector();
	int deb1_size = 0;
	//기타금융기관 부채현황
	Vector deb2s = ad_db.getStatDebtLs(br_id, save_dt, "2");
	int deb2_size = deb2s.size();
	//그외 기타 부채현황
	Vector deb3s = new Vector();
	int deb3_size = 0;
%>
<form action="stat_debt_sc_null.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='deb1_size' value='<%=deb1_size%>'>
<input type='hidden' name='deb2_size' value='<%=deb2_size%>'>
<input type='hidden' name='deb3_size' value='<%=deb3_size%>'>
<input type='hidden' name='tot_size' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>

    <tr>
	    <td class='line'>		
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
              
              <%for (int i = 0 ; i < deb2_size ; i++){
    							Hashtable deb2 = (Hashtable)deb2s.elementAt(i);%>
                <tr> 
                    <td align="center" width=10% ><%=i+1%></td>
                    <td align="center" width=15% ><%=c_db.getNameById(String.valueOf(deb2.get("CPT_CD")), "BANK")%>
                      <input type='hidden' name='cpt_cd' value='<%=deb2.get("CPT_CD")%>'>
                    </td>
                    <td align="center"  width=15%>리스료</td>
                    <td align="center"> 
                      <input type="text" name="last_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb2.get("LAST_MON_AMT")))%>" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="over_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb2.get("OVER_MON_AMT")))%>" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="new_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_NEW_AMT")))%>" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="plan_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_PLAN_AMT")))%>" class="whitenum">
        			  <input type="hidden" name="plan_prn" value="<%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_PLAN_AMT")))%>">
          			  <input type="hidden" name="plan_int" value="<%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_PLAN_INT_AMT")))%>">
                    </td>
                    <td align="center"> 
                      <input type="text" name="pay_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_PAY_AMT")))%>" class="whitenum">
        			  <input type="hidden" name="pay_prn" value="<%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_PAY_AMT")))%>">
          			  <input type="hidden" name="pay_int" value="<%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_PAY_INT_AMT")))%>">
                    </td>
                    <td align="center"> 
                      <input type="text" name="jan_amt" size="13" value="<%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_JAN_AMT")))%>" class="whitenum">
                    </td>
                </tr>
                <%	}%>
                <%if(deb2_size>0){%>
                <tr> 
                    <td align="center" colspan="2">합계</td>
                    <td align="center" >리스료</td>
                    <td align="center">
                      <input type="text" name="c_last_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="c_over_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="c_new_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="c_plan_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="c_pay_amt" size="13" value="" class="whitenum">
                    </td>
                    <td align="center"> 
                      <input type="text" name="c_jan_amt" size="13" value="" class="whitenum">
                    </td>
                </tr>                
                <%}%>  
                
            </table>
		</td>
	</tr>
</table>		
</form>
<script language='javascript'>
<!--
	set_debt();
//-->
</script>
</body>
</html>
