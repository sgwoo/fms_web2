<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*,acar.user_mng.*, acar.estimate_mng.*"%>

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
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

	String jg_code = request.getParameter("jg_code")==null?"":request.getParameter("jg_code");
	
	//신)중고차잔가코드 20070316
	EstiDatabase edb = EstiDatabase.getInstance();
	Vector jgVarList = edb.getEstiJgVarList();
	int jgVarList_size = jgVarList.size();
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
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="" leftmargin=15 >
<form name='form1' action='basic_price_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  	<tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > 자동차관리 > <span class=style5>정비부품단가표</span></span></td>
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
                        <option value='1' <%if(gubun3.equals("1")){%>selected<%}%>>기준일자</option>				
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
                    <td class=title width=10%>차종코드</td>
                    <td colspan="3">&nbsp;
						<select name='jg_code'>
						  <option value="">=======선 택=======</option>
						  <%if(jgVarList_size > 0){
								for(int i = 0 ; i < jgVarList_size ; i++){
									Hashtable jgVar = (Hashtable)jgVarList.elementAt(i); %>
						  <option value='<%= jgVar.get("SH_CODE") %>' <%if(jg_code.equals(jgVar.get("SH_CODE"))){%>selected<%}%>> [<%= jgVar.get("SH_CODE") %>]<%= jgVar.get("CARS") %> </option>
						  <% }
							}%>
						</select>
                	</td>
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
