<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.user_mng.*, acar.res_search.*, tax.*, acar.insur.*, acar.doc_settle.*, acar.car_sche.*"%>
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
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st 		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String fee_start_dt 	= "";
	
	String m_id 		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String c_id 		= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String ins_st 		= request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	
	String doc_no 		= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String ins_doc_no   	= request.getParameter("ins_doc_no")==null?"":request.getParameter("ins_doc_no");
	String mode   		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	//�α���ID&������ID&����
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "15", "01", "15");
	
	
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
	
	//���躯�渮��Ʈ
	Vector ins_cha = ins_db.getInsChangeDocList(ins_doc_no);
	int ins_cha_size = ins_cha.size();
	
	
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
	
	//��������
	ins = ins_db.getInsCase(c_id, ins_st);
	
	
	//�����
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	
	
	int total_amt = 0;	
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "LC_RENT";
	String content_seq  = "";

	Vector attach_vt = new Vector();
	int attach_vt_size = 0;	
	
	

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
	//����Ʈ
	function list(){
		var fm = document.form1;		
		if(fm.mode.value == 'doc_settle'){
			fm.action = '/fms2/doc_settle/doc_settle_frame.jsp';
		}else{
			fm.action = 'ins_doc_frame.jsp';
		}			
		fm.target = 'd_content';
		fm.submit();
	}	

	
	//�� ����
	function view_client()
	{
		var fm = document.form1;
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id=<%=base.getClient_id()%>", "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
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


	
	function set_t_ch_amt(){
		var fm = document.form1;
		var t_amt = 0;

		<%for(int i = 0 ; i < ins_cha_size ; i++){%>
		<%	if(ins_cha_size > 1){%>
				t_amt = t_amt + toInt(parseDigit(fm.ch_amt[<%=i%>].value))
		<%	}else{%>
				t_amt = t_amt + toInt(parseDigit(fm.ch_amt.value))
		<%	}%>
		<%}%>
		fm.t_ch_amt.value = parseDecimal(t_amt);

	}
	
	function set_n_ch_amt(){
		var fm = document.form1;
		fm.n_fee_amt.value 	= parseDecimal(toInt(parseDigit(fm.o_fee_amt.value)) + toInt(parseDigit(fm.d_fee_amt.value)));
	}	
				
	//����� �հ� ����
	function set_tot(){
		var fm = document.form1;
		//å��
		var tot_amt1 = fm.rins_pcp_amt.value;	
		//����
		var tot_amt2 = parseDecimal(toInt(parseDigit(fm.vins_pcp_amt.value))+
											toInt(parseDigit(fm.vins_gcp_amt.value))+
											toInt(parseDigit(fm.vins_bacdt_amt.value))+
											toInt(parseDigit(fm.vins_canoisr_amt.value))+
											toInt(parseDigit(fm.vins_share_extra_amt.value))+
											toInt(parseDigit(fm.vins_cacdt_cm_amt.value))+
											toInt(parseDigit(fm.vins_spe_amt.value)));
		//��
		fm.tot_amt12.value = parseDecimal(toInt(parseDigit(tot_amt1)) + toInt(parseDigit(tot_amt2)));		
	}	
				
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;

		
		<%if(!doc.getUser_dt2().equals("") && !base.getCar_st().equals("2")){%>
		if(doc_bit == '3'){
			//if(fm.t_ch_amt.value == '' || fm.t_ch_amt.value == '0')	{	alert('��¡����Ḧ �Է��Ͻʽÿ�.');			return;	}
			//if(fm.d_fee_amt.value == '' || fm.d_fee_amt.value == '0')	{	alert('�뿩�ὺ���� ���ݿ��ݾ׸� �Է��Ͻʽÿ�.');		return;	}
			//if(fm.n_fee_amt.value == '' || fm.n_fee_amt.value == '0')	{	alert('������ �뿩��ݾ��� �Է��Ͻʽÿ�.');			return;	}			
		}
		<%}%>
		
		if(doc_bit == '3'){
			if(fm.ins_doc_st.value == ''){ alert('ó�������� �����Ͻʽÿ�.'); return; }	
			if(fm.i_inschange_cng_yn.checked==true){fm.i_inschange_cng_yn_2.value='Y'};
			if(fm.i_inschange_cng_yn.checked==false){fm.i_inschange_cng_yn_2.value='N'};
			if(fm.i_insamt_cng_yn.checked==true){fm.i_insamt_cng_yn_2.value='Y'};
			if(fm.i_insamt_cng_yn.checked==false){fm.i_insamt_cng_yn_2.value='N'};
			
		
		}		
		
		var ment = '�����Ͻðڽ��ϱ�?';
		
		if(doc_bit == 'u') ment = '�����Ͻðڽ��ϱ�?';
		if(doc_bit == 'd') ment = '�����Ͻðڽ��ϱ�?';		
		if(doc_bit == 'd_req') ment = '������û�Ͻðڽ��ϱ�?';
		
		if(confirm(ment)){	
			fm.action='ins_doc_sanction2.jsp';		
			fm.target='i_no';
//			fm.target='_blank';
			fm.submit();
		}									
	}
	
	
	function page_reload(){
		var fm = document.form1;
		fm.action='ins_doc_u2.jsp';		
		fm.target='d_content';
		fm.submit();		
	}
	
	//�Ⱒ�ϴ� �������̱�
	function display_reject(){
		var fm = document.form1;
		
		if(fm.ins_doc_st.value =='N' || fm.ins_doc_st.value ==''){ //�Ⱒ
			tr_reject.style.display	= '';
			
			tr_cng0.style.display	= 'none';
			tr_cng1.style.display	= 'none';
			tr_cng2.style.display	= 'none';
			tr_cng3.style.display	= 'none';
			tr_cng4.style.display	= 'none';
			tr_cng5.style.display	= 'none';
			tr_cng6.style.display	= 'none';
			<%if(base.getCar_st().equals("1") || base.getCar_st().equals("3") || base.getCar_st().equals("5")){%>
			tr_cng7.style.display	= 'none';
			tr_cng8.style.display	= 'none';
			tr_cng9.style.display	= 'none';
			tr_cng10.style.display	= 'none';
			<%}%>
			
			
		}else if(fm.ins_doc_st.value =='Y'){ //����
			tr_reject.style.display	= 'none';
			
			tr_cng0.style.display	= '';
			tr_cng1.style.display	= '';
			tr_cng2.style.display	= '';
			tr_cng3.style.display	= '';
			tr_cng4.style.display	= '';
			tr_cng5.style.display	= '';
			tr_cng6.style.display	= '';
			<%if(base.getCar_st().equals("1") || base.getCar_st().equals("3") || base.getCar_st().equals("5")){%>
			tr_cng7.style.display	= '';
			tr_cng8.style.display	= '';
			tr_cng9.style.display	= '';
			tr_cng10.style.display	= '';
			<%}%>
			
			
		}
	}	
	
	//�����û��
	function select_inss(){
		var fm = document.form1;
		window.open('about:blank', "INSDOC_PRINT", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "INSDOC_PRINT";
		fm.action = "ins_doc_print.jsp";
		fm.submit();	
	}			
	
	//�����̰���ϱ�
	function age_search()
	{
		var fm = document.form1;
		
		window.open("about:blank",'age_search','scrollbars=yes,status=no,resizable=yes,width=360,height=250,left=370,top=200');		
		fm.action = "/fms2/lc_rent/search_age.jsp?mode=EM";
		fm.target = "age_search";
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
<form action='ins_doc_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1'	 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="m_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="rent_st" 		value="<%=cng_doc.getRent_st()%>">  
  <input type='hidden' name="car_mng_id" 	value="<%=c_id%>">
  <input type='hidden' name="ins_st" 		value="<%=ins_st%>">
  <input type='hidden' name="doc_no"		value="<%=doc_no%>">  
  <input type='hidden' name="ins_doc_no"	value="<%=ins_doc_no%>">    
  <input type='hidden' name="firm_nm"	 	value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="car_no"	 	value="<%=cr_bean.getCar_no()%>">  
  <input type='hidden' name="mode"		value="<%=mode%>">      
  <input type='hidden' name="from_page" 	value="/fms2/insure/ins_doc_u2.jsp">             
  <input type='hidden' name='doc_bit' 		value=''>     
  <input type='hidden' name='ch_cd' 		value='<%=cng_doc.getIns_doc_no()%>'>       
  <input type='hidden' name='car_st' 		value='<%=base.getCar_st()%>'>       
  
       
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>���ڹ��� > ������� > <span class=style5>���躯�湮��</span></span></td>
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
                    <td class=title width=10%>����ȣ</td>
                    <td width=25%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>�뵵/����</td>
                    <td width=15%>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>����<%}else if(car_st.equals("5")){%>�����뿩<%}%>
				  &nbsp;<%String rent_way = ext_fee.getRent_way();%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}%>
		    </td>
                    <td class=title width=10%>���������</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                </tr>
                <tr>
                    <td class=title>��ȣ</td>
                    <td>&nbsp;<a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=client.getFirm_nm()%> <%=site.getR_site()%></a></td>
                    <td class=title>������ȣ</td>
                    <td>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=cr_bean.getCar_no()%></a></td>
                    <td class=title>����</td>
                    <td>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;
        		<font color="#999999">(�����ڵ�:<%=cm_bean.getJg_code()%>)</font>
        	    </td>
                </tr>
                <tr> 
                    <td class=title width=10%>����Ⱓ</td>
                    <td width=25%>&nbsp;<%=AddUtil.ChangeDate2(ins.getIns_start_dt())%>~<%=AddUtil.ChangeDate2(ins.getIns_exp_dt())%></td>									
                    <td class=title width=10%>����ȸ��</td>
                    <td width=15%>&nbsp;<%=c_db.getNameById(ins.getIns_com_id(), "INS_COM")%></td>
                    <td class=title width=10%>��������</td>
                    <td>&nbsp; 
                        <%if(ins.getCar_use().equals("1")){%>������<%}%>
                        <%if(ins.getCar_use().equals("2")){%>������<%}%>
        		<%if(ins.getCar_use().equals("3")){%>���ο�<%}%>
                   &nbsp;<a href="javascript:age_search();"><img src=/acar/images/center/button_in_mnigs.gif border=0 align=absmiddle></a> </td>										
                </tr>				
            </table>
	    </td>
    </tr>
    <tr>
	<td class=h></td>
    </tr>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���躯��</span> <input type="checkbox" name="i_inschange_cng_yn" value="Y" checked> ���躯����� �ݿ�</td>
        <input type="hidden" name="i_inschange_cng_yn_2" value="Y">
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=3% rowspan="2">����</td>
                    <td class=title width=25% rowspan="2">�����׸�</td>
                    <td class=title colspan="2">�������</td>
                    <td class=title width=12% rowspan="2">��¡�����</td>                    
                </tr>
                <tr> 
                    <td class=title width=30%>������</td>
                    <td class=title width=30%>������</td>
                </tr>
                <%for(int i = 0 ; i < ins_cha_size ; i++){
			InsurChangeBean cha = (InsurChangeBean)ins_cha.elementAt(i);										
		%>
                <tr align="center"> 
                    <td><%=i+1%> 
                        <input type='hidden' name='ch_tm' value='<%=cha.getCh_tm()%>'>
                    </td>
                    <td>
        	        <select name="ch_item" disabled>
            	            <option value="10" <%if(cha.getCh_item().equals("10")){%>selected<%}%>>����2���Աݾ�</option>
            	            <option value="1" <%if(cha.getCh_item().equals("1")){%>selected<%}%>>�빰���Աݾ�</option>
        	            <option value="2" <%if(cha.getCh_item().equals("2")){%>selected<%}%>>�ڱ��ü����Աݾ�(���/���)</option>
			    <option value="12" <%if(cha.getCh_item().equals("12")){%>selected<%}%>>�ڱ��ü����Աݾ�(�λ�)</option>
        	            <option value="7" <%if(cha.getCh_item().equals("7")){%>selected<%}%>>�빰+�ڱ��ü����Աݾ�</option>			  
                	    <option value="3" <%if(cha.getCh_item().equals("3")){%>selected<%}%>>������������Ư��</option>
                	    <option value="4" <%if(cha.getCh_item().equals("4")){%>selected<%}%>>�ڱ��������ذ��Աݾ�</option>			  
                	    <option value="9" <%if(cha.getCh_item().equals("9")){%>selected<%}%>>�ڱ����������ڱ�δ��</option>			  			  			  
            	            <option value="5" <%if(cha.getCh_item().equals("5")){%>selected<%}%>>���ɺ���</option>		  
                	    <option value="6" <%if(cha.getCh_item().equals("6")){%>selected<%}%>>�ִ�īƯ��</option>			  			  
                	    <option value="8" <%if(cha.getCh_item().equals("8")){%>selected<%}%>>��������</option>			  			  			  
                	    <option value="11" <%if(cha.getCh_item().equals("11")){%>selected<%}%>>������ü</option>			  
                	    <option value="14" <%if(cha.getCh_item().equals("14")){%>selected<%}%>>��������������Ư��</option>
                	    <option value="17" <%if(cha.getCh_item().equals("17")){%>selected<%}%>>���ڽ�</option>
                	    <option value="15" <%if(cha.getCh_item().equals("15")){%>selected<%}%>>�Ǻ����ں���</option>
                	    <option value="16" <%if(cha.getCh_item().equals("16")){%>selected<%}%>>���Ǻ����� ���谻��</option>
                	    <option value="13" <%if(cha.getCh_item().equals("13")){%>selected<%}%>>��Ÿ</option>
        	        </select>			
                    </td>
                    <td>
                        <input type='text' size='40' name='ch_before' class='text' value='<%=cha.getCh_before()%>'>
                    </td>					
                    <td>
                        <input type='text' size='40' name='ch_after' class='text' value='<%=cha.getCh_after()%>'>
                    </td>
                    <td> 
                        <input type='text' size='10' name='ch_amt' class='num' value='<%=Util.parseDecimal(cha.getCh_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_t_ch_amt();'>
                        ��
                    </td>
                </tr>		  
                <%	total_amt = total_amt + cha.getCh_amt();
		  }
		%>		
                <tr align="center"> 
                    <td class=title>&nbsp;</td>
                    <td class=title>��</td>
                    <td class=title>&nbsp;</td>
                    <td class=title>&nbsp;</td>
                    <td class=title><input type='text' size='10' name='t_ch_amt' class='whitenum' value='<%=Util.parseDecimal(total_amt)%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��
                    </td>                
                </tr>						
            </table>
        </td>
    </tr>	
    <tr>
        <td align=right>* ���ʵ���� : <%=AddUtil.ChangeDate2(cng_doc.getReg_dt())%></td>
    </tr>
    <tr>
	<td class=h></td>
    </tr>	
    <tr id=tr_cng0 style="display:'none'"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ������� �㺸����� �ݿ�</span><input type="checkbox" name="i_carinschange_cng_yn" value="Y" checked> �ڵ������� �㺸����� �ݿ�</td>
    </tr>
    <tr id=tr_cng1 style="display:'none'">
        <td class=line2></td>
    </tr>
    <%	int i_cnt = 0; %>	     	    	     
    <tr id=tr_cng2 style="display:'none'"> 
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=3% rowspan="2">����</td>
                    <td class=title width=3% rowspan="2">����</td>
                    <td class=title width=22% rowspan="2">�����׸�</td>
                    <td class=title colspan="2">��������</td>                    
                </tr>
                <tr> 
                    <td class=title width=30%>������</td>
                    <td class=title width=30%>������</td>
                </tr>
                <%
                	for(int i = 0 ; i < ins_cha_size ; i++){
				InsurChangeBean cha = (InsurChangeBean)ins_cha.elementAt(i);	
		%>	
		<%		if(cha.getCh_item().equals("5")){
					i_cnt++;
		%>
                <tr align="center"> 
                    <td><%=i_cnt%></td>
                    <td align='center'><input type="checkbox" name="i_ch_cd" value="<%=i_cnt-1%>" checked></td>
                    <td>���ɺ���<input type='hidden' name='i_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        <select name='v_age_scp' disabled>
                            <option value='1' <%if(ins.getAge_scp().equals("1")){%>selected<%}%>>21���̻�</option>
                            <option value='4' <%if(ins.getAge_scp().equals("4")){%>selected<%}%>>24���̻�</option>
                            <option value='2' <%if(ins.getAge_scp().equals("2")){%>selected<%}%>>26���̻�</option>
                            <option value='3' <%if(ins.getAge_scp().equals("3")){%>selected<%}%>>������</option>                            
                            <option value='5' <%if(ins.getAge_scp().equals("5")){%>selected<%}%>>30���̻�</option>				
                            <option value='6' <%if(ins.getAge_scp().equals("6")){%>selected<%}%>>35���̻�</option>				
                            <option value='7' <%if(ins.getAge_scp().equals("7")){%>selected<%}%>>43���̻�</option>
			    <option value='8' <%if(ins.getAge_scp().equals("8")){%>selected<%}%>>48���̻�</option>												
                        </select>
                    </td>					
                    <td>
                        <select name='age_scp'>
                            <option value='1' <%if(cha.getCh_after().equals("21���̻�")){%>selected<%}%>>21���̻�</option>
                            <option value='4' <%if(cha.getCh_after().equals("24���̻�")){%>selected<%}%>>24���̻�</option>
                            <option value='2' <%if(cha.getCh_after().equals("26���̻�")){%>selected<%}%>>26���̻�</option>
                            <option value='3' <%if(cha.getCh_after().equals("������")){  %>selected<%}%>>������</option>                            
                            <option value='5' <%if(cha.getCh_after().equals("30���̻�")){%>selected<%}%>>30���̻�</option>				
                            <option value='6' <%if(cha.getCh_after().equals("35���̻�")){%>selected<%}%>>35���̻�</option>				
                            <option value='7' <%if(cha.getCh_after().equals("43���̻�")){%>selected<%}%>>43���̻�</option>
			    <option value='8' <%if(cha.getCh_after().equals("48���̻�")){%>selected<%}%>>48���̻�</option>												
                        </select>                                            
                    </td>
                </tr>		  		
		<%		}%>
		<%		if(cha.getCh_item().equals("1")){
					i_cnt++;
		%>
                <tr align="center"> 
                    <td><%=i_cnt%></td>
                    <td align='center'><input type="checkbox" name="i_ch_cd" value="<%=i_cnt-1%>" checked></td>
                    <td>�빰���Աݾ�<input type='hidden' name='i_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        <select name='v_vins_gcp_kd' disabled>
                            <option value='6' <%if(ins.getVins_gcp_kd().equals("6")){%>selected<%}%>>5���</option>
			    <option value='8' <%if(ins.getVins_gcp_kd().equals("8")){%>selected<%}%>>3���</option>
			    <option value='7' <%if(ins.getVins_gcp_kd().equals("7")){%>selected<%}%>>2���</option>
                            <option value='3' <%if(ins.getVins_gcp_kd().equals("3")){%>selected<%}%>>1���</option>						
                            <option value='4' <%if(ins.getVins_gcp_kd().equals("4")){%>selected<%}%>>5000����</option>
                            <option value='1' <%if(ins.getVins_gcp_kd().equals("1")){%>selected<%}%>>3000����</option>
                            <option value='2' <%if(ins.getVins_gcp_kd().equals("2")){%>selected<%}%>>1500����</option>
                            <option value='5' <%if(ins.getVins_gcp_kd().equals("5")){%>selected<%}%>>1000����</option>				
                        </select>
                    </td>					
                    <td>
                        <select name='vins_gcp_kd'>
                            <option value='6' <%if(cha.getCh_after().equals("5���")){%>selected<%}%>>5���</option>
			    <option value='8' <%if(cha.getCh_after().equals("3���")){%>selected<%}%>>3���</option>
			    <option value='7' <%if(cha.getCh_after().equals("2���")){%>selected<%}%>>2���</option>
                            <option value='3' <%if(cha.getCh_after().equals("1���")){%>selected<%}%>>1���</option>						
                            <option value='4' <%if(cha.getCh_after().equals("5000����")){%>selected<%}%>>5000����</option>
                            <option value='1' <%if(cha.getCh_after().equals("3000����")){%>selected<%}%>>3000����</option>
                            <option value='2' <%if(cha.getCh_after().equals("1500����")){%>selected<%}%>>1500����</option>
                            <option value='5' <%if(cha.getCh_after().equals("1000����")){%>selected<%}%>>1000����</option>				
                        </select>                    
                    </td>
                </tr>		  		
		<%		}%>					
		<%		if(cha.getCh_item().equals("2")){
					i_cnt++;
		%>
                <tr align="center"> 
                    <td><%=i_cnt%></td>
                    <td align='center'><input type="checkbox" name="i_ch_cd" value="<%=i_cnt-1%>" checked></td>
                    <td>�ڱ��ü����Աݾ�(���/���)<input type='hidden' name='i_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        <select name='v_vins_bacdt_kd' disabled>
                            <option value="1" <%if(ins.getVins_bacdt_kd().equals("1")){%>selected<%}%>>3���</option>
                            <option value="2" <%if(ins.getVins_bacdt_kd().equals("2")){%>selected<%}%>>1��5õ����</option>
                            <option value="6" <%if(ins.getVins_bacdt_kd().equals("6")){%>selected<%}%>>1���</option>
                            <option value="5" <%if(ins.getVins_bacdt_kd().equals("5")){%>selected<%}%>>5000����</option>
                            <option value="3" <%if(ins.getVins_bacdt_kd().equals("3")){%>selected<%}%>>3000����</option>
                            <option value="4" <%if(ins.getVins_bacdt_kd().equals("4")){%>selected<%}%>>1500����</option>
                        </select>
                    </td>					
                    <td>
                        <select name='vins_bacdt_kd'>
                            <option value="1" <%if(cha.getCh_after().equals("3���")){%>selected<%}%>>3���</option>
                            <option value="2" <%if(cha.getCh_after().equals("1��5õ����")){%>selected<%}%>>1��5õ����</option>
                            <option value="6" <%if(cha.getCh_after().equals("1���")){%>selected<%}%>>1���</option>
                            <option value="5" <%if(cha.getCh_after().equals("5000����")){%>selected<%}%>>5000����</option>
                            <option value="3" <%if(cha.getCh_after().equals("3000����")){%>selected<%}%>>3000����</option>
                            <option value="4" <%if(cha.getCh_after().equals("1500����")){%>selected<%}%>>1500����</option>
                        </select>                    
                    </td>
                </tr>		  		
		<%		}%>		
		<%		if(cha.getCh_item().equals("12")){
					i_cnt++;
		%>
                <tr align="center"> 
                    <td><%=i_cnt%></td>
                    <td align='center'><input type="checkbox" name="i_ch_cd" value="<%=i_cnt-1%>" checked></td>
                    <td>�ڱ��ü����Աݾ�(�λ�)<input type='hidden' name='i_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        <select name='v_vins_bacdt_kc2' disabled>
                            <option value="1" <%if(ins.getVins_bacdt_kc2().equals("1")){%>selected<%}%>>3���</option>
                            <option value="2" <%if(ins.getVins_bacdt_kc2().equals("2")){%>selected<%}%>>1��5õ����</option>
                            <option value="6" <%if(ins.getVins_bacdt_kc2().equals("6")){%>selected<%}%>>1���</option>
                            <option value="5" <%if(ins.getVins_bacdt_kc2().equals("5")){%>selected<%}%>>5000����</option>
                            <option value="3" <%if(ins.getVins_bacdt_kc2().equals("3")){%>selected<%}%>>3000����</option>
                            <option value="4" <%if(ins.getVins_bacdt_kc2().equals("4")){%>selected<%}%>>1500����</option>
                        </select>
                    </td>					
                    <td>
                        <select name='vins_bacdt_kc2'>
                            <option value="1" <%if(cha.getCh_after().equals("3���")){%>selected<%}%>>3���</option>
                            <option value="2" <%if(cha.getCh_after().equals("1��5õ����")){%>selected<%}%>>1��5õ����</option>
                            <option value="6" <%if(cha.getCh_after().equals("1���")){%>selected<%}%>>1���</option>
                            <option value="5" <%if(cha.getCh_after().equals("5000����")){%>selected<%}%>>5000����</option>
                            <option value="3" <%if(cha.getCh_after().equals("3000����")){%>selected<%}%>>3000����</option>
                            <option value="4" <%if(cha.getCh_after().equals("1500����")){%>selected<%}%>>1500����</option>
                        </select>                    
                    </td>
                </tr>		  		
		<%		}%>	
		<%		if(cha.getCh_item().equals("4")){
					i_cnt++;
		%>
                <tr align="center"> 
                    <td><%=i_cnt%></td>
                    <td align='center'><input type="checkbox" name="i_ch_cd" value="<%=i_cnt-1%>" checked></td>
                    <td>�ڱ��������ذ��Աݾ�<input type='hidden' name='i_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        <input type='text' size='10' name='v_vins_cacdt_cm_amt2' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_cm_amt()))%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'> ��
                    </td>					
                    <td>
                        <input type='text' size='10' name='vins_cacdt_cm_amt2' value='<%=Util.parseDecimal(String.valueOf(cha.getCh_after()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> ��
                    </td>
                </tr>		  		
		<%		}%>	
		<%		if(cha.getCh_item().equals("9")){
					i_cnt++;
		%>
                <tr align="center"> 
                    <td><%=i_cnt%></td>
                    <td align='center'><input type="checkbox" name="i_ch_cd" value="<%=i_cnt-1%>" checked></td>
                    <td>�ڱ����������ڱ�δ��<input type='hidden' name='i_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        ���������������
		        <select name='v_vins_cacdt_mebase_amt' disabled>
			    <option value=""    <%if(ins.getVins_cacdt_mebase_amt()==0  ){%>selected<%}%>>����</option>
			    <option value="50"  <%if(ins.getVins_cacdt_mebase_amt()==50 ){%>selected<%}%>>50����</option>
			    <option value="100" <%if(ins.getVins_cacdt_mebase_amt()==100){%>selected<%}%>>100����</option>
			    <option value="150" <%if(ins.getVins_cacdt_mebase_amt()==150){%>selected<%}%>>150����</option>
			    <option value="200" <%if(ins.getVins_cacdt_mebase_amt()==200){%>selected<%}%>>200����</option>
			</select>
			<br>
			&nbsp;
			�ִ��ڱ�δ�� &nbsp;&nbsp; 
                        <input type='text' size='6' name='v_vins_cacdt_me_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_me_amt()))%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'> 
                        ���� 
			<br>
			&nbsp;
			�ּ��ڱ�δ�� &nbsp;&nbsp;  
                        <select name='v_vins_cacdt_memin_amt' disabled>
                            <option value=""   <%if(ins.getVins_cacdt_memin_amt()==0 ){%>selected<%}%>>����</option>
                            <option value="5"  <%if(ins.getVins_cacdt_memin_amt()==5 ){%>selected<%}%>>5����</option>
                            <option value="10" <%if(ins.getVins_cacdt_memin_amt()==10){%>selected<%}%>>10����</option>
                            <option value="15" <%if(ins.getVins_cacdt_memin_amt()==15){%>selected<%}%>>15����</option>
                            <option value="20" <%if(ins.getVins_cacdt_memin_amt()==20){%>selected<%}%>>20����</option>
                        </select>                    			
                    </td>					
                    <td>
                        <%
                        	int s=0; 
                        	String app_value[] = new String[3];	
	
				if(cha.getCh_after().length() > 0){
					StringTokenizer st = new StringTokenizer(cha.getCh_after(),"/");				
					while(st.hasMoreTokens()){
						app_value[s] = st.nextToken();
						s++;
					}		
				}	
                        %>                        
                        ���������������
		        <select name='vins_cacdt_mebase_amt' >
			    <option value=""    <%if(app_value[0].equals("����")){%>selected<%}%>>����</option>
			    <option value="50"  <%if(app_value[0].equals("50����")){%>selected<%}%>>50����</option>
			    <option value="100" <%if(app_value[0].equals("100����")){%>selected<%}%>>100����</option>
			    <option value="150" <%if(app_value[0].equals("150����")){%>selected<%}%>>150����</option>
			    <option value="200" <%if(app_value[0].equals("200����")){%>selected<%}%>>200����</option>
			</select>
			<br>
			&nbsp;
			�ִ��ڱ�δ�� &nbsp;&nbsp; 
                        <input type='text' size='6' name='vins_cacdt_me_amt' value='<%=Util.parseDecimal(app_value[1])%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
                        ���� 
			<br>
			&nbsp;
			�ּ��ڱ�δ�� &nbsp;&nbsp;  
                        <select name='vins_cacdt_memin_amt' >
                            <option value=""   <%if(app_value[2].equals("����")){%>selected<%}%>>����</option>
                            <option value="5"  <%if(app_value[2].equals("5����")){%>selected<%}%>>5����</option>
                            <option value="10" <%if(app_value[2].equals("10����")){%>selected<%}%>>10����</option>
                            <option value="15" <%if(app_value[2].equals("15����")){%>selected<%}%>>15����</option>
                            <option value="20" <%if(app_value[2].equals("20����")){%>selected<%}%>>20����</option>
                        </select>                                                          
                    </td>
                </tr>		  		
		<%		}%>	
		<%		if(cha.getCh_item().equals("14")){
					i_cnt++;
		%>
                <tr align="center"> 
                    <td><%=i_cnt%></td>
                    <td align='center'><input type="checkbox" name="i_ch_cd" value="<%=i_cnt-1%>" checked></td>
                    <td>��������������Ư��<input type='hidden' name='i_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                      <select name='v_com_emp_yn2' disabled>
                        <option value="N" <%if(ins.getCom_emp_yn().equals("N")){%>selected<%}%>>�̰���</option>
                        <option value="Y" <%if(ins.getCom_emp_yn().equals("Y")){%>selected<%}%>>����</option>
                      </select>                                                                  
                    </td>					
                    <td>
                      <select name='com_emp_yn2'>
                        <option value="N" <%if(cha.getCh_after().equals("�̰���")){%>selected<%}%>>�̰���</option>
                        <option value="Y" <%if(cha.getCh_after().equals("����")){%>selected<%}%>>����</option>
                      </select>                                                                  
                    </td>
                </tr>		  		
		<%		}%>		
		<%		if(cha.getCh_item().equals("17")){
					i_cnt++;
		%>
                <tr align="center"> 
                    <td><%=i_cnt%></td>
                    <td align='center'><input type="checkbox" name="i_ch_cd" value="<%=i_cnt-1%>" checked></td>
                    <td>���ڽ�<input type='hidden' name='i_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                      <select name='v_blackbox_yn' disabled>
                        <option value="N" <%if(ins.getBlackbox_yn().equals("N")){%>selected<%}%>>����</option>
                        <option value="Y" <%if(ins.getBlackbox_yn().equals("Y")){%>selected<%}%>>�ִ�</option>
                      </select>                                                                  
                    </td>					
                    <td>
                      <select name='blackbox_yn'>
                        <option value="N" <%if(cha.getCh_after().equals("�̰���")){%>selected<%}%>>����</option>
                        <option value="Y" <%if(cha.getCh_after().equals("����")){%>selected<%}%>>�ִ�</option>
                      </select>                                                                  
                    </td>
                </tr>		  		
		<%		}%>																			
		<%		if(cha.getCh_item().equals("15")){
					i_cnt++;
		%>
                <tr align="center"> 
                    <td><%=i_cnt%></td>
                    <td align='center'><input type="checkbox" name="i_ch_cd" value="<%=i_cnt-1%>" checked></td>
                    <td>�Ǻ����ں���<input type='hidden' name='i_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        <input type='text' name='v_con_f_nm' value='<%=ins.getCon_f_nm()%>' size='20' class='whitetext'>
                    </td>					
                    <td>
                        <input type='text' name='con_f_nm' value='<%=cha.getCh_after()%>' size='20' class='text'>
                    </td>
                </tr>		  		
		<%		}%>

                <% 	}%>		
            </table>
        </td>
    </tr>
    <input type='hidden' name='i_cnt' 		value='<%=i_cnt%>'>       
    <tr id=tr_cng3 style="display:'none'">
	<td class=h></td>
    </tr>	
    <tr id=tr_cng4 style="display:'none'"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ������� �����</span> <input type="checkbox" name="i_insamt_cng_yn" value="Y" checked> ����� ����� �ݿ�</td>
        <input type="hidden" name="i_insamt_cng_yn_2" value="Y">
    </tr>
    <tr id=tr_cng5 style="display:'none'">
        <td class=line2></td>
    </tr>    
    <tr id=tr_cng6 style="display:'none'">
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>����</td>
                    <td class=title width=10%>���ι��</td>
                    <td class=title width=10%>���ι��</td>
                    <td class=title width=10%>�빰���</td>
                    <td class=title width=10%>�ڱ��ü���</td>
                    <td class=title width=10%>������������</td>
                    <td class=title width=10%>�д����������</td>
                    <td class=title width=10%>�ڱ���������</td>
                    <td class=title width=10%>Ư��</td>
                    <td class=title width=10%>�հ�</td>
        	</tr>	
                <tr> 
                    <td class=title>�����</td>
                    <td align="center"><input type='text' size='10' name='rins_pcp_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getRins_pcp_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'></td>
                    <td align="center"><input type='text' size='10' name='vins_pcp_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_pcp_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'></td>
                    <td align="center"><input type='text' size='10' name='vins_gcp_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_gcp_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'></td>
                    <td align="center"><input type='text' size='10' name='vins_bacdt_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_bacdt_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'></td>
                    <td align="center"><input type='text' size='10' name='vins_canoisr_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_canoisr_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'></td>
                    <td align="center"><input type='text' size='10' name='vins_share_extra_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_share_extra_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'></td>
                    <td align="center"><input type='text' size='10' name='vins_cacdt_cm_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_cm_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'></td>
                    <td align="center"><input type='text' size='10' name='vins_spe_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_spe_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'></td>                    
                    <td align="center"><input type='text' size='10' name='tot_amt12' value='<%=Util.parseDecimal(String.valueOf(ins.getRins_pcp_amt()+ins.getVins_pcp_amt()+ins.getVins_gcp_amt()+ins.getVins_bacdt_amt()+ins.getVins_canoisr_amt()+ins.getVins_share_extra_amt()+ins.getVins_cacdt_cm_amt()+ins.getVins_spe_amt()))%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
        	</tr>	
    	    </table>
	</td>
    </tr>  
    <%	int l_cnt = 0; %>	     	    	     
    <%if(base.getCar_st().equals("1") || base.getCar_st().equals("3") || base.getCar_st().equals("5")){%>	    
    <tr id=tr_cng7 style="display:'none'">
	<td class=h></td>
    </tr>	
    <tr id=tr_cng8 style="display:'none'"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����� ������� ����� �ݿ�</span><input type="checkbox" name="i_insinschange_cng_yn" value="Y" checked> ������� ����� �ݿ�</td>
    </tr>
    <tr id=tr_cng9 style="display:'none'">
        <td class=line2></td>
    </tr>
    <tr id=tr_cng10 style="display:'none'"> 
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=3% rowspan="2">����</td>
                    <td class=title width=3% rowspan="2">����</td>
                    <td class=title width=22% rowspan="2">�����׸�</td>
                    <td class=title colspan="2">�������</td>                    
                </tr>
                <tr> 
                    <td class=title width=30%>������</td>
                    <td class=title width=30%>������</td>
                </tr>
                <%
                	
                	for(int i = 0 ; i < ins_cha_size ; i++){
				InsurChangeBean cha = (InsurChangeBean)ins_cha.elementAt(i);	
		%>	
		<%		if(cha.getCh_item().equals("5")){
					l_cnt++;
		%>
                <tr align="center"> 
                    <td><%=l_cnt%></td>
                    <td align='center'><input type="checkbox" name="l_ch_cd" value="<%=l_cnt-1%>" checked></td>
                    <td>���ɺ���<input type='hidden' name='l_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        <select name='v_driving_age' disabled>                            
                            <option value="1" <%if(base.getDriving_age().equals("1")){%> selected <%}%>>21���̻�</option>
                            <option value="3" <%if(base.getDriving_age().equals("3")){%> selected <%}%>>24���̻�</option>
                            <option value="0" <%if(base.getDriving_age().equals("0")){%> selected <%}%>>26���̻�</option>                                                        
                            <option value="2" <%if(base.getDriving_age().equals("2")){%> selected <%}%>>��������</option>					  
                            <option value='5' <%if(base.getDriving_age().equals("5")){%>selected<%}%>>30���̻�</option>				
                            <option value='6' <%if(base.getDriving_age().equals("6")){%>selected<%}%>>35���̻�</option>				
                            <option value='7' <%if(base.getDriving_age().equals("7")){%>selected<%}%>>43���̻�</option>						
			    <option value='8' <%if(base.getDriving_age().equals("8")){%>selected<%}%>>48���̻�</option>					  						  
                        </select>
                    </td>					
                    <td>
                        <select name='driving_age'>                            
                            <option value="1" <%if(cha.getCh_after().equals("21���̻�")){%>selected <%}%>>21���̻�</option>
                            <option value="3" <%if(cha.getCh_after().equals("24���̻�")){%>selected <%}%>>24���̻�</option>
                            <option value="0" <%if(cha.getCh_after().equals("26���̻�")){%>selected <%}%>>26���̻�</option>                            
                            <option value="2" <%if(cha.getCh_after().equals("������")){%>selected <%}%>>��������</option>					  
                            <option value='5' <%if(cha.getCh_after().equals("30���̻�")){%>selected<%}%>>30���̻�</option>				
                            <option value='6' <%if(cha.getCh_after().equals("35���̻�")){%>selected<%}%>>35���̻�</option>				
                            <option value='7' <%if(cha.getCh_after().equals("43���̻�")){%>selected<%}%>>43���̻�</option>						
			   				<option value='8' <%if(cha.getCh_after().equals("48���̻�")){%>selected<%}%>>48���̻�</option>					  						  
                       		<option value='9' <%if(cha.getCh_after().equals("22���̻�")){%>selected<%}%>>22���̻�</option>
                        	<option value='10' <%if(cha.getCh_after().equals("28���̻�")){%>selected<%}%>>28���̻�</option>
                        	<option value='11' <%if(cha.getCh_after().equals("35���̻�~49������")){%>selected<%}%>>35���̻�~49������</option>
                        </select>                                            
                    </td>
                </tr>		  		
		<%		}%>		
		<%		if(cha.getCh_item().equals("1")){
					l_cnt++;
		%>
                <tr align="center"> 
                    <td><%=l_cnt%></td>
                    <td align='center'><input type="checkbox" name="l_ch_cd" value="<%=l_cnt-1%>" checked></td>
                    <td>�빰���Աݾ�<input type='hidden' name='l_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        <select name='v_gcp_kd' disabled>
                            <option value="1" <% if(base.getGcp_kd().equals("1")) out.print("selected"); %>>5õ����</option>
                            <option value="2" <% if(base.getGcp_kd().equals("2")) out.print("selected"); %>>1���</option>
			    <option value="4" <% if(base.getGcp_kd().equals("4")) out.print("selected"); %>>2���</option>
			    <option value="8" <% if(base.getGcp_kd().equals("8")) out.print("selected"); %>>3���</option>
			    <option value="3" <% if(base.getGcp_kd().equals("3")) out.print("selected"); %>>5���</option>
                        </select>
                    </td>					
                    <td>
                        <select name='gcp_kd'>
                            <option value="1" <% if(cha.getCh_after().equals("5õ����")) out.print("selected"); %>>5õ����</option>
                            <option value="2" <% if(cha.getCh_after().equals("1���")) out.print("selected"); %>>1���</option>
			    <option value="4" <% if(cha.getCh_after().equals("2���")) out.print("selected"); %>>2���</option>
			    <option value="8" <% if(cha.getCh_after().equals("3���")) out.print("selected"); %>>3���</option>
			    <option value="3" <% if(cha.getCh_after().equals("5���")) out.print("selected"); %>>5���</option>
                        </select>                    
                    </td>
                </tr>		  		
		<%		}%>	
		<%		if(cha.getCh_item().equals("2")){
					l_cnt++;
		%>
                <tr align="center"> 
                    <td><%=l_cnt%></td>
                    <td align='center'><input type="checkbox" name="l_ch_cd" value="<%=l_cnt-1%>" checked></td>
                    <td>�ڱ��ü���<input type='hidden' name='l_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        <select name='v_bacdt_kd' disabled>
                            <option value="1" <% if(base.getBacdt_kd().equals("1")) out.print("selected"); %>>5õ����</option>
                            <option value="2" <% if(base.getBacdt_kd().equals("2")) out.print("selected"); %>>1���</option>
                            <option value="9" <% if(base.getBacdt_kd().equals("9")) out.print("selected"); %>>�̰���</option>
                        </select>
                    </td>					
                    <td>
                        <select name='bacdt_kd'>
                            <option value="1" <% if(cha.getCh_after().equals("5õ����")) out.print("selected"); %>>5õ����</option>
                            <option value="2" <% if(cha.getCh_after().equals("1���")) out.print("selected"); %>>1���</option>
                            <option value="9" <% if(cha.getCh_after().equals("�̰���")) out.print("selected"); %>>�̰���</option>
                        </select>                    
                    </td>
                </tr>		  		
		<%		}%>	
		<%		if(cha.getCh_item().equals("4")){
					l_cnt++;
		%>
                <tr align="center"> 
                    <td><%=l_cnt%></td>
                    <td align='center'><input type="checkbox" name="l_ch_cd" value="<%=l_cnt-1%>" checked></td>
                    <td>�ڱ���������<input type='hidden' name='l_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        <select name='v_cacdt_yn' disabled>
                            <option value="">����</option>
                            <option value="Y" <%if(cont_etc.getCacdt_yn().equals("Y")){%> selected <%}%>>����</option>
                            <option value="N" <%if(cont_etc.getCacdt_yn().equals("N")){%> selected <%}%>>�̰���</option>
                        </select>                                                
                    </td>					
                    <td>
                        <select name='cacdt_yn'>
                            <option value="">����</option>
                            <option value="Y" <%if(!cha.getCh_after().equals("0")){%> selected <%}%>>����</option>
                            <option value="N" <%if(cha.getCh_after().equals("0")){%> selected <%}%>>�̰���</option>
                        </select>                                                
                    </td>
                </tr>		  		
		<%		}%>	
		<%		if(cha.getCh_item().equals("14")){
					l_cnt++;
		%>
                <tr align="center"> 
                    <td><%=l_cnt%></td>
                    <td align='center'><input type="checkbox" name="l_ch_cd" value="<%=l_cnt-1%>" checked></td>
                    <td>��������������Ư��<input type='hidden' name='l_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                      <select name='v_com_emp_yn' disabled>
                        <option value="N" <%if(cont_etc.getCom_emp_yn().equals("N")){%>selected<%}%>>�̰���</option>
                        <option value="Y" <%if(cont_etc.getCom_emp_yn().equals("Y")){%>selected<%}%>>����</option>
                      </select>                                                                  
                        
                    </td>					
                    <td>
                      <select name='com_emp_yn'>
                        <option value="N" <%if(cha.getCh_after().equals("�̰���")){%>selected<%}%>>�̰���</option>
                        <option value="Y" <%if(cha.getCh_after().equals("����")){%>selected<%}%>>����</option>
                      </select>                                                                  
                        
                    </td>
                </tr>		  		
		<%		}%>											
		<%		if(cha.getCh_item().equals("15")){
					l_cnt++;
		%>
                <tr align="center"> 
                    <td><%=l_cnt%></td>
                    <td align='center'><input type="checkbox" name="l_ch_cd" value="<%=l_cnt-1%>" checked></td>
                    <td>�Ǻ����ں���<input type='hidden' name='l_ch_item' value='<%=cha.getCh_item()%>'></td>
                    <td>
                        <select name='v_insur_per' disabled>                            
                            <option value="1" <%if(cont_etc.getInsur_per().equals("1")){%> selected <%}%>>�Ƹ���ī</option>
                            <option value="2" <%if(cont_etc.getInsur_per().equals("2")){%> selected <%}%>>��</option>
                        </select>
                    </td>					
                    <td>
                        <select name='insur_per'>                            
                            <option value="1" <%if(cha.getCh_after().equals("�Ƹ���ī")){%> selected <%}%>>�Ƹ���ī</option>
                            <option value="2" <%if(!cha.getCh_after().equals("�Ƹ���ī")){%> selected <%}%>>��</option>
                        </select>                        
                    </td>
                </tr>		  		
		<%		}%>

                <% 	}%>		
            </table>
        </td>
    </tr>	    	    
    <%}%>
    <input type='hidden' name='l_cnt' 		value='<%=l_cnt%>'>       
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
                    <td width='10%' class='title'>��ϱ���</td>
                    <td>&nbsp;
        		<%if(cng_doc.getCh_st().equals("2")){%>����<%}else{%>�ݿ�<%}%>
	            </td>
                </tr>
                <tr> 
                    <td width='10%' class='title'>��������</td>
                    <td>&nbsp;
        		<input type='text' name='cng_dt' size='11' value='<%=AddUtil.ChangeDate2(cng_doc.getCh_dt())%>' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 24�� </td>
                </tr>
                <tr> 
                    <td width='10%' class='title'>����㺸��ȿ�Ⱓ</td>
                    <td>&nbsp;
                        <input type='text' name='cng_s_dt' size='11' value='<%=AddUtil.ChangeDate2(cng_doc.getCh_s_dt())%>' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> ~ <input type='text' name='cng_e_dt' size='10' value='<%=AddUtil.ChangeDate2(cng_doc.getCh_e_dt())%>' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> </td>
                </tr>                                
                <tr> 
                    <td class='title'>���� �� Ư�̻���</td>
                    <td>&nbsp;
        		<textarea name="cng_etc" cols="100" class="text" style="IME-MODE: active" rows="5"><%=cng_doc.getCh_etc()%></textarea> 
                    </td>
                </tr>
                <%if(!cng_doc.getCh_st().equals("2")){%>                                
                <tr> 
                    <td width='10%' class='title'>���躯���û��</td>
                    <td>&nbsp;
                    	<%
				content_code = "LC_SCAN";
				content_seq  = rent_mng_id+""+rent_l_cd+"1"+"21";

				attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "21", 0);		
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
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
    						<%	}%>
    						<%}%>
    						<%if(scan_cnt>0){%>		
    						<input type='hidden' name='scan_yn' value='Y'>        
    						<%}else{%>      
    						<input type='hidden' name='scan_yn' value='N'>        
        			    		<span class="b"><a href="javascript:scan_reg('21', '<%=cng_doc.getIns_doc_no()%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_scan_reg.gif align=absmiddle border=0></a></span>
						&nbsp;&nbsp;* ��ĵ������ ����ϰ��� �� �������� <a href="javascript:page_reload()">���ΰ�ħ</a> ���ּ��� 						
						&nbsp;&nbsp;<a href="javascript:select_inss()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">[��ĺ���]</a>												
    						<%}%>
						&nbsp;&nbsp;<a href="javascript:view_scan()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a>
        			  
					 </td>
                </tr>		
                <tr> 
                    <td class='title' width="10%">ó������</td>
                    <td>&nbsp;
                        <select name='ins_doc_st'  class='default' onchange="javascript:display_reject();">
                            <option value="">����</option>
			    <option value="Y" <%if(cng_doc.getIns_doc_st().equals("Y"))%>selected<%%>>����</option>
			    <option value="N" <%if(cng_doc.getIns_doc_st().equals("N"))%>selected<%%>>�Ⱒ</option>
                        </select>
		    </td>
                </tr>				
                <tr id=tr_reject style="display:<%if(cng_doc.getIns_doc_st().equals("N")){%>''<%}else{%>none<%}%>"> 
                    <td class='title' width="10%">�Ⱒ����</td>
                    <td>&nbsp;<textarea cols="100" rows="5" name="reject_cau"><%=cng_doc.getReject_cau()%></textarea></td>
                </tr>								
		<%}%>		
            </table>
        </td>
    </tr>	
    <tr>
	<td>* ����㺸��ȿ�Ⱓ ���� 3�������� �����(�����)���� ���Ό������ �系�޽����� �뺸�մϴ�. ����ڴ� ���泻���� ���� ���� ���� �ݵ�� �����������ڿ��� ������ �����ؾ߸� �մϴ�.</td>
    </tr>	    
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩�ὺ���� �ݿ�</span></td>
    </tr>
    <%if(!base.getCar_st().equals("2")){%>	
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>���ݿ��ݾ�</td>
                    <td>&nbsp;
        		�� <input type='text' name='d_fee_amt' size='10' value='<%=AddUtil.parseDecimal(cng_doc.getD_fee_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value); set_n_ch_amt();'>���� ����
			&nbsp;&nbsp;(vat����)
		    </td>
                </tr>
                <tr> 
                    <td width='10%' class='title'>���뿩��</td>
                    <td>&nbsp;
        		[������] <input type='text' name='o_fee_amt' size='10' value='<%=AddUtil.parseDecimal(cng_doc.getO_fee_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value); set_n_ch_amt();'>��
			->
			[������] <input type='text' name='n_fee_amt' size='10' value='<%=AddUtil.parseDecimal(cng_doc.getN_fee_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value); set_n_ch_amt();'>��
			&nbsp;&nbsp;(vat����)
		    </td>
                </tr>				
            </table>
        </td>
    </tr>	
    <%}else{%>
        <input type='hidden' name="d_fee_amt" 	value="<%=cng_doc.getD_fee_amt()%>">
        <input type='hidden' name="o_fee_amt" 	value="<%=cng_doc.getO_fee_amt()%>">
        <input type='hidden' name="n_fee_amt" 	value="<%=cng_doc.getN_fee_amt()%>">
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td>&nbsp;* �������Դϴ�. �뿩�� ������ �ݿ����� �����ϴ�.</td>
                </tr>
            </table>
        </td>
    </tr>		
    <%}%>	
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10% rowspan="2">����</td>
                    <td class=title width=15%>������</td>
                    <td class=title width=15%><%=doc.getUser_nm1()%></td>
                    <td class=title width=15%><%=doc.getUser_nm2()%></td>
                    <td class=title width=15%><%=doc.getUser_nm3()%></td>
                    <td class=title width=15%><%=doc.getUser_nm4()%></td>
                    <td class=title width=15%><%//=doc.getUser_nm5()%></td>			
        	</tr>	
                <tr> 
                    <td align="center" style='height:44'><%=user_bean.getBr_nm()%></td>
                    <td align="center">
			<!--�����-->
			<%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%>        		
		    </td>
                   
      <%if(!doc.getUser_id4().equals("")){%>
       <td align="center">
		      <!--����������-->
					<%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%>        
				    </td>
		                    <td align="center">
					<!--������-->
					<%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%>
		        		<%if(!doc.getUser_dt2().equals("") && doc.getUser_dt3().equals("") && !cng_doc.getIns_doc_st().equals("N")){
		        			String user_id3 = doc.getUser_id3();
		        			CarScheBean cs_bean = csd.getCarScheTodayBean(user_id3);
		        			if(!cs_bean.getWork_id().equals(""))	user_id3 = cs_bean.getWork_id();
		        		%>
		     			<%	if(doc.getUser_id3().equals(user_id) || user_id3.equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������",user_id)){%>
		        		<a href="javascript:doc_sanction('3')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
		        		<%	}%>
		        		<br>&nbsp;
		        		<%}%>
		       			<br>&nbsp;
				    </td>
      <%}else{%>
      
		                    <td align="center">
					<!--������-->
					<%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%>
		        		<%if(!doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("") && !cng_doc.getIns_doc_st().equals("N")){
		        			String user_id2 = doc.getUser_id2();
		        			CarScheBean cs_bean = csd.getCarScheTodayBean(user_id2);
		        			if(!cs_bean.getWork_id().equals(""))	user_id2 = cs_bean.getWork_id();
		        		%>
		     			<%	if(doc.getUser_id2().equals(user_id) || user_id2.equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������",user_id)){%>
		        		<a href="javascript:doc_sanction('3')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
		        		<%	}%>
		        		<br>&nbsp;
		        		<%}%>
		       			<br>&nbsp;
				    </td>
      <td align="center"></td>
      <%}%>
			
                    <td align="center"></td>
                    <td align="center"></td>			
        	</tr>	
    	    </table>
	</td>
    </tr>  	 
    <%if(!mode.equals("view")){%> 		
    <%		if(doc.getUser_id1().equals(user_id) || doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("���ݰ�꼭�����",user_id) || nm_db.getWorkAuthUser("����������",user_id)){%>
    <tr>
	<td class=h></td>
    </tr>		
    <tr>
	<td align="right">
		
	    <%if(!doc.getDoc_step().equals("3")){%> 	
	    <a href="javascript:doc_sanction('u');"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
	    <%}%>
		  	  
	    <%if(cng_doc.getCh_st().equals("2") || !doc.getDoc_step().equals("3")){%> 	
	    <%		if(nm_db.getWorkAuthUser("������",user_id)||nm_db.getWorkAuthUser("�������",user_id)){%>
	    &nbsp;&nbsp;&nbsp;
	    <a href="javascript:doc_sanction('d');"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>
	    <%		}%>
	    <%}else{%>	
	    <%		if(nm_db.getWorkAuthUser("������",user_id)){%>
	    &nbsp;&nbsp;&nbsp;
	    <a href="javascript:doc_sanction('d');"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>
	    <%		}%>
	    <%}%>
	    
	    <%		if(cng_doc.getCh_st().equals("1") && doc.getUser_id1().equals(user_id) && !doc.getUser_dt1().equals("") && !doc.getDoc_step().equals("3")){//�ݿ��� ������û%>
	    &nbsp;&nbsp;&nbsp;
	    <input type="button" class="button" value="������û" onclick="javascript:doc_sanction('d_req');">	    
	    <%		} %>
	    
	</td>
    </tr>	
    <%		}%>	
    <%}%>	

</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	

//-->
</script>
</body>
</html>
