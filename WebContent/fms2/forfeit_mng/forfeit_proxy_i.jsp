<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<% 
	//�α��� ���������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	int flag1 = 0;
	int count = 0;	

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun"); //1:�����,������� 2:��Ÿ
	String[] chk_cd = request.getParameterValues("ch_l_cd");

	String vid_num="";
	
	String ch_m_id="";  
	String ch_l_cd="";
	String ch_c_id="";
	String ch_seq_no="";
	String ch_cust_nm="";
	String ch_dem_dt="";		
	String ch_e_dem_dt="";	
%>

<html>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//���
	function Save()
	{
		var fm = document.form1;	
		
		if(fm.proxy_est_dt.value == '')	{	alert('���ο������ڸ� �Է��Ͻʽÿ�.'); 	fm.proxy_est_dt.focus(); 		return; }

		if(confirm('����Ͻðڽ��ϱ�?')){					
			fm.action='forfeit_proxy_i_a.jsp';		
			fm.target='i_no';
			//fm.target='_blank';			
			fm.submit();
		}
	}
	

//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
<input type='hidden' name='search_code' value=''>
<%	
	//�Ľ�
	for(int i=0; i<chk_cd.length;i++){
		vid_num=chk_cd[i];
	//System.out.println("vid_num="+vid_num);
		StringTokenizer token1 = new StringTokenizer(vid_num,"^");
				
		while(token1.hasMoreTokens()) {
				
				ch_m_id = token1.nextToken().trim();	 
				ch_l_cd = token1.nextToken().trim();	 
				ch_c_id = token1.nextToken().trim();	 
				ch_seq_no = token1.nextToken().trim();
				ch_cust_nm = token1.nextToken().trim();		
				
				//�������·� ���Ϻ����°��ϰ� �ڸ��� ���߷��� �߰���.2012-11-22
				//if  ( gubun.equals("1")) {
					ch_dem_dt = token1.nextToken().trim();
					ch_e_dem_dt = token1.nextToken().trim();
				//}	
		}		
%>
  <input type="hidden" name="m_id" value="<%=ch_m_id%>">
  <input type="hidden" name="l_cd" value="<%=ch_l_cd%>">
  <input type="hidden" name="c_id" value="<%=ch_c_id%>">
  <input type="hidden" name="seq_no" value="<%=ch_seq_no%>">    
  <input type="hidden" name="dem_dt" value="<%=ch_dem_dt%>">
  <input type="hidden" name="e_dem_dt" value="<%=ch_e_dem_dt%>">
    
<%	}%>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>������ > ���·���� > <span class=style5>���ϳ��Խ�������</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>	<tr><td class=h></td></tr>
	
	<tr><td class=line2 colspan=2></td></tr>
    <tr> 
    	<td colspan="2" class="line">
    		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
                               		
          		<tr> 
            		<td class='title' width='100'>���ο�������</td>
            		<td>&nbsp; <input name="proxy_est_dt" type="text" class="text" value="<%=AddUtil.getDate()%>" size="12" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
            		
          		</tr>  
          		<tr> 
            		<td class='title'>����</td>
            		<td>&nbsp; 
					  <input type='radio' name="reg_st" value='1' checked>
        				��û��+��ݵ��
        			  <input type='radio' name="reg_st" value='2'>
       					��ݵ�ϸ�						
					</td>					
          		</tr>      		
          		<tr> 
            		<td class='title'>���ó��</td>
            		<td>&nbsp; 
					  <input type='radio' name="reg_type" value='1' checked>
        				����
        			  <input type='radio' name="reg_type" value='2'>
       					���� (�ѱ����ΰ��� ������Ϻ�)
						
					</td>					
          		</tr>      
          		<tr> 
            		<td class='title'>�۱����տ���</td>
            		<td>&nbsp; 
					  <input type='radio' name="act_union_yn" value='N' checked>
        				�����۱� (���������忡 ������ȣǥ��)
						<br>&nbsp; 
        			  <input type='radio' name="act_union_yn" value='Y'>
       					���ռ۱� (���� ����ó�� ��� �۱�ó��)
						
					</td>					
          		</tr>      						
				
        	</table>
        </td>
    </tr>   
    <tr>
    	<td class=h></td>
    </tr>
    <tr>
        <td>&nbsp; </td>
        <td align="right">
      		<a href="javascript:Save()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>

      	</td>
    </tr> 
</table>  
<input type='hidden' name='user_id' value='<%=user_id%>'>   
<input type='hidden' name='gubun' value='<%=gubun%>'>         
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>  
</body>
</html>