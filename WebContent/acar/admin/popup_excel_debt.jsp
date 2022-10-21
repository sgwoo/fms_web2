<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=popup_excel_debt.xls");
%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>

<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
</script>

<style type="text/css">
<!--
.style1 {color: #FFFFFF}
-->
</style>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String st = "1";
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//은행 부채현황
	Vector deb1s = ad_db.getStatDebt(br_id, save_dt, "1");
	
	int deb1_size = deb1s.size();
		
	//기타금융기관 부채현황
	Vector deb2s = ad_db.getStatDebt(br_id, save_dt, "2");
	int deb2_size = deb2s.size();
	//그외 기타 부채현황
	Vector deb3s = ad_db.getStatDebt(br_id, save_dt, "3");
	int deb3_size = deb3s.size();
	
	long t_last_amt = 0;
    long t_over_amt = 0;
    long t_new_amt  = 0;
    long t_plan_amt = 0;
    long t_pay_amt  = 0;
    long t_jan_amt  = 0;
    
	long b_last_amt = 0;
    long b_over_amt = 0;
    long b_new_amt  = 0;
    long b_plan_amt = 0;
    long b_pay_amt  = 0;
    long b_jan_amt  = 0;
    
    long bh_last_amt = 0;
    long bh_over_amt = 0;
    
    long bj_last_amt = 0;
    long bj_over_amt = 0;
       
    long c_last_amt = 0;
    long c_over_amt = 0;
    long c_new_amt  = 0;
    long c_plan_amt = 0;
    long c_pay_amt  = 0;
    long c_jan_amt  = 0;
              
    long g_last_amt = 0;
    long g_over_amt = 0;
    long g_new_amt  = 0;
    long g_plan_amt = 0;
    long g_pay_amt  = 0;
    long g_jan_amt  = 0;          
              
	
%>

<table border="0" cellspacing="0" cellpadding="0" width=900>
  <tr> 
    <td colspan="2" align="left"><font face="굴림" size="2" > 
      <b>&nbsp; * 부채현황 [기준일 : <%=AddUtil.ChangeDate2(save_dt)%> ] </b> </font></td>
  </tr>
  <tr> 
    <td colspan="2" align="right"><font face="굴림" size="2" > 
      출력일자: <%=AddUtil.getDate()%>&nbsp;</font></td>
  </tr>
  <tr> 
      <td class="line" colspan="2"> 
        <table width="100%" border="1" cellspacing="1" cellpadding="1">
          <tr> 
            <td class=title colspan="4" rowspan="3" align=center  >구분</td>
            <td class=title width="90" rowspan="3" align=center >전월이월<br>
              차입금액</td>
            <td class=title width="90" rowspan="3" align=center >차월이월<br>
              차입금액</td>
            <td class=title colspan="4" align=center >당월차입금변동</td>
          </tr>
          <tr> 
            <td class=title width="90" rowspan="2" align=center >당월신규<br>
              차입금액</td>
            <td class=title colspan="3" align=center >당월상환차입금액(이자별도)</td>
          </tr>
          <tr> 
            <td class=title width="90" align=center >예정금액</td>
            <td class=title width="90" align=center >상환금액</td>
            <td class=title width="90" align=center >잔액</td>
          </tr>
        </table>
      </td>
     
    </tr>

	 <tr>
	  <td class='line' colspan="2"> 	
        <table width="100%" border="1" cellspacing="1" cellpadding="1">
          <%for (int i = 0 ; i < deb1_size ; i++){
				Hashtable deb1 = (Hashtable)deb1s.elementAt(i);
				String cpt_cd = (String)deb1.get("CPT_CD");
				String h_amt = (String)deb1.get("WHAN_AMT");
				String j_amt = (String)deb1.get("J_AMT");
				
				/*	
				String whan = "0";
				if(String.valueOf(deb1.get("WHAN_AMT")).equals("0")){
					if(cpt_cd.equals("0005")) whan = "800,000,000";
					else if(cpt_cd.equals("0004")) whan = "0";
					else if(cpt_cd.equals("0001")) whan = "0";
					else if(cpt_cd.equals("0007")) whan = "300,000,000";
				}else{
					whan = AddUtil.parseDecimal2(String.valueOf(deb1.get("WHAN_AMT")));
				}
				*/
				
				bh_last_amt += AddUtil.parseLong(String.valueOf(deb1.get("WHAN_AMT")));
				bh_over_amt += AddUtil.parseLong(String.valueOf(deb1.get("WHAN_AMT")));
				
				bj_last_amt += AddUtil.parseLong(String.valueOf(deb1.get("WHAN_AMT")));
				bj_over_amt += AddUtil.parseLong(String.valueOf(deb1.get("WHAN_AMT")));
				
				
				t_last_amt += AddUtil.parseLong(String.valueOf(deb1.get("LAST_MON_AMT")));
				t_over_amt += AddUtil.parseLong(String.valueOf(deb1.get("OVER_MON_AMT")));
  			    t_new_amt  += AddUtil.parseLong(String.valueOf(deb1.get("THIS_MON_NEW_AMT")));
    			t_plan_amt += AddUtil.parseLong(String.valueOf(deb1.get("THIS_MON_PLAN_AMT")));
    			t_pay_amt  += AddUtil.parseLong(String.valueOf(deb1.get("THIS_MON_PAY_AMT")));
    			t_jan_amt  += AddUtil.parseLong(String.valueOf(deb1.get("THIS_MON_JAN_AMT")));
    			
    			b_last_amt += AddUtil.parseLong(String.valueOf(deb1.get("LAST_MON_AMT")));
				b_over_amt += AddUtil.parseLong(String.valueOf(deb1.get("OVER_MON_AMT")));
  			    b_new_amt  += AddUtil.parseLong(String.valueOf(deb1.get("THIS_MON_NEW_AMT")));
    			b_plan_amt += AddUtil.parseLong(String.valueOf(deb1.get("THIS_MON_PLAN_AMT")));
    			b_pay_amt  += AddUtil.parseLong(String.valueOf(deb1.get("THIS_MON_PAY_AMT")));
    			b_jan_amt  += AddUtil.parseLong(String.valueOf(deb1.get("THIS_MON_JAN_AMT")));
				
			%>
          <tr> 
            <%if(i == 0){%>
            <td align="center" rowspan="<%=4*(deb1_size+1)%>">은행</td>
            <%}%>
            <td align="center" rowspan="4" width="90" ><%=c_db.getNameById(String.valueOf(deb1.get("CPT_CD")), "BANK")%>
              <input type='hidden' name='cpt_cd' value='<%=deb1.get("CPT_CD")%>'>
            </td>
            <td align="center" colspan="2">시설자금</td>
            <td align="right" width="90"> <%=AddUtil.parseDecimal2(String.valueOf(deb1.get("LAST_MON_AMT")))%>
            </td>
            <td align="right" width="90"><%=AddUtil.parseDecimal2(String.valueOf(deb1.get("OVER_MON_AMT")))%> 
            </td>
            <td align="right" width="90"><%=AddUtil.parseDecimal2(String.valueOf(deb1.get("THIS_MON_NEW_AMT")))%> 
            </td>
            <td align="right" width="90"> 
             <%=AddUtil.parseDecimal2(String.valueOf(deb1.get("THIS_MON_PLAN_AMT")))%>
		    </td>
            <td align="right" width="90"> 
            <%=AddUtil.parseDecimal2(String.valueOf(deb1.get("THIS_MON_PAY_AMT")))%>
		    </td>
            <td align="right" width="90"> 
              <%=AddUtil.parseDecimal2(String.valueOf(deb1.get("THIS_MON_JAN_AMT")))%>
            </td>
          </tr>
          <tr> 
            <td align="center" rowspan="2">운전<br>
              자금</td>
            <td align="center">한도</td>
            <td align="right" width="90">
             <%=AddUtil.parseDecimal2(h_amt)%>
            </td>
            <td align="right" width="90"> 
            <%=AddUtil.parseDecimal2(h_amt)%>
            </td>
            <td align="right" width="90">0 
           
            </td>
            <td align="right" width="90">0 
              
            </td>
            <td align="right" width="90"> 0
            
            </td>
            <td align="right" width="90"> 0
             
            </td>
          </tr>
          <tr> 
            <td align="center">잔액</td>
            <td align="right" width="90">
              <%=AddUtil.parseDecimal2(j_amt)%>
            </td>
            <td align="right" width="90"> 
        <%=AddUtil.parseDecimal2(j_amt)%>
            </td>
            <td align="right" width="90"> 
              0
            </td>
            <td align="right" width="90"> 
             0
            </td>
            <td align="right" width="90"> 
             0
            </td>
            <td align="right" width="90"> 
              0
            </td>
          </tr>
          <tr> 
            <td class="is"  align="center" colspan="2">소계</td>
            <td class="is"  align="right" width="90">
              <%=AddUtil.parseDecimal2(String.valueOf(deb1.get("LAST_MON_AMT")))%>
            </td>
            <td class="is"  align="right" width="90"> 
             <%=AddUtil.parseDecimal2(String.valueOf(deb1.get("OVER_MON_AMT")))%> 
            </td>
            <td class="is"  align="right" width="90"> 
               <%=AddUtil.parseDecimal2(String.valueOf(deb1.get("THIS_MON_NEW_AMT")))%> 
            </td>
            <td class="is"  align="right" width="90"> 
               <%=AddUtil.parseDecimal2(String.valueOf(deb1.get("THIS_MON_PLAN_AMT")))%>
            </td>
            <td class="is"  align="right" width="90"> 
               <%=AddUtil.parseDecimal2(String.valueOf(deb1.get("THIS_MON_PAY_AMT")))%>
            </td>
            <td class="is"  align="right" width="90"> 
                <%=AddUtil.parseDecimal2(String.valueOf(deb1.get("THIS_MON_JAN_AMT")))%>
            </td>
          </tr>
          <%}		  %>
          <tr> 
            <td align="center" rowspan="4">합계</td>
            <td align="center" colspan="2">시설자금</td>
            <td align="right" width="90">
              <%=Util.parseDecimal(b_last_amt)%>
            </td>
            <td align="right" width="90"> 
               <%=Util.parseDecimal(b_over_amt)%>
            </td>
            <td align="right" width="90"> 
               <%=Util.parseDecimal(b_new_amt)%>
            </td>
            <td align="right" width="90"> 
               <%=Util.parseDecimal(b_plan_amt)%>
            </td>
            <td align="right" width="90"> 
               <%=Util.parseDecimal(b_pay_amt)%>
            </td>
            <td align="right" width="90"> 
               <%=Util.parseDecimal(b_jan_amt)%>
            </td>
          </tr>
          <tr> 
            <td align="center" rowspan="2">운전<br>
              자금</td>
            <td align="center">한도</td>
            <td align="right" width="90">
               <%=Util.parseDecimal(bh_last_amt)%> 
            </td>
            <td align="right" width="90"> 
               <%=Util.parseDecimal(bh_over_amt)%> 
            </td>
            <td align="right" width="90"> 
             0
            </td>
            <td align="right" width="90"> 
            0
            </td>
            <td align="right" width="90"> 
             0
            </td>
            <td align="right" width="90"> 
             0
            </td>
          </tr>
          <tr> 
            <td align="center">잔액</td>
            <td align="right" width="90">
               <%=Util.parseDecimal(bj_last_amt)%> 
            </td>
            <td align="right" width="90"> 
               <%=Util.parseDecimal(bj_over_amt)%> 
            </td>
            <td align="right" width="90"> 
              0
            </td>
            <td align="right" width="90"> 
             0
            </td>
            <td align="right" width="90"> 
             0
            </td>
            <td align="right" width="90"> 
              0
            </td>
          </tr>
          <tr> 
            <td class="star"  align="center" colspan="2">소계</td>
            <td class="star"  align="right" width="90">
               <%=Util.parseDecimal(b_last_amt)%>
            </td>
            <td class="star"  align="right" width="90"> 
                 <%=Util.parseDecimal(b_over_amt)%>
            </td>
            <td class="star"  align="right" width="90"> 
               <%=Util.parseDecimal(b_new_amt)%>
            </td>
            <td class="star"  align="right" width="90"> 
               <%=Util.parseDecimal(b_plan_amt)%>
            </td>
            <td class="star"  align="right" width="90"> 
               <%=Util.parseDecimal(b_pay_amt)%>
            </td>
            <td class="star"  align="right" width="90"> 
              <%=Util.parseDecimal(b_jan_amt)%>
            </td>
          </tr>
          
          <%for (int i = 0 ; i < deb2_size ; i++){
				Hashtable deb2 = (Hashtable)deb2s.elementAt(i);
				
				t_last_amt += AddUtil.parseLong(String.valueOf(deb2.get("LAST_MON_AMT")));
				t_over_amt += AddUtil.parseLong(String.valueOf(deb2.get("OVER_MON_AMT")));
  			    t_new_amt  += AddUtil.parseLong(String.valueOf(deb2.get("THIS_MON_NEW_AMT")));
    			t_plan_amt += AddUtil.parseLong(String.valueOf(deb2.get("THIS_MON_PLAN_AMT")));
    			t_pay_amt  += AddUtil.parseLong(String.valueOf(deb2.get("THIS_MON_PAY_AMT")));
    			t_jan_amt  += AddUtil.parseLong(String.valueOf(deb2.get("THIS_MON_JAN_AMT")));
    			
    			c_last_amt += AddUtil.parseLong(String.valueOf(deb2.get("LAST_MON_AMT")));
				c_over_amt += AddUtil.parseLong(String.valueOf(deb2.get("OVER_MON_AMT")));
  			    c_new_amt  += AddUtil.parseLong(String.valueOf(deb2.get("THIS_MON_NEW_AMT")));
    			c_plan_amt += AddUtil.parseLong(String.valueOf(deb2.get("THIS_MON_PLAN_AMT")));
    			c_pay_amt  += AddUtil.parseLong(String.valueOf(deb2.get("THIS_MON_PAY_AMT")));
    			c_jan_amt  += AddUtil.parseLong(String.valueOf(deb2.get("THIS_MON_JAN_AMT")));
    			
				%>
          <tr> 
            <%if(i == 0){%>
            <td align="center" rowspan="<%=3*(deb2_size+1)%>">은행을<br>제외한<br>기타<br>
              기관</td>
            <%}%>
            <td align="center" rowspan="3"><%=c_db.getNameById(String.valueOf(deb2.get("CPT_CD")), "BANK")%>
              <input type='hidden' name='cpt_cd' value='<%=deb2.get("CPT_CD")%>'>
            </td>
            <td align="center" colspan="2">시설자금</td>
            <td align="right" width="90"><%=AddUtil.parseDecimal2(String.valueOf(deb2.get("LAST_MON_AMT")))%> 
             </td>
            <td align="right" width="90"> 
              <%=AddUtil.parseDecimal2(String.valueOf(deb2.get("OVER_MON_AMT")))%>
            </td>
            <td align="right" width="90"> 
              <%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_NEW_AMT")))%>
            </td>
            <td align="right" width="90"> 
             <%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_PLAN_AMT")))%>
            </td>
            <td align="right" width="90"> 
              <%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_PAY_AMT")))%>
			</td>
            <td align="right" width="90"> 
             <%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_JAN_AMT")))%>
            </td>
          </tr>
          <tr> 
            <td align="center" colspan="2">기타</td>
            <td align="right" width="90">
             0
            </td>
            <td align="right" width="90"> 
             0
            </td>
            <td align="right" width="90"> 
             0
            </td>
            <td align="right" width="90"> 
             0
            </td>
            <td align="right" width="90"> 
             0
            </td>
            <td align="right" width="90"> 
              0
            </td>
          </tr>
          <tr> 
            <td class="is"  align="center" colspan="2">소계</td>
            <td class="is"  align="right" width="90">
              <%=AddUtil.parseDecimal2(String.valueOf(deb2.get("LAST_MON_AMT")))%> 
            </td>
            <td class="is"  align="right" width="90"> 
               <%=AddUtil.parseDecimal2(String.valueOf(deb2.get("OVER_MON_AMT")))%>
            </td>
            <td class="is"  align="right" width="90"> 
               <%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_NEW_AMT")))%>
            </td>
            <td class="is"  align="right" width="90"> 
             <%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_PLAN_AMT")))%>
            </td>
            <td class="is"  align="right" width="90"> 
             <%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_PAY_AMT")))%>
            </td>
            <td class="is"  align="right" width="90"> 
              <%=AddUtil.parseDecimal2(String.valueOf(deb2.get("THIS_MON_JAN_AMT")))%>
            </td>
          </tr>
          <%	}%>
          <tr> 
            <td align="center" rowspan="3">합계</td>
            <td align="center" colspan="2">시설자금</td>
            <td align="right" width="90">
                <%=Util.parseDecimal(c_last_amt)%>
            </td>
            <td align="right" width="90"> 
               <%=Util.parseDecimal(c_over_amt)%>
            </td>
            <td align="right" width="90"> 
                <%=Util.parseDecimal(c_new_amt)%>
            </td>
            <td align="right" width="90"> 
                <%=Util.parseDecimal(c_plan_amt)%>
            </td>
            <td align="right" width="90"> 
                <%=Util.parseDecimal(c_pay_amt)%>
            </td>
            <td align="right" width="90"> 
                <%=Util.parseDecimal(c_jan_amt)%>
            </td>
          </tr>
          <tr> 
            <td align="center" colspan="2">기타</td>
            <td align="right" width="90">
             0
            </td>
            <td align="right" width="90"> 
             0
            </td>
            <td align="right" width="90"> 
              0
            </td>
            <td align="right" width="90"> 
              0
            </td>
            <td align="right" width="90"> 
              0
            </td>
            <td align="right" width="90"> 
             0
            </td>
          </tr>
          <tr> 
            <td class="star"  align="center" colspan="2">합계</td>
            <td class="star"  align="right" width="90"> 
              <%=Util.parseDecimal(c_last_amt)%>
            </td>
            <td class="star"  align="right" width="90">
               <%=Util.parseDecimal(c_over_amt)%>
            </td>
            <td class="star"  align="right" width="90">
                <%=Util.parseDecimal(c_new_amt)%>
            </td>
            <td class="star"  align="right" width="90">
              <%=Util.parseDecimal(c_plan_amt)%>
            </td>
            <td class="star"  align="right" width="90">
               <%=Util.parseDecimal(c_pay_amt)%>
            </td>
            <td class="star"  align="right" width="90">
              <%=Util.parseDecimal(c_jan_amt)%>
            </td>
          </tr>		  
          <%for (int i = 0 ; i < deb3_size ; i++){
				Hashtable deb3 = (Hashtable)deb3s.elementAt(i);
				
				t_last_amt += AddUtil.parseLong(String.valueOf(deb3.get("LAST_MON_AMT")));
				t_over_amt += AddUtil.parseLong(String.valueOf(deb3.get("OVER_MON_AMT")));
  			    t_new_amt  += AddUtil.parseLong(String.valueOf(deb3.get("THIS_MON_NEW_AMT")));
    			t_plan_amt += AddUtil.parseLong(String.valueOf(deb3.get("THIS_MON_PLAN_AMT")));
    			t_pay_amt  += AddUtil.parseLong(String.valueOf(deb3.get("THIS_MON_PAY_AMT")));
    			t_jan_amt  += AddUtil.parseLong(String.valueOf(deb3.get("THIS_MON_JAN_AMT")));
    			
    			g_last_amt += AddUtil.parseLong(String.valueOf(deb3.get("LAST_MON_AMT")));
				g_over_amt += AddUtil.parseLong(String.valueOf(deb3.get("OVER_MON_AMT")));
  			    g_new_amt  += AddUtil.parseLong(String.valueOf(deb3.get("THIS_MON_NEW_AMT")));
    			g_plan_amt += AddUtil.parseLong(String.valueOf(deb3.get("THIS_MON_PLAN_AMT")));
    			g_pay_amt  += AddUtil.parseLong(String.valueOf(deb3.get("THIS_MON_PAY_AMT")));
    			g_jan_amt  += AddUtil.parseLong(String.valueOf(deb3.get("THIS_MON_JAN_AMT")));
    			
				%>
          <tr> 
            <%if(i == 0){%>
            <td align="center" rowspan="<%=3*(deb3_size+1)%>">기타</td>
            <%}%>
            <td align="center" rowspan="3"><%=c_db.getNameById(String.valueOf(deb3.get("CPT_CD")), "BANK")%>
              <input type='hidden' name='cpt_cd' value='<%=deb3.get("CPT_CD")%>'>
            </td>
            <td align="center" colspan="2">시설자금</td>
            <td align="right" width="90"> 
              <%=AddUtil.parseDecimal2(String.valueOf(deb3.get("LAST_MON_AMT")))%>
            </td>
            <td align="right" width="90"> 
              <%=AddUtil.parseDecimal2(String.valueOf(deb3.get("OVER_MON_AMT")))%>
            </td>
            <td align="right" width="90"> 
              <%=AddUtil.parseDecimal2(String.valueOf(deb3.get("THIS_MON_NEW_AMT")))%>
            </td>
            <td align="right" width="90"> 
             <%=AddUtil.parseDecimal2(String.valueOf(deb3.get("THIS_MON_PLAN_AMT")))%>
			</td>
            <td align="right" width="90"> 
             <%=AddUtil.parseDecimal2(String.valueOf(deb3.get("THIS_MON_PAY_AMT")))%>
			</td>
            <td align="right" width="90"> 
             <%=AddUtil.parseDecimal2(String.valueOf(deb3.get("THIS_MON_JAN_AMT")))%>
            </td>
          </tr>
          <tr> 
            <td align="center" colspan="2">기타</td>
            <td align="right" width="90">
             0
            </td>
            <td align="right" width="90"> 
              0
            </td>
            <td align="right" width="90"> 
              0
            </td>
            <td align="right" width="90"> 
             0
            </td>
            <td align="right" width="90"> 
              0
            </td>
            <td align="right" width="90"> 
              0
            </td>
          </tr>
          <tr> 
            <td class="is"  align="center" colspan="2">소계</td>
            <td class="is"  align="right" width="90">
              <%=AddUtil.parseDecimal2(String.valueOf(deb3.get("LAST_MON_AMT")))%>
            </td>
            <td class="is"  align="right" width="90"> 
               <%=AddUtil.parseDecimal2(String.valueOf(deb3.get("OVER_MON_AMT")))%>
            </td>
            <td class="is"  align="right" width="90"> 
               <%=AddUtil.parseDecimal2(String.valueOf(deb3.get("THIS_MON_NEW_AMT")))%>
            </td>
            <td class="is"  align="right" width="90"> 
                <%=AddUtil.parseDecimal2(String.valueOf(deb3.get("THIS_MON_PLAN_AMT")))%>
            </td>
            <td class="is"  align="right" width="90"> 
              <%=AddUtil.parseDecimal2(String.valueOf(deb3.get("THIS_MON_PAY_AMT")))%>
            </td>
            <td class="is"  align="right" width="90"> 
              <%=AddUtil.parseDecimal2(String.valueOf(deb3.get("THIS_MON_JAN_AMT")))%>
            </td>
          </tr>
          <%	}%>		  
          <tr> 
            <td align="center" rowspan="3">합계</td>
            <td align="center" colspan="2">시설자금</td>
            <td align="right" width="90">
                <%=Util.parseDecimal(g_last_amt)%>
            </td>
            <td align="right" width="90"> 
                <%=Util.parseDecimal(g_over_amt)%> 
            </td>
            <td align="right" width="90"> 
                <%=Util.parseDecimal(g_new_amt)%>
            </td>
            <td align="right" width="90"> 
                <%=Util.parseDecimal(g_plan_amt)%>
            </td>
            <td align="right" width="90"> 
                <%=Util.parseDecimal(g_pay_amt)%>
            </td>
            <td align="right" width="90"> 
                <%=Util.parseDecimal(g_jan_amt)%>
            </td>
          </tr>
          <tr> 
            <td align="center" colspan="2">기타</td>
            <td align="right" width="90">
              0
            </td>
            <td align="right" width="90"> 
              0
            </td>
            <td align="right" width="90"> 
              0
            </td>
            <td align="right" width="90"> 
             0
            </td>
            <td align="right" width="90"> 
             0
            </td>
            <td align="right" width="90"> 
              0
            </td>
          </tr>
          <tr> 
            <td class="star"  align="center" colspan="2">합계</td>
            <td align="right" width="90">
                <%=Util.parseDecimal(g_last_amt)%>
            </td>
            <td align="right" width="90"> 
                <%=Util.parseDecimal(g_over_amt)%> 
            </td>
            <td align="right" width="90"> 
                <%=Util.parseDecimal(g_new_amt)%>
            </td>
            <td align="right" width="90"> 
                <%=Util.parseDecimal(g_plan_amt)%>
            </td>
            <td align="right" width="90"> 
                <%=Util.parseDecimal(g_pay_amt)%>
            </td>
            <td align="right" width="90"> 
                <%=Util.parseDecimal(g_jan_amt)%>
            </td>
          </tr>
             <tr> 
            <td class="star"  align="center" colspan="4">총계</td>
            <td align="right" width="90">
                <%=Util.parseDecimal(t_last_amt)%>
            </td>
            <td align="right" width="90"> 
                <%=Util.parseDecimal(t_over_amt)%> 
            </td>
            <td align="right" width="90"> 
                <%=Util.parseDecimal(t_new_amt)%>
            </td>
            <td align="right" width="90"> 
                <%=Util.parseDecimal(t_plan_amt)%>
            </td>
            <td align="right" width="90"> 
                <%=Util.parseDecimal(t_pay_amt)%>
            </td>
            <td align="right" width="90"> 
                <%=Util.parseDecimal(t_jan_amt)%>
            </td>
          </tr>
        </table>
		</td>
	</tr>
	

</table>

<br>

</body>
</html>

