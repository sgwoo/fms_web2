<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.closeday.*, acar.user_mng.* , acar.doc_settle.*" %>
<jsp:useBean id="cd_db" scope="page" class="acar.closeday.CloseDayDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<%
	
	LoginBean login = LoginBean.getInstance();
	
	
	String acar_id = login.getCookieValue(request, "acar_id");
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_br_id = request.getParameter("s_br_id")==null?"":request.getParameter("s_br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");

	int count = 0;
	
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_step = request.getParameter("doc_step")==null?"":request.getParameter("doc_step");

	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String gubun 	= request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	String gubun3 	= request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "10", "01", "01");
	
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	String req_code  = Long.toString(System.currentTimeMillis());


	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));		
	int year =AddUtil.getDate2(1);
	int seq = request.getParameter("seq")==null?1:Util.parseInt(request.getParameter("seq"));

	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");
	
	String jj_gub = request.getParameter("jj_gub")==null?"":request.getParameter("jj_gub");
	String bs_gub = request.getParameter("bs_gub")==null?"":request.getParameter("bs_gub");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	

	Vector vt = cd_db.CloseDay_List(st_year, st_mon, user_id, gubun, dt, gubun3, ref_dt1, ref_dt2, jj_gub, bs_gub, asc);
	int vt_size = vt.size();
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--


	
//-->
</script>
</head>
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='user_id' value=''>
<input type='hidden' name='doc_no' value=''>
<input type="hidden" name="cmd" value="">	
<table border=0 cellspacing=0 cellpadding=0 width="100%">
	<tr> 
		<td class="line">
			<table border=0 cellspacing=1 width=100%>
	<% if(vt.size()>0){
	for(int i=0; i< vt.size(); i++){
	Hashtable ht = (Hashtable)vt.elementAt(i);
	%>
				<tr>
				    <td align="center" width="10%"><%= i+1 %></td>
				    <td align="center" width="15%"><% if(!ht.get("CHECK_DT").equals("")){%>완료<%}else{%>대기<%}%></td>
				    <td align="center" width="20%"><a href="javascript:parent.view_cont('<%=ht.get("USER_ID")%>','<%=ht.get("DOC_NO")%>')" onMouseOver="window.status=''; return true"><%=ht.get("USER_NM")%></a></td>
				    <td align="center" width="25%"><%= AddUtil.ChangeDate2((String)ht.get("REG_DT")) %></td>
				    <td align="left"   width="30%">&nbsp;<%=Util.subData(String.valueOf(ht.get("CONTENT")),70)%></td>
				</tr>
	<% 	}
	}else{ %>
				<tr> 
	    			<td colspan="5" align="center">사용내역이 없습니다.</td>
				</tr>
	<% } %>
			</table>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe>
</body>
</html>
