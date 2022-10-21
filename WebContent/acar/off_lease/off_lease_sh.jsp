<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"all":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"asc":request.getParameter("gubun5");
	String cjgubun = request.getParameter("cjgubun")==null?"all":request.getParameter("cjgubun");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector branches = c_db.getBranchList(); //영업소 리스트 조회
	int brch_size = branches.size();
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<html>
<head>
<title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="javascript">
<!--
function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') ybSearch();
}
function ybSearch()
{
	var theForm = document.Offls_ybSearchForm;
	theForm.target = "c_foot";
	theForm.submit();
}

//function gubun_nm_blank(){
//	var fm = document.Offls_ybSearchForm;
//	fm.gubun_nm.value = "";
//	fm.gubun_nm.focus();
//}

function offls_pre(){ //매각예정차량만 가능 
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
	if(!confirm('메각예정차량만 가능합니다. 매각결정 자동차 현황으로 넘기시겠습니까?')){	return;	}
	fm.action = "/acar/off_lease/off_ls_pre_set.jsp";
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
	if(!confirm('매각결정을 취소 하시겠습니까?')){	return;	}
	fm.action = "/acar/off_ls_pre/off_ls_pre_cancel.jsp";
	fm.target = "i_no";
	fm.submit();
}
function secondhand(){
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
	if(!confirm('선택하신 차량을 재리스로 결정하시겠습니까?')){	return;	 }
	fm.action = "/acar/off_lease/secondhand_set.jsp";
	fm.target = "i_no";
	fm.submit();
}
//재리스 비대상 결정
function no_secondhand(){
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
	if(!confirm('선택하신 차량을 재리스 비대상으로 결정하시겠습니까?')){	return;	 }
	fm.action = "/acar/off_lease/no_secondhand_set.jsp";
	fm.target = "i_no";
	fm.submit();
}

//재리스 비대상 해제
function no_secondhand_c(){
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
	if(!confirm('선택하신 차량을 재리스 비대상 해제하시겠습니까?')){	return;	 }
	fm.action = "/acar/off_lease/no_secondhand_set_c.jsp";
	fm.target = "i_no";
	fm.submit();
}

//월렌트 비대상 결정
function no_mon_secondhand(){
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
	if(!confirm('선택하신 차량을 월렌트 비대상으로 결정하시겠습니까?')){	return;	 }
	fm.action = "/acar/off_lease/no_mon_secondhand_set.jsp";
	fm.target = "i_no";
	fm.submit();
}
//월렌트 비대상 결정
function no_mon_secondhand_c(){
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
	if(!confirm('선택하신 차량을 월렌트 비대상결정 해제하시겠습니까?')){	return;	 }
	fm.action = "/acar/off_lease/no_mon_secondhand_set_c.jsp";
	fm.target = "i_no";
	fm.submit();
}

function spedc_car_reg(){
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
	if(cnt > 1) { alert("한건만 선택하세요 !"); return; }	
	
	window.open('about:blank', "SPEDC", "left=0, top=0, width=650, height=300, scrollbars=yes, status=yes, resizable=yes");		
	
	fm.target = "SPEDC";
	fm.action = "newcar_special_discount_i.jsp";
	fm.submit();		
}
function spedc_car_cancel(){
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
	if(!confirm('선택하신 차량의 특별할인을 취소하시겠습니까?')){	return;	 }
	fm.action = "newcar_special_discount_d.jsp";
	fm.target = "i_no";
	fm.submit();	
}

//디스플레이 타입(검색) - 조회기간 선택시
	function cng_input1(){
		var fm = document.Offls_ybSearchForm;
		if(fm.gubun.options[fm.gubun.selectedIndex].value == 'month_rent'){ //월별
			text_input.style.display	= 'none';
		}else{
			text_input.style.display	= "''";

		}
	}
	
