<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:AddUtil.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head><title>FMS</title>
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
	function search()
	{
		var fm = document.form1;
		if(fm.gubun1.value=='6'){
			if(fm.st_dt.value == '')				{	alert('조회기간을 입력하십시오');return;	}	
			if(fm.end_dt.value == '')				{	alert('조회기간을 입력하십시오');return;	}	
		}
		fm.target="c_foot";
		fm.action = "ins_com_emp_not_sc.jsp";
		document.form1.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
//-->


//디스플레이 타입(검색) - 조회기간 선택시
	function cng_input1(){
		var fm = document.form1;
		if(fm.gubun1.options[fm.gubun1.selectedIndex].value == '6'){ //기간조회선택
			text_input.style.display	= '';
		}else{
			text_input.style.display	= 'none';
			fm.st_dt.value='';
			fm.end_dt.value='';
		}
	}
	
	function list_excel_emp(){
		fm = document.form1;
		if(fm.s_kd.value!='9' && fm.gubun2.value!='D'){
			alert('비매칭으로 설정해 주세요');
			return;
		}
		window.open("about:blank",'list_excel','scrollbars=yes,status=yes,resizable=yes,width=1200,height=800,left=50,top=50');
		fm.target = "list_excel";
		fm.action = "ins_emp_excel.jsp";
		fm.submit();
	}		
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin=10 onload="javascript:document.form1.t_wd.focus();">

<form name='form1' action='ins_com_emp_not_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
<input type='hidden' name='br_id' 	value='<%=br_id%>'>
<input type='hidden' name='user_id' 	value='<%=user_id%>'>
<input type='hidden' name='sh_height' 	value='<%=sh_height%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고 및 보험 > 보험관리 > <span class=style5>임직원보험미가입현황</span></span></td>
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
                    <td class=title width=10%>보험만료일</td>
                    <td width=15%>&nbsp;
                        <select name="gubun1" onChange="javascript:cng_input1()">
                            <option value="" <%if(gubun1.equals("")){%>selected<%}%>>전체</option>
                            <option value="4" <%if(gubun1.equals("4")){%>selected<%}%>>만료15일전</option>
                            <option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>만료30일전</option>
                            <option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>당월</option>
			    <option value="3" <%if(gubun1.equals("3")){%>selected<%}%>>익월</option>			    
			    <option value="5" <%if(gubun1.equals("5")){%>selected<%}%>>당해</option>			
			    <option value="6" <%if(gubun1.equals("6")){%>selected<%}%>>기간</option>    
                        </select><div id="text_input" style="display:none;">
                        &nbsp;&nbsp;<input type="text" name="st_dt" size="10" value="" class="text">
			~
			<input type="text" name="end_dt" size="10" value="" class="text">
        	    </div></td>		  		  
                    <td class=title width=10%>가입여부</td>
                    <td width=10%>&nbsp;
                        <select name="gubun2">
                        		<option value="" <%if(gubun2.equals("")){%>selected<%}%>>전체</option>
                            <option value="N" <%if(gubun2.equals("N")){%>selected<%}%>>미가입</option>
                            <option value="Y" <%if(gubun2.equals("Y")){%>selected<%}%>>가입</option>
                            <option value="D" <%if(gubun2.equals("Y")){%>selected<%}%>>비매칭</option>
                        </select>
        	    </td>		
        	    <td class=title width=10%>검색조건</td>
                    <td width=25%>&nbsp;
        		<select name='s_kd'>                            
                            <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호 </option>
		            <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>사업자번호</option>                            
		            <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>계약번호 </option>
                            <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>차량번호 </option>
                            <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>차종</option>			  
                            <option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>최초영업자 </option>
                            <option value='7' <%if(s_kd.equals("7")){%>selected<%}%>>영업담당자 </option>
                            <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>보험만료일 </option>
                            <option value='9' <%if(s_kd.equals("9")){%>selected<%}%>>업무대여 </option>
                        </select>
        		&nbsp;
        		<input type='text' name='t_wd' size='35' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        	    </td>
        	    <td class=title width=10%>정렬조건</td>
                    <td width=20%>&nbsp;
                        <select name="gubun3">
                        		<option value="" <%if(gubun3.equals("")){%>selected<%}%>>보험시작일</option>
                            <option value="2" <%if(gubun3.equals("2")){%>selected<%}%>>가입기준</option>
                        </select>
        	    </td>		  		    		  
                    
                </tr>
            </table>
	</td>
    </tr>  
    <tr align="right">
        <td>
        	<a href="javascript:list_excel_emp();"><img src=/acar/images/center/button_bhex.gif border=0 align=absmiddle></a>
        	<a href="javascript:search();"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>
</table>
</form>
</body>
</html>
