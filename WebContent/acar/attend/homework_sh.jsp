<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
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
	
	String chk1 = request.getParameter("chk1")==null?"m":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));		
	int year =AddUtil.getDate2(1);
	
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

	UserMngDatabase umd = UserMngDatabase.getInstance();
	//사용자 정보 조회
	user_bean 	= umd.getUsersBean(user_id);
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	function search(){
		var fm = document.form1;
		fm.action = "homework_sc.jsp";		
		fm.target = "c_foot";		
		fm.submit();
	}
	
	//휴가등록
	function free_reg()	{
		var SUBWIN="/fms2/free_time/free_time_i.jsp?auth_rw=4&ck_acar_id=<%=user_id%>&go_url=homework_sh.jsp";	
		window.open(SUBWIN, "free_reg", "left=100, top=50, width=750, height=400, scrollbars=yes");
	}	
	function SchReg()
	{
		var SUBWIN="/acar/schedule/sch_i.jsp?auth_rw=4&acar_id=<%=user_id%>&start_year=<%=s_year%>&start_mon=<%=s_month%>&start_day=<%=s_day%>&sch_chk=0&go_url=homework_sh.jsp";			
		window.open(SUBWIN, "SchDisp", "left=100, top=100, width=620, height=600, scrollbars=yes");
	}	
	//재택파트너관리
	function ChangeArs(){
		window.open("/fms2/menu/ars_user_search.jsp?user_id=<%=user_id%>&dept_id=<%=user_bean.getDept_id()%>&loan_st=<%=user_bean.getLoan_st()%>&ars_group=<%=user_bean.getArs_group()%>&go_url=homework_sh.jsp", "ARS_GROUP", "left=200, top=100, width=500, height=350, scrollbars=yes, status=yes, resizable=yes");
	}
	
	
//-->
</script>
</head>
<body onLoad="javascript:document.form1.t_wd.focus()">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
<form action="homework_sc.jsp" name="form1" method="POST" target="c_foot">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">	
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 	
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">  
<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">   	

    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 근태관리 > <span class=style5>휴가관리</span></span></td>
                    <td width=7><img src=./acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td> 
            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                <tr> 
                  	<td width="600">&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gg.gif align=absmiddle>&nbsp;
						<select name="s_year">
							<%for(int i=2020; i<=year+1; i++){%>
							<option value="<%=i%>" <%if(s_year == i){%>selected<%}%>><%=i%>년</option>
							<%}%>
						</select>
						<select name="s_month">
							<%for(int i=1; i<=12; i++){%>
							<option value="<%=i%>" <%if(s_month == i){%>selected<%}%>><%=i%>월</option>
							<%}%>
						</select>
				  		&nbsp;&nbsp;<img src=/acar/images/center/arrow_search.gif align=absmiddle>&nbsp;
                    	<select name="s_kd" onChange="javascript:document.form1.t_wd.focus()">
                			<option value="1" <%if(s_kd.equals("1")){%>selected<%}%>>부서</option>
                		</select>
                		&nbsp;
                		<input type='text' name="t_wd" value='<%=t_wd%>' size='15' class='text'>
                		&nbsp;
                		<a href='javascript:search()'><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
                	</td>
                	<td align='left'> 
            			공휴일 <span style="color: #FEE6E6;size:20px;">■</span>&nbsp;/&nbsp;
                    	휴가 <span style="color: #FFFF00;size:20px;">■</span>&nbsp;/&nbsp;
                    	재택근무 <span style="color: #349BD5;size:20px;">■</span>&nbsp;
                    	&nbsp;&nbsp;&nbsp;&nbsp;                    	
        			    <input type="button" class="button" value="휴가등록" onclick="javascript:free_reg();">&nbsp;
        			    <input type="button" class="button" value="재택등록" onclick="javascript:SchReg();">&nbsp;
        			    <%if(user_bean.getLoan_st().equals("")){%>            			    
        			    <input type="button" class="button" value="재택파트너관리" onclick="javascript:ChangeArs();">&nbsp;
        			    <%} %>            					                   
        			</td>   
                </tr>
            </table>
        </td>
    </tr>
</form>
</table>
</body>
</html>