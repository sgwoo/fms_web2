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
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>

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
	boolean ch_item6_yn = false; 
	
	//�α���ID&������ID&����
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "15", "01", "17");
	
	
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
		
		doc = d_db.getDocSettleCommi("48", ins_doc_no);
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
	
	int total_amt = 0;	
	
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
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
			fm.action = 'fee_doc_frame.jsp';
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

	//�뿩���
	function view_fee(rent_mng_id, rent_l_cd, rent_st)
	{		
		window.open("/fms2/lc_rent/view_fee.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+rent_st+"&cmd=view", "VIEW_FEE", "left=100, top=100, width=850, height=650, scrollbars=yes");
	}		
	
	//��ĵ���
	function scan_reg(file_st, file_cont){
		window.open("/fms2/lc_rent/reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/car_pur/pur_doc_i.jsp&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&file_st="+file_st+"&file_cont="+file_cont, "SCAN", "left=10, top=10, width=620, height=350, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//��ĵ���� ����
	function view_scan(){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, scrollbars=yes");		
	}


	
	function set_d_ch_amt(){
		var fm = document.form1;
		fm.d_fee_amt.value 	= parseDecimal(toInt(parseDigit(fm.n_fee_amt.value)) - toInt(parseDigit(fm.o_fee_amt.value)));
	}	
			
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;

		<%if(!doc.getUser_dt1().equals("")){%>
		if(doc_bit == '2'){
			if(fm.ins_doc_st.value == ''){ alert('ó�������� �����Ͻʽÿ�.'); return; }	
			if(fm.ins_doc_st.value == 'N'){
				if(fm.reject_cau.value == ''){ alert('�Ⱒ�� ó�������� �Է¹ٶ��ϴ�'); return; }	
				
			}
		}		
		<%}else{%>
		<%	if(!nm_db.getWorkAuthUser("������",user_id)){%>
		if(doc_bit == '1' && fm.scan_chk_yn.value=='Y'){
			if(fm.ch_item.value!="6"){	//�뿩���Աݿ����� ���� ���̸� ��ĵ���� ����(20180720)
				if(fm.scan_yn.value == 'N'){	alert('�����׺����û�� ��ĵ�� �Ͻʽÿ�. ���� ��ĵ����� �Ͽ��ٸ� ���ΰ�ħ�� ���� �����Ͻñ� �ٶ��ϴ�.');	return;	}
			}
		}
		<%	}%>
		<%}%>
		
		if(doc_bit == '3'){
			if(toInt(parseDigit(fm.n_fee_amt.value))>0){
				fm.n_fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.n_fee_amt.value))));
				fm.n_fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.n_fee_amt.value)) - toInt(parseDigit(fm.n_fee_s_amt.value)));
			}
			if(toInt(parseDigit(fm.n_opt_amt.value))>0){
				fm.n_opt_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.n_opt_amt.value))));
				fm.n_opt_v_amt.value = parseDecimal(toInt(parseDigit(fm.n_opt_amt.value)) - toInt(parseDigit(fm.n_opt_s_amt.value)));
			}
		}
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='fee_doc_sanction.jsp';		
			fm.target='i_no';
