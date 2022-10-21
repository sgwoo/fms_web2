<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.client.*, acar.settle_acc.*, acar.forfeit_mng.*, acar.im_email.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	AddForfeitDatabase afm_db = AddForfeitDatabase.getInstance();
	ImEmailDatabase ie_db = ImEmailDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String client_id	= request.getParameter("client_id")	==null?"":request.getParameter("client_id");//��������ȣ
	String bus_id2		= request.getParameter("bus_id2")	==null?"":request.getParameter("bus_id2");
	
	//������
	ClientBean client = al_db.getNewClient(client_id);
	
	Vector c_sites = al_db.getClientSiteList(client_id, "");
	int c_site_size = c_sites.size();
	
	//���·Ḯ��Ʈ
	Vector fines = afm_db.getClientFineList(client_id, bus_id2);
	int fine_size = fines.size();
	
	Vector ie_vt =  ie_db.getFmsInfoMailFineDocSendList(client.getFirm_nm());
	int ie_size = ie_vt.size();
	
	String est_email = "";
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var popObj = null;
	
	//�˾������� ����
	function ScanOpen(theURL,file_type) { //v2.0
		
		if(file_type == ''){
			theURL = "https://fms3.amazoncar.co.kr/data/fine/"+theURL+".pdf";
		}else{			
			theURL = "https://fms3.amazoncar.co.kr/data/fine/"+theURL+""+file_type;		
		}
		if(file_type == 'jpg'){
			window.open('/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL,'popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			window.open(theURL,'popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}
	}
		
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/doc/"+theURL;
		window.open(theURL,winName,features);
	}

		
	//�������
	function ReqDoc_Print(){
		var fm = document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}			
		if(cnt == 0){
		 	alert("�μ��� ������ �����ϼ���.");
			return;
		}	
		
		if(confirm('û�������� ���� �μ��Ͻðڽ��ϱ�?')){
			fm.target = "_blank";
			fm.action = "fine_reqdoc_select_print.jsp";
			fm.submit();	
		}
	}		


	
	//���� ����
	function view_im_dmail(dmidx){
		var fm = document.form1;	
		fm.dmidx.value = dmidx;
	   	fm.action = '/fms2/im_dmail/im_dmail_c.jsp';		
		fm.target = '_blank';
		fm.submit();
	}				
	
	//���� ����
	function resand_im_dmail(dmidx, email){
		var fm = document.form1;	
		fm.dmidx.value = dmidx;
		fm.email.value = email;
	   	fm.action = '/fms2/im_dmail/re_send_a.jsp';		
		fm.target = '_blank';
		fm.submit();
	}	
	
	
	//��ü����
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}	
			}
		}
		return;
	}		
	
	//���ø��Ϲ߼�
	function select_email(){
		var fm = document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}			
		if(cnt == 0){
		 	alert("���·Ḧ �����ϼ���.");
			return;
		}	
		

	}						
