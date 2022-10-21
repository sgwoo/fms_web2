<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8' || fm.s_kd.options[fm.s_kd.selectedIndex].value == '10'){ //영업담당자
			fm.t_wd.value = fm.s_bus.options[fm.s_bus.selectedIndex].value;
		}
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '6'){ //영업소
			fm.t_wd.value = fm.s_brch.options[fm.s_brch.selectedIndex].value;
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
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8' || fm.s_kd.options[fm.s_kd.selectedIndex].value == '10'){ //영업담당자
			td_input.style.display	= 'none';
			td_bus.style.display	= '';
			td_brch.style.display	= 'none';			
		}else if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '6'){ //영업소
			td_input.style.display	= 'none';
			td_bus.style.display	= 'none';			
			td_brch.style.display	= '';						
		}else{
			td_input.style.display	= '';
			td_bus.style.display	= 'none';
			td_brch.style.display	= 'none';						
		}
	}	
	//디스플레이 타입(검색)-세부조회 선택시
	function cng_input1(){
		var fm = document.form1;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '3'){ //연체
			td_dt.style.display	 = 'none';
			td_ec.style.display = '';
		}else if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '4'){ //기간
			td_dt.style.display	 = '';
			td_ec.style.display = 'none';
		}else{
			if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '5'){ //검색
				fm.gubun3.options[0].selected = true;
			}				
			td_dt.style.display	 = 'none';
			td_ec.style.display = 'none';
		}
	}		
	
	//수금 스케줄 리스트 이동
	function list_move()
	{
		var fm = document.form1;
		var url = "";
		fm.auth_rw.value = "";		
		fm.gubun4.value = "";		
		var idx = fm.gubun1.options[fm.gubun1.selectedIndex].value;
		if(idx == '1') 		url = "/acar/arrear/get_frame_s.jsp";
		else if(idx == '2') url = "/acar/arrear/grt_frame_s.jsp";
		else if(idx == '3') url = "/acar/arrear/forfeit_frame_s.jsp";
		else if(idx == '4') url = "/acar/arrear/ins_m_frame_s.jsp";
		else if(idx == '5') url = "/acar/arrear/ins_h_frame_s.jsp";
		else if(idx == '6') url = "/acar/arrear/cls_frame_s.jsp";		
		else if(idx == '7') url = "/acar/arrear/get_frame_s.jsp";	
		
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}					
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"3":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"3":request.getParameter("gubun4");
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
<form name='form1' action='get_sc.jsp' target='c_body' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='gubun2' value='3'>
<input type='hidden' name='gubun3' value='3'>
<input type='hidden' name='gubun4' value='3'>
<table border="0" cellspacing="0" cellpadding="0" width=800>
	<tr>
		<td>
			<font color="navy">채권관리 -> 연체관리 -> </font><font color="red">채권추심현황 </font>
		</td>
	</tr>
	<tr>
		<td>			
        <table border="0" cellspacing="1" cellpadding="0" width=800>
        
          <tr> 
              <td width='180'> 검색조건: 
              <select name='s_kd' onChange="javascript:document.form1.t_wd.value='', cng_input()">
                <option value='0' <%if(s_kd.equals("0")){%> selected <%}%>>전체</option>
                <option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>상호</option>
                <option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>고객명</option>
                <option value='3' <%if(s_kd.equals("3")){%> selected <%}%>>계약번호</option>
                <option value='4' <%if(s_kd.equals("4")){%> selected <%}%>>차량번호</option>
                <option value='8' <%if(s_kd.equals("8")){%> selected <%}%>>영업담당자</option>
            			
              </select>
              &nbsp; </td>
             <td> 
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td id='td_input' <%if(s_kd.equals("8") || s_kd.equals("6") || s_kd.equals("10")){%> style='display:none'<%}%>> 
                    <input type='text' name='t_wd' size='12' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
                  </td>
                  <td id='td_bus' <%if(s_kd.equals("8") || s_kd.equals("10")){%> style="display:''"<%}else{%>style='display:none'<%}%>> 
                    <select name='s_bus'>
                      <option value="">미지정</option>
                      <%	if(user_size > 0){
						for (int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	%>
                      <option value='<%=user.get("USER_ID")%>' <%if(t_wd.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                      <%		}
					}		%>
					  <option value="000041" <%if(t_wd.equals("000041"))%>selected<%%>>OTO</option>	
				      <option value="">=퇴사자=</option>
			          <%if(user_size2 > 0){
							for (int i = 0 ; i < user_size2 ; i++){
								Hashtable user2 = (Hashtable)users2.elementAt(i);	%>
			          <option value='<%=user2.get("USER_ID")%>' <%if(t_wd.equals(user2.get("USER_ID"))) out.println("selected");%>><%=user2.get("USER_NM")%></option>
			          <%	}
						}%>
					
                    </select>
                  </td>
                  <td id='td_brch' <%if(s_kd.equals("6")){%> style="display:''"<%}else{%>style='display:none'<%}%>> 
			        <select name='s_brch' onChange='javascript:search();'>
			          <option value=''>전체</option>
			          <%Vector branches = c_db.getBranchList(); //영업소 리스트 조회
						int brch_size = branches.size();					  
					  	if(brch_size > 0){
								for (int i = 0 ; i < brch_size ; i++){
									Hashtable branch = (Hashtable)branches.elementAt(i);%>
			          <option value='<%= branch.get("BR_ID") %>'  <%if(t_wd.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> 
			          <%= branch.get("BR_NM")%> </option>
			          <%		}
							}		%>
			        </select>
                  </td>				  
                </tr>
              </table>
            </td>
                     
            <td align='right'><a href='javascript:search()' onMouseOver="window.status=''; return true"><img src="/images/search.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
            </td>
          </tr>
        </table>
      </td>
	</tr>
</table>
</form>
</body>
</html>
