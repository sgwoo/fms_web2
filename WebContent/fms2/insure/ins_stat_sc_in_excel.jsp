<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=ins_stat_sc_in_excel.xls");
%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	Vector vt = ai_db.getInsureStatList(s_kd, t_wd, gubun1);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body >
<table border="0" cellspacing="0" cellpadding="0" width='2280'>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='2280'>
			  <tr>
				<td width='40' rowspan="2" class='title'>연번</td>
				<td colspan="5" class='title'>차량사항</td>
				  <td colspan="2" class='title'>&nbsp;</td>
				  <td style="font-size:8pt" width='150' rowspan="2" class='title'>피보험자</td>
				  <td style="font-size:8pt" colspan="7" class='title'>보험가입사항</td>
				  <td style="font-size:8pt" colspan="2" class='title'>보험기간</td>
			      <td style="font-size:8pt" colspan="9" class='title'>보험료</td>				
			  </tr>    
			  <tr>
				<td style="font-size:8pt" width='100' class='title'>차량번호</td>
		        <td style="font-size:8pt" width='80' class='title'>차종소분류</td>
		        <td style="font-size:8pt" width='80' class='title'>현차종코드</td>
		        <td style="font-size:8pt" width='80' class='title'>구차종코드</td>
		        <td style="font-size:8pt" width='150' class='title'>차명</td>
				  <td style="font-size:8pt" width='80' class='title'>최초등록일</td>
				  <td style="font-size:8pt" width='80' class='title'>에어백</td>
				  <td style="font-size:8pt" width='80' class='title'>보험종류</td>
				  <td style="font-size:8pt" width='80' class='title'>가입연령</td>
				  <td style="font-size:8pt" width='80' class='title'>대물</td>
				  <td style="font-size:8pt" width='80' class='title'>자손-사망</td>
				  <td style="font-size:8pt" width='80' class='title'>자손-부상</td>				  
				  <td style="font-size:8pt" width='80' class='title'>자차-차가</td>
			      <td style="font-size:8pt" width='80' class='title'>자차-자기</td>
			      <td style="font-size:8pt" width='80' class='title'>시작일</td>
			      <td style="font-size:8pt" width='80' class='title'>만료일</td>
			      <td style="font-size:8pt" width='80' class='title'>대인배상1</td>
			      <td style="font-size:8pt" width='80' class='title'>대인배상2</td>
			      <td style="font-size:8pt" width='80' class='title'>대물배상</td>
			      <td style="font-size:8pt" width='80' class='title'>자기신체</td>
			      <td style="font-size:8pt" width='80' class='title'>무보험차</td>
			      <td style="font-size:8pt" width='80' class='title'>분담금할증</td>
			      <td style="font-size:7pt" width='80' class='title'>자기차량손해</td>
			      <td style="font-size:8pt" width='80' class='title'>특약</td>
			      <td style="font-size:8pt" width='80' class='title'>총보험료</td>
				
		      </tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='2280'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
				<tr>
					<td style="font-size:8pt"  width='40' align='center'><%=i+1%></td>
					<td style="font-size:8pt"  width='100' align='center'><%=ht.get("차량번호")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("차종소분류")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("현차종코드")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("구차종코드")%></td>
					<td style="font-size:8pt"  width='150' align='center'><span title='<%=ht.get("차명")%>'><%=Util.subData(String.valueOf(ht.get("차명")), 10)%></span></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("최초등록일")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("에어백")%></td>
					<td style="font-size:8pt"  width='150' align='center'><span title='<%=ht.get("피보험자")%>'><%=Util.subData(String.valueOf(ht.get("피보험자")), 10)%></span></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("보험종류")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("연령범위")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("대물배상")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("자기신체사고_사망장애")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("자기신체사고_부상")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("자차차량")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("자차자기부담금")%></td>					
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("보험시작일")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("보험만료일")%></td>										
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("대인1")%></td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("대인2")%></td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("대물")%></td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("자손")%></td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("무보험")%></td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("분담금")%>&nbsp;</td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("자차")%></td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("특약")%></td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("총보험료")%></td>					
				</tr>
<%
		}
%>
			</table>
		</td>
		</tr>
</table>
</body>
</html>
