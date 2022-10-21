<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"0":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"4":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"2":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"":request.getParameter("s_st");
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
%>
<html>
<head>
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function search(){
		
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8'){ //영업담당자
			fm.t_wd.value = fm.s_bus.options[fm.s_bus.selectedIndex].value;
		}
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '6'){ //영업소
			fm.t_wd.value = fm.s_brch.options[fm.s_brch.selectedIndex].value;
		}
		if(fm.st_dt.value != ''){ fm.st_dt.value = ChangeDate3(fm.st_dt.value);	}
		if(fm.end_dt.value != ''){ fm.end_dt.value = ChangeDate3(fm.end_dt.value);	}
		if(fm.st_dt.value !='' && fm.end_dt.value==''){ fm.end_dt.value = fm.st_dt.value; }
		//if(fm.t_wd.value !='' ) { fm.s_st.value = "3"; }	
		fm.submit();
		console.log("1");
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
		
	
	//디스플레이 타입(검색)-세부조회 선택시
	function cng_input1(){
		var fm = document.form1;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '4'){ //기간
			td_dt.style.display	 = '';
		}else{
			td_dt.style.display	 = 'none';
		}
	}		
	
						
//-->
</script>
</head>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' action='master_maint_sc.jsp' target='c_body' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='s_st' value=''>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>자동차검사결과조회</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<tr>
		<td colspan="2">			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='380'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jhgb.gif align=absmiddle>&nbsp;
						<select name="gubun3" >
							<option value="" <%if(gubun3.equals("")){%>selected<%}%>>전체</option>						
							<option value="3" <%if(gubun3.equals("3")){%>selected<%}%>>성수자동차</option>
							<option value="4" <%if(gubun3.equals("4")){%>selected<%}%>>정일현대</option>
							<option value="7" <%if(gubun3.equals("7")){%>selected<%}%>>협신자동차</option>
							<option value="8" <%if(gubun3.equals("8")){%>selected<%}%>>차비서</option>
						    <option value="6" <%if(gubun3.equals("6")){%>selected<%}%>>미스터박대리</option> 
							<option value="9" <%if(gubun3.equals("9")){%>selected<%}%>>영등포자동차검사소</option>
							<option value="A" <%if(gubun3.equals("A")){%>selected<%}%>>성서현대</option>
						<!--    <option value="1" <%if(gubun3.equals("1")){%>selected<%}%>>마스타자동차</option> -->
						</select>
						&nbsp;&nbsp;&nbsp;
						<!-- <select name="gubun1" onChange="javascript:list_move()"> -->
						<select name="gubun1">
							<option value="0" <%if(gubun1.equals("0")){%>selected<%}%>>전체</option>
							<option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>검사일</option>
						</select>
                    </td>
                    <td width='200'><img src=/acar/images/center/arrow_gsgg.gif align=absmiddle>&nbsp;
                      <select name="gubun2" onChange="javascript:cng_input1()">
                        <option value="5" <%if(gubun2.equals("5")){%>selected<%}%>>당월누적</option>
                        <option value="2" <%if(gubun2.equals("2")){%>selected<%}%>>전월</option>
                        <option value="4" <%if(gubun2.equals("4")){%>selected<%}%>>기간</option>
                        <option value="1" <%if(gubun2.equals("1")){%>selected<%}%>>검색</option>
                      </select>
                    </td>

                    <td align="left" width="200"> 
                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td id='td_dt' <%if(gubun2.equals("4")){%>style="display:''"<%}else{%>style='display:none'<%}%>> 
                            <input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                            ~ 
                            <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
                          </td>
                        </tr>
                      </table>
                    </td>
                </tr>
                <tr> 
                    <td width="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
                      <select name='s_kd' >
                        <option value='0' <%if(s_kd.equals("0")){%> selected <%}%>>전체</option>
                    <!--    <option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>상호</option> -->
                        <option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>담당자</option>
                    
                <!--        <option value='3' <%if(s_kd.equals("3")){%> selected <%}%>>계약번호</option> -->
                        <option value='4' <%if(s_kd.equals("4")){%> selected <%}%>>차량번호</option>  
                      </select>
                    </td>
                    <td> 
                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td id='td_input' <%if(s_kd.equals("8") || s_kd.equals("6")){%> style='display:none'<%}%>> 
                            <input type='text' name='t_wd' size='21' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()'>
                          </td>
                        </tr>
                      </table>
                    </td>
                    
                    <td align="right"><a href='javascript:search()'><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>&nbsp; 
<% if( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("사고관리",user_id) || nm_db.getWorkAuthUser("과태료관리자",user_id) ){%>                    	
           <!-- 		<a href ="excel_maint.jsp" target="_blank"><img src=/acar/images/center/button_reg_mstcar.gif align=absmiddle border=0></a>&nbsp;
            			<a href ="excel_ss_maint.jsp" target="_blank"><img src=/acar/images/center/button_reg_ss.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp; -->
<%}%>            		
                    </td>
                </tr>
            </table>
        </td>
	</tr>
</table>
</form>
</body>
</html>
