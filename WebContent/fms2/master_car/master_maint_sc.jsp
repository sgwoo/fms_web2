<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function reg_exp(){		
		window.open("/acar/mng_exp/exp_i.jsp", "REG_EXP", "left=100, top=100, width=550, height=300");
	}
	
	function reg_exp_all(){
		window.open("/acar/mng_exp/exp_i_all.jsp", "REG_EXP_ALL", "left=100, top=100, width=550, height=400, scrollbars=yes");
	}	
	
	function view_exp(m_id, l_cd, c_id, auth_rw){
		window.open("/acar/mng_exp/exp_u.jsp?auth_rw="+auth_rw+"&m_id="+m_id+"&l_cd="+l_cd+"&car_mng_id="+c_id, "VIEW_EXP", "left=100, top=100, width=850, height=650");
	}
	
	function pay_exp(c_id, exp_st, est_dt, auth_rw, user_id){
		window.open("/acar/mng_exp/exp_pay_p.jsp?user_id="+user_id+"&auth_rw="+auth_rw+"&car_mng_id="+c_id+"&exp_st="+exp_st+"&est_dt="+est_dt, "EXP_PAY", "left=100, top=100, width=450, height=300");
	}
	
	function view_car(m_id, l_cd, c_id)
	{
//		window.open("/acar/car_register/car_view.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&car_mng_id="+c_id+"&cmd=ud", "VIEW_CAR", "left=100, top=100, width=850, height=450, scrollbars=yes");
		window.open("view_mc_car_list.jsp?car_mng_id="+c_id, "VIEW_CAR", "left=100, top=100, width=850, height=500, scrollbars=yes");		
	}		
	
	//현황
	function  view_stat(){
		var taxInvoice = window.open("about:blank", "Stat", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=850px, height=275px");
		document.form1.action="exp_sc_stat.jsp";
		document.form1.method="post";
		document.form1.target="Stat";
		document.form1.submit();
	}		
	
		//리스트 엑셀 전환
	function pop_auto(){
		var fm = document.form1;
		fm.target = "_blank";
		fm.action = "popup_auto.jsp";
		fm.submit();
	}	
	
	
	//정산수정 - 회차 및 정산일
function view_jungsan(js_dt, js_seq)
{
		window.open("/fms2/master_car/master_car_jungsan_popup.jsp?js_dt="+js_dt+"&js_seq="+js_seq, "jungsan", "left=150, top=150, width=400, height=300");
}

function save(){
		var fm = document.form1;
	
	fm.action = 'ss_car_maint_excel_reg.jsp';
	fm.target = "_self";
	fm.submit();
	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
		
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID

	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");

	String s_kd = request.getParameter("s_kd")==null?"4":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"":request.getParameter("s_st");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<form name='form1'  method='post'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>

<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>

<input type='hidden' name='sh_height' value='<%=sh_height%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>

	<tr>
	    <td style='height:2'><a href="javascript:var win=window.open('hj_car_maint_excel_reg.jsp','popup','left=10, top=10, width=900, height=600, status=no, scrollbars=yes, resizable=no');"><img src=/acar/images/center/button_excel_dr.gif align=absmiddle border=0></a></td>
	</tr>
	<tr>
		<td>
			<iframe src="master_maint_sc_in.jsp?s_st=<%=s_st%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>" name="i_no" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
		</td>
	</tr>
	<tr>
	</tr>
</table>
</form>
</body>
</html>