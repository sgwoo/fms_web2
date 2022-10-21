<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	//검색구분
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
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
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
	//검색하기
	function search(){
		var fm = document.form1;	
		fm.action = "./stat_maker_tax_sc.jsp";
		fm.target = "c_foot";
		fm.submit();
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post' action='' target='c_foot'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>   
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td colspan="7" >
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td class=navigation>&nbsp;<span class=style1>현황 및 통계 > 차량관리 > <span class=style5>현대.기아차구입현황</span></span></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td width="60px">&nbsp;
        	<label><i class="fa fa-check-circle"></i> 용도 </label>
        </td>
        <td width="130px">
			<select name="gubun3" class="select">
              <option value=""  <%if(gubun3.equals("")){%>selected<%}%>>전체</option>
              <option value="1" <%if(gubun3.equals("1")){%>selected<%}%>>영업용</option>
              <option value="2" <%if(gubun3.equals("2")){%>selected<%}%>>업무용</option>
            </select>
		</td>
		<td width="90px">&nbsp;
        	<label><i class="fa fa-check-circle"></i> 기간구분 </label>
        </td>
        <td width="120px">
			<select name="gubun4" class="select">
              <option value="1" <%if(gubun4.equals("1")){%>selected<%}%>>세금계산서일</option>
              <option value="2" <%if(gubun4.equals("2")){%>selected<%}%>>최초등록일</option>              
            </select>
		</td>
        <td width="*">
            <select name="gubun2" class="select">
              <option value="1" <%if(gubun2.equals("1")){%>selected<%}%>>이번주</option>
              <option value="2" <%if(gubun2.equals("2")){%>selected<%}%>>지난주</option>              
              <option value="3" <%if(gubun2.equals("3")){%>selected<%}%>>지지난주</option>
              <option value="4" <%if(gubun2.equals("4")){%>selected<%}%>>당월</option>
              <option value="5" <%if(gubun2.equals("5")){%>selected<%}%>>전월</option>              
              <option value="6" <%if(gubun2.equals("6")){%>selected<%}%>>전전월</option>
              <option value="7" <%if(gubun2.equals("7")){%>selected<%}%>>기간</option>
            </select>            
			&nbsp;&nbsp; 
			<input class="input" type="text" name="st_dt" size="10" value="<%=st_dt%>" class="text">
			~ 
			<input class="input" type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text"> 
			
			&nbsp;<input type="button" class="button" value="검색" onclick="javascript:search();">
		<td>
    </tr>	
</table>
</form>
</body>
</html>
