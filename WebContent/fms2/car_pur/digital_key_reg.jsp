<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.car_mst.*, acar.client.*, acar.car_register.*, acar.user_mng.*, acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
String br_id 	= request.getParameter("br_id")  ==null?"":request.getParameter("br_id");

String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(auth_rw.equals(""))	auth_rw = rs_db.getXmlAuthRw(user_id, "01", "07", "15");
	
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//���ΰ�����������
	Vector car_mgrs = a_db.getCarMgrListNew(m_id, l_cd, "Y");
	int mgr_size = car_mgrs.size();
	
	//�������
	ContPurBean pur = a_db.getContPur(m_id, l_cd);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, "1");
	
	//�ڵ����������
	cr_bean = crd.getCarRegBean(base.getCar_mng_id());

	//����ŻŰ����
	Hashtable key = ec_db.getDigitalKey(m_id, l_cd);
	
	//��ĵ���� ������Ű��� �����������Ǽ� �� ������
	String content_code = "LC_SCAN";
	String content_seq  = m_id+""+l_cd+"150"; 
	Vector attach_vt_26 = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
	int attach_vt_26_size = attach_vt_26.size();
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function update(mode){		
		var fm = document.form1;
		
		fm.mode.value = mode;
		
		if(fm.com_firm_nm.value == '')		{	alert('�ǰ����� �Է��Ͽ� �ֽʽÿ�.'); 				fm.com_firm_nm.focus(); 		return;		}
		if(fm.com_firm_tel.value == '')		{	alert('�ǰ� �޴�����ȣ�� �Է��Ͽ� �ֽʽÿ�.'); 		fm.com_firm_tel.focus(); 		return;		}
		if(fm.start_dt.value == '')			{	alert('���������� �Է��Ͽ� �ֽʽÿ�.'); 			fm.start_dt.focus(); 			return;		}
		if(fm.end_dt.value == '')			{ 	alert('����������� �Է��Ͽ� �ֽʽÿ�.'); 			fm.end_dt.focus(); 				return; 	}
		
		var ment = '';
		
		if(mode == 'd'){
			ment = '���� ';
		}
		
		if(confirm(ment+'ó�� �Ͻðڽ��ϱ�?')){	
			fm.action='digital_key_reg_a.jsp';		
			fm.target='i_no';			
			fm.submit();
		}
	}	

	//��ĵ���
	function scan_reg(file_st){
		window.open("/fms2/lc_rent/reg_scan.jsp?auth_rw=4&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/car_pur/pur_doc_i.jsp&rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&file_st="+file_st, "SCAN", "left=10, top=10, width=620, height=350, scrollbars=yes, status=yes, resizable=yes");
	}
	
	function Anc_Open(bbs_id){
		var SUBWIN="/fms2/off_anc/anc_se_c.jsp?bbs_id="+bbs_id+"&acar_id=<%=user_id%>";	
		window.open(SUBWIN, "AncDisp", "left=200, top=150, width=950, height=700, scrollbars=yes");
	}	
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'> 
  <input type='hidden' name='gubun6' 	value='<%=gubun6%>'>       
  <input type='hidden' name='sort' 	value='<%=sort%>'>
  <input type='hidden' name='m_id' 	value='<%=m_id%>'>
  <input type='hidden' name='l_cd' 	value='<%=l_cd%>'>
  <input type='hidden' name='mode' 	value='<%=mode%>'>
  <input type='hidden' name='firm_nm' 	value='<%=client.getFirm_nm()%>'>
