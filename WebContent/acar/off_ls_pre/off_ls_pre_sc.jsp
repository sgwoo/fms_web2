<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import = "acar.util.*, acar.offls_pre.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-110;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language="javascript">
function view_detail(auth_rw,car_mng_id)
{
//alert(car_mng_id);
	var gubun = document.inner.form1.gubun.value;
	var gubun_nm = document.inner.form1.gubun_nm.value;
	var url = "?auth_rw="+auth_rw+"&car_mng_id="+car_mng_id+"&gubun="+gubun+"&gubun_nm="+gubun_nm;
	parent.parent.d_content.location.href ="./off_ls_pre_sc_in_detail_frame.jsp"+url;
}

	//자동차등록정보 보기
	function view_car(m_id, l_cd, c_id)
	{
		window.open("/acar/car_register/car_view.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&car_mng_id="+c_id+"&cmd=ud", "VIEW_CAR", "left=100, top=100, width=850, height=700, scrollbars=yes");
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
            <td><iframe src="./off_ls_pre_sc_in.jsp?auth_rw=<%=auth_rw%>&brch_id=<%=brch_id%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&sh_height=<%=height%>&height=<%=height%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe> 
            </td>
          </tr>
        </table>
		</td>
	</tr>
	<tr>
		<td>* 계약확정 및 상담시에는 리스트에 나타나지 않습니다. 오프리스현황에서 매각결정 취소하십시오.</td>
	</tr>	

</table>
</form>
</body>
</html>