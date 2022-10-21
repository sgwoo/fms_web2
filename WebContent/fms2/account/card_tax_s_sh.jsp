<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style type="text/css">
.height_td {height:33px;}
select {
	width: 104px !important;
}
.input {
	height: 24px !important;
}
</style>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function search()
	{
	  //추후 데이타 많아지면
	   var fm = document.form1;	  	  
	  
	   fm.submit()
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
//-->
</script>

</head>
<body  leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"5":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun0 	= request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun2 	= request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	String st_mon 	= request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
		
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	
	int year =AddUtil.getDate2(1);

%>

<form name='form1' action='/fms2/account/card_tax_s_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<div>
	<table width=100% border=0 cellpadding=0 cellspacing=0 class="search-area">
		<tr>
		 <td style="height: 30px" class="navigation">&nbsp;<span class=style1>경영정보 > 재무회계  > <span class=style5>신용카드 매출내역</span></span></td>	
		</tr>
	</table>
</div>
<div class="search-area" style="font-size:12px;font-weight:bold;color:#5f5f5f;">
	<div style="float:left;">
		<label><i class="fa fa-check-circle"></i> 기간조회 </label>		
		 <select name='gubun0' class="select" >
               <%for(int i=2020; i<=year; i++){%>
                <option value="<%=i%>" <%if(s_year == i){%>selected<%}%>><%=i%>년</option>
                <%}%>
        </select>	
        &nbsp;	  		
	    <select name="gubun2" class="select"   style="vertical-align: bottom;">
	    	<option value="" <%if(gubun2.equals("")){%>selected<%}%>>전체</option>
	    	<option value="1" <%if(gubun2.equals("1")){%>selected<%}%>>1분기</option>
	    	<option value="2" <%if(gubun2.equals("2")){%>selected<%}%>>2분기</option>
	    	<option value="3" <%if(gubun2.equals("3")){%>selected<%}%>>3분기</option>
	     	<option value="4" <%if(gubun2.equals("4")){%>selected<%}%>>4분기</option>	    	
	    </select>
	    &nbsp;	 
	    <select name="st_mon" class="select"   style="vertical-align: bottom;">
	    		<option value="" <%if(st_mon.equals("")){%>selected<%}%>>전체</option>
	    		<%for(int i=1; i<=12; i++){%>
				<option value="<%=i%>" <%if(Util.parseInt(st_mon) == i){%>selected<%}%>><%=i%>월</option>
				<%}%>
	    </select>
	    &nbsp;	  			
	    <select name="gubun3" class="select"   style="vertical-align: bottom;">
	    	<option value="" <%if(gubun3.equals("")){%>selected<%}%>>전체</option>
	       	<option value='1' <%if(gubun3.equals("1")){%>selected<%}%>>BC</option> 
	        <option value='2' <%if(gubun3.equals("2")){%>selected<%}%>>국민</option>
	        <option value='3' <%if(gubun3.equals("3")){%>selected<%}%>>신한</option>
	        <option value='4' <%if(gubun3.equals("4")){%>selected<%}%>>하나(외환</option>
	        <option value='5' <%if(gubun3.equals("5")){%>selected<%}%>>롯데</option>
	        <option value='6' <%if(gubun3.equals("6")){%>selected<%}%>>현대</option>
	        <option value='7' <%if(gubun3.equals("7")){%>selected<%}%>>삼성</option>
	        <option value='8' <%if(gubun3.equals("8")){%>selected<%}%>>씨티</option>	      
	        <option value='11' <%if(gubun3.equals("11")){%>selected<%}%>>나이스</option>	
	        <option value='13' <%if(gubun3.equals("13")){%>selected<%}%>>이노페이</option>		     
	        <option value='12' <%if(gubun3.equals("12")){%>selected<%}%>>페이엣</option>		      
		         	
	    </select>
	    
    </div>
     <div style="float:left;margin-left:150px">
     <input type="button" class="button" value="검색" onclick="javascript:search();">    
     </div>    
</div>

</table>
</form>
</body>
</html>
