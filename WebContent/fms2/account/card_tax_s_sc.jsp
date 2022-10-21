<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "5":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String gubun0 	= request.getParameter("gubun0")==null?"":request.getParameter("gubun0"); //년도  
	String gubun2 	= request.getParameter("gubun2")==null?"1":request.getParameter("gubun2"); // 분기
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3"); //카드사 
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	
	String st_mon 	= request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
		
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-80;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?st_mon="+st_mon+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun0="+gubun0+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
				"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun2="+gubun2+"&gubun3="+gubun3+"&asc="+asc+"&gubun1="+gubun1+
			   	"&height="+height+"";
			   	

%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
		
		
	function reg(){
			var fm = document.form1;
		/*
			if ( fm.gubun2.value == '') {				
				alert('분기를 선택하셔야 합니다!!!..');
				return;					
			} */
			
			if ( fm.st_mon.value == '') {				
				alert('월을 선택하셔야 합니다!!!..');
				return;					
			}
			
			if(confirm('등록하시겠습니까?')){	
				fm.action='card_tax_jip_reg_a.jsp';	
				fm.target='i_no';	
				fm.submit();
			}			
					
	}
	
function toExcel(){
	var fm = document.form1;
	fm.target = "_blank";
	
	fm.action = "popup_card_tax_excel.jsp";
	fm.submit();
			
}
				
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post' target='d_content'>

  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun0' 	value='<%=gubun0%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='st_mon' 	value='<%=st_mon%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/account/card_tax_s_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle>
	     <span class=style2>총 <input type='text' name='size' value='' size='4' class=whitenum> 건</span></td>
	     <td align=right><a href='javascript:reg()'><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a> </td>	
	     <td align=right><a href='javascript:toExcel()'><img src="/acar/images/center/button_excel.gif" border=0 align=absmiddle></a> </td>	
	</tr>
	
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="card_tax_s_sc_in.jsp<%=valus%>" name="ii_no" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 

</form>
</body>
</html>
