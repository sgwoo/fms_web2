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
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String cpt_cd = request.getParameter("cpt_cd")==null?"":request.getParameter("cpt_cd");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	long total_amt = 0;	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector debts = ad_db.getBankLendList2(cpt_cd, st_dt, end_dt);
	int debt_size = debts.size();
%>
<form name='form1' action='' method="post">
<input type='hidden' name='cpt_cd' value='<%=cpt_cd%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='allot_size' value='<%=debt_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=740>
	<tr>
		<td align='center'>
			<font color="navy"><%=c_db.getNameById(cpt_cd, "BANK")%> 대출리스트</font>
		</td>
	</tr>
	<tr>
		<td align='right'>
			* 대출기간 : <%=AddUtil.ChangeDate2(st_dt)%> ~ <%=AddUtil.ChangeDate2(end_dt)%>
		</td>
	</tr>	
	<tr>
		<td class='line'>			
        <table border="0" cellspacing="1" cellpadding="0">
          <tr>
			<td width='30' class='title'>연번</td>
			<td class='title'>상호</td>		
			<td width='100' class='title'>차명</td>								
			<td width='90' class='title'>차량번호</td>
			<td width='120' class='title'>차대번호</td>						
			<td width='70' class='title'>대출일자</td>
			<td width='80' class='title'>대출금액</td>
			<!--
			<td width='60' class='title'>등록지역</td>
			<td width='80' class='title'>관리번호</td>
			-->
			<td width='130' class='title'>대출번호</td>
		  </tr>
<%		for(int i = 0 ; i < debt_size ; i++){
			Hashtable debt = (Hashtable)debts.elementAt(i);%>
		  <tr>
			<td align='center'><%=i+1%></td>
			<td>&nbsp;<%=debt.get("FIRM_NM")%></td>
			<td>&nbsp;<%=debt.get("CAR_NM")%></td>
			<td align='center'><%=debt.get("CAR_NO")%></td>
			<td align='center'><%=debt.get("CAR_NUM")%></td>			
			<td align='center'><%=AddUtil.ChangeDate2(String.valueOf(debt.get("LEND_DT")))%></td>
			<td align='right'><%=Util.parseDecimal(String.valueOf(debt.get("LEND_PRN")))%></td>
			<!--
			<td align='center'><%=debt.get("CAR_EXT")%></td>
			<td align='center'><%=debt.get("CAR_DOC_NO")%></td>
			-->
			<td align='center'><%=debt.get("LEND_NO")%></td>
			<td>		
		  </tr>					
<%			total_amt   = total_amt   + Long.parseLong(String.valueOf(debt.get("LEND_PRN")));
		} %>			
          <tr> 
            <td class="star" align='center' colspan="6">합계</td>
            <td class="star" align='right'><%=Util.parseDecimal(total_amt)%></td>
			<!--
			<td class="star">&nbsp;</td>			
			<td class="star">&nbsp;</td>
			-->
			<td class="star">&nbsp;</td>
          </tr>						
		</table>
	  </td>
	</tr>
  </table>
</form>
</body>
</html>