<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"4":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	Vector users = c_db.getUserList("", "", "EMP"); //영업담당자 리스트
	int user_size = users.size();	
	Vector users2 = c_db.getUserList("9999", "", "", "N"); //퇴사자 리스트
	int user_size2 = users2.size();
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '5'){ //영업담당자
			fm.t_wd.value = fm.s_bus.options[fm.s_bus.selectedIndex].value;
		}
		if(fm.st_dt.value != '')			{ fm.st_dt.value 	= ChangeDate3(fm.st_dt.value);	}
		if(fm.end_dt.value != '')			{ fm.end_dt.value 	= ChangeDate3(fm.end_dt.value);	}
		if(fm.st_dt.value !='' && fm.end_dt.value=='')	{ fm.end_dt.value 	= fm.st_dt.value; 		}		
		fm.submit();
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
		
	//디스플레이 타입(검색) -검색조건 선택시
	function cng_input(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '5'){ //영업담당자
			td_input.style.display	= 'none';
			td_bus.style.display	= '';
			td_brch.style.display	= 'none';			
		}else{
			td_input.style.display	= '';
			td_bus.style.display	= 'none';
			td_brch.style.display	= 'none';						
		}
	}	
	//디스플레이 타입(검색)-세부조회 선택시
	function cng_input1(){
		var fm = document.form1;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '4'){ //기간
			td_dt.style.display	= '';		
		}else{
			if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '5'){ //검색
				fm.gubun3.options[0].selected = true;
			}				
			td_dt.style.display	= 'none';		
		}
	}							
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>

<form name='form1' action='con_s_rent2_sc.jsp' target='c_body' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 수금관리 > <span class=style5>정비대차 관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<tr>
		<td>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='19%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jhgb.gif align=absmiddle>&nbsp;
                      <select name="gubun1" onChange="javascript:list_move()">
                        <option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>기본식정비대차</option>                        																											
                      </select>
                    </td>
                    <td width='16%'><img src=/acar/images/center/arrow_ssjh.gif align=absmiddle>&nbsp;
                      <select name="gubun2" onChange="javascript:cng_input1()">
                        <option value="1" <%if(gubun2.equals("1")){%>selected<%}%>>당월</option>
                        <option value="2" <%if(gubun2.equals("2")){%>selected<%}%>>당일</option>
                        <option value="6" <%if(gubun2.equals("6")){%>selected<%}%>>당일+연체</option>				
                        <option value="3" <%if(gubun2.equals("3")){%>selected<%}%>>연체</option>
                        <option value="4" <%if(gubun2.equals("4")){%>selected<%}%>>기간</option>
                        <option value="5" <%if(gubun2.equals("5")){%>selected<%}%>>검색</option>
                      </select>
                    </td>
                    <td width='14%'><img src=/acar/images/center/arrow_sbjh.gif align=absmiddle>&nbsp;
                      <select name="gubun3">
                        <option value="1" <%if(gubun3.equals("1")){%>selected<%}%>>계획</option>
                        <option value="2" <%if(gubun3.equals("2")){%>selected<%}%>>수금</option>
                        <option value="3" <%if(gubun3.equals("3")){%>selected<%}%>>미수금</option>        
                      </select>
                    </td>
                    <td align="left" width="16%"> 
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
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
                      <select name='s_kd' onChange="javascript:document.form1.t_wd.value='', cng_input()">                        
                        <option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>상호</option>                        
                        <option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>계약번호</option>
                        <option value='3' <%if(s_kd.equals("3")){%> selected <%}%>>정비차량번호</option>
                        <option value='4' <%if(s_kd.equals("4")){%> selected <%}%>>대차차량번호</option>
                        <option value='5' <%if(s_kd.equals("5")){%> selected <%}%>>영업담당자</option>				
                      </select>
                      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
                    <td> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td id='td_input' <%if(s_kd.equals("5")){%> style='display:none'<%}%>> 
                                <input type='text' name='t_wd' size='21' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()'>
                              </td>
                              <td id='td_bus' <%if(s_kd.equals("5")){%> style="display:''"<%}else{%>style='display:none'<%}%>> 
                                <select name='s_bus'>
                                  <option value="">미지정</option>
                                  <%	if(user_size > 0){
            						for (int i = 0 ; i < user_size ; i++){
            							Hashtable user = (Hashtable)users.elementAt(i);	%>
                                  <option value='<%=user.get("USER_ID")%>' <%if(t_wd.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                                  <%		}
            					}		%>
            		  <option value="">=퇴사자=</option>
                      <%if(user_size2 > 0){
            				for (int i = 0 ; i < user_size2 ; i++){
            					Hashtable user2 = (Hashtable)users2.elementAt(i);	%>
                      <option value='<%=user2.get("USER_ID")%>' <%if(t_wd.equals(user2.get("USER_ID"))) out.println("selected");%>><%=user2.get("USER_NM")%></option>
                      <%	}
            			}%>
                                </select>
                              </td>                             	  					  
                            </tr>
                        </table>
                    </td>
                    <td><img src=/acar/images/center/arrow_jrjg.gif align=absmiddle>&nbsp;
                      <select name='sort_gubun' onChange='javascript:search()'>
                        <option value='1' <%if(sort_gubun.equals("1")){%> selected <%}%>>입금예정일</option>
                        <option value='2' <%if(sort_gubun.equals("2")){%> selected <%}%>>수금일자</option>
                        <option value='3' <%if(sort_gubun.equals("3")){%> selected <%}%>>상호</option>                       
                      </select>
                    </td>
                    <td> 
                      <input type='radio' name='asc' value='0' checked onClick='javascript:search()'>
                      오름차순 
                      <input type='radio' name='asc' value='1' onClick='javascript:search()'>
                      내림차순 </td>
                    <td><a href='javascript:search()'><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
                    </td>
                </tr>
            </table>
        </td>
	</tr>
</table>
</form>
</body>
</html>
