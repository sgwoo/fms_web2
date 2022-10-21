<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String m1_no = request.getParameter("m1_no")==null?"":request.getParameter("m1_no");//계약관리번호

%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//수정하기
	function save(){
		var fm = document.form1;	
		if(fm.rent_l_cd.value=="")		{	alert("변경하고자하는 차량번호를 선택해 주세요!");		return; }
		
		if(!confirm('등록하시겠습니까?')){
			return;
		}
		fm.action = "upd_l_cd_a.jsp";
		fm.target = "i_no";
		fm.submit();
	}
		
	//삭제하기
	function del(){
		var fm = document.form1;	
	    fm.mode.value = "D";		
	    
	    if(fm.rent_l_cd.value != "")		{	alert("삭제할 수 없습니다.");		return; }
	    
		if(!confirm('삭제하시겠습니까?')){
			return;
		}
		
		fm.action = "upd_l_cd_a.jsp";
		fm.target = "i_no";
		fm.submit();
	}	
	
//팝업윈도우 열기
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}


//검색하기
	function search(){
		var fm = document.form1;	
		if(fm.car_no.value == ''){ alert('검색어를 입력하십시오.'); fm.car_no.focus(); return; }	
//		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') car_no_search();
	}
	
	

	//과태료청구기관 검색하기
	function car_no_search(){
		var fm = document.form1;	
		if(fm.car_no.value == ''){ alert('검색어를 입력하십시오.'); fm.car_no.focus(); return; }	
		window.open("/tax/pop_search/s_cont.jsp?go_url=/fms2/master_car/upd_l_cd.jsp&s_kd=9&t_wd="+fm.car_no.value, "SEARCH_FINE_GOV", "left=200, top=200, width=900, height=450, scrollbars=yes");
	}
		

//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
<form name='form1' action='' method='post' >

<input type="hidden" name="m1_no" value="<%=m1_no%>">
<input type="hidden" name="rent_l_cd" >
<input type="hidden" name="c_id"  >
<input type='hidden' name='mng_id' >
<input type='hidden' name='rent_mng_id' >
<input type='hidden' name='mode' >
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>차량번호변경</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width=25%>차량번호</td>
                    <td width=75%>                    
                      <input type= "text" name="car_no"  class="text"  onKeyDown="javasript:enter()" style='IME-MODE: active'>                    
                     <a href="javascript:car_no_search()"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a></td>
                    
                </tr>
            
            </table>
        </td>
    </tr>
    <tr> 
        <td></td>
        <td align="right"><a href="javascript:save()"><img src="/acar/images/center/button_conf.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
        <a href="javascript:del()"><img src="/acar/images/center/button_delete.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
        <a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>	
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
