<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	
%>

<html>
<head>
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>

<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--

	//수신처검색하기
	function find_gov_search(){
		var fm = document.form1;	
		window.open("find_gov_search.jsp", "SEARCH_FINE_GOV", "left=100, top=100, width=450, height=550, scrollbars=yes");
	}
	
	
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') SearchopenBrWindow();
	}
	
	//팝업윈도우 열기
	function SearchopenBrWindow() { //v2.0
		fm = document.form1;
		if(fm.t_wd.value == ''){ alert("검색단어를 입력하십시오."); fm.t_wd.focus(); return; }
		window.open("about:blank",'search_open','scrollbars=yes,status=no,resizable=yes,width=800,height=500,left=50,top=50');		
		fm.action = "/tax/pop_search/s_cont.jsp";
		fm.target = "search_open";
		fm.submit();		
	}
	
		//청구금액대비 입금액이 5만원이상 차이 휴/대차료 검색하기
	function find_accid_search(){
		var fm = document.form1;
		if(fm.gov_nm.value == '') { alert('보험사를 확인하십시오.'); return; }
		window.open("find_myaccid_search.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gov_id="+fm.gov_id.value+"&t_wd="+fm.gov_nm.value, "SEARCH_FINE", "left=50, top=50, width=850, height=700, scrollbars=no");
	}	
	
				
//-->
</script>

</head>
<body>
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    
<input type="hidden" name="type" value="search">  
<input type="hidden" name="go_url" value="<%=go_url%>">      
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
  <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>채권관리 > <span class=style5>최고장등록 III</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr><td class=h></td></tr>
    <tr><td class=line2></td></tr>  
    <tr> 
        <td class="line">   
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width="12%">문서번호</td>
            <td width=88%>&nbsp;  
              <input type="text" name="doc_id" size="20" class="text" value="<%=FineDocDb.getSettleDocIdNext("법무")%>">
            </td>
          </tr>
          <tr> 
            <td class='title'>시행일자</td>
            <td>&nbsp; 
              <input type="text" name="doc_dt" size="11" class="text" value="<%=AddUtil.getDate()%>" onBlur='javscript:this.value = ChangeDate(this.value);'>
            </td>
          </tr>
          <tr> 
             <td class='title' rowspan="2" >수신</td>
             <td>&nbsp;  
                  <input type="text" name="gov_nm" size="50" class="text" readonly style='IME-MODE: active'>
        		  <input type='hidden' name="gov_id" value=''>
                  <a href="javascript:find_gov_search();"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
        	</td>
          </tr>                
          <tr>
            <td>&nbsp;&nbsp;<input type="text" name="gov_zip" size="10" class="text" value="">
             &nbsp;&nbsp;<input type="text" name="gov_addr" size="100" class="text" value="">
              (주소) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;           
                         
              </td>
          </tr>
          <tr> 
            <td class='title'>참조</td>
            <td>&nbsp;
              <input type="text" name="mng_dept" size="50" class="text" value="대표이사"> 
              </td>
          </tr>
          <tr> 
            <td class='title'>제목</td>
            <td>&nbsp;&nbsp;<select name='title'>
								<option value=''>선택</option>
								<option value="대차료 차액분 납부최고">대차료 차액분 납부최고</option>		
								
								  
               </select>
			   <input type="text" name="title_sub" size="40" class="text" value="">&nbsp;<font color='#CCCCCC'>(기타일때)</font>
			   </td>
          </tr>
          <tr> 
            <td class='title'>유예기간</td>
            <td>&nbsp;&nbsp;<input type="text" name="end_dt" size="11" class="text" value="" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
          </tr>
 
        </table>
      </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>	
    <tr> 
        <td><a href="javascript:find_accid_search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
    </tr>		
    
  </table>
</form>
</body>
</html>
