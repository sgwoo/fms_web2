<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");		
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	String dt		= request.getParameter("dt")==null?"4":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String s_au = request.getParameter("s_au")==null?"":request.getParameter("s_au");
	
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
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
	theForm.action='/fms2/off_demand/off_dm_car_sc.jsp';
	theForm.target = "c_foot";
	theForm.submit();
}




function add_gubun2(idx, val, str){
	document.form1.gubun2[idx] = new Option(str, val);
}
function change_gubun2(){
	var fm = document.form1;
	var gbn = fm.gubun1.options[fm.gubun1.selectedIndex].value;
	var gbn_idx = fm.gubun2.options[fm.gubun2.selectedIndex].value;
	if(gbn == 0){
		if(gbn_idx == 0){
			td_blank.style.display 	= 'none';
			td_input.style.display 	= '';
		}else{
			td_blank.style.display 	= 'none';
			td_input.style.display 	= '';
		}
	}else{
		td_blank.style.display 	= 'none';
		td_input.style.display 	= '';
	}
}	

function ChangeDT(arg)
{
	var theForm = document.form1;
	if(arg=="ref_dt1")
	{
	theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
	}else if(arg=="ref_dt2"){
	theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
	}

}





//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan=6>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ADMIN > 외부요청자료 > <span class=style5>차량구입및매각내역</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
     <tr> 
        <td colspan=6>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jhgg.gif border=0 align=absmiddle>&nbsp;&nbsp;
        	<input type="radio" name="dt" value="4" <%if(dt.equals("4"))%>checked<%%>>
          연도별 
          <input type="radio" name="dt" value="6" <%if(dt.equals("6"))%>checked<%%>>
          월별&nbsp;&nbsp; 
            <input type="text" name="ref_dt1" size="11" value="2011-01-01" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
          ~ 
          <%String sDate = c_db.addMonth(AddUtil.getDate(), -1);
					  int kDay=0;
					  kDay= AddUtil.getMonthDate(Integer.parseInt(sDate.substring(0,4)),Integer.parseInt(sDate.substring(5,7)));
						String sMonth = sDate.substring(5,7);
					  sDate = sDate.substring(0,8)+kDay;
          %>
          <input type="text" name="ref_dt2" size="11" value="<%=sDate%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()"> 

            &nbsp;<a href="javascript:Search()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>
    
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
<script language='javascript'>

</script>
</html>