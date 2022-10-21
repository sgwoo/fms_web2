<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc_kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=promotion_excel_list.xls");
%>

<%@ page import="java.util.*, acar.util.*, acar.user_mng.*,acar.common.*, acar.insa_card.*" %>
<jsp:useBean id="ic_db" scope="page" class="acar.insa_card.InsaCardDatabase"/>

<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr"><!--엑셀로 export시 한글깨짐 현상 방지-->
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<BODY>

<%
	//사용자별 정보 조회 및 수정 페이지
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	LoginBean login = LoginBean.getInstance();
	
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String basic_dt 	= request.getParameter("basic_dt")==null?"":request.getParameter("basic_dt");

	String acar_id = login.getCookieValue(request, "acar_id");
			
	if(basic_dt.equals("")){
		 basic_dt = AddUtil.getDate(1)+"0101";
	}
	

	//사용자 정보 조회
	Vector vt = ic_db.Insa_promotion(basic_dt);
	int vt_size = vt.size();
	
	
%>



<table border="0" cellspacing="0" cellpadding="1" width='100%' bordercolor="#000000">
	<tr> 
        <td class=></td>            
    </tr>
	<tr> 
        <td>진급자현황</td>
    </tr>
    <tr> 
        <td class=></td>            
    </tr>
	<tr> 
        <td class=></td>            
    </tr>
	<tr>
		<td class=line>
			<table border="1" cellspacing="0" cellpadding="1" width='100%' bordercolor="#000000">
				<tr>
					<td rowspan="3" colspan="1" class="title">연번</td>
					<td rowspan="3" colspan="1" class="title">부서명</td>
					<td rowspan="3" colspan="1" class="title">성명</td>
					<td rowspan="3" colspan="1" class="title">나이</td>
					<td rowspan="3" colspan="1" class="title">입사일자</td>
					<td rowspan="1" colspan="2" class="title">재직기간</td>
					<td rowspan="1" colspan="4" class="title">현재직급</td>
					<td rowspan="1" colspan="2" class="title">진급(심사)대상직급</td>
				</tr>
				<tr>
					<td rowspan="2" colspan="1" class="title">년</td>
					<td rowspan="2" colspan="1" class="title">월</td>
					<td rowspan="2" colspan="1" class="title">직급</td>
					<td rowspan="2" colspan="1" class="title">발령일자</td>
					<td rowspan="1" colspan="2" class="title">발령후 경과기간</td>
					<td rowspan="2" colspan="1" class="title">심사직급</td>
					<td rowspan="2" colspan="1" class="title">심사결과</td>
				</tr>
				<tr>
					<td class="title">년</td>
					<td class="title">월</td>
				</tr>
<%// if(vt_size > 0)	{
	int count =0;
	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
		
			count++;
%> 						
				<tr>
					<td align="center"><%=count%></td>
					<td align="center"><%=ht.get("DEPT_NM")%></td>
					<td align="center"><%=ht.get("USER_NM")%></td>
					<td align="center"><%=ht.get("AGE")%>세 <%=ht.get("AGE_MONTH")%>월</td>
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%></td>
					<td align="center"><%=ht.get("YEAR")%></td>
					<td align="center"><%=ht.get("MONTH")%></td>
					<td align="center"><%=ht.get("USER_POS")%></td>
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("JG_DT")))%></td>
					<td align="center"><%=ht.get("J_YEAR")%></td>
					<td align="center"><%=ht.get("J_MONTH")%></td>
					<td align="center"><%=ht.get("NEXT_POS")%></td>
					<td align="center"></td>
				</tr>
<%}%>
			</table>
		</td>
	</tr>
    <tr> 
        <td class=></td>
    </tr>
	<tr>
		<td>※ 진급축하금지급 : 일금 20만원 <br>※ 진급조건 최소연령기준은 만 30세 이상</td>
	</tr>
</table>



</BODY>

</HTML>

