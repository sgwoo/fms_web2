<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.im_email.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String vid1[] = request.getParameterValues("ch_cd");
	String vid2[] = request.getParameterValues("h_st");
	String vid3[] = request.getParameterValues("h_dmidx");
	String vid4[] = request.getParameterValues("h_email");
	String vid5[] = request.getParameterValues("h_subject");
	String vid6[] = request.getParameterValues("h_firm_nm");
	int vid_num			= 0;
	String dmidx		= "";
	String dm_st		= "";
	int vid_size 		= 0;
	int err_cnt	 		= 0;
	
	vid_size = vid1.length;
%>


<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function save(){
		var fm = document.form1;			
		fm.action = 're_send_a.jsp';
		//fm.target = 'i_no';
		fm.submit();
	}	
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='vid_size' value='<%=vid_size%>'>      
<table width=700 border=0 cellpadding=0 cellspacing=0>
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>admin > 메일관리 > <span class=style5>
						 메일 재발송</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>  	
    <tr>
        <td class=line>
		  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <tr> 
              <td width='30' class='title'>연번</td>		    
              <td width='70' class='title'>메일구분</td>		  
		      <td width='300' class='title'>수신처</td>
              <td width='300' class='title'>메일주소</td>		  
          </tr>
		  <%for(int i=0;i < vid_size;i++){
				vid_num = AddUtil.parseInt(vid1[i]);%>
		  <tr>
		    <td align="center"><%=i+1%></td>
		    <td align="center">
			<input type='hidden' name='st'    	value='<%=vid2[vid_num]%>'>
			<input type='hidden' name='dmidx' 	value='<%=vid3[vid_num]%>'>
			<input type='hidden' name='firm_nm'	value='<%=vid6[vid_num]%>'>
			<%if(vid2[vid_num].equals("2")){%>청구서<%}else if(vid2[vid_num].equals("3")){%>견적서<%}else if(vid2[vid_num].equals("4")){%>안내문<%}%></td>
		    <td>&nbsp;<%=vid6[vid_num]%></td>
		    <td align="center"><input type='text' name='email' maxlength='100' value='<%=vid4[vid_num]%>' class='default' size='40'></td>									
		  </tr>
		  <%}%>
      </table>
	  </td>
    </tr>	
	<tr>
	    <td align="right">&nbsp;</td>
	<tr> 
	<%//if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
    <tr>
	    <td align='center'>
	        <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
	    </td>
	</tr>		
	<%//}%>
</table>
<script language="JavaScript">
<!--
//-->
</script>  
</form>	
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>