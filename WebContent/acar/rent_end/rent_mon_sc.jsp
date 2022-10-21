<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");	
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");	
	String brch_id 		= request.getParameter("brch_id")	==null?"":request.getParameter("brch_id");
	String start_dt 	= request.getParameter("start_dt")	==null?"":request.getParameter("start_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");		
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");	
	String s_cc 		= request.getParameter("s_cc")		==null?"":request.getParameter("s_cc");
	String s_year 		= request.getParameter("s_year")	==null?"":request.getParameter("s_year");
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")		==null?"":request.getParameter("asc");
	
	//height
	int sh_height 		= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
%>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
 	//계약서 내용 보기
	function view_cont(use_st, rent_st, s_cd, c_id){
	
		var fm = document.form1;
		
		fm.mode.value = 'c';
		fm.s_cd.value = s_cd;
		fm.c_id.value = c_id;
				
		if(use_st == '예약'){ 	
			fm.action = '/acar/res_stat/res_rent_u.jsp';
		}else if(use_st == '배차'){ 	
			fm.action = '/acar/rent_mng/res_rent_u.jsp';
		}else if(use_st == '반차'){ 
			if(rent_st == '단기대여' || rent_st == '보험대차' || rent_st == '월렌트'){ 	
				fm.action = 'rent_settle_u.jsp';
			}else{
				fm.action = '/acar/rent_mng/res_rent_u.jsp';
			}
		}else if(use_st == '정산'){ 	
			fm.action = 'rent_settle_u.jsp';
		}else if(use_st == '취소'){ 	
			fm.action = '/acar/res_stat/res_rent_u.jsp';
		}
		
		
		fm.target = 'd_content';
		fm.submit();
	}
	
	//스캔관리 보기
	function view_scan(c_id, s_cd)
	{		
		window.open("/acar/res_stat/scan_view.jsp?c_id="+c_id+"&s_cd="+s_cd, "VIEW_SCAN", "left=100, top=100, width=720, height=800, scrollbars=yes");				
	}	
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
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
 <input type='hidden' name='gubun3' value='<%=gubun3%>'>  
 <input type='hidden' name='gubun4' value='<%=gubun4%>'>   
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
 <input type='hidden' name='list_from_page' value='/acar/rent_end/rent_mon_frame.jsp'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
			  		  <iframe src="rent_mon_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			 		   </iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>  
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
