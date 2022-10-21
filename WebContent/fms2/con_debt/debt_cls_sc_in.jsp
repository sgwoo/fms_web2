<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	/* Title ���� */
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
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	long total_amt9 = 0;
	long total_amt10 = 0;
	long total_amt11 = 0;
	long total_amt12 = 0;
	long total_amt13 = 0;
	long total_amt14 = 0;
	
	Vector debts = ad_db.getDebtClsList(gubun1, gubun2, gubun3, gubun4, s_kd, t_wd, sort_gubun, asc);
	int debt_size = debts.size();
%>
<form name='form1' action='debt_cls_sc.jsp' method="post">
<input type='hidden' name='allot_size' value='<%=debt_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=1980>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='360' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
					<td width=40 class='title' style='height:50'>����</td>
					<td width=50 class='title'>����</td>		
					<td width=80 class='title'>������</td>								
					<td width=100 class='title'>����ȣ</td>
					<td width=90 class='title'>������ȣ</td>
				</tr>
			</table>
		</td>
		<td class='line' width='1620'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width=70 rowspan="2" class='title'>�ŷ�ó<br>�ڵ�</td>								
					<td width=160 rowspan="2" class='title'>���¹�ȣ</td>				
					<td width=70 rowspan="2" class='title'>�ߵ���ȯ��</td>
					<td colspan="4" class='title' style='height:25'>�Һν�����</td>
					<td colspan="9" class='title' style='height:25'>�ߵ������ݾ׻��⳻��</td>
				</tr>
				<tr>
			      <td width=70 class='title'>��������</td>				
			      <td width=100 class='title'>����</td>
				  <td width=100 class='title'>����</td>
			      <td width=120 class='title'>�հ�</td>				
			      <td width=100 class='title' style='height:25'>�̻�ȯ����</td>			  
				  <td width=100 class='title'>����������ä</td>
			      <td width=100 class='title'>������Ա�</td>
			      <td width=100 class='title'>����������</td> 
			      <td width=100 class='title'>��Ÿ������</td> <!-- �׸�Ȯ�� -2022-08 -->
			      <td width=100 class='title'>�������</td>
			      <td width=100 class='title'>��ü�Һα�</td>
			      <td width=100 class='title'>������</td>
			      <td width=130 class='title'>�հ�</td>
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
			String st1 = String.valueOf(debt.get("ST1"));
			String st2 = String.valueOf(debt.get("ST2"));%>
				<tr>
					<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='center' width=40><%=i+1%></td>
					<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='center' width=50><%=st2%></td>		
					<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='center' width=80><span title='<%=debt.get("CPT_NM")%>'><%=AddUtil.substringbdot(String.valueOf(debt.get("CPT_NM")), 10)%></span></td>								
					<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='center' width=100>
						<a href="javascript:parent.view_allot('<%=debt.get("RENT_MNG_ID")%>', '<%=debt.get("RENT_L_CD")%>', '<%=debt.get("CAR_MNG_ID")%>',  '<%=debt.get("LEND_ID")%>', '<%=debt.get("GUBUN")%>', '<%=debt.get("RTN_SEQ")%>', '<%=i%>')" onMouseOver="window.status=''; return true">
						<span title='<%=debt.get("LEND_NO")%>'><%=AddUtil.substringbdot(String.valueOf(debt.get("LEND_NO")), 12)%></span>
						<%if(String.valueOf(debt.get("LEND_NO")).equals("") && st2.equals("����")){%>
						<%=debt.get("LEND_ID")%> <%=debt.get("RTN_SEQ")%>
						<%}else if(String.valueOf(debt.get("LEND_NO")).equals("") && st2.equals("����")){%>
						<%=debt.get("RENT_L_CD")%>
						<%}%>
						</a>
					</td>
					<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='center' width=90><%=debt.get("CAR_NO")%></td>					
				</tr>					
