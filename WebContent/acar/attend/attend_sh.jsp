<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "10", "01", "01");
	
	String chk1 = request.getParameter("chk1")==null?"d":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));		
	int year =AddUtil.getDate2(1);
	
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function search(){
		var fm = document.form1;
		if(fm.chk1[0].checked == true){
			fm.action = "attend_sc.jsp";
		}else{
			fm.action = "attend_sc2.jsp";		
		}
				
		fm.target = "c_foot";		
		fm.submit();
	}
	
	function search1(){
		var fm = document.form1;
		
		if ( fm.s_kd.value == '2' ){		  
		} else {
		  alert("검색항목을 이름으로 선택하세요!");	
		  return; 		
		} 
		
		if ( fm.t_wd.value == '' ){		
		  alert("이름을 입력하세요!");	
		  return; 		
		} 
		
		if(fm.chk1[1].checked == false){
	     alert("월별을 선택하세요!");
	     return;
	   }  	
		
		fm.action = "attend_sc3.jsp";
						
		fm.target = "c_foot";		
		fm.submit();
	}
	
	//등록하기
	function sch_reg()	{
		var fm = document.form1;
		window.open("sch_i.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&chk1=<%=chk1%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_year=<%=s_year%>&s_month=<%=s_month%>&s_day=<%=s_day%>", "ATT_REG", "left=100, top=100, width=620, height=500, scrollbars=yes");
	}
	//일괄등록하기
	function sch_reg_all()	{
		var fm = document.form1;
		window.open("sch_all_i.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&chk1=<%=chk1%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_year=<%=s_year%>&s_month=<%=s_month%>&s_day=<%=s_day%>", "ATT_REG", "left=100, top=100, width=620, height=400, scrollbars=yes");
	}
	
//-->
</script>
</head>
<body onLoad="javascript:document.form1.t_wd.focus()">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
<form action="attend_sc2.jsp" name="form1" method="POST" target="c_foot">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">	
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 	
    <tr>
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 근태관리 > <span class=style5>출근관리</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h colspan=2></td>
    </tr>
    <tr> 
        <td> 
            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                <tr> 
                    <td width="150">&nbsp;&nbsp;<input name="chk1" type="radio" value="d" <%if(chk1.equals("d")){%>checked<%}%>>
                      일별 
                      <input type="radio" name="chk1" value="m" <%if(chk1.equals("m")){%>checked<%}%>>
                      월간</td>
                    <td width="250"><img src=../images/center/arrow_gg.gif align=absmiddle>
                      &nbsp;<select name="s_year">
                        <%for(int i=2016; i<=year; i++){%>
                        <option value="<%=i%>" <%if(s_year == i){%>selected<%}%>><%=i%>년</option>
                        <%}%>
                      </select> <select name="s_month">
                        <%for(int i=1; i<=12; i++){%>
                        <option value="<%=i%>" <%if(s_month == i){%>selected<%}%>><%=i%>월</option>
                        <%}%>
                      </select> <select name="s_day">
                        <%for(int i=1; i<=31; i++){%>
                        <option value="<%=i%>" <%if(s_day == i){%>selected<%}%>><%=i%>일</option>
                        <%}%>
                      </select></td>
                    <td width="230"><img src=../images/center/arrow_search.gif align=absmiddle>
                      &nbsp;<select name="s_kd" onChange="javascript:document.form1.t_wd.focus()">
                        <option value="" <%if(s_kd.equals("")){%>selected<%}%>>전체</option>
                        <option value="1" <%if(s_kd.equals("1")){%>selected<%}%>>부서</option>
                        <option value="2" <%if(s_kd.equals("2")){%>selected<%}%>>이름</option>
                      </select> <input type='text' name="t_wd" value='<%=t_wd%>' size='15' class='text'> 
                    </td>
                    <td>
                      <input type="button" class="button" id="p_attend" value='검색' onclick="javascript:search();">&nbsp;&nbsp;                 	   
                 	   <input type="button" class="button" id="p_attend1" value='개인 월간 일자별' onclick="javascript:search1();">                    
                    </td>
                </tr>
            </table>
        </td>
        <td align="right">
      
        <%if(user_id.equals("000063")){%>
        <a href='javascript:sch_reg()'><img src=../images/center/button_reg.gif border=0 align=absmiddle></a>
        <a href='javascript:sch_reg_all()'><img src=../images/center/button_igdr.gif border=0 align=absmiddle></a>	  
        <%}%>
        
        </td>
    </tr>
</form>
</table>
</body>
</html>