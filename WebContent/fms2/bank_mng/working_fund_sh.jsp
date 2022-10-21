<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String bank_id 	= request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	CodeBean[] banks = c_db.getFundCptCdAll(gubun1); /* 코드 구분:은행명 working_fund */	
	int bank_size = banks.length;
%>

<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language="JavaScript">
<!--
	function search()
	{
		var fm = document.form1;
		fm.action = '/fms2/bank_mng/working_fund_sc.jsp';
		fm.target = 'c_body';
		fm.submit();		
	}
	
	//은행대출 등록
	function reg_bank_lend(){
		var fm = document.form1;
		fm.action = 'working_fund_i.jsp';
		fm.target = 'd_content';
		fm.submit();
	}	
	
	function cng_input(){
		var fm = document.form1;
		
		if(fm.gubun1.options[fm.gubun1.selectedIndex].value !== '1' && fm.gubun1.options[fm.gubun1.selectedIndex].value !== '2' && fm.gubun1.options[fm.gubun1.selectedIndex].value !== '3' && fm.gubun1.options[fm.gubun1.selectedIndex].value !== '4'){ //금융사
			finance.style.display	= 'none';								
		}else{
			finance.style.display	= '';							
		}
		fm.action ="working_fund_sh.jsp";
		fm.target="_self";						
		fm.submit();
	}
//-->
</script>
</head>

<body>
<form name='form1' action='/fms2/bank_mng/working_fund_sc.jsp' method='post' target='c_body'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'> 

<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp; <span class=style1>재무회계 > 구매자금관리 ><span class=style5>자금관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
    	<td>
    		<table width=100% border=0 cellpadding=0 cellspacing=0>
	    		<tr>
			    	<td>&nbsp;&nbsp;&nbsp;&nbsp;기간 : 
			    	<input type="text" name="st_dt" size="10" value="<%=st_dt%>" class="text">
			      ~
			      <input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text">
			      &nbsp;&nbsp;&nbsp;&nbsp;
					금융기관 구분: 
						<select name='gubun1' onChange='javascript:cng_input()'>
							<option value=''>전체</option>
							<option value='1' <%if(gubun1.equals("1")){%>selected<%}%>>은행</option>
							<option value='2' <%if(gubun1.equals("2")){%>selected<%}%>>캐피탈</option>
							<option value='3' <%if(gubun1.equals("3")){%>selected<%}%>>저축은행</option>
							<option value='4' <%if(gubun1.equals("4")){%>selected<%}%>>기타금융기관</option>
						</select>
					&nbsp;&nbsp;&nbsp;&nbsp;	
					금융사 : 
						<select name='bank_id'>
			    			<option value=''>전체</option>
							<%
							if(bank_size > 0){
								for(int i = 0 ; i < bank_size ; i++){
									CodeBean bank = banks[i];%>
							<option value='<%= bank.getCode()%>' <%if(bank_id.equals(bank.getCode())){%>selected<%}%>><%= bank.getNm()%></option>
							<%	}
							}
							%>	    	
						</select>
					&nbsp;&nbsp;&nbsp;&nbsp;					
			            진행여부 : 
						<select name='gubun2'>
			    			<option value='all' <%if(gubun2.equals("all")){%>selected<%}%>>전체</option>
			    			<option value='0'   <%if(gubun2.equals("0")){%>selected<%}%>>진행</option>
			    			<option value='1'   <%if(gubun2.equals("1")){%>selected<%}%>>완료</option>								
				    	</select>&nbsp;&nbsp;&nbsp;&nbsp;
			    		<a href=javascript:search();><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>	
			    	</td>			    	
			        <td align="right">
			        	<a href=javascript:reg_bank_lend();><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;&nbsp;&nbsp;
			        </td>
	    		</tr>
	      	</table>
    	</td>
    </tr>
</table>
</form>
</body>
</html>