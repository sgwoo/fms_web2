<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*,acar.car_register.*,acar.common.*, acar.client.*, acar.res_search.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//��ĵ���� ������
	
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String s_cd 	= request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String rent_st 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String from_page= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String file_st = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	String user_id = login.getCookieValue(request, "acar_id");
	
	
	//��������
	Hashtable reserv = rs_db.getCarInfo(c_id);
	
	//�ܱ�������
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	rent_st = rc_bean.getRent_st();
	
	//������
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
	
	//������
	ClientBean client = al_db.getNewClient(rc_bean.getCust_id());
	
	
	//������ȣ �̷�
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarHisBean ch_r [] = crd.getCarHisAll(c_id);
	
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
		
	
	String content_code = "SC_SCAN";
	String content_seq  = c_id+""+s_cd;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();		
	
	
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
		
		if(!confirm("�ش� ������ ����Ͻðڽ��ϱ�?"))	return;
		
		fm.<%=Webconst.Common.contentSeqName%>.value = fm.<%=Webconst.Common.contentSeqName%>.value+''+fm.file_st.value;
						
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.SC_SCAN%>";				
		fm.submit();
	}
	
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post' enctype="multipart/form-data">
<input type='hidden' name="user_id" value="<%=user_id%>">
<input type='hidden' name="c_id" value="<%=c_id%>">
<input type='hidden' name="s_cd" value="<%=s_cd%>">
<input type='hidden' name="from_page" 	value="<%=from_page%>">  
<table border="0" cellspacing="0" cellpadding="0" width=670>
    <tr>
    	<td colspan="2">
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>����ý��� ��ĵ���� (<%=c_id%>)</span></span></td>
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
	      
    <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>����ȣ</td>
                    <td width='20%'>&nbsp;<%=s_cd%></td>
                    <td class='title' width='15%'>��ȣ</td>
                    <td width='50%'>&nbsp;<%=client.getFirm_nm()%> <%=client.getClient_nm()%></td>
                </tr>
                <tr> 
                    <td class='title'>������ȣ</td>
                    <td>&nbsp;<%=reserv.get("CAR_NO")%></td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%></td>
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
                    <td class="title" width='10%'>����</td>                    
                    <td class="title" width='25%'>����</td>                    
                    <td class="title" width='25%'>���Ϻ���</td>
                    <td class="title" width='30%'>�����</td>
                    <td class="title" width='10%'>����</td>
                </tr>
                
                <% 	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j); 
 					
 					if(!String.valueOf(ht.get("CONTENT_SEQ")).equals("") && String.valueOf(ht.get("CONTENT_SEQ")).length() > 12){
 						file_st = String.valueOf(ht.get("CONTENT_SEQ")).substring(12);
 					}
 		%>
                <tr>
                    <td align="center"><%= j+1 %></td>			
                    <td align="center">
                    	<%if(file_st.equals("1")){%>���ʰ�༭<%}%>
                    	<%if(file_st.equals("17")){%>�뿩�����İ�༭(��)<%}%>
                    	<%if(file_st.equals("18")){%>�뿩�����İ�༭(��)<%}%>					
                    	<%if(file_st.equals("2")){%>����ڵ����<%}%>
                    	<%if(file_st.equals("3")){%>���ε��ε<%}%>
                    	<%if(file_st.equals("6")){%>�����ΰ�����<%}%>
                    	<%if(file_st.equals("4")){%>�ź���<%}%>
                    	<%if(file_st.equals("7")){%>�ֹε�ϵ<%}%>
                    	<%if(file_st.equals("8")){%>�ΰ�����<%}%>
                    	<%if(file_st.equals("9")){%>����纻<%}%>
                    	<%if(file_st.equals("10")){%>���ݰ�꼭<%}%>
                    	<%if(file_st.equals("5")){%>��Ÿ<%}%>
                    	<%if(file_st.equals("11")){%>�����νź���<%}%>
                    	<%if(file_st.equals("12")){%>�����ε<%}%>
                    	<%if(file_st.equals("13")){%>�������ΰ�<%}%>												
                    	<%if(file_st.equals("14")){%>���뺸����<%}%>	
                    	<%if(file_st.equals("15")){%>�Ÿ��ֹ���<%}%>
                    	<%if(file_st.equals("16")){%>���·�÷�μ���<%}%>
			<%if(file_st.equals("19")){%>���谡��Ư�༭<%}%>
			<%if(file_st.equals("20")){%>����������ΰ�����<%}%>					
			<%if(file_st.equals("21")){%>��������׺����û��<%}%>					
			<%if(file_st.equals("22")){%>�뿩������׺����û��<%}%>					
			<%if(file_st.equals("24")){%>�ֿ����ڿ���������<%}%>
			<%if(file_st.equals("25")){%>���������ε���<%}%>
			<%if(file_st.equals("26")){%>���������μ���<%}%>
			<%if(file_st.equals("27")){%>�߰������ڿ���������<%}%>
			<%if(file_st.equals("28")){%>�⺻�������������������<%}%>
    		    </td>                    
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%>&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("REG_USERSEQ")),"USER")%></td>
                    <td align="center">
                        <%if(file_st.equals("1")||file_st.equals("2")||file_st.equals("4")||file_st.equals("9")||file_st.equals("17")||file_st.equals("18")){ //�ֿ佺ĵ�� �����ϰ� ��ĵ�ڰ� �����Ҽ� �ִ�.%>
	                    	<%if(nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("������",ck_acar_id)){%>
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
                    <td colspan="5" class=""><div align="center">�ش� ��ĵ������ �����ϴ�.</div></td>
                </tr>
                <% 	} %>
            </table>
        </td>
    </tr>
    <%
    	file_st = "";
    %>
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
                    <td class='title' width='15%'>����</td>
                    <td width='85%'>&nbsp;
        	        <select name="file_st">
                            <option value="1" <%if(file_st.equals("1")){%>selected<%}%>>���ʰ�༭</option>
                            <option value="17" <%if(file_st.equals("17")){%>selected<%}%>>�뿩�����İ�༭(��)jpg</option>						
                            <option value="18" <%if(file_st.equals("18")){%>selected<%}%>>�뿩�����İ�༭(��)jpg</option>												
                            <option value="2" <%if(file_st.equals("2")){%>selected<%}%>>����ڵ����jpg</option>
                            <option value="3" <%if(file_st.equals("3")){%>selected<%}%>>���ε��ε</option>				
                            <option value="6" <%if(file_st.equals("6")){%>selected<%}%>>�����ΰ�����</option>								
                            <option value="4" <%if(file_st.equals("4")){%>selected<%}%>>�ź���jpg</option>				
                            <option value="7" <%if(file_st.equals("7")){%>selected<%}%>>�ֹε�ϵ</option>				
                            <option value="8" <%if(file_st.equals("8")){%>selected<%}%>>�ΰ�����</option>		
                            <option value="14" <%if(file_st.equals("14")){%>selected<%}%>>���뺸����</option>														
                            <option value="11" <%if(file_st.equals("11")){%>selected<%}%>>�����νź���</option>				
                            <option value="12" <%if(file_st.equals("12")){%>selected<%}%>>�����ε</option>				
                            <option value="13" <%if(file_st.equals("13")){%>selected<%}%>>�������ΰ�����</option>																				
                            <option value="9" <%if(file_st.equals("9")){%>selected<%}%>>����纻</option>
                            <option value="5" <%if(file_st.equals("5")){%>selected<%}%>>��Ÿ</option>				
                            <option value="24" <%if(file_st.equals("24")){%>selected<%}%>>�ֿ����ڿ���������</option>
                            <option value="25" <%if(file_st.equals("25")){%>selected<%}%>>���������ε���</option>
                            <option value="26" <%if(file_st.equals("26")){%>selected<%}%>>���������μ���</option>
                            <option value="27" <%if(file_st.equals("27")){%>selected<%}%>>�߰������ڿ���������</option>
                            <option value="28" <%if(file_st.equals("28")){%>selected<%}%>>�⺻�������������������</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class='title'>��ĵ����</td>
                    <td>                        
                        <input type="file" name="file" size="50" class=text>
                        <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='<%=c_id%><%=s_cd%>'>
                        <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.SC_SCAN%>'>                               			    
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2" align="right"><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
        <td colspan="2"></td>
    </tr>
    <tr>
        <td colspan="2" align="right"></td>
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
    				
    				if(ch_bean.getScanfile().equals("")) continue;	
    		
				//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
				content_code = "CAR_CHANGE";
				content_seq  = ch_bean.getCar_mng_id()+""+ch_bean.getCha_seq();

				attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
				attach_vt_size = attach_vt.size();
				
				if(attach_vt_size > 0){	    					
    		%>
                <tr>
                    <td align="center"><%= i+1 %></td>
                    <td align="center">�ڵ��������</td>
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
    <%}%>	  	  
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
