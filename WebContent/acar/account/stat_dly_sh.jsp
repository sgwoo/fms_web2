<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8'){ //영업담당자
			fm.t_wd.value = fm.s_bus.options[fm.s_bus.selectedIndex].value;
		}
		if(fm.st_dt.value != ''){ fm.st_dt.value = ChangeDate3(fm.st_dt.value);	}
		if(fm.end_dt.value != ''){ fm.end_dt.value = ChangeDate3(fm.end_dt.value);	}
		fm.submit()
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	//검색1 디스플레이
	function change_gubun1(){
		var fm = document.form1;
		var gbn_idx = fm.gubun1.options[fm.gubun1.selectedIndex].value;
		drop_gubun2();
		if((gbn_idx == 0) || (gbn_idx == 4))//전체,연체
		{
			add_gubun2(0, '0', '당일');
			add_gubun2(1, '2', '기간');
		}
		if((gbn_idx == 1))//선수
		{
			add_gubun2(0, '0', '당일');
		}
		else if((gbn_idx == 2) ||(gbn_idx == 3))//수금,미수
		{
			add_gubun2(0, '3', '당일+연체');
			add_gubun2(1, '0', '당일');
			add_gubun2(2, '1', '연체');
			add_gubun2(3, '2', '기간');
		}
		if((gbn_idx == 5))//검색
		{
			add_gubun2(0, '0', '검색');
		}
		if((gbn_idx == 6))//검색
		{
			add_gubun2(0, '2', '대여료현황');
			add_gubun2(1, '0', '담당자별수금현황');				
			add_gubun2(2, '1', '담당자별연체현황');
		}
		change_gubun2();
	}
	
	function change_gubun2(){
		var fm = document.form1;
		var gbn = fm.gubun1.options[fm.gubun1.selectedIndex].value;
		var gbn_idx = fm.gubun2.options[fm.gubun2.selectedIndex].value;
		if(gbn == 6){
			if(gbn_idx == 2){
				td_blank.style.display 	= 'none';
				td_term.style.display 	= 'none';
				td_term2.style.display 	= '';
			}else{
				td_blank.style.display 	= '';
				td_term.style.display 	= 'none';
				td_term2.style.display 	= 'none';
			}
		}else{
			if(gbn_idx == 2){
				td_blank.style.display 	= 'none';
				td_term.style.display 	= '';
				td_term2.style.display 	= 'none';
			}else{
				td_blank.style.display 	= '';
				td_term.style.display 	= 'none';
				td_term2.style.display 	= 'none';
			}
		}
	}	
	
	function drop_gubun2(){
		var fm = document.form1;
		var len = fm.gubun2.length;
		for(var i = 0 ; i < len ; i++)
		{
			fm.gubun2.options[len-(i+1)] = null;
		}
	}
	
	function add_gubun2(idx, val, str){
		document.form1.gubun2[idx] = new Option(str, val);
	}	
	
	//디스플레이 타입(검색)
	function cng_input(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8'){ //영업담당자
			td_input.style.display	= 'none';
			td_bus.style.display	= '';
		}else{
			td_input.style.display	= '';
			td_bus.style.display	= 'none';
		}
	}	
//-->
</script>

<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String gubun1		= request.getParameter("gubun1")==null?"3":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"3":request.getParameter("gubun2");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 		= request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc 			= request.getParameter("asc")==null?"0":request.getParameter("asc");
	String im_dt 		= request.getParameter("im_dt")==null?"":request.getParameter("im_dt");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	Vector users = c_db.getUserList("", "", "BUS_EMP"); //영업담당자 리스트
	int user_size = users.size();	
	Vector users2 = c_db.getUserList("", "", "MNG_EMP"); //관리담당자 리스트
	int user_size2 = users2.size();	
