<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.user_mng.*"%>
<%@ include file="/agent/cookies.jsp" %>

<%
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
	String white = "";
	String disabled = "";
	
	
%>

<html>
<head><title>FMS</title>
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
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="javascript:document.form1.t_wd.focus();" leftmargin=15>
<form name='form1' action='/agent/tint/tint_w_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > 용품관리 > <span class=style5>용품미수신현황</span></span></td>
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
        <td align="right">&nbsp;</td>
    </tr>
    <tr>    
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
    	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=10%>기간</td>
                    <td>&nbsp;
        			  <select name='gubun3'>
                        <option value='1' <%if(gubun3.equals("1")){%>selected<%}%>>요청등록일</option>
                        <option value='2' <%if(gubun3.equals("2")){%>selected<%}%>>마감요청일</option>
                        <option value='3' <%if(gubun3.equals("3")){%>selected<%}%>>출고예정일</option>
                        <option value='4' <%if(gubun3.equals("4")){%>selected<%}%>>등록예정일</option>								
                      </select>
                	  <select name='gubun2'>
                        <option value='3' <%if(gubun2.equals("3")){%>selected<%}%>>당일</option>
                        <option value='4' <%if(gubun2.equals("4")){%>selected<%}%>>익일</option>
						<option value='5' <%if(gubun2.equals("5")){%>selected<%}%>>전일</option>
                        <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>기간 </option>
                      </select>
                	  <input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                      ~ 
                      <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
                	</td>
                    <td class=title width=10%>용품업체</td>
                    <td width=40%>&nbsp;
        		      <select name='gubun1'>
        			    <%if(user_id.equals("000103")){%>
                            <option value='다옴방' 		<%if(gubun1.equals("다옴방")){%>selected<%}%>>		다옴방</option>
        		    <%}else if(user_id.equals("000104")){%>			  
                            <option value='유림카랜드' 		<%if(gubun1.equals("유림카랜드")){%>selected<%}%>>	유림카랜드</option>			  
					<%}else if(user_id.equals("000229")){%>			  
                            <option value='주식회사 오토카샵' 	<%if(gubun1.equals("주식회사 오토카샵")){%>selected<%}%>>	주식회사 오토카샵</option>
        		    <%}else if(user_id.equals("000105")){%>			  
                            <option value='웰스킨천연가죽' 	<%if(gubun1.equals("웰스킨천연가죽")){%>selected<%}%>>	웰스킨천연가죽</option>			  
					<%}else if(user_id.equals("000199")){%>			  
                            <option value='아시아나상사' 	<%if(gubun1.equals("아시아나상사")){%>selected<%}%>>	아시아나상사</option>			  
					<%}else if(user_id.equals("000201")){%>			  
                            <option value='대호4WD상사' 	<%if(gubun1.equals("대호4WD상사")){%>selected<%}%>>	대호4WD상사</option>			  
        		    <%}else{%>
        		    <option value='' >전체</option>
                            <option value='다옴방' 		<%if(gubun1.equals("다옴방")){%>selected<%}%>>		다옴방</option>
                            <option value='유림카랜드' 		<%if(gubun1.equals("유림카랜드")){%>selected<%}%>>	유림카랜드</option>
							<option value='주식회사 오토카샵' 	<%if(gubun1.equals("주식회사 오토카샵")){%>selected<%}%>>	주식회사 오토카샵</option>
                            <option value='웰스킨천연가죽' 	<%if(gubun1.equals("웰스킨천연가죽")){%>selected<%}%>>	웰스킨천연가죽</option>
                            <option value='우일칼라스틸' 	<%if(gubun1.equals("우일칼라스틸")){%>selected<%}%>>	우일칼라스틸</option>
							<option value='아시아나상사' 	<%if(gubun1.equals("아시아나상사")){%>selected<%}%>>	아시아나상사</option>
							<option value='대호4WD상사' 	<%if(gubun1.equals("대호4WD상사")){%>selected<%}%>>	대호4WD상사</option>
        		    <%}%>
                      </select>
                	</td>
                </tr>	  
                <tr>
                    <td class=title width=10%>검색조건</td>
                    <td>&nbsp;
                	  <select name='s_kd'>
                        <!-- <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>지점 </option> -->
                        <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>의뢰자</option>
                        <!-- <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차명</option>
                        <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>차대번호</option>			  					  					  
                        <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>고객 </option> -->
                      </select>
                	  &nbsp;&nbsp;&nbsp;
                	  <input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
                	</td>
                    <td class=title width=10%>정렬조건</td>
                    <td>&nbsp;
                	  <select name='sort'>
                        <option value='1' <%if(sort.equals("1")){%>selected<%}%>>지점 </option>
                        <option value='2' <%if(sort.equals("2")){%>selected<%}%>>의뢰자</option>
                        <option value='3' <%if(sort.equals("3")){%>selected<%}%>>차명</option>
                        <option value='4' <%if(sort.equals("4")){%>selected<%}%>>차대번호</option>			  					  					  
                        <option value='5' <%if(sort.equals("5")){%>selected<%}%>>고객 </option>
                        <option value='6' <%if(sort.equals("6")){%>selected<%}%>>요청등록일 </option>
                        <option value='7' <%if(sort.equals("7")){%>selected<%}%>>마감요청일 </option>								
                        <option value='8' <%if(sort.equals("8")){%>selected<%}%>>출고예정일 </option>
                        <option value='9' <%if(sort.equals("9")){%>selected<%}%>>등록예정일 </option>								
                      </select>
                	</td>
                </tr>
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <td><a href="javascript:search()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>
</table>
</form>
</body>
</html>
