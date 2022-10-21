<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>


<%
	AddForfeitDatabase afdb = AddForfeitDatabase.getInstance();
	
	Vector vt = afdb.getFineCollNoPayList();
	int vt_size = vt.size();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=3400>
    <tr>
        <td>            
            <table border=1 cellspacing=1 width=100%>
			  <tr>
			    <td width="100" rowspan="2" align="center">연번</td>
			    <td width="200" rowspan="2" align="center">청구기관</td>				
			    <td width="100" rowspan="2" align="center">차량번호</td>
			    <td width="200" rowspan="2" align="center">차명</td>
			    <td width="100" rowspan="2" align="center">계약번호</td>
			    <td width="100" rowspan="2" align="center">매각<br>
		        구분</td>
			    <td width="100" rowspan="2" align="center">대여<br>
		        구분</td>
			    <td width="100" rowspan="2" align="center">계약<br>
		        구분</td>
			    <td colspan="3" align="center">장기대여</td>
			    <td colspan="4" align="center">단기대여</td>																																
			    <td width="100" rowspan="2" align="center">최초영업</td>
			    <td width="100" rowspan="2" align="center">영업담당</td>
			    <td width="100" rowspan="2" align="center">관리담당</td>
			    <td width="100" rowspan="2" align="center">업무과실</td>
			    <td width="100" rowspan="2" align="center">위반일자</td>
			    <td width="400" rowspan="2" align="center">위반장소</td>
			    <td width="200" rowspan="2" align="center">위반내용</td>
			    <td width="100" rowspan="2" align="center">납부방식</td>
			    <td width="100" rowspan="2" align="center">고지서접수일</td>
			    <td width="100" rowspan="2" align="center">납부기한일</td>
			    <td width="100" rowspan="2" align="center">수금일</td>
			  </tr>
			  <tr>
			    <td width="200" align="center">고객</td>
		        <td width="100" align="center">대여개시일</td>
		        <td width="100" align="center">대여만료일</td>
			    <td width="100" align="center">구분</td>
			    <td width="200" align="center">사용자</td>
			    <td width="100" align="center">배차일</td>
			    <td width="100" align="center">반차일</td>
			  </tr>
			  <%for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>			  
			  <tr>
			    <td align="center"><%=i+1%></td>
			    <td align="center"><%=ht.get("GOV_NM")%></td>				
			    <td align="center"><%=ht.get("CAR_NO")%></td>
			    <td align="center"><%=ht.get("CAR_NM")%></td>
			    <td align="center"><%=ht.get("RENT_L_CD")%></td>
			    <td align="center"><%=ht.get("SUI_ST")%></td>
			    <td align="center"><%=ht.get("USE_ST")%></td>
			    <td align="center"><%=ht.get("CAR_ST")%></td>
			    <td align="center"><%=ht.get("FIRM_NM")%>&nbsp;</td>
			    <td align="center"><%=ht.get("MIN_DT")%>&nbsp;</td>
			    <td align="center"><%=ht.get("MAX_DT")%>&nbsp;</td>
			    <td align="center"><%=ht.get("RENT_ST")%>&nbsp;</td>
			    <td align="center"><%=ht.get("CUST_NM")%>&nbsp;</td>
			    <td align="center"><%=ht.get("DELI_DT")%>&nbsp;</td>
			    <td align="center"><%=ht.get("RET_DT")%>&nbsp;</td>
			    <td align="center"><%=ht.get("BUS_NM")%></td>
			    <td align="center"><%=ht.get("BUS_NM2")%></td>
			    <td align="center"><%=ht.get("MNG_NM")%>&nbsp;</td>
			    <td align="center"><%=ht.get("FAULT_NM")%>&nbsp;</td>
			    <td align="center"><%=ht.get("VIO_DT")%></td>
		        <td align="center"><%=ht.get("VIO_PLA")%></td>
		        <td align="center"><%=ht.get("VIO_CONT")%></td>
		        <td align="center"><%=ht.get("PAID_ST")%></td>
		        <td align="center"><%=ht.get("REC_DT")%>&nbsp;</td>
		        <td align="center"><%=ht.get("PAID_END_DT")%>&nbsp;</td>
		        <td align="center"><%=ht.get("COLL_DT")%>&nbsp;</td>
			  </tr>
			  <%}%>
          </table>
        </td>
    </tr>
</table>
</body>
</html>