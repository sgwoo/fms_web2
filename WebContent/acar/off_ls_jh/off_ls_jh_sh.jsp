<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");		
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
		
	String dt		= request.getParameter("dt")==null?"3":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String s_au = request.getParameter("s_au")==null?"":request.getParameter("s_au");
	
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="javascript">
<!--
function EnterDown()
{
	var keyValue = event.keyCode;
	if (keyValue =='13') Search();
}
function Search()
{
	var theForm = document.form1;
	theForm.action='/acar/off_ls_jh/off_ls_jh_sc.jsp';
	theForm.target = "c_foot";
	theForm.submit();
}
function offls_actn_cancel(){
	var fm = parent.c_foot.inner.form1;
	var len = fm.elements.length;
	var cnt=0;
	var idnum="";
	for(var i=0 ; i<len ; i++){
		var ck = fm.elements[i];
		if(ck.name == 'pr'){
			if(ck.checked == true){
				cnt++;
				idnum = ck.value;
			}
		}
	}
	if(cnt == 0){ alert("취소할 차량을 선택하세요 !"); return; }
	if(!confirm('경매를 취소 하시겠습니까?')){	return;	}
	fm.action = "off_ls_actn_cancel.jsp";
	fm.target = "i_no";
	fm.submit();
}
function offls_pre_cancel(){
	var fm = parent.c_foot.inner.form1;
	var len = fm.elements.length;
	var cnt=0;
	var idnum="";
	for(var i=0 ; i<len ; i++){
		var ck = fm.elements[i];
		if(ck.name == 'pr'){
			if(ck.checked == true){
				cnt++;
				idnum = ck.value;			
			}
		}
	}
	if(cnt == 0){ alert("차량을 선택하세요 !"); return; }
	if(!confirm('출품을 취소 하시겠습니까?')){	return;	}
	fm.action = "../off_ls_pre/off_ls_pre_cancel.jsp";
	fm.target = "i_no";
	fm.submit();
}


function print_open(){
	var fm = parent.c_foot.inner.form1;
	var len = fm.elements.length;
	var cnt=0;
	var max_cnt = 10;
	var idnum="";	
	
	for(var i=0 ; i<len ; i++){
		var ck = fm.elements[i];
		
		if(ck.name == 'pr'){
			if(ck.checked == true){
				var k = i+((len-6)/2);
				var km = fm.elements[k];
				
				if(km.name == "km"){
					if(km.value == "" || km.value == "0" || Math.abs(toInt(km.value)) >30000){
						alert("주행거리가 없습니다.");
						ck.checked = false;	
						cnt--;
					}
				}
				cnt++;
				idnum = ck.value;	
				if(cnt > max_cnt){
							ck.checked = false;						
						}				
			}
		}
	} 
	if(cnt > max_cnt){

		alert('건수합은 최대 '+max_cnt+'건까지 입니다.');
		
				cnt = 0;
				idnum="";
			
				for(var i=0 ; i<len ; i++){
					var ck=fm.elements[i];		
					if(ck.name == "pr"){		
						if(ck.checked == true){
							cnt++;
							idnum=ck.value;																									
						}
					}
				}			
	}	
			
	if(cnt == 0){ alert("차량을 선택하세요 !"); return; }
	
	fm.target = "_blank";
	fm.action = "off_ls_jh_sc_print.jsp";
	fm.submit();
}

