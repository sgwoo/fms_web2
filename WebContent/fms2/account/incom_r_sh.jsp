<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.bill_mng.*, acar.common.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "12", "07");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");

	String bank_nm 	= request.getParameter("bank_nm")==null? "":request.getParameter("bank_nm");
	String bank_no 	= request.getParameter("bank_no")==null? "" :request.getParameter("bank_no");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	
	
	//네오엠-은행정보
	CodeBean[] banks = neoe_db.getCodeAll();
	int bank_size = banks.length;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;
		fm.t_wd.value = replaceString("&","AND",fm.t_wd.value);
		fm.action = 'incom_r_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function ChangeDT(arg)
	{
		var theForm = document.form1;
		if(arg=="ref_dt1")
		{
		theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
		}else if(arg=="ref_dt2"){
		theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
		}	
	}	
	
	//조회항목 선택시
	function change_bank(){
		var fm = document.form1;
		var bank_code = fm.bank_code.options[fm.bank_code.selectedIndex].value;
		fm.bank_code2.value = bank_code.substring(0,3);
		fm.bank_name.value = bank_code.substring(3);
	}
		
	
	//디스플레이
	function cng_input1(){
		var fm = document.form1;

		var s_kd = fm.s_kd.options[fm.s_kd.selectedIndex].value;		
	 			
		tr_pay1.style.display		= 'none';
		tr_pay2.style.display		= 'none';			
		
		if(s_kd == '1')			tr_pay1.style.display		= '';
		if(s_kd == '2')			tr_pay2.style.display		= '';
						
	}	
		
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='from_page' value='<%=from_page%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'> 
  <input type='hidden' name='t_wd' value=''> 
  <input type='hidden' name='bank_code2' 	value=''>
  <input type='hidden' name='deposit_no2' 	value=''>
  <input type='hidden' name='bank_name' 	value=''>  
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 집금관리 > <span class=style5>
						입금등록관리</span></span></td>
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
            <table border="0" cellspacing="1" >
                <tr> 
                    <td width="390">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_ggjh.gif" >&nbsp;
                      <input type="radio" name="dt" value="1" <%if(dt.equals("1"))%>checked<%%>>
                      당일 
                      <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
                      당월 
                      <input type="radio" name="dt" value="4" <%if(dt.equals("4"))%>checked<%%>>
                      전일 
                      <input type="radio" name="dt" value="5" <%if(dt.equals("5"))%>checked<%%>>
                      전월 
                      <input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
                      조회기간 </td>
                      <td width="200"> <input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
                      ~ 
                      <input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" > 
                    </td>
                    <td width="68">&nbsp;<a href="javascript:search()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
                </tr>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jg.gif align=absmiddle>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <select name='s_kd' onChange='javascript:cng_input1()'>
               <!--         <option value='0' <%if(s_kd.equals("0")){%> selected <%}%>>전체</option> -->
                        <option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>계좌</option>
                        <option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>카드</option>
                        <option value='3' <%if(s_kd.equals("3")){%> selected <%}%>>현금</option>
                        <option value='5' <%if(s_kd.equals("5")){%> selected <%}%>>대체</option>
                      </select>
                    </td>
                    <td>
                    	<table>
                    		  <tr id=tr_pay1 style="display:''">
							      <td> 
							        <table border="0" cellspacing="1" cellpadding='0' width=100%>							        	
							          <tr> 							      
							            <td>
										  <select name='bank_code' onChange='javascript:change_bank()'>
							                      <option value=''>선택</option>
							                      <%if(bank_size > 0){
													for(int i = 0 ; i < bank_size ; i++){
														CodeBean bank = banks[i];	%>
							                      <option value='<%= bank.getCode()%>:<%= bank.getNm()%>'><%= bank.getNm()%></option>
							                      <%	}
												}	%>
							               </select>
										</td>	
									  </tr>
									 
							        </table>
								  </td>
							    </tr>
							    <tr id=tr_pay2 style='display:none'>
								    <td> 
								        <table border="0" cellspacing="1" cellpadding='0' width=100%>
								          <tr> 
								           <td>
									           <select name='card_cd'>
								                      <option value=''>선택</option>
								                      <option value='1'>BC</option>
								                      <option value='2'>국민</option>
								                      <option value='3'>신한</option>
								                      <option value='4'>외환</option>
								                      <option value='5'>롯데</option>
								                      <option value='6'>현대</option>	
								                      <option value='7'>삼성</option>		
								                      <option value='8'>씨티</option>			
								                      <option value='9'>KCP</option>						        			                    
								               </select>   
											
											</td>				
								          </tr>	
								        </table>
								     </td> 
								 </tr>         	
                    	</table>
                    </td>
                </tr>    
               
            </table>
        </td>
    </tr>
 
</table>
</form>
</body>
</html>

