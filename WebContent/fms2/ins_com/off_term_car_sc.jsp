<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import = "acar.util.*, acar.offls_actn.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String dt		= request.getParameter("dt")==null?"4":request.getParameter("dt");
	
  String sDate = c_db.addMonth(AddUtil.getDate(), -1);
  int kDay=0;
  kDay= AddUtil.getMonthDate(Integer.parseInt(sDate.substring(0,4)),Integer.parseInt(sDate.substring(5,7)));
	String sMonth = sDate.substring(5,7);
  sDate = sDate.substring(0,8)+kDay;
  
	String ref_dt1 	= request.getParameter("ref_dt1")==null?sDate.substring(0,4)+"-01-01":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?sDate:request.getParameter("ref_dt2");
	String s_au = request.getParameter("s_au")==null?"":request.getParameter("s_au");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="javascript">

</script>
</head>
<body leftmargin="15">

<form name='form1' method='post' target='d_content' action=''>

<table border="0" cellspacing="0" cellpadding="0" width=100%>	
	<tr>
		<td>			
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                    <td> <iframe src="/fms2/off_demand/off_term_car_sc_in.jsp?auth_rw=<%=auth_rw%>&brch_id=<%=brch_id%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&s_au=<%=s_au%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
                </tr>
            </table>
		</td>
	</tr>
	<tr>
		<td>※ 보험대차, 휴차료는 포함 안됨</td>
	</tr>

</table>
</form>
</body>
</html>