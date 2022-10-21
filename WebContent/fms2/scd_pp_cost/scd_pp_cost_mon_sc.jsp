<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.ext.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String s_yy 	= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	
	Vector vt = ae_db.getScdPpCostMonStat(s_yy, gubun2);
	int vt_size = vt.size();	
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4	= 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;	
	long total_amt8 = 0;
	long total_amt9 = 0;
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function Search(){
	var fm = document.form1;	
	fm.action = "scd_pp_cost_mon_sc.jsp";
	fm.target = "_self";
	fm.submit();
}

	function CostDay(s_kd, t_wd){
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		fm.t_wd.value = t_wd;		
		fm.target = "c_foot";
		fm.action = "scd_pp_cost_day_sc.jsp";
		fm.submit();		
	}
	function PpCostMon(est_dt){
		//if(est_dt > 20191231){
		//	window.open("view_account_pp_cost2.jsp?est_dt="+est_dt+"&gubun2=<%=gubun2%>", "VIEW_ACCOUNT_PP_COST", "left=50, top=50, width=850, height=300, scrollbars=yes, status=yes");
		//}else{
			window.open("view_account_pp_cost.jsp?est_dt="+est_dt+"&gubun2=<%=gubun2%>", "VIEW_ACCOUNT_PP_COST", "left=50, top=50, width=850, height=300, scrollbars=yes, status=yes");	
		//}
			
	}	
//-->
</script>
</head>
<body>
<form name='form1' action='scd_pp_cost_mon_sc.jsp' method='post' target='t_content'>
<input type='hidden' name='s_kd' value=''>
<input type='hidden' name='t_wd' value=''>
<input type='hidden' name='est_dt' value=''>
<input type='hidden' name='gubun' value=''>
<input type='hidden' name='go_url' value='/fms2/scd_pp_cost/scd_pp_cost_mon_sc.jsp'>
  <table border="0" cellspacing="0" cellpadding="0" width=1160>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>수익반영스케줄</span></td>
	  </tr>
    <tr>
	    <td align="right">(공급가기준)</td>
	  </tr>	  
	  <tr><td class=line2></td></tr>
    <tr>
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='150'  class='title'>검색</td>
            <td>&nbsp;
              <select name="s_yy">
			  			<%for(int i=2019; i<=AddUtil.getDate2(1)+6; i++){%>
							<option value="<%=i%>" <%if(s_yy.equals(Integer.toString(i))){%>selected<%}%>><%=i%>년</option>
						<%}%>
						</select>     
			  &nbsp;
                        구분 : 
              <select name="gubun2" id="gubun2">               
                <option value=''  <%if(gubun2.equals("")){%> selected <%}%>>전체</option>
                <option value='1' <%if(gubun2.equals("1")){%> selected <%}%>>선납금</option>
                <option value='2' <%if(gubun2.equals("2")){%> selected <%}%>>개시대여료</option>
                <option value='3' <%if(gubun2.equals("3")){%> selected <%}%>>대여료</option>
              </select>			         
              &nbsp;<a href="javascript:Search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a>
            </td>
          </tr>
        </table>
      </td>
    </tr> 	
    <tr> 
        <td class=h></td>
    </tr>      
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='100' rowspan='2' class='title'>구분</td>
                    <td width='100' rowspan='2' class='title'>예정금액</td>
                    <td colspan=7 class='title'>실행금액</td>
                    <td width='100' rowspan='2' class='title'>수익반영금액</td>
                    <td width='100' rowspan='2' class='title'>잔액점검</td>
                </tr>
                <tr>
                    <td width='100' class='title'>신규계약</td>
                    <td width='110' class='title'>수익반영</td>
                    <td width='110' class='title'>환불(해지)</td>
                    <td width='110' class='title'>합계</td>
                    <td width='110' class='title'>렌트</td>
                    <td width='110' class='title'>리스</td>
                    <td width='110' class='title'>잔액</td>
                </tr>
                <%if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					            
					            total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("EST_AMT")));
								total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("AMT1")));
								total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("AMT2")));
					            total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("AMT3")));
								total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("AMT4")));
								total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht.get("AMT4_1")));
								total_amt7 	= total_amt7 + AddUtil.parseLong(String.valueOf(ht.get("AMT4_2")));
								if(i==0){
									total_amt8 	= AddUtil.parseLong(String.valueOf(ht.get("REST_AMT")));
								}else{
									total_amt8 	= total_amt8+AddUtil.parseLong(String.valueOf(ht.get("AMT4")));
								}
								total_amt9 	= ae_db.getScdPpCostMonStatChkAmt(String.valueOf(ht.get("EST_DT")), gubun2);
					      %>
                <tr>
                    <td class='title'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DT")))%></td>
                    <td align="right"><a href="javascript:CostDay('1','<%=ht.get("EST_DT")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("EST_AMT")))%></a></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT1")))%></td>
                    <td align="right"><a href="javascript:CostDay('2','<%=ht.get("EST_DT")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT2")))%></a></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT3")))%></td>
                    <td align="right" class='is'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT4")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT4_1")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT4_2")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt8)%></td>
                    <td align="center"><input type="button" class="button" id="res_reg" value='수익반영금액' onclick="javascript:PpCostMon(<%=ht.get("EST_DT")%>);"></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt8-total_amt9)%></td>
                </tr>
		            <%	}%>
		        <tr>
                    <td class='title'>합계</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt1)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt2)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt3)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt4)%></td>
                    <td align="right" class='is'><%=AddUtil.parseDecimalLong(total_amt5)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt6)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt7)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt8)%></td>
                    <td align="center"></td>                    
                    <td align="center"></td>
                </tr>
                <%}%>		        
            </table>
	    </td>
    </tr> 	  
  </table>
</form>
</body>
</html>