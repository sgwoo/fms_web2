<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")	==null?"":request.getParameter("gubun6");
	String gubun7 	= request.getParameter("gubun7")	==null?"":request.getParameter("gubun7");
	String st_dt 	= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 	= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String asc 	= request.getParameter("asc")		==null?"":request.getParameter("asc");
	String go_url 	= request.getParameter("go_url")	==null?"":request.getParameter("go_url");
	String idx 	= request.getParameter("idx")		==null?"":request.getParameter("idx");
	
	//height
	int sh_height 	= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이				


	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function search(){
		var fm = document.form1;
		
		if(fm.gubun1.value == '3'){ alert('청구일자 기준일을 입력하십시오.'); return; }
		
		fm.action="accid_s9_sc.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}			
//-->
</script>
</head>
<body>

<form action="./accid_s9_sc.jsp" name="form1" method="POST" target="c_foot">
<input type="hidden" name="auth_rw" 	value="<%=auth_rw%>">
<input type="hidden" name="br_id" 	value="<%=br_id%>">
<input type="hidden" name="user_id" 	value="<%=user_id%>">

<input type="hidden" name="go_url" 	value="<%=go_url%>">
<input type="hidden" name="idx" 	value="<%=idx%>">
<input type="hidden" name="sh_height" 	value="<%=sh_height%>">


<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td colspan=5>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고 및 보험 > 사고관리 > <span class=style5>대차료미납현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>조건검색</span></td>
        <td align="right"></td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td colspan="2" class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=10%>청구일자</td>
                    <td width=40%>&nbsp;
                    	<input type='text' size='11' name='gubun1' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(gubun1)%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    	이후 청구분
                    	&nbsp;&nbsp;&nbsp;&nbsp;
                    	<input type="text" name="st_dt" size="10" value="<%=st_dt%>" class="text" >
                        ~ 
                        <input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text" >
                    </td>		  		  
                    <td class=title width=10%>계약일자</td>
                    <td width=40%>&nbsp;
                    	<input type='text' size='11' name='gubun2' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(gubun2)%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    	이후 계약분
                    </td>	
                </tr>
                <tr>                    	  		  
                    <td class=title width=10%>미납금액</td>
                    <td>&nbsp;
                    	<input type='text' size='6' name='gubun3' maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(gubun3)%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    	원이상, 
                    	<input type='text' size='2' name='gubun7' maxlength='10' class='defaultnum' value='<%=gubun7%>'>
                    	% 이하
                    </td>		  		  
                    <td class=title width=10%>경과월수</td>
                    <td>&nbsp;
                    	청구 <input type='text' size='2' name='gubun4' maxlength='10' class='defaultnum' value='<%=gubun4%>'>
                    	개월 경과
                    </td>		  		  
                </tr>
                <tr>
                    <td class=title width=10%>미수</td>                    
                    <td >&nbsp;
            		    <input type="radio" name="gubun5" value=""  <%if(gubun5.equals(""))%>checked<%%>>
            			전체
            		    <input type="radio" name="gubun5" value="1" <%if(gubun5.equals("1"))%>checked<%%>>
            			일부
            		    <input type="radio" name="gubun5" value="2" <%if(gubun5.equals("2"))%>checked<%%>>
            			전액
                    </td>
                    <td class=title width=10%>최고장</td>                    
                    <td >&nbsp;
            		    <input type="radio" name="gubun6" value=""  <%if(gubun6.equals(""))%>checked<%%>>
            			전체
            		    <input type="radio" name="gubun6" value="1" <%if(gubun6.equals("1"))%>checked<%%>>
            			등록
            		    <input type="radio" name="gubun6" value="2" <%if(gubun6.equals("2"))%>checked<%%>>
            			미등록
            		    <input type="radio" name="gubun6" value="3" <%if(gubun6.equals("3"))%>checked<%%>>
            			종결처리
            		    <input type="radio" name="gubun6" value="4" <%if(gubun6.equals("4"))%>checked<%%>>
            			종결처리외	
        	    </td>		  		  
                </tr>                              
                <tr>
                    <td class=title width=10%>검색조건</td>
                    <td >&nbsp;                    	
            		<select name='s_kd'>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호 </option>
                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>계약번호 </option>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>
                          <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>청구담당</option>
                          <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>보험사</option>                          					  						  
                        </select>
        		&nbsp;&nbsp;&nbsp;
        		<input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        	    </td>
                    <td class=title width=10%>정렬조건</td>
                    <td >&nbsp;
            		<select name='sort'>
                          <option value='1' <%if(sort.equals("1")){%>selected<%}%>>보험사</option>
                          <option value='4' <%if(sort.equals("4")){%>selected<%}%>>사고일자 </option>
                          <option value='2' <%if(sort.equals("2")){%>selected<%}%>>청구일자 </option>
                          <option value='3' <%if(sort.equals("3")){%>selected<%}%>>차량번호 </option>
                        </select>
        		&nbsp;&nbsp;&nbsp;                    
            		<input type="radio" name="asc" value="asc"  <%if(asc.equals("asc"))%>checked<%%>>
            			오름차순
            		<input type="radio" name="asc" value="desc" <%if(asc.equals("desc"))%>checked<%%>>
            			내림차순
        	    </td>		  		  
                </tr>                
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <td colspan="2"><a href="javascript:search()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>
</table>
</form>
</body>
</html>