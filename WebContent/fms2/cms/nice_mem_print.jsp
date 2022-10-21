<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ai_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

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
<%

	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String period_gubun 	= request.getParameter("period_gubun")==null?"Y":request.getParameter("period_gubun");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");

	//cms.member_user에 고객생성할 데이타 조회하기
	Vector vt = ai_db.getCardNiceMemberCmsList(s_kd, t_wd, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4, gubun5, period_gubun);
	int vt_size = vt.size();
	
	
%>
<form name='form1' method='post'  >

<input type='hidden' name='sh_height' value='74'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>

  <tr>
	<td class='line'>
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>
		<tr>
		  <td width='40' class='title'>연번</td>
		  <td width='100' class='title'>상호</td>
		  <td width='100' class='title'>계약번호</td>
		  <td width='50' class='title'>결제일</td>
		  <td width='90' class='title'>카드사</td>
		  <td width='100' class='title'>생년월일/사업자</td>
		  <td width='130' class='title'>카드번호</td>
		  <td width='100' class='title'>유효기간(yymm)</td>		
		  <td width='100' class='title'>소유주</td>		
		  <td width='80' class='title'>휴대폰</td>	
		  <td width='60' class='title'>전송일</td>		
		  <td width='70' class='title'>처리내역</td>
		  <td width='70' class='title'>처리결과</td>
		  <td width='120' class='title'>메세지</td>
		
		  </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);	
			
				String td_color = "";
				if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = "class='is'";					
					
			%>
		<tr>
		  <td  <%=td_color%> align="center" ><%=i+1%></td>
		  <td  <%=td_color%> >&nbsp;<%=ht.get("FIRM_NM")%></td>		  
		  <td  <%=td_color%> align="center" ><%=ht.get("RENT_L_CD")%></td>		 
		  <td  <%=td_color%> align="center" ><%=ht.get("CMS_DAY")%></td>
		  <td  <%=td_color%> align="center" ><%=ht.get("CMS_BANK")%></td>		 
		  <td  <%=td_color%> align="center" ><%=ht.get("CMS_DEP_SSN")%></td>
		  <td  <%=td_color%> align="center" ><%=ht.get("CARD_NO")%></td>
		  <td  <%=td_color%> align="center" ><%=ht.get("CARD_PRID")%></td>	
		  <td  <%=td_color%> align="center" ><%=ht.get("CLIENT_NM")%></td>		
		  <td  <%=td_color%> align="center" ><%=ht.get("CMS_TEL")%></td>
		  <td  <%=td_color%> align="center" ><%=ht.get("ADATE")%></td>
		  <td  <%=td_color%> align="center" ><%=ht.get("PROSS")%></td>
		  <td  <%=td_color%> align="center" ><%=ht.get("CMS_STATUS")%></td>
		  <td  <%=td_color%> align="center" ><%=ht.get("CMS_MESSAGE")%></td>
		</tr>

<%}%>	
		
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