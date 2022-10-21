<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.beans.*, acar.ma.*, acar.cc.*"%>
<jsp:useBean id="c_db" scope="page" class="acar.ma.CodeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String reg = request.getParameter("reg")==null?"1":request.getParameter("reg");//신차1
	
	String year = AddUtil.getDate().substring(2,4);//현재연도
	int car_size = 0;
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>계약번호 생성</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../include/table.css">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/*신규등록시---------------------------------------------------------------------------------------------------------------------*/
	
	//1. 계약코드에 영업소 코드 넣기
	function set_branch(){
		var fm = document.form1;
		var idx = fm.slt_brch.selectedIndex;
		fm.t_con_cd1.value = fm.slt_brch.options[idx].value;
	}
		
	//2. 계약코드에 자동차회사 코드 넣고 차종 리스트 가져오기
	function change_car_com(){
		var fm = document.form1;
		var tot_str = fm.slt_car_com.options[fm.slt_car_com.selectedIndex].value;
		var com_id = tot_str.substring(0,4);
		var com_id_nm = tot_str.substring(4,5);
		var com_name = tot_str.substring(5);	
		fm.t_con_cd3.value = com_id_nm;
		fm.com_id.value = com_id;
		fm.com_nm.value = com_name;
		drop_car_nm();		
		if(tot_str == ''){
			fm.slt_car_nm.options[0] = new Option('선택', '');
			return;
		}else{
			fm.target='i_no';
			fm.action='get_car_comp_id_nodisplay.jsp?com_id='+com_id;
			fm.submit();
		}
	}
	function drop_car_nm(){
		var fm = document.form1;
		var car_len = fm.slt_car_nm.length;
		for(var i = 0 ; i < car_len ; i++){
			fm.slt_car_nm.options[car_len-(i+1)] = null;
		}
	}		
	function add_car_nm(idx, val, str){
		document.form1.slt_car_nm[idx] = new Option(str, val);		
	}

	//3. 계약코드에 차종 코드 넣고 차명 리스트 가져오기
	function change_car_nm(){
		var fm = document.form1;
		fm.com_id.value = fm.slt_car_com.options[fm.slt_car_com.selectedIndex].value.substring(0,4);
		fm.code.value = fm.slt_car_nm.options[fm.slt_car_nm.selectedIndex].value;
		fm.car_nm.value = fm.slt_car_nm.options[fm.slt_car_nm.selectedIndex].text;
		fm.t_con_cd4.value = fm.code.value;
		drop_car_name();		
		if(fm.code.value == ''){
			fm.slt_car_name.options[0] = new Option('선택', '');
			return;
		}else{			
			fm.target='i_no';
			fm.action='get_car_id_nodisplay.jsp?com_id='+fm.com_id.value+'&code='+fm.code.value;
			fm.submit();
		}
	}		
	function drop_car_name(){
		var fm = document.form1;
		var car_len = fm.slt_car_name.length;
		for(var i = 0 ; i < car_len ; i++){
			fm.slt_car_name.options[car_len-(i+1)] = null;
		}
	}		
	function add_car_name(idx, val, str){
		document.form1.slt_car_name[idx] = new Option(str, val+','+str);		
	}		
	
	//4. 계약코드에 대여구분 코드 넣기
	function set_car_name(){
		var fm = document.form1;
		var car_name_value = fm.slt_car_name.options[fm.slt_car_name.selectedIndex].value;
		var car_name_value_split = car_name_value.split(",");
		fm.car_name.value = car_name_value_split[6];
	}	
	
	//5. 계약코드에 대여구분 코드 넣기
	function set_car_st(){
		var fm = document.form1;
		var car_st = fm.slt_car_st.options[fm.slt_car_st.selectedIndex].value;
		if(car_st == '1')	fm.t_con_cd5.value = 'R';
		if(car_st == '3')	fm.t_con_cd5.value = 'L';
	}	
		
	//계약코드 생성후 선택
	function save(){
		var fm = document.form1;
		var pfm = window.opener.form1;
		
		if(fm.t_con_cd1.value == '')		{	alert('영업소를 선택하십시오');			return;	}
		else if(fm.t_con_cd2.value == '')	{	alert('계약년도를 선택하십시오');		return;	}
		else if(fm.t_con_cd3.value == '')	{	alert('자동차회사를 선택하십시오');		return;	}
		else if(fm.t_con_cd4.value == '')	{	alert('차종을 선택하십시오');			return;	}
		else if(fm.t_con_cd5.value == '')	{	alert('대여구분을 선택하십시오');		return;	}

		pfm.con_cd.value 		= fm.t_con_cd1.value + fm.t_con_cd2.value + fm.t_con_cd3.value + fm.t_con_cd4.value + fm.t_con_cd5.value;
		pfm.br_id.value 		= fm.t_con_cd1.value;
		pfm.br_nm.value 		= fm.slt_brch.options[fm.slt_brch.selectedIndex].text;
		pfm.car_comp_id.value 	= fm.com_id.value ;
		pfm.car_comp_nm.value 	= fm.com_nm.value ;
		pfm.car_nm.value 		= fm.car_nm.value ;
		var car_name_value 		= fm.slt_car_name.options[fm.slt_car_name.selectedIndex].value;
		var car_name_value_split = car_name_value.split(",");
		pfm.car_id.value 		= car_name_value_split[0];
		pfm.car_cd.value 		= car_name_value_split[1];		
		pfm.car_seq.value 		= car_name_value_split[2];
		pfm.car_name.value 		= car_name_value_split[7];
		pfm.s_st.value 			= car_name_value_split[4];
		pfm.s_st_nm.value 		= car_name_value_split[5];
		pfm.dpm.value 			= car_name_value_split[6];
		//차량가격
		var car_amt 			= car_name_value_split[3];
		pfm.car_c_amt.value 	= parseDecimal(toInt(car_amt));
		pfm.car_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(car_amt))));
		pfm.car_cv_amt.value 	= parseDecimal(toInt(parseDigit(car_amt)) - toInt(parseDigit(pfm.car_cs_amt.value)));
		pfm.car_st.value 		= fm.slt_car_st.value;
		pfm.car_st_nm.value 	= fm.slt_car_st.options[fm.slt_car_st.selectedIndex].text;
		
		if(fm.slt_car_st.value == '1'){
			pfm.purc_gu.value = '0';
			window.opener.tot_f.style.display = '';			
		}else if(fm.slt_car_st.value == '3'){
			pfm.purc_gu.value = '1';
		}
		
		if(fm.slt_brch.value == 'S1')			pfm.car_ext[1].selected = true;
		else if(fm.slt_brch.value == 'K1')		pfm.car_ext[2].selected = true;
		else									pfm.car_ext[0].selected = true;
								
		window.close();
	}
