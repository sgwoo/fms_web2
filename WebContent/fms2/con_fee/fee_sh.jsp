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
		if(fm.st_dt.value != ''){ fm.st_dt.value = ChangeDate3(fm.st_dt.value);	}
		if(fm.end_dt.value != ''){ fm.end_dt.value = ChangeDate3(fm.end_dt.value);	}
		if(fm.st_dt.value !='' && fm.end_dt.value==''){ fm.end_dt.value = fm.st_dt.value; }
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
		if(idx == '1') 		url = "/fms2/con_fee/fee_frame_s.jsp";
		else if(idx == '2') url = "/fms2/con_grt/grt_frame_s.jsp";
		else if(idx == '3') url = "/acar/con_forfeit/forfeit_frame_s.jsp";
		else if(idx == '4') url = "/fms2/con_ins_m/ins_m_frame_s.jsp";
		else if(idx == '5') url = "/fms2/con_ins_h/ins_h_frame_s.jsp";
		else if(idx == '6') url = "/fms2/con_cls/cls_frame_s.jsp";		
		else if(idx == '7') url = "/acar/settle_acc/settle_s_frame.jsp";	
		else if(idx == '8') url = "/acar/con_debt/debt_frame_s.jsp?f_list=now";
		else if(idx == '9') url = "/acar/con_ins/ins_frame_s.jsp";
		else if(idx == '10') url = "/acar/forfeit_mng/forfeit_s_frame.jsp";
		else if(idx == '11') url = "/acar/commi_mng/commi_frame_s.jsp";
		else if(idx == '12') url = "/acar/mng_exp/exp_frame_s.jsp";			
		else if(idx == '13') url = "/acar/con_tax/tax_frame_s.jsp";					
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}	
	
	//계약별리스트 이동
	function search1()
	{
		var fm = document.form1;
		var url = "";
		fm.auth_rw.value = "";		
		fm.gubun4.value = "";		
	
	         url= "/fms2/arrear/arrear_frame_s.jsp";
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}					
					
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"6":request.getParameter("gubun2");
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
<form name='form1' action='fee_sc.jsp' target='c_body' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 수금관리 > <span class=style5>대여료 관리</span></span></td>
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
                    <td width=''>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jhgb.gif align=absmiddle>&nbsp;
                      <select name="gubun1" onChange="javascript:list_move()">
                        <option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>대여료</option>
                        <option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>선수금</option>
                        <option value="3" <%if(gubun1.equals("3")){%>selected<%}%>>과태료(수)</option>
                        <option value="4" <%if(gubun1.equals("4")){%>selected<%}%>>면책금</option>
                        <option value="5" <%if(gubun1.equals("5")){%>selected<%}%>>휴/대차료</option>
                        <option value="6" <%if(gubun1.equals("6")){%>selected<%}%>>해지정산</option>
                        <option value="7" <%if(gubun1.equals("7")){%>selected<%}%>>미수금정산</option>
                        <option value="8" <%if(gubun1.equals("8")){%>selected<%}%>>할부금</option>
                        <option value="9" <%if(gubun1.equals("9")){%>selected<%}%>>보험료</option>
                        <option value="10" <%if(gubun1.equals("10")){%>selected<%}%>>과태료(지)</option>
                        <option value="11" <%if(gubun1.equals("11")){%>selected<%}%>>지급수수료</option>																
                        <option value="12" <%if(gubun1.equals("12")){%>selected<%}%>>기타비용</option>
                        <option value="13" <%if(gubun1.equals("13")){%>selected<%}%>>특소세</option>				
                      </select>
                      &nbsp; </td>
                    <td width=''><img src=/acar/images/center/arrow_ssjh.gif align=absmiddle>&nbsp;
                      <select name="gubun2" onChange="javascript:cng_input1()">
                        <option value="1" <%if(gubun2.equals("1")){%>selected<%}%>>당월</option>
                        <option value="2" <%if(gubun2.equals("2")){%>selected<%}%>>당일</option>
                        <option value="6" <%if(gubun2.equals("6")){%>selected<%}%>>당일+연체</option>				
                        <option value="3" <%if(gubun2.equals("3")){%>selected<%}%>>연체</option>
                        <option value="4" <%if(gubun2.equals("4")){%>selected<%}%>>기간</option>
                        <option value="5" <%if(gubun2.equals("5")){%>selected<%}%>>검색</option>
                      </select>
                    </td>
                    <td width=''><img src=/acar/images/center/arrow_sbjh.gif align=absmiddle>&nbsp;
                      <select name="gubun3">
                        <option value="1" <%if(gubun3.equals("1")){%>selected<%}%>>계획</option>
                        <option value="2" <%if(gubun3.equals("2")){%>selected<%}%>>수금</option>
                        <option value="3" <%if(gubun3.equals("3")){%>selected<%}%>>미수금</option>
                      </select>
                    </td>
                    <td align="left" width=""> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                  <td id='td_dt' <%if(gubun2.equals("4")){%>style="display:''"<%}else{%>style='display:none'<%}%>> 
                                    <input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                                    ~ 
                                    <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
                                  </td>
                                  <td id='td_ec' <%if(gubun2.equals("3")){%>style="display:''"<%}else{%>style='display:none'<%}%>> 
                                    <select name="gubun4">
                                      <option value="1" <%if(gubun4.equals("1")){%>selected<%}%>>전체</option>
                                      <option value="2" <%if(gubun4.equals("2")){%>selected<%}%>>일반연체(1개월이내)</option>
                                      <option value="3" <%if(gubun4.equals("3")){%>selected<%}%>>부실연체(1~2개월이내)</option>
                                      <option value="4" <%if(gubun4.equals("4")){%>selected<%}%>>악성연체(2개월이상)</option>
                                    </select>
                                  </td>
                            </tr>
                        </table>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
                      <select name='s_kd' onChange="javascript:document.form1.t_wd.value='', cng_input()">
                        <option value='0' <%if(s_kd.equals("0")){%> selected <%}%>>전체</option>
                        <option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>상호</option>
                        <option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>고객명</option>
                        <option value='3' <%if(s_kd.equals("3")){%> selected <%}%>>계약번호</option>
                        <option value='4' <%if(s_kd.equals("4")){%> selected <%}%>>차량번호</option>
                        <option value='9' <%if(s_kd.equals("9")){%> selected <%}%>>차종</option>				
                        <option value='5' <%if(s_kd.equals("5")){%> selected <%}%>>월대여료</option>
                        <option value='6' <%if(s_kd.equals("6")){%> selected <%}%>>영업소코드</option>
                        <option value='7' <%if(s_kd.equals("7")){%> selected <%}%>>사용본거지</option>
                        <option value='8' <%if(s_kd.equals("8")){%> selected <%}%>>영업담당자</option>
                        <option value='10' <%if(s_kd.equals("10")){%> selected <%}%>>최초영업자</option>				
                      </select>
                      </td>
                    <td> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td id='td_input' <%if(s_kd.equals("8") || s_kd.equals("6") || s_kd.equals("10")){%> style='display:none'<%}%>> 
                                <input type='text' name='t_wd' size='21' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
                              </td>
                              <td id='td_bus' <%if(s_kd.equals("8") || s_kd.equals("10")){%> style="display:''"<%}else{%>style='display:none'<%}%>> 
                                <select name='s_bus'>
                                  <option value="">미지정</option>
                                  <%if(user_size > 0){
            							for (int i = 0 ; i < user_size ; i++){
            								Hashtable user = (Hashtable)users.elementAt(i);	%>
                                  <option value='<%=user.get("USER_ID")%>' <%if(t_wd.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                                  <%	}
            						}%>
            		 		 	  <option value="">=퇴사자=</option>
            			          <%if(user_size2 > 0){
            							for (int i = 0 ; i < user_size2 ; i++){
            								Hashtable user2 = (Hashtable)users2.elementAt(i);	%>
            			          <option value='<%=user2.get("USER_ID")%>' <%if(t_wd.equals(user2.get("USER_ID"))) out.println("selected");%>><%=user2.get("USER_NM")%></option>
            			          <%	}
            						}%>
            					  <option value="000041" <%if(t_wd.equals("000041"))%>selected<%%>>OTO</option>				
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
            			          <%	}
            						}%>
            			        </select>
                              </td>				  
                            </tr>
                          </table>
                    </td>
                    <td><img src=/acar/images/center/arrow_jrjg.gif align=absmiddle>&nbsp;
                      <select name='sort_gubun' onChange='javascript:search()'>
                        <option value='0' <%if(sort_gubun.equals("0")){%> selected <%}%>>입금예정일</option>
                        <option value='1' <%if(sort_gubun.equals("1")){%> selected <%}%>>상호</option>
                        <option value='2' <%if(sort_gubun.equals("2")){%> selected <%}%>>수금일자</option>
                        <option value='3' <%if(sort_gubun.equals("3")){%> selected <%}%>>월대여료</option>
                        <option value='4' <%if(sort_gubun.equals("4")){%> selected <%}%>>연체일수</option>
                        <option value='5' <%if(sort_gubun.equals("5")){%> selected <%}%>>차량번호</option>				
                      </select>
                    </td>
                    <td> 
                      <input type='radio' name='asc' value='0' checked onClick='javascript:search()'>
                      오름차순 
                      <input type='radio' name='asc' value='1' onClick='javascript:search()'>
                      내림차순 </td>
                    <td><a href="javascript:search()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a> 
                    </td>
                    <td><a href="javascript:search1()"><img src=/acar/images/center/button_gyb.gif border=0 align=absmiddle></a></td> 
                </tr>
            </table>
        </td>
	</tr>
</table>
</form>
</body>
</html>
