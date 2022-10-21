<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String settle_year 	= request.getParameter("settle_year")==null?"":request.getParameter("settle_year");
	String content_code	= request.getParameter("content_code")==null?"":request.getParameter("content_code");
	String settle_month	= request.getParameter("settle_month")==null?"":request.getParameter("settle_month");
	
	
	//스캔파일 업로드 현황
	Vector vt = ad_db.getSelectStatEtc_list_y2_sublist(content_code, settle_year, settle_month);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
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
  <input type='hidden' name='settle_year' value='<%=settle_year%>'>
  <table border="0" cellspacing="1" cellpadding="0" width=900>
	<tr>
	  <td colspan="5" align="center"><%=AddUtil.parseInt(settle_year)%>년<%=AddUtil.parseInt(settle_month)%>월 <%=content_code%> 스캔파일 현황</td>
	</tr>		
	<tr>
	  <td colspan="5">&nbsp;</td>	  
    </tr>		
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
			    <tr>
			      <td width="50" class="title">연번</td>
				  <td width="450" class="title">파일명</td>
				  <td width="100" class="title">파일사이즈</td>
				  <td width="100" class="title">등록자</td>
				  <td width="150" class="title">등록일자</td>
				  <td width="50" class="title">보기</td>				  
			    </tr>			    	    
			    <%	for(int i = 0 ; i < vt_size ; i++){
    					Hashtable ht = (Hashtable)vt.elementAt(i);	    					    					
				%>
			    <tr>
				  <td class="title"><%=i+1%></td>
				  <td align="center"><%=ht.get("FILE_NAME")%></td>
				  <td align="right"><%=ht.get("FILE_SIZE")%></td>
				  <td align="center"><%=ht.get("USER_NM")%></td>
				  <td align="center"><%=ht.get("REG_DATE")%></td>
				  <td align="center">
				     <%if(ht.get("FILE_TYPE").equals("image/jpeg")||ht.get("FILE_TYPE").equals("image/pjpeg")||ht.get("FILE_TYPE").equals("application/pdf")){%>			
					 <a href="javascript:openPopF('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
					 <%}else{%>
					 <a href="https://fms3.amazoncar.co.kr/fms2/attach/download.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
					 <%}%>
				  </td>				  
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


