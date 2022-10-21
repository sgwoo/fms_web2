<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String s_au = request.getParameter("s_au")==null?"":request.getParameter("s_au");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"0":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");
	
	String chk1 = request.getParameter("chk1")==null?"2":request.getParameter("chk1");
	
	String gubun 		= request.getParameter("gubun")==null?"car_no":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
		
	String hidden_value = "";
		
		//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "13", "05");
			
	if(t_wd.equals("") && st_dt.equals("") && end_dt.equals("")){
	  st_dt = AddUtil.getDate();
	  end_dt = AddUtil.getDate();
	}

	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈

	hidden_value = "?gubun="+gubun+"&gubun_nm="+gubun_nm+"&auth_rw="+auth_rw+"&s_width="+s_width+"&s_height="+s_height+"&chk1="+chk1+"&s_kd="+s_kd+"&s_au="+s_au+"&t_wd="+t_wd+"&gubun1="+gubun1+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+"&asc="+asc;

 	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
 	//자산 보기
	function view_asset(asset_code){
		var fm = document.form1;
		fm.asset_code.value = asset_code;
		fm.asset_g.value = '5';
		fm.target ='d_content';
		fm.action = 'assetma_frame.jsp';
		fm.submit();
	}
	
	//리스트 엑셀 전환
	function pop_excel(){
		var fm = document.form1;
		fm.target = "_blank";
		
		fm.action = "popup_asset_s5_excel.jsp";
		fm.submit();
	}		
//-->
</script>
</head>

<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='asset_code' value=''>
  <input type='hidden' name='asset_g' value=''>

<input type='hidden' name='gubun1' value='<%=gubun1%>'>

<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='chk1' value='<%=chk1%>'>  
 <input type='hidden' name='gubun' 	value='<%=gubun%>'>			
  <input type='hidden' name='gubun_nm' 	value='<%=gubun_nm%>'>
  <input type='hidden' name='s_au' value='<%=s_au%>'
<table border="0" cellspacing="0" cellpadding="0" width=100%>
 
	  <tr>	
	  <td align='left'><a href="javascript:pop_excel()"><img src="/acar/images/center/button_excel.gif" align="absmiddle" border="0"></a>
	  </td>
	</tr>
	
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="asset_s5_sc_in.jsp<%=hidden_value%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
