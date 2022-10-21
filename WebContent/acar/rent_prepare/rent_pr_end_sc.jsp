<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
 	//계약서 내용 보기
	function view_car(s_cd, c_id){
		var fm = document.form1;
		fm.action = '/acar/res_search/car_res_list.jsp';
		fm.s_cd.value = s_cd;
		fm.c_id.value = c_id;
		fm.submit();
	}
	
	//차량예약현황 조회
	function car_reserve(s_cd, c_id){
		var fm = document.form1;
		fm.c_id.value = c_id;		
		var SUBWIN="/acar/rent_diary/car_res_list.jsp?c_id="+fm.c_id.value+"&auth_rw="+fm.auth_rw.value;	
		window.open(SUBWIN, "CarReserve", "left=50, top=50, width=850, height=600, scrollbars=yes, status=yes");
	}
	
 	//매각예정&보류차량 처리
	function prepare_action(mode){
		var fm = inner.form1;
		var len = fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck = fm.elements[i];
			if(ck.name == 'pr'){
				if(ck.checked == true){
					cnt++;
					idnum = ck.value;
				}
			}
		}	
		if(cnt == 0){ alert("차량을 선택하세요 !"); return; }
	
		if(mode == '2'){ 	if(!confirm('매각예정처리를 하시겠습니까?')){	return;	}}
		if(mode == '3'){ 	if(!confirm('보류차량처리를 하시겠습니까?')){	return;	}}		
		if(mode == '4'){ 	if(!confirm('말소차량처리를 하시겠습니까?')){	return;	}}				
		if(mode == '5'){ 	if(!confirm('도난차량처리를 하시겠습니까?')){	return;	}}				
		if(mode == '6'){ 	if(!confirm('해지처리를 하시겠습니까?')){		return;	}}								
		
		fm.mode.value = mode;
		fm.action = "rent_pr_set.jsp";
		fm.target = "i_no";
		fm.submit();
	}
//-->
</script>
</head>
<body leftmargin="15">
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
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"1":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "04", "01");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-75;//현황 라인수만큼 제한 아이프레임 사이즈
%>	

  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
    <tr> 
        <td align="right" colspan="3">
    	<a href="javascript:prepare_action('1');"><img src="/acar/images/center/button_ybcrcr.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
        </td>
    </tr>
<%	}%>  
  <form name='form1' method='post' target='d_content' action='car_res_list.jsp'>
    <input type='hidden' name='s_cd' value=''>
    <input type='hidden' name='c_id' value=''>
    <input type='hidden' name='rent_st' value=''>
    <input type='hidden' name='rent_start_dt' value=''>
    <input type='hidden' name='rent_end_dt' value=''>
    <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
    <input type='hidden' name='user_id' value='<%=user_id%>'>
    <input type='hidden' name='br_id' value='<%=br_id%>'>
    <input type='hidden' name='gubun1' value='<%=gubun1%>'>
    <input type='hidden' name='gubun2' value='<%=gubun2%>'>
    <input type='hidden' name='brch_id' value='<%=brch_id%>'>
    <input type='hidden' name='start_dt' value='<%=start_dt%>'>
    <input type='hidden' name='end_dt' value='<%=end_dt%>'>
    <input type='hidden' name='car_comp_id' value='<%=car_comp_id%>'>
    <input type='hidden' name='code' value='<%=code%>'>
    <input type='hidden' name='s_kd'  value='<%=s_kd%>'>
    <input type='hidden' name='t_wd' value='<%=t_wd%>'>
    <input type='hidden' name='s_cc' value='<%=s_cc%>'>
    <input type='hidden' name='s_year' value='<%=s_year%>'>
    <input type='hidden' name='sort_gubun' value="<%=sort_gubun%>">
    <input type='hidden' name='asc' value='<%=asc%>'>
    <tr> 
        <td colspan='3'> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                    <td> <iframe src="rent_pr_end_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
                    </iframe> </td>
                </tr>
            </table>
        </td>
    </tr>
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>  
</body>
</html>
