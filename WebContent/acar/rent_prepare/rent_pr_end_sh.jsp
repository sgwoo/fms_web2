<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	int s_year = request.getParameter("s_year")==null?0:Util.parseDigit(request.getParameter("s_year"));
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"1":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;		
		if(fm.s_kd.value == '2'){
			fm.t_wd.value = ChangeDate3(fm.t_wd.value);
		}
		fm.action = 'rent_pr_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
		
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	
	
	//리스트 이동
	function list_move()
	{
		var fm = document.form1;
		var url = "";
		var idx = fm.gubun1.options[fm.gubun1.selectedIndex].value;
		if(idx == '1') 		url = "/acar/res_search/res_se_frame_s.jsp";
		else if(idx == '2') url = "/acar/res_stat/res_st_frame_s.jsp";
		else if(idx == '3') url = "/acar/rent_mng/rent_mn_frame_s.jsp";
		else if(idx == '4') url = "/acar/rent_settle/rent_se_frame_s.jsp";
		else if(idx == '5') url = "/acar/rent_end/rent_en_frame_s.jsp";
		else if(idx == '6') url = "/acar/rent_diary/rent_di_frame_s.jsp";		
		else if(idx == '7') url = "/acar/con_rent/res_fee_frame_s.jsp";
		fm.gubun1.value = "";
		fm.sort_gubun.value = "";		
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}					
-->
</script>
<script language="JavaScript">
<!--
	function SearchCarOff(){
		var theForm = document.form1;
		theForm.target = "c_foot";
		theForm.submit();
	}

	function GetCarKind(){
		var theForm1 = document.form1;
		var theForm2 = document.form2;
		te = theForm1.code;
		theForm2.sel.value = "form1.code";
		theForm2.car_comp_id.value = theForm1.car_comp_id.value;
		te.options[0].value = '';
		te.options[0].text = '조회중';
		theForm2.target="i_no";
		theForm2.submit();
	}

	function SearchCarNm(){
		var theForm = document.form1;	
		theForm.target="c_foot";
		theForm.submit();
	}

	function init(){
		var theForm1 = document.form1;
		var theForm2 = document.form2;
		te = theForm1.code;
		theForm2.sel.value = "form1.code";
		theForm2.car_comp_id.value = '<%=car_comp_id%>';
		theForm2.code.value = '<%=code%>';		
		te.options[0].value = '';
		te.options[0].text = '조회중';
		theForm2.target="i_no";
		theForm2.action="/acar/res_search/car_mst_nodisplay.jsp";
		theForm2.submit(); //car_mst_nodisplay.jsp
	}
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post' action='rent_pr_sc.jsp' target='c_foot'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='mode' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=4>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 자동차관리 > <span class=style5>말소및기타차량</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
