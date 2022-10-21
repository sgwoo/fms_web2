<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*,acar.car_register.*,acar.common.*, acar.client.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<jsp:useBean id="af_db" 	class="acar.fee.AddFeeDatabase"			   scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, "01", "01", "09");
	
	
	//��ĵ���� ������
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String rent_st 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String file_st  = request.getParameter("file_st")==null?"":request.getParameter("file_st");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	String user_id = login.getCookieValue(request, "acar_id");
	
	
	//���⺻����
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//������ȣ �̷�
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarHisBean ch_r [] = crd.getCarHisAll(base.getCar_mng_id());
	
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 	= af_db.getMaxRentSt(m_id, l_cd);
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
		
	
	String content_code = "LC_SCAN";
	String content_seq  = m_id+""+l_cd;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
	//�ڵ帮��Ʈ : ��ེĵ���ϱ���
	CodeBean[] scan_codes = c_db.getCodeAll3("0028");
	int scan_code_size = scan_codes.length;
	
	ContFeeBean f_fee = a_db.getContFeeNew(m_id, l_cd, "1");
	
	//��������
	String today = AddUtil.getDate(4);
	String modify_deadline = "";
	String delete_yn = "N";
	
	//�̰����̰ų� ����30���̳��̸� �������� ����
	if(!f_fee.getRent_start_dt().equals("")){
		modify_deadline = rs_db.addDay(f_fee.getRent_start_dt(), 30);
		if(AddUtil.parseInt(modify_deadline) > AddUtil.parseInt(today)){
			delete_yn = "Y";
		}
	}else{
		delete_yn = "Y";
	}
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//����ϱ�
	
	function save(){
		fm = document.form1;

		if(fm.file_st.value == ""){	alert("������ ������ �ּ���!");		fm.file_st.focus();	return;		}		
		if(fm.file.value == ""){	alert("������ ������ �ּ���!");		fm.file.focus();	return;		}		
		
		<% //if ( !base.getCar_st().equals("4"))  { %>	 
			// file_st :38  tif check
			if (fm.file_st.value == "38" ) {  //cms ���Ǽ�
				   var  str_dotlocation,str_ext,str_low, str_value;
				    str_value  = fm.file.value;
				  
				    str_low   = str_value.toLowerCase(str_value);
				    str_dotlocation = str_low.lastIndexOf(".");
				    str_ext   = str_low.substring(str_dotlocation+1);
				
				    if  ( str_ext == 'tif'  ||  str_ext == 'jpg'  || str_ext == 'TIF'  ||  str_ext == 'JPG' ) {
				    } else {
					      alert("tif  �Ǵ� jpg�� ��ϵ˴ϴ�." );
					      return false; 
				    }   			
			}else if (fm.file_st.value == "2" || fm.file_st.value == "4" || fm.file_st.value == "17" || fm.file_st.value == "18" || fm.file_st.value == "10" || fm.file_st.value == "27" || fm.file_st.value == "37" || fm.file_st.value == "15" || fm.file_st.value == "51" || fm.file_st.value == "52") {  //jpg��༭, ����ڵ����, ���ݰ�꼭, �����̿���Ȯ�ο�û��, ����(�ſ�)���� ����.�̿�.����.��ȸ���Ǽ�jpg, �Ÿ��ֹ���
				var  str_dotlocation,str_ext,str_low, str_value;
				    str_value  = fm.file.value;
				  
				    str_low   = str_value.toLowerCase(str_value);
				    str_dotlocation = str_low.lastIndexOf(".");
				    str_ext   = str_low.substring(str_dotlocation+1);
			if  ( str_ext == 'gif'  ||  str_ext == 'jpg'   || str_ext == 'GIF'  ||  str_ext == 'JPG' ) {
				
			} else {
				alert("jpg  �Ǵ� gif�� ��ϵ˴ϴ�." );
				return;
			}
		}
		
		<%// } %>
		
		
		if(!confirm("�ش� ������ ����Ͻðڽ��ϱ�?"))	return;
		
		fm.<%=Webconst.Common.contentSeqName%>.value = fm.<%=Webconst.Common.contentSeqName%>.value+''+fm.file_rent_st.value+''+fm.file_st.value;
		
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.LC_SCAN%>";				
		fm.submit();

	}
	
	//��ĵ���� ����
	function view_scan_client(){
		window.open("view_scan_client.jsp?client_id=<%=base.getClient_id()%>", "VIEW_CLIENT_SCAN", "left=200, top=100, width=820, height=800, scrollbars=yes");		
	}

	//���ϼ����ϱ�
	function go_mail(content_st, rent_st){			
		var SUBWIN="mail_input.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&rent_st="+rent_st+"&content_st="+content_st;	
		window.open(SUBWIN, "openMail", "left=100, top=100, width=440, height=500, scrollbars=no, status=yes");
	}	
	
	//�ŷ�ġ ������ĵ ����ȭ
	function scan_sys(){
		var fm = document.form2;
		fm.idx.value = 'scan_sys';
		if(confirm('��ĵ���� ����ȭ�Ͻðڽ��ϱ�?')){	
			fm.action='lc_b_u_a.jsp';
			fm.target='i_no';
			fm.submit();
		}
	}

