<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import = "acar.util.*, acar.offls_actn.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	String dt		= request.getParameter("dt")==null?"3":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String s_au = request.getParameter("s_au")==null?"":request.getParameter("s_au");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-70;//현황 라인수만큼 제한 아이프레임 사이즈
	
	
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="javascript">
function view_detail(auth_rw,car_mng_id,seq)
{
	var url = "?auth_rw="+auth_rw+"&car_mng_id=" + car_mng_id + "&seq="+seq;
	parent.location.href ="./off_ls_jh_sc_in_detail_frame.jsp"+url;
}

function view_detail_s(auth_rw,car_mng_id,seq)
{
	var SUBWIN= "off_ls_info.jsp?auth_rw="+auth_rw+"&car_mng_id="+car_mng_id+"&seq="+seq;
	window.open(SUBWIN, "View_OFFLS", "left=50, top=50, width=400, height=730, resizable=yes, scrollbars=yes");
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
                    <td> <iframe src="./off_ls_jh_sc_in.jsp?auth_rw=<%=auth_rw%>&brch_id=<%=brch_id%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&s_au=<%=s_au%>&sh_height=<%=height%>&height=<%=height%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
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