<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.* "%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id		= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
		
	//등록하기
	function DistReg(){
		var fm = document.form1;
		
		<%if(serv_id.equals("")){%>
		if(fm.rent_l_cd.value == '')	{ alert('차량을 조회하십시오'); 	return; }				
		<%}%>
		if(fm.serv_dt.value == '')		{ alert('기준일자를 입력하십시오'); return; }
		if(fm.tot_dist.value == '')		{ alert('주행거리를 입력하십시오'); return; }
		
		<%if(serv_id.equals("")){%>
		if(!confirm('등록하시겠습니까?')){	return; }
		fm.cmd.value = "i";
		<%}%>
		fm.action = 'http://fms1.amazoncar.co.kr/fms2/car_reg/car_dist_reg_a.jsp';		
//		fm.target = "i_no";
		fm.target = "_self";		
		fm.submit();
	
	}
	
	function date_type_input(date_type){
		var fm = document.form1;
		var today = new Date();
		var s_dt = "";		
		var dt = today;
		if(date_type==1){//내일			
			dt = new Date(today.valueOf()+(24*60*60*1000));
		}else if(date_type == -1){
			dt = new Date(today.valueOf()-(24*60*60*1000)*1);
		}else if(date_type == -2){
			dt = new Date(today.valueOf()-(24*60*60*1000)*2);
		}
		s_dt = String(dt.getFullYear())+"-";
		if(dt.getFullYear()<2000) s_dt = String(dt.getFullYear()+1900)+"-";		
		if((dt.getMonth()+1) < 10) 	s_dt = s_dt+"0";
		s_dt = s_dt+String(dt.getMonth()+1)+"-";
		if(dt.getDate() < 10) 		s_dt = s_dt+"0";
		s_dt = s_dt+String(dt.getDate());
		
		fm.serv_dt.value = s_dt;		
	}			
		
	
	
		
//-->
</script>

<body>
<form name='form1' method='post' action=''>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd' 	value='<%=rent_l_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>	
	<input type='hidden' name='serv_id'		value='<%=serv_id%>'>		
	<input type='hidden' name='cmd' 		value=''>		
	<input type='hidden' name='dist' 		value=''>			
	<input type='hidden' name='from_page'	value='car_dist_reg.jsp'>	
	
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 자동차관리 > <span class=style5>자동차주행거리등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
   	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
        <td class='line'> 
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
					<td width="20%" class="title" >기준일자</td>
					<td>&nbsp;<input type="text" name="serv_dt" value='<%=AddUtil.getDate()%>' size="15" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
						<input type='radio' name="date_type1" value='1' onClick="javascript:date_type_input(-1)">어제								
						<input type='radio' name="date_type1" value='1' onClick="javascript:date_type_input(0)" checked>오늘
					</td>
				</tr>	
				<tr>
					<td class="title" >주행거리</td>
					<td>&nbsp;<input type="text" name="tot_dist" class='text' size="15" value="">km</td>
				</tr>											
			</table>
		</td>								
	</tr>
	<tr>
	        <td align="left">*  주행거리 반영은 마감후 적용됩니다.</td>	
		<td align="right"><a href="javascript:DistReg();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>	
	</tr>  
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
