<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8'){ //담당자
			fm.t_wd.value = fm.s_bus.options[fm.s_bus.selectedIndex].value;
		}
		fm.submit()
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
		
	//디스플레이 타입(검색) -검색조건 선택시
	function cng_input(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8'){ //담당자
			td_input.style.display	= 'none';
			td_bus.style.display	= '';
		}else{
			td_input.style.display	= '';
			td_bus.style.display	= 'none';
		}
	}	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' action='forfeit_r_sc.jsp' target='c_foot' method='post'>
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;고객지원 > 과태료관리 > <span class=style1><span class=style5>대차회수차량과태료</span></span></td>
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
                    <td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_ssjh.gif align=absmiddle>&nbsp;
                          <select name="gubun1">
                            <option value="" >전체</option>
                            <option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>고객과실</option>
                            <!--<option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>업무상과실</option>-->
                          </select>
                    </td>
                    <td colspan="2"><img src=/acar/images/center/arrow_sbjh.gif align=absmiddle>&nbsp;
                          <select name="gubun2">
                            <option value="" >전체</option>
            			    <option value="1" <%if(gubun2.equals("1")){%>selected<%}%>>납부자변경</option>
            			    <option value="2" <%if(gubun2.equals("2")){%>selected<%}%>>고객납입</option>
                            <option value="3" <%if(gubun2.equals("3")){%>selected<%}%>>회사대납</option>
            			    <option value="4" <%if(gubun2.equals("4")){%>selected<%}%>>수금납입</option>
							<option value="5" <%if(gubun4.equals("5")){%>selected<%}%>>납부자변경제외</option>
                          </select>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td width='16%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
                          <select name='s_kd' onChange="javascript:document.form1.t_wd.value='', cng_input()">
                            <option value="" >선택</option>
                            <option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>차량번호</option>
                            <option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>위반일자</option>
                            <option value='3' <%if(s_kd.equals("3")){%> selected <%}%>>위반장소</option>
                            <option value='4' <%if(s_kd.equals("4")){%> selected <%}%>>위반내용</option>				
                            <option value='5' <%if(s_kd.equals("5")){%> selected <%}%>>고지서번호</option>																
                            <option value='6' <%if(s_kd.equals("6")){%> selected <%}%>>청구기관</option>					
                            <option value='7' <%if(s_kd.equals("7")){%> selected <%}%>>과태료</option>
                            <option value='8' <%if(s_kd.equals("8")){%> selected <%}%>>담당자</option>
                          </select>
                    </td>
                    <td width='15%'> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                  <td id='td_input' <%if(s_kd.equals("8")){%> style='display:none'<%}%>> 
                                    <input type='text' name='t_wd' size='21' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()'>
                                  </td>
                                  <td id='td_bus' <%if(s_kd.equals("8")){%> style="display:''"<%}else{%>style='display:none'<%}%>> 
                                    <select name='s_bus'>
                                    	  <option value="">미지정</option>
                                         <%if(user_size > 0){
                								for(int i = 0 ; i < user_size ; i++){
                									Hashtable user = (Hashtable)users.elementAt(i); 
                							%>
                							  <option value='<%=user.get("USER_ID")%>' <%if(t_wd.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                			                <%	}
                							}		%>
                                      </select> </td>
                            </tr>
                        </table>
                    </td>
                    <td width='13%'><img src=/acar/images/center/arrow_jrjg.gif align=absmiddle>&nbsp;
                          <select name='sort_gubun'>
                            <option value='1' <%if(sort_gubun.equals("1")){%> selected <%}%>>위반일자</option>
                            <option value='2' <%if(sort_gubun.equals("2")){%> selected <%}%>>수금일자</option>
                            <option value='3' <%if(sort_gubun.equals("3")){%> selected <%}%>>납부기한</option>							
                            <option value='4' <%if(sort_gubun.equals("4")){%> selected <%}%>>차량번호</option>
                            <option value='5' <%if(sort_gubun.equals("5")){%> selected <%}%>>청구기관</option>
                            <option value='6' <%if(sort_gubun.equals("6")){%> selected <%}%>>담당자</option>							
                          </select>
                    </td>
                    <td width='15%'> 
                        <input type='radio' name='asc' value='0' <%if(asc.equals("0")){%> checked <%}%>>
                        오름차순 
                        <input type='radio' name='asc' value='1' <%if(asc.equals("1")){%> checked <%}%>>
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
