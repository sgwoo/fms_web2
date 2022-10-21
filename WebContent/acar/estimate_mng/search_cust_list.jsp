<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	Vector vars = new Vector();
	
	if(!t_wd.equals("") && !t_wd.equals(" ")){
		vars = e_db.getCustSubList(t_wd);
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
		fm.action = 'search_cust_list.jsp';
		fm.submit();
	}
	
	function setCode(st, nm, ssn, tel, fax, reg_dt, doc_type, est_email, spr_kd, spr_kd_rent_dt){
		var fm = opener.document.form1;	
		
		<%if(from_page.equals("/acar/secondhand/secondhand_price_20090901.jsp")){%>			
			fm.cust_nm.value 	= nm;
			fm.cust_ssn.value 	= ssn;			
			fm.cust_tel.value 	= tel;
			fm.cust_fax.value 	= fax;
			fm.doc_type.value 	= doc_type;
			fm.cust_email.value 	= est_email;
		<%}else{%>
			fm.est_nm.value 	= nm;
			fm.est_ssn.value 	= ssn;
			fm.est_tel.value 	= tel;
			fm.est_fax.value 	= fax;
			fm.doc_type[0].checked = true;
			if(doc_type == '1') fm.doc_type[0].checked = true;
			if(doc_type == '2') fm.doc_type[1].checked = true;
			if(doc_type == '3') fm.doc_type[2].checked = true;
			fm.est_email.value 	= est_email;
			var spr1 = '';
			var spr2 = '';
			if(spr_kd == '2') spr1 = '�ʿ췮';
			if(spr_kd == '1') spr1 = '�췮';
			if(spr_kd == '0') spr1 = '�Ϲݱ��';
			if(spr_kd == '3') spr1 = '�ż����';
			if(fm.spr_yn[0].checked == true) spr2 = '�ʿ췮';
			if(fm.spr_yn[1].checked == true) spr2 = '�췮';
			if(fm.spr_yn[2].checked == true) spr2 = '�Ϲݱ��';
			if(fm.spr_yn[3].checked == true) spr2 = '�ż����';
			if(spr1 != '' && spr1 != '�ʿ췮' && spr1 != spr2){
				sure = confirm('���� �ֱٿ� �Էµ� ���� ���('+spr_kd_rent_dt+')�� �ſ뵵�� ['+spr1+']�Դϴ�. \n������ �����Ͻñ� �ٶ��ϴ�. \n\n���� �ۼ����� ['+spr2+']�������� ��� �����Ͻðڽ��ϱ�?');
			}				
			//if(spr_kd == '2') alert('�ֱ� ����� �ʿ췮����Դϴ�.');	//fm.spr_yn[0].checked = true;
			//if(spr_kd == '1') alert('�ֱ� ����� �췮����Դϴ�.'); 	//fm.spr_yn[1].checked = true;
			//if(spr_kd == '0') alert('�ֱ� ����� �Ϲݱ���Դϴ�.'); 	//fm.spr_yn[2].checked = true;
			//if(spr_kd == '3') alert('�ֱ� ����� �ż������Դϴ�.'); 	//fm.spr_yn[3].checked = true;			
		<%}%>
		self.close();
	}
	
	function old_search(){
		var fm = document.form1;
		fm.action = 'search_cust_list_old.jsp';
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
<form name='form1' action='search_cust_list.jsp' method='post'>
<input type='hidden' name='size' value='<%=size%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>����ȸ</span></span></td>
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
        <td align="right"> <font color=red> �� �ֱ� 3�����̳� ����Ÿ</font> | <a href="javascript:old_search();">��絥��Ÿ</a>&nbsp;</td>
    </tr>          
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���������� (�ֱ� 3�����̳�, �ִ�10����)</span></td>
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
    		    <%	if(size >10) size = 10; %>	
              		<%for(int i = 0 ; i < size ; i++){
    					Hashtable var = (Hashtable)vars.elementAt(i);%>							
						<tr>
							<td align="center"><%=i+1%></td>
							<td>&nbsp;<a href="javascript:setCode('1', '<%=var.get("EST_NM")%>', '<%=var.get("EST_SSN")%>', '<%=var.get("EST_TEL")%>', '<%=var.get("EST_FAX")%>', '<%=var.get("REG_DT")%>', '<%=var.get("DOC_TYPE")%>', '<%=var.get("EST_EMAIL")%>', '', '');"><%=var.get("EST_NM")%></a></td>
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
	<%	if(!t_wd.equals("")){
				vars = e_db.getSpeCustSubList(t_wd);
			}
			size = vars.size();%>
    		    <%	if(size >10) size = 10; %>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����Ʈ������ (�ִ�10����)</span></td>
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
    					Hashtable var = (Hashtable)vars.elementAt(i);%>							
						<tr>
							<td align="center"><%=i+1%></td>
							<td>&nbsp;<a href="javascript:setCode('2', '<%=var.get("EST_NM")%>', '<%=var.get("EST_SSN")%>', '<%=var.get("EST_TEL")%>', '<%=var.get("EST_FAX")%>', '<%=var.get("REG_DT")%>', '<%=var.get("DOC_TYPE")%>', '<%=var.get("EST_EMAIL")%>', '', '');"><%=var.get("EST_NM")%></a></td>
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
	<%	if(!t_wd.equals("")){
				/*
				if(from_page.equals("/acar/secondhand/secondhand_price_20090901.jsp")){
					//�縮����
					vars = e_db.getLcCustSprSubList("0", t_wd);
				}else{
					//������
					vars = e_db.getLcCustSprSubList("1", t_wd);
				}
				*/
				vars = e_db.getLcCustSubList(t_wd);
			}
			
			size = vars.size();%>
    		    <%	if(size >5) size = 5; %>	
			
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���뿩�� (�ִ�5����)</span></td>
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
    					Hashtable var = (Hashtable)vars.elementAt(i);
    					Hashtable s_ht = new Hashtable();
    					if(from_page.equals("/acar/secondhand/secondhand_price_20090901.jsp")){
    						//�縮����
    						//s_ht = e_db.getLcCustSprSubCase("0", String.valueOf(var.get("CLIENT_ID")));
    					}else{
    						//������
    						s_ht = e_db.getLcCustSprSubCase("1", String.valueOf(var.get("CLIENT_ID")));
    					}
    					String spr_kd = "";
    					String spr_kd_rent_dt = "";
    					if(!String.valueOf(s_ht.get("SPR_KD")).equals("") && !String.valueOf(s_ht.get("SPR_KD")).equals("null")){
    						spr_kd = String.valueOf(s_ht.get("SPR_KD"));
    						spr_kd_rent_dt = String.valueOf(s_ht.get("RENT_DT"));
              			}
    				%>							
						<tr>
							<td align="center"><%=i+1%></td>
							<td>&nbsp;<a href="javascript:setCode('3', '<%=var.get("EST_NM")%>', '<%=var.get("EST_SSN")%>', '<%=var.get("EST_TEL")%>', '<%=var.get("EST_FAX")%>', '<%=var.get("REG_DT")%>', '<%=var.get("DOC_TYPE")%>', '<%=var.get("EST_EMAIL")%>', '<%=spr_kd%>', '<%=spr_kd_rent_dt%>');"><%=var.get("EST_NM")%></a></td>
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
	<%	if(!t_wd.equals("")){
				vars = e_db.getEmpSubList(t_wd);
			}
			size = vars.size();%>
    		    <%	if(size >5) size = 5; %>	
			
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������� (�ִ�5����)</span></td>
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
							<td>&nbsp;<a href="javascript:setCode('4', '<%=var.get("EST_NM")%>', '<%=var.get("EST_SSN")%>', '<%=var.get("EST_TEL")%>', '<%//=var.get("EST_FAX")%>', '<%=var.get("REG_DT")%>', '<%=var.get("DOC_TYPE")%>', '<%=var.get("EST_EMAIL")%>', '', '');"><%=var.get("EST_NM")%></a></td>
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