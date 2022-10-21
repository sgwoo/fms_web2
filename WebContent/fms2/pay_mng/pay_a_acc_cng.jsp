<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp"%>

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
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int sh_height 	= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String reqseq 	= request.getParameter("reqseq")==null?"":request.getParameter("reqseq");
	
	
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	
	
	//출금원장
	PayMngBean pay 	= pm_db.getPay(reqseq);
	
	//금융사리스트
	Vector bank_vt =  ps_db.getCodeList("0003");
	int bank_size = bank_vt.size();
	
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
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
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
			
	function save()
	{
		var fm = document.form1;
		if(fm.s_bank_id.options[fm.s_bank_id.selectedIndex].value != ''){
			fm.bank_nm.value = fm.s_bank_id.options[fm.s_bank_id.selectedIndex].text;
		}
		
		if(confirm('수정하시겠습니까?')){
			
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
			
			fm.action = 'pay_a_acc_cng_a.jsp';
			fm.target = 'i_no';
			fm.submit();		
		
			link.getAttribute('href',originFunc);
			
		}
		
	}	
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>      
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='from_page' value='<%=from_page%>'>  
  <input type='hidden' name='reqseq' 	value='<%=reqseq%>'>    
  <input type='hidden' name='bank_nm' value=''>      

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 집금관리 > <span class=style5>
						출금원장수정</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
      <td class=h></td>
    </tr>
	<tr>
	  <td align="right">&nbsp;</td>
	<tr> 	
    <tr>
      <td class=line2></td>
    </tr>    
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=15%>출금항목</td>
            <td width=40%>&nbsp;<%=pay.getP_st2()%>
              <%if(!pay.getReg_st().equals("")){%>
&nbsp;(기타 : <%=pay.getP_gubun_etc()%>)
<%}%></td>
            <td class=title width=15%>예정일자</td>
            <td width="30%">&nbsp;<%=AddUtil.ChangeDate2(pay.getP_est_dt())%></td>
          </tr>
		</table>
	  </td>
	</tr>	 	
	<tr>
	  <td>▣ 출금요청내역</td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="15%" class=title>출금방식</td>
            <td>&nbsp;
				현금지출
			  	-&gt;
				  
			계좌이체</td>
          </tr>
          <tr>
            <td class=title>금액</td>
            <td>&nbsp; <%=AddUtil.parseDecimalLong(pay.getAmt())%>원 </td>
          </tr>
          <tr>				
            <td class=title>지출처</td>
            <td>&nbsp;[
                <%if(pay.getOff_st().equals("cpt_cd")){		%>
                금융사
                <%}%>
                <%if(pay.getOff_st().equals("com_code")){	%>
                자동차사
                <%}%>
                <%if(pay.getOff_st().equals("ins_com_id")){	%>
                보험사
                <%}%>
                <%if(pay.getOff_st().equals("car_off_id")){	%>
                영업소
                <%}%>
                <%if(pay.getOff_st().equals("emp_id")){		%>
                영업사원
                <%}%>
                <%if(pay.getOff_st().equals("off_id")){		%>
                협력업체
                <%}%>
                <%if(pay.getOff_st().equals("gov_id")){		%>
                정부기관
                <%}%>
                ]&nbsp;<%=pay.getOff_nm()%> &nbsp; <img src=/acar/images/center/arrow.gif align=absmiddle> 코드 : <%=pay.getOff_id()%> </td>
          </tr>
          <tr>
            <td class=title>입금정보</td>
            <td >&nbsp;
			  <input type='hidden' name='bank_id' 	value='<%=pay.getBank_id()%>'> 
			  <select name='s_bank_id'>
                        <option value=''>선택</option>
                        <%	for(int i = 0 ; i < bank_size ; i++){
								Hashtable bank_ht = (Hashtable)bank_vt.elementAt(i);
								if(pay.getBank_id().length() == 3){%>
                        <option value='<%= bank_ht.get("BANK_ID")%>' <%if(pay.getBank_id().equals(String.valueOf(bank_ht.get("BANK_ID"))))%>selected<%%>><%= bank_ht.get("NM")%></option>
						<%		}else{%>
                        <option value='<%= bank_ht.get("BANK_ID")%>' <%if(pay.getBank_nm().equals(String.valueOf(bank_ht.get("NM"))))%>selected<%%>><%= bank_ht.get("NM")%></option>
						<%		}%>
                        <%	}%>
              </select>&nbsp;
              <input type='text' name='bank_no' size='30' value='<%=pay.getBank_no()%>' class='default' >       
			  &nbsp;예금주 : <input type='text' name='bank_acc_nm' size='33' value='<%=pay.getBank_acc_nm()%>' class='default' >      
			</td>
          </tr>		  	  
		</table>
	  </td>
	</tr> 				
    <tr>
	    <td align='center'>
	    <%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a id="submitLink" href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>&nbsp;&nbsp;
	    <%}%>
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
	    </td>
	</tr>	
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>		
  </table>
</form>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

