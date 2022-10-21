<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	
	Vector vt = ad_db.getInsideReq01(end_dt);
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
  <table border="1" cellspacing="0" cellpadding="0" width=2850>
	<tr>
	  <td colspan="30" align="center">보유차기본정보</td>
	</tr>		
	<tr>
	  <td colspan="30">&nbsp;</td>	  
	</tr>		
	<tr>
	  <td width="50" class="title">연번</td>
	  <td width="100" class="title">계약번호</td>
	  <td width="100" class="title">차명</td>
	  <td width="100" class="title">모델명</td>
	  <td width="100" class="title">차량번호</td>
	  <td width="100" class="title">상호</td>
	  <td width="100" class="title">계약자</td>
	  <td width="100" class="title">차량구분</td>
	  <td width="100" class="title">용도구분</td>
	  <td width="100" class="title">대여구분</td>	  
	  <td width="100" class="title">대여방식</td>
	  <td width="100" class="title">월대여료</td>
	  <td width="100" class="title">대여개시일</td>
	  <td width="100" class="title">대여만료일</td>
	  <td width="100" class="title">차종</td>
	  <td width="100" class="title">배기량</td>
	  <td width="100" class="title">차량가격</td>	  
	  <td width="100" class="title">선택사양금액</td>
	  <td width="100" class="title">선택사양</td>	  
	  <td width="100" class="title">색상금액</td>
	  <td width="100" class="title">색상</td>
	  <td width="100" class="title">탁송료</td>
	  <td width="100" class="title">소비자가합계</td>
	  <td width="100" class="title">구입차가</td>
	  <td width="100" class="title">매출DC</td>
	  <td width="100" class="title">구입가합계</td>	 
	  <td width="100" class="title">출고일</td>
	  <td width="100" class="title">신차등록일</td>	  
	  <td width="100" class="title">연료</td>
	  <td width="100" class="title">예상주행거리</td>	  	   
	</tr>
    </tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
	%>		
	<tr>
	  <td class="title"><%=i+1%></td>
	  <td align="center"><%=ht.get("RENT_L_CD")%></td>
	  <td align="center"><%=ht.get("CAR_NM")%></td>
	  <td align="center"><%=ht.get("CAR_NAME")%></td>
	  <td align="center"><%=ht.get("CAR_NO")%></td>
	  <td align="center"><%=ht.get("FIRM_NM")%></td>
	  <td align="center"><%=ht.get("CLIENT_NM")%></td>
	  <td align="center"><%=ht.get("CAR_GU")%></td>
	  <td align="center"><%=ht.get("CAR_ST")%></td>
	  <td align="center"><%=ht.get("RENT_ST")%></td>
	  <td align="center"><%=ht.get("RENT_WAY")%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%></td>
	  <td align="center"><%=ht.get("RENT_START_DT")%></td>
	  <td align="center"><%=ht.get("RENT_END_DT")%></td>
	  <td align="center"><%=ht.get("CAR_KD")%></td>
	  <td align="center"><%=ht.get("DPM")%></td>	  
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CAR_C_AMT")))%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("OPT_C_AMT")))%></td>
	  <td align="center"><%=ht.get("OPT")%></td>	  
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CLR_C_AMT")))%></td>
	  <td align="center"><%=ht.get("COLO")%></td>	  
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("SD_C_AMT")))%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CAR_CT_AMT")))%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CAR_F_AMT")))%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("DC_C_AMT")))%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CAR_F_AMT")))%></td>
	  <td align="center"><%=ht.get("DLV_DT")%></td>
	  <td align="center"><%=ht.get("INIT_REG_DT")%></td>
	  <td align="center"><%=ht.get("FUEL_KD")%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TODAY_DIST")))%></td>
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