//-->
</script>
</head>
<body>
<div style="margin:auto; text-align:center;">
<div style="vertical-align:middle; display:inline-block">
<form name='form1' action='' method='post' enctype="multipart/form-data">
<input type='hidden' name="user_id" value="<%=user_id%>">
<input type='hidden' name="m_id" value="<%=m_id%>">
<input type='hidden' name="l_cd" value="<%=l_cd%>">
<input type='hidden' name="fee_size" value="<%=fee_size%>">    
<input type='hidden' name="seq" value="">

<table border="0" cellspacing="0" cellpadding="0" width=670>
    <tr>
    	<td colspan="2">
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>��ĵ����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td colspan="2" class=h></td>
    </tr>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>
	      <%	Hashtable est = a_db.getRentEst(m_id, l_cd);%>
    <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>����ȣ</td>
                    <td width='20%'>&nbsp;<%=l_cd%></td>
                    <td class='title' width='15%'>��ȣ</td>
                    <td width='50%'>&nbsp;<%=est.get("FIRM_NM")%>&nbsp;<%=est.get("CLIENT_NM")%></td>
                </tr>
                <tr> 
                    <td class='title'>������ȣ</td>
                    <td>&nbsp;<%=est.get("CAR_NO")%></td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=est.get("CAR_NM")%> <%=est.get("CAR_NAME")%></td>
                </tr>
				<%for(int i=1; i<=fee_size; i++){
						ContFeeBean fees = a_db.getContFeeNew(m_id, l_cd, Integer.toString(i));
				%>
                <tr>
                    <td class='title'>�뿩����</td>
                    <td>&nbsp;<%=fees.getCon_mon()%>����<%if(i>1){%>(����)<%}%></td>
					<td class='title'>�뿩�Ⱓ</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>~<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>				
                </tr>						
				<%}%>
                <tr> 
					<td class='title'>��ȭ��ȣ</td>
                    <td colspan=''>&nbsp;<%=est.get("O_TEL")%></td>
                    <td class='title'>�����ּ�</td>
                    <td colspan=''>&nbsp;<%= base.getP_zip()%>&nbsp;<%= base.getP_addr()%>&nbsp;<%=base.getTax_agnt()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2" class=h></td>
    </tr>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class='line'>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class="title" width='6%'>����</td>
                    <td class="title" width='7%'>���</td>
                    <td class="title" width='30%'>����</td>                    
                    <td class="title" width='30%'>���Ϻ���</td>
                    <td class="title" width='20%'>�����</td>
                    <td class="title" width='7%'>����</td>
                </tr>
                <%//�����Һ� ���Ϸ� ���� �ѽ��� ����
                	if(fee_size==1 && base.getDlv_dt().equals("")){%>
                <tr>
                  <td align="center"></td>
                  <td align="center"></td>
                  <td align="center">�ڵ����뿩�̿��༭</td>
                  <td align="center">
		      <a href='/fms2/lc_rent/newcar_doc_dc.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&rent_st=1&paper_size=A4' target="_blank"><img src=/acar/images/center/button_in_a4.gif align="absmiddle" border="0"></a>
		      &nbsp;&nbsp;&nbsp;
		      <a href='/fms2/lc_rent/newcar_doc_dc.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&rent_st=1&paper_size=A3' target="_blank"><img src=/acar/images/center/button_in_a3.gif align="absmiddle" border="0"></a>
		  </td>
                  <td align="center">��������</td>		  
                  <td align="center"></td>		  
                </tr>	                     
                <%}%>
                <!--
        	<%if(base.getCar_st().equals("4")){%>        	
                <tr>
                  <td align="center"></td>
                  <td align="center"></td>		  
                  <td align="center">�ڵ����뿩�̿��༭</td>                  
                  <td align="center">
		      <a href='/fms2/lc_rent/rmcar_doc.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&rent_st=1' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		  </td>
                  <td align="center">(����Ʈ) ��������</td>
                  <td align="center"></td>
                </tr>	        	
        	<%}else{%>        	
        	<%	for(int f=1; f<=fee_size; f++){
        			ContFeeBean fees = a_db.getContFeeNew(m_id, l_cd, Integer.toString(f));
        	%>        	
        	<%		if(f==1 && f==fee_size){//��,����%>        	
        	<%			if(!base.getRent_st().equals("1") && AddUtil.parseInt(fees.getRent_dt()) > 20140101 ){ %>
                <tr>
                  <td align="center"></td>
                  <td align="center"></td>
                  <td align="center">�ڵ����뿩�̿��༭</td>
                  <td align="center">
		      <a href='/fms2/lc_rent/newcar_doc_dc.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&rent_st=<%=f%>&paper_size=A4' target="_blank"><img src=/acar/images/center/button_in_a4.gif align="absmiddle" border="0"></a>
		      &nbsp;&nbsp;&nbsp;
		      <a href='/fms2/lc_rent/newcar_doc_dc.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&rent_st=<%=f%>&paper_size=A3' target="_blank"><img src=/acar/images/center/button_in_a3.gif align="absmiddle" border="0"></a>
		  </td>
                  <td align="center">(����,����) ��������</td>		  
                  <td align="center"></td>		  
                </tr>	        	
        	<%			}%>        	
        	<%		}else{//����������%>        	
        	<%			if(AddUtil.parseInt(fees.getRent_dt()) > 20140101 && f==fee_size ){ %>
                <tr>
                  <td align="center"></td>
                  <td align="center"></td>
                  <td align="center">�ڵ����뿩�̿��༭</td>
                  <td align="center">
		      <a href='/fms2/lc_rent/newcar_doc.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&rent_st=<%=f%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		  </td>
                  <td align="center">(����) ��������</td>		  
                  <td align="center"></td>		  
                </tr>	                	
        	<%			}%>        	
        	<%		}%>        	        	        	
        	<%	}%>
        	<%}%>
        	-->
        	
        	<%if(fee_size>1){ %>
                <tr>
                  <td align="center"></td>
                  <td align="center"></td>
                  <td align="center">�ڵ����뿩�̿��༭(����)</td>
                  <td align="center">
		      �������� <a href='/fms2/lc_rent/newcar_doc_dc.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&rent_st=<%=fee_size%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		  </td>
                  <td align="center"><a href=javascript:go_mail('newcar_doc','<%=fee_size%>');><img src=/acar/images/center/button_email_renew.gif border=0></a></td>		  
                  <td align="center"></td>		  
                </tr>	         	
        	<%} %>
        	                
                <% 	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j); 
 					
 					if(!String.valueOf(ht.get("CONTENT_SEQ")).equals("") && String.valueOf(ht.get("CONTENT_SEQ")).length() > 20){
 						rent_st = String.valueOf(ht.get("CONTENT_SEQ")).substring(19,20);
 						file_st = String.valueOf(ht.get("CONTENT_SEQ")).substring(20); 						
 					}
 					
 					String file_type1 = String.valueOf(ht.get("FILE_TYPE"));
 					
 					if(!rent_st.equals("1")){
 						ContFeeBean fees = a_db.getContFeeNew(m_id, l_cd, rent_st);
 						//�̰����̰ų� ����30���̳��̸� �������� ����
						modify_deadline = rs_db.addDay(fees.getRent_start_dt(), 30);
						if(AddUtil.parseInt(modify_deadline) > AddUtil.parseInt(today)){
							delete_yn = "Y";
						}
 					}
 		%>                
                <tr>
                    <td align="center"><%= j+1 %></td>
                    <td align="center">
                        <%if(rent_st.equals("1") || rent_st.equals("")){%>�ű�
			<%}else{%><%=AddUtil.parseInt(rent_st)-1%>������<%}%>
    		    </td>					
                    <td align="center"><%=c_db.getNameByIdCode("0028", "", file_st)%>
                    	<%if(file_st.equals("55")){ //Ʃ�׽��ν�û��%>
                    	<%	if(file_type1.equals("image/tiff")||file_type1.equals("image/gif")||file_type1.equals("image/jpeg")||file_type1.equals("image/pjpeg")){%>
                    		&nbsp;&nbsp;<a href="/acar/car_register/doc_print_stamp.jsp?file_st=55&file_info=<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>" target='_blank'><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="�μ�ȭ��"></a>
                    	<%	} %>
                    	<%} %>
                    </td>
                    <td align="center">
                        <%if(file_type1.equals("image/tiff")||file_type1.equals("image/gif")||file_type1.equals("image/jpeg")||file_type1.equals("image/pjpeg")||file_type1.equals("application/pdf")){%>
                    		<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a>
                    	<%}else{%>
							<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><%=ht.get("FILE_NAME")%></a>
						<%}%>
                    </td>
                    <td align="center"><%=ht.get("REG_DATE")%>&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("REG_USERSEQ")),"USER")%></td>
                    <td align="center">
                        <%if(file_st.equals("1")||file_st.equals("2")||file_st.equals("4")||file_st.equals("9")||file_st.equals("17")||file_st.equals("18")){ //�ֿ佺ĵ�� �����ϰ� ��ĵ�ڰ� �����Ҽ� �ִ�.%>
	                    	<%if((base.getBus_id().equals(user_id) && delete_yn.equals("Y")) || (String.valueOf(ht.get("REG_USERSEQ")).equals(user_id) && delete_yn.equals("Y")) || nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("������",ck_acar_id)){%>
    	    	            	<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
        	            	<%}%>
                        <%}else{ %>
    	    	            	<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
        	            <%}%>	
                    </td>
                </tr>
                <% 		}
    		  	}else{ %>
                <tr>
                    <td colspan="6" class=""><div align="center">�ش� ��ĵ������ �����ϴ�.</div></td>
                </tr>
                <% 	} %>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2" class=h></td>
    </tr>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>
    <tr>
        <td colspan="2" align="right" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title' width='15%'>���</td>
                    <td>
        			  &nbsp;<select name="file_rent_st">					  
                        <option value="1" <%if(fee_size==1){%>selected<%}%>>�ű�</option>
						<%for(int i = 1 ; i < fee_size ; i++){%>
                        <option value="<%=i+1%>" <%if(fee_size==(i+1) && ( file_st.equals("1") || file_st.equals("17") || file_st.equals("18") )){%>selected<%}%>><%=i%>������</option>						
						<%}%>
                      </select> 			
                    </td>
                </tr>			
                <tr>
                    <td class='title' width='15%'>����</td>
                    <td width='85%'>&nbsp;
		      <%if(file_st.equals("") && ck_acar_id.equals("000031")) file_st="10";//���ǻ������ ���·�÷�μ���->�뿩�����İ�༭(��)jpg ����Ʈ%>
        	      <select name="file_st">
                            <%for(int j = 0 ; j < scan_code_size ; j++){
                                CodeBean scan_code = scan_codes[j];	%>
                            <option value="<%=scan_code.getNm_cd()%>" <%if(file_st.equals(scan_code.getNm_cd())){%> selected<%}%>><%=scan_code.getNm()%></option>
                            <%}%>
                      </select>
                    </td>
                </tr>
                <tr>
                    <td class='title'>��ĵ����</td>
                    <td>&nbsp;
                        <input type="file" name="file" size="50" class=text>
                        <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='<%=m_id%><%=l_cd%>'>
                        <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.LC_SCAN%>'>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <!-- 
    <tr>
        <td colspan="2">�� 2010��5��1�� ���� �뿩�����İ�༭, ����ڵ����, �ź��� ��ĵ�� JPG�� ���� ������ ��� ��ĵ ����� ���� �ʽ��ϴ�.</td>
    </tr>
     -->	
    <tr>
        <td colspan="2">�� <b>�뿩�����İ�༭(��/��)jpg</b>�� <b>������ȣ, �뿩������, �뿩������</b>�� �ۼ��Ȱ����� ��ĵ�ϼ���.</td>
    </tr>
    <!-- 			
    <tr>
        <td colspan="2">�� <b>�ڵ������Լ��ݰ�꼭�� jpg</b>�� ��ĵ����ϼ���.(2012-04-09)</td>
    </tr>	
    <tr>
        <td colspan="2">�� <b>�Ÿ��ֹ����� jpg</b>�� ��ĵ����ϼ���.(2021-03-16)</td>
    </tr>
     -->			
    <tr>
        <td colspan="2">�� <b>���ϱ��� �߰���  IT���������� ��û�ϼ���.</b></td>
    </tr>   
    <%if(delete_yn.equals("N")){%>   
    <tr>
        <td colspan="2">�� <b>���ϻ����� �������忡�� ��û�ϼ���.</b></td>
    </tr>         
    <%}%>    
    <tr>
        <td colspan="2" align="right">
            <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
            <a href='javascript:save()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;
            <%}%>
            <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
        </td>
    </tr>
    <tr>
        <td colspan="2" class=h></td>
    </tr>
    <tr>
        <td colspan="2" style='background-color:bebebe; height:1;'></td>
    </tr>
    <tr>
        <td></td>
    </tr>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���� �ֱ� ��ĵ</span></td>
        <td align="right"><a href='javascript:view_scan_client()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_more.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <%if(client.getClient_st().equals("1")){//����%>
                <tr> 
                    <td class='title' width='15%'>������ּ�</td>
                    <td>&nbsp;<%=client.getO_zip()%> &nbsp;<%=client.getO_addr()%></td>
                </tr>                
                <tr> 
                    <td class='title' width='15%'>�����ּ�</td>
                    <td>&nbsp;<%=client.getHo_zip()%> &nbsp;<%=client.getHo_addr()%></td>
                </tr>
                <tr> 
                    <td class='title'>��ǥ���ּ�</td>
                    <td>&nbsp;<%=client.getRepre_zip()%> &nbsp;<%=client.getRepre_addr()%> [<%=client.getClient_nm()%>]</td>
                </tr>                
                <%}else if(client.getClient_st().equals("2")){//����%>
                <tr> 
                    <td class='title' width='15%'>�����ּ�</td>
                    <td>&nbsp;<%=client.getHo_zip()%> &nbsp;<%=client.getHo_addr()%></td>
                </tr>                
                <tr> 
                    <td class='title' width='15%'>�����ּ�</td>
                    <td>&nbsp;<%=client.getComm_zip()%> &nbsp;<%=client.getComm_addr()%> <%=client.getCom_nm()%></td>
                </tr>                                
                <%}else{%>
                <tr> 
                    <td class='title' width='15%'>������ּ�</td>
                    <td>&nbsp;<%=client.getO_zip()%> &nbsp;<%=client.getO_addr()%></td>
                </tr>                
                <tr> 
                    <td class='title'>��ǥ���ּ�</td>
                    <td>&nbsp;<%=client.getRepre_zip()%> &nbsp;<%=client.getRepre_addr()%> [<%=client.getClient_nm()%>]</td>
                </tr>                                
                <%}%>
            </table>
        </td>
    </tr>  
    <%if(ck_acar_id.equals("000029")){ %>
     <tr>
        <td colspan="2" align="right">�� �� �������� ���� �ŷ�ó Ÿ��� ��ĵ���ϰ� <a href="javascript:scan_sys()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">[����ȭ]</a></td>
    </tr>  	
    <%} %>
    <tr>
        <td colspan="2" class=h></td>
    </tr>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class="title" width='6%'>����</td>
                    <td class="title" width='37%'>����</td>                    
                    <td class="title" width='30%'>���Ϻ���</td>
                    <td class="title" width='27%'>�����</td>
                </tr>
                <%
			attach_vt = c_db.getAcarAttachFileLcScanClientMaxSeqList(base.getClient_id());		
			attach_vt_size = attach_vt.size();		
                
                %>
                <% 	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j); 
 										
 					Hashtable ht2 = c_db.getAcarAttachFileEqual("","",AddUtil.parseInt(String.valueOf(ht.get("SEQ"))));	
 					 					
 					if(!String.valueOf(ht2.get("CONTENT_SEQ")).equals("") && String.valueOf(ht2.get("CONTENT_SEQ")).length() > 20){
 						rent_st = String.valueOf(ht2.get("CONTENT_SEQ")).substring(19,20);
 						file_st = String.valueOf(ht2.get("CONTENT_SEQ")).substring(20); 						
 					}
 		%>                
                
                <tr>
                    <td align="center"><%= j+1 %></td>
                    <td align="center"><%=c_db.getNameByIdCode("0028", "", file_st)%></td>
                    <td align="center"><a href="javascript:openPopP('<%=ht2.get("FILE_TYPE")%>','<%=ht2.get("SEQ")%>');" title='����' ><%=ht2.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht2.get("REG_DATE")%>&nbsp;<%=c_db.getNameById(String.valueOf(ht2.get("REG_USERSEQ")),"USER")%></td>
                </tr>
                <% 		}
    		  		}else{ %>
                <tr>
                    <td colspan="4" class=""><div align="center">�ش� ��ĵ������ �����ϴ�.</div></td>
                </tr>
                <% 	} %>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2" class=h></td>
    </tr>
	  <%if(ch_r.length > 0){%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ�������� ��ĵ</span></td>
    </tr>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class="title" width='5%'>����</td>
                    <td class="title" width='20%'>����</td>
                    <td class="title" width='40%'>����</td>
                    <td class="title" width='15%'>���Ϻ���</td>
                    <td class="title" width='20%'>�����</td>
                </tr>
                <%
    				for(int i=0; i<ch_r.length; i++){
    			        ch_bean = ch_r[i];
    			//	if(ch_bean.getScanfile().equals("")) continue;	
    					
    				//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
				content_code = "CAR_CHANGE";
				content_seq  = ch_bean.getCar_mng_id()+""+ch_bean.getCha_seq();

				attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
				attach_vt_size = attach_vt.size();
				
				if(attach_vt_size > 0){	    	
		%>
                <tr>
                    <td align="center"><%= i+1 %></td>
                    <td align="center">
                    �ڵ��������
    			    </td>
                    <td align="center">
    			  		  <% if(ch_bean.getCha_cau().equals("1")){%>
                          ��뺻���� ���� 
                          <%}else if(ch_bean.getCha_cau().equals("2")){%>
                          �뵵���� 
                          <%}else if(ch_bean.getCha_cau().equals("3")){%>
                          ��Ÿ 
                          <%}else if(ch_bean.getCha_cau().equals("4")){%>
                          ����
                          <%}else if(ch_bean.getCha_cau().equals("5")){%>�űԵ��<%}%>	
    			    </td>
                    <td align="center">
					<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);    								
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='����' ><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>    							
    						<%	}%>		    			
    						<%}%> 				
					 </td>
                    <td align="center"><%=ch_bean.getCha_dt()%><%=c_db.getNameById(ch_bean.getReg_id(),"USER")%></td>
                </tr>
                <% 		}%>
                <% 	}%>
            </table>
        </td>
    </tr>	  
     <% 	} %>	  	  
</table>
</form>
<form name='form2' action='' method='post'>
<input type='hidden' name="user_id" value="<%=user_id%>">
<input type='hidden' name="rent_mng_id" value="<%=m_id%>">
<input type='hidden' name="rent_l_cd" value="<%=l_cd%>">    
<input type='hidden' name="from_page2" value="/fms2/lc_rent/scan_view.jsp">
<input type='hidden' name="idx" value="">
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</div>
</div>
</body>
</html>