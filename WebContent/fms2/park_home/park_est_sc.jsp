<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.parking.*"%>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>

<%
String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
String park_id = request.getParameter("park_id")==null?"1":request.getParameter("park_id");
String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

String sort = request.getParameter("sort")==null?"":request.getParameter("sort");

	Vector vt = pk_db.getParkWashEstList();
	int vt_size = vt.size();		
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>

function ParkWashReg(rent_l_cd) {
	var SUBWIN="park_w_i3.jsp?s_kd=5&rent_l_cd="+rent_l_cd;
	window.open(SUBWIN, "ParkInReg", "left=10, top=20, width=1200, height=220, scrollbars=no");
}

</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' method='post'>
	<table border="0" cellspacing="0" cellpadding="0" width=100%>
	    <tr>
		    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>재리스/월렌트 출고예정현황</span></td>
		</tr>
		<tr><td class=line2></td></tr>
	    <tr>
	        <td class="line" >
		        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
	                <tr>
	                    <td width='5%' class='title'>연번</td>
	                    <td width='10%' class='title'>차량번호</td>
	                    <td width='20%' class='title'>차명</td>
	                    <td width='10%' class='title'>계약구분</td>
	                    <td width='15%' class='title'>계약번호</td>
	                    <td width='10%' class='title'>계약일자</td>
	                    <td width='10%' class='title'>차량인도예정일</td>
	                    <td width='10%' class='title'>대여개시일</td>
	                    <td width='5%' class='title'>최초영업자</td>
	                    <td width='5%' class='title'>작업지시서</td>
	                </tr>
	                <%	if( vt_size > 0) {
							for(int i = 0 ; i < vt_size ; i++) {
								Hashtable ht = (Hashtable)vt.elementAt(i);
						%>
			                <tr>
			                	<td align="center"><%=i+1%></td>
			                	<td align="center"><%=ht.get("CAR_NO")%></td>
			                	<td align="center"><%=ht.get("CAR_NM")%></td>
			                	<td align="center"><%=ht.get("CAR_ST")%></td>
			                	<td align="center"><%=ht.get("RENT_L_CD")%></td>
			                	<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
			                	<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CAR_DELI_EST_DT")))%></td>
			                	<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
			                	<td align="center"><%=ht.get("USER_NM")%></td>
			                	<td align="center">
			                	<!-- 	<a href="javascript:ParkWashReg('<%=ht.get("RENT_L_CD")%>');" align="center"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0"></a> -->
			                	</td>
			                </tr>
			        	<%}%>
	                <%} else {%>
	                <tr>
	                	<td colspan="10" align="center">데이터가 없습니다.</td>
	                </tr>
	                <%}%>	
	            </table>
		    </td>
	    </tr>
	</table>
</form>
</body>
</html>
