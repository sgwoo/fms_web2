<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>

<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"7":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String acct = request.getParameter("acct")==null?"009290":request.getParameter("acct");
	
	String s_sys = Util.getDate();
	String s_mon = s_sys.substring(5,7);	

	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	String s_day = request.getParameter("s_day")==null?"":request.getParameter("s_day");	
	int year =AddUtil.getDate2(1);
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='javascript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

function carSearch(){
	var theForm = document.form1;
	theForm.target = "c_body";
	theForm.action = "cus_samt_s2_sc.jsp";
	theForm.submit();
}

	//디스플레이 타입(검색)-세부조회 선택시
	function cng_input1(){
		var fm = document.form1;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '4'){ //기간
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
	//디스플레이 타입(검색) -검색조건 선택시
	function cng_input(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8'||
			fm.s_kd.options[fm.s_kd.selectedIndex].value == '10'||
			fm.s_kd.options[fm.s_kd.selectedIndex].value == '11'){ //영업담당자
			td_input.style.display	= 'none';
			td_bus.style.display	= '';
			td_brch.style.display	= 'none';			
		}else if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '6'){ //영업소
			td_input.style.display	= 'none';
			td_bus.style.display	= 'none';			
			td_brch.style.display	= '';
		}else if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '4'){ //차량번호
			fm.gubun2.value = '5';
			td_input.style.display	= '';
			td_bus.style.display	= 'none';			
			td_brch.style.display	= 'none';						
		}else{
			td_input.style.display	= '';
			td_bus.style.display	= 'none';
			td_brch.style.display	= 'none';						
		}
	}
	
	function Search(){
		var fm = document.form1;
		
		fm.action="cus_samt_s2_sc.jsp";
		fm.first.value = 'N';
		fm.target="c_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
	
	function ChangeDT(arg)
	{
		var theForm = document.form1;
		if(arg=="st_dt")
		{
		theForm.st_dt.value = ChangeDate(theForm.st_dt.value);
		}else if(arg=="end_dt"){
		theForm.end_dt.value = ChangeDate(theForm.end_dt.value);
		}

	}	
	
	
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='cus_samt_s2_sc.jsp' >
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="user_id" value="<%= user_id %>">
<input type="hidden" name="br_id" value="<%= br_id %>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='first' > 
<table width="100%" border="0" cellspacing="1" cellpadding="0">
   <tr>
    	<td colspan=3>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>협력업체 > 업체정보관리 > <span class=style5>정비비 정산현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    
    <tr> 
      <td colspan=3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jhgb.gif align=absmiddle>&nbsp;
        <select name="gubun1" >      
          <option value="3" <%if(gubun1.equals("3")){%> selected <%}%>>계산서발행일&nbsp;</option>
     
        </select>
        <select name="s_year">
                <%for(int i=year; i>2010; i--){%>
                <option value="<%=i%>" <%if(s_year == i){%>selected<%}%>><%=i%>년</option>
                <%}%>
        </select>
     	<select name='s_mon'>
    			<option value='01' <%if(s_mon.equals("01")){%>selected<%}%>>01</option>
    			<option value='02' <%if(s_mon.equals("02")){%>selected<%}%>>02</option>
    			<option value='03' <%if(s_mon.equals("03")){%>selected<%}%>>03</option>
    			<option value='04' <%if(s_mon.equals("04")){%>selected<%}%>>04</option>
    			<option value='05' <%if(s_mon.equals("05")){%>selected<%}%>>05</option>
    			<option value='06' <%if(s_mon.equals("06")){%>selected<%}%>>06</option>
    			<option value='07' <%if(s_mon.equals("07")){%>selected<%}%>>07</option>
    			<option value='08' <%if(s_mon.equals("08")){%>selected<%}%>>08</option>
    			<option value='09' <%if(s_mon.equals("09")){%>selected<%}%>>09</option>
    			<option value='10' <%if(s_mon.equals("10")){%>selected<%}%>>10</option>
    			<option value='11' <%if(s_mon.equals("11")){%>selected<%}%>>11</option>
    			<option value='12' <%if(s_mon.equals("12")){%>selected<%}%>>12</option>
    	</select>월
    	<select name='s_day'>
    			<option value='' <%if(s_day.equals("")){%>selected<%}%>>전체</option>
    			<option value='01' <%if(s_day.equals("01")){%>selected<%}%>>01</option>
    			<option value='02' <%if(s_day.equals("02")){%>selected<%}%>>02</option>
    			<option value='03' <%if(s_day.equals("03")){%>selected<%}%>>03</option>
    			<option value='04' <%if(s_day.equals("04")){%>selected<%}%>>04</option>
    			<option value='05' <%if(s_day.equals("05")){%>selected<%}%>>05</option>
    			<option value='06' <%if(s_day.equals("06")){%>selected<%}%>>06</option>
    			<option value='07' <%if(s_day.equals("07")){%>selected<%}%>>07</option>
    			<option value='08' <%if(s_day.equals("08")){%>selected<%}%>>08</option>
    			<option value='09' <%if(s_day.equals("09")){%>selected<%}%>>09</option>
    			<option value='10' <%if(s_day.equals("10")){%>selected<%}%>>10</option>
    			<option value='11' <%if(s_day.equals("11")){%>selected<%}%>>11</option>
    			<option value='12' <%if(s_day.equals("12")){%>selected<%}%>>12</option>
    			<option value='13' <%if(s_day.equals("13")){%>selected<%}%>>13</option>
    			<option value='14' <%if(s_day.equals("14")){%>selected<%}%>>14</option>
    			<option value='15' <%if(s_day.equals("15")){%>selected<%}%>>15</option>
    			<option value='16' <%if(s_day.equals("16")){%>selected<%}%>>16</option>
    			<option value='17' <%if(s_day.equals("17")){%>selected<%}%>>17</option>
    			<option value='18' <%if(s_day.equals("18")){%>selected<%}%>>18</option>
    			<option value='19' <%if(s_day.equals("19")){%>selected<%}%>>19</option>
    			<option value='20' <%if(s_day.equals("20")){%>selected<%}%>>20</option>
    			<option value='21' <%if(s_day.equals("21")){%>selected<%}%>>21</option>
    			<option value='22' <%if(s_day.equals("22")){%>selected<%}%>>22</option>
    			<option value='23' <%if(s_day.equals("23")){%>selected<%}%>>23</option>
    			<option value='24' <%if(s_day.equals("24")){%>selected<%}%>>24</option>
    			<option value='25' <%if(s_day.equals("25")){%>selected<%}%>>25</option>
    			<option value='26' <%if(s_day.equals("26")){%>selected<%}%>>26</option>
    			<option value='27' <%if(s_day.equals("27")){%>selected<%}%>>27</option>
    			<option value='28' <%if(s_day.equals("28")){%>selected<%}%>>28</option>
    			<option value='29' <%if(s_day.equals("29")){%>selected<%}%>>29</option>
    			<option value='30' <%if(s_day.equals("30")){%>selected<%}%>>30</option>
    			<option value='31' <%if(s_day.equals("31")){%>selected<%}%>>31</option>
    	</select>일
    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    	<select name='acct'>   
    					 	<option value='009290'       <%if(acct.equals("009290"))		{%>selected<%}%>>신엠제이모터스</option>  
    					 	<option value='012005'       <%if(acct.equals("012005"))		{%>selected<%}%>>아마존모터스</option>    		
    			 			<option value='000620'       <%if(acct.equals("000620"))		{%>selected<%}%>>MJ모터스</option>
	                    <option value='002105'       <%if(acct.equals("002105"))		{%>selected<%}%>>부경자동차정비</option>
	                    <option value='002734' 	      <%if(acct.equals("002734"))		{%>selected<%}%>>현대카독크(대전)</option>
	                    <option value='000286'       <%if(acct.equals("000286"))		{%>selected<%}%>>정일현대</option>
	                    <option value='006858' 	      <%if(acct.equals("006858"))		{%>selected<%}%>>오토크린</option>
	                   <option value='001816'       <%if(acct.equals("001816"))		{%>selected<%}%>>삼일정비</option>
	                    <option value='007897' 	      <%if(acct.equals("007897"))		{%>selected<%}%>> 1급금호(대전) </option>
	                    <option value='008462'       <%if(acct.equals("008462"))		{%>selected<%}%>>성서현대(대구)</option>
	             <!--       <option value='008507' 	     <%if(acct.equals("008507"))		{%>selected<%}%>>상무현대(광주)</option> 
	                    <option value='008611'       <%if(acct.equals("008611"))		{%>selected<%}%>>옥산(광주)</option> -->
	                   <option value='006490'       <%if(acct.equals("006490"))		{%>selected<%}%>>상무1급(광주)</option> 
	                  
	                   <option value='002033'       <%if(acct.equals("002033"))		{%>selected<%}%>>충정로점현대자동차</option>  
	                   <option value='010424'       <%if(acct.equals("010424"))		{%>selected<%}%>>강서현대</option> 
	                   	<option value='010757'       <%if(acct.equals("010757"))		{%>selected<%}%>>SNP모터스(광주)</option> 
	                   <option value='010779'       <%if(acct.equals("010779"))		{%>selected<%}%>>엠파크서비스</option> 
	                   	<option value='010651'       <%if(acct.equals("010651"))		{%>selected<%}%>>강서모터스</option> 
	                    <option value='012730'       <%if(acct.equals("012730"))		{%>selected<%}%>>통진서비스</option> 	  
           </select>      
       </td>
    </tr>
    
    <tr> 
      <td width="40%"><table width="100%" cellspacing=0 border="0" cellpadding="0">
        <tr>
          <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
              <select name="s_kd" >
                <option value=""  <%if(s_kd.equals("")){%> selected <%}%>>전체</option>
                <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>상호</option>
                <option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>차량번호</option>
                <option value="3" <%if(s_kd.equals("3")){%> selected <%}%>>정산회차</option>
              </select>
      		  <input type="text" name="t_wd" size="25" value="<%=t_wd%>" class="text" onKeyDown="javasript:enter()">
      	  </td>
         </tr>
      </table></td>
      <td width="31%"><img src=/acar/images/center/arrow_jr.gif align=absmiddle>&nbsp;</font>
        <select name="sort">
          <option value="1" <%if(sort.equals("1")){%> selected <%}%>>상호</option>
          <option value="5" <%if(sort.equals("5")){%> selected <%}%>>정비일</option>
          <option value="6" <%if(sort.equals("6")){%> selected <%}%>>정산일</option>
          <option value="7" <%if(sort.equals("7")){%> selected <%}%>>구분</option>
        </select>
        <input type='radio' name='asc' value='0' <%if(asc.equals("asc")){%> checked <%}%> onClick='javascript:Search()'>
        오름차순 
        <input type='radio' name='asc' value='1' <%if(asc.equals("desc")){%> checked <%}%>onClick='javascript:Search()'>
        내림차순 </td>
      <td><a href="javascript:Search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
      </td>
      
    </tr>
    <iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
  </table>
</form>
</body>
</html>
