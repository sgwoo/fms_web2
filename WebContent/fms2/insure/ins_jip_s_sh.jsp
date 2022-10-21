<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>

<%@ include file="/acar/cookies.jsp" %>


<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
//	String  s_dt = "20150210";
	String s_dt = request.getParameter("s_dt")==null?"20150210":request.getParameter("s_dt");
	String s_use = request.getParameter("s_use")==null?"2":request.getParameter("s_use");
		
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
				
		fm.action="ins_jip_s_sc.jsp";			
		
		fm.target="cd_foot";		
		fm.submit();
}


function magam()
{
	var theForm = document.form1;
	
	if(!confirm('마감하시겠습니까?'))
		return;
			
	theForm.action = 'stat_end_null.jsp';		
	theForm.target = 'i_no';
					
	theForm.submit();	
	
}

	//리스트 출력 전환
function pop_print()
{
	var fm = document.form1;
	
     	fm.target = "_blank";
	
	fm.action = "ins_jip_print.jsp";
	fm.submit();
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
						<span class=style1>사고관리 > 보험현황 > <span class=style5>용도별 갱신에정현황</span></span></td>
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
			 
			 <select name="s_dt"  >				
		                  <option value="20140210" <%if(s_dt.equals("20140210"))%>selected<%%>>20140210</option>		 
		                  <option value="20150210"  <%if(s_dt.equals("20150210"))%>selected<%%>>20150210</option>
		           </select>		
		           
		        					
			<select name="s_use"  >				
		        <!--          <option value="1" <%if(s_use.equals("1"))%>selected<%%>>영업용</option>		 -->             
		                  <option value="2" <%if(s_use.equals("2"))%>selected<%%>>업무용</option>
		          
		            </select>						
			&nbsp;&nbsp;&nbsp;<a href="javascript:Search()"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a>
			 <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
			  <a href="javascript:magam()">.</a>	
			<%}%>			  
			</td>		
            
             <td align=right>         
   	     <a href="javascript:pop_print()"><img src="/acar/images/center/button_print.gif"  align="absmiddle" border="0"></a>
       	  </td>
         </tr>
        </table>
      </td>
   
    </tr>
  </form>
  <iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</table>
</body>