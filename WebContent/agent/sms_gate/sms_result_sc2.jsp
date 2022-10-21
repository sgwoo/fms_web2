<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*"%>
<%@ include file="/agent/cookies.jsp" %>
<%

	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String dest_gubun = request.getParameter("dest_gubun")==null?"":request.getParameter("dest_gubun");	
	String rslt_dt = request.getParameter("rslt_dt")==null?"1":request.getParameter("rslt_dt");
	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.ChangeString(request.getParameter("st_dt"));	
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String dest_nm = request.getParameter("dest_nm")==null?"":request.getParameter("dest_nm");	
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");	
	
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language="javascript">

function view_detail(car_mng_id)
{
	var gubun = document.inner.form1.gubun.value;
	var gubun_nm = document.inner.form1.gubun_nm.value;
	var url = "?car_mng_id="+car_mng_id+"&gubun="+gubun+"&gubun_nm="+gubun_nm;
	parent.parent.d_content.location.href ="./off_lease_sc_in_detail_frame.jsp"+url;
}
</script>
</head>
<body>
<form name='form1' method='post' target='d_content' action=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="sms_result_sc_in2.jsp?gubun=<%=gubun%>&dest_gubun=<%=dest_gubun%>&rslt_dt=<%= rslt_dt %>&st_dt=<%= st_dt %>&end_dt=<%= end_dt %>&dest_nm=<%= dest_nm %>&sort=<%= sort %>&sort_gubun=<%= sort_gubun %>" name="inner" width="100%" height="550" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>