//			fm.target='_blank';
			fm.submit();
		}									
	}
	
	//�뿩�ὺ���ٰ����� �̵�	
	function move_fee_scd(){
		
		//������� ����� �˾� ���� �뿩�ὺ���� �̵�
		window.open("/fms2/con_fee/fee_doc_u.jsp?ins_doc_no=<%=ins_doc_no%>&mode=view", "VIEW_INSDOC", "left=100, top=10, width=850, height=650, scrollbars=yes");		
		
		var fm = document.form1;		
		fm.target = 'd_content';	
		fm.action = '/fms2/con_fee/fee_scd_u_frame.jsp';
		fm.submit();								
	}	
	
	function page_reload(){
		var fm = document.form1;
		fm.action='fee_doc_u.jsp';		
		fm.target='d_content';
		fm.submit();		
	}
	
	//�Ⱒ�ϴ� �������̱�
	function display_reject(){
		/* var fm = document.form1;
		
		if(fm.ins_doc_st.value =='N'){ //�Ⱒ
			tr_reject.style.display	= '';
		}else{							//����
			tr_reject.style.display	= 'none';
		} */
	}	
	
			//�����û��
	function select_inss(){
		var fm = document.form1;
		window.open('about:blank', "INSDOC_PRINT", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "INSDOC_PRINT";
		fm.action = "fee_doc_print_n.jsp";
		fm.submit();	
	}	
			
	//���ϼ����ϱ�
	function go_mail(rent_mng_id, rent_l_cd, ins_doc_no, doc_no){			
		var SUBWIN="fee_doc_u_mail.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&ins_doc_no="+ins_doc_no+"&doc_no="+doc_no;
		window.open(SUBWIN, "openMail", "left=100, top=100, width=440, height=500, scrollbars=no, status=yes");
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
<form action='fee_doc_u_a.jsp' name="form1" method='post'>
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
  <input type='hidden' name="from_page" 	value="/fms2/con_fee/fee_doc_u.jsp">             
  <input type='hidden' name='doc_bit' 		value=''>   
  <input type='hidden' name='o_est_id' 		value='<%=e_bean.getEst_id()%>'>     
  <input type='hidden' name='ch_cd' 		value='<%=cng_doc.getIns_doc_no()%>'>       
  <input type='hidden' name='car_st' 		value='<%=base.getCar_st()%>'>       
  
  <input type='hidden' name='n_fee_s_amt' value=''>
  <input type='hidden' name='n_fee_v_amt' value=''>
  <input type='hidden' name='n_opt_s_amt' value=''>
  <input type='hidden' name='n_opt_v_amt' value=''>
  
       
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>���ڹ��� > ������� > <span class=style5>�뿩�ắ�湮��</span></span></td>
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
            <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
                <tr>
                    <td style="font-size : 9pt;" width="3%" class=title rowspan="2">����</td>
                    <td style="font-size : 9pt;" width="10%" class=title rowspan="2">�������</td>
                    <td style="font-size : 9pt;" width="6%" class=title rowspan="2">�̿�Ⱓ</td>
                    <td style="font-size : 9pt;" width="8%" class=title rowspan="2">�뿩������</td>
                    <td style="font-size : 9pt;" width="8%" class=title rowspan="2">�뿩������</td>
                    <td style="font-size : 9pt;" width="7%" class=title rowspan="2">�����</td>
                    <td style="font-size : 9pt;" width="9%" class=title rowspan="2">���뿩��</td>
                    <td style="font-size : 9pt;" class=title colspan="2">������</td>
                    <td style="font-size : 9pt;" width="10%" class=title rowspan="2">������</td>
                    <td style="font-size : 9pt;" class=title colspan="2">���ô뿩��</td>
                    <td style="font-size : 9pt;" class=title colspan="2">���Կɼ�</td>
                </tr>
                <tr>
                    <td style="font-size : 9pt;" width="10%" class=title>�ݾ�</td>
                    <td style="font-size : 9pt;" width="3%" class=title>�°�</td>
                    <td style="font-size : 9pt;" width="10%" class=title>�ݾ�</td>
                    <td style="font-size : 9pt;" width="3%" class=title>�°�</td>
                    <td style="font-size : 9pt;" width="10%" class=title>�ݾ�</td>
                    <td style="font-size : 9pt;" width="3%" class=title>%</td>			
                </tr>
    		  <%for(int i=0; i<fee_size; i++){
    				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
    				if(!fees.getCon_mon().equals("")){%>	
                <tr>
                    <td style="font-size : 9pt;" align="center"><%=i+1%></td>
                    <td style="font-size : 9pt;" align="center"><a href="javascript:view_fee('<%=rent_mng_id%>','<%=rent_l_cd%>','<%=fees.getRent_st()%>')"><%=AddUtil.ChangeDate2(fees.getRent_dt())%></a></td>
                    <td style="font-size : 9pt;" align="center"><%=fees.getCon_mon()%>����</td>
                    <td style="font-size : 9pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_start_dt())%></td>
                    <td style="font-size : 9pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
                    <td style="font-size : 9pt;" align="center"><%if(i==0){%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}else{%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}%></td>
                    <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>��&nbsp;</td>
                    <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>��&nbsp;</td>
                    <td style="font-size : 9pt;" align="center"><%if(fees.getGrt_suc_yn().equals("0")){%>�°�<%}else if(fees.getGrt_suc_yn().equals("1")){%>����<%}else{%>-<%}%></td>			
                    <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>��&nbsp;</td>
                    <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>��&nbsp;</td>
                    <td style="font-size : 9pt;" align="center"><%if(fees.getIfee_suc_yn().equals("0")){%>�°�<%}else if(fees.getIfee_suc_yn().equals("1")){%>����<%}else{%>-<%}%></td>
                    <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>��&nbsp;</td>
                    <td style="font-size : 9pt;" align="center"><%=fees.getOpt_per()%></td>
                </tr>
    		  <%}}%>
            </table>
	    </td>
	</tr>	
	<tr>
	    <td class=h></td>
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
                    <td class=title width=3% rowspan="2">����</td>
                    <td class=title width=10% rowspan="2">�����׸�</td>
                    <td class=title colspan="2">�������</td>					
                </tr>
                <tr> 
                    <td class=title width=22%>������</td>
                    <td class=title width=65%>������</td>
                </tr>
          <%	for(int i = 0 ; i < ins_cha_size ; i++){
					InsurChangeBean cha = (InsurChangeBean)ins_cha.elementAt(i);
					if(cha.getCh_item().equals("6")){
						ch_item6_yn = true;
					}	%>
					
                <tr align="center"> 
                    <td><%=i+1%> 
                      <input type='hidden' name='ch_tm' value='<%=cha.getCh_tm()%>'>
                    </td>
                    <td>
        	        <select name="ch_item" disabled>
            	      <option value="1" <%if(cha.getCh_item().equals("1")){%>selected<%}%>>�뿩��ǰ</option>
            	      <option value="2" <%if(cha.getCh_item().equals("2")){%>selected<%}%>>�뿩������</option>
        	          <option value="3" <%if(cha.getCh_item().equals("3")){%>selected<%}%>>��Ÿ</option>
        	          <option value="4" <%if(cha.getCh_item().equals("4")){%>selected<%}%>>�߰�������</option>
        	          <option value="5" <%if(cha.getCh_item().equals("5")){%>selected<%}%>>��������Ÿ�����</option>
        	          <option value="6" <%if(cha.getCh_item().equals("6")){%>selected<%}%>>�뿩���Աݿ����Ϻ���</option>
        	          <option value="7" <%if(cha.getCh_item().equals("7")){%>selected<%}%>>�������ｺƼĿ�߱�</option>
        	          <option value="8" <%if(cha.getCh_item().equals("8")){%>selected<%}%>>������ġ����</option>
        	          <option value="9" <%if(cha.getCh_item().equals("9")){%>selected<%}%>>����������</option>
        	        </select>
        	        <input type="hidden" name="r_ch_item" value="<%=cha.getCh_item() %>">			
                    </td>
                    <td>
                      <input type='text' size=<%if(cha.getCh_item().equals("5")){%>'10'<%}else{%>'50'<%} %> name='ch_before' class='text' value='<%=cha.getCh_before()%>'><%if(cha.getCh_item().equals("5")){%>km����/1��<%}%>
                    </td>					
                    <td>
                      <input type='text' size=<%if(cha.getCh_item().equals("5")){%>'10'<%}else{%>'50'<%} %> name='ch_after' class='text' value='<%=cha.getCh_after()%>'><%if(cha.getCh_item().equals("5")){%>km����/1��<%}%>
                    </td>
                </tr>		  
          <%	}%>
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
                <tr> 
                    <td class='title'>���� �� Ư�̻���</td>
                    <td>&nbsp;
        			  <textarea name="cng_etc" cols="100" class="text" style="IME-MODE: active" rows="5"><%=cng_doc.getCh_etc()%></textarea> 
                    </td>
                </tr>
                <tr> 
                    <td width='13%' class='title'>�����׺����û��</td>
                    <td>&nbsp;
                    
                    	<%
				content_code = "LC_SCAN";
				content_seq  = rent_mng_id+""+rent_l_cd+"1"+"22";

				attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "22", 0);
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
    						<a href="javascript:go_mail('<%=rent_mng_id%>', '<%=rent_l_cd%>', '<%=ins_doc_no%>', '<%=doc_no%>')" title='���� ���� �߼�'><img src=/acar/images/center/button_in_email.gif align=absmiddle border=0></a>  
							<%	if(ck_acar_id.equals("000029")){%>	
							&nbsp;&nbsp;<input type="button" class="button" value="���ڹ��� �߼�" onclick="javascript:confirmDoc('mail','9');">
							&nbsp;&nbsp;<a href="javascript:select_inss()" onMouseOver="window.status=''; return true" title="��ĺ���"><img src=/acar/images/center/button_ysbg.gif align=absmiddle border=0></a>
							<%	} %>
							<!-- �����Ϸ����̸� �߰���ϵ� �����ϴ�. -->
							<%	if(doc.getDoc_step().equals("0")){%>
							(�߰����:
							&nbsp;&nbsp;<a href="javascript:select_inss()" onMouseOver="window.status=''; return true" title="��ĺ���"><img src=/acar/images/center/button_ysbg.gif align=absmiddle border=0></a>
							<span class="b"><a href="javascript:scan_reg('22', '<%=cng_doc.getIns_doc_no()%>')" onMouseOver="window.status=''; return true" title="��ĵ���"><img src=/acar/images/center/button_in_scan_reg.gif align=absmiddle border=0></a></span>
							�� ������ ��ĵ����
							)
							<%	} %>							
    						<%}else{%>      
    						<input type='hidden' name='scan_yn' value='N'>        
        			    	<span class="b"><a href="javascript:scan_reg('22', '<%=cng_doc.getIns_doc_no()%>')" onMouseOver="window.status=''; return true" title="��ĵ���"><img src=/acar/images/center/button_in_scan_reg.gif align=absmiddle border=0></a></span>
							&nbsp;&nbsp;* ��ĵ������ ����ϰ��� �� �������� <a href="javascript:page_reload()">���ΰ�ħ</a> ���ּ��� 			
							&nbsp;&nbsp;<a href="javascript:select_inss()" onMouseOver="window.status=''; return true" title="��ĺ���"><img src=/acar/images/center/button_ysbg.gif align=absmiddle border=0></a>
							<%//	if(ck_acar_id.equals("000029")){%>										
							&nbsp;&nbsp;<input type="button" class="button" value="���ڹ��� �߼�" onclick="javascript:confirmDoc('mail','9');">
							<%//	} %>
    						<%}%>
					  		&nbsp;&nbsp;<a href="javascript:view_scan()" onMouseOver="window.status=''; return true" title="��ĵ����Ʈ����"><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a>			  
					 </td>
                </tr>		
				<%if(!doc.getUser_dt1().equals("")){%>		
                <tr> 
                    <td class='title' width="13%">ó������</td>
                    <td>&nbsp;
                      <select name='ins_doc_st'  class='default' <%if(!doc.getUser_dt1().equals("")){%><!-- onchange="javascript:display_reject();" --><%}%> <%if(doc.getDoc_step().equals("3")){%>disabled<%}%> >
                        <option value="">����</option>
						<option value="Y" <%if(cng_doc.getIns_doc_st().equals("Y"))%>selected<%%>>����</option>
						<option value="N" <%if(cng_doc.getIns_doc_st().equals("N"))%>selected<%%>>�Ⱒ</option>
                      </select>
					</td>
                </tr>				
                <tr id=tr_reject > 
                    <td class='title' width="13%">ó������</td>
                    <td>&nbsp;<textarea cols="100" rows="5" name="reject_cau"><%=cng_doc.getReject_cau()%></textarea></td>
                </tr>								
				<%}else{%>			
				<input type='hidden' name='ins_doc_st' value=''>        
				<input type='hidden' name='reject_cau' value=''>        
				<%}%>
            </table>
        </td>
    </tr>	
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩�ὺ���� �ݿ� ��</span></td>
    </tr>
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=13%>����</td>
                    <td class=title width=22%>������</td>
                    <td class=title width=22%>������</td>
                    <td class=title width=43%>-</td>
                </tr>
                <tr>
                    <td class='title'>���뿩��</td>
                    <td>&nbsp;
        			          <input type='text' name='o_fee_amt' size='10' value='<%=AddUtil.parseDecimal(cng_doc.getO_fee_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value); set_d_ch_amt();'>��
					          </td>
                    <td>&nbsp;
					              <input type='text' name='n_fee_amt' size='10' value='<%=AddUtil.parseDecimal(cng_doc.getN_fee_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value); set_d_ch_amt();'>��
					              &nbsp;&nbsp;(vat����)
					          </td>
                    <td>&nbsp;���ݿ��ݾ� : 
        			          �� <input type='text' name='d_fee_amt' size='10' value='<%=AddUtil.parseDecimal(cng_doc.getD_fee_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value); set_d_ch_amt();'>���� ����
					              &nbsp;&nbsp;(vat����)
					          </td>
                </tr>
                <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                <tr>
                    <td class='title'>ȯ�޴뿩��</td>
                    <td>&nbsp;
        			          <input type='text' name='o_rtn_run_amt' size='10' value='<%=AddUtil.parseDecimal(cng_doc.getO_rtn_run_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value);'>��/1km(�ΰ�������)
					          </td>
                    <td>&nbsp;
					              <input type='text' name='n_rtn_run_amt' size='10' value='<%=AddUtil.parseDecimal(cng_doc.getN_rtn_run_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value);'>��/1km(�ΰ�������)					              
					          </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class='title'>�ʰ�����뿩��</td>
                    <td>&nbsp;
        			          <input type='text' name='o_over_run_amt' size='10' value='<%=AddUtil.parseDecimal(cng_doc.getO_over_run_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value);'>��/1km(�ΰ�������)
					          </td>
                    <td>&nbsp;
					              <input type='text' name='n_over_run_amt' size='10' value='<%=AddUtil.parseDecimal(cng_doc.getN_over_run_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value);'>��/1km(�ΰ�������)					              
					          </td>
                    <td>&nbsp;</td>
                </tr>
                <%} %>
                <tr>
                    <td class='title'>���Կɼǰ���</td>
                    <td>&nbsp;
        			          <input type='text' name='o_opt_amt' size='10' value='<%=AddUtil.parseDecimal(cng_doc.getO_opt_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value);'>��
					          </td>
                    <td>&nbsp;
					              <input type='text' name='n_opt_amt' size='10' value='<%=AddUtil.parseDecimal(cng_doc.getN_opt_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value);'>��
					              &nbsp;&nbsp;(vat����)
					          </td>
                    <td>&nbsp;</td>
                </tr>        
                <tr> 
                    <td class='title'>������</td>
                    <td>&nbsp;
        			          <input type='text' name='o_cls_per' size='10' value='<%=cng_doc.getO_cls_per()%>' class='num'>%
					          </td>
                    <td>&nbsp;
					              <input type='text' name='n_cls_per' size='10' value='<%=cng_doc.getN_cls_per()%>' class='num'>%
					          </td>
                    <td>&nbsp;</td>
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
                    <td class=title width=12%>������</td>
                    <td class=title width=15%><%=doc.getUser_nm1()%></td>
                    <td class=title width=15%><%=doc.getUser_nm2()%></td>
                    <td class=title width=15%><%=doc.getUser_nm4()%></td>
                    <td class=title width=15%><%=doc.getUser_nm5()%></td>			
                    <td class=title width=15%><%=doc.getUser_nm3()%></td>
        	    </tr>	
                <tr> 
                    <td align="center" style='height:44'><%=user_bean.getBr_nm()%></td>
                    <td align="center">
					  <!--�����-->
					  <%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%>
        			  <%if(doc.getUser_dt1().equals("") && !cng_doc.getIns_doc_st().equals("N")){
        			  		String user_id1 = doc.getUser_id1();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id1);
        					if(!cs_bean.getWork_id().equals(""))									user_id1 = cs_bean.getWork_id();
        					%>
        			  <%	if(doc.getUser_id1().equals(user_id) || user_id1.equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������",user_id)){%>
        			    <a href="javascript:doc_sanction('1')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
        			  	<input type="hidden" name="doc_user_id1" value="<%=doc.getUser_id1()%>">
					</td>
                    <td align="center">
					  <!--��������-->
					  <%if(ch_item6_yn!=true){ %>
					  	<%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%>
					  <%} %>
        			  <%if(!doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("") && !cng_doc.getIns_doc_st().equals("N")){
        			  		String user_id2 = doc.getUser_id2();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id2);
        					if(!cs_bean.getWork_id().equals(""))									user_id2 = cs_bean.getWork_id();
        					%>
        			  <%	if(user_id2.equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�ӿ�",user_id)){%>
        			  <% 		if(ch_item6_yn!=true){	//�뿩���Աݿ����� ������̸� ��������� ���� ����(20180723)%>
        			    <a href="javascript:doc_sanction('2')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <% 		}%> 
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
					</td>
                    <td align="center">
                    <%if(cng_doc.getIns_doc_st().equals("Y") && !doc.getUser_id4().equals("") ){%>
                    <!--�õ������� �����-->
                    <br>
	  				<%=c_db.getNameById(doc.getUser_id4(),"USER_PO")%><br><%=doc.getUser_dt4()%>
                  	<%if(doc.getUser_id4().equals(user_id) || nm_db.getWorkAuthUser("������",user_id)){%>
        			  <%	if(!doc.getUser_dt1().equals("") && !doc.getUser_dt2().equals("") && doc.getUser_dt4().equals("")&& !cng_doc.getIns_doc_st().equals("N")){
        			  		String user_id4 = doc.getUser_id4();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id4);
        					if(!cs_bean.getWork_id().equals(""))									user_id4 = cs_bean.getWork_id();
     					%>
        			    	<a href="javascript:doc_sanction('4')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        				<%	}%> 
        			    <br>&nbsp;
        			  <%}%>
        			  <%}%>
                    </td>
                    <td align="center">
					<%if(cng_doc.getIns_doc_st().equals("Y") && !doc.getUser_id4().equals("")){%>
                   	<!--�������ｺƼĿ�߱� �����-->
                   	<br>
	  				<%=c_db.getNameById(doc.getUser_id5(),"USER_PO")%><br><%=doc.getUser_dt5()%>
                  	<%if(doc.getUser_id5().equals(user_id) || nm_db.getWorkAuthUser("������",user_id)){%>
        			  <%	if(!doc.getUser_dt1().equals("") && !doc.getUser_dt2().equals("") && !doc.getUser_dt4().equals("") && doc.getUser_dt5().equals("") && !cng_doc.getIns_doc_st().equals("N")){
        			  		String user_id5 = doc.getUser_id5();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id5);
        					if(!cs_bean.getWork_id().equals(""))									user_id5 = cs_bean.getWork_id();
     					%>
        			    	<a href="javascript:doc_sanction('5')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        				<%	}%> 
        			    <br>&nbsp;
        			  <%}%>
        			  <%}%>
                    </td>
                    <td align="center">
                    <%if(cng_doc.getIns_doc_st().equals("Y")){%>
			 		 <!--�����ٴ����-->
			 		 <br>
			  		<%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%>
                    <%if(doc.getUser_id3().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("���ݰ�꼭�����",user_id) || nm_db.getWorkAuthUser("����������",user_id)){%>
        			  <%	if(( !doc.getUser_dt1().equals("") && !doc.getUser_dt2().equals("") && doc.getUser_dt3().equals("") &&  !cng_doc.getIns_doc_st().equals("N") ) ||  (ch_item6_yn==true && doc.getUser_dt3().equals(""))){
        			  		String user_id3 = doc.getUser_id3();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id3);
        					if(!cs_bean.getWork_id().equals(""))									user_id3 = cs_bean.getWork_id();
        					if(doc.getUser_id4().equals("") || (!doc.getUser_id5().equals("") && !doc.getUser_dt5().equals("")) ){  
        			  %>        			  
        			        <a href="javascript:doc_sanction('3')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>        			          			    
        			  <%	}%>
        			  <%	}%>
        			  <br>&nbsp;
        			<%}%>
        			<%}%>
        			  
                    </td>			
        	    </tr>	
    		</table>
	    </td>
	</tr>  	 
	<%if(!mode.equals("view")){%> 		
		
	<%		if( (doc.getUser_id1().equals(user_id) && doc.getUser_dt1().equals("")) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("���ݰ�꼭�����",user_id) || nm_db.getWorkAuthUser("����������",user_id)){%>
	<tr>
	    <td class=h></td>
	</tr>		
    <tr>
		<td align="right">
		  <a href="javascript:doc_sanction('u');"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
		  <%	if(!doc.getDoc_step().equals("3") || nm_db.getWorkAuthUser("������",user_id)){%> 	
		  &nbsp;
		  <a href="javascript:doc_sanction('d');"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>
		  <%	}%>	
		</td>
	</tr>	
	<%		}%>
	<%	if(doc.getDoc_step().equals("3") && !cng_doc.getIns_doc_st().equals("N")){
			if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("���ݰ�꼭�����",user_id) || nm_db.getWorkAuthUser("����������",user_id)){%>
	<tr>
	    <td class=h></td>
	</tr>		
    <tr>
		<td align="right">* �޴��̵� : <a href="javascript:move_fee_scd()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_sch.gif align=absmiddle border="0"></a></td>
	</tr>	
	<%		}
		}%>
	<%}%>
<input type='hidden' name="scan_chk_yn"		value="<%=scan_chk_yn%>">      			
</table>
</form>
<form name="printForm" method="post">
	<input type="hidden" name="est_nm" value="<%=client.getFirm_nm()%>">	
	<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">			
	<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
	<input type="hidden" name="client_id" value="<%=base.getClient_id()%>">
	<input type="hidden" name="client_st" value="<%=client.getClient_st()%>">		
	<input type="hidden" name="car_mng_id" value="<%=base.getCar_mng_id()%>">
	<input type="hidden" name="rent_st" value="<%=rent_st%>">
	<input type="hidden" name="user_id" value="<%=ck_acar_id%>">						
	<input type="hidden" name="ch_cd" value="<%=ins_doc_no%>">
	<input type="hidden" name="user_type" value="">
	<input type="hidden" name="type" value="">
	<input type="hidden" name="view_amt" value="">	
	<input type="hidden" name="pay_way" value="">
	<input type="hidden" name="view_good" value="">
	<input type="hidden" name="view_tel" value="">
	<input type="hidden" name="view_addr" value="">
	<input type="hidden" name="var1" value="<%=ck_acar_id%>">
	<input type="hidden" name="var2" value="<%=rent_l_cd%>">
	<input type="hidden" name="var3" value="<%=base.getCar_mng_id()%>">
	<input type="hidden" name="var4" value="<%=rent_mng_id%>">
	<input type="hidden" name="var5" value="<%=base.getClient_id()%>">
	<input type="hidden" name="var6" value="<%=rent_st%>">
	<input type="hidden" name="mail_yn" value="">
	<input type="hidden" name="doc_url" value="">
</form>
<script>
	
	function confirmDoc(st, type){
		
		var frmData = document.printForm;
		
		var url = "about:blank";
		var width = 420;
		var height = 500;
		if(st == 'doc'){
			width = 900;
			height = 800;
		}
		window.open(url, 'CONFIRM_TEMPLATE', "left=50, top=50, width="+width+", height="+height+", scrollbars=yes");
		
		frmData.type.value = type;
						
		var doc_url = "/fms2/con_fee/fee_doc_print_n.jsp";
		
		frmData.doc_url.value = doc_url;
		
		if(st == 'doc'){
			frmData.action = doc_url;			
		}else{
			doc_url = "/edoc_fms/acar/e_doc/confirm_template_link"+type+".jsp";
			frmData.doc_url.value = doc_url;
			frmData.action = "/fms2/lc_rent/select_mail_input_e_doc.jsp";
		}
		
		frmData.target = "CONFIRM_TEMPLATE";
		frmData.submit();

	}	

</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
