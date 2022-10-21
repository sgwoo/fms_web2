<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.stat_account.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.stat_account.StatAccountDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	if(save_dt.equals(""))	save_dt = ad_db.getMaxSaveDt("stat_fee_debt_gap");
	
	Vector vt = new Vector();
	int vt_size = 0;
	
	vt = ac_db.getStatFeeDebtGap(save_dt);
	vt_size = vt.size();
	
	String reg_dt		= "";
	if(vt.size()>0){
		for(int i=0; i<vt.size(); i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			reg_dt			= String.valueOf(ht.get("REG_DT"));
		}
	}
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long fee_amt = 0;
	long alt_amt = 0;
	long prn_amt = 0;
	long int_amt = 0;
	long dly_amt = 0;
	long ls_prn_amt = 0;
	
	//말일자 여부
	String month_end_day_yn = "N";
	String month_end_day = save_dt.substring(0,6)+""+String.valueOf(AddUtil.getMonthDate(AddUtil.parseInt(save_dt.substring(0,4)), AddUtil.parseInt(save_dt.substring(4,6))));
	if(save_dt.equals(month_end_day)){
		month_end_day_yn = "Y";
	}
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//리스트 엑셀 전환
	function pop_excel(){
		var fm = document.form1;
		fm.target = "_blank";	
		fm.action = "magam_popup_excel_money.jsp";
		fm.submit();
	}	

	//비율그래프
	function view_gh2(){
		window.open("about:blank", "VIEW_GH", "left=10, top=10, width=950, height=640, scrollbars=yes, status=yes");
		var fm = document.form1;
		fm.target = "VIEW_GH";
		fm.action = "magam_stat_gh2.jsp";				
		fm.submit();		
	}		

	//그래프
	function view_gh(){
		window.open("about:blank", "VIEW_GH", "left=10, top=10, width=950, height=640, scrollbars=yes, status=yes");
		var fm = document.form1;
		fm.target = "VIEW_GH";
		fm.action = "magam_stat_gh.jsp";				
		fm.submit();		
	}	
	
//-->
</script>
</head>
<body>

