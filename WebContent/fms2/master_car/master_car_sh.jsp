<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
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
		fm.submit()
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
			if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '5'){ //검색
				fm.gubun3.options[0].selected = true;
			}				
			td_dt.style.display	 = 'none';
		}
	}		
	
						
//-->
</script>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"12":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"2":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
%>
<form name='form1' action='master_car_sc.jsp' target='c_body' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='f_list' value=''>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>긴급출동처리내역</span></span></td>
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
                    <td width='19%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jhgb.gif align=absmiddle>&nbsp;
                      <select name="gubun1" onChange="javascript:list_move()">
                      	<option value="0" <%if(gubun1.equals("1")){%>selected<%}%>>전체</option>
                        <option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>타이어교체</option>
                        <option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>배터리충전</option>
                        <option value="3" <%if(gubun1.equals("3")){%>selected<%}%>>잠금장치</option>
                        <option value="4" <%if(gubun1.equals("4")){%>selected<%}%>>비상급유</option>
                        <option value="5" <%if(gubun1.equals("5")){%>selected<%}%>>견인</option>
                        <option value="6" <%if(gubun1.equals("6")){%>selected<%}%>>기타</option>
                      </select>
                    </td>
					<td width='12%'>
                      <select name="gubun4">
                        <option value='0' <%if(gubun4.equals("0")){%> selected <%}%>>전체</option>
                        <option value='5' <%if(gubun4.equals("5")){%> selected <%}%>>애니카랜드</option>
                        <option value='1' <%if(gubun4.equals("1")){%> selected <%}%>>마스타자동차</option>
                        <option value='7' <%if(gubun4.equals("7")){%> selected <%}%>>SK네트웍스</option>
                      </select>
                    </td>
                    <td width='17%'><img src=/acar/images/center/arrow_gsgg.gif align=absmiddle>&nbsp;
                      <select name="gubun2" onChange="javascript:cng_input1()">
                        <option value="5" <%if(gubun2.equals("5")){%>selected<%}%>>당월</option>
                        <option value="2" <%if(gubun2.equals("2")){%>selected<%}%>>전월</option>
                        <option value="6" <%if(gubun2.equals("6")){%>selected<%}%>>당일+연체</option>				
                        <option value="3" <%if(gubun2.equals("3")){%>selected<%}%>>연체</option>				
                        <option value="4" <%if(gubun2.equals("4")){%>selected<%}%>>기간</option>
                        <option value="1" <%if(gubun2.equals("1")){%>selected<%}%>>검색</option>
                      </select>
                    </td>
                    <td width='12%'><img src=/acar/images/center/arrow_sbjh.gif align=absmiddle>&nbsp;
                      <select name="gubun3">
                        <option value="1" <%if(gubun3.equals("1")){%>selected<%}%>>계획</option>
                        <option value="2" <%if(gubun3.equals("2")){%>selected<%}%>>지출</option>
                        <option value="3" <%if(gubun3.equals("3")){%>selected<%}%>>미지출</option>
                      </select>
                    </td>

                    <td align="left"> 
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
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
                      <select name='s_kd' onChange="javascript:document.form1.t_wd.value='', cng_input1()">
                        <option value='0' <%if(s_kd.equals("0")){%> selected <%}%>>전체</option>
                        <option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>상호</option>
                        <option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>고객명</option>
                        <option value='7' <%if(s_kd.equals("7")){%> selected <%}%>>담당자</option>
                        <option value='3' <%if(s_kd.equals("3")){%> selected <%}%>>계약번호</option>
                        <option value='4' <%if(s_kd.equals("4")){%> selected <%}%>>차량번호</option>
                        <option value='9' <%if(s_kd.equals("9")){%> selected <%}%>>차종</option>
                        <option value='5' <%if(s_kd.equals("5")){%> selected <%}%>>금액</option>
                      </select>
                    </td>
					<td id='td_input' <%if(s_kd.equals("8") || s_kd.equals("6")){%> style='display:none'<%}%>> 
						<input type='text' name='t_wd' size='21' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
					</td>
                    <td colspan="3"><a href='javascript:search()'><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a> &nbsp;
<% if(nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("사고관리",user_id) || nm_db.getWorkAuthUser("협력업체담당",user_id)){%>                  	
            		<a href="javascript:var win=window.open('master_excel.jsp?&user_id=<%=user_id%>','popup','left=10, top=10, width=900, height=200, status=no, scrollbars=no, resizable=no');"><img src=/acar/images/center/button_reg_mstcar.gif align=absmiddle border=0></a>&nbsp;
<%}%>            		
<% if(nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("협력업체담당",user_id)){%>                  	
            		<a href="javascript:var win=window.open('master_car_cr.jsp','popup','left=10, top=10, width=500, height=200, status=no, scrollbars=no, resizable=no');"><img src=/acar/images/center/button_chgcr.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
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
