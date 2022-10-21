<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.common.*" %>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<jsp:useBean id="cd_bean" class="acar.common.CodeBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String emp_id = request.getParameter("emp_id")==null?"":request.getParameter("emp_id");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	//�����������
	coe_bean = cod.getCarOffEmpBean(emp_id);
	
	//����������
	co_bean = cod.getCarOffBean(coe_bean.getCar_off_id()); 
	
	//��Ÿ���¸���Ʈ
	Vector vt = c_db.getBankAccList("emp_id", emp_id, "");
	int vt_size = vt.size();
	
	//���ฮ��Ʈ
	CodeBean cd_r [] = c_db.getCodeAllCms("0003");
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript" src='/include/common.js'></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function CarOffReg()
{
	var fm = document.form1;
	if(fm.seq.value != '')		{ alert('�̹� ��ϵ� �����Դϴ�.'); 		return; }
	if(fm.acc_nm.value == '')	{ alert('������ �Է��Ͻʽÿ�.'); 			return; }		
	if(fm.acc_ssn.value == '')	{ alert('�ֹε�Ϲ�ȣ�� �Է��Ͻʽÿ�.'); 	return; }			
	if(fm.etc.value == '')		{ alert('���踦 �Է��Ͻʽÿ�.'); 			return; }				
	if(fm.bank_cd.value == '')		{ alert('������ �Է��Ͻʽÿ�.'); 			return; }
	if(fm.acc_no.value == '')	{ alert('���¹�ȣ�� �Է��Ͻʽÿ�.'); 		return; }
	if(fm.t_zip.value == '')	{ alert('�ּҸ� �Է��Ͻʽÿ�.'); 			return; }
	
	if(fm.acc_ssn.value.length > 5 && fm.acc_ssn.value.length < 13){
		alert('�ֹε�Ϲ�ȣ�� 13�ڸ� �̸��Դϴ�. Ȯ���Ͻʽÿ�.');
		return;
	}
	
	if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}
	fm.cmd.value = "i";
	fm.action = "car_offemp_bank_a.jsp"
	fm.target = "i_no"
	fm.submit();
}

function CarOffUp()
{
	var fm = document.form1;
	if(fm.seq.value == '')		{ alert('�̵�ϵ� ���̶� �����Ҽ� �����ϴ�.'); return; }
	if(fm.acc_nm.value == '')	{ alert('������ �Է��Ͻʽÿ�.'); 			return; }		
	if(fm.acc_ssn.value == '')	{ alert('�ֹε�Ϲ�ȣ�� �Է��Ͻʽÿ�.'); 	return; }			
	if(fm.etc.value == '')		{ alert('���踦 �Է��Ͻʽÿ�.'); 			return; }				
	if(fm.bank_cd.value == '')		{ alert('������ �Է��Ͻʽÿ�.'); 			return; }
	if(fm.acc_no.value == '')	{ alert('���¹�ȣ�� �Է��Ͻʽÿ�.'); 		return; }
	if(fm.t_zip.value == '')	{ alert('�ּҸ� �Է��Ͻʽÿ�.'); 			return; }	
	
	if(fm.acc_ssn.value.length > 5 && fm.acc_ssn.value.length < 13){
		alert('�ֹε�Ϲ�ȣ�� 13�ڸ� �̸��Դϴ�. Ȯ���Ͻʽÿ�.');
		return;
	}
	
	if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
	fm.cmd.value = "u";
	fm.action = "car_offemp_bank_a.jsp"
	fm.target = "i_no"
	fm.submit();
}

function CarOffDel(){
	var fm = document.form1;
	if(fm.seq.value == '')		{ alert('������ ���°� �����ϴ�.'); return; }
	if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
	if(!confirm('���������� �����ϴ�. �����Ͻðڽ��ϱ�?')){	return;	}	
	fm.cmd.value = "d";
	fm.action = "car_offemp_bank_a.jsp"
	fm.target = "i_no"
	fm.submit();
}

