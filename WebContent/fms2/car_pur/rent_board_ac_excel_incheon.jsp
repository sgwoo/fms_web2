<%//@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=rent_board_ac_excel_incheon.xls");
%>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String vid[] 	= request.getParameterValues("ch_cd");
	int vid_size = vid.length;
	
	String vid_num		= "";
	String rent_mng_id 	= "";
	String rent_l_cd 	= "";
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	
	//인천지점
	Hashtable br = c_db.getBranch("I1");
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<body>
<% int col_cnt = 31;%>
<table border="0" cellspacing="0" cellpadding="0" width=1970>
  <tr>
	  <td colspan='<%=col_cnt%>' align='center' style="font-size : 20pt;" height="50">(주)아마존카 자동차 신규등록 신청 리스트 (<%=AddUtil.getDate()%>)</td>
	</tr>
  <tr>
	  <td colspan='<%=col_cnt%>' height="20"></td>
	</tr>
</table>
<table border="1" cellspacing="0" cellpadding="0" width=1870>
	<tr>
    <td colspan="13" align='center' style="font-size : 15pt;" height="40">제원정보 입력</td>
    <td colspan="9" align='center' style="font-size : 15pt;">대행사 입력</td>
		<td colspan="8" align='center' style="font-size : 15pt;">기타입력</td>
  </tr>
  <tr>
    <td colspan="2"  align='center' style="font-size : 8pt;" height="30">구분</td>
    <td colspan="3"  align='center' style="font-size : 8pt;">소유자정보</td>
    <td colspan="6" align='center' style="font-size : 8pt;">제작증정보</td>
    <td colspan="2" align='center' style="font-size : 8pt;">수입차정보</td>
    <td align='center' style="font-size : 8pt;">보험</td>
	  <td align='center' style="font-size : 8pt;">채권</td>
	  <td colspan="3" align='center' style="font-size : 8pt;">특이사항</td>
    <td colspan="4" align='center' style="font-size : 8pt;">공동소유</td>
    <td align='center' style="font-size : 8pt;">차량번호</td>
    <td align='center' style="font-size : 8pt;" colspan='2'>자산양수차량</td>
	  <td colspan="3" align='center' style="font-size : 8pt;">취득자정보(금융)</td>
    <td colspan="2" align='center' style="font-size : 8pt;">배출가스 및 소음인증</td>
    <td rowspan='2' align='center' style="font-size : 8pt;">배송지역</td>
  </tr>
  <tr>
		<td width='30' align='center' style="font-size : 8pt;">연번</td>
		<td width='30' align='center' style="font-size : 8pt;">구분</td>
		<td width='70' align='center' style="font-size : 8pt;">소유자명</td>
	  <td width='60' align='center' style="font-size : 8pt;">법인번호</td>
	  <td width='150' align='center' style="font-size : 8pt;">사용본거지</td>
	  <td width='50' align='center' style="font-size : 8pt;">제작증발행일</td>
	  <td width='100' align='center' style="font-size : 8pt;">차명</td>
	  <td width='50' align='center' style="font-size : 8pt;">원동기형식</td>
	  <td width='100' align='center' style="font-size : 8pt;">차대번호</td>
	  <td width='60' align='center' style="font-size : 8pt;">제원관리번호</td>
	  <td width='80' align='center' style="font-size : 8pt;">공급가액</td>
	  <td width='60' align='center' style="font-size : 8pt;">수입신고번호</td>
	  <td width='60' align='center' style="font-size : 8pt;">수입신고일</td>
	  <td width='60' align='center' style="font-size : 8pt;">계약번호</td>
	  <td width='60' align='center' style="font-size : 8pt;">채권할인</td>
	  <td width='50' align='center' style="font-size : 8pt;">감면</td>
	  <td width='60' align='center' style="font-size : 8pt;">임판번호</td>
	  <td width='60' align='center' style="font-size : 8pt;">번호판특이사항</td>
	  <td width='50' align='center' style="font-size : 8pt;">공동소유자</td>
	  <td width='50' align='center' style="font-size : 8pt;">주민번호</td>
	  <td width='50' align='center' style="font-size : 8pt;">주소</td>
	  <td width='50' align='center' style="font-size : 8pt;">지분율</td>
	  <td width='80' align='center' style="font-size : 8pt;">렌터카부여번호</td>
    <td width='80' align='center' style="font-size : 8pt;">주행거리</td>
    <td width='80' align='center' style="font-size : 8pt;">잔금지급일</td>
	  <td width='70' align='center' style="font-size : 8pt;">취득자명</td>
	  <td width='60' align='center' style="font-size : 8pt;">법인번호</td>
	  <td width='150' align='center' style="font-size : 8pt;">주소</td>
	  <td width='60' align='center' style="font-size : 8pt;">자동차배출가스인증번호</td>
	  <td width='60' align='center' style="font-size : 8pt;">자동차소음인증번호</td>
	</tr>
	<%	for(int i=0;i < vid_size;i++){
				rent_l_cd = vid[i];
				Hashtable ht = ec_db.getRentBoardSubAcCase(rent_l_cd);
				total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("CAR_AMT")));
	%>
	<tr>
    <td align='center' style="font-size : 8pt;"><%=i+1%></td>
    <td align='center' style="font-size : 8pt;">렌트</td>
    <td align='center' style="font-size : 8pt;">(주)아마존카</td>
    <td align='center' style="font-size : 8pt;">115611-0019610</td>
    <td align='center' style="font-size : 8pt;"><%=br.get("BR_ADDR")%></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"><%=ht.get("CAR_NM")%>&nbsp;<%=ht.get("CAR_NAME")%></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"><%=ht.get("CAR_NUM")%></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='right' style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_AMT")))%></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;">임시운행미발급</td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"><%=ht.get("EST_CAR_NO")%></td>
    <td align='right' style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("SH_KM")))%></td>
    <td align='center' style="font-size : 8pt;"><%=ht.get("PUR_PAY_DT")%></td>
    <td align='center' style="font-size : 8pt;"></td>
		<td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
    <td align='center' style="font-size : 8pt;"></td>
	</tr>
	<%}%>
</table>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>

