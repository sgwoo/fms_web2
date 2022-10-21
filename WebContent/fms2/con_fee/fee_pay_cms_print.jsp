<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*, acar.bill_mng.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	function view_scd(m_id, l_cd)
	{
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.target = 'd_content';
		fm.action='fee_c_mgr.jsp'
		fm.submit();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<%
	String adate = request.getParameter("adate")==null?"":request.getParameter("adate");
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	
	//acms 테이블에서 입금미반영 리스트 조회하기
	Vector vt = af_db.getACmsDateList(adate);
	int vt_size = vt.size();
%>
<form name='form1' method='post'>
<input type='hidden' name='adate' value='<%=adate%>'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='sh_height' value='74'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	<td>< 이체 결과 조회 ></td>
  </tr>
  <tr>
	<td class='line'>
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>
		<tr>
		  <td width='30' class='title'>연번</td>
		  <td class='title'>상호</td>
		  <td width='100' class='title'>차량번호</td>
		  <td width='100' class='title'>계약번호</td>
		  <td width='100' class='title'>출금의뢰금액</td>
		  <td width='100' class='title'>출금액</td>
		  <td width='100' class='title'>입금처리금액</td>
		  <td width='100' class='title'>남는금액</td>
		  </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
		<tr>
		  <td align="center" ><%=i+1%></td>
		  <td >&nbsp;<%=ht.get("FIRM_NM")%></td>
		  <td align="center" ><%=ht.get("CAR_NO")%></td>
		  <td align="center" ><a href="javascript:view_scd('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>')"><%=ht.get("ACODE")%></a></td>
		  <td align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("AAMT")))%></td>
		  <td align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("AOUTAMT")))%></td>
		  <td align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("RC_AMT")))%></td>
		  <td align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("DEF_AMT")))%></td>
		</tr>
<%			total_amt1 = total_amt1 + Long.parseLong(String.valueOf(ht.get("AAMT")));
			total_amt2 = total_amt2 + Long.parseLong(String.valueOf(ht.get("AOUTAMT")));
			total_amt3 = total_amt3 + Long.parseLong(String.valueOf(ht.get("RC_AMT")));
			total_amt4 = total_amt4 + Long.parseLong(String.valueOf(ht.get("DEF_AMT")));
		}%>	
		<tr>
		  <td class=star>&nbsp;</td>
		  <td class=star align="center" >합계</td>
		  <td class=star >&nbsp;</td>
		  <td class=star >&nbsp;</td>
		  <td align="right" class=star ><%=Util.parseDecimal(total_amt1)%></td>
		  <td align="right" class=star ><%=Util.parseDecimal(total_amt2)%></td>
		  <td align="right" class=star ><%=Util.parseDecimal(total_amt3)%></td>
		  <td align="right" class=star ><%=Util.parseDecimal(total_amt4)%></td>
		</tr>	
	  </table>
	</td>
  </tr>  
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>