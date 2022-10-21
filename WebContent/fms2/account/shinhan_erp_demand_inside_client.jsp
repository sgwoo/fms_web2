<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.* "%>
<%@ page import="acar.inside_bank.*"%>
<%@ page import="acar.bill_mng.*, acar.common.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	String bank_code = request.getParameter("bank_code")==null?"":request.getParameter("bank_code");
	
	String ven_code 	= request.getParameter("ven_code")==null? "":request.getParameter("ven_code");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "12", "01");
      
	if (t_wd.equals("")) t_wd = AddUtil.getDate(4);
	
		
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
		
	//네오엠-은행정보
	CodeBean[] banks = neoe_db.getInsideCodeAll();
	int bank_size = banks.length;
	
	String hidden_value = "";
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-150;//현황 라인수만큼 제한 아이프레임 사이즈

	hidden_value = "?height="+height+"&auth_rw="+auth_rw+"&s_width="+s_width+"&s_height="+s_height+"&s_kd="+s_kd+"&t_wd="+t_wd+"&bank_code="+bank_code;
	
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
		if(fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }		 
		fm.submit();
	}
	
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
			
	
				
	//거래처매칭  
	function matching(){
	
		if(confirm('거래처매칭하시겠습니까?')){
			
			var fm = ii_no.document.form1;	
			
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");			
									
			fm.action='./shinhan_erp_demand_c1_nodisplay.jsp';
			fm.target='i_no';
			fm.submit();								  		
			
			link.getAttribute('href',originFunc);
		}
	}	
	
	//보증금액 매칭 - 보증금액이 일단 같아야 함 - 기존에 입금처리가 없는 경우 다반사임.  금액으로만 매칭되므로 반드시 확인하여 처리해야 함. - 20181004    
	function matching2(){
	
		if(confirm('보증금액 매칭하시겠습니까?')){
			
			var fm = ii_no.document.form1;	
			
			var link1 = document.getElementById("submitLink1");
			var originFunc1 = link1.getAttribute("href");
			link1.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");			
									
			fm.action='./shinhan_erp_demand_c2_nodisplay.jsp';
			fm.target='i_no';
			fm.submit();								  		
			
			link1.getAttribute('href',originFunc);
		}
	}	
	
//-->
</script>
</head>

<body onload="document.form1.t_wd.focus()"  style="overflow:hidden;">
<form name='form1' method='post' action='shinhan_erp_demand_inside_client.jsp'>
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
					<td class="navigation">&nbsp;<span class=style1>재무회계 > 입금관리 > <span class=style5>입금매칭관리</span></span></td>
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
        <td><label><i class="fa fa-check-circle"></i> 입금일 </label>
                 
            <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>    
            
         </td>   
         <td><label><i class="fa fa-check-circle"></i> 입금은행 </label>     
			  <select name='bank_code'>
                      <option value=''>선택</option>
                      <%if(bank_size > 0){
						for(int i = 0 ; i < bank_size ; i++){
							CodeBean bank = banks[i];	
							%>						
                      <option value='<%= bank.getCode()%>' <%if(bank.getCode().equals(bank_code )  ){%>selected<%}%>><%= bank.getNm()%></option>
                      <%	}
					}	%>
               </select>                                          	     
		    &nbsp;<input type="button" class="button" value="검색" onclick="javascript:search();"> 
		   &nbsp; </td>
		   <td colspan=2 align=right>&nbsp;</td>
		  <td align=right>
		  <input  id="submitLink"  type="button" class="button btn-submit" value="매칭" onclick="javascript:matching();"> &nbsp;&nbsp;
		 <input  id="submitLink1" type="button" class="button btn-submit" value="보증금매칭" onclick="javascript:matching2();"> </td>
        <td align=right>&nbsp;</td>
    </tr>
   
    <tr></tr><tr></tr><tr></tr>
    	
       
    <tr>
		<td colspan=6>
			 <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td><iframe src="./shinhan_erp_demand_inside_client_s.jsp<%=hidden_value%>" name="ii_no" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>								
			</table>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="100" height="100"  frameborder="0" noresize> </iframe>
</body>
</html>