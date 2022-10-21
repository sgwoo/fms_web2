<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page import="java.util.*, acar.util.*, acar.admin.*,acar.common.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+AddUtil.getDate(4)+"_acar_car_excel_list.xls");
%>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String car_ext 	= request.getParameter("car_ext")==null?"":request.getParameter("car_ext");
	int car_cnt 	= request.getParameter("car_cnt")==null?0:AddUtil.parseDigit(request.getParameter("car_cnt"));
	
//	AdminDatabase ad_db = AdminDatabase.getInstance();
	
	Vector vt = ad_db.getMasterCarComAcarExcelList();
	int vt_size = vt.size();
	
//	if(car_cnt > 0 && vt_size > car_cnt) vt_size = car_cnt;
 	

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
  <table border="1" cellspacing="0" cellpadding="0">
	<tr>
	  <td colspan="33" align="center"><%=c_db.getNameByIdCode("0032", "", car_ext)%> (주)아마존카 보유차량 리스트 <%if(car_cnt>0){%>(<%=car_cnt%>대)<%}%></td>
	</tr>		
	<tr>
	  <td colspan="5" align="right"><%=AddUtil.getDate()%> 기준</td>
	  <td colspan="28">&nbsp;</td>	  
	</tr>			
	<tr>
	  <td class="title">연번</td>
	  <td class="title">구분</td>	  
	  <td class="title">등록일자</td>	  
	  <td class="title">차량번호</td>
	  <td class="title">차종</td>
	  <td class="title">제조사</td>
	  <td class="title">연식</td>			
	  <td class="title">미션</td>				  
	  <td class="title">연료</td>
	  <td class="title">고객</td>
	  <td class="title">사무실</td>
	  <td class="title">휴대폰</td>			
	  <td class="title">주소</td>
	  <td class="title">실운전자</td>
	  <td class="title">보험사</td>
	  <td class="title">대여기간</td>			
	  <td class="title">대인배상Ⅰ</td>
	  <td class="title">대인배상Ⅱ</td>
	  <td class="title">대물배상</td>
	  <td class="title">자기신체사고_사망장애</td>			
	  <td class="title">자기신체사고_부상</td>
	  <td class="title">자차차량</td>
	  <td class="title">자차자기부담금</td>
	  <td class="title">무보험</td>			
	  <td class="title">보험종류</td>
	  <td class="title">연령범위</td>			
	  <td class="title">에어백</td>
	  <td class="title">피보험자</td>			
	  <td class="title">최초등록일</td>	
	  <td class="title">등록지역</td>			
	  <td class="title">대여방식</td>			
	  <td class="title">관리담당자</td>			
	  <td class="title">연락처</td>	
	  
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	<tr>
	  <td align="center"><%=i+1%></td>
	  <td align="center"><%=ht.get("구분")%></td>	  
	  <td align="center"><%=ht.get("등록일자")%></td>	  	
	  <td align="center"><%=ht.get("차량번호")%></td>
	  <td align="center"><%=ht.get("차종")%></td>
	  <td align="center"><%=ht.get("제조사")%></td>
	  <td align="center"><%=ht.get("연식")%></td>
	  <td align="center"><%=ht.get("미션")%></td>	  
	  <td align="center"><%=ht.get("연료")%></td>
	  <td align="center"><%=ht.get("고객")%></td>
	  <td align="center"><%=ht.get("사무실")%></td>
	  <td align="center"><%=ht.get("휴대폰")%></td>
	  <td align="center"><%=ht.get("주소")%></td>
	  <td align="center"><%=ht.get("실운전자")%></td>
	  <td align="center"><%=ht.get("보험사")%></td>
	  <td align="center"><%=ht.get("대여기간")%></td>
	  <td align="center"><%=ht.get("대인배상Ⅰ")%></td>
	  <td align="center"><%=ht.get("대인배상Ⅱ")%></td>
	  <td align="center"><%=ht.get("대물배상")%></td>
	  <td align="center"><%=ht.get("자기신체사고_사망장애")%></td>
	  <td align="center"><%=ht.get("자기신체사고_부상")%></td>
	  <td align="center"><%=ht.get("자차차량")%></td>
	  <td align="center"><%=ht.get("자차자기부담금")%></td>
	  <td align="center"><%=ht.get("무보험")%></td>	  
	  <td align="center"><%=ht.get("보험종류")%></td>
	  <td align="center"><%=ht.get("연령범위")%></td>	  
	  <td align="center"><%=ht.get("에어백")%></td>
	  <td align="center"><%=ht.get("피보험자")%></td>	  
	  <td align="center"><%=ht.get("최초등록일")%></td>
	  <td align="center"><%=ht.get("등록지역")%></td>
	  <td align="center"><%=ht.get("대여방식")%></td>	  
	  <td align="center"><%=ht.get("관리담당자")%></td>
	  <td align="center"><%=ht.get("연락처")%></td>	 
	  
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
