<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.stat_account.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.stat_account.StatAccountDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"6":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String gubun = request.getParameter("gubun")==null?"total":request.getParameter("gubun");
	String s_yy = request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	int s_mon = request.getParameter("s_mon")==null?36:AddUtil.parseInt(request.getParameter("s_mon"));
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = "";
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
	
	if(st_dt.equals("")) st_dt = s_yy+""+s_mm+"01";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	end_dt = c_db.addMonth(st_dt, s_mon);
	end_dt = c_db.addDay(end_dt, -1);
	
	Vector accs = ac_db.getStatMoney(st_dt, end_dt);
	int acc_size = accs.size();	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
-->
</script>
<script language='javascript'>
<!--
//-->
</script>
<!-- <link rel=stylesheet type="text/css" href="../../include/table.css"> -->
<link rel=stylesheet type="text/css" href="/include/table_t.css"> 
</head>
<body onLoad="javascript:init()">
<form action="stat_bus_sc_null.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='size' value='<%=acc_size%>'>
<input type='hidden' name='s_yy' value='<%=s_yy%>'>
<input type='hidden' name='s_mm' value='<%=s_mm%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='mode' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'> 
        <td id='td_title' style='position:relative;' class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td width="3%" rowspan="2" class=title>연번</td>
                    <td width="4.5%" rowspan="2" class=title>년월</td>
                    <td width="8.5%" rowspan="2" class=title>대여료<br>(공급가)</td>
                    <td colspan="3" class=title>할부금</td><!-- 2018.03.21 -->
                    <td colspan="3" class=title>차액</td><!-- 2018.03.21 -->
                    <td width="18.5%" rowspan="2" class=title>대여료 대비 할부금비</td>
                </tr>
                <tr align="center">
                  <td width="8.5%" class=title>원금</td>
                  <td width="8.5%" class=title>이자</td>
                  <td width="8.5%" class=title>합계</td>
                  <td width="30%" class=title colspan="2">그래프</td><!-- 2018.03.21 -->
                  <td width="10%" class=title>금액</td><!-- 2018.03.21 -->
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td class='line' id='td_con' style='position:relative;'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <%for (int i = 0 ; i < acc_size ; i++){
    				Hashtable acc = (Hashtable)accs.elementAt(i);
    				fee_amt = AddUtil.parseLong(String.valueOf(acc.get("FEE_S_AMT")));
						prn_amt = AddUtil.parseLong(String.valueOf(acc.get("PRN_AMT")));
						int_amt = AddUtil.parseLong(String.valueOf(acc.get("INT_AMT")));
						alt_amt = AddUtil.parseLong(String.valueOf(acc.get("ALT_AMT")));
						dly_amt = AddUtil.parseLong(String.valueOf(acc.get("DLY_AMT")));
						ls_prn_amt = AddUtil.parseLong(String.valueOf(acc.get("LS_PRN_AMT")));
    				float per = AddUtil.parseFloat(String.valueOf(acc.get("ALT_AMT")))/AddUtil.parseFloat(String.valueOf(acc.get("FEE_S_AMT")))*100;%>
                <tr> 
                    <td width="3%" height="38%" align="center"><%=i+1%></td><!-- 연번 -->
                    <td width="4.5%" height="38%" align="center"><%=AddUtil.ChangeDate2(String.valueOf(acc.get("DT")))%></td><!-- 년월 -->
                    <td width="8.5%" height="38%" align="right"><%=Util.parseDecimal(fee_amt)%></td><!-- 대여료 -->
                    <td width="8.5%" align="right"><%=Util.parseDecimal(prn_amt)%></td><!-- 할부금 원금 -->
                    <td width="8.5%" align="right"><%=Util.parseDecimal(int_amt)%></td><!-- 할부금 이자 -->
                    <td width="8.5%" height="38%" align="right"><%=Util.parseDecimal(alt_amt)%></td><!-- 할부금 소계 -->
                    <%-- <td width=10% height="38%" align="right"><%=Util.parseDecimal(ls_prn_amt)%></td> 변경전 --%>
                    <td width="15%" height="38%" align="right" style="text-align:right;"><img src="../../images/result4.gif" height="10px;" name="minus"></img></td><!-- 리스료 그래프 마이너스(-) -->
                    <td width="15%" height="38%"><img src="../../images/result2.gif" height="10px;" name="plus"></img></td><!-- 차액 그래프 플러스(+) 2018.03.21-->
                    <%-- <td width="30%" height="38%"><img <%if(dly_amt > 0){ %>src="../../images/result2.gif"<%} else{%>src="../../images/result4.gif" <%} %> height="10px;" name="difference"></img></td> --%><!-- 차액 그래프 플러스(+)/마이너스(-) -->
                    <td width="10%" height="38%" align="right" class="dly_amt"><%=Util.parseDecimal(dly_amt)%></td><!-- 차액 금액 -->                                      
                    <td width="18.5%"><img src=../../images/result1.gif width='<%if(per*1.4 > 140){%>140<%}else{%><%=per*1.4%><%}%>' height=10> 
                      <%=AddUtil.parseFloatCipher(per,2)%>% 
                      <a href="javascript:MM_openBrWindow('stat_money_sc_in_view_debt_sub_list.jsp?alt_est_m=<%=acc.get("DT")%>','list_id1','scrollbars=yes,status=no,resizable=yes,width=1200,height=860,top=50,left=50')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="할부금전검"></a>  
                    </td>
                </tr>
                  <%	total_amt1 = total_amt1 + fee_amt;
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
<!-- 차액 그래프 +, - 그래프 추가 2018.03.21 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
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
</body>
</html>
