<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.cus0403.*" %>
<jsp:useBean id="cnd" scope="session" class="acar.common.ConditionBean"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	cnd.setGubun1(request.getParameter("gubun1")==null?cnd.getGubun1():request.getParameter("gubun1"));
	cnd.setGubun2(request.getParameter("gubun2")==null?"1":request.getParameter("gubun2"));
	cnd.setGubun3(request.getParameter("gubun3")==null?cnd.getGubun3():request.getParameter("gubun3"));
	cnd.setGubun4(request.getParameter("gubun4")==null?cnd.getGubun3():request.getParameter("gubun4"));
	cnd.setSt_dt(request.getParameter("st_dt")==null?cnd.getSt_dt():request.getParameter("st_dt"));
	cnd.setEnd_dt(request.getParameter("end_dt")==null?cnd.getEnd_dt():request.getParameter("end_dt"));
	cnd.setS_kd(request.getParameter("s_kd")==null?cnd.getS_kd():request.getParameter("s_kd"));
	cnd.setT_wd(request.getParameter("t_wd")==null?cnd.getT_wd():request.getParameter("t_wd"));
	cnd.setS_bus(request.getParameter("s_bus")==null?cnd.getS_bus():request.getParameter("s_bus"));
	cnd.setS_brch(request.getParameter("s_brch")==null?cnd.getS_brch():request.getParameter("s_brch"));
	cnd.setSort_gubun(request.getParameter("sort_gubun")==null?cnd.getSort_gubun():request.getParameter("sort_gubun"));
	cnd.setAsc(request.getParameter("asc")==null?cnd.getAsc():request.getParameter("asc"));
	cnd.setIdx(request.getParameter("idx")==null?cnd.getIdx():request.getParameter("idx"));

	Cus0403_Database c43_Db = Cus0403_Database.getInstance();
	int[] mc = c43_Db.getUpChu(cnd);
	int[] mc_dd = c43_Db.getUpChu_dd(cnd);
	int[] mc_delay = c43_Db.getUpChu_delay(cnd);
	int[] mc_tot = c43_Db.getUpChu_total(cnd);

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
//System.out.println("==cus0401_s_sc.jsp==");
System.out.println("gubun2="+cnd.getGubun2());
System.out.println("gubun3="+cnd.getGubun3());
//System.out.println("st_dt="+cnd.getSt_dt());
//System.out.println("end_dt="+cnd.getEnd_dt());
System.out.println("s_kd="+cnd.getS_kd());
//System.out.println("t_wd="+cnd.getT_wd());

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
function view_detail(car_mng_id,rent_mng_id,rent_l_cd,client_id)
{
	var fm = document.form1;
	var url = "?st=cus0403&car_mng_id="+car_mng_id+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&client_id="+client_id;
	parent.location.href = "/acar/car_register/register_frame.jsp"+url;
}
function list_move(gubun1, gubun2, gubun3)
{
	var fm = document.form1;
	var url = "/acar/cus0403/cus0403_s_frame.jsp?gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3;
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
    <td><iframe src="./cus0403_s_sc_in.jsp?" name="carList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
  </tr>
<!--  
  <tr>
      <td class="line"><table width="800" border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td width="160" class='title'>구분</td>
            <td width="160" align="center" class='title'>검사기간</td>
            <td width="160" align="center" class='title'>D-7일</td>
            <td width="160" align="center" class='title'>D-2일</td>
            <td width="160" align="center" class='title'>합계</td>
          </tr>
          <tr> 
            <td  class='title'>예정</td>
            <td  align="center"> <a href="javascript:list_move('23', '1', 'P');" onMouseOver="window.status=''; return true"><%= mc[5] %> 대</a></td>
            <td   align="center"> <a href="javascript:list_move('23', '2', 'P');" onMouseOver="window.status=''; return true"><%= mc_dd[5] %> 대</a></td>
            <td   align="center"> <a href="javascript:list_move('23', '3', 'P');" onMouseOver="window.status=''; return true"><%= mc_delay[5] %> 대</a></td>
            <td  align="center"> <a href="javascript:list_move('23', '5', 'P');" onMouseOver="window.status=''; return true"><%= mc_tot[5] %> 대</a></td>
          </tr>
          <tr> 
            <td  class='title'>실시(검사)</td>
            <td  align="center"><a href="javascript:list_move('23', '1', 'Y');" onMouseOver="window.status=''; return true"><%= mc[6] %> 대</a></td>
            <td   align="center"> <a href="javascript:list_move('23', '2', 'Y');" onMouseOver="window.status=''; return true"><%= mc_dd[6] %> 대</a></td>
            <td   align="center"> <a href="javascript:list_move('23', '3', 'Y');" onMouseOver="window.status=''; return true"><%= mc_delay[6] %> 대</a></td>
            <td  align="center"> <a href="javascript:list_move('23', '5', 'Y');" onMouseOver="window.status=''; return true"><%= mc_tot[6] %> 대</a></td>
          </tr>
          <tr> 
            <td  class='title'>실시율</td>
            <td  align="center"><%= AddUtil.parseDecimal(m_mc) %> %</td>
            <td   align="center"> <%= AddUtil.parseDecimal(m_mc_dd) %> %</td>
            <td   align="center"> <%= AddUtil.parseDecimal(m_mc_delay) %> %</td>
            <td  align="center"> <%= AddUtil.parseDecimal(m_mc_tot) %> %</td>
          </tr>
        </table></td>
  </tr>
 --> 
</table>
</form>
</body>
</html>
