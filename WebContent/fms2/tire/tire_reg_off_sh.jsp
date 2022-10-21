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
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"1":request.getParameter("sort");
	String tire_gubun = request.getParameter("tire_gubun")==null?"":request.getParameter("tire_gubun");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String white = "";
	String disabled = "";
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	if(nm_db.getWorkAuthUser("아마존카이외",user_id)){
		white = "white";
		disabled = "disabled";
		
		
	}else{
	if(user_id.equals("000156")){
			gubun1 = "2";
			gubun2 = "3";
			sort = "1";
		}
	}
	String title ="";
	if(tire_gubun.equals("000256")){
		title="타이어휠타운";
	}
	if(tire_gubun.equals("000148")){
		title="두꺼비카센타";
	}
	if(tire_gubun.equals("000156")){
		title="티스테이션시청점";
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
<body <%if(white.equals("")){%>onload="javascript:document.form1.t_wd.focus();"<%}%> leftmargin=15 >
<form name='form1' action='/fms2/tire/tire_reg_off_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<input type='hidden' name='tire_gubun' value='<%=tire_gubun%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  	<tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>협력업체 > 협력업체관리 > <span class=style5><%=title%> 등록</span></span></td>
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
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td colspan="2" class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=10%>기간</td>
                    <td>&nbsp;
        			  <select name='gubun3'>
                        <option value='1' <%if(gubun3.equals("1")){%>selected<%}%>>정비일자</option>				
                      </select>
                	  <select name='gubun2'>
                        <option value='1' <%if(gubun2.equals("1")){%>selected<%}%>>당월</option>
                        <option value='3' <%if(gubun2.equals("3")){%>selected<%}%>>전월</option>
                        <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>기간 </option>
                      </select>
                	  <input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                      ~ 
                      <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
                	</td>
                    <td class=title width=10%>검색조건</td>
                    <td colspan="3">&nbsp;
                	  <select name='s_kd'>
                        <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>차량번호</option>
						<option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>담당자</option>
                      </select>
                	  &nbsp;&nbsp;&nbsp;
                	  <input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
                	</td>
                </tr>
				<tr>
					<td class=title width=10%>상태</td>
        		    <td colspan="">&nbsp;
            		    <input type='radio' name="gubun1" value=''  <%if(gubun1.equals("")||gubun1.equals("N")){%>checked<%}%>> 전체
            		    <input type='radio' name="gubun1" value='1' <%if(gubun1.equals("1")){%>checked<%}%>>확인
            		    <input type='radio' name="gubun1" value='2' <%if(gubun1.equals("2")){%>checked<%}%>>미확인
        		    </td>
					<td class=title width=10%>정비일자 </td>
        		    <td colspan="3">&nbsp;
            		    <input type='radio' name="sort" value='1' <%if(sort.equals("1")){%>checked<%}%>>오름차순
            		    <input type='radio' name="sort" value='2' <%if(sort.equals("2")){%>checked<%}%>>내림차순
        		    </td>
				</tr>
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <%if(tire_gubun.equals("000156")){%>
    			<td colspan="2"><%if(white.equals("")){%><a href="javascript:search();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif" align="absbottom" border="0"></a> <%}%></td>
    	<%}else{%>
    			<td colspan="2"><%//if(white.equals("")){%><a href="javascript:search();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif" align="absbottom" border="0"></a> <%//}%></td>
    	<%}%>
    </tr>
	
</table>
</form>
</body> 
</html>
