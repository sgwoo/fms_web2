<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
 	//계약서 내용 보기
	function view_cont(s_cd, c_id){
		var fm = document.form1;
		if(s_cd != ''){
			fm.s_cd.value = s_cd;
			fm.c_id.value = c_id;
			fm.target = 'd_content';
			fm.action = 'res_rent_u.jsp';
			fm.submit();
		}		
	}
	
	//예약처리=>배차,취소
	function reserve_action(mode, s_cd, c_id, car_no, firm_nm, client_nm){
		var fm = document.form1;
		if(mode == 'N'){
			if(!confirm('취소하시겠습니까?')){	return;	}
			fm.s_cd.value 		= s_cd;
			fm.c_id.value 		= c_id;
			fm.mode.value 		= mode;
			fm.car_no.value 	= car_no;
			fm.c_firm_nm.value 	= firm_nm;
			fm.c_client_nm.value = client_nm;
			fm.target = 'i_no';
			fm.action = 'res_action_a.jsp';
			fm.submit();
		}else if(mode == 'N_REQ'){
			if(!confirm('취소요청하시겠습니까?')){	return;	}
			fm.s_cd.value 		= s_cd;
			fm.c_id.value 		= c_id;
			fm.mode.value 		= mode;
			fm.car_no.value 	= car_no;
			fm.c_firm_nm.value 	= firm_nm;
			fm.c_client_nm.value = client_nm;
			fm.target = 'i_no';
			fm.action = 'res_action_a.jsp';
			fm.submit();				
		}else if(mode == 'BEFORE'){
			if(!confirm('배차취소하시겠습니까?')){	return;	}
			fm.s_cd.value 		= s_cd;
			fm.c_id.value 		= c_id;
			fm.mode.value 		= mode;
			fm.car_no.value 	= car_no;
			fm.c_firm_nm.value 	= firm_nm;
			fm.c_client_nm.value = client_nm;
			fm.target = 'i_no';
			fm.action = 'res_action_a.jsp';
			fm.submit();				
		}else{
			window.open("about:blank", "ACTION", "left=100, top=50, width=900, height=850, resizable=yes, scrollbars=yes, status=yes");			
			fm.s_cd.value = s_cd;
			fm.c_id.value = c_id;
			fm.mode.value = mode;
			fm.target = 'ACTION';
			fm.action = 'res_action.jsp';
			fm.submit();			
		}
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
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"c.car_nm":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-80;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<form name='form1' method='post' target='d_content' action='res_rent_c.jsp'>
 <input type='hidden' name='car_no' value=''>
 <input type='hidden' name='c_firm_nm' value=''>
 <input type='hidden' name='c_client_nm' value=''>  
 <input type='hidden' name='s_cd' value=''>
 <input type='hidden' name='c_id' value=''>
 <input type='hidden' name='rent_st' value=''>  
 <input type='hidden' name='rent_start_dt' value=''> 
 <input type='hidden' name='rent_end_dt' value=''>  
 <input type='hidden' name='use_days' value=''>   
 <input type='hidden' name='mode' value=''>  
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
 <input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'> 
 <input type='hidden' name='asc' value='<%=asc%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
			  		  <iframe src="rent_mn_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			 		   </iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>  
	<tr>
	    <td>* 월렌트 연장은 반차 처리하고, 월렌트관리-월렌트계약등록에 등록하십시오.</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
