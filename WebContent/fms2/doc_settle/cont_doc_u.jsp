<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.user_mng.*, acar.res_search.*, tax.*, acar.insur.*, acar.doc_settle.*, acar.car_sche.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ins" 	class="acar.insur.InsurBean" 			scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>


<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st 		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String fee_start_dt = "";
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String c_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String ins_st 	= request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String ins_doc_no   = request.getParameter("ins_doc_no")==null?"":request.getParameter("ins_doc_no");
	String mode   = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	//�α���ID&������ID&����
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getXmlAuthRw(user_id, "11", "01", "19");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	InsDatabase ins_db = InsDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	//����ǰ��
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	//���躯��
	InsurChangeBean cng_doc = ins_db.getInsChangeDoc(ins_doc_no);
	
	if(!ins_doc_no.equals("") && doc_no.equals("")){
		rent_mng_id = cng_doc.getRent_mng_id();
		rent_l_cd 	= cng_doc.getRent_l_cd();
		c_id				= cng_doc.getCar_mng_id();
		ins_st			= cng_doc.getIns_st();
		rent_st			= cng_doc.getRent_st();
		
		doc = d_db.getDocSettleCommi("42", ins_doc_no);
		doc_no = doc.getDoc_no();
	}
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//1. �� ---------------------------
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//3. �뿩-----------------------------
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size = af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//���ΰ�����������
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "");
	int mgr_size = car_mgrs.size();	
	
	if(ins_doc_no.equals("")){
		ins_doc_no = doc.getDoc_id();
		//���躯��
		cng_doc = ins_db.getInsChangeDoc(ins_doc_no);
	}
	
	//�����
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	
	//���躯�渮��Ʈ
	Vector ins_cha = ins_db.getInsChangeDocList(ins_doc_no);
	int ins_cha_size = ins_cha.size();
	InsurChangeBean cha = new InsurChangeBean();
	for(int j = 0 ; j < ins_cha_size ; j++){
		cha = (InsurChangeBean)ins_cha.elementAt(j);
	}
	
	int total_amt = 0;	
	
	
	//ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "LC_RENT";
	String content_seq  = "";

	Vector attach_vt = new Vector();
	int attach_vt_size = 0;	
	
	String scan_chk_yn = "Y";	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//���� üũ
	function CheckLen(f, max_len){
		if(get_length(f)>max_len){alert(f+'�� ����'+len+'�� �ִ����'+max_len+'�� �ʰ��մϴ�.');}
	}
	
	var popObj = null;
	

	//�˾������� ����
	function ScanOpen(theURL,file_path,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+file_path+""+theURL+""+file_type;		
		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj =window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}		
		popObj.location = theURL;
		popObj.focus();			
	}

	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();	
	}
		
	//����Ʈ
	function list(){
		var fm = document.form1;		
		if(fm.mode.value == 'doc_settle'){
			fm.action = '/fms2/doc_settle/doc_settle_frame.jsp';
		}else{
			fm.action = 'cont_doc_frame.jsp';
		}			
		fm.target = 'd_content';
		fm.submit();
	}	
	
	//�� ����
	function view_client(client_id)
	{
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//����/���� ����
	function view_site(client_id, site_id)
	{
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id+"&site_id="+site_id, "CLIENT_SITE", "left=100, top=100, width=620, height=450");
	}			

	//�ڵ���������� ����
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}		

	
	//��ĵ���
	function scan_reg(file_st, file_cont){
		window.open("/fms2/lc_rent/reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/car_pur/pur_doc_i.jsp&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&file_st="+file_st+"&file_cont="+file_cont, "SCAN", "left=10, top=10, width=620, height=350, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//��ĵ���� ����
	function view_scan(){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, scrollbars=yes");		
	}
			
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
		
		if(doc_bit == '1' && fm.scan_chk_yn.value=='Y'){
			if(fm.scan_yn.value == 'N'){	alert('��û�� ��ĵ�� �Ͻʽÿ�. ���� ��ĵ����� �Ͽ��ٸ� ���ΰ�ħ�� ���� �����Ͻñ� �ٶ��ϴ�.');	return;	}
		}			
		
		<%if(doc.getUser_dt1().equals("")){%>
			if(fm.link_yn[0].checked == false && fm.link_yn[1].checked == false){
				alert('��࿬�� ó�����θ� �����Ͻʽÿ�.'); return;
			}
		<%}%>
		
		var ment = '�����Ͻðڽ��ϱ�?';
		
		if(doc_bit=='u') ment = '�����Ͻðڽ��ϱ�?';
		if(doc_bit=='d') ment = '�����Ͻðڽ��ϱ�?';
		
		if(confirm(ment)){	
			fm.action='cont_doc_sanction.jsp';		
			fm.target='i_no';
//			fm.target='_blank';
			fm.submit();
		}									
	}
	
	function page_reload(){
		var fm = document.form1;
		fm.action='cont_doc_u.jsp';		
		fm.target='d_content';
		fm.submit();		
	}
	
	//�����û��
	function select_inss(){
		var doc_print_type = '1';
		<%if(cha.getCh_item().equals("�����̿���")){%>
			doc_print_type = '1';
		<%}%>
		var fm = document.form1;
		window.open('about:blank', "DOC_PRINT", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "DOC_PRINT";
		fm.action = "cont_doc_print_"+doc_print_type+".jsp";
		fm.submit();	
	}	
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='cont_doc_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1'	 	value='<%=gubun1%>'>  
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="m_id" 			value="<%=rent_mng_id%>">
  <input type='hidden' name="l_cd" 			value="<%=rent_l_cd%>">
  <input type='hidden' name="rent_st" 		value="<%=cng_doc.getRent_st()%>">  
  <input type='hidden' name="car_mng_id" 	value="<%=c_id%>">
  <input type='hidden' name="ins_st" 		value="<%=ins_st%>">
  <input type='hidden' name="doc_no"		value="<%=doc_no%>">  
  <input type='hidden' name="ins_doc_no"	value="<%=ins_doc_no%>">    
  <input type='hidden' name="firm_nm"	 	value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="car_no"	 	value="<%=cr_bean.getCar_no()%>">  
  <input type='hidden' name="mode"			value="<%=mode%>">      
  <input type='hidden' name="from_page" 	value="/fms2/doc_settle/cont_doc_u.jsp">             
  <input type='hidden' name='doc_bit' 		value=''>   
  <input type='hidden' name='ch_cd' 		value='<%=cng_doc.getIns_doc_no()%>'>       
  <input type='hidden' name='car_st' 		value='<%=base.getCar_st()%>'>       
  
  
       
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>���ڹ��� > ������� > <span class=style5>��ຯ�湮��</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td align="right"><%if(!mode.equals("view")){%><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a><%}%></td></td>
	<tr> 	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>����ȣ</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>��������</td>
                    <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
                    <td class=title width=10%>��������</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
                </tr>
                <tr> 
                    <td class=title>���ʿ�����</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
                    <td class=title>�����븮��</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
                    <td class=title>���������</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                </tr>
                <tr>
                    <td class=title>�������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                    <td class=title>��౸��</td>
                    <td>&nbsp;<%String rent_st2 = base.getRent_st();%><%if(rent_st2.equals("1")){%>�ű�<%}else if(rent_st2.equals("3")){%>����<%}else if(rent_st2.equals("4")){%>����<%}%></td>
                    <td class=title>��������</td>
                    <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>���ͳ�<%}else if(bus_st.equals("2")){%>�������<%}else if(bus_st.equals("3")){%>��ü�Ұ�<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>��ȭ���<%}else if(bus_st.equals("6")){%>������ü<%}else if(bus_st.equals("7")){%>������Ʈ<%}else if(bus_st.equals("8")){%>�����<%}%></td>
                </tr>
                <tr> 
                    <td class=title>��������</td>
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>�縮��<%}else if(car_gu.equals("1")){%>����<%}else if(car_gu.equals("2")){%>�߰���<%}%></td>
                    <td class=title>�뵵����</td>
                    <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>����<%}else if(car_st.equals("5")){%>�����뿩<%}%></td>
                    <td class=title>��������</td>
                    <td>&nbsp;<%String rent_way = ext_fee.getRent_way();%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}%></td>
                </tr>
                <tr>
                    <td class=title>��ȣ</td>
                    <td>&nbsp;<a href="javascript:view_client('<%=client.getClient_id()%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=client.getFirm_nm()%></a></td>
                    <td class=title>��ǥ��</td>
                    <td>&nbsp;<%=client.getClient_nm()%></td>
                    <td class=title>����/����</td>
                    <td>&nbsp;<a href="javascript:view_site('<%=client.getClient_id()%>','<%=base.getR_site()%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=site.getR_site()%></a></td>
                </tr>
                <tr>
                    <td class=title>������ȣ</td>
                    <td width=20%>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=cr_bean.getCar_no()%></a></td>
                    <td class=title width=10%>����</td>
                    <td colspan="3" >&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;
        			<font color="#999999">(�����ڵ�:<%=cm_bean.getJg_code()%>)</font>
        			</td>
                </tr>		  
            </table>
	    </td>
    </tr>
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>�����ּ�</td>
                    <td width='37%' align='left'>&nbsp;<%= base.getP_zip()%>&nbsp;<%= base.getP_addr()%>
                    </td>
                    <td width='12%' class='title'>����������</td>
                    <td width="38%" class='left'>&nbsp;<%=base.getTax_agnt()%></td>
                </tr>	
                <%	CarMgrBean mgr1 = new CarMgrBean();
                		for(int i = 0 ; i < mgr_size ; i++){
        							CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        							if(mgr.getMgr_st().equals("�����̿���")){
        								mgr1 = mgr;
        							}
										}                       
                %>                	  
                <tr>
                    <td width='13%' class='title'>����� ���������ȣ</td>
                    <td colspan=3 align='left'>&nbsp;<%=base.getLic_no()%></td>
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
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <%if(base.getCar_st().equals("4")){//����Ʈ%>
                  <tr> 
                    <td width="3%" rowspan="3" class=title>��<br>��<br>��</td>
                    <td class=title width="10%">����</td>
                    <td class=title width="10%">����</td>			
                    <td class=title width="12%">�������</td>
                    <td class=title width="15%">�ּ�</td>
                    <td class=title width="10%">��ȭ��ȣ</td>
                    <td class=title width="10%">�޴���</td>
                    <td width="10%" class=title>���������ȣ</td>
                    <td width="20%" class=title>��Ÿ(����)</td>
                  </tr>
        		  <%String mgr_zip = "";
        			String mgr_addr = "";
        		  	for(int i = 0 ; i < mgr_size ; i++){
        				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        						if(mgr.getMgr_st().equals("�����̿���")){
        		%>
                  <tr> 
                    <td align='center'><%=mgr.getMgr_st()%></td>
                    <td align='center'><%=mgr.getMgr_nm()%></td>
                    <td align='center'><%=AddUtil.ChangeEnpH(mgr.getSsn())%></td>
                    <td align='center'><%=mgr.getMgr_addr()%></td>
                    <td align='center'><%=AddUtil.phoneFormat(mgr.getMgr_tel())%></td>
                    <td align='center'><%=AddUtil.phoneFormat(mgr.getMgr_m_tel())%></td>
                    <td align='center'><%=mgr.getLic_no()%></td>
                    <td align='center'><%=mgr.getEtc()%></td>
                  </tr>
        		  <%		}
        		  		} %>
                  <%}else{%>
                  <tr> 
                    <td width="3%" rowspan="3" class=title>��<br>��<br>��</td>
                    <td class=title width="10%">����</td>
                    <td class=title width="10%">�ٹ�ó</td>			
                    <td class=title width="10%">�μ�</td>
                    <td class=title width="10%">����</td>
                    <td class=title width="10%">����</td>
                    <td class=title width="13%">��ȭ��ȣ</td>
                    <td class=title width="13%">�޴���</td>
                    <td width="21%" class=title>E-MAIL</td>
                  </tr>
        		  <%String mgr_zip = "";
        			String mgr_addr = "";
					String lic_no = "";
        		  	for(int i = 0 ; i < mgr_size ; i++){
        				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        				if(mgr.getMgr_st().equals("�����̿���")){
        					mgr_zip = mgr.getMgr_zip();
        					mgr_addr = mgr.getMgr_addr();
							lic_no	= mgr.getLic_no();
        				%>
                  <tr> 
                    <td align='center'><%=mgr.getMgr_st()%></td>
                    <td align='center'><%=mgr.getCom_nm()%></td>
                    <td align='center'><%=mgr.getMgr_dept()%></td>
                    <td align='center'><%=mgr.getMgr_nm()%></td>
                    <td align='center'><%=mgr.getMgr_title()%></td>
                    <td align='center'><%=AddUtil.phoneFormat(mgr.getMgr_tel())%></td>
                    <td align='center'><%=AddUtil.phoneFormat(mgr.getMgr_m_tel())%></td>
                    <td align='center'><%=mgr.getMgr_email()%></td>
                  </tr>
        		  <%		}
        		  		} %>
                  <tr> 
                    <td colspan="2" class=title>�����̿��� �ǰ����� �ּ�</td>
                    <td colspan="4">&nbsp;<%=mgr_zip%>&nbsp;<%=mgr_addr%></td>
					<td class=title>�����̿��� ���������ȣ</td>
                    <td>&nbsp;<%=lic_no%></td>
                  </tr>
                  <%}%>                  
            </table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr>                  
                    <td class=title width=13%>�����׸�</td>
                    <td class=title>���泻��</td>					
                </tr>
          <%
								int s=0; 
								String app_value[] = new String[7];	
								
								if(cha.getCh_after().length() > 0){
									StringTokenizer st = new StringTokenizer(cha.getCh_after(),"||");
									while(st.hasMoreTokens()){
										app_value[s] = st.nextToken().trim();
										s++;
									}
								}
								if(s<3) app_value[2] = "";
								if(s<4) app_value[3] = "";
								if(s<5) app_value[4] = "";
								if(s<6) app_value[5] = "";
					%>
					<input type='hidden' name='ch_item' 		value='<%=cha.getCh_item()%>'>
                <tr> 
                    <td align='center'><%=cha.getCh_item()%></td>
                    <td>&nbsp;
                    	<%if(cha.getCh_item().equals("�����̿���")){%>
                    		
                        ���� : <input type='text' name='value01' value='<%=app_value[0]%>'  size='8' class='default' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'>&nbsp;
                        ����(����) : <input type='text' name='value02' value='<%=app_value[1]%>'  size='12' class='default' onBlur='javascript:CheckLen(this.value,20)' >&nbsp;
                        ��ȭ��ȣ : <input type='text' name='value03' value='<%=app_value[2]%>'  size='14' class='text' onBlur='javascript:CheckLen(this.value,20)' >&nbsp;
                        �޴��� : <input type='text' name='value04' value='<%=app_value[3]%>'  size='15' class='default' onBlur='javascript:CheckLen(this.value,20)' >&nbsp;
                        ������ȣ��ȣ : <input type='text' name='value05' value='<%=app_value[4]%>'  size='18' class='default' onBlur='javascript:CheckLen(this.value,20)' >&nbsp;
                        E-MAIL : <input type='text' name='value06' value='<%=app_value[5]%>'  size='25' class='text' onBlur='javascript:CheckLen(this.value,80)'  style='IME-MODE: inactive'>
                    	<%}else{%>
                    	<input type='hidden' name='value01' value='<%=app_value[0]%>'>
                    	<input type='hidden' name='value02' value='<%=app_value[1]%>'>
                    	<input type='hidden' name='value03' value='<%=app_value[2]%>'>
                    	<input type='hidden' name='value04' value='<%=app_value[3]%>'>
                    	<input type='hidden' name='value05' value='<%=app_value[4]%>'>
                    	<input type='hidden' name='value06' value='<%=app_value[5]%>'>
                    	<%}%>
                    	<!--
                    	<br>&nbsp;
                    	<font color='#CCCCCC'>(������:<%=cha.getCh_before()%>)</font>
                    	-->
                    </td>
                </tr>		  
            </table>
        </td>
    </tr>	
    <tr>
        <td>&nbsp;</td>
    </tr>
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>��������</td>
                    <td>&nbsp;
        			  <input type='text' name='cng_dt' size='11' value='<%=AddUtil.ChangeDate2(cng_doc.getCh_dt())%>' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'></td>
                </tr>  
                <%if(doc.getUser_dt1().equals("")){%>		
                <tr> 
                    <td class='title' width="13%">��࿬��ó������</td>
                    <td>&nbsp;
                      <input type="radio" name="link_yn" value="Y" >�Ѵ�.
                    	&nbsp;<input type="radio" name="link_yn" value="N" >���Ѵ�.
                    	
                    	<%if(cha.getCh_item().equals("�����̿���")){%>
                    	&nbsp;&nbsp;&nbsp;&nbsp;
                    	(������-������-�����̿��� ������Ʈ)
                    	<%}%>
                    </td>
                </tr>		  
                <%}%>                                                      
                <tr> 
                    <td class='title'>���� �� Ư�̻���</td>
                    <td>&nbsp;
        			  <textarea name="cng_etc" cols="100" class="text" style="IME-MODE: active" rows="5"><%=cng_doc.getCh_etc()%></textarea> 
                    </td>
                </tr>
                <tr> 
                    <td width='13%' class='title'><%if(cha.getCh_item().equals("�����̿���")){%>�����̿��� Ȯ�ο�û��<%}else{%>����Ȯ�ο�û��<%}%></td>
                    <td>&nbsp;
                    
                    	<%
                    	
                    	String file_st = "27";
                    	
				content_code = "LC_SCAN";
				content_seq  = rent_mng_id+""+rent_l_cd+"1"+file_st;

				attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, file_st, 0);
				attach_vt_size = attach_vt.size();
				
				int scan_cnt = 0;		                    	
                    	%>
                    	
						<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);    
    								
    								//����ϰ� �Ϸ��� ������ ��ĵ�� �����´�.	
    								if(AddUtil.parseInt(cng_doc.getReg_dt()) > AddUtil.parseInt(String.valueOf(ht.get("REG_DT")))) continue; 	
    								
    								if(!doc.getVar01().equals("") && AddUtil.parseInt(doc.getVar01()) < AddUtil.parseInt(String.valueOf(ht.get("REG_DT")))) continue; 
    								
    								scan_cnt++;							
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a>
    						<%	}%>		
    						<%}%>	
    						<%if(scan_cnt>0){%>		
    						<input type='hidden' name='scan_yn' value='Y'>        
    						<%}else{%>      
    						<input type='hidden' name='scan_yn' value='N'>        
        			    		<span class="b"><a href="javascript:scan_reg('<%=file_st%>', '<%=cng_doc.getIns_doc_no()%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_scan_reg.gif align=absmiddle border=0></a></span>
						&nbsp;&nbsp;* ��ĵ������ ����ϰ��� �� �������� <a href="javascript:page_reload()">���ΰ�ħ</a> ���ּ��� 			
						&nbsp;&nbsp;<a href="javascript:select_inss()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_ysbg.gif align=absmiddle border=0></a>			
    						<%}%>
					  &nbsp;&nbsp;<a href="javascript:view_scan()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a>			  
					 </td>
                </tr>		
				
            </table>
        </td>
    </tr>	

    <tr>
        <td>&nbsp;doc_no:<%=doc.getDoc_no()%></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13% rowspan="2">����</td>
                    <td class=title width=15%>������</td>
                    <td class=title width=15%><%=doc.getUser_nm1()%></td>
                    <td class=title width=15%></td>
                    <td class=title width=15%></td>
                    <td class=title width=15%></td>
                    <td class=title width=12%></td>			
        	    </tr>	
                <tr> 
                    <td align="center" style='height:44'><%=user_bean.getBr_nm()%></td>
                    <td align="center">
					  <!--�����-->
					  <%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%>
        			  <%if(doc.getUser_dt1().equals("")){
        			  		String user_id1 = doc.getUser_id1();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id1);
        					if(!cs_bean.getWork_id().equals(""))									user_id1 = cs_bean.getWork_id();
        					%>
        			  <%	if(doc.getUser_id1().equals(user_id) || user_id1.equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("���·�����",user_id)){%>
        			    <a href="javascript:doc_sanction('1')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
        			  	<input type="hidden" name="doc_user_id1" value="<%=doc.getUser_id1()%>">
					</td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>			
        	    </tr>	
    		</table>
	    </td>
	</tr>  	 
	<%if(!mode.equals("view")){%> 		
		
	<%		if(doc.getUser_id1().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("���·�����",user_id)){%>
	<tr>
	    <td class=h></td>
	</tr>		
		  <%	if(!doc.getDoc_step().equals("3") || nm_db.getWorkAuthUser("������",user_id)){%> 		
    <tr>
		<td align="right">
		  <a href="javascript:doc_sanction('u');"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
		  &nbsp;
		  <a href="javascript:doc_sanction('d');"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>
		</td>
	</tr>	
		  <%	}%>	
	<%		}%>
	<%}%>

<input type='hidden' name="scan_chk_yn"		value="<%=scan_chk_yn%>">      			
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