//-->
</script>
</head>
<body>
<form name='Offls_ybSearchForm' method='post' action='./off_lease_sc.jsp'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=6>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>오프리스 > 오프리스현황 > <span class=style5>오프리스현황</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<tr>
		<td class=h></td>
	</tr>
    <tr> 
        <td width='20%' align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<img src=../images/center/arrow_gshm.gif align=absmiddle>&nbsp;
			<select name='gubun' onChange="javascript:cng_input1()">
			  <option value='all' >전체</option>
			  <option value='car_no' <%if(gubun.equals("car_no")){%>selected<%}%>>차량번호</option>
			  <option value='car_nm' <%if(gubun.equals("car_nm")){%>selected<%}%>>차명</option>
			  <option value='init_reg_dt' <%if(gubun.equals("init_reg_dt")){%>selected<%}%>>최초등록일</option>
			  <option value='month_rent' <%if(gubun.equals("month_rent")){%>selected<%}%>>월렌트차량제외</option>
			  <option value='ncar_spe_dc' <%if(gubun.equals("ncar_spe_dc")){%>selected<%}%>>특별할인차량</option>
			  <%if(ck_acar_id.equals("000029")){%>
			  <option value='old_ncar_spe_dc' <%if(gubun.equals("old_ncar_spe_dc")){%>selected<%}%>>특별할인차량잔여분(현재대여중)</option>
			  <%} %>
			</select>
		</td>
		<td id="text_input" width="20%" <%if(gubun.equals("month_rent")){%>style='display:none'<%}else{%>style="display:''"<%}%>>
			&nbsp;&nbsp;<img src=../images/center/arrow_gsu.gif align=absmiddle><input type="text" name="gubun_nm" value="<%=gubun_nm%>" class="text" size="15" onKeydown="javascript:EnterDown()"> 
		</td>
		<td width="">
			<img src=../images/center/arrow_yuscd.gif align=absmiddle>
			<select name='brch_id' onChange='javascript:ybSearch();'>
			  <option value=''>전체</option>
			  <%	if(brch_size > 0){
								for (int i = 0 ; i < brch_size ; i++){
									Hashtable branch = (Hashtable)branches.elementAt(i);%>
			  <option value='<%= branch.get("BR_ID") %>'  <%if(brch_id.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> 
			  <%= branch.get("BR_NM")%> </option>
			  <%							}
							}		%>
			</select>
		</td>
		<td width="">
			<img src=../images/center/arrow_jlswrt.gif align=absmiddle>
			<select name='gubun3' onChange="javascript:cng_input1()">
			  <option value='all' >전체</option>
			  <option value='lease_y' <%if(gubun3.equals("lease_y")){%>selected<%}%>>재리스대상</option>
			  <option value='lease_n' <%if(gubun3.equals("lease_n")){%>selected<%}%>>재리스비대상</option>
			  <option value='rent_y' <%if(gubun3.equals("rent_y")){%>selected<%}%>>월렌트대상</option>
			  <option value='rent_n' <%if(gubun3.equals("rent_n")){%>selected<%}%>>월렌트비대상</option>
			</select>
			
		</td>
		<td>
			<img src=../images/center/arrow_cjgb.gif align=absmiddle>			
			<select name='cjgubun' onChange='javascript:ybSearch()'>
        <option value='all' <%if(cjgubun.equals("all")){%> selected <%}%>>전체</option>
        <option value='300' <%if(cjgubun.equals("300")){%> selected <%}%>>소형승용LPG</option>
        <option value='301' <%if(cjgubun.equals("301")){%> selected <%}%>>중형승용LPG</option>		  
        <option value='302' <%if(cjgubun.equals("302")){%> selected <%}%>>대형승용LPG</option>		  		  
 			  <option value='100' <%if(cjgubun.equals("100")){%> selected <%}%>>경승용</option>	
 		    <option value='112' <%if(cjgubun.equals("112")){%> selected <%}%>>소형승용</option>	
 		    <option value='103' <%if(cjgubun.equals("103")){%> selected <%}%>>중형승용</option>	
 	      <option value='104' <%if(cjgubun.equals("104")){%> selected <%}%>>대형승용</option>	
 	      <option value='401' <%if(cjgubun.equals("401")){%> selected <%}%>>RV</option>	
 	      <option value='701' <%if(cjgubun.equals("701")){%> selected <%}%>>승합</option>	
 	      <option value='801' <%if(cjgubun.equals("801")){%> selected <%}%>>화물</option>	
			  <option value='car_gu_2' <%if(cjgubun.equals("car_gu_2")){%>selected<%}%>>자산양수차량</option> 	      
			</select>
		</td>
		<td>
			<a href="javascript:ybSearch()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="../images/center/button_search.gif"  border="0" align=absmiddle></a>
		</td>
	</tr>		
	<tr>
        <td align="" colspan="6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <%if(auth_rw.equals("6")){%>		
        <img src=../images/center/arrow_mg.gif align=absmiddle>
        <a href="javascript:offls_pre()" title='매각결정'><img src=../images/center/button_gju.gif border=0 align=absmiddle></a>&nbsp;
		<a href="javascript:offls_pre_cancel()" title='매각결정취소'><img src=../images/center/button_mg_cancel.gif border=0 align=absmiddle></a>&nbsp;
		&nbsp;&nbsp;&nbsp;
		<img src=../images/center/arrow_jls.gif align=absmiddle> 
		<a href="javascript:secondhand()" title='재리스결정'><img src=../images/center/button_gju.gif border=0 align=absmiddle></a>&nbsp;
		<a href="javascript:no_secondhand()" title='재리스대대상결정'><img src=../images/center/button_bdsgj.gif border=0 align=absmiddle></a>&nbsp;
		<a href="javascript:no_secondhand_c()" title='비대상해제'><img src=../images/center/button_bdshj.gif border=0 align=absmiddle></a>&nbsp;
		&nbsp;&nbsp;&nbsp;
		<img src=../images/center/arrow_wrt.gif align=absmiddle>
		<a href="javascript:no_mon_secondhand()" title='월렌트비대상결정'><img src=../images/center/button_dec_bds.gif border=0 align=absmiddle></a>&nbsp;
		<a href="javascript:no_mon_secondhand_c()" title='월렌트비대상결정해제'><img src=../images/center/button_dec_bds_hj.gif border=0 align=absmiddle></a>&nbsp;
		&nbsp;&nbsp;&nbsp;
		<input type="button" class="button" value="특별할인 결정" onclick="javascript:spedc_car_reg();">&nbsp;
		<input type="button" class="button" value="특별할인 결정취소" onclick="javascript:spedc_car_cancel();">&nbsp;
        <%}%>
        &nbsp;&nbsp;&nbsp;
		<img src=/acar/images/center/arrow_jrjg.gif align=absmiddle> 
            <select name='gubun4' onChange='javascript:ybSearch()'>
              <option value='1' >현위치</option>
              <option value='2' >구분</option>
              <option value='3' >차량번호</option>
              <option value='4' >차명</option>
            </select>
            <select name='gubun5' onChange='javascript:ybSearch()'>
              <option value="asc" >오름차순</option>
              <option value="desc">내림차순</option>
            </select>
        
		
		</td></tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>