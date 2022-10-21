<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	/*여기부터 수정문안*/
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?Util.getDate():request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?Util.getDate():request.getParameter("ref_dt2");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String sort = request.getParameter("sort")==null?"7":request.getParameter("sort");
	String g_fm = "1";
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function SearchRentCond()
{
	var theForm = document.RentCondSearchForm;
	theForm.target = "c_foot";
	theForm.submit();
}
function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') SearchRentCond();
}
function ChangeDT(arg)
{
	var theForm = document.RentCondSearchForm;
	if(arg=="ref_dt1")
	{
	theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
	}else if(arg=="ref_dt2"){
	theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
	}

}

	//디스플레이 타입
	function cng_input(){
		var fm = document.RentCondSearchForm;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '3'){
			td_nm.style.display 	= '';
		}else{
			td_nm.style.display 	= 'none';
		}
	}
	
		//수정하기
	function nocall()
	{
	
		var fm = parent.c_foot.inner.form1;
		var len = fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck = fm.elements[i];
			if(ck.name == 'ch_all'){
				if(ck.checked == true){
					cnt++;
					idnum = ck.value;
				}
			}
		}
		
		if(cnt == 0){ alert("비대상을 선택하세요 !"); return; }
		if(!confirm('Call 비대상으로 지정하시겠습니까?')){	return;	}
		fm.action = "call_reg_cont_u_a.jsp";
		fm.target = "i_no";
//		fm.target='nodisplay';
		fm.submit();
				
				
	}	
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
<style>
.ml-btn-6 {
	display: inline-block;
	text-decoration: none;
	font-family: "Nanum Gothic";
	font-size: 13px;
	font-weight: bold;
	line-height: 240%;
	color: rgb(255, 255, 255);
	text-align: center;
	text-shadow: 0px 1px 0px rgba(0,0,0,0.5);
	background-color: rgba(22, 130, 202, 1);
	background-image: -moz-linear-gradient(53% 100% 90deg,rgb(83,91,95) 0%,rgb(95,106,112) 100%);
	background-image: -webkit-gradient(linear,53% 100%,53% 3%,color-stop(0, rgb(83,91,95)),color-stop(1, rgb(95,106,112)));
	background-image: -webkit-linear-gradient(90deg,rgb(83,91,95) 0%,rgb(95,106,112) 100%);
	background-image: -o-linear-gradient(90deg,rgb(83,91,95) 0%,rgb(95,106,112) 100%);
	
	width: 70px;
	height: 25px;
	border-color: rgb(0, 0, 0);
	border-width: 1px;
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	border-radius: 3px;
	border-style: solid;
	-moz-box-shadow: 0px 0px 0px 3px rgba(0, 0, 0, 0.1) , inset 0px 1px 0px rgba(255, 255, 255, 0.25);
	-webkit-box-shadow: 0px 0px 0px 3px rgba(0, 0, 0, 0.1) , inset 0px 1px 0px rgba(255, 255, 255, 0.25);
	box-shadow: 0px 0px 0px 3px rgba(0,0,0,0.1), inset 0px 1px 0px rgba(255,255,255,0.25);
	-ms-filter: "progid:DXImageTransform.Microsoft.gradient(startColorstr=#ff5f6a70,endColorstr=#ff535b5f,GradientType=0)
		progid:DXImageTransform.Microsoft.Glow(Color=#ff000000,Strength=3)";
	filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=#ff5f6a70,endColorstr=#ff535b5f,GradientType=0)
		progid:DXImageTransform.Microsoft.Glow(Color=#ff000000,Strength=3);
}

</style>
</head>
<body>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
		<tr>
    	<td>
    	    <table width="100%" border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7 rowspan=2><img src="/acar/images/center/menu_bar_1.gif" width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/menu_bar_dot.gif" width=4 height=5 align=absmiddle>&nbsp;<span class=style1>콜센터 > <span class=style5>콜항목관리</span></span></td>
                    <td width=7 rowspan=2><img src="/acar/images/center/menu_bar_2.gif" width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<form action="./survey_ds_sc.jsp" name="RentCondSearchForm" method="POST" target="c_foot">
    <tr>
        <td>
            <table border=0 cellspacing=1 width=100%>
                <tr> 
					<td width="300">&nbsp;&nbsp;&nbsp;
						<input type="radio" name="gubun1" value="1" <%if(gubun1.equals("1"))%>checked<%%>>계약 
						<input type="radio" name="gubun1" value="2" <%if(gubun1.equals("2"))%>checked<%%>>순회정비
						<input type="radio" name="gubun1" value="3" <%if(gubun1.equals("3"))%>checked<%%>>사고처리
					</td>
                    <td width="200">&nbsp;&nbsp;&nbsp;<input type="radio" name="dt" value="1" <%if(dt.equals("1"))%>checked<%%>>
                    당월 
                    <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
                    당해 
                    <input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
                    조회기간 </td>
                    <td width=130><img src="/acar/images/center/arrow_g.gif">&nbsp;
                        <select name="gubun2" onChange="javascript:cng_input()">          
                        <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>계약일</option>
                        <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>대여개시일</option>
                        <option value="3" <%if(gubun2.equals("3"))%>selected<%%>>상호</option>
                      </select></td>
                    <td width=165> <input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
                    ~ 
                    <input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()"> 
                    </td>            
                    <td align="left" width="74"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td id='td_nm' style='display:none'> 
                                <input type='text' size='10' name='st_nm' class='text' value=''>
                                </td>
                            </tr>
                        </table>
                    </td>                       
                    <td width="68" align=left><a href="javascript:SearchRentCond()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a> </td>
                    <%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                    <td>&nbsp;</td>
                    <td align=right >
					<%if(!gubun1.equals("1")){%>
					<a href='javascript:yescall()' onMouseOver="window.status=''; return true" onfocus="this.blur()" class="ml-btn-6" style="text-decoration: none;" >대상저장</a>&nbsp;
					<%}else{%>
					<a href='javascript:nocall()' onMouseOver="window.status=''; return true" onfocus="this.blur()" class="ml-btn-6" style="text-decoration: none; background-color: rgba(255, 5, 9, 1);">대상제외</a>
					<%}%>
					</td>
                    <%}%>          
                </tr>
            </table>
        </td>
    </tr>

<input type='hidden' name='sh_height' value='<%=sh_height%>'> 	    
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</table>
</body>
</html>