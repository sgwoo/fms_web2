<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String esti_m = request.getParameter("esti_m")==null?"":request.getParameter("esti_m");
	String esti_m_dt = request.getParameter("esti_m_dt")==null?"":request.getParameter("esti_m_dt");
	String esti_m_s_dt = request.getParameter("esti_m_s_dt")==null?"":request.getParameter("esti_m_s_dt");
	String esti_m_e_dt = request.getParameter("esti_m_e_dt")==null?"":request.getParameter("esti_m_e_dt");	
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//조회
	function search(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '2'||fm.s_kd.options[fm.s_kd.selectedIndex].value == '4'){ //작성자,상담자
			fm.t_wd.value = fm.reg_id.options[fm.reg_id.selectedIndex].value;		
		}
		fm.action = "esti_res_sc.jsp";
		fm.target = "c_foot";
		fm.submit();
	}
	function EnterDown(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
//-->
</script>
</head>
<body>
<form action="./esti_res_sc.jsp" name="form1" method="POST" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='gubun4' value=''> 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업관리 > 견적관리 > <span class=style5>일반대차견적서관리</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"> 
            <table border=0 cellpadding=0 cellspacing=1 width="100%">
                <tr> 
                    <td width="40%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_g_gj.gif align=absmiddle>&nbsp;
                        <select name="gubun1">
                            <option value="8" <%if(gubun1.equals("8"))%>selected<%%>>일반대차차량</option>
                        </select> 
                    </td>
                    <td width=60%>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td><img src=/acar/images/center/arrow_day_gj.gif align=absmiddle>&nbsp;
        						  <select name="s_dt" >
          						    <option value="" <%if(s_dt.equals("")){%> selected <%}%>>전체</option>        								  
        						    <% for(int i=2014; i<=AddUtil.getDate2(1); i++){%>
        						    <option value="<%=i%>" <%if(i == AddUtil.parseInt(s_dt)){%> selected <%}%>><%=i%>년도</option>
        						    <%}%>
        						  </select>			
						          <select name="e_dt">
          						    <option value="" <%if(e_dt.equals("")){%> selected <%}%>>전체</option>        
          						    <% for(int i=1; i<=12; i++){%>        
          						    <option value="<%=AddUtil.addZero2(i)%>" <%if(i == AddUtil.parseInt(e_dt)){%> selected <%}%>><%=AddUtil.addZero2(i)%>월</option>
          						    <%}%>
        						  </select>				
                                </td>
                                <td></td>
                            </tr>
                        </table> 
                    </td>
                    <td align="right">&nbsp;</td>
                </tr>
                <tr> 
                    <td colspan='2'>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width=100%>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>&nbsp;
                                <select name="s_kd">
                                    <option>전체</option>
                                    <option value="1" <%if(s_kd.equals("1"))%>selected<%%>>차량번호</option>
                                    <option value="2" <%if(s_kd.equals("2"))%>selected<%%>>차명</option> 
                                    <option value="3" <%if(s_kd.equals("3"))%>selected<%%>>신차등록일</option> 									
                                  </select> 
								  &nbsp;&nbsp;&nbsp;
								  <input type="text" name="t_wd" size="29" value="<%=t_wd%>" class=text  onKeyDown="javasript:EnterDown()"> 
								  </td>
                            </tr>
                        </table>
                    </td>
                    <td align=right><a href="javascript:search()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
					<!--&nbsp;&nbsp;&nbsp;<a href="javascript:esti_reg()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>-->
					</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>