//-->
</script>
</head>

<body>
<form name='form1' action='get_con_cd_p.jsp' method='post'>
<input type='hidden' name='h_com' value=''>
<input type='hidden' name='com_nm' value=''>
<input type='hidden' name='com_id' value=''>
<input type='hidden' name='code' value=''>
<input type='hidden' name='car_nm' value=''>
<input type='hidden' name='car_name' value=''>
<input type='hidden' name='s_st' value=''>
<input type='hidden' name='dpm' value=''>

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
      <td align='left'><font color="#666600">- 계약번호 생성 -</font></td>
    </tr>
    <tr> 
      <td class='line'> <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class='title' width='20%'>영업소</td>
            <td width="80%">&nbsp;
			  <jsp:include page="/acar/code/get_branch.jsp" flush="true">
			  	<jsp:param name="f_nm" value="slt_brch" />
			  	<jsp:param name="value" value="" />
			  	<jsp:param name="onChange" value="onChange='javascript:set_branch()'" />
			  </jsp:include>			
            </td>
          </tr>
		  <%	MaCodeBean[] companys = c_db.getCodeAll("car_comp_id", "Y");//자동차사
				int com_size = companys.length;%>
          <tr> 
            <td class='title' width='20%'>자동차회사</td>
            <td width="80%">&nbsp;
			  <jsp:include page="/acar/code/get_code.jsp" flush="true">
			  	<jsp:param name="f_nm" value="slt_car_com" />
			  	<jsp:param name="nm_cd" value="car_comp_id" />
			  	<jsp:param name="app_st" value="Y" />
			  	<jsp:param name="value" value="" />
			  	<jsp:param name="onChange" value="onChange='javascript:change_car_com()'" />
			  </jsp:include>
            </td>
          </tr>
          <tr> 
            <td class='title' width='20%'>차종</td>
            <td width="80%">&nbsp;
			  <select name='slt_car_nm' onChange='javascript:change_car_nm()'>
                <option value=''>자동차회사를선택하세요</option>
              </select></td>
          </tr>
          <tr> 
            <td class='title' width='20%'>차명</td>
            <td width="80%">&nbsp;
			  <select name='slt_car_name' onChange='javascript:set_car_name()'>
                <option value=''>차종을선택하세요</option>
              </select> </td>
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
			  </jsp:include>			
		    </td>
          </tr>
          <tr> 
            <td class='title' width='20%'>계약번호</td>
            <td colspan='3'>&nbsp;
			  <input type='text' class='text' name='t_con_cd1' size='2' value='<%if(!br_id.equals("S1")){%><%=br_id%><%}%>' readonly> 
              <input type='text' class='text' name='t_con_cd2' size='2' value='<%=year%>'> 
              <input type='text' class='text' name='t_con_cd3' size='1' value='' readonly> 
              <input type='text' class='text' name='t_con_cd4' size='2' readonly> 
              &nbsp;|&nbsp; <input type='text' class='text' name='t_con_cd5' size='1' readonly> 
            </td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td align='right'><a href="javascript:save();"><img src="../images/bbs/but_confirm.gif" width="50" height="18" aligh="absmiddle" border="0" alt="확인"></a> 
        <a href="javascript:window.close()"><img src="../images/bbs/but_close.gif" width="50" height="18" aligh="absmiddle" border="0" alt="닫기"></a></td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="110" height="110" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
</body>
</html>
