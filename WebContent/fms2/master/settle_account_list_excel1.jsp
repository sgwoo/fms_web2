<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=settle_account_list_excel1.xls");
%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String settle_year 	= request.getParameter("settle_year")==null?"":request.getParameter("settle_year");
	String table_width	= request.getParameter("table_width")==null?"":request.getParameter("table_width");
	
	
	Vector vt = ad_db.getSettleAccount_list1(settle_year);
	int vt_size = vt.size();
	
	Vector vt2 = ad_db.getSettleAccount_list1_sub1(settle_year);
	int vt_size2 = vt2.size();
	
   	String ins_com_nm[]	= new String[vt_size];
   	String car_use[]	= new String[vt_size];   	
   	long t_cnt[]		= new long[vt_size];
	long t1[]		= new long[vt_size];
	long t2[]		= new long[vt_size];
	long t3[]		= new long[vt_size];
	long t4[]		= new long[vt_size];
	long t5[]		= new long[vt_size];
	long t6[]		= new long[vt_size];
	long cnt1[]		= new long[vt_size];
	long amt1[]		= new long[vt_size];	
	long cnt3[]		= new long[vt_size];
	long amt3[]		= new long[vt_size];	
	long cnt4[]		= new long[vt_size];
	long amt4[]		= new long[vt_size];	
	long cnt5[]		= new long[vt_size];
	long amt5[]		= new long[vt_size];	
	
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		ins_com_nm[i]	= String.valueOf(ht.get("INS_COM_NM"));
		car_use[i]	= String.valueOf(ht.get("CAR_USE"));
		t_cnt[i]	= AddUtil.parseLong(String.valueOf(ht.get("T_CNT")));		
		t1[i]		= AddUtil.parseLong(String.valueOf(ht.get("T1")));
		t2[i]		= AddUtil.parseLong(String.valueOf(ht.get("T2")));
		t3[i]		= AddUtil.parseLong(String.valueOf(ht.get("T3")));
		t4[i]		= AddUtil.parseLong(String.valueOf(ht.get("T4")));
		t5[i]		= AddUtil.parseLong(String.valueOf(ht.get("T5")));
		t6[i]		= AddUtil.parseLong(String.valueOf(ht.get("T6")));
		cnt1[i]		= AddUtil.parseLong(String.valueOf(ht.get("CNT1")));
		amt1[i]		= AddUtil.parseLong(String.valueOf(ht.get("AMT1")));
		cnt3[i]		= AddUtil.parseLong(String.valueOf(ht.get("CNT3")));
		amt3[i]		= AddUtil.parseLong(String.valueOf(ht.get("AMT3")));
		cnt4[i]		= AddUtil.parseLong(String.valueOf(ht.get("CNT4")));
		amt4[i]		= AddUtil.parseLong(String.valueOf(ht.get("AMT4")));
		cnt5[i]		= AddUtil.parseLong(String.valueOf(ht.get("CNT5")));
		amt5[i]		= AddUtil.parseLong(String.valueOf(ht.get("AMT5")));
	}
	
	for(int i = 0 ; i < vt_size2 ; i++){
		Hashtable ht = (Hashtable)vt2.elementAt(i);		
		t_cnt[i]	= AddUtil.parseLong(String.valueOf(ht.get("T_CNT")));		
	}
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='settle_year' value='<%=settle_year%>'>
  <table border="0" cellspacing="1" cellpadding="0" width=<%=table_width%>>
	<tr>
	  <td colspan="5" align="center"><%=settle_year%> 자동차보험료 전년대비 지급현황</td>
	</tr>		
	<tr>
	  <td colspan="5">&nbsp;</td>	  
    </tr>		
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>		
			    <tr>
				  <td width="150" rowspan="3" class="title">보험사</td>
				  <td width="70" rowspan="3" class="title">구분</td>
				  <td width="60" rowspan="3" class="title">차량대수</td>
				  <td width="60" rowspan="3" class="title">총건수</td>	  
				  <td width="90" rowspan="3" class="title">총보험료</td>
				  <td colspan="6" class="title">지급보험료</td>
				  <td colspan="6" class="title">환급보험료</td>
			    </tr>
			    <tr>
				  <td colspan="2" class="title">가입보험료</td>
			      	  <td colspan="2" class="title">변경가입보험료</td>
			      	  <td colspan="2" class="title">소계</td>
			      	  <td colspan="2" class="title">해지보험료</td>
			      	  <td colspan="2" class="title">변경환급보험료</td>
			      	  <td colspan="2" class="title">소계</td>
			    </tr>
			    <tr>
				  <td width="40" class="title">건수</td>
				  <td width="90" class="title">금액</td>
				  <td width="40" class="title">건수</td>
				  <td width="90" class="title">금액</td>
				  <td width="40" class="title">건수</td>
				  <td width="90" class="title">금액</td>
				  <td width="40" class="title">건수</td>
				  <td width="90" class="title">금액</td>
				  <td width="40" class="title">건수</td>
				  <td width="90" class="title">금액</td>
				  <td width="40" class="title">건수</td>
				  <td width="90" class="title">금액</td>
			    </tr>
			    <%	for(int i = 0 ; i < vt_size ; i++){%>
			    <tr>
				  <td align="center"><%=ins_com_nm[i]%></td>
				  <td align="center"><%=car_use[i]%></td>
				  <td align="right"><%=t_cnt[i]%></td>
				  <td align="right"><%=t1[i]%></td>	  
				  <td align="right"><%=Util.parseDecimal(t2[i])%></td>
				  <td align="right"><%=cnt1[i]%></td>
				  <td align="right"><%=Util.parseDecimal(amt1[i])%></td>
				  <td align="right"><%=cnt3[i]%></td>
				  <td align="right"><%=Util.parseDecimal(amt3[i])%></td>
				  <td align="right"><%=t3[i]%></td>	  
				  <td align="right"><%=Util.parseDecimal(t4[i])%></td>
				  <td align="right"><%=cnt4[i]%></td>
				  <td align="right"><%=Util.parseDecimal(amt4[i])%></td>
				  <td align="right"><%=cnt5[i]%></td>
				  <td align="right"><%=Util.parseDecimal(amt5[i])%></td>
				  <td align="right"><%=t5[i]%></td>	  
				  <td align="right"><%=Util.parseDecimal(t6[i])%></td>
			    </tr>
			    <%	}%>
			</table>
		</td>
	</tr>
  </table>
</form>
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
