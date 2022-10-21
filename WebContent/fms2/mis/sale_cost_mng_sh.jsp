<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String mode = request.getParameter("mode")==null?"1":request.getParameter("mode");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function search(){
		var fm = document.form1;
		fm.submit()
	}
		
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
//-->
</script>

</head>
<body>
<form name='form1' action='sale_cost_mng_sc.jsp' target='c_body' method='post'>
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='mode' 		value='<%=sort%>'>      
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>영업효율관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>    
    </tr>
    <tr>
        <td class=h></td>
    </tr>      
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>조건검색</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width="10%" class=title>검색기간</td>
                    <td colspan="3">&nbsp;
		        <select name='gubun1'>
                            <option value='1' <%if(gubun1.equals("1")){%>selected<%}%>>기준일자</option>
                            <option value='2' <%if(gubun1.equals("2")){%>selected<%}%>>계약일자</option>
			    <option value='3' <%if(gubun1.equals("3")){%>selected<%}%>>대여개시일</option>
			    <option value='4' <%if(gubun1.equals("4")){%>selected<%}%>>해지일자</option>					
                        </select>
			&nbsp;
			<select name='gubun2'>
                            <option value='1' <%if(gubun2.equals("1")){%>selected<%}%>>당일</option>
                            <option value='4' <%if(gubun2.equals("4")){%>selected<%}%>>전일</option>
                            <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>당월</option>
                            <option value='6' <%if(gubun2.equals("6")){%>selected<%}%>>전월</option>					
                            <option value='5' <%if(gubun2.equals("5")){%>selected<%}%>>캠페인</option>					
                            <option value='3' <%if(gubun2.equals("3")){%>selected<%}%>>기간 </option>
                        </select>
			&nbsp;
                        <input type="text" name="st_dt" size="11" value="<%= AddUtil.ChangeDate2(st_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                        ~
                        <input type="text" name="end_dt" size="11" value="<%= AddUtil.ChangeDate2(end_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td width="10%" class=title>부서</td>
                    <td>&nbsp;
                        <select name='gubun6'>
                            <option value=''>전체</option>
                            <option value='1' <%if(gubun6.equals("1")){%>selected<%}%>>영업팀 </option>
                            <option value='2' <%if(gubun6.equals("2")){%>selected<%}%>>고객지원팀 </option>
                            <option value='3' <%if(gubun6.equals("3")){%>selected<%}%>>부산지점 </option>
                            <option value='4' <%if(gubun6.equals("4")){%>selected<%}%>>대전지점 </option>
                            <option value='5' <%if(gubun6.equals("5")){%>selected<%}%>>퇴사자 </option>					  
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class=title>차량구분</td>
                    <td width="30%">&nbsp;
        		<select name='gubun3'>
                            <option value=''   <%if(gubun3.equals("")){  %>selected<%}%>>전체 </option>
                            <option value='1'  <%if(gubun3.equals("1")){ %>selected<%}%>>신차 </option>
                            <option value='2'  <%if(gubun3.equals("2")){ %>selected<%}%>>재리스 </option>
                            <option value='3'  <%if(gubun3.equals("3")){ %>selected<%}%>>연장 </option>
                            <option value='12' <%if(gubun3.equals("12")){%>selected<%}%>>신차정산</option>					  
                            <option value='4'  <%if(gubun3.equals("4")){ %>selected<%}%>>재리스정산 </option>					  
                            <option value='9'  <%if(gubun3.equals("9")){ %>selected<%}%>>연장정산 </option>					  					  
                            <option value='5'  <%if(gubun3.equals("5")){ %>selected<%}%>>추가이용</option>					  
                            <option value='6'  <%if(gubun3.equals("6")){ %>selected<%}%>>계약승계</option>					  					  
                            <option value='7'  <%if(gubun3.equals("7")){ %>selected<%}%>>중도해지정산금발생</option>					  
                            <option value='8'  <%if(gubun3.equals("8")){ %>selected<%}%>>중도해지정산금수금 </option>
                            <option value='10' <%if(gubun3.equals("10")){%>selected<%}%>>만기해지정산금발생 </option>
                            <option value='11' <%if(gubun3.equals("11")){%>selected<%}%>>만기해지정산금수금 </option>
                            <option value='13' <%if(gubun3.equals("13")){%>selected<%}%>>출고지연대차 </option>
			    <option value='14' <%if(gubun3.equals("14")){%>selected<%}%>>재리스수리비추가분 </option>
			    <option value='15' <%if(gubun3.equals("15")){%>selected<%}%>>해지정산경감원계약자 </option>
			    <option value='16' <%if(gubun3.equals("16")){%>selected<%}%>>해지정산경감부담자 </option>
			    <option value='17' <%if(gubun3.equals("17")){%>selected<%}%>>월렌트 </option>
                    </select>
        		  </td>
                  <td width="10%" class=title>용도구분</td>
                  <td width="20%">&nbsp;
				  <select name='gubun4'>
                      <option value=''  <%if(gubun4.equals("")){ %>selected<%}%>>전체 </option>
                      <option value='1' <%if(gubun4.equals("1")){%>selected<%}%>>렌트 </option>
                      <option value='2' <%if(gubun4.equals("2")){%>selected<%}%>>리스 </option>
                  </select></td>
                  <td width="10%" class=title>관리구분</td>
                  <td width="20%">&nbsp;
				  <select name='gubun5'>
                      <option value=''  <%if(gubun5.equals("")){ %>selected<%}%>>전체 </option>
                      <option value='1' <%if(gubun5.equals("1")){%>selected<%}%>>일반식 </option>
                      <option value='2' <%if(gubun5.equals("2")){%>selected<%}%>>기본식 </option>
                  </select></td>
                </tr>
                <tr>
                  <td class=title>검색조건</td>
                  <td>&nbsp;
                      <select name='s_kd'>
                        <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호 </option>
                        <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>차종 </option>
                        <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>
                        <option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>계약번호</option>						
                        <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>최초영업자 </option>
                        <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>영업대리인 </option>
                        <option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>기타비용 </option>
                        <option value='7' <%if(s_kd.equals("7")){%>selected<%}%>>기타수익 </option>
                        <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>기타반영값 </option>
                        <option value='9' <%if(s_kd.equals("9")){%>selected<%}%>>정산유의사항 </option>
                      </select>
                      &nbsp;
                      <input type='text' name='t_wd' size='18' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
                  </td>
                  <td class=title>정렬조건</td>
                  <td colspan="3">&nbsp;
                    <select name='sort'>
                      <option value='7' <%if(s_kd.equals("7")){%>selected<%}%>>계약구분</option>					
                      <option value='1' <%if(sort.equals("1")){%>selected<%}%>>상호 </option>
                      <option value='2' <%if(sort.equals("2")){%>selected<%}%>>차종 </option>
                      <option value='3' <%if(sort.equals("3")){%>selected<%}%>>차량번호 </option>
                      <option value='4' <%if(sort.equals("4")){%>selected<%}%>>최초영업자 </option>
                      <option value='5' <%if(sort.equals("5")){%>selected<%}%>>영업대리인 </option>
                      <option value='6' <%if(sort.equals("6")){%>selected<%}%>>기준일자</option>
                    </select></td>
                </tr>
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <td colspan="2"><a href="javascript:search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
    </tr>	
  </table>
  </form>
  <iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</table>
</body>