<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "09");
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
		
	int year =2021;
	
	String first 	= request.getParameter("first")==null?"Y":request.getParameter("first");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	
	int cnt = 4; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-150;//현황 라인수만큼 제한 아이프레임 사이즈
	
	
	String valus = 	"?first="+first+"&height="+height+"&auth_rw="+auth_rw+"&s_width="+s_width+"&s_height="+s_height+"&user_id="+user_id+"&br_id="+br_id+
					"&gubun1="+gubun1+"&gubun2="+gubun2;
				  
%>


<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
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
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		fm.first.value = 'N';
		fm.submit();
	}
		
	
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
		
	function search_excel(){
		var fm = document.form1;
		fm.action = 'acct_stat_list_excel.jsp';				
		fm.target = '_blank';
		fm.submit()		
	}
	
//-->
</script>
</head>

<body style="overflow:hidden;">
<form name='form1' method='post' action='acct_stat_list.jsp'>
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">     
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>    
<input type='hidden' name='first' > 

<table width="90%" border="0" cellspacing="0" cellpadding="0" class="search-area">

	<tr>
		<td colspan=6 style="height: 30px">
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td class="navigation">&nbsp;<span class=style1>재무회계 > 자금관리 > <span class=style5>장기대여보증금확인</span></span></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan=6  class=h></td>
	</tr>
		
	<tr>
		<td colspan=6  class=h></td>
	</tr>	

    <tr> 
        <td width=60%><label><i class="fa fa-check-circle"></i> 연도 </label>            
           <select name="gubun1">              	
                <%for(int i=2021; i<=year; i++){%>
                <option value="<%=i%>" <%if(s_year == i){%>selected<%}%>><%=i%>년</option>
                <%}%>
              </select>    
          
         </td> 
                   
         <td><label><i class="fa fa-check-circle"></i> 기준 </label>
                <input type="radio" name="gubun2" value="1" <%if(gubun2.equals("1"))%>checked<%%>>
                      네오엠 
                <input type="radio" name="gubun2" value="2" <%if(gubun2.equals("2"))%>checked<%%>>
          FMS 
          &nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="button" value="검색" onclick="javascript:search();"> 
         </td>                      
		 <td colspan=2 >&nbsp;</td>
		 <td align=right> 	
        &nbsp;&nbsp;<a href="javascript:var win=window.open('acct_excel_reg.jsp','popup','left=10, top=10, width=900, height=600, status=no, scrollbars=yes, resizable=no');"><img src=/acar/images/center/button_excel_dr.gif align=absmiddle border=0></a>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:search_excel()"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>
      </td>
     
    </tr>
   
    <tr></tr><tr></tr><tr></tr>
  
    <tr> 
        <td colspan=9 class=line2></td>
    </tr>
         
    <tr>
		<td colspan=6>
			 <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td><iframe src="./acct_stat_list_s.jsp<%=valus%>" name="ii_no" width="100%" height="<%=height+10%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>								
			</table>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="100" height="100"  frameborder="0" noresize> </iframe>
</body>
</html>

