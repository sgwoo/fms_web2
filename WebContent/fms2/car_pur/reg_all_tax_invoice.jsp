<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String param 	= request.getParameter("param")==null? "":request.getParameter("param");

	String[] params = param.split(",");
%>
<html>
<head><title>FMS</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script type="text/javascript">
//�����ȣ, ���������, ������� ����(��������ڴ� ������ڿ� ���� ������Ʈ��)
function saveAll(){
	var fm = document.form1;
	if(confirm('���� �����ȣ, �������, ���ݰ�꼭����, ��꼭�ݾ��������� ���� �״�� �ϰ� ���� �˴ϴ�.\n\n��������ڴ� ������ڷ� �ڵ� �����˴ϴ�.\n\n�����Ͻðڽ��ϱ�?')){
		var fn = "save_all";		
		fm.action='reg_all_tax_invoice_a.jsp?fn='+fn;		
		fm.target='i_no';			
		fm.submit();
	}
}

//�����ȣ �ϰ� ����
/* �̻��
function saveRpt_no(){
	var fm = document.form1;
	if(confirm('���� �����ȣ ���� �״�� �ϰ� ���� �˴ϴ�. �����Ͻðڽ��ϱ�?')){
		var fn = "save_rpt_no";		
		fm.action='reg_all_tax_invoice_a.jsp?fn='+fn;		
		fm.target='i_no';			
		fm.submit();
	}
}
*/

//��������� �ϰ� ����
/* �̻��
function saveDlv_est_dt(){
	var fm = document.form1;
	if(confirm('���� ��������� ���� �״�� �ϰ� ���� �˴ϴ�. �����Ͻðڽ��ϱ�?')){
		var fn = "save_dlv_est_dt";		
		fm.action='reg_all_tax_invoice_a.jsp?fn='+fn;		
		fm.target='i_no';			
		fm.submit();
	}
}
*/

//������� �ϰ� ����
/* �̻��
function saveDlv_dt(){
	var fm = document.form1;
	if(confirm('���� ������� ���� �״�� �ϰ� ���� �˴ϴ�. �����Ͻðڽ��ϱ�?')){
		var fn = "save_dlv_dt";		
		fm.action='reg_all_tax_invoice_a.jsp?fn='+fn;		
		fm.target='i_no';			
		fm.submit();
	}
}
*/

//���ݰ�꼭 ��ĵ���
function saveFile(idx){
//	var l_cd = $("#l_cd"+idx).val();
	var rpt_no = $("#rpt_no"+idx).val();
	var contentSeq = $("#contentSeq"+idx).val() + "1"+"10"  //�� 1 : �ű԰�� , �� 10 : ��ĵ���� ����(���ݰ�꼭)
//	window.open("/fms2/car_pur/reg_all_tax_invoice_scan.jsp?l_cd="+l_cd+"&contentSeq="+contentSeq,'savePop','width=500,height=180,top=0,left=100,scrollbars=no');
	window.open("/fms2/car_pur/reg_all_tax_invoice_scan.jsp?rpt_no="+rpt_no+"&contentSeq="+contentSeq,'savePop','width=500,height=180,top=0,left=100,scrollbars=no');
}

//���ݰ�꼭 ��ĵ����
function delFile(idx){
	var seq = $("#seq"+idx).val();
	window.open("https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ="+seq,'delPop','width=700,height=300,top=0,left=100,scrollbars=no');
}

//��ĵ���Ϻ���
/* �̻��
function openPopP(type,seq){	
	var isImage = type.indexOf("image/") != -1 ? true : false;
	var isPDF = type.indexOf("/pdf") != -1 ? true : false;
	var url = 'https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp';
	if( isImage || isPDF ){
		if(type.indexOf("image/") != -1 ) {				
			url = 'https://fms3.amazoncar.co.kr/fms2/attach/imgview_print.jsp';
		}						
		url = url + "?SEQ=" + seq;
		var popName = "view_file";
		var aTagObj = document.getElementById("link_view_a");		
		if( aTagObj == null ){			
			var aTag = document.createElement("a");
			aTag.setAttribute("href", url);
			aTag.setAttribute("target",popName);
			aTag.setAttribute("id","link_view_a");
			target = document.getElementsByTagName("body");
			target[0].appendChild(aTag);
			aTagObj = document.getElementById("link_view_a");		
		}else{		
			aTagObj.setAttribute("href", url);
		}		
		var pop = window.open('', popName, "left=300, top=250, width=1000, height=1000, scrollbars=yes");		
		aTagObj.click();		
	}else{
		alert('���⸦ �Ҽ����� �����Դϴ�.');
	} 	
}
*/

