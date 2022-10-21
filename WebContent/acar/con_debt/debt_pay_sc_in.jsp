<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	function init(){		
		setupEvents();
	}	
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"6":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.ChangeDate2(request.getParameter("st_dt"));
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeDate2(request.getParameter("end_dt"));
//	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
//	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	int total_su = 0;
	long total_amt = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "03", "01");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "02");
	
	Vector debts = ad_db.getAllotPayList(br_id, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int debt_size = debts.size();
%>
<form name='form1' method='post'>
<input type='hidden' name='allot_size' value='<%=debt_size%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<table border="0" cellspacing="0" cellpadding="0" width=1300>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width=30% id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width=11% class='title'>연번</td>
					<td width=27% class='title'>계약번호</td>
					<td width=37% class='title'>상호</td>
					<td width=25% class='title'>차량번호</td>
				</tr>
			</table>
		</td>
		<td class='line' width=70%>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>					
                    <td width=18% class='title'>금융사</td>
					<td width=7% class='title'>회차</td>
					<td width=10% class='title'>상환일자</td>
					<td width=12% class='title'>상환원금</td>	
					<td width=11% class='title'>상환이자</td>	
					<td width=12% class='title'>월할부금</td>
					<td width=13% class='title'>잔액원금</td>
					<td width=10% class='title'>출금일자</td>	
					<!--<td width=8% class='title'>자동전표</td>-->
					<td width=7% class='title'>출금</td>
				</tr>
			</table>
		</td>
	</tr>
<%	if(debt_size > 0){%>
	<tr>
		<td class='line' width=30% id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <%		for(int i = 0 ; i < debt_size ; i++){
			Hashtable debt = (Hashtable)debts.elementAt(i);%>
                <tr> 
                    <td width=11% align='center'><a name="<%=i+1%>"><%=i+1%></a></td>
                    <td width=27% align='center'><a href="javascript:parent.view_allot('<%=debt.get("RENT_MNG_ID")%>', '<%=debt.get("RENT_L_CD")%>', '<%=debt.get("CAR_MNG_ID")%>',  '<%=debt.get("LEND_ID")%>', '<%=debt.get("GUBUN")%>', '<%=debt.get("RTN_SEQ")%>', '<%=i%>')" onMouseOver="window.status=''; return true"><%=debt.get("RENT_L_CD")%></a></td>
                    <td width=37% align='center'><span title='<%=debt.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(debt.get("FIRM_NM")), 8)%></span><%=debt.get("DEPOSIT_NO")%></td>
                    <td width=25% align='center'><span title='<%=debt.get("CAR_NO")%>'><%=debt.get("CAR_NO")%></span></td>
                </tr>
          <%		}%>
                <tr> 
                    <td class="title" align='center'></td>
			        <td class="title">&nbsp;</td>
                    <td class="title" align='center'>합계</td>
                    <td class="title">&nbsp;</td>
                </tr>
            </table>
		</td>
		<td class='line' width=70%>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <%		for(int i = 0 ; i < debt_size ; i++){
			Hashtable debt = (Hashtable)debts.elementAt(i);%>
                <tr> 
                    <td width=18% align='center'><span title='<%=c_db.getNameById(String.valueOf(debt.get("CPT_CD")), "BANK")%>'><%=Util.subData(c_db.getNameById(String.valueOf(debt.get("CPT_CD")), "BANK"), 5)%></span></td>
                    <td width=7% align='center'><%=debt.get("ALT_TM")%>회</td>
                    <td width=10% align='center'><%=debt.get("ALT_EST_DT")%></td>
                    <td width=12% align='right'><%=AddUtil.parseDecimal(String.valueOf(debt.get("ALT_PRN")))%></td>
                    <td width=11% align='right'><%=AddUtil.parseDecimal(String.valueOf(debt.get("ALT_INT")))%></td>
                    <td width=12% align='right'><%=AddUtil.parseDecimal(String.valueOf(debt.get("ALT_AMT")))%></td>
                    <td width=13% align='right'><%=AddUtil.parseDecimal(String.valueOf(debt.get("ALT_REST")))%></td>
                    <td width=10% align='center'><%=debt.get("PAY_DT")%></td>
                    <!--
                    <td width=8% align='center'> 
                      <%if(debt.get("PAY_YN").equals("0") && (auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))){%>
                      <a href="javascript:parent.pay_allot('a', '<%=auth_rw%>', '<%=debt.get("CAR_MNG_ID")%>', '<%=debt.get("ALT_TM")%>', '<%=debt.get("LEND_ID")%>', '<%=debt.get("GUBUN")%>', '<%=debt.get("RTN_SEQ")%>', '<%=i%>')"><img src=../images/center/button_in_bh.gif align=absmiddle border=0></a> 
                      <%}else{%>
                      -
                      <%}%>
                    </td>
                    -->
                    <td width=7% align='center'> 
                      <%if(debt.get("PAY_YN").equals("0") && (auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))){%>
                      <!--<a href="javascript:parent.pay_allot('p', '<%=auth_rw%>', '<%=debt.get("CAR_MNG_ID")%>', '<%=debt.get("ALT_TM")%>', '<%=debt.get("LEND_ID")%>', '<%=debt.get("GUBUN")%>', '<%=debt.get("RTN_SEQ")%>', '<%=i%>')"><img src=../images/center/button_in_cg.gif align=absmiddle border=0></a> -->
                      <%}else{%>
                      - 
                      <%}%>
                    </td>			
                </tr>
          <%
				total_amt  = total_amt  + Long.parseLong(String.valueOf(debt.get("ALT_PRN"))==null?"0":String.valueOf(debt.get("ALT_PRN")));
		  		total_amt2 = total_amt2 + Long.parseLong(String.valueOf(debt.get("ALT_INT"))==null?"0":String.valueOf(debt.get("ALT_INT")));
		  		total_amt3 = total_amt3 + Long.parseLong(String.valueOf(debt.get("ALT_AMT"))==null?"0":String.valueOf(debt.get("ALT_AMT")));
				if(!String.valueOf(debt.get("ALT_REST")).equals("")){
			  		total_amt4 = total_amt4 + Long.parseLong(String.valueOf(debt.get("ALT_REST"))==null?"0":String.valueOf(debt.get("ALT_REST")));
				}
		  			}%>
                <tr> 
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>		  
                    <td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt)%></td>
                    <td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt2)%></td>
                    <td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt3)%></td>
                    <td class="title" style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt4)%></td>
                    <td class="title">&nbsp;</td>
                    <!--<td class="title">&nbsp;</td>-->
                    <td class="title">&nbsp;</td>
                </tr>
            </table>
		</td>
<%	}else{%>
	<tr>
		<td class='line' width=30% id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td class='line' width=70%>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%	}%>
</table>
</form>
</body>
</html>
