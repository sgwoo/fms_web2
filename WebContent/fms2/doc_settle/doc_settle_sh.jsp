<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function search()
	{
		document.form1.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="javascript:document.form1.t_wd.focus();">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<form name='form1' action='/fms2/doc_settle/doc_settle_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > <span class=style5>문서처리전관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
  <tr>
    <td><img src="/acar/images/center/icon_arrow.gif" border="0" align=absmiddle> <span class=style2>검색조건</span></td>
    <td align="right">&nbsp;</td>
  </tr>
  <tr><td class=line2 colspan=2></td></tr>
  <tr>
    <td colspan="2" class=line>
	  <table border="0" cellspacing="1" cellpadding='0' width=100%>
	    <tr>
		  <td class=title width=10%>기간조건</td>
		  <td colspan="3">&nbsp;
		    <input type="radio" name="gubun1" value="1" <%if(gubun1.equals("1"))%>checked<%%>>
              당일 
            <input type="radio" name="gubun1" value="2" <%if(gubun1.equals("2"))%>checked<%%>>
              당월 
            <input type="radio" name="gubun1" value="3" <%if(gubun1.equals("3"))%>checked<%%>>
              조회기간
			  &nbsp;&nbsp;
			<input type="text" name="start_dt" size="11" value="<%=start_dt%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
              ~ 
            <input type="text" name="end_dt" size="11" value="<%=end_dt%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()">
		  </td>
		</tr>
        <tr>
          <td class=title width=10%>검색조건</td>
          <td width=40%>&nbsp;
		    <select name='s_kd'>
              <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호 </option>
              <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>계약번호 </option>
              <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>
              <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>기안자</option>
              <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>결재자</option>			  
            </select>
			&nbsp;&nbsp;&nbsp;
			<input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
		  </td>
          <td class=title width=10%>구분</td>
          <td width=40%>&nbsp;
		    <select name='gubun2'>
              <option value=''>전체</option>
              <option value='1' <%if(gubun2.equals("1")){%>selected<%}%>>미결 </option>
              <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>완결</option>
            </select>
		    <select name='gubun3'>
              <option value=''>전체</option>
              <option value='1' <%if(gubun3.equals("1")){%>selected<%}%>>영업수당</option>
              <option value='2' <%if(gubun3.equals("2")){%>selected<%}%>>탁송의뢰</option>
              <option value='3' <%if(gubun3.equals("3")){%>selected<%}%>>탁송료</option>
              <option value='4' <%if(gubun3.equals("4")){%>selected<%}%>>차량출고</option>
              <option value='5' <%if(gubun3.equals("5")){%>selected<%}%>>차량대금</option>
              <option value='6' <%if(gubun3.equals("6")){%>selected<%}%>>용품의뢰</option>
              <option value='7' <%if(gubun3.equals("7")){%>selected<%}%>>용품대금</option>
              <option value='8' <%if(gubun3.equals("8")){%>selected<%}%>>특근신청</option>
              <option value='11' <%if(gubun3.equals("11")){%>selected<%}%>>해지정산</option>	
              <option value='21' <%if(gubun3.equals("21")){%>selected<%}%>>년차신청</option>	              
              <option value='31' <%if(gubun3.equals("31")){%>selected<%}%>>출금기안</option>	              
              <option value='32' <%if(gubun3.equals("32")){%>selected<%}%>>송금요청</option>	              			  			  			  		  			  
            </select>			
			</td>		  		  
        </tr>
    </table>
	</td>
  </tr>  
  <tr align="right">
    <td colspan="2">
		<a href="javascript:search();"><img src="/acar/images/center/button_search.gif" border="0" align=absmiddle></a>
	</td>
  </tr>
</table>
</form>
</body>
</html>
