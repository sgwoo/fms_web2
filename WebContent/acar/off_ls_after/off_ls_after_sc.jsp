<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import = "acar.util.*, acar.offls_after.*"%>
<jsp:useBean id="olfD" class="acar.offls_after.Offls_afterDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String dt = request.getParameter("dt")==null?"cont_dt":request.getParameter("dt");
	String migr_dt = request.getParameter("migr_dt")==null?"":request.getParameter("migr_dt");
	String migr_gu = request.getParameter("migr_gu")==null?"3":request.getParameter("migr_gu");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st");	
	String com_id = request.getParameter("com_id")==null?"":request.getParameter("com_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	
	//int tg[][]  = olfD.getTg(brch_id);
	
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-75;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language="javascript">
function view_detail(auth_rw,car_mng_id,seq)
{
	var gubun = document.inner.form1.gubun.value;
	var gubun_nm = document.inner.form1.gubun_nm.value;
	var url = "?auth_rw="+auth_rw+"&car_mng_id="+car_mng_id+"&seq="+seq+"&gubun="+gubun+"&gubun_nm="+gubun_nm+"&migr_dt=<%= migr_dt %>&st_dt=<%= st_dt %>&end_dt=<%= end_dt %>&car_st=<%= car_st %>&com_id=<%= com_id %>&car_cd=<%= car_cd %>";
	parent.location.href ="./off_ls_after_sc_in_detail_frame.jsp"+url;
}
</script>
</head>
<body leftmargin="15">

<form name='form1' method='post' target='d_content' action=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	
	<tr>
		<td>
			
        <table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
            <td> <iframe src="./off_ls_after_sc_in.jsp?auth_rw=<%=auth_rw%>&brch_id=<%=brch_id%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&dt=<%= dt %>&migr_dt=<%= migr_dt %>&migr_gu=<%= migr_gu %>&st_dt=<%= st_dt %>&end_dt=<%= end_dt %>&car_st=<%= car_st %>&com_id=<%= com_id %>&car_cd=<%= car_cd %>&sh_height=<%=height%>&height=<%=height%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
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