//��ĵ���Ϻ���
function openPopP_tax(save_file,save_folder,m_id,l_cd){	
	var url = '/acar/car_register/register_pur_id_tax.jsp';
	url = url + "?save_file=" + save_file + "&save_folder=" + save_folder + "&rent_mng_id="+m_id+"&rent_l_cd="+l_cd;
	window.open(url, "PopP_tax", "left=300, top=250, width=1000, height=1000, scrollbars=yes");		
}
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' method='post'>
<table width=1100 border=0 cellpadding=0 cellspacing=0>
    <tr>
        <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
        <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>���ݰ�꼭 �� ������� �ϰ����</span></span></td>
        <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
    </tr>
    <tr height="10px;"></tr>
</table>
<div style="font-size: 13px; padding-bottom: 10px; float: left;">
	<div>�� ������� �� �������ڴ� ������ڰ� �Էµ��� �ʾ� ��������ڸ� ������ ���Դϴ�. ����� �״�� ������ڿ� �ݿ��˴ϴ�.</div>
	<div>�� ���ݰ�꼭���� �� �������ڴ� ���ݰ�꼭���ڰ� �Էµ��� �ʾ� ������� Ȥ�� ��������ڸ� ������ ���Դϴ�. ����� �״�� ���ݰ�꼭���ڿ� �ݿ��˴ϴ�.</div>
	<div>�� ��꼭�ݾ��������� �� �������ڴ� ��꼭�ݾ��������ڰ� �Էµ��� �ʾ� �������ڸ� ������ ���Դϴ�. ����� �״�� ��꼭�ݾ��������ڿ� �ݿ��˴ϴ�.</div>
	<div>�� �����ȣ, ���������, �������, ���ݰ�꼭����, ��꼭�ݾ��������� ������ �ڵ� ���ΰ�ħ�� ������, ��ĵ���ϵ��/�����ÿ��� �ʿ信 ���� ���� ���ΰ�ħ�� ���ּ���.</div>
	<div>�� ���ݰ�꼭����, ��꼭�ݾ��������ڸ� ���Է��ϰ� ������ ���� ����� �����ϼ���.</div>
</div>	
<div align="right" style="position: relative; margin-right: 35px;">
	<input type="button" class="button" value="����" onclick="javascript:saveAll()">&nbsp;&nbsp;&nbsp; 
	<input type="button" class="button" value="���ΰ�ħ" onclick="javascript:window.location.reload();">