//-->
</script>
</head>
<body>
<form action="" name="form1">
<input type="hidden" name="user_id" value="<%=ck_acar_id%>">
<input type="hidden" name="client_id" value="<%=client_id%>">
<input type="hidden" name="bus_id2" value="<%=bus_id2%>">
<input type="hidden" name="dmidx" value="">
<input type='hidden' name='dm_st'    value='4'>      
<input type='hidden' name='st'    value='4'>      
<input type="hidden" name="email" value="">
<input type="hidden" name="firm_nm" value="<%=client.getFirm_nm()%>">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
		<td colspan=6>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>���·���� > <span class=style5>
						û���� �ʿ伭��</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>  
	<tr>
		<td class=h></td>
	</tr>  
    <tr>
		<td class=line2 colspan="2"></td>
	</tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="10%">��ȣ</td>
                    <td colspan='3'>&nbsp;<%=client.getFirm_nm()%></td>
                </tr>
                <tr> 
                    <td class=title width="10%">�繫�ǹ�ȣ</td>
                    <td width="40%">&nbsp;<%=client.getO_tel()%></td>
                    <td class=title width="10%">�ѽ���ȣ</td>
                    <td width="40%">&nbsp;<%=client.getFax()%>
					</td>
                </tr>
                <tr> 
                    <td class=title width="10%">��꼭�����</td>
                    <td colspan='3'>&nbsp;����:<%=client.getCon_agnt_nm()%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�繫��:<%=client.getCon_agnt_o_tel()%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�̵���ȭ:<%=client.getCon_agnt_m_tel()%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FAX:<%=client.getCon_agnt_fax()%></td>
                </tr>				
            </table>
        </td>
    </tr>	
	<tr>
		<td class=h></td>
	</tr>	
	<%if(c_site_size > 0){%>
    <tr>
		<td class=line2 colspan="2"></td>
	</tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="3%" rowspan='2'>����</td>
                    <td class=title width="15%" rowspan='2'>��ȣ</td>
                    <td class=title width="15%" rowspan='2'>�繫�ǹ�ȣ</td>
                    <td class=title width="15%" rowspan='2'>�ѽ���ȣ</td>										
                    <td class=title colspan='5'>��꼭�����</td>																				
                </tr>
				<tr>
				    <td class=title width="7%">�̸�</td>
				    <td class=title width="7">����</td>
				    <td class=title width="10%">�ڵ���</td>					
				    <td class=title width="10%">�ѽ���ȣ</td>
				    <td class=title width="18%">�̸���</td>					
				</tr>
			    <%for(int i = 0 ; i < c_site_size ; i++){
					ClientSiteBean site = (ClientSiteBean)c_sites.elementAt(i);
					if(!site.getAgnt_email().equals("")){%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=site.getR_site()%></td>
					<td align="center"><%=site.getTel()%></td>
					<td align="center"><%=site.getFax()%></td>
					<td align="center"><%=site.getAgnt_nm()%></td>
					<td align="center"><%=site.getAgnt_title()%></td>
					<td align="center"><%=site.getAgnt_m_tel()%></td>
					<td align="center"><%=site.getAgnt_fax()%></td>
					<td align="center"><%=site.getAgnt_email()%></td>
                </tr>
				<%}}%>
            </table>
        </td>
    </tr>	
	<tr>
		<td class=h></td>
	</tr>		
	<%}%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�̼� ���·� ����Ʈ</span>
	    &nbsp;&nbsp;&nbsp;&nbsp;
	    <!--<a href="javascript:select_email();" title='���� ���Ϲ߼��ϱ�'><img src=/acar/images/center/button_send_smail.gif align=absmiddle border=0></a>&nbsp;-->
	    </td>
	</tr>  			
    <tr>
        <td class=line2></td>
    </tr>    
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=3% class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>				
                    <td width=3% class='title'>����</td>				
                    <td width=8% class='title'>������ȣ</td>
                    <td width=9% class='title'>����</td>	
                    <td width=12% class='title'>û�����</td>
                    <td width=18% class='title'>�������</td>
					<td width=8% class='title'>���ݳ���</td>
                    <td width=8% class='title'>���ݱݾ�</td>
                    <td width=8% class='title'>��������</td>					
					<td width=8% class='title'>��������</td>
					<td width=8% class='title'>�������</td>					
                    <td width=7% class='title'>��ĵ</td>					
                </tr>
