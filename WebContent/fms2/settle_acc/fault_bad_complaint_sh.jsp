<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<script language='javascript'>
	<!-- 
	function search(){
	var fm = document.form1;	   	 
	   if (fm.gubun1[1].checked == true) {
	     	     
	   //  if (fm.t_wd.value == '') {
	   //  	alert("검색조건을 입력하셔야 합니다.")
	   //  	return;
	    // }
	     
	   }
		document.form1.submit();
	}
		
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	//-->
</script>
<style type=text/css>
	<!-- 
	.style1 {color: #666666}
	.style2 {color: #515150; font-weight: bold;}
	.style3 {color: #b3b3b3; font-size: 11px;}
	.style4 {color: #737373; font-size: 11px;}
	.style5 {color: #ef620c; font-weight: bold;}
	.style6 {color: #4ca8c2; font-weight: bold;}
	.style7 {color: #666666; font-size: 11px;}
	-->
</style>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel=stylesheet type="text/css" href="/include/table_t.css">

</head>
<body onload="javascript:document.form1.t_wd.focus();" leftmargin=15>
<%
	String auth_rw    = request.getParameter("auth_rw")    == null ? ""  : request.getParameter("auth_rw");
	String br_id        = request.getParameter("br_id")        == null ? ""  : request.getParameter("br_id");
	String user_id     = request.getParameter("user_id")     == null ? ""  : request.getParameter("user_id");
	String s_kd         = request.getParameter("s_kd")         == null ? ""  : request.getParameter("s_kd");
	String t_wd         = request.getParameter("t_wd")        == null ? ""   : request.getParameter("t_wd");
	String asc           = request.getParameter("asc")           == null ? "0" : request.getParameter("asc");
	String gubun1 	 = request.getParameter("gubun1")     == null ? ""   : request.getParameter("gubun1");
	String from_page = request.getParameter("from_page") == null ? ""  : request.getParameter("from_page");  // popup 요청한 페이지
	
	//height
	int sh_height = request.getParameter("sh_height") == null ? 0 : Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<form name='form1' action='/fms2/settle_acc/fault_bad_complaint_sc.jsp' target='c_foot' method='post'>
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' value='<%=br_id%>'>
	<input type='hidden' name='user_id' value='<%=user_id%>'>
	<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
	<input type='hidden' name='from_page' value='<%=from_page%>'> 
	<div class="navigation" style="margin-bottom:0px !important" >
		<span class="style1">FMS운영관리 > 전자문서관리 > </span><span class="style5">과실비율미확정소송관리</span>
	</div>
	<div class="search-area" style="margin:5px 10px;">
		<label><i class="fa fa-check-circle"></i> 조건검색 </label>
	</div>
	<table border="0" cellspacing="0" cellpadding="0" width=100%>
		<tr>
	        <td colspan="2" class=line>
		        <table border="0" cellspacing="1" cellpadding='0' width=100%>
	                <tr>
	                    <td class=title width=10%>검색조건</td>
	                    <td width=40%>&nbsp;
	            		    <select name='s_kd' class="select">
	                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호 </option>
	                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>계약번호 </option>
	                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>
	                          <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>기안자</option>
							  <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>기안일자</option>
							  <option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>완료일자</option>						  						  
	                        </select>
	        			    &nbsp;&nbsp;&nbsp;
	        			    <input type='text' name='t_wd' size='25' class='input' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
	        		    </td>
	                    <td class=title width=10%>구분</td>
	                    <td width=40%>&nbsp;
						    <input type="radio" name="gubun1" value="0" <%if(gubun1.equals("0"))%>checked<%%>>
	            			전체
	            		    <input type="radio" name="gubun1" value="1" <%if(gubun1.equals("1"))%>checked<%%>>
	            			미결
	            		    <input type="radio" name="gubun1" value="2" <%if(gubun1.equals("2"))%>checked<%%>>
	            			결재완료
	        			</td>		  		  
	                </tr>
	            </table>
		    </td>
	    </tr>  
	</table>
	<div align="right">
		<input type="button" class="button" value="검색" onclick="search()" onMouseOver="window.status=''; return true" onfocus="this.blur()">
	</div>
</form>
</body>
</html>