</div>
<table border="0" cellspacing="0" cellpadding="0" width='1100'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='1100' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			    <tr>
			        <td width='40' class='title' style='height:51'>����</td>
	                <td width="100" class='title'>����ȣ</td>
	                <td width="140" class='title'>�����ȣ</td>
	                <td width="100" class='title'>��������</td>
	                <td width="100" class='title'>���������</td>
	                <td width="100" class='title'>�������</td>
	                <td width="100" class='title'>���ݰ�꼭����</td>
	                <td width="100" class='title'>��꼭�ݾ�<br>��������</td>
	                <td width="310" class='title' colspan="3">���ݰ�꼭 ��ĵ���</td>
			    </tr>
			</table>
		</td>
	</tr>
	<%
	for(int i=0; i<params.length; i++){
		
		Vector vt = a_db.getRegAllTaxInvoiceList(params[i]);		
		int vt_size = vt.size();
		
		for(int j = 0 ; j < vt_size ; j++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(j);
			String m_id = ht.get("RENT_MNG_ID").toString();
			String l_cd = ht.get("RENT_L_CD").toString();
			String contentSeq = "" + m_id + l_cd + "%";
			
			Vector vt2 = a_db.getRegAllTaxInvoiceScan(contentSeq);		
			int vt_size2 = vt2.size();	
	%>
			<tr>
				<td class='line' width='970' id='td_con' style='position:relative;'>
					<table border="0" cellspacing="1" cellpadding="0" width='100%'>
						<tr>
							<td  width='40' align='center' style='height:30'>
								<%=i+1%>
								<input type="hidden" name="m_id" value="<%=ht.get("RENT_MNG_ID")%>" >
								<input type="hidden" name="l_cd" id="l_cd<%=i%>" value="<%=ht.get("RENT_L_CD")%>" >
							</td>
							<td  width='100' align='center'><%=ht.get("RENT_L_CD")%></td>										
							<td  width='140' align='center'>
								<input type="text" name="rpt_no" id="rpt_no<%=i%>" value="<%=ht.get("RPT_NO")%>" size="15" style="text-align: center;">
							</td>
							<td  width='100' align='center'><%=ht.get("TOT_F_AMT")%> ��</td>	
							<td  width='100' align='center'>
								<input type="text" name="dlv_est_dt" value="<%=ht.get("DLV_EST_DT")%>" size="10" style="text-align: center;">
							</td>
							<!-- ������� -->
							<%	if(ht.get("DLV_DT")!=null && !ht.get("DLV_DT").equals("")){%>								
							<td  width='100' align='center'>
								<input type="text" name="dlv_dt" value="<%=ht.get("DLV_DT")%>" size="10" style="text-align: center;">
							</td>	
                            <%	}else{%>					
							<td  width='100' align='center'>
								<input type="text" name="dlv_dt" value="<%=ht.get("DLV_EST_DT")%>" size="10" style="text-align: center; color: red;">
							</td>			
                            <%	}%>
                            <!-- ���ݰ�꼭���� -->
                            <%	if(String.valueOf(ht.get("CAR_TAX_DT")).equals("")){%>
                            <%		if(ht.get("DLV_DT")!=null && !ht.get("DLV_DT").equals("")){%>								
							<td  width='100' align='center'>
								<input type="text" name="car_tax_dt" value="<%=ht.get("DLV_DT")%>" size="10" style="text-align: center; color: red;">
							</td>	
                            <%		}else{%>					
							<td  width='100' align='center'>
								<input type="text" name="car_tax_dt" value="<%=ht.get("DLV_EST_DT")%>" size="10" style="text-align: center; color: red;">
							</td>			
                            <%		}%>                            
							<%	}else{%>
							<td  width='100' align='center'>
								<input type="text" name="car_tax_dt"  value="<%=ht.get("CAR_TAX_DT")%>" size="10" style="text-align: center;">
							</td>								
							<%	}%>
							<!-- ��꼭�ݾ��������� -->
							<%	if(String.valueOf(ht.get("CAR_AMT_DT")).equals("")){%>
							<td  width='100' align='center'>
								<input type="text" name="car_amt_dt" value="<%=AddUtil.getDate(1)%><%=AddUtil.getDate(2)%><%=AddUtil.getDate(3)%>" size="10" style="text-align: center; color: red;">
							</td>
							<%	}else{%>
							<td  width='100' align='center'>
								<input type="text" name="car_amt_dt" value="<%=ht.get("CAR_AMT_DT")%>" size="10" style="text-align: center;">
							</td>							
							<%	}%>
							<!-- ��ĵ���� -->
                            <% if(vt_size2 > 0){
				          			for(int k = 0 ; k < vt_size2 ; k++){
										Hashtable ht2 = (Hashtable)vt2.elementAt(k);
                            %>
							<td  width='255' align='center'>	
								<!-- <a href="javascript:openPopP('<%=ht2.get("FILE_TYPE")%>','<%=ht2.get("SEQ")%>');" title='����' ><%=ht2.get("FILE_NAME")%></a> -->
								<a href="javascript:openPopP_tax('<%=ht2.get("SAVE_FILE")%>','<%=ht2.get("SAVE_FOLDER")%>','<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');" title='����' ><%=ht2.get("FILE_NAME")%></a>
							</td>
							<td  width='55' align='center'>
								<a href="#" onclick="javascript:delFile(<%=i%>)"><img src=/acar/images/center/button_in_delete.gif align=absmiddle border=0></a>
								<input type="hidden" id="seq<%=i%>" value="<%=ht2.get("SEQ")%>">
								<input type="hidden" id="contentSeq<%=i%>" value="<%=contentSeq%>">
							</td>
                            <%		}
								}else{%>
							<td  width='255' align='center' colspan="2">��ĵ���� �̵��</td>
							<td  width='55' align='center'>
								<a href="#" onclick="javascript:saveFile(<%=i%>)"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
								<input type="hidden" id="contentSeq<%=i%>" value="<%=m_id%><%=l_cd%>">
							</td>
                            <%	}%>							
						</tr>
					</table>
				</td>
			</tr>
<%
			}
		}	
%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>