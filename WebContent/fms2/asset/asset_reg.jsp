<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.asset.*"%>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function save(work_st)
	{
		var fm = document.form1;
		
		if(work_st == '') { alert('������ �۾��մϱ�? �� �� �����ϴ�.'); return;}
		
		fm.work_st.value = work_st;
		if (work_st == 'asset_move_chk') {	
			fm.target = 'ii_no';
		} else {
			fm.target = 'i_no';
		}
		fm.action = 'asset_reg_a.jsp';
		fm.submit();
		
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
	String cnt = request.getParameter("cnt")==null?"":request.getParameter("cnt");
	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int year =AddUtil.getDate2(1);
	
	year = 2022; //�ڻ��� �ش�⵵ �̿��� ������������ ���س⵵�� ���;� ��. �̿��� �ȵȻ��¿��� ���/�Ű�/������ �� �� ����. -�߿�!!!!!
	
%>
<form name='form1'  method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='work_st' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
		<td colspan=3>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>�繫ȸ�� > �ڻ���� > <span class=style5>�ڻ����</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>  
	<tr>
	    <td class=line2></td>
	</tr>
    <tr>
	    <td class='line'>
    	  <table border="0" cellspacing="1" cellpadding="0" width=100%>
    		<tr>
    		  <td width='22%' class='title'>�ڻ��� ����</td>
    		  <td>
                  &nbsp;<select name="s_year">
                    <%for(int i=year; i<=year; i++){%>
                    <option value="<%=i%>" <%if(s_year == i){%>selected<%}%>><%=i%>��</option>
                    <%}%>
                  </select>
                  <% if ( !cnt.equals("4")) { %> 
                  <select name="s_month">
                  
                    <%for(int i=1; i<=12; i++){%>
                       <option value="<%=i%>" <%if(s_month == i){%>selected<%}%>><%=i%>��</option>
                    <%}%>
                  <% } %>  
                  </select>
                  <% if ( cnt.equals("6")) { %> 
                  <select name="s_gubun">
                     <option value="1" >��Ʈ</option>
                     <option value="2" >����</option>
                  <% } %>  
                  </select>
    		  </td>
    		</tr>
    	  </table>
	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  
 <% if (cnt.equals("1")) { %>  
  <tr>
	<td><a href="javascript:save('asset_ma_reg')"><img src="/acar/images/center/button_reg_cdjs.gif" align="absmiddle" border="0"></a>&nbsp;����ڻ� ���</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
<% } %>
<% if (cnt.equals("2")) { %>  
  <tr>
	<td><a href="javascript:save('asset_move_reg')"><img src="/acar/images/center/button_reg_bgjs.gif" align="absmiddle" border="0"></a>&nbsp;�����ڻ� ��� </td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
<% } %>	   
<% if (cnt.equals("3")) { %>  
  <tr>
	<td><a href="javascript:save('asset_move2_reg')"><img src="/acar/images/center/button_reg_mgjs.gif" align="absmiddle" border="0"></a>&nbsp;�Ű��ڻ� ��� </td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
<% } %>	   
 <% if (cnt.equals("4")) { %>  	    
  <tr>
	<td> <a href="javascript:save('asset_ydep_reg')"><img src="/acar/images/center/button_ggsg_niw.gif" align="absmiddle" border="0"></a>&nbsp;������ ���̿� </td>
  </tr>
  
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;���̿�ó���� �ݵ�� �������� �ڻ굥��Ÿ �������  (������ �Ǵ� sqlgate���� �Ʒ����� ����) <br>	  	
	  	select count(*) from fassetma_bak2;  <br>
		select count(*) from fassetmove_bak2; <br>
		select count(*) from fassetdep_bak2;  <br>
		select count(*) from fyassetdep_bak2; <br>	
		select count(*) from fassetdep_green_bak2; <br>	
		select count(*) from fyassetdep_green_bak2; <br>	
		select count(*) from fassetma;  <br>
		select count(*) from fassetmove; <br>
		select count(*) from fassetdep;  <br>
		select count(*) from fyassetdep; <br>		
		select count(*) from fassetdep_green; <br>		
		select count(*) from fyassetdep_green; <br>		
		truncate table fassetma_bak2; <br>		
		truncate table fassetmove_bak2; <br>		
		truncate table fassetdep_bak2; <br>		
		truncate table fyassetdep_bak2; <br>		
		truncate table fassetdep_green_bak2; <br>		
		truncate table fyassetdep_green_bak2; <br>		
		insert into fassetma_bak2 select * from fassetma; <br>		
		insert into fassetmove_bak2 select * from fassetmove;  <br>		
		insert into fassetdep_bak2 select * from fassetdep;  <br>		
		insert into fyassetdep_bak2 select * from fyassetdep;  <br>
		insert into fassetdep_green_bak2 select * from fassetdep_green;  <br>
		insert into fyassetdep_green_bak2 select * from fyassetdep_green;  <br>
		commit; <br>
	</td>
  </tr>
<% } %>
 <% if (cnt.equals("5")) { %>  	    
  <tr>
	<td><a href="javascript:save('asset_move_chk')"><img src="/acar/images/center/button_check_bgjs.gif" align="absmiddle" border="0"></a>&nbsp;�����ڻ� üũ </td>
  </tr>  
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
<% } %>
 <% if (cnt.equals("6")) { %>  	    
  <tr>
	<td><a href="javascript:save('update_assetma')"><img src="/acar/images/center/button_car_cjcr.gif" align="absmiddle" border="0"></a>&nbsp;������� ���� ó�� </td>
  </tr>  
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
<% } %>
<% if (cnt.equals("7")) { %>  	    
  <tr>
	<td><a href="javascript:save('insert_assetmove_s')"><img src="/acar/images/center/button_tsscr.gif" align="absmiddle" border="0"></a>&nbsp;Ư�Ҽ� ó��</td>
  </tr>  
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
<% } %>
<% if (cnt.equals("8")) { %>  	    
  <tr>
	<td><a href="javascript:save('insert_assetmove_green')">���ź����� ó��</a>&nbsp;���ź����� ó��</td>
  </tr>  
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
<% } %>

<% if (cnt.equals("9")) { %>  	    
  <tr>
	<td><a href="javascript:save('update_assetma_deprf')">�ڻ����(deprf_yn=6 ó��)</a>&nbsp;�ڻ����(deprf_yn=6 ó��)</td>
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