<%
	if(fine_size > 0){
		for (int i = 0 ; i < fine_size ; i++){
			Hashtable fine = (Hashtable)fines.elementAt(i);
			
	String content_code = "FINE";
	String content_seq  = String.valueOf(fine.get("RENT_MNG_ID"))+String.valueOf(fine.get("RENT_L_CD"))+String.valueOf(fine.get("CAR_MNG_ID"))+String.valueOf(fine.get("SEQ_NO"));

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
	
	String file_type1 = "";
	String seq1 = "";
	String file_type2 = "";
	String seq2 = "";
	
	String file_name1 = "";
	String file_name2 = "";
	
	for(int j=0; j< attach_vt.size(); j++){
    		Hashtable ht = (Hashtable)attach_vt.elementAt(j);   
		
		if((content_seq+1).equals(ht.get("CONTENT_SEQ"))){
			file_name1 = String.valueOf(ht.get("FILE_NAME"));
			file_type1 = String.valueOf(ht.get("FILE_TYPE"));
			seq1 = String.valueOf(ht.get("SEQ"));
			
		}else if((content_seq+2).equals(ht.get("CONTENT_SEQ"))){
			file_name2 = String.valueOf(ht.get("FILE_NAME"));
			file_type2 = String.valueOf(ht.get("FILE_TYPE"));
			seq2 = String.valueOf(ht.get("SEQ"));

		}
	}				
			
			
%>				  
                <tr> 
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=fine.get("RENT_MNG_ID")%><%=fine.get("RENT_L_CD")%><%=fine.get("CAR_MNG_ID")%><%=fine.get("SEQ_NO")%>"></td>				
                    <td align="center"><%=i+1%></td>				
                    <td align="center"><%=fine.get("CAR_NO")%></td>
					<td align="center"><%=fine.get("CAR_NM")%></td>
					<td align="center"><%=fine.get("GOV_NM")%></td>					
                    <td align="center"><%=fine.get("VIO_PLA")%>
					<%if(String.valueOf(fine.get("USE_YN")).equals("N")){%>
					<br>-> ���� <%=fine.get("CLS_ST")%> <%=fine.get("CLS_DT")%>
					<%}%>
					<%if(!String.valueOf(fine.get("NOTE")).equals("")){%>
					<br>(<%=fine.get("NOTE")%>)
					<%}%>
					</td>
                    <td align="center"><%=fine.get("VIO_CONT")%></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(fine.get("PAID_AMT")))%>��</td>
                    <td align="center"><%=AddUtil.ChangeDate3(String.valueOf(fine.get("VIO_DT2")))%></td>					
                    <td align="center"><%=fine.get("PROXY_DT")%></td>					
                    <td align="center"><%=fine.get("REG_DT")%></td>										
		    <td align="center">
					<%if(!file_name1.equals("")){%>
					<a href="javascript:openPopP('<%=file_type1%>','<%=seq1%>');" title='����' ><%=file_name1%></a>
					<%}%>					
					<br>					
					<%if(!file_name2.equals("")){%>
					&nbsp;
					<a href="javascript:openPopP('<%=file_type2%>','<%=seq2%>');" title='����' ><%=file_name2%></a>
					<%}%>
		    </td>				
                </tr>
<%		}
	}else{%>		  
                <tr> 
                    <td align="center" colspan="8">�ڷᰡ �����ϴ�.</td>
                </tr>
<%	} %>		
            </table>
        </td>
    </tr>	
	<tr>
		<td align="right"><a href="javascript:MM_openBrWindow('������������纻2.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">[������������纻2.pdf]</a></td>
	</tr>  	
	<tr>
		<td class=h></td>
	</tr>  	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���·� û���� ���� �߼� ����Ʈ</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
          			<td width='3%' class='title'>����</td>		    
          			<td width='8%' class='title'>�߼ۿ���</td>		  
		  			<td width='8%' class='title'>���ſ���</td>
          			<td width='20%' class='title'>�޴»��</td>		  
		  			<td width="15%" class='title'>�߼��Ͻ�</td>		
		  			<td width="40%" class='title'>����</td>				
		  			<td width="6%" class='title'>�����</td>									
                </tr>	
<%
	if(ie_size > 0){
		for (int i = 0 ; i < ie_size ; i++){
			Hashtable ht = (Hashtable)ie_vt.elementAt(i);
			est_email = String.valueOf(ht.get("EMAIL"));
%>				  
                <tr> 
                    <td align="center"><%=i+1%></td>				
                    <td align="center"><span title='<%=ht.get("NOTE")%>'><%=ht.get("ERRCODE_NM")%></span></td>
					<td align="center"><%=ht.get("OCNT_NM")%></td>
                    <td align="center"><a href="javascript:view_im_dmail('<%=ht.get("DMIDX")%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=ht.get("EMAIL")%></a></td>
					<td align="center"><%=AddUtil.ChangeDate3(String.valueOf(ht.get("STIME")))%></td>					
                    <td>&nbsp;<span title='<%=ht.get("SUBJECT")%>'><%=ht.get("SUBJECT2")%></span>&nbsp;<%=ht.get("R_ST")%></td>
					<td align="center"><a href="javascript:resand_im_dmail('<%=ht.get("DMIDX")%>','<%=ht.get("EMAIL")%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">[�����]</a></td>
                </tr>
<%		}
	}else{%>		  
                <tr> 
                    <td align="center" colspan="7">�ڷᰡ �����ϴ�.</td>
                </tr>
<%	} %>		
            </table>
        </td>
    </tr>					
</table>
<input type="hidden" name="est_email" value="<%=est_email%>">
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
