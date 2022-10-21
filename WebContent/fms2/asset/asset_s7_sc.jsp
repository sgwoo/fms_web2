<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
 	//자산내역 내용 보기
	function view_asset(asset_code){
		var fm = document.form1;
		fm.asset_code.value = asset_code;
		fm.asset_g.value = '7';
		fm.target ='d_content';
		fm.action = 'assetma_frame.jsp';
		fm.submit();
	}
	
	
			
//-->
</script>
</head>
<body>
<%
			
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");
	
	String chk1 = request.getParameter("chk1")==null?"2":request.getParameter("chk1");
	
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");	
	String f_month = request.getParameter("f_month")==null?"":request.getParameter("f_month");
	String t_month = request.getParameter("t_month")==null?"":request.getParameter("t_month");
		
	
	f_month = AddUtil.addZero(f_month);
	t_month = AddUtil.addZero(t_month);
		
	String hidden_value = "";
	
	String first 	= request.getParameter("first")==null?"":request.getParameter("first");
	
		//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "13", "07");
			
	if(t_wd.equals("") && st_dt.equals("") && end_dt.equals("")){
	  st_dt = AddUtil.getDate();
	  end_dt = AddUtil.getDate();
	}

	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈

	hidden_value = "?first="+first+"&auth_rw="+auth_rw+"&s_width="+s_width+"&s_height="+s_height+"&chk1="+chk1+"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_year="+s_year+"&f_month="+f_month+"&t_month="+t_month+"&sort="+sort+"&asc="+asc;

	
%>
<form name='form1' method='post'>
<input type='hidden' name='tax_no' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>

<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
  
<input type='hidden' name='chk1' value='<%=chk1%>'>  

<input type='hidden' name='asset_code' value=''>
<input type='hidden' name='asset_g' value=''>
  
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    
    <tr>
		<td>
			 <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td><iframe src="./asset_s7_sc_in.jsp<%=hidden_value%>" name="RegList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>								
			</table>
		</td>
	</tr>
	
</table>
</form>
</body>
</html>
