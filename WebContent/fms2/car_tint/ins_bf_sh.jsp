<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	== null ? "" : request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")		== null ? "" : request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		== null ? "" : request.getParameter("br_id");
	
	String s_kd 			 = request.getParameter("s_kd")				== null ? "" : request.getParameter("s_kd");
	String t_wd 			 = request.getParameter("t_wd")				== null ? "" : request.getParameter("t_wd");
	String andor 			 = request.getParameter("andor")				== null ? "" : request.getParameter("andor");
	String gubun1			 = request.getParameter("gubun1")			== null ? "" : request.getParameter("gubun1");
	String gubun2			 = request.getParameter("gubun2")			== null ? "" : request.getParameter("gubun2");
	String gubun3			 = request.getParameter("gubun3")			== null ? "" : request.getParameter("gubun3");
	String st_dt 			 = request.getParameter("st_dt")				== null ? "" : request.getParameter("st_dt");
	String end_dt 			 = request.getParameter("end_dt")			== null ? "" : request.getParameter("end_dt");
	String sort 				 = request.getParameter("sort")					== null ? "" : request.getParameter("sort");
	String rent_or_lease = request.getParameter("rent_or_lease")	== null ? "" : request.getParameter("rent_or_lease");
	String con_f 			 = request.getParameter("con_f")			   	== null ? "" : request.getParameter("con_f");
	
	String from_page = request.getParameter("from_page") == null ? "" : request.getParameter("from_page");  //popup 요청한 페이지
	
	//height
	int sh_height = request.getParameter("sh_height") == null ? 0 : Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
	String white = "";
	String disabled = "";
	
%>

<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %><title>FMS</title>
<script language='javascript'>
<!--
	function search(){
		fm = document.form1;
		if( fm.gubun2.value == '2' ){
			if( fm.t_wd.value == '' && ( fm.st_dt.value == '' || fm.end_dt.value== '' ) ){
				alert( '기간을 입력하십시오.' );
				return;
			}
		}
		fm.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function list_excel(){
		fm = document.form1;
		window.open("about:blank",'list_excel','scrollbars=yes,status=yes,resizable=yes,width=1200,height=800,left=50,top=50');
		fm.target = "list_excel";
		fm.action = "ins_bf_sc_in_excel.jsp";
		fm.submit();
	}		
//-->
</script>
<style type=text/css>

<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="javascript:document.form1.t_wd.focus();" leftmargin=15>
<form name='form1' action='ins_bf_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고관리 > 보험관리 > <span class=style5>블랙박스파일생성</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>조건검색</span></td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>    
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
    	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=10%>기간</td>
                    <td colspan='7'>&nbsp;
        		<select name='gubun3'>
                            <option value='1' <%if(gubun3.equals("1")){%>selected<%}%>>설치일자</option>
                            <option value='2' <%if(gubun3.equals("2")){%>selected<%}%>>보험시작일</option>
                            <option value='3' <%if(gubun3.equals("3")){%>selected<%}%>>차량등록일</option>
                        </select>
                	<select name='gubun2'>
                            <option value='3' <%if(gubun2.equals("3")){%>selected<%}%>>당일</option>                            
			    <option value='5' <%if(gubun2.equals("5")){%>selected<%}%>>전일</option>
			    <option value='6' <%if(gubun2.equals("6")){%>selected<%}%>>7일</option>
			    <option value='1' <%if(gubun2.equals("1")){%>selected<%}%>>당월</option>			    
                            <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>기간 </option>
                        </select>
                	<input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                        ~ 
                        <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
                    </td>
                </tr>	  
                <tr>
                    <td class=title width=10%>검색조건</td>
                    <td>&nbsp;
                	  <select name='s_kd'>
                        <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>보험사 </option>
                        <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>차량번호 </option>
                        <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>불충 </option>
                      </select>
                	  &nbsp;&nbsp;&nbsp;
                	  <input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
                	</td>
                	<td class=title width=10%>렌트/리스</td>
                    <td>&nbsp;
                	  <select name='rent_or_lease'>
                        <option value='1' <%if(rent_or_lease.equals("1")){%>selected<%}%>>전체 </option>
                        <option value='2' <%if(rent_or_lease.equals("2")){%>selected<%}%>>렌트 </option>
                        <option value='3' <%if(rent_or_lease.equals("3")){%>selected<%}%>>리스 </option>
                      </select>
                	</td>
                	<td class=title width=10%>피보험자</td>
                    <td>&nbsp;
                	  <select name='con_f'>
                        <option value='1' <%if(con_f.equals("1")){%>selected<%}%>>전체 </option>
                        <option value='2' <%if(con_f.equals("2")){%>selected<%}%>>아마존카 </option>
                        <option value='3' <%if(con_f.equals("3")){%>selected<%}%>>고객 </option>
                      </select>
                	</td>
                    <td class=title width=10%>정렬조건</td>
                    <td>&nbsp;
                	  <select name='sort'>
                        <option value='1' <%if(sort.equals("1")){%>selected<%}%>>설치일자 </option>
                        <option value='2' <%if(sort.equals("2")){%>selected<%}%>>보험사 </option>
                      </select>
                	</td>
                </tr>
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <td><a href="javascript:search()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		
		<a href="javascript:list_excel()"><img src="/acar/images/center/button_excel.gif"  align="absmiddle" border="0"></a> 		        
        </td>
    </tr>
</table>
</form>
</body>
</html>
