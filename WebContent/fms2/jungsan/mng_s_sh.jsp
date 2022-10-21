<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
			
	int year =AddUtil.getDate2(1);
//	int year = 2017;
	int mon =AddUtil.getDate2(2);
	
	String st_mon		= request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
	
	int cnt = 3; //현황 출력 총수
	int sh_height = cnt*sh_line_height;
		
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
function Search()
{
		var fm = document.form1;
		
		fm.action="mng_s_sc.jsp";
		
		fm.target="cd_foot";		
		fm.submit();
}


function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') Search();
}


function mon_display(){
		var fm = document.form1;
		
		for(var i = 0 ; i < 4 ; i++){
			fm.st_mon.options[4-(i+1)] = null;
		}
		
		if ( fm.st_year.value == '2011' ) {
			fm.st_mon.options[0]  = new Option('2분기', '2');
			fm.st_mon.options[1]  = new Option('3분기', '3');
			fm.st_mon.options[2]  = new Option('4분기', '4');
		} else {
			fm.st_mon.options[0] = new Option('1분기', '1');
			fm.st_mon.options[1] = new Option('2분기', '2');
			fm.st_mon.options[2] = new Option('3분기', '3');		
			fm.st_mon.options[3] = new Option('4분기', '4');		
		}				
}

function Jungsan(){
		
		var fm = document.form1;
		var SUBWIN="oil_jung_popup.jsp?user_id="+fm.user_id.value+"&auth_rw="+fm.auth_rw.value;	
		window.open(SUBWIN, "card_popup", "left=50, top=50, width=500, height=300, scrollbars=yes, status=yes");
		
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
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    

  <table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=5>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 복리후생비 > <span class=style5>외근 유류대 분기정산</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>
     <tr> 
      <td> 
        <table width="100%" border="0" cellpadding="0" cellspacing="1">
          <tr> 
          	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_ggjh.gif" >&nbsp;
			 
		            <select name="st_year"  >
						<%for(int i=2018; i<=year; i++){%>
						<option value="<%=i%>" <%if(year == i){%>selected<%}%>><%=i%>년</option>
						<%}%>
					</select> 
					
					<select name="st_mon"  >	
					      <option value="" <%if(st_mon.equals(""))%>selected<%%>>전체</option>		 			
		                  <option value="1" <%if(st_mon.equals("1"))%>selected<%%>>1분기</option>		             
		                  <option value="2" <%if(st_mon.equals("2"))%>selected<%%>>2분기</option>
		                  <option value="3" <%if(st_mon.equals("3"))%>selected<%%>>3분기</option>
		                  <option value="4" <%if(st_mon.equals("4"))%>selected<%%>>4분기</option>
			
		            </select>						
			&nbsp;&nbsp;&nbsp;<a href="javascript:Search()"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a>
			</td>
		</tr>
	        <tr>    
	             <td align=right>  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	           <a href='javascript:Jungsan()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_jungs.gif" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;
	             <%}%> 
	      	</td>
      	</tr>
      	
        </table>
      </td>   
    </tr>
    <tr><td class=h></td></tr>
   
  </form>
 <!--  <iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> -->
</table>
</body>