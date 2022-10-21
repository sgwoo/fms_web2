<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.secondhand.*" %>
<jsp:useBean id="shBn" class="acar.secondhand.SecondhandBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq 			= request.getParameter("seq")==null?"":request.getParameter("seq");
	String situation 	= request.getParameter("situation")==null?"":request.getParameter("situation");
	String memo 		= request.getParameter("memo")==null?"":request.getParameter("memo");
	String cust_nm 		= request.getParameter("cust_nm")==null?"":request.getParameter("cust_nm");	
	String cust_tel 	= request.getParameter("cust_tel")==null?"":request.getParameter("cust_tel");	
	String damdang_id 	= request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function regReserveCar(gubun){
		fm = document.form1;
		
		if(fm.cust_nm.value=='' || fm.cust_tel.value=='') { alert('���� �� ����ó�� �Է��Ͻʽÿ�.'); return; }
		<%if(from_page.equals("/acar/secondhand/secondhand_sc.jsp") &&situation.equals("2")){%>
			//if(fm.cust_sms_yn.value=='Y') {
			if(fm.cust_sms_yn.checked == true) {
				fm.cust_sms_y.value = 'YS';
			}
		<%}%>
		<%if(from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp")&&situation.equals("2")){%>
			//if(fm.cust_sms_yn.value=='Y') {
			if(fm.cust_sms_yn.checked == true) {
				if(fm.sms_msg.value!='' && fm.sms_msg2.value=='') { alert('���湮�� �غ� �ȳ����ڴ� �湮��ҵ� �����Ͻʽÿ�.'); return; }
				fm.cust_sms_y.value = 'YM';
			}
		<%}%>			
		fm.gubun.value = gubun;
		if(!confirm("���� �Ͻðڽ��ϱ�?"))	return;
		fm.action = "reserveCarM_a.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
function SendSms(){
	var fm = document.form1;
	
	if(fm.cust_nm.value=='' || fm.cust_tel.value=='') { alert('���� �� ����ó�� �Է��Ͻʽÿ�.'); return; }
	<%if(from_page.equals("/acar/secondhand/secondhand_sc.jsp")){%>
		if(fm.sms_msg2.value=='') { alert('���湮�� ������ �ȳ����ڸ� �����Ͻʽÿ�.'); return; }
	<%}%>
	<%if(from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp")){%>
		if(fm.sms_msg.value=='' && fm.sms_msg2.value=='') { alert('���湮�� �غ� �ȳ����ڸ� �����Ͻʽÿ�.'); return; }
		if(fm.sms_msg.value!='' && fm.sms_msg2.value=='') { alert('���湮�� �غ� �ȳ����ڴ� �湮��ҵ� �����Ͻʽÿ�.'); return; }
	<%}%>

	if(!confirm('���ڸ� ���� �Ͻðڽ��ϱ�?')){	return;	}
	
	fm.gubun.value = 'sms';
	
	fm.action = "reserveCar_iu.jsp";
	fm.target = "i_no";
	fm.submit();
}	
//-->
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="seq" value="<%=seq%>">
<input type="hidden" name="damdang_id" value="<%=damdang_id%>">
<input type="hidden" name="from_page" value="<%=from_page%>">
<input type="hidden" name="gubun" value="">
<input type="hidden" name="cust_sms_y" value="">
<input type="hidden" name="situation" value="<%=situation%>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td >
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>�������� �޸����</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>	
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2 ></td>
    </tr>
    <tr> 
        <td class="line">
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td width="20%" class=title>�����Ȳ</td>
                    <td width="80%">&nbsp;
        			<%if (situation.equals("0")) {%>
        				�����
        			<%} else if (situation.equals("2")) {%>
        				���Ȯ��
        			<%}%>
      		    	</td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td>&nbsp;<input type="text" name="cust_nm" value="<%=cust_nm%>" size="30" class=text style='IME-MODE: active'></td>
                </tr>
                <tr> 
                    <td class=title>������ó</td>
                    <td>&nbsp;<input type="text" name="cust_tel" value="<%=cust_tel%>" size="15" class=text style='IME-MODE: active'></td>
                </tr>                
                <tr> 
                    <td class=title>�޸�</td>
                    <td>&nbsp;<textarea name="memo" cols="48" rows="6" style="IME-MODE:ACTIVE"><%=memo%></textarea></td>
                </tr>
                <%if(situation.equals("2")){//���Ȯ��%>
                <tr> 
                    <td class=title>�ȳ�����</td>
                    <td>&nbsp;<input type="checkbox" name="cust_sms_yn" value="Y"> �߼�
                        <br>&nbsp;(�� ����� ������ó�� ����� ������ �߼��մϴ�.)
                    </td>
                </tr>                
                <%}%>
            </table>
        </td>
    </tr>
    <!--
    <tr>  
        <td>* �޸� ����� ������ó�� �� �Է��Ͻʽÿ�.
	    </td>	
    </tr>	
    -->
    <tr>  
        <td align="right">
	    	<a href="javascript:regReserveCar('memo');"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
	    </td>	
    </tr>   
    <tr> 
        <td><hr></td>
    </tr>   
     <%if(from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp")){%> 
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����Ʈ ���湮�� �غ� �ȳ�����</span></td>
    </tr>    
    <tr> 
        <td class=line2 ></td>
    </tr>
    <tr> 
        <td class="line">
        	<table border="0" cellspacing="1" cellpadding=0 width=100%>
        		<tr>                     
                    <td align='center'>
                    	<select name='sms_msg'>
	                        <option value="">================����================</option>
							<option value="���θ��� �ſ�ī��(üũī�� �Ұ�), ����������">�Ϲݰ���/���ι湮/���θ� ����</option>
							<option value="���θ��� �ſ�ī��(üũī�� �Ұ�), ����������, �߰�������(�����) ������ �纻, �������� ������">�Ϲݰ���/���ι湮/�߰�������(�����) �ִ°��</option>
							<option value="">------------------------------------------------------------</option>
							<option value="���θ��� �ſ�ī��(üũī�� �Ұ�), ����������, ����� �纻">���λ����/���ι湮/���θ� ����</option>
							<option value="���θ��� �ſ�ī��(üũī�� �Ұ�), ����������, ����� �纻, �߰������� [�ǰ����� �ڰ�Ȯ�μ�], �߰������� �������纻">���λ����/���ι湮/�߰������� �ִ°��</option>
							<option value="���λ���� ���� �ſ�ī��(üũī��� �Ұ�), �����(���λ����) ���������� �纻, ����� �纻, ������ [�ǰ����� �ڰ�Ȯ�μ�], ������ ������">���λ����/�����湮/����� ������ ���� �������</option>
							<option value="">------------------------------------------------------------</option>
							<option value="���� ����ī��(ī�忡 �̿��� ���� �̸��� �����ִ� ����ī��) �Ǵ� ��ǥ�� ����ī�� [üũī�� �Ұ�], ��ǥ�̻� ����������, ����� �纻">����/��ǥ�ڹ湮/���θ� ����</option>
							<option value="���� ����ī��(ī�忡 �̿��� ���� �̸��� �����ִ� ����ī��) �Ǵ� ��ǥ�� ����ī�� [üũī�� �Ұ�], ��ǥ�̻� ����������, ����� �纻, �߰������� [�ǰ����� �ڰ�Ȯ�μ�], �߰������� �������纻">����/��ǥ�ڹ湮/�߰������� �ִ°��</option>
							<option value="���� ����ī��(ī�忡 �̿��� ���� �̸��� �����ִ� ����ī��) �Ǵ� ���� ������ ����ī�� [üũī�� �Ұ�], ����� �纻, �湮�� [�ǰ����� �ڰ�Ȯ�μ�], �湮�� ����������">����/�����湮/�湮�ڸ� ����</option>
							<option value="���� ����ī��(ī�忡 �̿��� ���� �̸��� �����ִ� ����ī��) �Ǵ� ���� ������ ����ī�� [üũī�� �Ұ�], ����� �纻, �湮�� [�ǰ����� �ڰ�Ȯ�μ�], �湮�� ����������, �߰������� [�ǰ����� �ڰ�Ȯ�μ�], �߰������� �������纻">����/�����湮/�߰������� �ִ°��</option>
                       	</select>
					</td>
                </tr>                
            </table>
        </td>
    </tr>
      <%}%>        
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td>
	        <img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>
	        <%if(from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp")){%>
	       	����Ʈ 
	       	<%}%>
	       	 <%if(from_page.equals("/acar/secondhand/secondhand_sc.jsp")){%>
	       	�緻Ʈ 
			<%}%>
			���湮�� ������ �ȳ�����</span>
		</td>
    </tr>    
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table border="0" cellspacing="1" cellpadding=0 width=100%>                                
		        <tr>
                    <td align='center'>
                    	<select name='sms_msg2'>
                        	<option value="">================����================</option>
						    <!--<option value="��������">��������:�Ѹ��� ���� ������(�������Ա� ���� 20m)</option>-->
							<option value="������������">������������:������ ����������</option>
						    <option value="�λ�������1">�λ�������1:�λ����� ����Ʈ���� 3��</option>
							<option value="�λ�������2">�λ�������2:�����̵���ǽ��� ����1�� ������</option>
						    <!-- <option value="����������1">����������1:��ȣ�ڵ��������� 2��</option> -->
							<option value="����������2">����������:(��)����ī��ũ 2��</option>
						    <option value="�뱸������">�뱸������:(��)��������������</option>
						    <option value="����������">����������:��1���ڵ���������</option>
                        </select>
					</td>
                </tr>                
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>  
        <td align="right">        	
	        <%if(!auth_rw.equals("1")){%>
	          <a href="javascript:SendSms()"><img src=/acar/images/center/button_send_smsgo.gif align=absmiddle border=0></a>		        
	        <%}%>
	    </td>	
    </tr>      
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