%>
<form name='form1' action='fee_sc.jsp' target='c_body' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<!--
구분1:전체(0), 선수(1), 수금(2), 미수(3), 연체(4)
구분2:당일(0), 연체(1), 기간(2), 당일+연체(3)
-->
<table border="0" cellspacing="0" cellpadding="0" width=800>
	<tr>
		<td>
			<font color="navy">계약관리 -> </font><font color="red">대여료 관리 </font>
		</td>
	</tr>
	<tr>
		<td>			
        <table border="0" cellspacing="1" cellpadding="0" width=800>
          <tr> 
            <td width='310'> 조회구분: 
              <select name='gubun1' onChange='javascript:change_gubun1()'>
                <option value='0' <%if(gubun1.equals("0")){%>selected<%}%>>전체</option>
                <option value='1' <%if(gubun1.equals("1")){%>selected<%}%>>선수</option>
                <option value='2' <%if(gubun1.equals("2")){%>selected<%}%>>수금</option>
                <option value='3' <%if(gubun1.equals("3")){%>selected<%}%>>미수</option>
                <option value='4' <%if(gubun1.equals("4")){%>selected<%}%>>연체</option>
                <option value='5' <%if(gubun1.equals("5")){%>selected<%}%>>검색</option>
                <option value='6' <%if(gubun1.equals("6")){%>selected<%}%>>현황</option>
              </select>
              &nbsp; 상세조회: 
              <select name='gubun2' onChange='javascript:change_gubun2()'>
              </select>
            </td>
            <td width='160' id='td_term' style='display:none' align="left"> 
              <input type='text' size='11' name='st_dt' class='text'>
              ~ 
              <input type='text' size='11' name='end_dt' class='text'>
            </td>
            <td width='160' id='td_term2' style='display:none' align="left"> 
              <input type='text' size='11' name='im_dt' class='text'>&nbsp;(임의일자)
            </td>
            <td width='160' id='td_blank' align="left">&nbsp;</td>
            <td align="left" width="140"> 조건: 
              <select name='s_kd' onChange="javascript:document.form1.t_wd.value='', cng_input()">
                <option value='0' <%if(s_kd.equals("0")){%> selected <%}%>>전체</option>
                <option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>상호</option>
                <option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>고객명</option>
                <option value='3' <%if(s_kd.equals("3")){%> selected <%}%>>계약코드</option>
                <option value='4' <%if(s_kd.equals("4")){%> selected <%}%>>차량번호</option>
                <option value='5' <%if(s_kd.equals("5")){%> selected <%}%>>월대여료</option>
                <option value='6' <%if(s_kd.equals("6")){%> selected <%}%>>영업소코드</option>
                <option value='7' <%if(s_kd.equals("7")){%> selected <%}%>>사용본거지</option>
                <option value='8' <%if(s_kd.equals("8")){%> selected <%}%>>영업담당자</option>
              </select>
              &nbsp;&nbsp; </td>
            <td id='td_input' width="90" <%if(s_kd.equals("8")){%> style='display:none'<%}%> align="left"> 
              <input type='text' name='t_wd' size='12' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()'>
            </td>
            <td id='td_bus' width="90" <%if(!s_kd.equals("8")){%> style='display:none'<%}%> align="left"> 
              <select name='s_bus'>
                <option value="">미지정</option>
                <%	if(user_size > 0){
						for (int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	%>
                <option value='<%=user.get("USER_ID")%>' <%if(t_wd.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                <%		}
					}		%>
                <%	if(user_size2 > 0){
						for (int i = 0 ; i < user_size2 ; i++){
							Hashtable user2 = (Hashtable)users2.elementAt(i);	%>
                <option value='<%=user2.get("USER_ID")%>' <%if(t_wd.equals(user2.get("USER_ID"))) out.println("selected");%>><%=user2.get("USER_NM")%></option>
                <%		}
					}		%>
              </select>
            </td>
            <td align="left"><a href='javascript:search()' onMouseOver="window.status=''; return true"><img src="/images/search.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
          </tr>
          <tr> 
            <td colspan='7' align='right'>정렬조건: 
              <select name='sort_gubun' onChange='javascript:search()'>
                <option value='0' <%if(sort_gubun.equals("0")){%> selected <%}%>>입금예정일</option>
                <option value='1' <%if(sort_gubun.equals("1")){%> selected <%}%>>상호</option>
                <option value='2' <%if(sort_gubun.equals("2")){%> selected <%}%>>수금일자</option>
                <option value='3' <%if(sort_gubun.equals("3")){%> selected <%}%>>월대여료</option>
                <option value='4' <%if(sort_gubun.equals("4")){%> selected <%}%>>연체일수</option>
              </select>
              <input type='radio' name='asc' value='0' checked onClick='javascript:search()'>
              오름차순 
              <input type='radio' name='asc' value='1' onClick='javascript:search()'>
              내림차순&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
          </tr>
        </table>
		</td>
	</tr>
</table>
</form>
<script language='javascript'>
<!--
change_gubun1();
-->
</script>
</body>
</html>
