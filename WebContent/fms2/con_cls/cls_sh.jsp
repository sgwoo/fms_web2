<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8' || fm.s_kd.options[fm.s_kd.selectedIndex].value == '11'){ //영업담당자
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
	
	function search2(){
		var fm = document.form1;
		fm.action = 'cls_frame_s2.jsp';
		fm.target='d_content';
		fm.submit();
	}	
		
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
		
	//디스플레이 타입(검색) -검색조건 선택시
	function cng_input(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8' || fm.s_kd.options[fm.s_kd.selectedIndex].value == '11'){ //영업담당자
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
		else if(idx == '8') url = "/acar/con_debt/debt_frame_s.jsp";
		else if(idx == '9') url = "/acar/con_ins/ins_frame_s.jsp?f_list=now";
		else if(idx == '10') url = "/acar/forfeit_mng/forfeit_s_frame.jsp";
		else if(idx == '11') url = "/acar/commi_mng/commi_frame_s.jsp";
		else if(idx == '12') url = "/acar/mng_exp/exp_frame_s.jsp";			
		else if(idx == '13') url = "/acar/con_tax/tax_frame_s.jsp";							
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}				
//-->
</script>
</head>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style type="text/css">
.height_td {height:33px;}
select {
	width: 104px !important;
}
.input {
	height: 24px !important;
}
</style>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"6":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String rtype = request.getParameter("rtype")==null?"":request.getParameter("rtype");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	Vector users = c_db.getUserList("", "", "EMP"); //영업담당자 리스트
	int user_size = users.size();	
