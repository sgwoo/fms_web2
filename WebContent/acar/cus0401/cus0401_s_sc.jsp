<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.cus0401.*" %>
<jsp:useBean id="cnd" scope="page" class="acar.common.ConditionBean"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"21":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_bus = request.getParameter("s_bus")==null?"":request.getParameter("s_bus");
	String s_brch = request.getParameter("s_brch")==null?"":request.getParameter("s_brch");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	Cus0401_Database c41_Db = Cus0401_Database.getInstance();
//	int[] mdc = c41_Db.getUpChu2();
//	float mc_rate = 0.0f, dc_rate = 0.0f;
//	if(mdc[1] !=0 )	mc_rate = (float)mdc[5]*100/mdc[1];
//	if(mdc[7] !=0 ) dc_rate = (float)mdc[11]*100/mdc[7];	

		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-70;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function view_detail(car_mng_id,rent_mng_id,rent_l_cd)
{
	var fm = document.form1;
	var url = "?car_mng_id="+car_mng_id+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd;
	var url2 = "&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_bus=<%=s_bus%>&s_brch=<%=s_brch%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>";
	parent.location.href = "cus0401_d_sc_carinfo.jsp"+url+url2;
}
function view_client(client_id,cmd)
{
	var fm = document.form1;
	var url = "?client_id="+client_id+"&cmd="+cmd;
	var url2 = "&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_bus=<%=s_bus%>&s_brch=<%=s_brch%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>";
	parent.location.href = "/acar/cus0402/cus0402_d_sc_clientinfo.jsp"+url+url2;
}
function jakup(cmg,rmg,rld){
	var fm = document.form1;
	parent.location.href = "jakup2.jsp?car_mng_id="+cmg+"&rent_mng_id="+rmg+"&rent_l_cd="+rld;
}
	function list_move(gubun1, gubun2, gubun3)
	{
		var fm = document.form1;
		var url = "/acar/cus0401/cus0401_s_frame.jsp?gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4=<%=gubun4%>";
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}
//-->
</script>
</head>

<body>
<table width="100%" border="0" cellspacing="1" cellpadding="0">
  <tr> 
    <td><iframe src="./cus0401_s_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_bus=<%=s_bus%>&s_brch=<%=s_brch%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>" name="carList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
  </tr>

</table>
</body>
</html>