<table border="0" cellspacing="0" cellpadding="0" width=670>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>����ŻŰ����</span></span></td>
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
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>����ȣ</td>
                    <td width='29%'>&nbsp;<%=l_cd%></td>
                    <td class='title' width='15%'>�뿩�Ⱓ</td>
                    <td width='41%'>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_start_dt())%>~<%=AddUtil.ChangeDate2(base.getRent_end_dt())%></td>
                </tr>
                <tr> 
                    <td class='title'>��ȣ</td>
                    <td colspan='3'>&nbsp;<%=client.getFirm_nm()%><%if(!client.getClient_st().equals("2")){%>&nbsp;<%=client.getClient_nm()%><%}%></td>
                </tr>                     
                <tr> 
                    <td class='title'>������</td>
                    <td>&nbsp;<%if(client.getClient_st().equals("1")) 		out.println("����");
                      	else if(client.getClient_st().equals("2"))  out.println("����");
                      	else if(client.getClient_st().equals("3")) 	out.println("���λ����(�Ϲݰ���)");
                      	else if(client.getClient_st().equals("4"))	out.println("���λ����(���̰���)");
                      	else if(client.getClient_st().equals("5")) 	out.println("���λ����(�鼼�����)");
        				else if(client.getClient_st().equals("6")) 	out.println("�����");%></td>
                    <td class='title'>����ڹ�ȣ</td>
                    <td>&nbsp;<%if(!client.getClient_st().equals("2")){%><%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%><%}%></td>
                </tr>                
            </table>
    	</td>
    </tr>
    <%if(!site.getR_site().equals("")){%>
    <tr>
        <td class=h></td>
    </tr>            
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>        
                <tr> 
                    <td class='title' width='15%'><%if(site.getSite_st().equals("1")) 		out.println("����");
                      	else if(site.getSite_st().equals("2"))  out.println("����");%></td>
                    <td width='29%'>&nbsp;<%=site.getR_site()%></td>
                    <td class='title' width='15%'>����ڹ�ȣ</td>
                    <td width='41%'>&nbsp;<%=AddUtil.ChangeEnp(site.getEnp_no())%></td>
                </tr>                
            </table>
        </td>
    </tr>    
    <%}%>
    <tr>
        <td class=h></td>
    </tr>            
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>        
                <tr> 
                    <td class='title' width='15%'>������ȣ</td>
                    <td width='29%'>&nbsp;<%=cr_bean.getCar_no()%></td>
                    <td class='title' width='15%'>�����ȣ</td>
                    <td width='41%'>&nbsp;<%=cr_bean.getCar_num()%></td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td colspan='3'>&nbsp;<%=cr_bean.getCar_nm()%> <%=cm_bean.getCar_name()%></td>
                </tr>                
                <tr> 
                    <td class='title'>�ɼ�</td>
                    <td colspan='3'>&nbsp;<%=car.getOpt()%></td>
                </tr>
                <tr> 
                    <td class='title'>�����������Ǽ� �� ������</td>
                    <td colspan='3'>&nbsp;<%
					  	if(attach_vt_26_size > 0){
					  		for(int k=0; k<attach_vt_26_size; k++){
					  			Hashtable ht = (Hashtable)attach_vt_26.elementAt(k);
					  			%>
					  				<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a>&nbsp;
					  			<%
					  		}
					  	}else{
					  		%>
<span class="b"><a href="javascript:scan_reg('50')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_scan_reg.gif align=absmiddle border=0></a></span>
					  		<%
					  	}
					  %></td>
                </tr>                
            </table>
        </td>
    </tr>
    <tr>
        <td><font color=red>�� ������Ű�� �ִ� ����(Ʈ��), �ɼ��� �ִ� ��쿡 ��û ����Ͻʽÿ�.</font></td>
    </tr>     
    <tr>
        <td class=h></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="5%" rowspan="<%=mgr_size+1%>" class=title>��<br>��<br>��</td>
                    <td class=title width="10%">����</td>
                    <td class=title width="15%">�ٹ�ó</td>			
                    <td class=title width="15%">�μ�</td>
                    <td class=title width="15%">����</td>
                    <td class=title width="10%">����</td>
                    <td class=title width="15%">��ȭ��ȣ</td>
                    <td class=title width="15%">�޴���</td>
                </tr>
    		  	<%
    		  		for(int i = 0 ; i < mgr_size ; i++){
    					CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
    			%>
                <tr>
                    <td align='center'><%=mgr.getMgr_st()%></td>
                    <td align='center'><%=mgr.getCom_nm()%></td>
                    <td align='center'><%=mgr.getMgr_dept()%></td>
                    <td align='center'><%=mgr.getMgr_nm()%></td>
                    <td align='center'><%=mgr.getMgr_title()%></td>
                    <td align='center'><%=mgr.getMgr_tel()%></td>
                    <td align='center'><%=mgr.getMgr_m_tel()%></td>
                </tr>
    		  	<%	}%>
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>	     
    <tr>
        <td class=line2></td>
    </tr>  
    <%
    	if(String.valueOf(key.get("RENT_L_CD")).equals("")||String.valueOf(key.get("RENT_L_CD")).equals("null")){
			key.put("FIRM_NM", client.getClient_nm());
			key.put("FIRM_TEL", client.getM_tel());
			key.put("ETC", "");
    		if(cm_bean.getCar_comp_id().equals("0001")){
    			if(client.getClient_st().equals("1")){
    				key.put("FIRM_NM", client.getFirm_nm());
        			key.put("FIRM_TEL", client.getEnp_no1()+""+client.getEnp_no2()+""+client.getEnp_no3());        				    				
    			}
    		}
			key.put("START_DT", fee.getRent_start_dt());
			key.put("END_DT", c_db.addMonth(fee.getRent_start_dt(), 7*12));
    	}
    %>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>	
                <tr> 
                    <td width=15% class=title>�ǰ�</td>
                    <td width=85%>&nbsp;<input type='text' name="com_firm_nm" value='<%=key.get("FIRM_NM")%>' size='50' class='default'>
                      <%if(cm_bean.getCar_comp_id().equals("0002")){%>
                      (�����:���θ��Ǹ� �Է� ����)
                      <%}else{%>
                      (������:����-���θ�/����-���μ���)
                      <%}%>
       			  </td>
       			</tr>  
                <tr> 
                    <td width=15% class=title>����ó</td>
                    <td width=85%>&nbsp;<input type='text' name="com_firm_tel" value='<%=key.get("FIRM_TEL")%>' size='20' class='default'>
                      <%if(cm_bean.getCar_comp_id().equals("0002")){%>
                      (�����:���� �޴���ȭ��ȣ)
                      <%}else{%>
                      (������:����-����ڹ�ȣ/����-�޴���ȭ��ȣ)
                      <%}%>
       			  </td>
       			</tr>  
       			<tr> 
                    <td width=15% class=title>���</td>
                    <td width=85%>&nbsp;<input type='text' name="etc" value='<%=key.get("ETC")%>' size='50' class='default'>                      
       			  </td>
       			</tr> 
       			<tr> 
                    <td width=15% class=title>�Ⱓ����</td>
                    <td width=85%>&nbsp;<input type='text' size='12' name='start_dt' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(String.valueOf(key.get("START_DT")))%>' onBlur='javscript:this.value = ChangeDate(this.value);'>~
                    <input type='text' size='12' name='end_dt' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(String.valueOf(key.get("END_DT")))%>' onBlur='javscript:this.value = ChangeDate(this.value);'>                 
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
          
   	      <%if(String.valueOf(key.get("RENT_L_CD")).equals("")||String.valueOf(key.get("RENT_L_CD")).equals("null")){%>
	      <a href="javascript:update('i')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;		
   	      <%}else{%>
   	      <%	if(String.valueOf(key.get("COM_CLS_DT")).equals("") && (nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��������",user_id) || nm_db.getWorkAuthUser("������Ű�δ��",user_id) || nm_db.getWorkAuthUser("�����������������",user_id))){%>		
	      <a href="javascript:update('u')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;	      	
	      <%//		if(String.valueOf(key.get("COM_REG_DT")).equals("")){%>
	      &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:update('d')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
	      <%//		} %>
	      <%	}%>
	      <%}%>
		  <a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr> 
    <tr>
        <td>�� ���� : ������Ű ��û ���� (2020-09-10) <a href="javascript:Anc_Open('7941')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_see.gif align=absmiddle border=0></a></td>
    </tr>	    
</table>
</form>
<script language="JavaScript">
<!--		
//-->
</script>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
