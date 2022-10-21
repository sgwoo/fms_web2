<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")		==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	
	String from_page = request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head><title>FMS</title>
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
	function search()
	{
		document.form1.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="javascript:document.form1.t_wd.focus();">

<form name='form1' action='/fms2/insure/gur_ins_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계출관리 > <span class=style5>보증보험관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>조건검색</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td colspan="2" class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
<tr>
                <td class="title">조회일자</td>
                <td colspan='3'>&nbsp;
		  <select name='gubun2'>
                    <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>계약일자</option>
                    <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>보험가입일</option>
                    <option value="3" <%if(gubun2.equals("3"))%>selected<%%>>보험개시일</option>
                    <option value="4" <%if(gubun2.equals("4"))%>selected<%%>>보험만기일</option>
                  </select>			
		  &nbsp;	
		  <select name='gubun3'>
                    <option value="3" <%if(gubun3.equals("3"))%>selected<%%>>기간</option>					
                    <option value="4" <%if(gubun3.equals("4"))%>selected<%%>>전일</option>				  
                    <option value="1" <%if(gubun3.equals("1"))%>selected<%%>>당일</option>
                    <option value="2" <%if(gubun3.equals("2"))%>selected<%%>>당월</option>
                  </select>		
		  &nbsp;				  
                  <input type="text" name="st_dt" size="10" value="<%=st_dt%>" class="text">
		  ~
		  <input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text">
		</td>
		<!--
                <td width="10%" class="title">결제원</td>
                <td width="40%">&nbsp;
                  <select name='gubun4'>
                    <option value="">전체</option>                    
                    <option value="1" <%if(gubun4.equals("1"))%>selected<%%>>신규</option>
		    <option value="2" <%if(gubun4.equals("2"))%>selected<%%>>승인</option>					
                    <option value="3" <%if(gubun4.equals("3"))%>selected<%%>>해지신청</option>
                    <option value="4" <%if(gubun4.equals("4"))%>selected<%%>>해지완료</option>
                    <option value="7" <%if(gubun4.equals("7"))%>selected<%%>>임의해지</option>					
                    <option value="8" <%if(gubun4.equals("8"))%>selected<%%>>신고에러</option>					
                    <option value="9" <%if(gubun4.equals("9"))%>selected<%%>>미등록</option>					
                  </select></td>
                  -->
              </tr>	        
                <tr>
                    <td class=title width=11%>검색조건</td>
                    <td width=39%>&nbsp;
            		    <select name='s_kd'>
                            <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호 </option>
                            <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>대표자 </option>
                            <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>계약번호 </option>
                            <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>보험증권번호 </option>
                            <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>발행지점 </option>                            
                            <option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>차량번호 </option>                            
                        </select>
        			    &nbsp;&nbsp;&nbsp;
        			    <input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        		    </td>
                    <td class=title width=11%>구분</td>
                    <td width=39%>&nbsp;
            		    <input type="radio" name="gubun1" value=""  <%if(gubun1.equals(""))%>checked<%%>>
            			전체
            		    <input type="radio" name="gubun1" value="Y" <%if(gubun1.equals("Y"))%>checked<%%>>
            			등록
            		    <input type="radio" name="gubun1" value="N" <%if(gubun1.equals("N"))%>checked<%%>>
            			미등록</td>		  		  
                </tr>
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <td colspan="2"><a href="javascript:search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</body>
</html>
