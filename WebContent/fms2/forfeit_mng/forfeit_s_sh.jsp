<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

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
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String coll_yn 	= request.getParameter("coll_yn")==null?"":request.getParameter("coll_yn");
		
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
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
		fm.action = 'forfeit_s_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
			//디스플레이 타입(검색)-세부조회 선택시
	function cng_input1(){
		var fm = document.form1;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '3' ){ //기간
			td_dt.style.display	 = '';
		}else{
			td_dt.style.display	 = 'none';
		}
	}		
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'> 
 
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고 및 보험 > 선납입 현황 > <span class=style5>선납입현황</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>  	
    <tr>
      <td class=line2></td>
    </tr>	
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width=10% class="title">조회일자</td>
                    <td width="17%">&nbsp;
    				  <select name='gubun1'>
                    <!--    <option value="1" <%if(gubun1.equals("1"))%>selected<%%>>예정일자</option> -->
                        <option value="2" <%if(gubun1.equals("2"))%>selected<%%>>납부일자</option>
                      								
                      </select>			
    				  &nbsp;
    				   <select name='gubun2' onChange="javascript:cng_input1()">
                        <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>당일</option>
                        <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>당월</option>
                        <option value="5" <%if(gubun2.equals("5"))%>selected<%%>>전월</option>
                        <option value="3" <%if(gubun2.equals("3"))%>selected<%%>>기간</option>	
                        <option value="4" <%if(gubun2.equals("4"))%>selected<%%>>검색</option>					
                      </select>		
                      &nbsp;
                    </td> 
                    <td width="25%">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td id='td_dt' <%if(gubun2.equals("3")){%>style="display:''"<%}else{%>style='display:none'<%}%>> 
                                     &nbsp;<input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                                    ~ 
                                    <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
                                </td>
                            </tr>
                        </table>
                    </td>                         
                    <td width="10%" class="title">검색조건</td>
                    <td width=36%>&nbsp;
                      <select name='s_kd'>
                        <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>거래처</option>
                        <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>차량번호</option>
                        <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>청구기관</option>
                        </select>
    					&nbsp;&nbsp;&nbsp;
    					<input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
              		 	&nbsp;&nbsp;&nbsp;
               			<input type="checkbox" name="coll_yn" value="Y"  >수금포함</td>	      	
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

