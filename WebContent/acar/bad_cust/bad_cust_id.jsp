<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.bad_cust.*,acar.common.*"%>
<jsp:useBean id="bc_db" class="acar.bad_cust.BadCustDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "06", "02");
	
	String bc_nm = "";
	String bc_ent_no = "";
	String bc_lic_no = "";
	String bc_addr = "";
	String bc_firm_nm = "";
	String bc_cont = "";
	String reg_id = "";
	String reg_dt = "";
	String bc_m_tel = "";
	String bc_email = "";
	String bc_fax = "";
	
	int count = 0;
	
	if(!seq.equals(""))
	{
		BadCustBean bean = bc_db.getBadCustBean(seq);
		
		bc_nm = bean.getBc_nm();
		bc_ent_no = bean.getBc_ent_no();
		bc_lic_no = bean.getBc_lic_no();
		bc_addr = bean.getBc_addr();
		bc_firm_nm = bean.getBc_firm_nm();
		bc_cont = bean.getBc_cont();
		bc_m_tel = bean.getBc_m_tel();
		bc_email = bean.getBc_email();
		bc_fax = bean.getBc_fax();
		reg_id = bean.getReg_id();
		reg_dt = bean.getReg_dt();
	}
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function Save(idx){
		var fm = document.form1;
		if(!CheckField()){	return;	}
		
		if(idx == 'i'){
			if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}
			fm.cmd.value= "i";
		}else{
			if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
			fm.cmd.value= "u";
		}		
		fm.target="i_no";
		fm.submit();
	}

	function CheckField(){
		var fm = document.form1;		
		if(fm.bc_nm.value==""){			alert("������ �����Ͻʽÿ�.");			fm.bc_nm.focus();		return false;	}
		if(fm.bc_ent_no.value==""){		alert("��������� �����Ͻʽÿ�.");	fm.bc_ent_no.focus();	return false;	}
		//if(fm.bc_lic_no.value==""){		alert("���������ȣ�� �Է��Ͻʽÿ�.");	fm.bc_lic_no.focus();	return false;	}
		if(fm.bc_lic_no.value!=""){		//���������ȣ �ڸ���üũ �� formating ���� �߰�(2018.02.07)
			var chk_lic_no_res = CheckLic_no(fm.bc_lic_no.value);
			if(chk_lic_no_res=='N'){	return false;	}
		}
		return true;
	}
	
	//�� ��ȸ
	function search_client(){window.open("/fms2/client/client_s_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/acar/bad_cust/bad_cust_id.jsp","CLIENT","left=200,top=200,width=1100,height=600,scrollbars=yes,status=yes,resizable=yes");}
	
//-->
</script>
</head>
<body <%if(bc_nm.equals("")){%> onLoad="document.form1.bc_nm.focus()"<%} %>>
<center>
<form action="bad_cust_null_ui.jsp" name="form1" method="POST" >
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>"> 
  <input type="hidden" name="user_id" value="<%=user_id%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="s_kd" value="<%=s_kd%>">
  <input type="hidden" name="t_wd" value="<%=t_wd%>">    
  <input type="hidden" name="seq" value="<%=seq%>">   
  <input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5>�ҷ������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <%if(!reg_id.equals("")){%>
    <tr>
        <td>
        	<img src=/acar/images/center/arrow_ccdrj.gif align=absmiddle> : <%=c_db.getNameById(reg_id, "USER")%>&nbsp;&nbsp; <img src=/acar/images/center/arrow_ccdri.gif align=absmiddle> :
            <%=AddUtil.ChangeDate2(reg_dt)%>
        </td>
    </tr>   
    <%}%> 
     <tr>
        <td class=line2></td>
    </tr>	
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=title width="100">����</td>
                    <td> 
                        &nbsp;<input type="text" name="bc_nm" value="<%=bc_nm%>" size="40" style='IME-MODE: active' <%if(!bc_nm.equals("")){%>readonly class=whitetext <%}else{%>class=text <%}%>>                        
                        <%if(bc_nm.equals("")){%>
                        <span class="b"><a href='javascript:search_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
                        <%} %>
                    </td>
                </tr>
                <tr> 
                    <td class=title>�������(6�ڸ�)</td>
                    <td> 
                        &nbsp;<input type="text" name="bc_ent_no" value="<%=bc_ent_no%>" size="20" maxlength=8 <%if(cmd.equals("u")){%>class='whitetext' readlony<%}else{%>class='text'<%}%>>
                    </td>
                </tr>
                <tr> 
                    <td class=title>�ּ�</td>
                    <td> 
                        &nbsp;<input type="text" name="bc_addr" value="<%=bc_addr%>" size="90" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title>���������ȣ</td>
                    <td> 
                        &nbsp;<input type="text" name="bc_lic_no" value="<%=bc_lic_no%>" size="20" class=text onBlur='javscript:this.value = ChangeLic_no(this.value);'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>�޴�����ȣ</td>
                    <td> 
                        &nbsp;<input type="text" name="bc_m_tel" value="<%=bc_m_tel%>" size="20" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title>�̸����ּ�</td>
                    <td> 
                        &nbsp;<input type="text" name="bc_email" value="<%=bc_email%>" size="40" class=text style='IME-MODE: inactive'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>FAX</td>
                    <td> 
                        &nbsp;<input type="text" name="bc_fax" value="<%=bc_fax%>" size="20" class=text>
                    </td>
                </tr>
                <tr> 
                    <td class=title>���ؾ�ü</td>
                    <td> 
                        &nbsp;<input type="text" name="bc_firm_nm" value="<%=bc_firm_nm%>" size="60" class=text style='IME-MODE: active'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>���س���</td>
                    <td> 
                        &nbsp;<textarea name="bc_cont" cols="90" class="text" rows="13"><%=bc_cont%></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>�� �׸� ��ü�� �ʼ� �Է»����� �ƴմϴ�. �ƴ� ������ �Է��ϸ� �˴ϴ�. </td>
    </tr>    
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding=0 width=100%>
                <tr>
    			    <td align="right">
    			    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
    				<%if(seq.equals("")){%>
    	        	<a href="javascript:Save('i')"><img src=/acar/images/center/button_reg.gif align=absmiddle border="0"></a>&nbsp;
    				<%}else{%>
    	        	<a href="javascript:Save('u')"><img src=/acar/images/center/button_modify.gif align=absmiddle border="0"></a>&nbsp;
    				<%}%>
    			    <%}%>	
            		<a href="javascript:self.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border="0"></a></td>
    			</tr>
            </table>
        </td>
    </tr>
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>