<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun2 = "";
	
	if(user_id.equals(""))	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
		
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"5":request.getParameter("gubun");
	String s_yy = request.getParameter("s_yy")==null?AddUtil.dateFormat("yyyyMM")+"01":request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?AddUtil.dateFormat("yyyyMMdd"):request.getParameter("s_mm");
	if(user_id.equals("000003")) brch_id="";
	
	int cnt = 3; //검색 라인수
	int sh_height = cnt*sh_line_height  ;
	
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height) - 50;//현황 라인수만큼 제한 아이프레임 사이즈
	
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//조회
	function Search(){
		var fm = document.form1;
		if(fm.gubun.value == ''){ alert('구분을 선택하십시오'); return;}
		
		var i_fm = i_view.form1;
		i_fm.s_yy.value = fm.s_yy.value;
		i_fm.s_mm.value = fm.s_mm.value;		
		i_fm.gubun.value = fm.gubun.value;	
		i_fm.brch_id.value = fm.brch_id.value;	
		i_fm.action = "./stat_asset_in_view.jsp";			
		i_fm.target='i_view';
									
		if(fm.gubun.value == '5')		i_fm.action='stat_asset_in_view.jsp';		
																		
		i_fm.submit();				
	}
	
	function Search2(){
		var fm = document.form1;
		fm.action = "./stat_asset_in_view.jsp";			
		fm.target='i_view';
																			
		fm.submit();				
	}
	
	function OpenHelp(){
		var fm = document.form1;		
		var SUBWIN = "stat_total_help.jsp?auth_rw="+fm.auth_rw.value+"&user_id="+fm.user_id.value+"&br_id="+fm.br_id.value+"&save_dt="+fm.save_dt.value;
		window.open(SUBWIN, "Help", "left=100, top=100, width=600, height=500, resizable=yes, scrollbars=yes, status=yes");
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
<input type='hidden' name='brch_id' value=''>
<input type='hidden' name='height' value='<%=height%>'>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 자산관리 > <span class=style5>자산매각현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    		<td>
        <img src=/acar/images/center/arrow_cj.gif align=absmiddle> 
				<select name="gubun2">
					<option value="" <% if(gubun2.equals("")) out.print("selected"); %>>전체</option>
					<option value="8" <% if(gubun2.equals("8")) out.print("selected"); %>>소형승용(LPG)</option>
					<option value="5" <% if(gubun2.equals("5")) out.print("selected"); %>>중형승용(LPG)</option>
					<option value="4" <% if(gubun2.equals("4")) out.print("selected"); %>>대형승용(LPG)</option>
					<option value="9" <% if(gubun2.equals("9")) out.print("selected"); %>>경승용</option>
					<option value="3" <% if(gubun2.equals("3")) out.print("selected"); %>>소형승용</option>
					<option value="2" <% if(gubun2.equals("2")) out.print("selected"); %>>중형승용</option>
					<option value="1" <% if(gubun2.equals("1")) out.print("selected"); %>>대형승용</option>
					<option value="6" <% if(gubun2.equals("6")) out.print("selected"); %>>RV</option>
					<option value="10" <% if(gubun2.equals("10")) out.print("selected"); %>>승합</option>
					<option value="7" <% if(gubun2.equals("7")) out.print("selected"); %>>화물</option>
					<option value="20" <% if(gubun2.equals("20")) out.print("selected"); %>>수입차</option>
				</select>&nbsp;
				<a href="javascript:Search2()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
				</td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>		
    <tr> 
      <td><iframe src="./stat_asset_in_view.jsp?height=<%=height%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun=<%=gubun%>&brch_id=<%=brch_id%>" name="i_view" width="100%" height="<%=height+10%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
      </td>
    </tr>
  </table>
</form>
</body>
</html>
