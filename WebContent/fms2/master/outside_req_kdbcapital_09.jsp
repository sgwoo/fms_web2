<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String end_dt 	= request.getParameter("end_dt_09")==null?"":request.getParameter("end_dt_09");
	
	
	Hashtable ht = ad_db.getOutsideReq09(end_dt);
	
	Vector vt = ad_db.getOutsideReq09_2(end_dt);	
	int vt_size = vt.size();	
	
	long sum0 = 0;
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
  <table border="0" cellspacing="1" cellpadding="0" width=850>
	<tr>
	  <td align="right"><%=AddUtil.getDate3(end_dt)%> 현재</td>
	</tr>
	<tr>
	  <td>1. 고객구성</td>
	</tr>		
	<%	sum0 = 0;%>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>		
				<tr>
				  <td width="25%" class="title">구분</td>
				  <td width="25%" class="title">법인</td>
				  <td width="25%" class="title">개인사업자/개인</td>
				  <td width="25%" class="title">비고</td>
				</tr>
				<tr>
				  <td class="title">차량대수</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT1")))%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT2")))%></td>
				  <td align="center">대여대수</td>
				</tr>
				<tr>
				  <td class="title">매출액(백만원)</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(ht.get("AMT1")))/1000000)%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(ht.get("AMT2")))/1000000)%></td>
				  <td align="center">약정월대여료</td>
				</tr>
			</table>
		</td>
	</tr>				
	<%	sum0  = AddUtil.parseLong(String.valueOf(ht.get("CNT1")))+AddUtil.parseLong(String.valueOf(ht.get("CNT2")));%>	
	<!--
	<tr>
		<td>* 대수합계 : <%=sum0%></td>
	</tr>	
	-->
	<tr>
	  <td>2. 유종별 비중</td>
	</tr>		
	<%	sum0 = 0;%>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>		
				<tr>
				  <td width="25%" rowspan='2' class="title">구분</td>
				  <td class="title" colspan='2'>보유대수</td>
				  <td class="title" colspan='2'>장부가격(백만원)</td>
				  <td width="15%" rowspan='2' class="title">비고</td>
				</tr>
				<tr>
				  <td width="15%" class="title">LPG</td>
				  <td width="15%" class="title">가솔린</td>
				  <td width="15%" class="title">LPG</td>
				  <td width="15%" class="title">가솔린</td>
				</tr>				
				<tr>
				  <td class="title">렌트</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT3")))%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT4")))%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(ht.get("AMT3")))/1000000)%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(ht.get("AMT4")))/1000000)%></td>
				  <td align="center"></td>
				</tr>
				<tr>
				  <td class="title">리스</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT5")))%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT6")))%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(ht.get("AMT5")))/1000000)%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(ht.get("AMT6")))/1000000)%></td>
				  <td align="center"></td>
				</tr>
			</table>
		</td>
	</tr>				
	<%	sum0  = AddUtil.parseLong(String.valueOf(ht.get("CNT3")))+AddUtil.parseLong(String.valueOf(ht.get("CNT4")))+AddUtil.parseLong(String.valueOf(ht.get("CNT5")))+AddUtil.parseLong(String.valueOf(ht.get("CNT6")));%>	
	<!--
	<tr>
		<td>* 대수합계 : <%=sum0%></td>
	</tr>	
	-->
	<tr>
	  <td>3. 제조사별</td>
	</tr>		
	<%	sum0 = 0;%>		
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>		
				<tr>
				  <td width="25%" class="title">구분</td>
				  <td width="40%" class="title">대수</td>
				  <td width="35%" class="title">장부가격</td>
				</tr>

				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht2 = (Hashtable)vt.elementAt(i);
						sum0  = sum0  + AddUtil.parseLong(String.valueOf(ht2.get("CNT0")));
			%>
				<tr>
				  <td class="title"><%=ht2.get("NM")%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht2.get("CNT0")))%></td>
				  <td align="center"></td>
				</tr>
				<%	}%>
			</table>
		</td>
	</tr>
	<!--
	<tr>
		<td>* 대수합계 : <%=sum0%></td>
	</tr>
	-->
	<tr>
	  <td>4. 차량종류별</td>
	</tr>		
	<%	sum0 = 0;%>		
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>		
				<tr>
				  <td width="25%" class="title">구분</td>
				  <td width="40%" class="title">대수</td>
				  <td width="35%" class="title">장부가격</td>
				</tr>
				<tr>
				  <td class="title">소형(1500cc이하)</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT7")))%></td>
				  <td align="center"></td>
				</tr>
				<tr>
				  <td class="title">중형(2000cc이하)</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT8")))%></td>
				  <td align="center"></td>
				</tr>
				<tr>
				  <td class="title">대형(2000cc이상)</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT9")))%></td>
				  <td align="center"></td>
				</tr>
				<tr>
				  <td class="title">기타(화물,승합)</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT10")))%></td>
				  <td align="center"></td>
				</tr>
			</table>
		</td>
	</tr>	
	<tr>
	  <td>5. 계약기간별</td>
	</tr>		
	<%	sum0 = 0;%>		
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>		
				<tr>
				  <td width="25%" class="title">구분</td>
				  <td width="75%" class="title">대수</td>
				</tr>
				<tr>
				  <td class="title">12개월</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT11")))%></td>
				</tr>
				<tr>
				  <td class="title">24개월</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT12")))%></td>
				</tr>
				<tr>
				  <td class="title">36개월</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT13")))%></td>
				</tr>
				<tr>
				  <td class="title">48개월</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT14")))%></td>
				</tr>
				<tr>
				  <td class="title">60개월</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT15")))%></td>
				</tr>
				<tr>
				  <td class="title">기타</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT16")))%></td>
				</tr>
			</table>
		</td>
	</tr>		
	<tr>
	  <td>6. 년식별 보유현황</td>
	</tr>		
	<%	sum0 = 0;%>		
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>		
				<tr>
				  <td width="25%" class="title">구분</td>
				  <td width="40%" class="title">보유대수</td>
				  <td width="35%" class="title">장부가격(백만원)</td>
				</tr>
				<%
					int v_year = 0;
					for(int i = AddUtil.parseInt(end_dt.substring(0,4)) ; i >= AddUtil.parseInt(end_dt.substring(0,4))-7 ; i--){
						v_year = i;
				%>
				<tr>
				  <td class="title"><%=v_year%>년식</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT"+v_year)))%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(ht.get("AMT"+v_year)))/1000000)%></td>
				</tr>
				<%}%>
				<tr>
				  <td class="title"><%=v_year%>년이전</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT"+v_year+"B")))%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(ht.get("AMT"+v_year+"B")))/1000000)%></td>
				</tr>
			</table>
		</td>
	</tr>			
  </table>
</form>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