%>
<form name='form1' action='cls_sc.jsp' target='c_body' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100% class="search-area">
	<tr >
		<td colspan=7 style="height: 30px">
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td class="navigation">&nbsp;<span class=style1>재무회계 > 수금관리 > <span class=style5>해지 정산금 관리</span></span></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan=7  class=h></td>
	</tr>
	
	<tr>
		<td>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='19%'class="height_td" ><label><i class="fa fa-check-circle"></i> 조회구분 </label>
                      <select name="gubun1" onChange="javascript:list_move()">
                 <!--       <option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>대여료</option>
                        <option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>선수금</option>
                        <option value="3" <%if(gubun1.equals("3")){%>selected<%}%>>과태료(수)</option>
                        <option value="4" <%if(gubun1.equals("4")){%>selected<%}%>>면책금</option>
                        <option value="5" <%if(gubun1.equals("5")){%>selected<%}%>>휴/대차료</option> -->
                        <option value="6" <%if(gubun1.equals("6")){%>selected<%}%>>해지정산</option>
                   <!--     <option value="7" <%if(gubun1.equals("7")){%>selected<%}%>>미수금정산</option>
                        <option value="8" <%if(gubun1.equals("8")){%>selected<%}%>>할부금</option>
                        <option value="9" <%if(gubun1.equals("9")){%>selected<%}%>>보험료</option>
                        <option value="10" <%if(gubun1.equals("10")){%>selected<%}%>>과태료(지)</option>
                        <option value="11" <%if(gubun1.equals("11")){%>selected<%}%>>지급수수료</option>																
                        <option value="12" <%if(gubun1.equals("12")){%>selected<%}%>>기타비용</option>	
                        <option value="13" <%if(gubun1.equals("13")){%>selected<%}%>>특소세</option>		 -->																									
                      </select>
                    </td>
                    <td width='16%'><label><i class="fa fa-check-circle"></i> 상세조회 </label>
                      <select name="gubun2" onChange="javascript:cng_input1()">
                        <option value="1" <%if(gubun2.equals("1")){%>selected<%}%>>당월</option>
                        <option value="2" <%if(gubun2.equals("2")){%>selected<%}%>>당일</option>
                        <option value="6" <%if(gubun2.equals("6")){%>selected<%}%>>당일+연체</option>								
                        <option value="3" <%if(gubun2.equals("3")){%>selected<%}%>>연체</option>
                        <option value="4" <%if(gubun2.equals("4")){%>selected<%}%>>기간</option>
                        <option value="5" <%if(gubun2.equals("5")){%>selected<%}%>>검색</option>
                      </select>
                    </td>
                    <td width='16%'><label><i class="fa fa-check-circle"></i> 세부조회 </label>
                      <select name="gubun3">
                        <option value="1" <%if(gubun3.equals("1")){%>selected<%}%>>계획</option>
                        <option value="2" <%if(gubun3.equals("2")){%>selected<%}%>>수금</option>
                        <option value="3" <%if(gubun3.equals("3")){%>selected<%}%>>미수금</option>
      
                      </select>
                    </td>
                    <td align="left" width="15%"> 
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
                              <option value="2" <%if(gubun4.equals("2")){%>selected<%}%>>일반연체(1개월)</option>
                              <option value="3" <%if(gubun4.equals("3")){%>selected<%}%>>부실연체(2개월)</option>
                              <option value="4" <%if(gubun4.equals("4")){%>selected<%}%>>악성연체(3개월이상)</option>
                            </select>
                          </td>
                        </tr>
                      </table>
                    </td>
                    <td><select name="gubun5">
                        <option value=""  <%if(gubun5.equals("")){%>selected<%}%>>전체</option>
                        <option value="1" <%if(gubun5.equals("1")){%>selected<%}%>>대여료</option> 
                        <option value="2" <%if(gubun5.equals("2")){%>selected<%}%>>정산금</option>
                      </select> </td>
                </tr>
                <tr> 
                    <td class="height_td"><label><i class="fa fa-check-circle"></i> 검색조건 </label>
                      <select name='s_kd' onChange="javascript:document.form1.t_wd.value='', cng_input()">
                        <option value='0' <%if(s_kd.equals("0")){%> selected <%}%>>전체</option>
                        <option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>상호</option>
                        <option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>고객명</option>
                        <option value='3' <%if(s_kd.equals("3")){%> selected <%}%>>계약번호</option>
                        <option value='4' <%if(s_kd.equals("4")){%> selected <%}%>>차량번호</option>
                        <option value='9' <%if(s_kd.equals("9")){%> selected <%}%>>차종</option>	
                        <option value='10' <%if(s_kd.equals("10")){%> selected <%}%>>해지일자</option>				
                        <option value='5' <%if(s_kd.equals("5")){%> selected <%}%>>청구금액</option>
                   <!--     <option value='6' <%if(s_kd.equals("6")){%> selected <%}%>>영업소코드</option>
                        <option value='7' <%if(s_kd.equals("7")){%> selected <%}%>>사용본거지</option> -->
                        <option value='8' <%if(s_kd.equals("8")){%> selected <%}%>>영업담당자</option>
                        <option value='11' <%if(s_kd.equals("11")){%> selected <%}%>>관리담당자</option>				
						<option value='12' <%if(s_kd.equals("12")){%> selected <%}%>>사업자등록번호</option>
				<!--		<option value='13' <%if(s_kd.equals("13")){%> selected <%}%>>법인/생년월일</option>		 -->				
					<!--	<option value='14' <%if(s_kd.equals("14")){%> selected <%}%>>월렌트 미수금</option>	 -->
                      </select>
                    </td>
                    <td> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td id='td_input' <%if(s_kd.equals("8") || s_kd.equals("11") || s_kd.equals("6")){%> style='display:none'<%}%>> 
                                    <input type='text' name='t_wd' size='21' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()'>
                                </td>
                                <td id='td_bus' <%if(s_kd.equals("8")||s_kd.equals("11")){%> style="display:''"<%}else{%>style='display:none'<%}%>> 
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
                				<option value="000008" <%if(t_wd.equals("000008"))%>selected<%%>>김학선</option>	
                				<option value="000040" <%if(t_wd.equals("000040"))%>selected<%%>>이상근</option>
                				<option value="000016" <%if(t_wd.equals("000016"))%>selected<%%>>최윤호</option>													
                				<option value="000009" <%if(t_wd.equals("000009"))%>selected<%%>>한창숙</option>				
                				<option value="000024" <%if(t_wd.equals("000024"))%>selected<%%>>이금지</option>								
                                    </select>
                                  </td>
                                  <td id='td_brch' <%if(s_kd.equals("6")){%> style="display:''"<%}else{%>style='display:none'<%}%>> 
                			        <select name='s_brch' >
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
                    <td><label><i class="fa fa-check-circle"></i> 정렬조건 </label>
                      <select name='sort_gubun' >
                        <option value='0' <%if(sort_gubun.equals("0")){%> selected <%}%>>해지일</option>
                        <option value='1' <%if(sort_gubun.equals("1")){%> selected <%}%>>상호</option>
                        <option value='2' <%if(sort_gubun.equals("2")){%> selected <%}%>>수금일자</option>
                        <option value='3' <%if(sort_gubun.equals("3")){%> selected <%}%>>청구금액</option>
                        <option value='5' <%if(sort_gubun.equals("5")){%> selected <%}%>>미수금</option>
        <!--            <option value='4' <%if(sort_gubun.equals("4")){%> selected <%}%>>연체일수</option>-->
                      </select>
                    </td>
                    <td> 
                      <input type='radio' name='asc' value='0' <%if(asc.equals("0")){%>checked<%}%>>
                      오름차순 
                      <input type='radio' name='asc' value='1' <%if(asc.equals("1")){%>checked<%}%>>
                      내림차순 </td>                      
                      <td> 
                      <input type='radio' name='rtype' value='' <%if(rtype.equals("")){%>checked<%}%> >
                      전체 
                      <input type='radio' name='rtype' value='L' <%if(rtype.equals("L")){%>checked<%}%> >
                     장기대여 
                      <input type='radio' name='rtype' value='M' <%if(rtype.equals("M")){%>checked<%}%> >
                     월렌트 </td>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="button" class="button" value="검색" onclick="javascript:search();">                   
                    <input type="button" class="button" value="계약별" onclick="javascript:search2();">                    
                    </td>
                </tr>
            </table>
        </td>
	</tr>
</table>
</form>
</body>
</html>
