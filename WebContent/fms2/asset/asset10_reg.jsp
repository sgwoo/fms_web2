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
	
//		fm.target = 'i_no';
		
//		fm.action = 'asset_reg_a.jsp';
//		fm.submit();
		
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
	
	year = 2021; //�ڻ��� �ش�⵵ �̿��� ������������ ���س⵵�� ���;� ��. �̿��� �ȵȻ��¿��� ���/�Ű�/������ �� �� ����. -�߿�!!!!!
		
	//�ڻ� -  ��Ʈ :2008��~2015��: 6���
    //��Ʈ: 2016����� 6.5�� ��
    //����: 2015����� 6.5�� ��
    

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
  
  <% if (cnt.equals("2")) { %>  	    
  <tr>
	<td> <!--<a href="javascript:save('asset_ydep_reg')">5���ڻ꿡 �ݿ� </a> -->&nbsp;5���ڻ꿡 �ݿ� </td>
  </tr>
  
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;���̿�ó���� �ݵ�� �������� �ڻ굥��Ÿ �������  (������ �Ǵ� sqlgate���� �Ʒ����� ����) <br>	  
		select count(*) from fyassetdep5_bak; <br>
		select count(*) from fassetdep5_bak; <br>
		select count(*) from fyassetdep5_green_bak; <br>
		select count(*) from fassetdep5_green_bak; <br>
		select count(*) from asset_bak; <br>
		select count(*) from fyassetdep5; <br>
		select count(*) from fassetdep5; <br>
		select count(*) from fyassetdep5_green; <br>
		select count(*) from fassetdep5_green; <br>
		select count(*) from asset; <br><br>
		
		truncate  table fyassetdep5_bak; <br>
		truncate  table fassetdep5_bak;  <br>
		truncate  table fyassetdep5_green_bak; <br>
		truncate  table fassetdep5_green_bak; <br>
		truncate  table asset_bak; <br><br>
			      
		insert into fyassetdep5_bak  select * from fyassetdep5; <br>
		insert into fassetdep5_bak  select * from fassetdep5; <br>
		insert into fyassetdep5_green_bak  select * from fyassetdep5_green; <br>
		insert into fassetdep5_green_bak  select * from fassetdep5_green;  <br>
		insert into asset_bak  select * from asset; <br><br>

	 	P_INSERT_YASSETDEP5 (�ڻ��̿�)  �̿����ڻ� <br>
	    P_INSERT_ASSETMASTER5_N (�������)  <br>
	    P_INSERT_ASSETMOVE3_5_N (�ڻ꺯��) <br>
	    P_INSERT_ASSETMOVE_GREEN5(���κ�����) <br>
		P_INSERT_ASSETMOVE2_5_N (�Ű�) <br>
	    P_INSERT_ASSET (5�����)<br><br>
	    
	    ����: P_INSERT_YASSETDEP5(2019)
	     P_INSERT_ASSETMASTER5_N(2020) ,  P_INSERT_ASSETMOVE3_5_N(2020) , P_INSERT_ASSETMOVE_GREEN5(2020), <br>
	     P_INSERT_ASSETMOVE2_5_N(2020), P_INSERT_ASSET(2020) <br>
	     ����Ÿ�� �ѹ��� ����� ��� , ���� �̿��� ���س⵵ �������� �ݿ����� 5���ڻ��� ����� ���
	     
	
	</td>
  </tr>
<% } %>

</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
