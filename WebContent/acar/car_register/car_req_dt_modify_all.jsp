<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.car_register.*, acar.cus_reg.*"%>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	String param 	= request.getParameter("param")==null?"":request.getParameter("param");
	String modi_chk	= request.getParameter("modi_chk")==null?"0":request.getParameter("modi_chk");
	String[] params = param.split(",");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
		
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//등록
	function Save()
	{
		var fm = document.form1;	
		
		if(fm.end_req_dt.value == '')	{	alert('처리예정일을 입력하십시오.'); 	fm.end_req_dt.focus(); 		return; }

		if(confirm('등록하시겠습니까?')){					
			fm.action='car_req_dt_modify_all_a.jsp';		
			fm.target='i_no';			
			fm.submit();
		}
	}


//-->
</script>
</head>
<body>

<form action="" name="form1" method="POST">
<%	
	//파싱
	for(int i=0; i<params.length; i++){		
%>
 <input type="hidden" name="car_mng_id" value="<%=params[i]%>">
      
<%	}%>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					 <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
		        <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>처리예정일일 등록</span></span></td>
		        <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>	<tr><td class=h></td></tr>
	
	<tr><td class=line2 colspan=2></td></tr>
    <tr> 
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>                               		
          		<tr> 
            		<td class='title'>처리예정일</td>
            		<td>&nbsp;
            		 <input type="text" id="end_req_dt" name="end_req_dt"  value="<%=Util.getDate()%>" style="margin-bottom: 2px; width: 130px;" placeholder="ex) 2022-03-23" onBlur='javascript:this.value=ChangeDate(this.value)'>
					</td>            		
          		</tr> 
        	</table>
        </td>
    </tr>   
    <tr>
    	<td class=h></td>
    </tr>
    <tr>
        <td>&nbsp; </td>
        <td align="right">
      		<a href="javascript:Save()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
      		<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
 	
      	</td>
    </tr> 
</table>  
       
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>  
</body>
</html>

