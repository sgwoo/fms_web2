<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String gubun1		= request.getParameter("gubun1")==null?"9":request.getParameter("gubun1");
		
	int cnt = 2; //현황 출력 총수
	int sh_height = cnt*sh_line_height;
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50-15;//현황 라인수만큼 제한 아이프레임 사이즈

%>

<html>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language='javascript'>
<!--
function enter() 
{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
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

function Search(){
		var fm = document.form1;
	
		fm.action="s_money_sc.jsp";
			
		fm.target="c_foot";		
		fm.submit();
}

			
//-->
</script>

</head>
<body>
<form name='form1'  method='post' >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">     
  
<table border="0" cellspacing="0" cellpadding="0" width=800>
	<tr> 
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp; <span class=style1>인사관리 > 특정수당 ><span class=style5>특정수당</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>            
		</td>
	</tr>
	<tr> 
		<td class=h></td>
	</tr>
	<tr>
		<td class=''>
			<table border="0" cellspacing="0" cellpadding='0' width=100%>
			
				 <td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_ggjh.gif" >&nbsp;
			 
			              <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
			              당월 
			              <input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
			              당해 			            
			              <input type="radio" name="dt" value="4" <%if(dt.equals("4"))%>checked<%%>>
			              조회기간
						  &nbsp;&nbsp;
							<input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
			              ~ 
			              <input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()"> 
						  
						  &nbsp;&nbsp;&nbsp;<a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>	
		                     <td><input type="checkbox" name="minus" value="Y" onClick='javascript:Search()'> 실지급액  마이너스 포함</td>				  
				    			   
		   </tr>  
    
				<tr>
					<td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jhgb.gif align=absmiddle> 
					 &nbsp;
						<select name="gubun1">
			                        	<option value="9" <%if(gubun1.equals("9")){%>selected<%}%>>제안포상금</option>
			                        	<option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>영업캠페인</option>
			                        	<option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>채권캠페인</option>
			                        	<option value="30" <%if(gubun1.equals("30")){%>selected<%}%>>비용(1군)캠페인</option>
			                        	<option value="29" <%if(gubun1.equals("29")){%>selected<%}%>>비용(2군)캠페인</option>
			                        	<option value="6" <%if(gubun1.equals("6")){%>selected<%}%>>제안캠페인</option>
			                      <!--   	<option value="28" <%if(gubun1.equals("28")){%>selected<%}%>>비용(1군-사고)캠페인</option>
			                        	<option value="5" <%if(gubun1.equals("5")){%>selected<%}%>>비용(1군-정비)캠페인</option> -->
							<option value="8" <%if(gubun1.equals("8")){%>selected<%}%>>통신비증빙</option>
						</select>
					</td>	
						     
				</tr>
			</table>
		</td>
	</tr>  

</table>
</form>
</body>
</html>