function off_ls_cmplt(){
//	var theForm = document.form1;
	var fm = parent.c_foot.inner.form1;
	var len = fm.elements.length;
	var cnt=0;
	var idnum="";
	for(var i=0 ; i<len ; i++){
		var ck = fm.elements[i];
		if(ck.name == 'pr'){
			if(ck.checked == true){
				cnt++;
				idnum = ck.value;
				if(idnum.substring(6,7) != '4'){
					alert('낙찰된 차량만 자동차 처분현황으로 넘길 수 있읍니다!');
					return;
				}
			}
		}
	}
	if(cnt == 0){ alert("차량을 선택하세요 !"); return; }
	if(!confirm('자동차 처분 현황으로 넘기시겠습니까?')){	return;	}
//	fm.action = "/acar/off_ls_cmplt/off_ls_cmplt_set.jsp?s_au="+theForm.s_au.value;
	fm.action = "/acar/off_ls_cmplt/off_ls_cmplt_set.jsp";
	fm.target = "i_no";
	fm.submit();
}
//검색1 디스플레이
function change_gubun1(){
	var fm = document.form1;
	var gbn_idx = fm.gubun1.options[fm.gubun1.selectedIndex].value;
	drop_gubun2();
	if(gbn_idx == 0){	//전체
		add_gubun2(0,'0','전체');
	}else if(gbn_idx == 1){	//소매
		add_gubun2(0,'0','이름');
	}else if(gbn_idx == 2){	//경매
		add_gubun2(0, '0', '전체');
		add_gubun2(1, '1', '경매장');
		add_gubun2(2, '2', '주단위');
	}else if((gbn_idx == 3)){	//수의계약
		add_gubun2(0,'0','계약자명');
	}
	change_gubun2();
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
function change_gubun2(){
	var fm = document.form1;
	var gbn = fm.gubun1.options[fm.gubun1.selectedIndex].value;
	var gbn_idx = fm.gubun2.options[fm.gubun2.selectedIndex].value;
	if(gbn == 0){
		if(gbn_idx == 0){
			td_blank.style.display 	= 'none';
			td_input.style.display 	= '';
		}else{
			td_blank.style.display 	= 'none';
			td_input.style.display 	= '';
		}
	}else{
		td_blank.style.display 	= 'none';
		td_input.style.display 	= '';
	}
}	

function ChangeDT(arg)
{
	var theForm = document.form1;
	if(arg=="ref_dt1")
	{
	theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
	}else if(arg=="ref_dt2"){
	theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
	}

}


function offls_pre_excel(){
	var fm = parent.c_foot.inner.form1;
	var len = fm.elements.length;
	var cnt=0;
	var idnum="";
	for(var i=0 ; i<len ; i++){
		var ck = fm.elements[i];
		if(ck.name == 'pr'){
			if(ck.checked == true){
				cnt++;
				idnum = ck.value;			
			}
		}
	}
	if(cnt == 0){ alert("차량을 선택하세요 !"); return; }
	
	fm.target = "_blank";
	fm.action = "offls_pre_excel.jsp";
	fm.submit();
}

//엑셀 다운 추가  
function excel_list(){
	var fm = document.form1;
	fm.target = "_blank";
	fm.action = "off_ls_jh_excel_list.jsp?ck_acar_id=<%=ck_acar_id%>";
	fm.submit();
}

//경매일, 경매회차 일괄입력 (테스트)
function modifyManyInfo(){
	var fm = parent.c_foot.inner.form1;
	var len = fm.elements.length;
	var cnt=0;
	var idnum="";
	for(var i=0 ; i<len ; i++){
		var ck = fm.elements[i];
		if(ck.name == 'pr'){
			if(ck.checked == true){
				cnt++;
				idnum = ck.value;			
			}
		}
	}
	if(cnt == 0){ alert("경매일, 경매회차를 일괄수정할 차량을 선택하세요."); return; }
	window.open('','pop_target','width=700, height=600, top=0, left=0, resizable=no, status=no, menubar=no, toolbar=no, scrollbars=yes, location=no');
	fm.target = "pop_target";
	fm.method = 'POST';
	fm.action = "off_ls_jh_modi_all.jsp";
	fm.submit();
}

//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan=6>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>오프리스 > 경매관리 > <span class=style5>출품현황</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
     <tr> 
        <td colspan=6>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
          당월 
          <input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
          조회기간&nbsp;&nbsp; 
            <input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
          ~ 
          <input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()"> 

            &nbsp;<a href="javascript:Search()"><img src=../images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>
    
    <tr> 
      <td width='190' align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
        <select name='gubun'>
          <option value='all' >전체</option> 
          <option value='car_no' <%if(gubun.equals("car_no")){%>selected<%}%>>차량번호</option>
          <option value='car_nm' <%if(gubun.equals("car_nm")){%>selected<%}%>>차명</option>
          <option value='init_reg_dt' <%if(gubun.equals("init_reg_dt")){%>selected<%}%>>최초등록일</option>
   
        </select>
      </td>
      <td width="100"> 
        <input type="text" name="gubun_nm" value="<%=gubun_nm%>" class="text" size="15" onKeydown="javasript:EnterDown()">
      </td>
	  <td width='250' align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gmj.gif align=absmiddle>
          <select name="s_au" >
                <option value=""  <%if(s_au.equals("")){%> selected <%}%>>전체</option>
                <option value="000502" <%if(s_au.equals("000502")){%> selected <%}%>>현대글로비스(주)-시화</option>
				<option value="013011" <%if(s_au.equals("013011")){%> selected <%}%>>현대글로비스(주)-분당</option>
				<option value="061796" <%if(s_au.equals("061796")){%> selected <%}%>>현대글로비스(주)-양산</option>
                <option value="020385" <%if(s_au.equals("020385")){%> selected <%}%>>에이제이셀카(주)</option>
				<option value="003226" <%if(s_au.equals("003226")){%> selected <%}%>>서울오토</option>
				<option value="011723" <%if(s_au.equals("011723")){%> selected <%}%>>서울자동차경매</option>
				<option value="013222" <%if(s_au.equals("013222")){%> selected <%}%>>동화엠파크 주식회사</option>
				<option value="022846" <%if(s_au.equals("022846")){%> selected <%}%>>롯데렌탈((구)케이티렌탈)</option>
           </select>
      </td>
	  <td width="0"></td>
	  <td align="right">&nbsp; <%if(auth_rw.equals("6")){%>
	  	<input type="button" class="button" value="경매내용 일괄수정" onclick="javascript:modifyManyInfo();">
	  	<a href="javascript:print_open();"><img src=../images/center/button_print_all.gif border=0 align=absmiddle></a>
		<a href="javascript:excel_list();">[Excel]</a>
		&nbsp;<a href="javascript:offls_pre_excel()"><img src=../images/center/button_excel.gif border=0 align=absmiddle></a>
	    &nbsp;<a href="javascript:offls_pre_cancel()"><img src=../images/center/button_cp_cancel.gif border=0 align=absmiddle></a>
        &nbsp;<a href="javascript:off_ls_cmplt()"><img src=../images/center/button_cb.gif border=0 align=absmiddle></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		
        <%}%>
      </td>
    </tr>
<!--
    
    <tr> 
        <td width=300' align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gshm.gif align=absmiddle>&nbsp;
        <select name='gubun1' onChange="javascript:change_gubun1()">
          <option value='0' >전체</option>
          <option value='1' >소매</option>
          <option value='2' >경매</option>
          <option value='3' >수의</option>
        </select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_sbhm.gif align=absmiddle>
        &nbsp;<select name='gubun2' onChange="javascript:change_gubun2()">
        </select> </td>
        <td id='td_blank' width='10' align="left">&nbsp;</td>
        <td id='td_input' width='120' style='display:none' align="left"> &nbsp;
        <input type="text" name="gubun_nm" class="text" size="15"  align="absmiddle" onKeyDown="javasript:EnterDown()"> 
        </td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td align="right">
   
        </td>
    </tr>
-->    
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
<script language='javascript'>
<!--
//change_gubun1();
-->
</script>
</html>