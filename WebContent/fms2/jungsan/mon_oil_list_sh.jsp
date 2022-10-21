<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String dt		= request.getParameter("dt")==null?"1":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
//   	String st_mon		= request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
//	String st_year		= request.getParameter("st_year")==null?"":request.getParameter("st_year");

	int st_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int st_mon = request.getParameter("s_mon")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_mon"));	
	int year =AddUtil.getDate2(1);
	int mon =AddUtil.getDate2(2);
		
	int cnt = 3; //현황 출력 총수
	int sh_height = cnt*sh_line_height;
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50-15;//현황 라인수만큼 제한 아이프레임 사이즈

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--

		
function Search(){
		var fm = document.form1;
	
	        if(  fm.ref_dt1.value == '' || fm.ref_dt2.value == '' ) alert("기간을 입력하세요!!");
	        
	        
		fm.action="mon_oil_list_sc.jsp";
			
		fm.target="cd_foot";		
		fm.submit();
}

function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') Search();
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

</head>
<body>
<form  name="form1" method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan=3>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 정산서 > <span class=style5>업무유류비 월별내역</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>
    <tr> 
      <td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_ggjh.gif" >&nbsp;      
      	    <input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
              ~ 
              <input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()"> 
			  
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_jrjg.gif" >&nbsp;
                           <input type="radio" name="dt" value="1" <%if(dt.equals("1"))%>checked<%%>>
              			평균연비 
            	        <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
              	  	평균주유단가 
			  &nbsp;&nbsp;&nbsp;<a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>	
	  		  
			  
	<!--		  
		<select name="st_year">
				<%for(int i=2012; i<=year; i++){%>
				<option value="<%=i%>" <%if(year == i){%>selected<%}%>><%=i%>년</option>
				<%}%>
			</select> 
			<select name="st_mon">
				<%for(int i=1; i<=12; i++){%>
				<option value="<%=i%>" <%if(st_mon == i){%>selected<%}%>><%=i%>월</option>
				<%}%>
			</select>
			   </td>
                      	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_jrjg.gif" >&nbsp;
                           <input type="radio" name="dt" value="1" <%if(dt.equals("1"))%>checked<%%>>
              			평균연비 
            	        <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
              	  	평균주유단가 
			  &nbsp;&nbsp;&nbsp;<a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>		-->    
      
    </tr>  
    <tr>
    <tr><td class=h></td></tr>
    </tr>
  </table>
  </form>
  <iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</table>
</body>