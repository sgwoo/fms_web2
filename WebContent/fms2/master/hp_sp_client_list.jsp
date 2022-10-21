<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_var 	= request.getParameter("s_var")==null?"":request.getParameter("s_var");
	
	String vid1[] 	= request.getParameterValues("gubun1");
	String vid2[] 	= request.getParameterValues("gubun2");
	String vid3[] 	= request.getParameterValues("gubun3");
	
	String gubun1 = "";
	String gubun2 = "";
	String gubun3 = "";
	
	if(s_var.equals("일반대기업")){
		gubun1 = vid1[0]==null?"":vid1[0];
		gubun2 = vid2[0]==null?"":vid2[0];
		gubun3 = vid3[0]==null?"":vid3[0];
	}else if(s_var.equals("중견기업")){
		gubun1 = vid1[1]==null?"":vid1[1];
		gubun2 = vid2[1]==null?"":vid2[1];
		gubun3 = vid3[1]==null?"":vid3[1];
	}else if(s_var.equals("금융권")){
		gubun1 = vid1[2]==null?"":vid1[2];
		gubun2 = vid2[2]==null?"":vid2[2];
		gubun3 = vid3[2]==null?"":vid3[2];
	}else if(s_var.equals("외국계기업")){
		gubun1 = vid1[3]==null?"":vid1[3];
		gubun2 = vid2[3]==null?"":vid2[3];
		gubun3 = vid3[3]==null?"":vid3[3];
	}else if(s_var.equals("벤처,IT기업")){
		gubun1 = vid1[4]==null?"":vid1[4];
		gubun2 = vid2[4]==null?"":vid2[4];
		gubun3 = vid3[4]==null?"":vid3[4];
	}
	
	Vector vt = ad_db.getHpSpClientList(s_var, gubun1, gubun2, gubun3);
	int vt_size = vt.size();
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
  <input type='hidden' name='s_var' value='<%=s_var%>'>
  <table border="0" cellspacing="1" cellpadding="0" width=1370>
	<tr>
	  <td colspan="5" align="center"><%=s_var%></td>
	</tr>		
	<tr>
	  <td>&nbsp;</td>	  
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>	  
	  <td>&nbsp;</td>
	</tr>	
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>		
				<tr>
				  <td width="50" class="title">연번</td>
				  <td width="300" class="title">상호</td>
				  <td width="70" class="title">거래건수</td>
				  <td width="150" class="title">대표이사</td>
				  <td width="200" class="title">업태</td>
				  <td width="200" class="title">종목</td>
				  <td width="80" class="title">자산총액</td>
				  <td width="80" class="title">자본금</td>
				  <td width="80" class="title">자본총계</td>
				  <td width="80" class="title">매출</td>
				  <td width="80" class="title">당기순이익</td>
				</tr>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);%>
				<tr>
				  <td class="title"><%=i+1%></td>
				  <td align="center"><%=ht.get("FIRM_NM")%></td>
				  <td align="center"><%=ht.get("CNT")%></td>
				  <td align="center"><%=ht.get("CLIENT_NM")%></td>				  
				  <td align="center"><%=ht.get("BUS_CDT")%></td>				  
				  <td align="center"><%=ht.get("BUS_ITM")%></td>
				  <td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("C_ASSET_TOT")))%></td>
				  <td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("C_CAP")))%></td>
				  <td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("C_CAP_TOT")))%></td>
				  <td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("C_SALE")))%></td>
				  <td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("C_PROFIT")))%></td>				  
				</tr>
				<%	}%>
			</table>
		</td>
	</tr>
  </table>
</form>
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
