<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.beans.*, acar.ma.*, acar.cc.*"%>
<jsp:useBean id="c_db" scope="page" class="acar.ma.CodeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String car_st =  request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String car_cd =  request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	
	String s_kd =  request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	if(t_wd.equals("")) car_cd="";

%>
<html>
<head>
<title>기존차량리스트</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../include/table.css">
<script language='javascript'>
<!--
	function save(){		
		var fm = document.form1;
		var rent_mng_id = fm.rent_mng_id.value;
		var rent_l_cd = fm.rent_l_cd.value;
		var car_comp_id = fm.car_comp_id.value;
		var car_mng_id = fm.car_mng_id.value;
		var car_no = fm.car_no.value;
		var off_ls = fm.off_ls.value;
		var car_nm = fm.car_nm.value;
		var car_name = fm.car_name.value;

		if(fm.t_con_cd1.value == '')		{	alert('영업소를 선택하십시오');			return;	}
		else if(fm.t_con_cd2.value == '')	{	alert('계약년도를 선택하십시오');		return;	}
		else if(fm.t_con_cd3.value == '')	{	alert('자동차회사를 선택하십시오');		return;	}
		else if(fm.t_con_cd4.value == '')	{	alert('차종을 선택하십시오');			return;	}
		else if(fm.t_con_cd5.value == '')	{	alert('대여구분을 선택하십시오');		return;	}
		
		window.opener.form1.con_cd.value = fm.t_con_cd1.value + fm.t_con_cd2.value + fm.t_con_cd3.value + fm.t_con_cd4.value + fm.t_con_cd5.value;
		window.opener.form1.br_id.value = fm.t_con_cd1.value;
		window.opener.form1.br_nm.value = fm.slt_brch.options[fm.slt_brch.selectedIndex].text;
		window.opener.form1.s_st_nm.value = fm.s_st_nm.value;
		window.opener.form1.s_st.value = fm.s_st.value;
		window.opener.form1.dpm.value = fm.dpm.value+" cc";
		window.opener.form1.car_no.value = fm.car_no.value;
		window.opener.form1.init_reg_dt.value = fm.init_reg_dt.value;
		window.opener.form1.car_st.value	= fm.slt_car_st.value;
		window.opener.form1.car_st_nm.value = fm.slt_car_st.options[fm.slt_car_st.selectedIndex].text;
		
		fm.target='i_no';
		fm.action='./set_car_s_a.jsp?rent_mng_id='+rent_mng_id+'&rent_l_cd='+rent_l_cd+'&car_comp_id='+car_comp_id+'&car_mng_id='+car_mng_id+'&car_no='+car_no+'&car_nm='+car_nm+'&car_name='+car_name;
		fm.submit();
	}
	function select_car(rent_mng_id, rent_l_cd, car_comp_id, nm_cd, car_cd, car_mng_id, car_no, init_reg_dt, off_ls, car_nm, car_name, s_st, s_st_nm, dpm){
		var fm = document.form1;
		alert("가입된 보험을 확인하십시오.\n\n책임보험인지 종합보험인지 확인하여\n책임보험일 경우 보험해지후 종합보험에 가입하도록\n보험담당자에게 공지하여 주십시오.");
		if(off_ls != '0'){
			alert("매각 진행중인 차량입니다.\n\n오프리스에서 매각취소 하십시오.");
		}
		fm.rent_mng_id.value = rent_mng_id;
		fm.rent_l_cd.value = rent_l_cd;
		fm.car_comp_id.value = car_comp_id;
		fm.car_mng_id.value = car_mng_id;
		fm.car_no.value = car_no;
		fm.init_reg_dt.value = init_reg_dt;
		fm.off_ls.value = off_ls;
		fm.car_nm.value = car_nm;
		fm.car_name.value = car_name;
		fm.s_st.value = s_st;
		fm.s_st_nm.value = s_st_nm;
		fm.dpm.value = dpm;
		
		fm.t_con_cd3.value = nm_cd;
		fm.t_con_cd4.value = car_cd;
				
	}	
	function search(){
		document.form1.mode.value = 'AFTER';
		document.form1.submit();
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}		
	//계약코드에 영업소 코드 넣기
	function set_branch(){
		var fm = document.form1;
		var idx = fm.slt_brch.selectedIndex;
		fm.t_con_cd1.value = fm.slt_brch.options[idx].value;
	}	
	//5. 계약코드에 대여구분 코드 넣기
	function set_car_st(){
		var fm = document.form1;
		var car_st = fm.slt_car_st.options[fm.slt_car_st.selectedIndex].value;
		if(car_st == '1')	fm.t_con_cd5.value = 'R';
		if(car_st == '3')	fm.t_con_cd5.value = 'L';
	}		
-->
</script>
</head>

<body leftmargin="15" javascript="document.form1.t_wd.focus();">

