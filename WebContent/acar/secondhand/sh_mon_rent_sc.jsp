<%@ page language="java" import="java.util.*, acar.util.*" contentType="text/html;charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");		
	
	String gubun 		= request.getParameter("gubun")		==null?"":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")	==null?"":request.getParameter("gubun_nm");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String brch_id 		= request.getParameter("brch_id")	==null?"":request.getParameter("brch_id");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String res_yn 		= request.getParameter("res_yn")	==null?"":request.getParameter("res_yn");
	String res_mon_yn	= request.getParameter("res_mon_yn")	==null?"":request.getParameter("res_mon_yn");
	String all_car_yn	= request.getParameter("all_car_yn")	==null?"":request.getParameter("all_car_yn");
	
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language="javascript">

function view_detail(auth_rw,car_mng_id,rent_mng_id,rent_l_cd,jg_code){

	var gubun 	= document.inner.form1.gubun.value;
	var gubun2 	= document.inner.form1.gubun2.value;
	var gubun_nm 	= document.inner.form1.gubun_nm.value;	
	var sort_gubun 	= document.inner.form1.sort_gubun.value;
	
	var url 	= "?auth_rw="+auth_rw+"&car_mng_id="+car_mng_id+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&jg_code="+jg_code;
	
	url = url + "&gubun="+gubun+"&gubun2="+gubun2+"&gubun_nm="+gubun_nm+"&sort_gubun="+sort_gubun;
	
	url = url + "&user_id=<%=user_id%>&br_id=<%=br_id%>&brch_id=<%=brch_id%>&res_yn=<%=res_yn%>&res_mon_yn=<%=res_mon_yn%>&all_car_yn=<%=all_car_yn%>&from_page=/acar/secondhand/sh_mon_rent_sc.jsp&list_from_page=/acar/secondhand/sh_mon_rent_frame.jsp";
	
			
	parent.parent.d_content.location.href ="./secondhand_detail_frame.jsp"+url;
	
}

</script>
</head>
<body leftmargin="10">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="sh_mon_rent_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&brch_id=<%=brch_id%>&gubun=<%=gubun%>&gubun2=<%=gubun2%>&gubun_nm=<%=gubun_nm%>&sort_gubun=<%=sort_gubun%>&res_yn=<%=res_yn%>&res_mon_yn=<%=res_mon_yn%>&all_car_yn=<%=all_car_yn%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>	
</table>
</body>
</html>