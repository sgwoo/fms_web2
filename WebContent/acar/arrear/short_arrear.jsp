<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	if(user_id.equals(""))	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "09", "04", "02");
	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"6":request.getParameter("gubun");
	String s_yy = request.getParameter("s_yy")==null?AddUtil.dateFormat("yyyyMM")+"01":request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?AddUtil.dateFormat("yyyyMMdd"):request.getParameter("s_mm");
	if(user_id.equals("000003")) brch_id="";
	
	int cnt = 2; //검색 라인수
	int sh_height = cnt*sh_line_height;
	
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50-15;//현황 라인수만큼 제한 아이프레임 사이즈
	
	if(height < 50) height = 150;
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//조회
	function Search(){
		var fm = document.form1;
		if(fm.gubun.value == ''){ alert('구분을 선택하십시오'); return;}
		if(fm.s_yy.value == ''){ alert('기간 시작일을 입력하십시오'); fm.s_yy.focus(); return;}		
		if(fm.s_mm.value == ''){ alert('기간 종료일을 입력하십시오'); fm.s_mm.focus(); return;}				
		var i_fm = i_view.form1;
		i_fm.s_yy.value = fm.s_yy.value;
		i_fm.s_mm.value = fm.s_mm.value;		
		i_fm.gubun.value = fm.gubun.value;				
		i_fm.brch_id.value = fm.brch_id.value;				
		i_fm.target='i_view';
		if(fm.gubun.value == '1')		i_fm.action='stat_total_sc_in_view.jsp';		
		if(fm.gubun.value == '2')		i_fm.action='stat_mng_sc_in_view.jsp';		
		if(fm.gubun.value == '3')		i_fm.action='stat_dly_sc_in_view.jsp';		
		if(fm.gubun.value == '4')		i_fm.action='stat_bus_sc_in_view.jsp';								
		if(fm.gubun.value == '5')		i_fm.action='stat_bus_sc_in_view4.jsp';
		if(fm.gubun.value == '6')		i_fm.action='stat_bus_sc_in_view4.jsp';										
		i_fm.submit();				
	}
	
	function OpenHelp(){
		var fm = document.form1;		
		var SUBWIN = "stat_total_help.jsp?auth_rw="+fm.auth_rw.value+"&user_id="+fm.user_id.value+"&br_id="+fm.br_id.value+"&save_dt="+fm.save_dt.value;
		window.open(SUBWIN, "Help", "left=100, top=100, width=600, height=500, scrollbars=yes");
	}	
//-->
</script>
</head>
<body>

<form action="" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
  <table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr> 
      <td width="200"><font color="navy">채권관리 -> 연체관리 -> </font><font color="red">연체현황 </font>
      <td align="right" colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="2">
	  영업소 : 
              <select name='brch_id'>
                <option value='' <%if(brch_id.equals("")){%> selected <%}%>>전체</option>
        <!--        <option value='S1' <%if(brch_id.equals("S1")){%> selected <%}%>>본사</option>
                <option value='B1' <%if(brch_id.equals("B1")){%> selected <%}%>>부산지점</option>
                <option value='D1' <%if(brch_id.equals("D1")){%> selected <%}%>>대전지점</option>				-->
              </select>	 
	  </td>
      <td align="right" width="100">&nbsp;기준:120일 이전&nbsp;</td>
    </tr>	
    <tr> 
      <td colspan="3">&nbsp;</td>
    </tr>		
    <tr> 
      <td colspan="3"><iframe src="./short_arrear_view.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun=<%=gubun%>&s_yy=<%=s_yy%>&s_mm=<%=s_mm%>&brch_id=<%=brch_id%>" name="i_view" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
      </td>
    </tr>
  </table>
</form>
</body>
</html>
