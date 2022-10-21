<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	UserMngDatabase umd = UserMngDatabase.getInstance();

	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");

	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))		br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = umd.getXmlMaMenuAuth(user_id, "07", "04", "13");
%>

<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;
		fm.t_wd.value = replaceString("&","AND",fm.t_wd.value);
		fm.action = 'ecar_charg_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
//-->
	
</script>
</head>
<body onload="javascript:document.form1.t_wd.focus();">
<form name='form1' method='post'>
	<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>
	<input type='hidden' name='br_id' 	value='<%=br_id%>'>
	<input type='hidden' name='from_page' value='<%=from_page%>'>  
	<input type='hidden' name='sh_height' value='<%=sh_height%>'>
  	<div class="navigation" style="margin-bottom:0px !important">
		<span class="style1">영업관리 > 계출관리 > </span><span class="style5">전기차 충전기 신청</span>
	</div> 
	<div class="search-area" style="margin:0px 10px;">
    	    <table width=100%>
    	    	<colgroup>
    	    		<col width="7%">
    	    		<col width="25%">
    	    		<col width="7%">
    	    		<col width="10%">
    	    		<col width="7%">
    	    		<col width="20%">
    	    		<col width="*">
    	    	</colgroup>
                <tr>
                	<td>
                    	<label><i class="fa fa-check-circle"></i> 검색조건 </label>
                    </td>
                    <td>&nbsp;
            			<select name='s_kd' class="select">
                            <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>> 상호 </option>
                            <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>> 차량번호 </option>
                            <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>> 차명 </option>
                            <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>> 설치업체 </option>
                        </select>
                        &nbsp;
            			<input type='text' name='t_wd' size='25' class='text input' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>            		
        	  		</td>
        	  		<td><label><i class="fa fa-check-circle"></i> 충전기타입 </label></td>
                	<td>&nbsp;
        	      		<select name='gubun1' class='select'>
        	      			<option value='' <%if(gubun1.equals("")){%>selected<%}%>> 전체 </option>
                        	<option value='1' <%if(gubun1.equals("1")){%>selected<%}%>> 이동형 </option>
                          	<option value='2' <%if(gubun1.equals("2")){%>selected<%}%>> 고정형 </option>
                      	</select>
                    </td> 	
                    <td><label><i class="fa fa-check-circle"></i> 진행상태 </label></td>
                	<td>&nbsp;
        	      		<select name='gubun2' class='select'>
        	      			<option value='' <%if(gubun2.equals("")){%>selected<%}%>> 전체 </option>
                        	<option value='1' <%if(gubun2.equals("1")){%>selected<%}%>> 처리중 </option>
                          	<option value='2' <%if(gubun2.equals("2")){%>selected<%}%>> 완료 </option>
                      	</select>
                    </td>  	  	
                  	<td><label><i class="fa fa-check-circle"></i> 정렬조건 </label></td>
                	<td>&nbsp;
        	      		<select name='sort' class='select'>
                          	<option value='1' <%if(sort.equals("1")){%>selected<%}%>> 진행상태 </option>
                        	<option value='2' <%if(sort.equals("2")){ %>selected<%}%>> 등록일 </option>
                      	</select>
        	  		</td>
        	  		<td>
        	  			<div align="right">
				            <button class="button" onclick="javascript:search();">검색</button>&nbsp;&nbsp;
			            </div>
        	  		</td>						
                </tr>
    	    </table>
       </div>
</form>
</body>
</html>

