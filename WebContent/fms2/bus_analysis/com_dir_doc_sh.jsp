<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

		
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %> 
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//조회
	function search(){
		var fm = document.form1;	
		if(fm.gubun1.value == '3'){
			if(fm.s_dt.value == '' || fm.e_dt.value == ''){
				alert('기간을 정확히 입력해 주십시오.'); 
				return;
			}
		}	
		fm.action = "com_dir_doc_sc.jsp";
		fm.target = "c_foot";
		fm.submit();
	}
	function EnterDown(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	
	
//-->
</script>
</head>
<body>
<form action="./com_dir_doc_sc.jsp" name="form1" method="POST" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보  > 영업관리 > <span class=style5>자동차영업활동보고서</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>    
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width="10%" class="title">조회일자</td>
                    <td colspan='3'>&nbsp;
			<select name='gubun1'>
                            <option value="1" <%if(gubun1.equals("1"))%>selected<%%>>전월</option>
                            <option value="2" <%if(gubun1.equals("2"))%>selected<%%>>당월</option>
                            <option value="3" <%if(gubun1.equals("3"))%>selected<%%>>기간</option>
                        </select>
                        &nbsp;&nbsp;&nbsp;
            		<input type='text' size='11' name='s_dt' class='text' value='<%=s_dt%>'>
                                ~ 
                        <input type='text' size='11' name='e_dt' class='text' value="<%=e_dt%>">
	            </td>                    
                </tr>
                <tr>    
                    <td width="10%" class="title">검색조건</td>
                    <td width="40%">&nbsp;
                        <select name='s_kd'>
                            <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호</option>
                            <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>차종</option>
                        </select>
			&nbsp;&nbsp;&nbsp;
			<input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
		    </td>
                    <td width="10%" class="title">영업담당자</td>
                    <td width="40%">&nbsp;
                        <input type='text' name='gubun2' size='10' class='text' value='<%=gubun2%>' style='IME-MODE: active'>
                    </td>
                </tr>
            </table>
        </td>
    </tr>    
    <tr align="right">
        <td colspan="2"><a href="javascript:search()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>	
</table>
</form>
</body>
</html>