<form action="stat_money_magam.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='mode' value='31'>
<input type='hidden' name='from_page' value='/acar/stat_money/stat_money_magam.jsp'>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td colspan=5>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 재무분석 > <span class=style5>마감대여료/할부금GAP</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align="right"> 
        </td>
    </tr>
    <tr> 
        <td><iframe src="/acar/admin/stat_end_fee_debt_gap_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>&from_page=incoming_2011" name="i_list" width="100%" height="45" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>	
	<tr> 
        <td align="right"><img src=../images/center/arrow_gji.gif border=0 align=absmiddle> : <%=reg_dt%>&nbsp;&nbsp;
			<a href="javascript:pop_excel();" title='엑셀'><img src=../images/center/button_excel.gif align=absmiddle border=0></a>&nbsp;&nbsp;
			<a href="javascript:view_gh2();" title='비율그래프'><img src=../images/center/button_graph_p.gif align=absmiddle border=0></a>&nbsp;&nbsp;
			<a href="javascript:view_gh();" title='그래프'><img src=../images/center/button_graph.gif align=absmiddle border=0></a>
		</td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td width="3%" rowspan="2" class=title>연번</td>
                    <td width="4.5%" rowspan="2" class=title>년월</td>
                    <td width="8.5%" rowspan="2" class=title>대여료<br>(공급가)</td>                    
                    <td colspan="3" class=title>할부금</td>
                    <td colspan="3" class=title>차액</td><!-- 2018.03.21 -->
                    <td width="18.5%" rowspan="2" class=title>대여료 대비 할부금비</td>
                </tr>
                <tr align="center">
                  <td width="8.5%%" class=title>원금</td>
                  <td width="8.5%" class=title>이자</td>
                  <td width="8.5%" class=title>합계</td>
                  <td width="30%" class=title colspan="2">그래프</td><!-- 2018.03.21 -->
                  <td width="10%" class=title>금액</td><!-- 2018.03.21 -->
                </tr>
              <%int count = 0;
              	for (int i = 0 ; i < vt_size ; i++){
    					Hashtable acc = (Hashtable)vt.elementAt(i);
    					//말일자마감인 경우 해당월은 빠진다
    					if(month_end_day_yn.equals("Y") && i==0) continue;  
    					count++;
    					fee_amt = AddUtil.parseLong(String.valueOf(acc.get("FEE_S_AMT")));
						prn_amt = AddUtil.parseLong(String.valueOf(acc.get("PRN_AMT")));
						int_amt = AddUtil.parseLong(String.valueOf(acc.get("INT_AMT")));
						alt_amt = AddUtil.parseLong(String.valueOf(acc.get("ALT_AMT")));
						ls_prn_amt = AddUtil.parseLong(String.valueOf(acc.get("LS_PRN_AMT")));
						dly_amt = AddUtil.parseLong(String.valueOf(acc.get("DLY_AMT")));
    					float per = (AddUtil.parseFloat(String.valueOf(acc.get("ALT_AMT")))+AddUtil.parseFloat(String.valueOf(acc.get("LS_PRN_AMT"))))/AddUtil.parseFloat(String.valueOf(acc.get("FEE_S_AMT")))*100;%>
                <tr> 
                    <td width="3%" height="38%" align="center"><%=count%></td><!-- 연번 -->
                    <td width="4.5%" height="38%" align="center"><%=AddUtil.ChangeDate2(String.valueOf(acc.get("SEQ")))%><%if(count==1){%><input type='hidden' name='st_dt' value='<%=acc.get("SEQ")%>01'><%}%></td>
                    <td width="8.5%" height="38%" align="right"><%=Util.parseDecimal(fee_amt)%></td><!-- 대여료 -->
                    <td width="8.5%" align="right"><%=Util.parseDecimal(prn_amt)%></td><!-- 원금 -->
                    <td width="8.5%" align="right"><%=Util.parseDecimal(int_amt)%></td><!-- 이자 -->
                    <td width="8.5%" height="38%" align="right"><%=Util.parseDecimal(alt_amt)%></td><!-- 소계 -->
                    <td width="15%" height="38%" align="right" style="text-align:right;"><img src="../../images/result4.gif" height="10px;" name="minus"></img></td> <!-- 리스료 그래프 마이너스(-) --><!-- Util.parseDecimal(ls_prn_amt) -->
                    <td width="15%" height="38%"><img src="../../images/result2.gif" height="10px;" name="plus"></img></td> <!-- 차액 그래프 플러스(+) 2018.03.21-->
                    <%-- <td width="30%" height="38%"><img <%if(dly_amt > 0){ %>src="../../images/result2.gif"<%} else{%>src="../../images/result4.gif" <%} %> height="10px;" name="difference"></img></td> --%><!-- 차액 그래프 플러스(+)/마이너스(-) -->
                    <td width="10%" height="38%" align="right" class="dly_amt"><%=Util.parseDecimal(dly_amt)%></td><!-- 차액 금액 -->                    
                    <td width="18.5%"><img src=../../images/result1.gif width='<%if(per*1.4 > 140){%>140<%}else{%><%=per*1.4%><%}%>' height=10>
                      <%=AddUtil.parseFloatCipher(per,2)%>% </td>
                </tr>
                  <%	
                  	total_amt1 = total_amt1 + fee_amt;
        			total_amt2 = total_amt2 + prn_amt;
					total_amt3 = total_amt3 + int_amt;
        			total_amt4 = total_amt4 + alt_amt;
        			total_amt5 = total_amt5 + dly_amt;
        			total_amt6 = total_amt6 + ls_prn_amt;
        		  }%>
                <tr> 
                    <td height="20" class=title align="center"></td>
                    <td height="20" class=title align="center">합계</td>
                    <td height="20" class=title align="right" style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>
                    <td height="20" align="right" class=title style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>
                    <td height="20" align="right" class=title style='text-align:right'><%=Util.parseDecimal(total_amt3)%></td>
                    <td height="20" align="right" class=title style='text-align:right'><%=Util.parseDecimal(total_amt4)%></td>
                    <td height="20" class=title align="right" style='text-align:right' colspan="2"><%-- <%=Util.parseDecimal(total_amt6)%> --%></td>
                    <td height="20" id="amt5_total" class=title align="right" style='text-align:right'><%=Util.parseDecimal(total_amt5)%></td>
                    <td height="20" class=title></td>
                </tr>
            </table>
        </td>
    </tr>	
</table>
</form>
</body>
<!-- 차액 그래프 +, - 그래프 추가 2018.03.21 -->
<script>
var amt5_total = $("#amt5_total").text();
var regExp = /[,]/gi;
var amt5_total_num = amt5_total.replace(regExp, "");
var amt5_total_first = amt5_total_num.substring(0,1);
var amt5_total_100 = amt5_total_num/(Number(amt5_total_first)*100000000);
var amt5_total_162 = amt5_total_100 + (amt5_total_100/100*30);
var amt5_total_162_2 = Math.round(amt5_total_162);
$(".dly_amt").each(function(i){
	var dly_amt = $(this).text().replace(regExp, "");
	var dly_amt_100;
	var dly_amt_162;
	var dly_amt_162_2;
	var dly_amt_minus;
	if(dly_amt>0){
		dly_amt_100 = dly_amt/(Number(amt5_total_first)*10000000);
		dly_amt_162 = dly_amt_100 + (dly_amt_100/100*30);
		dly_amt_162_2 = (dly_amt_162/amt5_total_162_2)*400;
		dly_amt_162_3 = dly_amt_162_2.toFixed(1);
		$("img[name=plus]").eq(i).width(dly_amt_162_3);
		$("img[name=minus]").eq(i).width(0);
	}else{
		dly_amt_minus = Number(dly_amt) * -1;
		dly_amt_100 = dly_amt_minus/(Number(amt5_total_first)*10000000);
		dly_amt_162 = dly_amt_100 + (dly_amt_100/100*30);
		dly_amt_162_2 = (dly_amt_162/amt5_total_162_2)*350;
		dly_amt_162_3 = dly_amt_162_2.toFixed(1);
		$("img[name=minus]").eq(i).width(dly_amt_162_3);
		$("img[name=plus]").eq(i).width(0);
	}
	// $("img[name=difference]").eq(i).width(dly_amt_162_3);
});
</script>
</html>
