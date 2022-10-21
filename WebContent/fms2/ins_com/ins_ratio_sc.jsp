<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	if(user_id.equals(""))	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getXmlAuthRw(user_id, "09", "04", "15");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String s_yy = request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	
	int cnt = 2; //검색 라인수
	int sh_height = cnt*sh_line_height;
	
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50-75;//현황 라인수만큼 제한 아이프레임 사이즈
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
	function Search(){
		var fm = document.form1;
		//if(fm.s_yy.value == ''){ alert('기간 시작일을 입력하십시오'); fm.s_yy.focus(); return;}		
		//if(fm.s_mm.value == ''){ alert('기간 종료일을 입력하십시오'); fm.s_mm.focus(); return;}				
		var i_fm = i_view.form1;
		i_fm.s_yy.value = fm.s_yy.value;
		i_fm.s_mm.value = fm.s_mm.value;		
		i_fm.target='i_view';
		i_fm.action='ins_ratio_sc_in_view.jsp';		
		i_fm.submit();				
	}
	
//추가등록
function Reg_ratio()
{
	var fm = document.form1;
	window.open("about:blank", "MK", "left=250, top=50, width=600, height=500, scrollbars=yes, status=yes");				
	fm.action = "ins_ratio_i.jsp";
	fm.target = "MK";
	fm.submit();				
}		
//-->
</script>
</head>
<body>

<form action="" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
    	<td >
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 재무회계 > <span class=style5>보험손해/사고율현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td>    
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <select name="gubun1">
    			<option value="">선택</option>
    			<option value="0038" selected>렌터카공제조합</option>
    		</select>  
	   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;기간조회:
        &nbsp;<input type="text" name="s_yy" size="11" value="" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
        ~
        <input type="text" name="s_mm" size="11" value="" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
        &nbsp;&nbsp;
        
        <a href="javascript:Search();"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
        &nbsp;&nbsp; 
        </td>
    </tr>	
    <tr> 
        <td>&nbsp;</td>
    </tr>		
    <tr> 
        <td><iframe src="./ins_ratio_sc_in_view.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_yy=<%=s_yy%>&s_mm=<%=s_mm%>&gubun1=<%=gubun1%>" name="i_view" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>
</table>
<table border=0 cellspacing=0 cellpadding=0 width="800">  
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
        <td align=right><a href="javascript:Reg_ratio();"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a></td>
    </tr>
</table>
</form>
</body>
</html>
