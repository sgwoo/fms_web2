<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*, acar.user_mng.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
  


function doIframe(){
    o = document.getElementsByTagName('iframe');

    for(var i=0;i<o.length;i++){  
        if (/\bautoHeight\b/.test(o[i].className)){
            setHeight(o[i]);
            addEvent(o[i],'load', doIframe);
        }
    }
}

function setHeight(e){
    if(e.contentDocument){
        e.height = e.contentDocument.body.offsetHeight + 35; //높이 조절
    } else {
        e.height = e.contentWindow.document.body.scrollHeight;
    }
}

function addEvent(obj, evType, fn){
    if(obj.addEventListener)
    {
    obj.addEventListener(evType, fn,false);
    return true;
    } else if (obj.attachEvent){
    var r = obj.attachEvent("on"+evType, fn);
    return r;
    } else {
    return false;
    }
}

if (document.getElementById && document.createTextNode){
 addEvent(window,'load', doIframe); 
} 

//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	
	
	auth_rw = rs_db.getAuthRw(user_id, "09", "03", "01");
	
	//리스료현황
	if(save_dt.equals(""))	save_dt = ad_db.getMaxSaveDt("stat_debt");
		
		
	int cnt = 4; //현황 출력 영업소 총수
	int sh_height = cnt*sh_line_height;
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	
	if(height < 50) height = 150;
%>
<form action="" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='a_cpt_cd' value=''>
<input type='hidden' name='a_h_amt' value=''>
<input type='hidden' name='a_j_amt' value=''>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
	<tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 재무분석 > <span class=style5>리스료현황</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
		<td colspan=2><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>리스료현황 리스트</span></td>
    </tr>
    <tr> 
		<td colspan="2"><iframe src="./stat_debt_ls_sc_in_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="50" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0" scrolling="yes"></iframe> 
		</td>
    </tr>    
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr> 
            		<td>&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gji.gif align=absmiddle> :<input type='text' name='view_dt' size='11' value='<%=AddUtil.ChangeDate2(save_dt)%>' class="white" readonly></td>
            		<td align="right"> 
                    
                   </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
		<td class="line"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class=title width=40% colspan="4" rowspan="3">구분</td>
                    <td class=title width=10% rowspan="3">전월이월<br>
                      금액</td>
                    <td class=title width=10% rowspan="3">차월이월<br>
                      금액</td>
                    <td class=title colspan="4">당월지급분변동</td>
                </tr>
                <tr> 
                    <td class=title width=10% rowspan="2">당월신규<br>
                      금액</td>
                    <td class=title colspan="3">당월지급금액</td>
                </tr>
                <tr> 
                    <td class=title width=10%>예정금액</td>
                    <td class=title width=10%>지급금액</td>
                    <td class=title width=10%>잔액</td>
                </tr>
            </table>
		</td>
		<td width="16">&nbsp;</td>
	</tr>
	<tr> 
		<td colspan="2"><iframe src="./stat_debt_ls_sc_in_view.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_view" width="100%"  class="autoHeight" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
		</td>
	</tr>

	<tr>
	    <td align=right colspan=2><span class=style4>(단위:원)</span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
	</tr>
	<tr>
        <td class=h></td>
    </tr>

</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
