<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String gubun6 		= request.getParameter("gubun6")	==null?"":request.getParameter("gubun6");
	String gubun7 		= request.getParameter("gubun7")	==null?"":request.getParameter("gubun7");
	String gubun8 		= request.getParameter("gubun8")	==null?"":request.getParameter("gubun8");
	String gubun9 		= request.getParameter("gubun9")	==null?"":request.getParameter("gubun9");
	String gubun10 		= request.getParameter("gubun10")	==null?"":request.getParameter("gubun10");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");

	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//???ܱ???

	
	int cnt = 1; //sc ???¶??μ?
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//??Ȳ ???μ???ŭ ???? ?????????? ??????
	
	
	String vlaus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort="+sort+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+
					"&gubun6="+gubun6+"&gubun7="+gubun7+"&gubun8="+gubun8+"&gubun9="+gubun9+"&gubun10="+gubun10+
					"&st_dt="+st_dt+"&end_dt="+end_dt+"&from_page="+from_page+
				   	"&sh_height="+height+"";

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
 	//???༭ ???? ????
	function view_cont(rent_mng_id, rent_l_cd, com_con_no){
		var fm = document.form1;
		fm.rent_mng_id.value 	= rent_mng_id;
		fm.rent_l_cd.value 	= rent_l_cd;
		fm.com_con_no.value 	= com_con_no;
		fm.target ='d_content';
		fm.action = 'lc_rent_c.jsp';
		fm.submit();
	}

//-->
</script>
</head>
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='sort'	value='<%=sort%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>  
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'> 
  <input type='hidden' name='gubun6' 	value='<%=gubun6%>'>  
  <input type='hidden' name='gubun7' 	value='<%=gubun7%>'>  
  <input type='hidden' name='gubun8' 	value='<%=gubun8%>'>  
  <input type='hidden' name='gubun9' 	value='<%=gubun9%>'> 
  <input type='hidden' name='gubun10' value='<%=gubun10%>'> 
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/pur_com/pur_sh_frame.jsp'>  
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='com_con_no' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>?? <input type='text' name='size' value='' size='4' class=whitenum> ??</span></td>
    </tr>
    <tr>
	<td>
    	    <table border="0" cellspacing="0" cellpadding="0" width=100%>
    		<tr>
        	    <td>
        		<iframe src="pur_sh_sc_in.jsp<%=vlaus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
        	    </td>
    		</tr>
    	    </table>
	</td>
    </tr>
</table>
</form>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
