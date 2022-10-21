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
	long total_amt = 0;	
	long total_amt2 = 0;
	long total_amt3 = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector debts = ad_db.getCltrRegStatList(br_id, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int debt_size = debts.size();
%>
<form name='form1' action='debt_pay_sc.jsp' method="post">
<input type='hidden' name='allot_size' value='<%=debt_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=1130>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='360' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
					<td width=40 class='title'>연번</td>
					<td width=40 class='title'>구분</td>	
					<td width=40 class='title'>등록</td>	
					<td width=50 class='title'>근저당</td>								
					<td width=90 class='title'>차량번호</td>
					<td width=100 class='title'>상호</td>					
				</tr>
			</table>
		</td>
		<td class='line' width='770'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
		            <td width=100 class='title'>금융사</td>					
					<td width=80 class='title'>대출일</td>
					<td width=100 class='title'>대출금액</td>
					<td width=100 class='title'>설정약정액</td>
					<td width=100 class='title'>설정가액</td>					
					<td width=50 class='title'>설정율</td>
					<td width=80 class='title'>서류작성일</td>
					<td width=80 class='title'>설정일자</td>
					<td width=80 class='title'>말소일자</td>
				</tr>
			</table>
		</td>
	</tr>
<%	if(debt_size > 0){%>
	<tr>
		<td class='line' width='360' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < debt_size ; i++){
			Hashtable debt = (Hashtable)debts.elementAt(i);
			String use_yn = (String)debt.get("USE_YN");%>
				<tr>
					<td  align='center' width=40><%=i+1%></td>
					<td  align='center' width=40><%if(use_yn.equals("Y")) {%>대여 <%}else{%>해지 <%}%></td>	
				    <td  align='center' width=40><%=debt.get("CLTR_ST")%></td>						
					<td  align='center' width=50>
					<%if(debt.get("CPT_CD").equals("")){%>
		              <a href="javascript:parent.view_reg_allot('<%=debt.get("RENT_MNG_ID")%>', '<%=debt.get("RENT_L_CD")%>', '<%=debt.get("CAR_MNG_ID")%>',  'i')" onMouseOver="window.status=''; return true"><font color="#6699CC"><img src=../images/center/button_in_plus.gif align=absmiddle border=0></font></a> 
					<%}else{%>
        		      <a href="javascript:parent.view_reg_allot('<%=debt.get("RENT_MNG_ID")%>', '<%=debt.get("RENT_L_CD")%>', '<%=debt.get("CAR_MNG_ID")%>',  'u')" onMouseOver="window.status=''; return true"><font color="#009900"><img src=../images/center/button_in_modify.gif align=absmiddle border=0></font></a> 
					<%}%></td>								
					<td  align='center' width=90><a href="javascript:parent.view_car('<%=debt.get("RENT_MNG_ID")%>', '<%=debt.get("RENT_L_CD")%>', '<%=debt.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='자동차등록내역'><%=debt.get("CAR_NO")%></a></td>					
					<td  align='center' width=100><span title='<%=debt.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(debt.get("FIRM_NM")), 6)%></span></td>
				</tr>					
<%		} %>			
          <tr> 
			<td class="title">&nbsp;</td>
			<td class="title">&nbsp;</td>
			<td class="title">&nbsp;</td>
			<td class="title">&nbsp;</td>
            <td class="title" align='center'>합계</td>
			<td class="title">&nbsp;</td>			
          </tr>		
			</table>
		</td>
		<td class='line' width='770'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < debt_size ; i++){
			Hashtable debt = (Hashtable)debts.elementAt(i);%>					
				<tr>
					<td  align='center' width=100><%=c_db.getNameById(String.valueOf(debt.get("CPT_CD")), "BANK")%></td>				
					<td  align='center' width=80><%=debt.get("LEND_DT")%></td>
					<td  align='right' width=100><%=Util.parseDecimal(String.valueOf(debt.get("LEND_PRN")))%></td>
					<td  align='right' width=100><%=Util.parseDecimal(String.valueOf(debt.get("CLTR_AMT")))%></td>					
					<td  align='right' width=100><%=Util.parseDecimal(String.valueOf(debt.get("ClTR_F_AMT")))%></td>
					<td  align='center' width=50><%=debt.get("CLTR_PER_LOAN")%>%</td>				
					<td  align='center' width=80><%=debt.get("CLTR_DOCS_DT")%></td>											
					<td  align='center' width=80><%=debt.get("CLTR_SET_DT")%></td>					
					<td  align='center' width=80><%=debt.get("CLTR_EXP_DT")%></td>					

				</tr>
<%						total_amt   = total_amt   + AddUtil.parseLong(String.valueOf(debt.get("LEND_PRN")));
						total_amt2  = total_amt2  + AddUtil.parseLong(String.valueOf(debt.get("ClTR_AMT")));
						total_amt2  = total_amt2  + AddUtil.parseLong(String.valueOf(debt.get("ClTR_F_AMT")));
		}%>
          <tr> 
			<td class="title">&nbsp;</td>
			<td class="title">&nbsp;</td>
			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%></td>
			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>
			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt3)%></td>			
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
		<td class='line' width='360' id='td_con' style='position:relative;'>
			
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td class='line' width='770'>
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