<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun 	= request.getParameter("gubun")==null?"1":request.getParameter("gubun");
 	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String dest_gubun= request.getParameter("dest_gubun")==null?"":request.getParameter("dest_gubun");
	String send_dt 	= request.getParameter("send_dt")==null?"1":request.getParameter("send_dt");
	String s_bus 	= request.getParameter("s_bus")==null?"":request.getParameter("s_bus");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String sort_gubun= request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
	function Search()
	{
		var fm = document.form1;		
		//if(fm.send_dt.value == '' && fm.t_wd.value == '')						{ alert('검색항목을 입력하십시오.'); fm.t_wd.focus(); return;}		
		//if(fm.send_dt.value == '' && fm.s_kd.value == '' && fm.t_wd.value != ''){ alert('검색조건을 입력하십시오.'); fm.t_wd.focus(); return;}				
		fm.target = "c_foot";
		fm.action = "./v5_sms_cre_sc2.jsp";
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}

	//기간 입력박스 디스플레이
	function show_dt(arg){
		var fm = document.form1;
		if(arg=='3'){
			td_blank.style.display 	= "none";	
			td_dt.style.display 	= "";
			fm.st_dt.focus();
		}else{
			td_blank.style.display 	= "";	
			td_dt.style.display 	= "none";	
		}
	}
	
	function Reg()
	{
		window.open("about:blank", "SMS_V5", "left=100, top=110, width=740, height=400, scrollbars=no");	
		fm = document.form1;
		fm.target = "SMS_V5";
		fm.action = "./v5_sms_cre_i2.jsp";
		fm.submit();
	}
	
//-->
</script>
</head>
<body>
<form name='form1' method='post' action='v5_sms_cre_sc2.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
  	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>SMS > SMS관리 > <span class=style5>신용조회메모 리스트</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>

    <tr>
      <td width="30%" align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_dsgb.gif"  border="0" align=absmiddle>&nbsp;
        <select name='dest_gubun'>
		  <option value='cre' <%if(dest_gubun.equals("cre")){%>selected<%}%>>신용조회</option>		  		  
      </select></td>
      <td width="15%"><img src="/acar/images/center/arrow_day_bs.gif"  border="0" align=absmiddle>&nbsp;
        <select name='send_dt' onChange="javascript:show_dt(this.value);">
          <option value=''  <%if(send_dt.equals("")){%>selected<%}%>>전체</option>
		  <option value='4' <%if(send_dt.equals("4")){%>selected<%}%>>당월</option>		  
		  <option value='1' <%if(send_dt.equals("1")){%>selected<%}%>>당일</option>
          <option value='2' <%if(send_dt.equals("2")){%>selected<%}%>>전일</option>
          <option value='3' <%if(send_dt.equals("3")){%>selected<%}%>>기간</option>
      </select></td>
      <td id="td_blank" style="display:''" width=25%>&nbsp;</td>
      <td id="td_dt" style="display:none;">
	    <input type="text" name="st_dt" size="12" value="<%=st_dt%>" class="text" onBlur='javascript:this.value=ChangeDate(this.value)'> ~
		<input type="text" name="end_dt" size="12" value="<%=end_dt%>" class="text" onBlur='javascript:this.value=ChangeDate(this.value)'>
	  </td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif  align=absmiddle>&nbsp;   
        <select name="s_kd">
          <option value=""  <%if(s_kd.equals("")){%> selected <%}%>>전체</option>
          <option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>수신자</option>
          <option value="4" <%if(s_kd.equals("4")){%> selected <%}%>>수신번호</option>		  
          <option value="5" <%if(s_kd.equals("5")){%> selected <%}%>>문자</option>
          <option value="6" <%if(s_kd.equals("6")){%> selected <%}%>>의뢰자</option>		  		  
        </select>
		&nbsp;<input type="text" name="t_wd" size="21" value="<%=t_wd%>" class="text" onKeyDown="javasript:enter()">
	  </td>
      <td><img src="/acar/images/center/arrow_jr.gif"  border="0" align=absmiddle>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <select name='sort'>
          <option value='5' <%if(sort.equals("5")){%>selected<%}%>>등록일자</option>		  
        </select></td>
      <td><input type="radio" name="sort_gubun" value="asc" <%if(sort_gubun.equals("asc")){%>checked<%}%>>
		오름차순
		  <input type="radio" name="sort_gubun" value="desc" <%if(sort_gubun.equals("desc")){%>checked<%}%>>
		내림차순
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="javascript:Search()" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif" border="0"></a></td>
      <td>&nbsp;
	  	<a href="javascript:Reg()" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_reg.gif" border="0"></a>
	  </td>
    </tr>	
  </table>
</form>
</body>
</html>