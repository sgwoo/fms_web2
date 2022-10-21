<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String start_dt = request.getParameter("start_dt7")==null?"":AddUtil.replace(request.getParameter("start_dt7"),"-","");
	String end_dt 	= request.getParameter("end_dt7")==null?"":AddUtil.replace(request.getParameter("end_dt7"),"-","");
	
	
	Vector vt = ad_db.getInsideReq07(start_dt, end_dt);
	int vt_size = vt.size();
	
	long sum0 = 0;
	long sum1 = 0;
	long sum2 = 0;
	long sum3 = 0;
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
  <input type='hidden' name='end_dt' value='<%=end_dt%>'>
  <table border="1" cellspacing="0" cellpadding="0" width=2700>
	<tr>
	  <td colspan="27" align="center">연체현황분석표</td>
	</tr>		
	<tr>
	  <td colspan="27">&nbsp;</td>	  
	</tr>		
	<tr>
	  <td width="100" class="title">연번</td>
	  <td width="100" class="title">계약번호</td>
	  <td width="100" class="title">상호</td>
	  <td width="100" class="title">차종</td>
	  <td width="100" class="title">차량가격</td>
	  <td width="100" class="title">차량번호</td>
	  <td width="100" class="title">영업구분</td>
	  <td width="100" class="title">최초영업자</td>
	  <td width="100" class="title">관리담당자</td>
	  <td width="100" class="title">용도구분</td>	  
	  <td width="100" class="title">관리구분</td>
	  <td width="100" class="title">계약기간</td>
	  <td width="100" class="title">크레탑 신용등급</td>
	  <td width="100" class="title">NICE 신용등급</td>
	  <td width="100" class="title">KCB 신용등급</td>
	  <td width="100" class="title">보증금율</td>
	  <td width="100" class="title">선납금율</td>	  
	  <td width="100" class="title">개시대여료율</td>
	  <td width="100" class="title">증권</td>	  
	  <td width="100" class="title">총합</td>
	  <td width="100" class="title">과거 연체일수</td>
	  <td width="100" class="title">과거 연체료</td>
	  <td width="100" class="title">현재 연체일수</td>
	  <td width="100" class="title">현재 연체료</td>
	  <td width="100" class="title">현재 받을어음</td>
	  <td width="100" class="title">현재 미수금액</td>	 
	  <td width="100" class="title">현재 연체율</td>
	</tr>
    </tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
	%>		
	<tr>
	  <td class="title"><%=i+1%></td>
	  <td align="center"><%=ht.get("RENT_L_CD")%></td>
	  <td align="center"><%=ht.get("FIRM_NM")%></td>
	  <td align="center"><%=ht.get("CAR_NM")%></td>
	  <td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("O_1")))%></td>
	  <td align="center"><%=ht.get("CAR_NO")%></td>
	  <td align="center"><%=ht.get("BUS_ST")%></td>
	  <td align="center"><%=ht.get("BUS_NM")%></td>
	  <td align="center"><%=ht.get("BUS_NM2")%></td>
	  <td align="center"><%=ht.get("CAR_ST")%></td>
	  <td align="center"><%=ht.get("RENT_WAY")%></td>
	  <td align="center"><%=ht.get("CON_MON")%></td>
	  <td align="center">
	  	<%
	  		String eval_gr1 = "";
	  		if(eval_gr1.equals("") && String.valueOf(ht.get("EVAL_OFF1")).equals("크레탑")){ eval_gr1 = String.valueOf(ht.get("EVAL_GR1"));	}
	  		if(eval_gr1.equals("") && String.valueOf(ht.get("EVAL_OFF2")).equals("크레탑")){ eval_gr1 = String.valueOf(ht.get("EVAL_GR2"));	}
	  		if(eval_gr1.equals("") && String.valueOf(ht.get("EVAL_OFF3")).equals("크레탑")){ eval_gr1 = String.valueOf(ht.get("EVAL_GR3"));	}
	  		if(eval_gr1.equals("") && String.valueOf(ht.get("EVAL_OFF4")).equals("크레탑")){ eval_gr1 = String.valueOf(ht.get("EVAL_GR4"));	}
	  		if(eval_gr1.equals("") && String.valueOf(ht.get("EVAL_OFF5")).equals("크레탑")){ eval_gr1 = String.valueOf(ht.get("EVAL_GR5"));	}
	  	%>
	  	<%=eval_gr1%>
	  </td>
	  <td align="center">
	  	<%
	  		String eval_gr2 = "";
	  		if(eval_gr2.equals("") && String.valueOf(ht.get("EVAL_OFF1")).equals("NICE")){ eval_gr2 = String.valueOf(ht.get("EVAL_GR1"));	}
	  		if(eval_gr2.equals("") && String.valueOf(ht.get("EVAL_OFF2")).equals("NICE")){ eval_gr2 = String.valueOf(ht.get("EVAL_GR2"));	}
	  		if(eval_gr2.equals("") && String.valueOf(ht.get("EVAL_OFF3")).equals("NICE")){ eval_gr2 = String.valueOf(ht.get("EVAL_GR3"));	}
	  		if(eval_gr2.equals("") && String.valueOf(ht.get("EVAL_OFF4")).equals("NICE")){ eval_gr2 = String.valueOf(ht.get("EVAL_GR4"));	}
	  		if(eval_gr2.equals("") && String.valueOf(ht.get("EVAL_OFF5")).equals("NICE")){ eval_gr2 = String.valueOf(ht.get("EVAL_GR5"));	}
	  	%>
	  	<%=eval_gr2%>
	  </td>
	  <td align="center">
	  	<%
	  		String eval_gr3 = "";
	  		if(eval_gr3.equals("") && String.valueOf(ht.get("EVAL_OFF1")).equals("KCB")){ eval_gr3 = String.valueOf(ht.get("EVAL_GR1"));	}
	  		if(eval_gr3.equals("") && String.valueOf(ht.get("EVAL_OFF2")).equals("KCB")){ eval_gr3 = String.valueOf(ht.get("EVAL_GR2"));	}
	  		if(eval_gr3.equals("") && String.valueOf(ht.get("EVAL_OFF3")).equals("KCB")){ eval_gr3 = String.valueOf(ht.get("EVAL_GR3"));	}
	  		if(eval_gr3.equals("") && String.valueOf(ht.get("EVAL_OFF4")).equals("KCB")){ eval_gr3 = String.valueOf(ht.get("EVAL_GR4"));	}
	  		if(eval_gr3.equals("") && String.valueOf(ht.get("EVAL_OFF5")).equals("KCB")){ eval_gr3 = String.valueOf(ht.get("EVAL_GR5"));	}
	  	%>
	  	<%=eval_gr3%>
	  </td>	  
	  <td align="center"><%=ht.get("GUR_P_PER")%>%</td>
	  <td align="center"><%=ht.get("PERE_R_PER")%>%</td>
	  <td align="center"><%=ht.get("IFEE_PER")%>%</td>
	  <td align="center"><%=ht.get("GI_PER")%>%</td>	  
	  <td align="right"><%=AddUtil.parseFloat(String.valueOf(ht.get("GUR_P_PER")))+AddUtil.parseFloat(String.valueOf(ht.get("PERE_R_PER")))+AddUtil.parseFloat(String.valueOf(ht.get("IFEE_PER")))+AddUtil.parseFloat(String.valueOf(ht.get("GI_PER")))%>%</td>
	  <td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("O_DLY_DAYS")))%></td>
	  <td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("O_DLY_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("N_DLY_DAYS")))%></td>
	  <td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("N_DLY_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("T_FEE_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("DLY_FEE_AMT")))%></td>
	  <td align="center"><%=ht.get("DLY_PER")%>%</td>
	</tr>
	<%	}%>
  </table>
</form>
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
