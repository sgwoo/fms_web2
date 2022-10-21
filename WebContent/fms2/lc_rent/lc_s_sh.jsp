<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "09");
	
	String s_kd 	= request.getParameter("s_kd")==null?	"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?	"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?	"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?	"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?	"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?	"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//영업소리스트
	Vector branches = c_db.getBranchList();
	int brch_size = branches.size();
		
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;
		if(fm.t_wd.value == '' && fm.gubun1.value == '' && fm.gubun3.value == ''){
			if(fm.gubun5.value == '6' && ( fm.st_dt.value == '' || fm.end_dt.value == '' ) ){  alert('기간을 입력하십시오.'); return; }
		}		
				
		fm.action = 'lc_s_sc.jsp';		
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
//-->
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.t_wd.focus();">
<form name='form1' method='post' target='c_foot'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td>
    	<table width=100% border=0 cellpadding=0 cellspacing=0>
        <tr>
          <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
          <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>계약관리</span></span></td>
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
          <td class="title" width=10%>조회일자</td>
          <td width="40%">&nbsp;
			      <select name='gubun4'>
              <option value="1" <%if(gubun4.equals("1"))%>selected<%%>>계약일자</option>
              <option value="2" <%if(gubun4.equals("2"))%>selected<%%>>계약승계일</option>         
              <%if(ck_acar_id.equals("000029")){ %>
              <option value="3" <%if(gubun4.equals("3"))%>selected<%%>>대여개시일</option>
              <%} %>     
            </select>
			      &nbsp;
			      <select name='gubun5'>
              <option value="1" <%if(gubun5.equals("1"))%>selected<%%>>당일</option>
              <option value="2" <%if(gubun5.equals("2"))%>selected<%%>>전일</option>
              <option value="3" <%if(gubun5.equals("3"))%>selected<%%>>2일</option>
              <option value="4" <%if(gubun5.equals("4"))%>selected<%%>>당월</option>
              <option value="5" <%if(gubun5.equals("5"))%>selected<%%>>전월</option>
              <option value="6" <%if(gubun5.equals("6"))%>selected<%%>>기간</option>
            </select>
			      &nbsp;
            <input type="text" name="st_dt" size="10" value="<%=st_dt%>" class="text">
			      ~
			      <input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text">
		      </td>
          <td class=title width=10%>구분</td>
          <td width=40%>&nbsp;
        		<select name='gubun1'>
              <option value=''  <%if(gubun1.equals("")){ %>selected<%}%>>전체 </option>
              <option value='0' <%if(gubun1.equals("0")){%>selected<%}%>>미결 </option>
              <option value='Y' <%if(gubun1.equals("Y")){%>selected<%}%>>진행 </option>
              <option value='N' <%if(gubun1.equals("N")){%>selected<%}%>>해지 </option>
              <option value='R' <%if(gubun1.equals("R")){%>selected<%}%>>보유차 </option>
			        <option value='G' <%if(gubun1.equals("G")){%>selected<%}%>>GPS장착 </option>
			        <option value='E' <%if(gubun1.equals("E")){%>selected<%}%>>일시완납</option>
			        <option value='F' <%if(gubun1.equals("F")){%>selected<%}%>>수입차 </option>
			        <option value='C' <%if(gubun1.equals("C")){%>selected<%}%>>자산양수차</option>
			        <option value='EH' <%if(gubun1.equals("EH")){%>selected<%}%>>전기/수소차</option>
            </select>
            &nbsp;
        		<select name='gubun3'>
              <option value=''  <%if(gubun3.equals("")){ %>selected<%}%>>전체 </option>
              <option value='10' <%if(gubun3.equals("10")){%>selected<%}%>>렌트 </option>
              <option value='11' <%if(gubun3.equals("11")){%>selected<%}%>>리스 </option>
              <option value='15' <%if(gubun3.equals("15")){%>selected<%}%>>업무대여 </option>
              <option value='1' <%if(gubun3.equals("1")){%>selected<%}%>>일반식 </option>
              <option value='2' <%if(gubun3.equals("2")){%>selected<%}%>>기본식 </option>
              <option value='3' <%if(gubun3.equals("3")){%>selected<%}%>>신차 </option>
              <option value='4' <%if(gubun3.equals("4")){%>selected<%}%>>재리스 </option>
              <option value='5' <%if(gubun3.equals("5")){%>selected<%}%>>중고차 </option>
              <option value='6' <%if(gubun3.equals("6")){%>selected<%}%>>연장 </option>
              <option value='12' <%if(gubun3.equals("12")){%>selected<%}%>>신규 </option>
        	    <option value='13' <%if(gubun3.equals("13")){%>selected<%}%>>증차 </option>
	            <option value='14' <%if(gubun3.equals("14")){%>selected<%}%>>대차 </option>
              <option value='8' <%if(gubun3.equals("8")){%>selected<%}%>>차종변경 </option>
              <option value='9' <%if(gubun3.equals("9")){%>selected<%}%>>에이젼트 </option>
            </select>
        	</td>
        </tr>
        <tr>
          <td class=title width=10%>검색조건</td>
          <td width=40%>&nbsp;
        	  <select name='s_kd'>
              <option value='1' 	<%if(s_kd.equals("1")){%>selected<%}%>>상호 </option>
              <option value='13' 	<%if(s_kd.equals("13")){%>selected<%}%>>대표자 </option>
		      <option value='19' 	<%if(s_kd.equals("19")){%>selected<%}%>>사업자번호/생년월일</option>
              <option value='2' 	<%if(s_kd.equals("2")){%>selected<%}%>>계약번호 </option>
              <option value='3' 	<%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>
              <option value='4' 	<%if(s_kd.equals("4")){%>selected<%}%>>관리번호 </option>
              <option value='5' 	<%if(s_kd.equals("5")){%>selected<%}%>>차대번호 </option>
              <option value='16' 	<%if(s_kd.equals("16")){%>selected<%}%>>차종</option>
              <option value='20' 	<%if(s_kd.equals("20")){%>selected<%}%>>차종코드</option>
              <option value='8' 	<%if(s_kd.equals("8")){%>selected<%}%>>최초영업자 </option>
              <option value='10' 	<%if(s_kd.equals("10")){%>selected<%}%>>영업담당자 </option>
              <option value='11' 	<%if(s_kd.equals("11")){%>selected<%}%>>관리담당자 </option>
		          <option value='22' 	<%if(s_kd.equals("22")){%>selected<%}%>>대차보증금승계원계약번호</option>
            </select>
        		&nbsp;
        		<input type='text' name='t_wd' size='18' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
          </td>
          <td class=title width=10%>관리지점</td>
          <td width=40%>&nbsp;
        		<select name='gubun2'>
              <option value=''>전체</option>
              <%if(brch_size > 0)	{
        					for (int i = 0 ; i < brch_size ; i++){
        						Hashtable branch = (Hashtable)branches.elementAt(i);%>
              <option value='<%=branch.get("BR_ID")%>' <%if(gubun2.equals(String.valueOf(branch.get("BR_ID")))){%> selected <%}%>><%= branch.get("BR_NM")%></option>
              <%		}
        				}
        			%>
            </select>
          </td>
        </tr>
      </table>
	  </td>
  </tr>
  <tr align="right">
    <td><a href="javascript:search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
  </tr>
</table>
</form> 
</body>
</html>

