<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String e_t_wd = AddUtil.getDate();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(birth){
  var fm = document.form1;
	var date = fm.e_t_wd.value;
	date = date.replace('-', '').replace('-', '');

	var birth = fm.s_t_wd.value;
	var year = date.substr(0,4);
	var month = date.substr(4,6);
  var day = date.substr(6,8);        
	var monthDay = month + day;
		
	birth = birth.replace('-', '').replace('-', '');
  var birthdayy = birth.substr(0, 4);
  var birthdaymd = birth.substr(4, 4);
    
  var age = monthDay < birthdaymd ? year - birthdayy - 1 : year - birthdayy;
  fm.t_wd.value=age;
}
	
	
	
	function ChangeDT(arg)
{
	var theForm = document.form1;
	if(arg=="s_t_wd")
	{
	theForm.s_t_wd.value = ChangeDate(theForm.s_t_wd.value);
	}else if(arg=="e_t_wd"){
	theForm.e_t_wd.value = ChangeDate(theForm.e_t_wd.value);
	}

}
	
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
	
//-->
</script>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>

</head>
<body onload="javascript:document.form1.s_t_wd.focus();" leftmargin=15>
<form action="./search_age.jsp" name="form1" method="POST">
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style5>영업관리 > 만 나이 계산</span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>  
    <tr>
        <td class=h></td>
    </tr>  
   
    <tr> 
      <td>&nbsp;&nbsp;<img src=/acar/images/center/arrow_csi.gif align=absmiddle>&nbsp;
        <input name="s_t_wd" type="text" class="text" value="" size="12" onKeyDown="javasript:enter()" onBlur="javascript:ChangeDT('s_t_wd')" style='IME-MODE: active'>
        &nbsp;
        <img src=/acar/images/center/arrow_gji.gif align=absmiddle>&nbsp;
        <input name="e_t_wd" type="text" class="text" value="<%=e_t_wd%>" size="12" onKeyDown="javasript:enter()" onBlur="javascript:ChangeDT('e_t_wd')" style='IME-MODE: active'>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:Search();"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
      <td class="line" >
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        
          
          <tr>		  
            <td colspan="4" align="center">만 <input name="t_wd" type="text" class="text" value="" size="3" style='text-align: center;  border: white; border-image: none; color: red; font-size: 40px; font-weight: bold; IME-MODE: active'>세 입니다</td>
          </tr>
 
        </table>
	</td>
  </tr>
    <tr>
        <td class=h></td>
    </tr>  
   
    <tr>
      <td align="right"><a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>
  </table>
</form>
</body>
</html>