<%		} %>			
          <tr> 
			<td colspan="5" class="title">&nbsp;</td>
		  </tr>		
		</table>
		</td>
		<td class='line' width='1600'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < debt_size ; i++){
			Hashtable debt = (Hashtable)debts.elementAt(i);
			String st1 = String.valueOf(debt.get("ST1"));%>					
				<tr>
					<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='center' width=70><%=debt.get("VEN_CODE")%></td>				
					<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='center' width=160><%=debt.get("DEPOSIT_NO")%></td>				
					<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='center' width=70><%=debt.get("CLS_RTN_DT")%></td>
					<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='center' width=70><%=debt.get("PAY_DT1")%></td>				
					<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=100><%=Util.parseDecimal(String.valueOf(debt.get("ALT_PRN")))%>��</td>						
					<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=100><%=Util.parseDecimal(String.valueOf(debt.get("ALT_INT")))%>��</td>
					<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=120><%=Util.parseDecimal(String.valueOf(debt.get("ALT_AMT")))%>��</td>
					<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=100><%=Util.parseDecimal(String.valueOf(debt.get("NALT_REST")))%>��</td>
					<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=100><%=Util.parseDecimal(String.valueOf(debt.get("NALT_REST_1")))%>��</td>
					<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=100><%=Util.parseDecimal(String.valueOf(debt.get("NALT_REST_2")))%>��</td>
					<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=100><%=Util.parseDecimal(String.valueOf(debt.get("CLS_RTN_FEE")))%>��</td>
					<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=100><%=Util.parseDecimal(String.valueOf(debt.get("CLS_ETC_FEE")))%>��</td>
					<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=100><%=Util.parseDecimal(String.valueOf(debt.get("CLS_RTN_INT_AMT")))%>��</td>
					<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=100><%=Util.parseDecimal(String.valueOf(debt.get("DLY_ALT")))%>��</td>
					<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=100><%=Util.parseDecimal(String.valueOf(debt.get("BE_ALT")))%>��</td>
					<td <%if(st1.equals("���οϷ�"))%>class=is<%%> align='right' width=130><%=Util.parseDecimal(String.valueOf(debt.get("CLS_RTN_AMT")))%>��</td>
			    </tr>
<%						total_amt1   = total_amt1   + AddUtil.parseLong(String.valueOf(debt.get("ALT_PRN")));
						total_amt2   = total_amt2   + AddUtil.parseLong(String.valueOf(debt.get("ALT_INT")));
						total_amt3   = total_amt3   + AddUtil.parseLong(String.valueOf(debt.get("ALT_AMT")));
						total_amt4   = total_amt4   + AddUtil.parseLong(String.valueOf(debt.get("NALT_REST")));
						total_amt5   = total_amt5   + AddUtil.parseLong(String.valueOf(debt.get("NALT_REST_1")));
						total_amt6   = total_amt6   + AddUtil.parseLong(String.valueOf(debt.get("NALT_REST_2")));
						total_amt7   = total_amt7   + AddUtil.parseLong(String.valueOf(debt.get("CLS_RTN_FEE")));
						total_amt8   = total_amt8   + AddUtil.parseLong(String.valueOf(debt.get("CLS_RTN_INT_AMT")));
						total_amt9   = total_amt9   + AddUtil.parseLong(String.valueOf(debt.get("DLY_ALT")));
						total_amt10  = total_amt10  + AddUtil.parseLong(String.valueOf(debt.get("BE_ALT")));
						total_amt11  = total_amt11  + AddUtil.parseLong(String.valueOf(debt.get("CLS_RTN_AMT")));
						total_amt12  = total_amt12  + AddUtil.parseLong(String.valueOf(debt.get("CLS_ETC_FEE")));
		}%>
          <tr> 
			<td class="title">&nbsp;</td>		  
			<td class="title">&nbsp;</td>
			<td class="title">&nbsp;</td>			
			<td class="title">&nbsp;</td>
			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%>��</td>
			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%>��</td>
			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt3)%>��</td>
			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt4)%>��</td>
			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt5)%>��</td>
			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt6)%>��</td>
			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt7)%>��</td>
			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt12)%>��</td>
			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt8)%>��</td>
			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt9)%>��</td>
			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt10)%>��</td>
			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt11)%>��</td>
            </tr>		
			</table>
		</td>
	</tr>		
<%	}else{%>
	<tr>
		<td class='line' width='360' id='td_con' style='position:relative;'>
			
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
					<td align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
				</tr>
			</table>
		</td>
		<td class='line' width='1570'>
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