<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=car_maint_excel_list2.xls");
%>
<%@ page import="java.util.*, acar.util.*, acar.master_car.*" %>
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
			
	Vector vt = mc_db.getSsmotersComAcarExcelList(gubun3, gubun2, s_kd, st_dt, end_dt, gubun1, t_wd, gubun4);
	int vt_size = vt.size();
	
	String gubun4_nm = "";
	
	 if ( gubun4.equals("011614")) {
    	  gubun4_nm = "차비서";
	 } else	  if ( gubun4.equals("008462")) {
        	  gubun4_nm = "성서현대";	  
    } else {
    	 gubun4_nm = "성수자동차";   
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
  <table border="1" cellspacing="0" cellpadding="0">
	<tr>
	  <td colspan="23" align="center">(주)아마존카 검사 리스트 </td>
	</tr>	
	
	<tr>
	  <td colspan="23" align="center">업체: <%=gubun4_nm%></td>
	</tr>		
			
	<tr>
	  <td class="title">연번</td>
	  <td class="title">구분&nbsp; 차령연장</td>	  
	  <td class="title">등록일자</td>	  	  
	  <td class="title">차량번호</td>
	  <td class="title">차종</td>
	  <td class="title">제조사</td>
	  <td class="title">연식</td>			  
	  <td class="title">연료</td>
	  <td class="title">고객</td>
	  <td class="title">사무실</td>
	  <td class="title">주소</td>
	  <td class="title">차량관리자</td>		 	
	  <td class="title">실운전자</td>
	  <td class="title">대여기간</td>			
	  <td class="title">최초등록일</td>		
	  <td class="title">차령만료일</td>		
	  <td class="title">등록지역</td>
	  <td class="title">대여방식</td>
	  <td class="title">관리담당자</td>			
	  <td class="title">연락처</td>	
	  <td class="title">검사일</td>	
	  <td class="title">종류</td>	
	  <td class="title">검사금액</td>	
			  	  	  	  
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	<tr>
	  <td align="center"><%=i+1%></td>
	  <td align="center"><%if( String.valueOf(ht.get("GUBUN")).equals("1") ){%>의뢰<%}else if (String.valueOf(ht.get("GUBUN")).equals("2") ){%>완료<%}else if (String.valueOf(ht.get("GUBUN")).equals("4") ){%>기타<%}else{ %>취소<%}%>
	  &nbsp;&nbsp;<%=ht.get("AG")%></td>	   
	  <td align="center"><%=ht.get("등록일자")%></td>	  	  
	  <td align="center"><%=ht.get("차량번호")%></td>
	  <td align="center"><%=ht.get("차종")%></td>
	  <td align="center"><%=ht.get("제조사")%></td>
	  <td align="center"><%=ht.get("연식")%></td>
	
	  <td align="center"><%=ht.get("연료")%></td>
	  <td align="center"><%if( String.valueOf(ht.get("CAR_ST")).equals("4") ) {%> (월)<%} else { %>&nbsp;<%} %><%=ht.get("고객")%></td>
	  <td align="center"><%=ht.get("사무실")%></td>
	  <td align="left"><%=ht.get("주소")%></td>
	  <td align="center"><%=ht.get("차량관리자")%></td>
	  <td align="center"><%=ht.get("실운전자")%></td>
	  <td align="center"><%=ht.get("대여기간")%></td>
	  <td align="center"><%=ht.get("최초등록일")%></td>
	  <td align="center"><%=ht.get("차령만료일")%></td>
	  <td align="center"><%=ht.get("등록지역")%></td>	 
	  <td align="center"><%=ht.get("대여방식")%></td>	 
	  <td align="center"><%=ht.get("관리담당자")%></td>
	  <td align="center"><%=ht.get("연락처")%></td>	 
	  <td align="center"><%=ht.get("검사일")%></td>	
	  <td align="center"><%=ht.get("종류")%></td>	
	  <td align="right"><%=AddUtil.parseDecimal(ht.get("검사금액"))%></td>	 
	   
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
