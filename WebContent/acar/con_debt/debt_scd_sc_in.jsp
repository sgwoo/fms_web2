<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
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
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector debts = ad_db.getAllotScdList(br_id, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int debt_size = debts.size();
%>
<form name='form1' action='debt_pay_sc.jsp' method="post">
<input type='hidden' name='allot_size' value='<%=debt_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=1850>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='720' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
					<td width=50 class='title' style='height:38'>연번</td>
					<td width=50 class='title'>구분</td>		
					<td width=60 class='title'>할부<br>관리</td>								
					<td width=100 class='title'>계약번호</td>
					<td width=100 class='title'>상호</td>
					<td width=60 class='title'>고객명</td>
					<td width=90 class='title'>차량번호</td>
					<td width=100 class='title'>차명</td>
		            <td class='title'>금융사</td>
				</tr>
			</table>
		</td>
		<td class='line' width='1100'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width=80 class='title' style='height:38'>대출일</td>
					<td width=110 class='title'>대출번호</td>					
					<td width=110 class='title'>대출금액</td>
					<td width=110 class='title'>월할부금</td>
					<td width=110 class='title'>이자합계</td>
					<td width=110 class='title'>원금합계</td>
					<td width=50 class='title'>이자율</td>					
					<td width=50 class='title'>할부<br>횟수</td>					
					<td width=100 class='title'>마지막회차<br>이자</td>					
					<td width=70 class='title'>마지막회차<br>결제일자</td>					
					<td width=50 class='title'>등록<br>여부</td>
					<td width=50 class='title'>설정<br>(말소)</td>					
					<td width=50 class='title'>납부<br>상태</td>
					<td width=50 class='title'>자금<br>관리</td>
				</tr>
			</table>
		</td>
	</tr>
<%	if(debt_size > 0){%>
	<tr>
		<td class='line' width='720' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < debt_size ; i++){
			Hashtable debt = (Hashtable)debts.elementAt(i);
			String use_yn = (String)debt.get("USE_YN");
			String all_yn = String.valueOf(debt.get("ALL_YN"));%>
				<tr>
					<td <%if(all_yn.equals("납부완료"))%>class=is<%%> align='center' width=50><%=i+1%></td>
					<td <%if(all_yn.equals("납부완료"))%>class=is<%%> align='center' width=50><%if(use_yn.equals("Y")){%>대여<%}else{%>해지<%}%></td>		
					<td <%if(all_yn.equals("납부완료"))%>class=is<%%> align='center' width=60>
					<%if(debt.get("CPT_CD").equals("")){%>
		              <a href="javascript:parent.view_reg_allot('<%=debt.get("RENT_MNG_ID")%>', '<%=debt.get("RENT_L_CD")%>', '<%=debt.get("CAR_MNG_ID")%>',  'i')" onMouseOver="window.status=''; return true"><font color="#6699CC"><img src=../images/center/button_in_plus.gif align=absmiddle border=0></font></a> 
					<%}else{%>
        		      <a href="javascript:parent.view_reg_allot('<%=debt.get("RENT_MNG_ID")%>', '<%=debt.get("RENT_L_CD")%>', '<%=debt.get("CAR_MNG_ID")%>',  'u')" onMouseOver="window.status=''; return true"><font color="#009900"><img src=../images/center/button_in_modify.gif align=absmiddle border=0></font></a> 
					<%}%></td>								
					<td <%if(all_yn.equals("납부완료"))%>class=is<%%> align='center' width=100>
					<%if(debt.get("ALLOT_ST").equals("1")){	//현금구매	-- 스케줄이 없다%>
					<%=debt.get("RENT_L_CD")%>
					<%}else{	//일반할부구매
						if(debt.get("REG_YN").equals("Y")){%>
						<a href="javascript:parent.view_scd_allot('<%=debt.get("RENT_MNG_ID")%>', '<%=debt.get("RENT_L_CD")%>', '<%=debt.get("CAR_MNG_ID")%>',  'u')" onMouseOver="window.status=''; return true"><%=debt.get("RENT_L_CD")%></a>
					<%	}else{%>
						<a href="javascript:parent.view_scd_allot('<%=debt.get("RENT_MNG_ID")%>', '<%=debt.get("RENT_L_CD")%>', '<%=debt.get("CAR_MNG_ID")%>',  'i')" onMouseOver="window.status=''; return true"><%=debt.get("RENT_L_CD")%></a>
					<%	}
					  }%>
					</td>
					<td <%if(all_yn.equals("납부완료"))%>class=is<%%> align='center' width=100><span title='<%=debt.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(debt.get("FIRM_NM")), 5)%></span></td>
					<td <%if(all_yn.equals("납부완료"))%>class=is<%%> align='center' width=60><span title='<%=debt.get("CLIENT_NM")%>'><%=Util.subData(String.valueOf(debt.get("CLIENT_NM")), 3)%></span></td>
					<td <%if(all_yn.equals("납부완료"))%>class=is<%%> align='center' width=90><a href="javascript:parent.view_car('<%=debt.get("RENT_MNG_ID")%>', '<%=debt.get("RENT_L_CD")%>', '<%=debt.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='자동차등록내역'><%=debt.get("CAR_NO")%></a></td>					
					<td <%if(all_yn.equals("납부완료"))%>class=is<%%> align='center' width=100><span title='<%=debt.get("CAR_NM")%>'><%=Util.subData(String.valueOf(debt.get("CAR_NM")), 5)%></span></td>
					<td <%if(all_yn.equals("납부완료"))%>class=is<%%> align='center'>
					<%if(debt.get("ALLOT_ST").equals("1")){//현금구매%>
					현금구매
					<%}else{%>
					<%-- <%=c_db.getNameById(String.valueOf(debt.get("CPT_CD")), "BANK")%> --%>
					<span title='<%=c_db.getNameById(String.valueOf(debt.get("CPT_CD")), "BANK")%>'><%=Util.subData(c_db.getNameById(String.valueOf(debt.get("CPT_CD")), "BANK"), 7)%></span>
					<%}%>
					<%if(String.valueOf(debt.get("FILE_TYPE")).equals(".jpg") || String.valueOf(debt.get("FILE_TYPE")).equals(".JPG")){%>
					<img src=/acar/images/center/icon_jpg.gif align=absmiddle border="0">
					<%}else if(String.valueOf(debt.get("FILE_TYPE")).equals(".pdf") || String.valueOf(debt.get("FILE_TYPE")).equals(".PDF")){%>										
					<img src=/acar/images/center/icon_pdf.gif align=absmiddle border="0">
					<%}else if(!String.valueOf(debt.get("FILE_TYPE")).equals("")){%>					
					<img src=/acar/images/center/icon_memo.gif align=absmiddle border="0">					
					<%}%>
					</td>
				</tr>					
<%		} %>			
          <tr> 
			<td class="title">&nbsp;</td>
			<td class="title">&nbsp;</td>
			<td class="title">&nbsp;</td>
			<td class="title">&nbsp;</td>
            <td class="title" align='center'>합계</td>
			<td class="title">&nbsp;</td>
            <td class="title">&nbsp;</td>
			<td class="title">&nbsp;</td>
			<td class="title">&nbsp;</td>
          </tr>		
			</table>
		</td>
		<td class='line' width='1100'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < debt_size ; i++){
			Hashtable debt = (Hashtable)debts.elementAt(i);
			String all_yn = String.valueOf(debt.get("ALL_YN"));%>					
				<tr>
					<td <%if(all_yn.equals("납부완료"))%>class=is<%%> align='center' width=80><%=debt.get("LEND_DT")%></td>
					<td <%if(all_yn.equals("납부완료"))%>class=is<%%> align='center' width=110><span title='<%=debt.get("LEND_NO")%>'><%=Util.subData(String.valueOf(debt.get("LEND_NO")), 14)%></span></td>					
					<td <%if(all_yn.equals("납부완료"))%>class=is<%%> align='right' width=110><%=Util.parseDecimal(String.valueOf(debt.get("LEND_PRN")))%>원&nbsp;</td>
					<td <%if(all_yn.equals("납부완료"))%>class=is<%%> align='right' width=110><%=Util.parseDecimal(String.valueOf(debt.get("ALT_AMT")))%>원&nbsp;</td>
					<td <%if(all_yn.equals("납부완료"))%>class=is<%%> align='right' width=110><%=Util.parseDecimal(String.valueOf(debt.get("T_ALT_INT")))%>원&nbsp;</td>
					<td <%if(all_yn.equals("납부완료"))%>class=is<%%> align='right' width=110><%=Util.parseDecimal(String.valueOf(debt.get("T_ALT_PRN")))%>원&nbsp;</td>										
					<td <%if(all_yn.equals("납부완료"))%>class=is<%%> align='center' width=50><%=debt.get("LEND_INT")%>%</td>					
					<td <%if(all_yn.equals("납부완료"))%>class=is<%%> align='center' width=50><%=debt.get("TOT_ALT_TM")%></td>					
					<td <%if(all_yn.equals("납부완료"))%>class=is<%%> align='right' width=100><%=Util.parseDecimal(String.valueOf(debt.get("MAX_ALT_INT")))%>원&nbsp;</td>															
					<td <%if(all_yn.equals("납부완료"))%>class=is<%%> align='center' width=70><%=debt.get("MAX_ALT_EST_DT")%></td>															
					<td <%if(all_yn.equals("납부완료"))%>class=is<%%> align='center' width=50><%=debt.get("REG_YN")%></td>
					<td <%if(all_yn.equals("납부완료"))%>class=is<%%> align='center' width=50><%=debt.get("CLTR_ST")%>(<%=debt.get("CLTR_EXP_ST")%>)</td>					
					<td <%if(all_yn.equals("납부완료"))%>class=is<%%> align='center' width=50><%if(debt.get("REG_YN").equals("Y")){%><%=debt.get("ALL_YN")%><%}else{%>-<%}%></td>
					<td <%if(all_yn.equals("납부완료"))%>class=is<%%> align='center' width=50><%=debt.get("FUND_ID")%></td>
				</tr>
<%						total_amt1  = total_amt1   + AddUtil.parseLong(String.valueOf(debt.get("LEND_PRN")));
						total_amt2  = total_amt2  + AddUtil.parseLong(String.valueOf(debt.get("ALT_AMT")));
						total_amt3  = total_amt3   + AddUtil.parseLong(String.valueOf(debt.get("T_ALT_INT")));
						total_amt4  = total_amt4  + AddUtil.parseLong(String.valueOf(debt.get("T_ALT_PRN")));
		}%>
          <tr> 
			<td class="title">&nbsp;</td>
			<td class="title">&nbsp;</td>
			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%>원&nbsp;</td>
			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%>원&nbsp;</td>
			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt3)%>원&nbsp;</td>
			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt4)%>원&nbsp;</td>
            <td class="title">&nbsp;</td>
            <td class="title">&nbsp;</td>
            <td class="title">&nbsp;</td>			
            <td class="title">&nbsp;</td>			
            <td class="title">&nbsp;</td>						
			<td class="title">&nbsp;</td>
            <td class="title">&nbsp;</td>
            <td class="title">&nbsp;</td>
          </tr>		
			</table>
		</td>
	</tr>		
<%	}else{%>
	<tr>
		<td class='line' width='710' id='td_con' style='position:relative;'>
			
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td class='line' width='1050'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
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