<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, tax.*, acar.im_email.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String reg_dt = request.getParameter("reg_dt")==null?AddUtil.getDate():request.getParameter("reg_dt");
	
	
	ImEmailDatabase ie_db = ImEmailDatabase.getInstance();
	
	Vector vts1 = ScdMngDb.getTodayActStat("item", reg_dt);
	int vt_size1 = vts1.size();
	
	Vector vts2 = ScdMngDb.getTodayActStat("tax", reg_dt);
	int vt_size2 = vts2.size();
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function Search(){
		var fm = document.form1;
		if(fm.reg_dt.value == ''){ alert('������ڸ� �Է��Ͻʽÿ�.'); return; }
		fm.action="send_mail.jsp";
		fm.target="d_content";		
		fm.submit();
	}
	
	function p_tax_ebill_item_email(reg_code){
		var fm = document.form1;
		if(confirm('û�����̸����� �߼��Ͻðڽ��ϱ�?')){
			fm.reg_code.value = reg_code;
			fm.action = '/tax/issue_1_item/tax_reg_step3_proc.jsp';
			fm.target = 'i_no';
			fm.submit();		
		}
	}		
	function p_tax_ebill_tax_email(tax_code){
		var fm = document.form1;
		if(confirm('��꼭�̸����� �߼��Ͻðڽ��ϱ�?')){		
			fm.reg_code.value = tax_code;
			fm.action = '/tax/tax_mng/p_tax_ebill_email.jsp';
			fm.target = 'i_no';
			fm.submit();		
		}
	}	
	function p_tax_ebill_tax_sms(tax_code){
		var fm = document.form1;
		if(confirm('��꼭���ڸ� �߼��Ͻðڽ��ϱ�?')){		
			fm.reg_code.value = tax_code;
			fm.action = '/tax/tax_mng/p_tax_ebill_sms.jsp';
			fm.target = 'i_no';
			fm.submit();		
		}
	}			
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='reg_code' value=''>
<input type='hidden' name='from_page' value='/tax/send_mail/send_mail.jsp'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>

	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>���ݰ�꼭���� > <span class=style5>û�����ȳ����Ϲ߼�</span></span></td>
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
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������� : <input name="reg_dt" type="text" class="taxtext" value="<%=AddUtil.ChangeDate2(reg_dt)%>" size="11" onBlur='javscript:this.value = ChangeDate(this.value);'> </span>
	  <a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>
	  </td>
    </tr>	
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ŷ�����</span></td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>		 
          <tr>
            <td width='5%' class='title'>����</td>
            <td width="15%" class='title'>�۾��ڵ�</td>
            <td width="10%" class='title'>��ϰǼ�</td>
            <td width="10%" class='title'>���ϰǼ�</td>
            <td class='title'>-</td>			
          </tr>
          <%	for(int i = 0 ; i < vt_size1 ; i++){
				      Hashtable ht = (Hashtable)vts1.elementAt(i);
					  
					  int mail_cnt  = ie_db.getMailRegCnt("2", String.valueOf(ht.get("GUBUN")), "�ŷ�����");%>
          <tr>
            <td align='center'><%=i+1%></td>
            <td align='center'><%=ht.get("GUBUN")%></td>
            <td align='center'><%=ht.get("CNT")%></td>
            <td align='center'><%=mail_cnt%></td>						
            <td>&nbsp;
                <%if(mail_cnt==0){%>
                    <a href="javascript:p_tax_ebill_item_email('<%=ht.get("GUBUN")%>');" title='���� �ϰ� ����'><img src="/acar/images/center/button_jbh.gif" align="absmiddle" border="0"></a>
                    (���ϸ� �߼�)      
                <%}%>
            </td>
          </tr>
          <%	}%>		
        </table>
      </td>
    </tr>
    
    <tr>
        <td class=h></td>
    </tr>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ݰ�꼭</span></td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>		 
          <tr>
            <td width='5%' class='title'>����</td>
            <td width="15%" class='title'>�۾��ڵ�</td>
            <td width="10%" class='title'>��ϰǼ�</td>
            <td width="10%" class='title'>���ϰǼ�</td>
            <td class='title'>-</td>			
          </tr>
          <%	for(int i = 0 ; i < vt_size2 ; i++){
				      Hashtable ht = (Hashtable)vts2.elementAt(i);
					  int mail_cnt  = ie_db.getMailRegCnt("2", String.valueOf(ht.get("GUBUN")), "���ݰ�꼭");%>
          <tr>
            <td align='center'><%=i+1%></td>
            <td align='center'><%=ht.get("GUBUN")%></td>
            <td align='center'><%=ht.get("CNT")%></td>
            <td align='center'><%=mail_cnt%></td>						
            <td>&nbsp;
                <!-- 20140212 Ʈ������ �ý��� �̿����� ������,�ָ��϶��� ���Ͽ� ���ڸ� �߼۰����ϵ��� -->	                
                    <a href="javascript:p_tax_ebill_tax_sms('<%=ht.get("GUBUN")%>');" title='���� �ϰ� ����'><img src="/acar/images/center/button_jbh.gif" align="absmiddle" border="0"></a>
                    (������,�ָ� ����� ���ڸ� �߼�)                
            </td>
          </tr>
          <%	}%>		
        </table>
      </td>
    </tr>    
    <tr>
        <td class=h></td>
    </tr>	
    <tr>
        <td></td>
    </tr>		
    <tr>
        <td>* ��ϵ� û�����߿� ���Ͼ�ü ���� �ִٸ� ��ϰǼ����� ���ϰǼ��� ���� �� �ֽ��ϴ�.</td>
    </tr>		
    <tr>
        <td>* ���ϰǼ��� 0�϶��� ���� �ִ� [�����] ������ư�� Ŭ���ϸ� ������ �ϰ��߼۵˴ϴ�.</td>
    </tr>		
    <tr>
        <td>* ������ ���Űźη� �� ���� ���Ե��� �ʽ��ϴ�.</td>
    </tr>		
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
