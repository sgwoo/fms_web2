<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	Vector vars = new Vector();
	
	if(!t_wd.equals("") && !t_wd.equals(" ")){
		vars = e_db.getCustSubJudgeList(t_wd);
	}
	
	int size = vars.size();
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"> 
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//�˻��ϱ�
	function search(){
		var fm = document.form1;	
		if(fm.t_wd.value == ''){ alert('�˻�� �Է��Ͻʽÿ�.'); fm.t_wd.focus(); return; }	
		fm.action = 'search_cust_list_judge.jsp';
		fm.submit();
	}
	
	//�ŷ�ó ��ü�ݾ�
	function cl_dlyamt(client_id)
	{
		window.open('/acar/account/stat_settle_sc_in_view_sub_list_client.jsp?client_id='+client_id, "CLIENT_DLVAMT", "left=10, top=10, width=1200, height=560, resizable=yes, scrollbars=yes, status=yes");
	}
	
//-->
</script>
</head>
<body>
<form name='form1' action='search_cust_list_judge.jsp' method='post'>
<input type='hidden' name='size' value='<%=size%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>�ɻ�� ����ȸ</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><select name="s_kd"> 
				<option value="1" selected>�˻���</option> 
			</select> 
			<input accesskey="s" class="keyword" title=�˻��� type="text" name="t_wd" value="<%=t_wd%>"> 
			<a href="javascript:search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>
    </tr>	
    <tr> 
        <td class=h></td>
    </tr>	      
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���������� (�ִ�20����)</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=5%>����</td>
                    <td class=title width=30%>��ȣ �Ǵ� ����</td>
                    <td class=title width=15%>����ڹ�ȣ �Ǵ�<br>�������</td>
                    <td class=title width=15%>��ȭ��ȣ</td>
                    <td class=title width=14%>�̸���</td>
                    <td class=title width=10%>���ʰ���</td>					
                    <td class=title width=10%>�ֱٰ���</td>					
    		    </tr>			
    		    <%	if(size >20) size = 20; %>	
              	<%	for(int i = 0 ; i < size ; i++){
    					Hashtable var = (Hashtable)vars.elementAt(i);%>							
						<tr>
							<td align="center"><%=i+1%></td>
							<td>&nbsp;<%=var.get("EST_NM")%></td>
							<td>&nbsp;<%=var.get("EST_SSN")%></td>
							<td>&nbsp;<%=var.get("EST_TEL")%></td>
							<td>&nbsp;<%=var.get("EST_EMAIL")%></td>
							<td align="center"><%=var.get("REG_DT2")%><br><%=var.get("USER_NM2")%></td>
							<td align="center"><%=var.get("REG_DT")%><br><%=var.get("USER_NM")%></td>							
						</tr>
              	<%}%>				
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>	
	<%	size = 0;
		if(!t_wd.equals("")){
			vars = e_db.getSpeCustSubList(t_wd);
		}
		size = vars.size();%>
    <%	if(size >20) size = 20; %>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����Ʈ������ (�ִ�20����)</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=5%>����</td>
                    <td class=title width=30%>��ȣ �Ǵ� ����</td>
                    <td class=title width=20%>����ڹ�ȣ �Ǵ�<br>�������</td>
                    <td class=title width=20%>��ȭ��ȣ</td>
                    <td class=title width=17%>�̸���</td>
                    <td class=title width=20%>�������</td>					
    		    </tr>				
			
              		<%for(int i = 0 ; i < size ; i++){
    					Hashtable var = (Hashtable)vars.elementAt(i);
    					String est_st = String.valueOf(var.get("EST_ST"));
    				%>							
						<tr>
							<td align="center"><%=i+1%></td>
							<td>&nbsp;<%if(est_st.equals("PM1")||est_st.equals("PM2")||est_st.equals("PM3")){%>[����Ʈ����] <%}%><%=var.get("EST_NM")%></td>
							<td>&nbsp;<%=var.get("EST_SSN")%></td>
							<td>&nbsp;<%=var.get("EST_TEL")%></td>
							<td>&nbsp;<%=var.get("EST_EMAIL")%></td>
							<td align="center"><%=var.get("REG_DT")%></td>																					
						</tr>
              		<%}%>				
            </table>
        </td>
    </tr>		
    <tr> 
        <td class=h></td>
    </tr>		
	<%	size = 0;
		if(!t_wd.equals("")){			
			vars = e_db.getLcCustSubList(t_wd);
		}	
		size = vars.size();%>
    <%	if(size >20) size = 20; %>				
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���뿩�� (�ִ�20����)</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=5%>����</td>
                    <td class=title width=30%>��ȣ �Ǵ� ����</td>
                    <td class=title width=20%>����ڹ�ȣ �Ǵ�<br>�������</td>
                    <td class=title width=15%>��ȭ��ȣ</td>
                    <td class=title width=20%>�̸���</td>
                    <td class=title width=10%>��ü�ݾ�</td>
    		    </tr>				
			
              		<%for(int i = 0 ; i < size ; i++){
    					Hashtable var = (Hashtable)vars.elementAt(i);%>							
						<tr>
							<td align="center"><%=i+1%></td>
							<td>&nbsp;<%=var.get("EST_NM")%> / <%=var.get("CLIENT_NM")%></td>
							<td>&nbsp;<%=var.get("EST_SSN")%></td>
							<td>&nbsp;<%=var.get("EST_TEL")%></td>
							<td>&nbsp;<%=var.get("EST_EMAIL")%></td>
							<td align="center"><a href="javascript:cl_dlyamt('<%=var.get("CLIENT_ID")%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
						</tr>
              		<%}%>				
            </table>
        </td>
    </tr>	
    <tr> 
        <td class=h></td>
    </tr>		
	<%	size = 0;
		if(!t_wd.equals("")){
			vars = e_db.getEmpSubList(t_wd);
		}	
		size = vars.size();%>
    <%	if(size >20) size = 20; %>	
			
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������� (�ִ�20����)</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=5%>����</td>
                    <td class=title width=30%>��ȣ �Ǵ� ����</td>
                    <td class=title width=20%>����ڹ�ȣ �Ǵ�<br>�������</td>
                    <td class=title width=30%>��ȭ��ȣ</td>
                    <td class=title width=20%>�̸���</td>					
    		    </tr>							
              		<%for(int i = 0 ; i < size ; i++){
    					Hashtable var = (Hashtable)vars.elementAt(i);%>							
						<tr>
							<td align="center"><%=i+1%></td>
							<td>&nbsp;<%=var.get("EST_NM")%></td>
							<td>&nbsp;<%=AddUtil.subDataCut(var.get("EST_SSN")+"",7)%></td>
							<td>&nbsp;<%=var.get("EST_TEL")%></td>
							<td>&nbsp;<%=var.get("EST_EMAIL")%></td>
						</tr>
              		<%}%>				
            </table>
        </td>
    </tr>			
    <tr> 
        <td align="right"> 
			<a href="javascript:self.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
        </td>
    </tr>  
</table>
</form>
</body>
</html>