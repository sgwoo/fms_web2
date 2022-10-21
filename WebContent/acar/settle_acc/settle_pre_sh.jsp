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
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8' || fm.s_kd.options[fm.s_kd.selectedIndex].value == '11'){ //영업담당자or관리담당자
			fm.t_wd.value = fm.s_bus.options[fm.s_bus.selectedIndex].value;
		}
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '10'){ //대여방식
			fm.t_wd.value = fm.s_rent_st.options[fm.s_rent_st.selectedIndex].value;
		}		
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '6'){ //영업소
			fm.t_wd.value = fm.s_brch.options[fm.s_brch.selectedIndex].value;
		}				
		if(fm.st_dt.value != ''){ fm.st_dt.value = ChangeDate3(fm.st_dt.value);	}		
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '6'){ //기간(임의일자)
			fm.today.value = fm.st_dt.value;
		}
		fm.submit()
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
		
	
	//디스플레이 타입(검색)-세부조회 선택시
	function cng_input1(){
		var fm = document.form1;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '3'){ //연체
			td_dt.style.display	 = 'none';
		}else if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '6'){ //기간(임의일자)
			td_dt.style.display	 = '';
		}else{
			td_dt.style.display	 = 'none';
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
		if(idx == '1')		url = "/fms2/con_fee/fee_frame_s.jsp";
		else if(idx == '2') url = "/fms2/con_grt/grt_frame_s.jsp";
		else if(idx == '3'){
			url = "/acar/con_forfeit/forfeit_frame_s.jsp";
		}
		else if(idx == '4') url = "/acar/con_ins_m/ins_m_frame_s.jsp";
		else if(idx == '5') url = "/acar/con_ins_h/ins_h_frame_s.jsp";
		else if(idx == '6') url = "/fms2/con_cls/cls_frame_s.jsp";		
		else if(idx == '7') url = "/acar/settle_acc/settle_s_frame.jsp";	
		else if(idx == '8') url = "/acar/con_debt/debt_frame_s.jsp";
		else if(idx == '9') url = "/acar/con_ins/ins_frame_s.jsp?f_list=now";
		else if(idx == '10') url = "/acar/forfeit_mng/forfeit_s_frame.jsp";
		else if(idx == '11') url = "/acar/commi_mng/commi_frame_s.jsp";
		else if(idx == '12') url = "/acar/mng_exp/exp_frame_s.jsp";			
		else if(idx == '13') url = "/acar/con_tax/tax_frame_s.jsp";									
		if(idx == '1' || idx == '2' || idx == '3' || idx == '4' || idx == '5' | idx == '6')	fm.gubun2.value = '6';
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}				
//-->
</script>
</head>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String gubun1 = request.getParameter("gubun1")==null?"7":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"8":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String today = request.getParameter("today")==null?AddUtil.getDate():request.getParameter("today");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<form name='form1' action='settle_pre_sc.jsp' target='c_body' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<!--<input type='hidden' name='today' value='<%=today%>'>-->
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  	<tr>
		<td colspan="4">
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 수금관리 ><span class=style5>
						예비배정자 미수금정산 관리</span></span>
						</td>
						<td class=bar align=right><font color="#999999">♧ 기준일 : 
        <input type='text' size='10' name='today' class='whitetext' value='<%=today%>'></font>&nbsp;&nbsp;</td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td></td>
	</tr>
    
    <tr> 
      <td colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='19%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jhgb.gif align=absmiddle>&nbsp;
              <select name="gubun1" onChange="javascript:list_move()">
                <option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>대여료</option>
                <option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>선수금</option>
                <option value="3" <%if(gubun1.equals("3")){%>selected<%}%>>과태료(수)</option>
                <option value="4" <%if(gubun1.equals("4")){%>selected<%}%>>면책금</option>
                <option value="5" <%if(gubun1.equals("5")){%>selected<%}%>>휴/대차료</option>
                <option value="6" <%if(gubun1.equals("6")){%>selected<%}%>>중도해지</option>
                <option value="7" <%if(gubun1.equals("7")){%>selected<%}%>>미수금정산</option>
                <option value="8" <%if(gubun1.equals("8")){%>selected<%}%>>할부금</option>
                <option value="9" <%if(gubun1.equals("9")){%>selected<%}%>>보험료</option>
                <option value="10" <%if(gubun1.equals("10")){%>selected<%}%>>과태료(지)</option>
                <option value="11" <%if(gubun1.equals("11")){%>selected<%}%>>지급수수료</option>																
                <option value="12" <%if(gubun1.equals("12")){%>selected<%}%>>기타비용</option>	
                <option value="13" <%if(gubun1.equals("13")){%>selected<%}%>>특소세</option>																											
              </select>
              &nbsp; </td>
            <td width='27%'><img src=/acar/images/center/arrow_ssjh.gif align=absmiddle>&nbsp;
              <select name="gubun2" onChange="javascript:cng_input1()">
                <option value="2" <%if(gubun2.equals("2")){%>selected<%}%>>당일</option>
                <option value="6" <%if(gubun2.equals("6")){%>selected<%}%>>임의일자</option>                
              </select>
              &nbsp; 
              <select name="gubun4">
                <option value="" <%if(gubun4.equals("")){%>selected<%}%>>전체</option>
                <option value="1" <%if(gubun4.equals("1")){%>selected<%}%>>대여료</option>
                <option value="2" <%if(gubun4.equals("2")){%>selected<%}%>>선수금</option>
                <option value="3" <%if(gubun4.equals("3")){%>selected<%}%>>과태료</option>
                <option value="4" <%if(gubun4.equals("4")){%>selected<%}%>>면책금</option>
                <option value="5" <%if(gubun4.equals("5")){%>selected<%}%>>휴/대차료</option>
                <option value="6" <%if(gubun4.equals("6")){%>selected<%}%>>중도해지위약금</option>
                <option value="7" <%if(gubun4.equals("7")){%>selected<%}%>>단기요금</option>				
              </select>
            </td>
            <td width='16%'><img src=/acar/images/center/arrow_sbjh.gif align=absmiddle>&nbsp;
              <select name="gubun3">                
                <option value="3" <%if(gubun3.equals("3")){%>selected<%}%>>미수금</option>                
              </select>
            </td>
            <td align="left" width="100"> 
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td id='td_dt' <%if(gubun2.equals("4")){%>style="display:''"<%}else{%>style='display:none'<%}%>> 
                    <input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                    
                  </td>
                </tr>
              </table>
            </td>
            <td>&nbsp; </td>
          </tr>
          <tr> 
            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
              <select name='s_kd' onChange="javascript:document.form1.t_wd.value=''">
                <option value='0' <%if(s_kd.equals("0")){%> selected <%}%>>전체</option>
                <option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>상호</option>
                <option value='4' <%if(s_kd.equals("4")){%> selected <%}%>>차량번호</option>
                <option value='8' <%if(s_kd.equals("8")){%> selected <%}%>>예비배정자</option>
              </select>
            </td>
            <td> 
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td> 
                    <input type='text' name='t_wd' size='12' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()'>
                  </td>                  
                  <td> 
                    <select name='s_rent_st'>
                      <option value="1" <%if(t_wd.equals("1"))%>selected<%%>>일반식</option>
                      <option value="2" <%if(t_wd.equals("2"))%>selected<%%>>맞춤식</option>
                      <option value="3" <%if(t_wd.equals("3"))%>selected<%%>>기본식</option>
                    </select>
                  </td>
                  <td> 
			        <select name='s_brch'>
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
            <td align='right'><a href='javascript:search()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a> 
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
</body>
</html>
