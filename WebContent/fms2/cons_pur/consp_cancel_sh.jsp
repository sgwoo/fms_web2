<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*,acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String white = "";
	String disabled = "";
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	if(nm_db.getWorkAuthUser("아마존카이외",user_id)){
		white = "white";
		disabled = "disabled";
	}
%>

<html>
<head>
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
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
<form name='form1' action='/fms2/cons_pur/consp_cancel_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>협력업체 > 배달탁송관리 > <span class=style5>탁송취소현황</span></span></td>
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
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td colspan="2" class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>		
                    <td class=title width=10%>일자</td>
                    <td width=40%>&nbsp;
                          <select name='gubun6'>
                          <option value='3' <%if(gubun6.equals("3")){%>selected<%}%>>취소일자</option>
                        </select>
                        &nbsp;
            		    <select name='gubun1'>
                          <option value='3' <%if(gubun1.equals("3")){%>selected<%}%>>당일</option>
                          <option value='4' <%if(gubun1.equals("4")){%>selected<%}%>>전일</option>
                          <option value='1' <%if(gubun1.equals("1")){%>selected<%}%>>당월</option>
                          <option value='2' <%if(gubun1.equals("2")){%>selected<%}%>>기간 </option>
                        </select>
            			&nbsp;&nbsp;&nbsp;
            			<input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                                ~ 
                        <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
        		    </td>        		    
                    <td class=title width=10%>제조사</td>
                    <td width=40%>&nbsp;
                            <input type="radio" name="gubun3" value=""  <%if(gubun3.equals(""))%>checked<%%>>
            			전체
            		    <input type="radio" name="gubun3" value="1" <%if(gubun3.equals("1"))%>checked<%%>>
            			현대자동차
            		    <input type="radio" name="gubun3" value="2" <%if(gubun3.equals("2"))%>checked<%%>>
            			기아자동차
            		    <input type="radio" name="gubun3" value="3" <%if(gubun3.equals("3"))%>checked<%%>>
            			기타자동차
            		    
        		    </td>
                </tr>
                <tr>
                    <td class=title width=10%>출고사무소</td>
                    <td width=40%>&nbsp;
            		  <input type='text' name='gubun4' size='25' class='text' value='<%=gubun4%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        		    </td>		
                    <td class=title width=10%>탁송지점</td>
                    <td width=40%>&nbsp;
            		    <select name='gubun5'>
                          <option value='' <%if(gubun5.equals("3")){%>selected<%}%>>선택</option>
                          <option value='1' <%if(gubun5.equals("4")){%>selected<%}%>>서울본사</option>
                          <option value='2' <%if(gubun5.equals("1")){%>selected<%}%>>부산지점</option>
                          <option value='3' <%if(gubun5.equals("5")){%>selected<%}%>>대전지점</option>
                          <option value='5' <%if(gubun5.equals("5")){%>selected<%}%>>대구지점</option>
                          <option value='6' <%if(gubun5.equals("6")){%>selected<%}%>>광주지점</option>
                          <option value='4' <%if(gubun5.equals("2")){%>selected<%}%>>고객 </option>
                        </select>
        		    </td>
                </tr>                
        		<tr>
                    <td class=title width=10%>검색조건</td>
                    <td <%if(nm_db.getWorkAuthUser("외부_탁송업체",ck_acar_id)){%>colspan="3"<%}%>>&nbsp;
            		    <select name='s_kd' <%=disabled%>>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>지점</option>
                          <!--<option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>탁송업체 </option>-->
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>계출번호</option>			  
                          <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>판매지점</option>
                          <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>의뢰자</option>
                        </select>
            			&nbsp;&nbsp;&nbsp;
        			    <input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        		    </td>   
        		    <%if(nm_db.getWorkAuthUser("외부_탁송업체",ck_acar_id)){%>
    	        <input type='hidden' name='gubun2' value='<%=gubun2%>'> 
    	        <%}else{%>
                    <td class=title width=10%>탁송업체</td>
                    <td>&nbsp;
            		<select name='gubun2'>
                            <option value='' <%if(gubun2.equals("")){%>selected<%}%>> 전체 </option>
                            <option value='007751' <%if(gubun2.equals("007751")){%>selected<%}%>> 삼진특수 </option>                                                        
                            <option value='009026' <%if(gubun2.equals("009026")){%>selected<%}%>> 영원물류 </option>
                            <option value='011372' <%if(gubun2.equals("011372")){%>selected<%}%>> 상원물류 </option>
                            <option value='009771' <%if(gubun2.equals("009771")){%>selected<%}%>> 프로카비스 </option>
                            <option value='010265' <%if(gubun2.equals("010265")){%>selected<%}%>> 신화로직스 </option>
                            <option value='010266' <%if(gubun2.equals("010266")){%>selected<%}%>> 대명운수 </option>
                            <option value='010630' <%if(gubun2.equals("010630")){%>selected<%}%>> 동운로지스 </option>   
                        </select>
        	  </td>					
    	        <%}%>  	         		        		    			  
        		</tr>
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <td colspan="2"><a href="javascript:search();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif" align="absbottom" border="0"></a></td>
    </tr>
</table>
</form>
</body>
</html>
