<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, test.menu.*"%>
<%//@ include file="/acar/cookies.jsp" %>

<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String m_st = request.getParameter("m_st")==null?"01":request.getParameter("m_st");
	String m_st2 = request.getParameter("m_st2")==null?"01":request.getParameter("m_st2");
	String m_cd = request.getParameter("m_cd")==null?"01":request.getParameter("m_cd");
	String reg = request.getParameter("reg")==null?"1":request.getParameter("reg");
	
	
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
	//계약코드 생성후 선택
	function save(){
		var fm = document.form1;
		if(fm.t_con_cd1.value == '')		{	alert('영업소를 선택하십시오');			return;	}
		else if(fm.t_con_cd2.value == '')	{	alert('계약년도를 선택하십시오');		return;	}
		else if(fm.t_con_cd3.value == '')	{	alert('자동차회사를 선택하십시오');		return;	}
		else if(fm.t_con_cd4.value == '')	{	alert('차종을 선택하십시오');			return;	}
		else if(fm.t_con_cd5.value == '')	{	alert('대여구분을 선택하십시오');		return;	}

		window.opener.form1.t_con_cd.value = fm.t_con_cd1.value + fm.t_con_cd2.value + fm.t_con_cd3.value + fm.t_con_cd4.value + fm.t_con_cd5.value;
		window.opener.form1.h_brch.value 	= fm.t_con_cd1.value;
		window.opener.form1.t_brch_nm.value = fm.slt_brch.options[fm.slt_brch.selectedIndex].text;
		window.opener.form1.t_com_id.value 	= fm.com_id.value ;
		window.opener.form1.t_com_nm.value 	= fm.com_nm.value ;
		window.opener.form1.t_car_nm.value 	= fm.car_nm.value ;
//		window.opener.form1.t_car_name.value = fm.car_name.value ;
//		window.opener.form1.h_car_id.value = fm.slt_car_name.options[fm.slt_car_name.selectedIndex].value.substring(0,6);
//		window.opener.form1.t_car_seq.value = fm.slt_car_name.options[fm.slt_car_name.selectedIndex].value.substring(8,10);
		var car_name_value = fm.slt_car_name.options[fm.slt_car_name.selectedIndex].value;
		var car_name_value_split = car_name_value.split(",");
		window.opener.form1.h_car_id.value = car_name_value_split[0];
		window.opener.form1.t_car_cd.value = car_name_value_split[1];		
		window.opener.form1.t_car_seq.value = car_name_value_split[2];
		window.opener.form1.t_car_name.value = car_name_value_split[4];		
		//차량가격
		var car_amt = car_name_value_split[3];
		window.opener.form1.t_car_c.value = parseDecimal(toInt(car_amt));
		window.opener.form1.t_car_cs.value = parseDecimal(sup_amt(toInt(parseDigit(car_amt))));
		window.opener.form1.t_car_cv.value = parseDecimal(toInt(parseDigit(car_amt)) - toInt(parseDigit(window.opener.form1.t_car_cs.value)));

		if(fm.slt_car_st.value == 'R')		{ window.opener.form1.s_car_st[1].selected = true; }		
		else if(fm.slt_car_st.value == 'L')	{ window.opener.form1.s_car_st[2].selected = true; }	
		else if(fm.slt_car_st.value == 'S')	{ window.opener.form1.s_car_st[3].selected = true; }
		window.close();
	}
	
	//계약코드에 자동차회사 코드 넣고 차종 리스트 가져오기
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

	//계약코드에 차종 코드 넣고 차명 리스트 가져오기
	function change_car_nm(){
		var fm = document.form1;
		fm.car_cd.value = fm.slt_car_nm.options[fm.slt_car_nm.selectedIndex].value;
		fm.com_id.value = fm.slt_car_com.options[fm.slt_car_com.selectedIndex].value.substring(0,4);
		fm.car_nm.value = fm.slt_car_nm.options[fm.slt_car_nm.selectedIndex].text;
		fm.t_con_cd4.value = fm.car_cd.value;
		drop_car_name();		
		if(fm.car_cd.value == ''){
			fm.slt_car_name.options[0] = new Option('선택', '');
			return;
		}else{			
			fm.target='i_no';
//			fm.target='SET_RENT_L_CD';
			fm.action='get_car_id_nodisplay.jsp?com_id='+fm.com_id.value+'&car_cd='+fm.car_cd.value;
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
	
	//계약코드에 영업소 코드 넣기
	function set_branch(){
		var fm = document.form1;
		var idx = fm.slt_brch.selectedIndex;
		fm.t_con_cd1.value = fm.slt_brch.options[idx].value;
	}
	
	//계약코드에 대여구분 코드 넣기
	function set_car_st(){
		var fm = document.form1;
		fm.t_con_cd5.value = fm.slt_car_st.options[fm.slt_car_st.selectedIndex].value;
	}	
	
	//계약코드에 대여구분 코드 넣기
	function set_car_name(){
		var fm = document.form1;
		var car_name_value = fm.slt_car_name.options[fm.slt_car_name.selectedIndex].value;
		var car_name_value_split = car_name_value.split(":");
		fm.car_name.value = car_name_value_split[4];
	}	
-->
</script>
</head>

<body>
<form name='form1' action='get_con_cd_p.jsp' method='post'>
<input type='hidden' name='h_com' value=''>
<input type='hidden' name='com_nm' value=''>
<input type='hidden' name='com_id' value=''>
<input type='hidden' name='car_cd' value=''>
<input type='hidden' name='car_nm' value=''>
<input type='hidden' name='car_name' value=''>

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
<%	if(reg.equals("2")){%>
    <tr>
		
      <td align='left'><font color="#666600">- 보유차 조회 (재리스) -</font></td>
	</tr>
	<tr>
	<td class='line'>
		<table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class='title' width='20%'>차량번호</td>
            <td width="80%">&nbsp; 
              <input type='text' class='text' name='t_con_cd42' size='15' readonly>
              <a href="#" target="d_content"><img src="../images/bbs/but_search.gif" width="50" height="18" aligh="absmiddle" border="0" alt="목록"></a> 
            </td>
          </tr>
        </table>
	</td>
</tr>
<%	}%>
    <tr>
		
      <td align='left'><font color="#666600">- 계약번호 생성 -</font></td>
	</tr>
	<tr>
	<td class='line'>
		<table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class='title' width='20%'>영업소</td>
            <td width="80%">&nbsp; 
              <select name='slt_brch' onChange='javascript:set_branch()'>
			  
                
                <option value=''>선택</option>
                
                <option value='I1'>인천영업소</option>
                
                <option value='K1'>파주영업소</option>
                
                <option value='S1'>본사</option>
                
                <option value='S2'>중앙영업소</option>
                
                <option value='S3'>OTO</option>
                
			  								  
              </select>
            </td>
          </tr>
<%	if(reg.equals("1")){%>		  
          <tr> 
            <td class='title' width='20%'>자동차회사</td>
            <td width="80%">&nbsp; 
              <select name='slt_car_com' onChange='javascript:change_car_com()'>
                
                <option value=''>선택</option>
                
                <option value='0001H현대자동차'>현대자동차</option>
                
                <option value='0002K기아자동차'>기아자동차</option>
                
                <option value='0003S르노삼성자동차'>르노삼성자동차</option>
                
                <option value='0004D한국GM'>한국GM</option>
                
                <option value='0005Y쌍용자동차'>쌍용자동차</option>
                
                <option value='0006V볼보'>볼보</option>
                
                <option value='0007T도요타'>도요타</option>
                
                <option value='0009Z시보레'>시보레</option>
                
                <option value='0011W폭스바겐'>폭스바겐</option>
                
                <option value='0012C크라이슬러'>크라이슬러</option>
                
                <option value='0013BBMW'>BMW</option>
                
                <option value='0014A캐딜락/사브'>캐딜락/사브</option>
                
                <option value='0015D한국GM'>한국GM</option>
                
                <option value='0016D한국GM'>한국GM</option>
                
                <option value='0017Z기타'>기타</option>
                
                <option value='0018U아우디자동차'>아우디자동차</option>
                
                <option value='0019D한국GM'>한국GM</option>
                
                <option value='0020Z기타'>기타</option>
                
                <option value='0021F포드자동차'>포드자동차</option>
                
                <option value='0022Z기타'>기타</option>
                
                <option value='0023H현대캐피탈'>현대캐피탈</option>
                
                <option value='0024S삼성캐피탈'>삼성캐피탈</option>
                
                <option value='0025H혼다'>혼다</option>
                
                <option value='0026P프라임모터'>프라임모터</option>
                
              </select>
            </td>
          </tr>
          <tr> 
            <td class='title' width='20%'>차종</td>
            <td width="80%">&nbsp; 
              <select name='slt_car_nm' onChange='javascript:change_car_nm()'>
                <option value=''>자동차회사를선택하세요</option>
              </select>
              &nbsp; &nbsp; </td>
          </tr>
          <tr> 
            <td class='title' width='20%'>차명</td>
            <td width="80%">&nbsp; 
              <select name='slt_car_name' onChange='javascript:set_car_name()'>
                <option value=''>차종을선택하세요</option>
              </select>
            </td>
          </tr>
<%	}%>
		  
          <tr> 
            <td class='title' width='20%'>대여구분</td>
            <td width="80%">&nbsp; 
              <select name="slt_car_st" onChange='javascript:set_car_st()'>
                <option value="">선택</option>
                <option value="R">렌트</option>
                <option value="L">리스</option>
                <option value="S">예비용</option>
              </select>
              &nbsp; </td>
          </tr>
          <tr> 
            <td class='title' width='20%'>계약번호</td>
            <td colspan='3'>&nbsp; 
              <input type='text' class='text' name='t_con_cd1' size='2' value='' readonly>
              <input type='text' class='text' name='t_con_cd2' size='2' value='04'>
              <input type='text' class='text' name='t_con_cd3' size='1' value='' readonly>
              <input type='text' class='text' name='t_con_cd4' size='2' readonly>
              &nbsp;|&nbsp; 
              <input type='text' class='text' name='t_con_cd5' size='1' readonly>
            </td>
          </tr>
        </table>
	</td>
</tr>
    <tr>
		
      <td align='right'><a href="#"><img src="../images/bbs/but_confirm.gif" width="50" height="18" aligh="absmiddle" border="0" alt="목록"></a> 
        <a href="javascript:window.close()"><img src="../images/bbs/but_close.gif" width="50" height="18" aligh="absmiddle" border="0" alt="목록"></a></td>
	</tr>

</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
