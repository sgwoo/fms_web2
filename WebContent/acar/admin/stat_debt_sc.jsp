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
	//등록하기
	function save(){
		var fm = document.form1;	
		if(fm.save_dt.value != ''){ alert("이미 마감 등록된 부채현황입니다."); return; }				
		var i_fm = i_view.form1;
		i_view.save();
/*		if(i_fm.save_dt.value != ''){ alert("이미 마감등록된 부채현황입니다."); return; }
		if(!confirm('마감하시겠습니까?'))
			return;
		i_fm.target='i_no';
		i_fm.submit();				
*/
	}

	//당일조회
	function TodaySearch(today){
		var fm = document.form1;	
		var i_fm = i_view.form1;
		fm.view_dt.value = today;
		fm.save_dt.value = '';				
		i_fm.save_dt.value = '';
		i_fm.target='i_view';
		i_fm.action='stat_debt_sc_in_view.jsp';		
		i_fm.submit();				
	}
	
	//운전자금관리
	function StatDebtAmtMng(cpt_cd, h_amt, j_amt){
		var fm = document.form1;	
		fm.a_cpt_cd.value 	= cpt_cd;
		fm.a_h_amt.value 	= h_amt;
		fm.a_j_amt.value 	= j_amt;
		fm.target='_blank';
		fm.action='stat_debt_amt_null.jsp';		
		
		if(fm.user_id.value == '000029') 	fm.action='/fms2/bank_mng/working_fund_frame.jsp';		
		
		fm.submit();				
	}	
  
//리스트 엑셀 전환
function pop_excel(){
	var fm = document.form1;
	fm.target = "_blank";

	fm.action = "popup_excel_debt.jsp?save_dt=" + ChangeDate_nb(fm.view_dt.value) ;
	fm.submit();
}		

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
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	auth_rw = rs_db.getAuthRw(user_id, "09", "03", "01");
	
	
	if(save_dt.equals(""))	save_dt = ad_db.getMaxSaveDt("stat_debt");
		
		
	int cnt = 4; //현황 출력 영업소 총수
	int sh_height = cnt*sh_line_height;
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	
	if(height < 50) height = 150;
%>
<form action="stat_debt_sc_null.jsp" name="form1" method="POST">
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 재무분석 > <span class=style5>부채현황</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
		<td colspan=2><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>부채현황 리스트</span></td>
    </tr>
    <tr> 
		<td colspan="2"><iframe src="./stat_debt_sc_in_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_list" width="100%" height="50" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0" scrolling="yes"></iframe> 
		</td>
    </tr>    
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr> 
            		<td>&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gji.gif align=absmiddle> :<input type='text' name='view_dt' size='11' value='<%=AddUtil.ChangeDate2(save_dt)%>' class="white" readonly> (원금기준)</td>
            		<td align="right"> 
                    <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
                    <a href="javascript:save();"><img src=../images/center/button_mg.gif align=absmiddle border=0></a>
                    &nbsp;
                    <%}%>
                    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                    <a href="javascript:pop_excel();"><img src=../images/center/button_excel.gif align=absmiddle border=0></a> 
                    <%}%>
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
                      차입금액</td>
                    <td class=title width=10% rowspan="3">차월이월<br>
                      차입금액</td>
                    <td class=title colspan="4">당월차입금변동</td>
                </tr>
                <tr> 
                    <td class=title width=10% rowspan="2">당월신규<br>
                      차입금액</td>
                    <td class=title colspan="3">당월상환차입금액</td>
                </tr>
                <tr> 
                    <td class=title width=10%>예정금액</td>
                    <td class=title width=10%>상환금액</td>
                    <td class=title width=10%>잔액</td>
                </tr>
            </table>
		</td>
		<td width="16">&nbsp;</td>
	</tr>
	<tr> 
		<td colspan="2"><iframe src="./stat_debt_sc_in_view.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>" name="i_view" width="100%"  class="autoHeight" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
		</td>
	</tr>
	<tr> 
		<td class="line"> 
			<table width="100%" border="0" cellspacing="1" cellpadding="1">
                <tr align="center"> 
                    <td class=title colspan="4" width=40%>총계</td>
                    <td class=title width=10%>
                      <input type="text" name="tot_last_amt" size="13" value="" class="sum" readonly>
                    </td>
                    <td class=title width=10%>
                      <input type="text" name="tot_over_amt" size="13" value="" class="sum" readonly>
                    </td>
                    <td class=title width=10%>
                      <input type="text" name="tot_new_amt" size="13" value="" class="sum" readonly>
                    </td>
                    <td class=title width=10%>
                      <input type="text" name="tot_plan_amt" size="13" value="" class="sum" readonly>
                    </td>
                    <td class=title width=10%>
                      <input type="text" name="tot_pay_amt" size="13" value="" class="sum" readonly>
                    </td>
                    <td class=title width=10%>
                      <input type="text" name="tot_jan_amt" size="13" value="" class="sum" readonly>
                    </td>
                </tr>
            </table>
		</td>
		<td width="16">&nbsp;</td>
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
