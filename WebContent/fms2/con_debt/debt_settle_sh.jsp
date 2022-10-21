<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	CodeBean[] banks = c_db.getDebtCptCdAll(); /* 코드 구분:은행명 debt_pay_view */	
	int bank_size = banks.length;
	

%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		fm.action = 'debt_settle_sc.jsp';		
		fm.target = 'c_body';
		fm.submit()
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function search_list(){
		var fm = document.form1;
		fm.action = 'debt_settle_popup_stat.jsp';				
		fm.target = '_blank';
		fm.submit()
	}		
	
	function search_list2(){
		var fm = document.form1;
		fm.action = 'debt_settle_popup_stat_int.jsp';				
		fm.target = '_blank';
		fm.submit()
	}		
	
	function search_autodoc(chk){
		var fm = document.form1;
		fm.action = 'debt_settle_popup_auto.jsp?chk='+chk;				
		fm.target = '_blank';
		fm.submit()		
	}
	

	
	function search_excel(){
		var fm = document.form1;
		fm.action = 'debt_settle_sc_excel.jsp';				
		fm.target = '_blank';
		fm.submit()		
	}

//-->
</script>
</head>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onload="javascript:document.form1.t_wd.focus();">

<form name='form1' action='debt_settle_sc.jsp' target='c_body' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp; <span class=style1>재무회계 > 구매자금관리 ><span class=style5>유동성부채현황</span></span></td>
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
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='30%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_ssjh.gif align=absmiddle>&nbsp;
					<select name="gubun1">
                <option value="1" <%if(gubun1.equals("1"))%>selected<%%>>대출일자</option>
                <option value="2" <%if(gubun1.equals("2"))%>selected<%%>>상환일자</option>
              </select>
			  <select name="gubun2" >
                <% for(int i=AddUtil.getDate2(1)-5; i<=AddUtil.getDate2(1)+4; i++){%>
                <option value="<%=i%>" <%if(i == AddUtil.parseInt(gubun2)){%> selected <%}%>><%=i%>년도</option>
                <%}%>
              </select>
              <select name="gubun3">
                <option value="" <%if(gubun3.equals("")){%> selected <%}%>>전체</option>
                <% for(int i=1; i<=12; i++){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(i == AddUtil.parseInt(gubun3)){%> selected <%}%>><%=AddUtil.addZero2(i)%>월</option>
                <%}%>
              </select>
                    </td>
                    <td width='35%'><img src=/acar/images/center/arrow_sbjh.gif align=absmiddle>&nbsp;
                      <select name="gubun4">			  
                        <option value="" <%if(gubun4.equals("")){%>selected<%}%>>전체</option>
                        <%if(bank_size > 0){
        					for(int i = 0 ; i < bank_size ; i++){
        						CodeBean bank = banks[i];%>
                        <option value='<%= bank.getCode()%>'<%if(gubun4.equals( bank.getCode())){%> selected <%}%>><%= bank.getNm()%></option>
                        <%	}
        				}	%>
                      </select>	
                    </td>
                    <td width=35%>&nbsp;</td>
                  </tr>
                  <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
                      <select name='s_kd'>
                        <option value='3' <%if(s_kd.equals("3")){%> selected <%}%>>계약번호</option>
                        <option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>계좌번호</option>
                        <option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>차량번호</option>
						<option value='4' <%if(s_kd.equals("4")){%> selected <%}%>>거래처코드</option>
                      </select>
					  <input type='text' name='t_wd' size='16' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()'>
                    </td>
                    <td><img src=/acar/images/center/arrow_jrjg.gif align=absmiddle>&nbsp;
                      <select name='sort_gubun'>
                        <option value='5' <%if(sort_gubun.equals("5")){%> selected <%}%>>거래처코드</option>
                        <option value='1' <%if(sort_gubun.equals("1")){%> selected <%}%>>금융사</option>
                        <option value='6' <%if(sort_gubun.equals("6")){%> selected <%}%>>계약번호</option>						
                        <option value='2' <%if(sort_gubun.equals("2")){%> selected <%}%>>계좌번호</option>
                        <option value='3' <%if(sort_gubun.equals("3")){%> selected <%}%>>차량번호</option>												
                        <option value='4' <%if(sort_gubun.equals("4")){%> selected <%}%>>대출일자</option>
                      </select>
					  <input type='radio' name='asc' value='0' checked>
                      오름차순 
                      <input type='radio' name='asc' value='1'>
                      내림차순 					  
                    </td>
                    <td><a href='javascript:search()'><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
					&nbsp;&nbsp;<a href='javascript:search_list()' title='할부금 상환년별예정리스트'><img src=/acar/images/center/button_see_hb.gif align=absmiddle border=0></a>
					&nbsp;&nbsp;<a href='javascript:search_list2()' title='할부금+이자 상환년별 예정리스트'><img src=/acar/images/center/button_see_shny.gif align=absmiddle border=0></a>
					&nbsp;&nbsp;<a href='javascript:search_autodoc(1)' title='대체전표처리(년도마감)'><img src=/acar/images/center/button_jpss.gif align=absmiddle border=0></a>
					&nbsp;&nbsp;<a href='javascript:search_excel()'><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>					
					</td>
                </tr>
            </table>
        </td>
	</tr>
</table>
</form>
</body>
</html>