<form name='form1' action='./ext_car_s.jsp' method='post'>
<input type='hidden' name='mode' value='PRE'>
<input type='hidden' name='car_st' value='<%=car_st%>'>
<input type='hidden' name='car_cd' value='<%=car_cd%>'>
<input type='hidden' name='rent_mng_id' value=''>
<input type='hidden' name='rent_l_cd' value=''>
<input type='hidden' name='car_comp_id' value=''>
<input type='hidden' name='nm_cd' value=''>
<input type='hidden' name='car_cd' value=''>
<input type='hidden' name='car_mng_id' value=''>
<input type='hidden' name='car_no' value=''>
<input type='hidden' name='init_reg_dt' value=''>
<input type='hidden' name='off_ls' value=''>
<input type='hidden' name='car_nm' value=''>
<input type='hidden' name='car_name' value=''>
<input type='hidden' name='s_st' value=''>
<input type='hidden' name='s_st_nm' value=''>
<input type='hidden' name='dpm' value=''>

  <table border="0" cellspacing="0" cellpadding="0" width=470>
    <tr> 
      <td colspan='2'><font color="#666600">- 계약번호 생성 -</font></td>
    </tr>
    <tr> 
      <td class="line" colspan='2'><table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class='title' width='20%'>영업소</td>
            <td width="80%">&nbsp; <jsp:include page="/acar/code/get_branch.jsp" flush="true"> 
              <jsp:param name="f_nm" value="slt_brch" />
              <jsp:param name="value" value="" />
              <jsp:param name="onChange" value="onChange='javascript:set_branch()'" />
              </jsp:include> </td>
          </tr>
          <tr> 
            <td class='title' width='20%'>대여구분</td>
            <td width="80%">&nbsp; 
              <jsp:include page="/acar/code/get_code.jsp" flush="true"> 
              <jsp:param name="f_nm" value="slt_car_st" />
              <jsp:param name="nm_cd" value="car_st" />
              <jsp:param name="app_st" value="Y" />
              <jsp:param name="value" value="" />
              <jsp:param name="onChange" value="onChange='javascript:set_car_st()'" />
              </jsp:include> </td>
          </tr>
          <tr> 
            <td class='title' width='20%'>계약번호</td>
            <td colspan='3'>&nbsp; <input type='text' class='text' name='t_con_cd1' size='2' value='<%if(!br_id.equals("S1")){%><%=br_id%><%}%>' readonly> 
              <input type='text' class='text' name='t_con_cd2' size='2' value='<%=Util.getDate().substring(2, 4)%>'> 
              <input type='text' class='text' name='t_con_cd3' size='1' value='' readonly> 
              <input type='text' class='text' name='t_con_cd4' size='2' readonly> 
              &nbsp;|&nbsp; <input type='text' class='text' name='t_con_cd5' size='1' readonly> 
            </td>
          </tr>
        </table></td>
    </tr>
    <tr>
      <td align='left' colspan='2'>&nbsp;</td>
    </tr>
    <tr> 
      <td align='left' colspan='2'><font color="#666600">- 보유차 조회 (재리스) -</font></td>
    </tr>
    <tr> 
      <td colspan='2'> <select name='s_kd'>
          <option value='0' <%if(s_kd.equals("0")){%> selected <%}%>>전체</option>
          <option value='1' <%if(s_kd.equals("1") || s_kd.equals("")){%> selected <%}%>>차량번호</option>
          <option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>차명</option>
        </select> <input type='text' name='t_wd' size='15' value='<%=t_wd%>' class='text' onKeyDown='javascript:enter()'> 
        <a href='javascript:search()' onMouseOver="window.status=''; return true"><img src="../images/bbs/but_search.gif" width="50" height="18" aligh="bottom" border="0"></a> 
      </td>
    </tr>
    <tr> 
      <td class='line' width='450'> <table border="0" cellspacing="1" cellpadding="0" width=450>
          <tr> 
            <td class='title' width='30'>&nbsp;</td>
            <td class='title' width='30'>연번</td>
            <td class='title' width='100'>계약번호</td>
            <td class='title' width='100'>차량번호</td>
            <td class='title'>차명</td>
          </tr>
        </table></td>
      <td width='20'>&nbsp;</td>
    </tr>
    <tr> 
      <td colspan='2'> <iframe src="./ext_car_s_in.jsp?s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&mode=<%=mode%>&car_st=<%=car_st%>&car_cd=<%=car_cd%>" name="inner" width="470" height="220" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        </iframe> </td>
    </tr>
    <tr> 
      <td colspan='2'>&nbsp;</td>
    </tr>
    <tr> 
      <td colspan='2'><div align="right"><a href="javascript:save();"><img src="../images/bbs/but_confirm.gif" width="50" height="18" aligh="absmiddle" border="0" alt="확인"></a> 
          <a href="javascript:window.close()"><img src="../images/bbs/but_close.gif" width="50" height="18" aligh="absmiddle" border="0" alt="닫기"></a></div></td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="200" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
</body>
</html>

