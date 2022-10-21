<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.* "%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String charge_dt = request.getParameter("charge_dt")==null?"":request.getParameter("charge_dt");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	String bank_code = request.getParameter("bank_code")==null?"":request.getParameter("bank_code");
	
	Vector vt2 = CardDb.getDemandDate();
	int vt_size2 = vt2.size();	
		
	String hidden_value = "";
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-150;//현황 라인수만큼 제한 아이프레임 사이즈

	hidden_value = "?height="+height+"&auth_rw="+auth_rw+"&s_width="+s_width+"&s_height="+s_height+"&s_kd="+s_kd+"&charge_dt="+charge_dt;
	
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
		if(fm.charge_dt.value == ''){ alert('청구일을 확인하십시오.'); return; }		 
		fm.submit();
	}
	
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
			
	
				
	//거래처매칭  
	function toExcel(){
			
		var fm = document.form1;	
												
		fm.action='./popup_card_demand_excel.jsp';
		fm.target='i_no';
		fm.submit();								  		
			
	}

	
//-->
</script>
</head>

<body onload="document.form1.charge_dt.focus()"  style="overflow:hidden;">
<form name='form1' method='post' action='card_demand_list.jsp'>
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">     
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>    
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<input type='hidden' name='s_kd' value='1'>    

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="search-area">

<tr >
		<td colspan=6 style="height: 30px">
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td class="navigation">&nbsp;<span class=style1>현황 및 통계 > 재무회계 > <span class=style5>카드청구현황(전북)</span></span></td>
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
        <td><label><i class="fa fa-check-circle"></i> 청구일 </label>
          <select name="charge_dt">
			    <option value="">선택</option>
<%		for(int i = 0 ; i < vt_size2 ; i++){
			Hashtable ht = (Hashtable)vt2.elementAt(i);%>
                <option value="<%=ht.get("CHARGE_DATE")%>"  <% if(charge_dt.equals(String.valueOf(ht.get("CHARGE_DATE"))))%> selected<%%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CHARGE_DATE")))%></option>
<%		}%>
          </select>	
         </td>   
         <td>                                        	     
		    &nbsp;<input type="button" class="button" value="검색" onclick="javascript:search();"> 
		   &nbsp; </td>
		   <td colspan=2 align=right>&nbsp;</td>
		  <td align=right>
		  <input  id="submitLink"  type="button" class="button btn-submit" value="excel" onclick="javascript:toExcel();"> &nbsp;&nbsp;
		  </td>
        <td align=right>&nbsp;</td>
    </tr>
   
    <tr></tr><tr></tr><tr></tr>
    	
       
    <tr>
		<td colspan=6>
			 <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td><iframe src="./card_demand_list_s.jsp<%=hidden_value%>" name="ii_no" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>								
			</table>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="100" height="100"  frameborder="0" noresize> </iframe>
</body>
</html>