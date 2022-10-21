<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");	
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"all":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"asc":request.getParameter("gubun5");
	String cjgubun = request.getParameter("cjgubun")==null?"all":request.getParameter("cjgubun");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-80;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="javascript">
<!--

function view_detail(auth_rw,car_mng_id)
{
	var gubun = document.inner.form1.gubun.value;
	var gubun_nm = document.inner.form1.gubun_nm.value;
	var url = "?auth_rw="+auth_rw+"&car_mng_id="+car_mng_id+"&gubun="+gubun+"&gubun_nm="+gubun_nm;
	parent.parent.d_content.location.href ="./off_lease_sc_in_detail_frame.jsp"+url;
}
function view_detail_sh(auth_rw,car_mng_id,rent_mng_id,rent_l_cd,jg_code){
	var gubun = document.inner.form1.gubun.value;
	var gubun_nm = document.inner.form1.gubun_nm.value;	
	var url = "?auth_rw="+auth_rw+"&car_mng_id="+car_mng_id+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&jg_code="+jg_code+"&gubun="+gubun+"&gubun_nm="+gubun_nm+"&from_page=off_lease_sc.jsp";
	parent.parent.d_content.location.href ="/acar/secondhand/secondhand_detail_frame.jsp"+url;
}
//-->
</script>
</head>
<body leftmargin="15">

<form name='form1' method='post' target='d_content' action=''>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="off_lease_sc_in.jsp?auth_rw=<%=auth_rw%>&brch_id=<%=brch_id%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&cjgubun=<%=cjgubun%>&sh_height=<%=height%>&height=<%=height%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>	

</table>
</form>
</body>
</html>