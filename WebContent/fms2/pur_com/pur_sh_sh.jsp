<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
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

	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//????????

	
	//??????ID&??????ID&????
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "14", "06");
	
		
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
%>

<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//????????
	function search(){
		var fm = document.form1;
		fm.t_wd.value = replaceString("&","AND",fm.t_wd.value);
		fm.action = 'pur_sh_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
//-->
</script>
</head>
<body onload="javascript:document.form1.t_wd.focus();">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='from_page' value='<%=from_page%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>???????? > <span class=style5>????????</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
	<td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>????????</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
    	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
    	        <%if(nm_db.getWorkAuthUser("????_????????",ck_acar_id)){%>
    	        <input type='hidden' name='gubun4' value='<%=gubun4%>'> 
    	        <%}else{%>
                <tr>
                    <td class=title width=10%>??????</td>
                    <td>&nbsp;
            		<select name='gubun4'>
                            <option value='' <%if(gubun4.equals("")){%>selected<%}%>> ???? </option>
                            <option value='03900' <%if(gubun4.equals("03900")){%>selected<%}%>> ???? B2B?????????? </option>
                            <option value='00588' <%if(gubun4.equals("00588")){%>selected<%}%>> ???? ?????????????? </option>
                            <option value='00631' <%if(gubun4.equals("00631")){%>selected<%}%>> ???? ?????????? </option>
                            <option value='00623' <%if(gubun4.equals("00623")){%>selected<%}%>> ???? ?????????? </option>
                            <option value='00998' <%if(gubun4.equals("00998")){%>selected<%}%>> ???? ???????????? </option>
                            <option value='01129' <%if(gubun4.equals("01129")){%>selected<%}%>> ???? ???????????? </option>
                            <option value='03579' <%if(gubun4.equals("03579")){%>selected<%}%>> ???? ?????????? </option>
                            <option value='03954' <%if(gubun4.equals("03954")){%>selected<%}%>> ???? ???????????? </option>
                            <option value='04500' <%if(gubun4.equals("04500")){%>selected<%}%>> ???? ???????????? </option>
                            <option value='03548' <%if(gubun4.equals("03548")){%>selected<%}%>> ???? ?????????? </option>
                            <option value='02176' <%if(gubun4.equals("02176")){%>selected<%}%>> ???? ?????????? </option>
                        </select>
        	  </td>			
                    <td class=title width=10%>????</td>
                    <td>&nbsp;
            		<input type='text' name='gubun3' size='20' class='text' value='<%=gubun3%>' style='IME-MODE: active'>
            		&nbsp;/&nbsp;
            		<input type='text' name='gubun6' size='20' class='text' value='<%=gubun6%>' style='IME-MODE: active'>
        	  </td>					
                    <td class=title width=10%>????</td>
                    <td>&nbsp;
            		<select name='gubun5'>
                            <option value='' <%if(gubun5.equals("")){%>selected<%}%>> ???? </option>
                            <option value='D' <%if(gubun5.equals("D")){%>selected<%}%>> ???????? </option>
                            <option value='D1' <%if(gubun5.equals("D1")){%>selected<%}%>> ????????-???? </option>
                            <option value='D2' <%if(gubun5.equals("D2")){%>selected<%}%>> ????????-???? </option>
                            <option value='Y' <%if(gubun5.equals("Y")){%>selected<%}%>> ???????? </option>
                            <option value='N' <%if(gubun5.equals("N")){%>selected<%}%>> ???????? </option>
                            
                        </select>
        	  </td>					           	  		
                </tr>    	        
    	        <%}%>  
                <tr>
                    <td class=title>????</td>
                    <td colspan='5'>&nbsp;
            		<input type='text' name='gubun7' size='20' class='text' value='<%=gubun7%>' style='IME-MODE: active'>
            		&nbsp;/&nbsp;
            		<input type='text' name='gubun8' size='20' class='text' value='<%=gubun8%>' style='IME-MODE: active'>
            		&nbsp;/&nbsp;
            		<input type='text' name='gubun9' size='20' class='text' value='<%=gubun9%>' style='IME-MODE: active'>
            		&nbsp;/&nbsp;
            		<input type='text' name='gubun10' size='20' class='text' value='<%=gubun10%>' style='IME-MODE: active'>
            		
        	  </td>						
                </tr>     	        
                <tr>
                    <td class=title width=10%>????????</td>
                    <td width=22%>&nbsp;
            		<select name='s_kd'>
                            <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>> ???????????? </option>                            
                            <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>> ???? </option>                            
                            <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>> ?????? </option>
                        </select>
                        &nbsp;
            		<input type='text' name='t_wd' size='15' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>            		
        	  </td>
                    <td class=title width=10%>????</td>
                    <td width=33%>&nbsp;
            		<select name='gubun1'>
                            <option value='1' <%if(gubun1.equals("1")){%>selected<%}%>> ?????????? </option>
                        </select>
                        &nbsp;
                        <select name='gubun2'>                          
                          <option value='1' <%if(gubun2.equals("1")){%>selected<%}%>>????</option>
                          <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>????</option>
                          <option value='3' <%if(gubun2.equals("3")){%>selected<%}%>>????</option>
                          <option value='4' <%if(gubun2.equals("4")){%>selected<%}%>>???? </option>
                        </select>
                        &nbsp;
            		<input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                                ~ 
                        <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">      		
        	  </td>
                  <td class=title width=10%>????????</td>
                  <td >&nbsp;
        	      <select name='sort'>
                          <option value='1' <%if(sort.equals("1")){ %>selected<%}%>> ?????????? </option>
                      </select>
        	  </td>						
                </tr>                
    	    </table>
        </td>
    </tr>
    <tr align="right">
        <td>
            <a href="javascript:search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
        </td>
    </tr>
</table>
</form>
</body>
</html>