function setCarOffBank(seq, acc_nm, acc_ssn, etc, bank, acc_no, acc_zip, acc_addr, bank_cd){
	var fm = document.form1;
	fm.seq.value 			= seq;
	fm.acc_nm.value 	= acc_nm;	
	fm.acc_ssn.value 	= acc_ssn;
	fm.etc.value 			= etc;	
	fm.bank.value 		= bank;
	fm.bank_cd.value 	= bank_cd;
	fm.acc_no.value 	= acc_no;
	fm.t_zip.value 		= acc_zip;
	fm.t_addr.value 	= acc_addr;
}

function SelfReload(){
	var fm = document.form1;
	fm.action = "car_offemp_bank.jsp"
	fm.target = "OfficeBank"
	fm.submit();
}

	//�����ȣ �˻�
	function search_zip(str){
		window.open("/fms2/lc_rent/zip_s.jsp?idx="+str, "ZIP", "left=100, top=100, height=500, width=400, scrollbars=yes");
	}
	
	//��ĵ���
	function scan_reg(file_st, seq){
		window.open("car_offemp_bank_reg_scan.jsp?emp_id=<%=emp_id%>&from_page=/acar/car_office/car_offemp_bank.jsp&file_st="+file_st+"&acc_seq="+seq, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//�˾������� ����
	function MM_openBrWindow(theURL,fileExtension,winName,features) { //v2.0
		if(fileExtension == ''){
			theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
			window.open(theURL,winName,features);

		}else{
			theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+""+fileExtension;
			window.open(theURL,winName,features);
		}		
	}	
//-->
</script>
</head>
<body leftmargin="15">
<form action="car_offemp_bank_a.jsp" name="form1" method="POST" >
  <input type="hidden" name="emp_id" value="<%= emp_id %>">
  <input type="hidden" name="seq" value="">
  <input type="hidden" name="cmd" value="">    
<table border=0 cellspacing=0 cellpadding=0 width="900">
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ����������� > <span class=style5>�����������</span></span> : �Ǽ����ΰ���</td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr>
    	<td class=line>
            <table border="0" cellspacing="1" cellpadding="3" width="100%">
            	<tr>
			    	<td width=15% class=title>�ٹ�ó</td>
			    	<td width=35%><%= co_bean.getCar_off_nm() %></td>
			    	<td width=15% class=title>����</td>
			        <td width=35%><%= coe_bean.getEmp_nm() %></td>
            	</tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>		
    <tr>
        <td class=h></td>
    </tr>	
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Ǽ�����</span></td>
    </tr>				
    <tr>
        <td class=line2></td>
    </tr>	
    <tr>
    	<td class=line>
            <table border="0" cellspacing="1" cellpadding="3" width="100%">
            	<tr>
			    	<td width=40 class=title>����</td>								
			    	<td width=80 class=title>����</td>					
			    	<td width=120 class=title>�������</td>										
			    	<td width=80 class=title>����</td>										
			    	<td width=100 class=title>����</td>				
			    	<td width=160 class=title>���¹�ȣ</td>
			    	<td width=200 class=title>�ּ�</td>					
			    	<td width=60 class=title>�ź���</td>										
			    	<td width=60 class=title>����</td>															
            	</tr>
				<%	for (int i = 0 ; i < vt_size ; i++){
    					Hashtable ht = (Hashtable)vt.elementAt(i);
    					
					//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
					String content_code = "BANK_ACC";
					String content_seq  = "emp_id"+emp_id+""+String.valueOf(ht.get("SEQ"));

					Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
					int attach_vt_size = attach_vt.size();	
    					
		                       	String emp_file1_yn = "";
                	            	String emp_file2_yn = "";
    					
    				%>
            	<tr>
			    	<td align=center><%=i+1%></td>				
			    	<td align=center><%=ht.get("ACC_NM")%></td>
			    	<td align=center><%if(String.valueOf(ht.get("ACC_SSN")).length() > 6){%><%=String.valueOf(ht.get("ACC_SSN")).substring(0,6)%>-*******<%}%></td>
			    	<td align=center><%=ht.get("ETC")%></td>															
			    	<td align=center><%=ht.get("BANK_NM")%></td>
			        <td align=center><a href="javascript:setCarOffBank('<%=ht.get("SEQ")%>','<%=ht.get("ACC_NM")%>','<%=ht.get("ACC_SSN")%>','<%=ht.get("ETC")%>','<%=ht.get("BANK_NM")%>','<%=ht.get("ACC_NO")%>','<%=ht.get("ACC_ZIP")%>','<%=ht.get("ACC_ADDR")%>','<%=ht.get("BANK_CD")%>')" onMouseOver="window.status=''; return true"><%=ht.get("ACC_NO")%></a></td>
					<td align=center><%=ht.get("ACC_ADDR")%></td>
					<td align=center>					
                                                <%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);
    								if(String.valueOf(attach_ht.get("CONTENT_SEQ")).equals(content_seq+"1")){
    									emp_file1_yn = "Y";
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='����' ><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
    							<br>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
    						<%		}%>		
    						<%	}%>		
    						<%}%>
    						<%if(emp_file1_yn.equals("")){%>
                                                <a href="javascript:scan_reg('1', '<%=ht.get("SEQ")%>')"><img src=../images/center/button_in_reg.gif align=absmiddle border=0></a>
                                                <%}%>
					  
					</td>					
					<td align=center>					  
                                                <%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);
    								if(String.valueOf(attach_ht.get("CONTENT_SEQ")).equals(content_seq+"2")){
    									emp_file2_yn = "Y";
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='����' ><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
    							<br>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
    						<%		}%>		
    						<%	}%>		
    						<%}%>
    						<%if(emp_file2_yn.equals("")){%>
                                                <a href="javascript:scan_reg('2', '<%=ht.get("SEQ")%>')"><img src=../images/center/button_in_reg.gif align=absmiddle border=0></a>
                                                <%}%>
                                                					  
					</td>										
            	</tr>
				<%	}%>
				<%	if(vt_size==0){%>
				<tr>
					<td colspan='9' align=center>����Ÿ�� �����ϴ�.</td>
				</tr>
				<%	}%>
            </table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>		
    <tr>
        <td><hr></td>
    </tr>		
    <tr>
        <td class=line2></td>
    </tr>	
    <tr>
    	<td class=line>
            <table border="0" cellspacing="1" cellpadding="3" width="100%">
            	<tr>
			    	<td width=120 class=title>����</td>					
			    	<td width=120 class=title>�ֹι�ȣ</td>										
			    	<td width=80 class=title>����</td>										
			    	<td width=140 class=title>����</td>				
			    	<td width=140 class=title>���¹�ȣ</td>
			    	<td width=300 class=title>�ּ�</td>					
            	</tr>
            	<tr>
			        <td align=center><input type="text" name="acc_nm" value="" size="16" class=text style='IME-MODE: active'></td>
			        <td align=center><input type="text" name="acc_ssn" value="" size="16" class=text></td>					
			        <td align=center><input type="text" name="etc" value="" size="10" class=text></td>										
			    	<td align=center>
			    		<input type='hidden' name="bank" 			value="">
						<select name="bank_cd">
							<option value="">����</option>
							<%	for(int i=0; i<cd_r.length; i++){
        							cd_bean = cd_r[i];
        							//�ű��ΰ�� �̻������ ����
											if(cd_bean.getUse_yn().equals("N"))	 continue;
							%>
            				<option value="<%= cd_bean.getCode() %>"><%= cd_bean.getNm() %></option>
							<%	}%>
						</select>
					</td>

			        <td align=center><input type="text" name="acc_no" value="" size="20" class=text></td>
					<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
					<script>
						function openDaumPostcode() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip').value = data.zonecode;
									document.getElementById('t_addr').value = data.address;
									
								}
							}).open();
						}
					</script>							
					<td>&nbsp;
					<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7'>
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr" size="32">
					</td>
            	</tr>
            </table>
        </td>
    </tr>	
    <tr>
        <td>* F5Ű�� Ŭ���ϸ� �ʱ�ȭ �˴ϴ�. </td>
    </tr>	
    <tr>
        <td align=right>
			<a href="javascript:CarOffReg()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>&nbsp;
			<a href="javascript:CarOffUp()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>&nbsp;
			
			<a href="javascript:CarOffDel()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_delete.gif" align="absmiddle" border="0"></a>&nbsp;
			
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>
    </tr>			
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
