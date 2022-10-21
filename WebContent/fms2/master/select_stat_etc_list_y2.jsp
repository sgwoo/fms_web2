<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String settle_year 	= request.getParameter("settle_year")==null?"":request.getParameter("settle_year");
	String table_width	= request.getParameter("table_width")==null?"":request.getParameter("table_width");
	
	
	//스캔파일 업로드 현황
	Vector vt = ad_db.getSelectStatEtc_list_y2(settle_year);
	int vt_size = vt.size();
	
	long total_amt1[]	 		= new long[13];
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
//세부리스트
function view_stat(content_code, settle_month){
	window.open('select_stat_etc_list_y2_sub_list.jsp?settle_year=<%=settle_year%>&content_code='+content_code+'&settle_month='+settle_month, "STAT_LIST", "left=300, top=20, width=950, height=800, scrollbars=yes, status=yes, resize");
}
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
  <table border="0" cellspacing="1" cellpadding="0" width=<%=table_width%>>
	<tr>
	  <td colspan="5" align="center"><%=AddUtil.parseInt(settle_year)%>년 스캔파일 현황</td>
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
				  <td width="170" class="title">구분</td>
				  <td width="60" class="title">합계</td>
				  <%for (int j = 0 ; j < 12 ; j++){%>
                  <td width="60" class=title><%=j+1%>월</td>
				  <%}%>				  
			    </tr>			    	    
			    <%	for(int i = 0 ; i < vt_size ; i++){
    					Hashtable ht = (Hashtable)vt.elementAt(i);	
    					
    					for(int j = 0 ; j < 13 ; j++){
							if( j == 0 ){
								total_amt1[j]	= total_amt1[j] + AddUtil.parseLong(String.valueOf(ht.get("CNT")));
							}else{
								total_amt1[j]	= total_amt1[j] + AddUtil.parseLong(String.valueOf(ht.get("CNT_"+j)));
							}
						}
				%>
			    <tr>
				  <td class="title"><%=i+1%></td>
				  <td align="center"><%=ht.get("CONTENT_CODE")%></td>
				  <td align="right"><%=ht.get("CNT")%></td>
				  <%for(int j = 1 ; j <= 12 ; j++){ %>
				  <td align="right"><a href="javascript:view_stat('<%=ht.get("CONTENT_CODE")%>','<%=AddUtil.addZero2(j)%>')"><%=ht.get("CNT_"+j)%></a></td>
				  <%} %>
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


