<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.cus0402.*" %>
<jsp:useBean id="cnd" scope="page" class="acar.common.ConditionBean"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"21":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_bus = request.getParameter("s_bus")==null?"":request.getParameter("s_bus");
	String s_brch = request.getParameter("s_brch")==null?"":request.getParameter("s_brch");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	cnd.setGubun1(gubun1);
	cnd.setGubun2(gubun2);
	cnd.setGubun3(gubun3);
	//cnd.setGubun4(gubun4);
	cnd.setSt_dt(st_dt);
	cnd.setEnd_dt(end_dt);
	cnd.setS_kd(s_kd);
	cnd.setT_wd(t_wd);
	cnd.setS_bus(s_bus);
	cnd.setS_brch(s_brch);
	cnd.setSort_gubun(sort_gubun);
	cnd.setAsc(asc);
	//cnd.setIdx(idx);

Cus0402_Database c42_Db = Cus0402_Database.getInstance();
	int[] mdc = c42_Db.getUpChu(cnd);
	float mc_rate = 0.0f, dc_rate = 0.0f;
	if(mdc[1] !=0 )	mc_rate = (float)mdc[2]*100/mdc[1];
	if(mdc[4] !=0 ) dc_rate = (float)mdc[5]*100/mdc[4];
	//int[] mc_dd = c42_Db.getUpChu_dd(cnd);
	//int[] mc_delay = c42_Db.getUpChu_delay(cnd);
	//int[] mc_tot = c42_Db.getUpChu_total(cnd);
/*
	double v_mc = 0d;
	double s_mc = 0d;
	double m_mc = 0d;
	if(mc[0]!=0)	v_mc = (double)(mc[1] * 100 )/ mc[0];
	if(mc[2]!=0)	s_mc = (double)(mc[3] * 100 )/ mc[2];
	if(mc[5]!=0)	m_mc = (double)(mc[6] * 100 )/ mc[5];
	
	

	double v_mc_dd = 0d;
	double s_mc_dd = 0d;
	double m_mc_dd = 0d;	
	if(mc_dd[0]!=0)	v_mc_dd = (double)(mc_dd[1] * 100 )/ mc_dd[0];
	if(mc_dd[2]!=0)	s_mc_dd = (double)(mc_dd[3] * 100 )/ mc_dd[2];
	if(mc_dd[5]!=0)	m_mc_dd = (double)(mc_dd[6] * 100 )/ mc_dd[5];
	
	double v_mc_delay = 0;
	double s_mc_delay = 0;
	double m_mc_delay = 0;	
	if(mc_delay[0]!=0)	v_mc_delay = (double)(mc_delay[1] * 100 )/ mc_delay[0];
	if(mc_delay[2]!=0)	s_mc_delay = (double)(mc_delay[3] * 100 )/ mc_delay[2];
	if(mc_delay[5]!=0)	m_mc_delay = (double)(mc_delay[6] * 100 )/ mc_delay[5];
	
	double v_mc_tot = 0;
	double s_mc_tot = 0;
	double m_mc_tot = 0;	
	if(mc_tot[0]!=0)	v_mc_tot = (double)(mc_tot[1] * 100 )/ mc_tot[0];
	if(mc_tot[2]!=0)	s_mc_tot = (double)(mc_tot[3] * 100 )/ mc_tot[2];
	if(mc_tot[5]!=0)	m_mc_tot = (double)(mc_tot[6] * 100 )/ mc_tot[5];
*/

		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function view_detail(client_id)
{
	var fm = document.form1;
	var url = "?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_bus=<%=s_bus%>&s_brch=<%=s_brch%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>&client_id="+client_id;
	parent.location.href = "/acar/cus0402/cus0402_d_sc_clientinfo.jsp"+url;
}
function list_move(gubun1, gubun2, gubun3)
{
	var fm = document.form1;
	var url = "/acar/cus0402/cus0402_s_frame.jsp?gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3;
	fm.action = url;		
	fm.target = 'd_content';	
	fm.submit();						
}
//-->
</script>
</head>

<body>
<form name="form1" action="" method="post">
<table width="100%" border="0" cellspacing="1" cellpadding="0">
  <tr> 
    <td><iframe src="./cus0402_s_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_bus=<%=s_bus%>&s_brch=<%=s_brch%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>" name="carList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
  </tr>
 
</table>
</form>
</body>
</html>
