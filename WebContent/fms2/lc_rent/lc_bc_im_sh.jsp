<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getXmlAuthRw(user_id, "/fms2/lc_rent/lc_bc_im_frame.jsp");
	
	String s_kd 	= request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		fm.action = 'lc_bc_im_sc.jsp';
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
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;영업지원 > 계약관리 > <span class=style1><span class=style5>임의연장영업효율등록현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>조건검색</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
    	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=10%>검색조건</td>
                    <td width=30%>&nbsp;
            		    <select name='s_kd'>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호 </option>
                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>계약번호 </option>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>
                          <option value='16' <%if(s_kd.equals("16")){%>selected<%}%>>차종</option>			  
                          <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>최초영업자 </option>
                          <option value='14' <%if(s_kd.equals("14")){%>selected<%}%>>대여개시일</option>	
						  <option value='19' <%if(s_kd.equals("19")){%>selected<%}%>>견적일자</option>				  
                        </select>
        			    &nbsp;
    			        <input type='text' name='t_wd' size='18' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
    		        </td>
                    <td class=title width=10%>진행구분</td>
                    <td width=20%>&nbsp;
            		    <select name='gubun1'>
                          <option value='' <%if(gubun1.equals("")){%>selected<%}%>>전체 </option>
                          <option value='Y' <%if(gubun1.equals("Y")){%>selected<%}%>>진행 </option>
                          <option value='N' <%if(gubun1.equals("N")){%>selected<%}%>>해지 </option>
                        </select>&nbsp;
    		        </td>		  		  
                    <td class=title width=10%>등록구분</td>
                    <td width=20%>&nbsp;
            		    <select name='gubun3'>
                          <option value=''  <%if(gubun3.equals("")){ %>selected<%}%>>전체 </option>
                          <option value='1' <%if(gubun3.equals("1")){%>selected<%}%>>등록 </option>
                          <option value='2' <%if(gubun3.equals("2")){%>selected<%}%>>미등록 </option>
                        </select></td>		  		  
                </tr>
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <td><a href="javascript:search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
    </tr>
</form> 
</table>
</body>
</html>

