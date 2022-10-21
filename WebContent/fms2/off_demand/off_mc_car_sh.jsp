<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();

	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String dt		= request.getParameter("dt")==null?"4":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<!DOCTYPE html>
<html>
<head>
<title>FMS</title>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="javascript">
<!--
function EnterDown()
{
	var keyValue = event.keyCode;
	if (keyValue =='13') Search();
}
function Search()
{
	var theForm = document.form1;
	if(theForm.ref_dt1.value == ''){ alert('시작일을 입력하십시오.'); return;}
	if(theForm.ref_dt2.value == ''){ alert('종료일을 입력하십시오.'); return;}
	theForm.action='/fms2/off_demand/off_mc_car_sc.jsp';
	theForm.target = "c_foot";	
	theForm.submit();
}

function ChangeDT(arg)
{
	var theForm = document.form1;
	if(arg=="ref_dt1")
	{
		theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
	}else if(arg=="ref_dt2")
	{
		theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
	}
}

//-->
</script>
</head>
<body>
<form name='form1' method='post'>
<input type="hidden" name="sh_height" value="<%=sh_height%>">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan=6>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>FMS운영관리 > ADMIN > <span class=style5>매출형태</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
     <tr> 
        <td colspan=6>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <select name='gubun'>
            <option value=''  <%if(gubun.equals("")){%>selected<%}%>>전체</option>
            <option value='1' <%if(gubun.equals("1")){%>selected<%}%>>장기대여</option>
            <option value='3' <%if(gubun.equals("3")){%>selected<%}%>>장기대여-렌트</option>
            <option value='4' <%if(gubun.equals("4")){%>selected<%}%>>장기대여-리스</option>
            <option value='2' <%if(gubun.equals("2")){%>selected<%}%>>월렌트</option>		  
          </select>
          &nbsp;&nbsp;
          <img src=/acar/images/center/arrow_jhgg.gif border=0 align=absmiddle>&nbsp;&nbsp;
        	<input type="radio" name="dt" value="4" <%if(dt.equals("4")){%>checked<%}%>>
          		연도별 &nbsp;
            <% 	String sDate = c_db.addMonth(AddUtil.getDate(), -1);
				int kDay=0;
				kDay= AddUtil.getMonthDate(Integer.parseInt(sDate.substring(0,4)),Integer.parseInt(sDate.substring(5,7)));
				String sMonth = sDate.substring(5,7);
				sDate = sDate.substring(0,8)+kDay;
            %>
            <input type="text" name="ref_dt1" size="12" value="2012-12-31" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
          		~ 
            <input type="text" name="ref_dt2" size="12" value="<%=sDate%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()"> 
            &nbsp;
            <a href="javascript:Search()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>
    
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
<script language='javascript'>

</script>
</html>