<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, card.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function save(job_st)
	{
		var fm = document.form1;
		
		
		if(confirm('등록하시겠습니까?')){		
			fm.action='user_budget_iwol_a.jsp?job_st='+job_st;
			fm.target='i_no';
			fm.submit();
		}		
		
	
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String job_st = request.getParameter("job_st")==null?"":request.getParameter("job_st");
	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));
	
	int year =AddUtil.getDate2(1);

	String s_sys = Util.getDate();
	String byear = s_sys.substring(0,4);
%>
<form name='form1'  method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='work_st' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=400>
  <tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 법인전표관리 > <span class=style5>
						예산한도관리</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>

  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
        <td class=line2></td>
  </tr>
  <tr>
	<td class='line'>
	  <table border="0" cellspacing="1" cellpadding="0" width=400>
	  	<tr>
		  <td width='100' class='title'>구분</td>
		  <td width="300">
           &nbsp;<input type="radio" name="bu_st" value="1" >복지비
      <!--     &nbsp;<input type="radio" name="bu_st" value="2" checked >유류대 -->
                 <input type="radio" name="bu_st" value="3" checked >팀장활동비</td>
          </td>
		</tr>
		<tr>
		  <td width='100' class='title'>기준</td>
		  <td width="300">
              <select name="s_year">
            	
				    			
                <%for(int i=2013; i<=year; i++){%>
                <option value="<%=i%>" <%if(s_year == i){%>selected<%}%>><%=i%>년</option>
                <%}%> 
              </select> 
              <% if ( !job_st.equals("1")) { %> 
              <select name="s_month">
              
                <%for(int i=1; i<=12; i++){%>
                   <option value="<%=i%>" <%if(s_month == i){%>selected<%}%>><%=i%>월</option>
                <%}%>
              <% } %>  
              </select>
              <% if ( !job_st.equals("1")) { %> 
               <input type="text" name="s_amt"  size="10" class=num style="text-align:right;" >
              <% } %>  
            
		  </td>
		</tr>
	  </table>
	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
   <% if (job_st.equals("1")) { %>  
  <tr>
	<td> <a href="javascript:save('1')"><img src=/acar/images/center/button_niw.gif border=0 align=absmiddle></a>&nbsp;년이월 (* 마감할 연도를 선택함)</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
<% } %>
<% if (job_st.equals("2")) { %>  
  <tr>
	<td> <a href="javascript:save('2')"><img src=/acar/images/center/button_jj_m.gif border=0 align=absmiddle></a>&nbsp;월금액지정</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
<% } %>	   

  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>