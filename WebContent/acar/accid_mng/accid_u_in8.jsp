<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, tax.*"%>
<%@ page import="acar.accid.*, acar.res_search.*, acar.cont.*, acar.car_mst.*, acar.user_mng.*,  acar.settle_acc.*, acar.estimate_mng.*"%>
<jsp:useBean id="oa_bean" class="acar.accid.OtAccidBean" scope="page"/>
<jsp:useBean id="my_bean2" class="acar.accid.MyAccidBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="ai_db" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//����ȣ
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//��������ȣ
	String seq_no = request.getParameter("seq_no")==null?"":request.getParameter("seq_no");//�������Ϸù�ȣ
	String mode = request.getParameter("mode")==null?"8":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "01", "02");
	
	//�����ȸ
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����ȸ
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
	
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP"); 
	int user_size = users.size();
		
	String bus_id2 = "";
	
	
	
	//����û����������Ʈ
	MyAccidBean my_r [] = as_db.getMyAccidList(c_id, accid_id);
	
	if(seq_no.equals("")) seq_no = "1";
	
	//����û������(����/������)
	MyAccidBean ma_bean = as_db.getMyAccid(c_id, accid_id, AddUtil.parseInt(seq_no));
		
		
	if ( !ma_bean.getBus_id2().equals("")){
	 	bus_id2 = ma_bean.getBus_id2();
	} else {
	    if ( !a_bean.getBus_id2().equals("") ) {  //�������� �����
	  	    bus_id2 = a_bean.getBus_id2();
	    } else {
			bus_id2 = (String)cont.get("BUS_ID2");
		}	
	}
	
	
	//�ܱ�������
	RentContBean rc_bean = rs_db.getRentContCaseAccid(c_id, accid_id);
	//������Ȳ
	Vector rc_conts = rs_db.getResCarAccidList(c_id, accid_id);
	int rc_cont_size = rc_conts.size();
	
	//��������
	Hashtable reserv = rs_db.getCarInfo(rc_bean.getCar_mng_id());
	
	//���ݰ�꼭 ��ȸ
	tax.TaxBean t_bean 		= IssueDb.getTax_accid(l_cd, c_id, accid_id, seq_no);
	
	Vector tax_vts = ScdMngDb.getEbHistoryList(t_bean.getTax_no());
	int tax_vt_size = tax_vts.size();
	String pubcode = "";
	if(tax_vt_size > 0){
		Hashtable tax_ht = (Hashtable)tax_vts.elementAt(tax_vt_size-1);
		pubcode = String.valueOf(tax_ht.get("PUBCODE"));
	}
	
	String car_st = String.valueOf(cont.get("CAR_NO"));
	if(!car_st.equals("")){
		if(car_st.indexOf("��") != -1){
			car_st = car_st.substring(4,5);	
		}
	}
	
	//������� ��������
	OtAccidBean oa_r [] = as_db.getOtAccid(c_id, accid_id);
	if(oa_r.length > 0){
		for(int i=0; i<1; i++){
   			oa_bean = oa_r[i];   			
			if(ma_bean.getIns_com().equals(""))		ma_bean.setIns_com	(oa_bean.getOt_ins());
			if(ma_bean.getIns_nm().equals(""))		ma_bean.setIns_nm	(oa_bean.getMat_nm());
			if(ma_bean.getIns_tel().equals(""))		ma_bean.setIns_tel	(oa_bean.getMat_tel());
			if(ma_bean.getIns_num().equals(""))		ma_bean.setIns_num	(oa_bean.getOt_num());
		}
	}
	
	//û�������� ��ȸ
	TaxItemListBean ti = IssueDb.getTaxItemListMyAccid(c_id, accid_id, seq_no, ma_bean.getIns_req_amt());
	
	
	
	//�޴����� ���ݽ�����
	Hashtable ext6 = a_db.getScdExtEtcPay(m_id, l_cd, "6", accid_id+""+seq_no);
	if(AddUtil.parseInt(String.valueOf(ext6.get("PAY_AMT")))>0){
		ma_bean.setIns_pay_amt(AddUtil.parseInt(String.valueOf(ext6.get("PAY_AMT"))));
	}
	
	//����
	String d_var1 = e_db.getEstiSikVarCase("1", "", "myaccid_app1");//÷�μ���1
	String d_var2 = e_db.getEstiSikVarCase("1", "", "myaccid_app2");//÷�μ���2
	String d_var3 = e_db.getEstiSikVarCase("1", "", "myaccid_app3");//÷�μ���3
	String d_var4 = e_db.getEstiSikVarCase("1", "", "myaccid_app4");//÷�μ���4	
	String d_var5 = e_db.getEstiSikVarCase("1", "", "myaccid_app5");//÷�μ���5
	String d_var6 = e_db.getEstiSikVarCase("1", "", "myaccid_app6");//÷�μ���6
	String d_var7 = e_db.getEstiSikVarCase("1", "", "myaccid_app7");//÷�μ���7
	String d_var8 = e_db.getEstiSikVarCase("1", "", "myaccid_app8");//÷�μ���8
	String d_var9 = e_db.getEstiSikVarCase("1", "", "myaccid_app9");//÷�μ���9
	String d_var10 = e_db.getEstiSikVarCase("1", "", "myaccid_app10");//÷�μ���10
	String d_var11 = e_db.getEstiSikVarCase("1", "", "myaccid_app11");//÷�μ���11
	
	
	String i_start_dt = ma_bean.getIns_use_st();
    	String i_start_h 	= "00";
    	String i_start_s 	= "00";
    	String get_start_dt = ma_bean.getIns_use_st();
    	if(get_start_dt.length() == 12){
    		i_start_dt 	= get_start_dt.substring(0,8);
    		i_start_h 	= get_start_dt.substring(8,10);
    		i_start_s	= get_start_dt.substring(10,12);
    	}
    	if(get_start_dt.length() == 10){
    		i_start_dt 	= get_start_dt.substring(0,8);
    		i_start_h 	= get_start_dt.substring(8,10);
    	}
	if(ma_bean.getIns_req_amt()==0 && get_start_dt.length() == 8 && !rc_bean.getCar_mng_id().equals("") && get_start_dt.equals(rc_bean.getDeli_dt_d())){
		i_start_h 	= rc_bean.getDeli_dt_h();
    		i_start_s	= rc_bean.getDeli_dt_s();
	}
	String i_end_dt = ma_bean.getIns_use_et();
    	String i_end_h 	= "00";
    	String i_end_s 	= "00";
    	String get_end_dt = ma_bean.getIns_use_et();
    	if(get_end_dt.length() == 12){
    		i_end_dt 	= get_end_dt.substring(0,8);
    		i_end_h 	= get_end_dt.substring(8,10);
    		i_end_s		= get_end_dt.substring(10,12);
    	}
    	if(get_end_dt.length() == 10){
    		i_end_dt 	= get_end_dt.substring(0,8);
    		i_end_h 	= get_end_dt.substring(8,10);
    	}
    	if(ma_bean.getIns_req_amt()==0 && get_end_dt.length() == 8 && !rc_bean.getCar_mng_id().equals("") && get_end_dt.equals(rc_bean.getRet_dt_d())){
		i_end_h 	= rc_bean.getRet_dt_h();
    		i_end_s		= rc_bean.getRet_dt_s();
	}
	
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
			
	String content_code = "PIC_RESRENT_ACCID";
	String content_seq  = c_id+""+accid_id+""+seq_no;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();	
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
	

	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}		
		theURL = "https://fms3.amazoncar.co.kr/data/doc/"+theURL;
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();
	}	
	
	//�����ϱ�
	function save(cmd){
		var fm = document.form1;	
		
		fm.cmd.value = cmd;
		

		if(fm.ins_use_st.value != '')
			fm.h_rent_start_dt.value 	= fm.ins_use_st.value+fm.use_st_h.value+fm.use_st_s.value;
		if(fm.ins_use_et.value != '')
			fm.h_rent_end_dt.value 		= fm.ins_use_et.value+fm.use_et_h.value+fm.use_et_s.value;


				
		if(fm.accid_id.value == '')			{ alert("����� ���� ����Ͻʽÿ�."); 	return; }		
		if(fm.ins_use_day.value == 'NaN')	{ alert('�ϼ��� Ȯ���Ͻʽÿ�.'); 		fm.ins_use_day.focus(); 	return; }
		
		if(fm.ins_req_gu.value == '2' && fm.ins_req_st.value == '1'){
			if(fm.mc_v_amt.value == '0' || fm.mc_v_amt.value == ''){
				alert('������� û���ϴ� ��� �ΰ����� �Է����ּ���.'); return;
			}
		}
		
		if( fm.ins_req_st.value == '1'){
			if(fm.ins_req_dt.value == '' ){
				alert('û�����ڸ� �Է����ּ���.'); fm.ins_req_dt.focus(); return;
			}
			if(fm.ins_use_st.value == '' ){
				alert('�����Ⱓ�� �Է����ּ���.'); fm.ins_use_st.focus(); return;
			}
			if(fm.ins_use_et.value == '' ){
				alert('�����Ⱓ�� �Է����ּ���.'); fm.ins_use_et.focus(); return;
			}
			
			if(toInt(replaceString('-','',fm.ins_use_st.value)) < <%=a_bean.getAccid_dt().substring(0,8)%>){
				alert('������ں��� ������������ �����ϴ�. Ȯ���Ͻʽÿ�.');
				return;
			}
		}	
		
		if(fm.ins_req_st.value == '1'){ //û���� ���
			if(fm.ins_req_gu.value == '2'){ //������				
				if(fm.ins_car_no.value == '')		{ alert("������ ������ȣ�� �Է��Ͻʽÿ�.");	fm.ins_car_no.focus(); 	return; }									
				if('<%=cont.get("CAR_NO")%>' == replaceString(" ","",fm.ins_car_no.value)){ alert("�����Ḧ û���� ������ȣ�� ��� �߻��� ������ȣ�� ������ �ȵ˴ϴ�."); 	return; }	
				//�������� ��� ������������ ������.
				if(fm.ins_car_no.value.indexOf("��")==-1 && fm.ins_car_no.value.indexOf("��")==-1 && fm.ins_car_no.value.indexOf("ȣ")==-1){
					alert("�����Ḧ û���� ��� ���������� �������̿��� �մϴ�. \n\n������ȣ�� �����ϼ���.");				fm.ins_car_no.focus(); 	return; 
				}	
				if(fm.ins_com.value == '')			{ alert("�������� �Է��Ͻʽÿ�.");		fm.ins_com.focus(); 	return; }	
			}
		}
		
		var mc_amt = toInt(parseDigit(fm.mc_s_amt.value)) + toInt(parseDigit(fm.mc_v_amt.value)); 							
		var req_amt = toInt(parseDigit(fm.ins_req_amt.value));
		
		if(mc_amt > req_amt || mc_amt < req_amt){
			alert('û���ݾװ� (���ް�+�ΰ���) �ݾ��� Ʋ���ϴ�. Ȯ���Ͻʽÿ�.'); return;
		}
		
		
		if(!confirm('����Ͻðڽ��ϱ�?')){
			return;
		}
		fm.action = "accid_u_a.jsp"
		fm.target = "i_no"
		fm.submit();
	}
	
	//���޺���� �հ� ����
	function set_accid_tot_amt(obj){
		var fm = document.form1;
		fm.accid_tot_amt.value = parseDecimal(toInt(parseDigit(fm.hum_amt.value)) + toInt(parseDigit(fm.mat_amt.value)) + toInt(parseDigit(fm.one_amt.value)) + toInt(parseDigit(fm.my_amt.value))); 							
	}
		
	//����/�����Ⱓ ���ڰ��
	function set_ins_use_dt(){
		var fm = document.form1;
		
		if(fm.ins_use_st.value != '' && fm.ins_use_et.value != ''){		

			m  = 30*24*60*60*1000;		//��
			l  = 24*60*60*1000;  		// 1��
			lh = 60*60*1000;  			// 1�ð�
			lm = 60*1000;  	 	 		// 1��			
			var d1 = replaceString('-','',fm.ins_use_st.value)+fm.use_st_h.value+fm.use_st_s.value;
			var d2 = replaceString('-','',fm.ins_use_et.value)+fm.use_et_h.value+fm.use_et_s.value;		
			var t1 = getDateFromString(d1).getTime();
			var t2 = getDateFromString(d2).getTime();
			var t3 = t2 - t1;			
			fm.ins_use_day.value 	= parseInt(t3/l);
			fm.use_hour.value 		= parseInt(((t3%m)%l)/lh);	
			
			if(toInt(d1)>0 && toInt(d1)==toInt(d2) && fm.ins_use_day.value == '0' && fm.use_hour.value == '0'){
				fm.ins_use_day.value 	= 1;
			}
			
			if(toInt(parseDigit(fm.ins_day_amt.value))>0){
				fm.ins_req_amt.value = parseDecimal( ((toInt(parseDigit(fm.ins_day_amt.value)) * toInt(fm.ins_use_day.value)) + (toInt(parseDigit(fm.ins_day_amt.value))/24 * toInt(fm.use_hour.value))) * (toInt(fm.ot_fault_per.value)/100) );
				if(fm.ins_req_gu.value == '1'){		//������
					fm.mc_s_amt.value = fm.ins_req_amt.value;
				}else{				
					fm.mc_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ins_req_amt.value))));
					fm.mc_v_amt.value = parseDecimal(toInt(parseDigit(fm.ins_req_amt.value)) - toInt(parseDigit(fm.mc_s_amt.value)));					
				}
			}

		}
	}	
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}
		
	//û���ݾ� ����
	function set_ins_amt(){
		var fm = document.form1;		
		fm.ins_req_amt.value = parseDecimal( (toInt(parseDigit(fm.ins_day_amt.value)) * toInt(fm.ins_use_day.value)) * toInt(fm.f_per.value)/100 );
		if(fm.vat_yn.checked == true){
			fm.mc_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ins_req_amt.value))));
			fm.mc_v_amt.value = parseDecimal(toInt(parseDigit(fm.ins_req_amt.value)) - toInt(parseDigit(fm.mc_s_amt.value)));					
		}else{
			fm.mc_s_amt.value = fm.ins_req_amt.value;
		}
	}
	
	//û���ݾ� ����
	function set_ins_vat_amt(){
		var fm = document.form1;		
		if(fm.vat_yn.checked == true){
			fm.mc_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ins_req_amt.value))));
			fm.mc_v_amt.value = parseDecimal(toInt(parseDigit(fm.ins_req_amt.value)) - toInt(parseDigit(fm.mc_s_amt.value)));					
		}
	}	
	
	function set_v_amt(){
		var fm = document.form1;		
		if(fm.vat_yn.checked == true){
			fm.mc_v_amt.value = parseDecimal(toInt(parseDigit(fm.mc_s_amt.value)) * 0.1);					
		}
		
	}
	function accid_tax(){
		var fm = document.form1;
		if(<%=ma_bean.getIns_req_amt()%>==0){ alert('û���ݾ��� �����ϴ�. û�������� ���� �����Ͻʽÿ�.'); return;}
		
		
		if(fm.ins_req_gu.value == '1'){		
			fm.action = "/tax/issue_3/issue_3_sc6.jsp";//������
		}else{
			fm.action = "/tax/issue_3/issue_3_sc5.jsp";//������
		}

		fm.target = "d_content";
		fm.submit();
	}	

	//�������μ�
	function DocPrint(){
		var fm = document.form1;
		var SUBWIN="/tax/item_mng/doc_accid_print.jsp?item_id=<%=ti.getItem_id()%>&client_id=<%=cont.get("CLIENT_ID")%>&r_site=&auth_rw=<%=auth_rw%>&car_mng_id=<%=c_id%>&accid_id=<%=accid_id%>&seq_no="+fm.seq_no.value;	
		window.open(SUBWIN, "DocPrint", "left=50, top=50, width=700, height=600, scrollbars=yes, status=yes");
	}	
	
	//���ݰ�꼭�μ�
	function TaxPrint(tax_no){
		var fm = document.form1;
		var SUBWIN="/tax/tax_mng/tax_accid_print.jsp?item_id=<%=ti.getItem_id()%>&client_id=<%=cont.get("CLIENT_ID")%>&r_site=&auth_rw=<%=auth_rw%>&car_mng_id=<%=c_id%>&accid_id=<%=accid_id%>";	
		window.open(SUBWIN, "TaxPrint", "left=50, top=50, width=680, height=550, scrollbars=yes, status=yes");
	}	
	
	//���ݰ�꼭�μ�
	function TaxPrint2(tax_no){
		var fm = document.form1;
		var SUBWIN="/tax/tax_mng/tax_print.jsp?tax_no="+tax_no;
		window.open(SUBWIN, "TaxPrint", "left=50, top=50, width=680, height=550, scrollbars=yes, status=yes");
	}	
	
	//�ʿ伭��
	function DocSelect(){
		var fm = document.form1;
		var SUBWIN="myaccid_reqdoc_select.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&seq_no=<%=seq_no%>&client_id=<%=cont.get("CLIENT_ID")%>";			
		window.open(SUBWIN, "DocSelect", "left=50, top=50, width=950, height=600, scrollbars=yes, status=yes");	
	}
	
	//û���ݾ� ����
	function set_reqamt(st){
		var fm = document.form1;			
		
		if(fm.ins_use_day.value == '') 	set_ins_use_dt();		
		if(fm.ins_use_day.value == ''){	alert('�̿��ϼ��� �Է��Ͻʽÿ�.'); return;}

		if(fm.use_hour.value == '') 	set_ins_use_dt();
		if(fm.use_hour.value == ''){	alert('�̿�ð��� �Է��Ͻʽÿ�. �����������ڿ��� Ŀ���� �״ٰ� �����ø� �ڵ���� �մϴ�.'); return;}

		
		fm.st.value = st;
		fm.action='getMyAccidReqAmt.jsp';
		
		if(st == 'view'){
			fm.target='_blank';
		}else{
			
			if(toInt(replaceString('-','',fm.ins_use_st.value)) < <%=a_bean.getAccid_dt().substring(0,8)%>){
				alert('������ں��� ������������ �����ϴ�. Ȯ���Ͻʽÿ�.');
				return;
			}
						
			fm.target='i_no';
		}
				
		fm.submit();
	}	
	

	
	function accid_tax_msg(){
		var fm = document.form1;	
		fm.action='/fms2/coolmsg/cool_msg_send.jsp';
		fm.target='i_no';
		fm.submit();
	}
	
	//������û������ �����û
	function accid_doc_req_msg(){
		var fm = document.form1;	
		
		if(<%=ma_bean.getIns_req_amt()%>==0){ 	alert('û���ݾ��� �����ϴ�. û�������� ���� �����Ͻʽÿ�.'); 		return;}
		if('<%=ma_bean.getIns_req_dt()%>'==''){ alert('û�����ڰ� �����ϴ�. û�������� ���� �����Ͻʽÿ�.'); 		return;}
		if('<%=ma_bean.getIns_com()%>'==''){ 	alert('û���� ����簡 �����ϴ�. û�������� ���� �����Ͻʽÿ�.'); 	return;}
		if('<%=ma_bean.getIns_nm()%>'==''){ 	alert('û���� �����-����ڰ� �����ϴ�. û�������� ���� �����Ͻʽÿ�.'); 	return;}
		if('<%=ma_bean.getIns_zip()%>'==''){ 	alert('û���� �����-�����ȣ�� �����ϴ�. û�������� ���� �����Ͻʽÿ�.'); 	return;}
		if('<%=ma_bean.getIns_addr()%>'==''){ 	alert('û���� �����-�ּҰ� �����ϴ�. û�������� ���� �����Ͻʽÿ�.'); 	return;}
		if('<%=ma_bean.getApp_docs()%>'==''){ 	alert('û���� �����-÷�μ����� �����ϴ�. û�������� ���� �����Ͻʽÿ�.'); 	return;}
			
		if(!confirm('��û�Ͻðڽ��ϱ�?')){
			return;
		}
		fm.action = "accid_u_h_a.jsp";
		fm.target = "i_no";
		fm.submit();		
	}
	
	
	function reg_save(){
		var fm = document.form1;	
		fm.seq_no.value = <%=my_r.length%>+1;
		fm.action='accid_u_in8.jsp';
		fm.target='_self';
		fm.submit();		
	}
	
	function view_my_accid(seq_no){
		var fm = document.form1;	
		fm.seq_no.value = seq_no;
		fm.seq_no2.value = seq_no;
		fm.action='accid_u_in8.jsp';
		fm.target='_self';
		fm.submit();		
	}
	
	//Ʈ������ ����
	function  viewTaxInvoice(pubCode){
		var iMyHeight;
		width = (window.screen.width-635)/2
		if(width<0)width=0;
		iMyWidth = width; 
		height = 0;
		if(height<0)height=0;
		iMyHeight = height;
		var taxInvoice = window.open("about:blank", "taxInvoice", "resizable=no,  scrollbars=no, left=" + iMyWidth + ",top=" + iMyHeight + ",screenX=" + iMyWidth + ",screenY=" + iMyHeight + ",width=680px, height=760px");
		document.form1.action="https://www.trusbill.or.kr/jsp/directTax/TaxViewIndex.jsp";
		document.form1.method="post";
		document.form1.pubCode.value=pubCode;
		document.form1.docType.value="T"; //���ݰ�꼭
		document.form1.userType.value="S"; // S=�������� ó��ȭ��, R= �޴��� ó��ȭ��
		document.form1.target="taxInvoice";
		document.form1.submit();
		document.form1.target="_self";
		document.form1.pubCode.value="";
		taxInvoice.focus();
		return;
	}
		
	function ViewTaxItem(){		
		var taxItemInvoice = window.open("about:blank", "TaxItem", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=1000px, height=800px");
		var fm = document.form1;
		fm.target="TaxItem";
		fm.action = "/tax/issue_1_tax/tax_item_u.jsp";
		fm.submit();			
	}						
		
	//�������ȸ
	function find_gov_search(){
		var fm = document.form1;	
		window.open("find_gov_search.jsp?mode=<%=mode%>", "SEARCH_FINE_INSCOM", "left=100, top=10, width=1050, height=850, scrollbars=yes");
	}		
	
	//����ϱ�
	function FineDocPrint(doc_id){
		var fm = document.form1;
		var SUMWIN = "/fms2/accid_doc/accid_mydoc_print.jsp?doc_id="+doc_id;	
		window.open(SUMWIN, "DocPrint", "left=50, top=50, width=750, height=600, scrollbars=yes, status=yes");			
	}
			
	
	//����ý��� ����Ÿ ����(�����϶�)
	function reserv_set(){
		var fm = document.form1;
		if(fm.ins_req_st.value == '' || fm.ins_req_st.value == '0') fm.ins_req_st.value = '1';
		fm.ins_car_no.value = '<%=reserv.get("CAR_NO")%>';
		fm.ins_car_nm.value = '<%=reserv.get("CAR_NM")%>';
		fm.ins_use_st.value = ChangeDate('<%=rc_bean.getDeli_dt_d()%>');
		fm.use_st_h.value 	= '<%=rc_bean.getDeli_dt_h()%>';
		fm.use_st_s.value 	= '<%=rc_bean.getDeli_dt_s()%>';
		fm.ins_use_et.value = ChangeDate('<%=rc_bean.getRet_dt_d()%>');
		fm.use_et_h.value 	= '<%=rc_bean.getRet_dt_h()%>';
		fm.use_et_s.value 	= '<%=rc_bean.getRet_dt_s()%>';		
				
		//�����Ⱓ ���(��,�ð�)		
		set_ins_use_dt();
		
		if(fm.ot_fault_per.value == '0' || fm.ot_fault_per.value == ''){ alert('���������� �����ϴ�. \n\n���������� �Է��ϰ� [����ϱ�]�� Ŭ�� �Ͻʽÿ�.'); fm.ot_fault_per.focus(); return; } 
		
		//�������رݾ� ���
		set_reqamt('');
	}
	
	//����ý��� ����Ÿ ����(����������)
	function reserv_set2(car_no, car_nm, deli_dt, ret_dt){
		var fm = document.form1;
		if(fm.ins_req_st.value == '' || fm.ins_req_st.value == '0') fm.ins_req_st.value = '1';
		fm.ins_car_no.value = car_no;
		fm.ins_car_nm.value = car_nm;
		if(deli_dt.length >= 8){
			fm.ins_use_st.value = ChangeDate(deli_dt.substring(0,8));
			if(deli_dt.length == 12){
				fm.use_st_h.value 	= deli_dt.substring(8,10);
				fm.use_st_s.value 	= deli_dt.substring(10,12);			
			}else{
				fm.use_st_h.value 	= '00';
				fm.use_st_s.value 	= '00';						
			}
		}
		if(ret_dt.length >= 8){
			fm.ins_use_et.value = ChangeDate(ret_dt.substring(0,8));
			if(ret_dt.length == 12){
				fm.use_et_h.value 	= ret_dt.substring(8,10);
				fm.use_et_s.value 	= ret_dt.substring(10,12);			
			}else{
				fm.use_et_h.value 	= '00';
				fm.use_et_s.value 	= '00';						
			}
		}
				
		//�����Ⱓ ���(��,�ð�)		
		set_ins_use_dt();
		
		if(fm.ot_fault_per.value == '0' || fm.ot_fault_per.value == ''){ alert('���������� �����ϴ�. \n\n���������� �Է��ϰ� [����ϱ�]�� Ŭ�� �Ͻʽÿ�.'); fm.ot_fault_per.focus(); return; } 
		
		//�������رݾ� ���
		set_reqamt('');
	}	
	
	//û�����ý� ó����
	function cng_reserv(value){
		var fm = document.form1;
		if(value =='1' && '<%=rc_bean.getCar_mng_id()%>' != ''){
			if(!confirm('����ý����� ���������� �������ڽ��ϱ�?')){
				return;
			}
			reserv_set();
		}
	}
	
	//����ý��� ��༭
	function view_scan_res(mode, c_id, s_cd){
		window.open("/acar/rent_mng/res_rent_u_accid_print.jsp?c_id="+c_id+"&s_cd="+s_cd+"&mode="+mode+"&sub_c_id=<%=c_id%>&accid_id=<%=accid_id%>&seq_no=<%=seq_no%>", "VIEW_SCAN_RES", "left=100, top=100, width=750, height=700, scrollbars=yes");		
	}	
	
	//���������� �ڰ����϶� ������ ������ ��ȸ�ϱ�
	function res_car_search(reg_yn, section, car_nm, deli_dt, ret_dt, ins_com){
		var fm = document.form1;
		if(reg_yn == 'Y'){
			window.open("res_car_taecha_search.jsp?section_yn=Y&section="+section+"&car_nm="+car_nm+"&deli_dt="+deli_dt+"&ret_dt="+ret_dt+"&ins_com="+ins_com+"", "SEARCH_RES_CAR", "left=100, top=100, width=850, height=700, scrollbars=yes");				
		}else{
			if(fm.ins_use_st.value == '' )	{	alert('�����Ⱓ ������ �Է����ּ���.'); 	fm.ins_use_st.focus(); 	return;	}
			if(fm.ins_com.value == '')		{ 	alert("�������� �Է��Ͻʽÿ�.");	fm.ins_com.focus(); 	return; }	
			window.open("res_car_taecha_search.jsp?section_yn=Y&section=<%=cm_bean.getSection()%>&car_nm=<%=cm_bean.getCar_nm()%>&deli_dt="+fm.ins_use_st.value+"&ret_dt="+fm.ins_use_et.value+"&ins_com="+fm.ins_com.value+"", "SEARCH_RES_CAR", "left=100, top=100, width=850, height=700, scrollbars=yes");						
		}
	}
	

	//��ĵ���
	function scan_reg(file_st){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&seq_no=<%=seq_no%>&file_st="+file_st, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
			
	//��ĵ����
	function scan_del(accid_id, c_id){
		var fm = document.form1;
		if(!confirm('�����Ͻðڽ��ϱ�?')){		return;	}

		fm.target = "i_no"
		fm.action = "del_accid_scan_a.jsp?accid_id="+accid_id+"&c_id="+c_id;
		fm.submit();
		
	}
	
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
<form action="accid_u_a.jsp" name="form1">
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='gubun1' value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' value='<%=gubun2%>'>
  <input type='hidden' name='gubun3' value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' value='<%=gubun5%>'>
  <input type='hidden' name='gubun6' value='<%=gubun6%>'>
  <input type='hidden' name='brch_id' value='<%=brch_id%>'>
  <input type='hidden' name='st_dt' value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' value='<%=end_dt%>'>
  <input type='hidden' name='s_kd' value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' value='<%=t_wd%>'>
  <input type='hidden' name='sort' value='<%=sort%>'>
  <input type='hidden' name='asc' value='<%=asc%>'>
  <input type='hidden' name='s_st' value='<%=s_st%>'>
  <input type='hidden' name='idx' value='<%=idx%>'>
  <input type='hidden' name='m_id' value='<%=m_id%>'>
  <input type='hidden' name='l_cd' value='<%=l_cd%>'>
  <input type='hidden' name='c_id' value='<%=c_id%>'>
  <input type='hidden' name='accid_id' value='<%=accid_id%>'>
  <input type='hidden' name='mode' value='<%=mode%>'>
  <input type='hidden' name='cmd' value='<%=cmd%>'>    
  <input type='hidden' name='go_url' value='<%=go_url%>'>
  <input type="hidden" name="client_id" value="<%=cont.get("CLIENT_ID")%>">
  <input type="hidden" name="site_id" value="">  
  <input type="hidden" name="rent_mng_id" value="<%=m_id%>">
  <input type="hidden" name="rent_l_cd" value="<%=l_cd%>">      
  <input type="hidden" name="car_mng_id" value="<%=c_id%>">      
  <input type="hidden" name="firm_nm" value="<%=cont.get("FIRM_NM")%>">     
  <input type='hidden' name='f_per' value='<%=Math.abs(a_bean.getOur_fault_per()-100)%>'>
  <input type='hidden' name='st' value=''>
  <input type="hidden" name="sender_id" value="<%=user_id%>">  	
  <input type="hidden" name="target_id" value="<%=nm_db.getWorkAuthUser("������")%>">  	
  <input type="hidden" name="coolmsg_sub" value="������û������ �߼ۿ�û">  	
  <input type="hidden" name="coolmsg_cont" value="�� ������û������ �����û :: <%=cont.get("FIRM_NM")%> <%=cont.get("CAR_NO")%>, ����Ͻ�:<%=a_bean.getAccid_dt()%>, û���ݾ�:<%=AddUtil.parseDecimal(ma_bean.getIns_req_amt())%>">  	
  <input type="hidden" name="seq_no" value="<%=seq_no%>">  	
  <input type="hidden" name="seq_no2" value="<%=seq_no%>">  	
  <input type='hidden' name="pubCode" value="">
  <input type='hidden' name="docType" value="">
  <input type='hidden' name="userType" value="">  
  <input type='hidden' name="item_id" value="<%=ti.getItem_id()%>">    
  <input type='hidden' name='ins_com_id' value=''>
  <input type='hidden' name='h_rent_start_dt' value=''>
  <input type='hidden' name='h_rent_end_dt' value=''>
  

    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td width="6%" class=title>����</td>
                    <td width="6%" class=title>����</td>
                    <td width="15%" class=title>�����</td>
                    <td width="10%" class=title>��������</td>
                    <td width="10%" class=title>������ȣ</td>
                    <td width="15%" class=title>����</td>
                    <td width="10%" class=title>û���ݾ�</td>
                    <td width="10%" class=title>û������</td>
                    <td width="10%" class=title>�Աݱݾ�</td>
                    <td width="10%" class=title>�Ա�����</td>
                </tr>
		<%	for(int i=0; i<my_r.length; i++){
    				my_bean2 = my_r[i];
				//�޴����� ���ݽ�����
				Hashtable ext66 = a_db.getScdExtEtcPay(m_id, l_cd, "6", accid_id+""+my_bean2.getSeq_no());
				if(AddUtil.parseInt(String.valueOf(ext66.get("PAY_AMT")))>0){
					my_bean2.setIns_pay_amt(AddUtil.parseInt(String.valueOf(ext66.get("PAY_AMT"))));
				}
		%>
                <tr>
                  <td align="center"><%=i+1%></td>
                  <td align="center"><%if(my_bean2.getIns_req_gu().equals("2")){%>������<%}%><%if(my_bean2.getIns_req_gu().equals("1")){%>������<%}%></td>
                  <td align="center"><a href="javascript:view_my_accid(<%=my_bean2.getSeq_no()%>);"><%=my_bean2.getIns_com()%></a></td>
                  <td align="center"><%=my_bean2.getIns_nm()%></td>
                  <td align="center"><%=my_bean2.getIns_car_no()%></td>
                  <td align="center"><%=my_bean2.getIns_car_nm()%></td>
                  <td align="right"><%=AddUtil.parseDecimal(my_bean2.getIns_req_amt())%>��</td>
                  <td align="center"><%=AddUtil.ChangeDate2(my_bean2.getIns_req_dt())%></td>
                  <td align="right"><%=AddUtil.parseDecimal(my_bean2.getIns_pay_amt())%>��</td>
                  <td align="center"><%=AddUtil.ChangeDate2(my_bean2.getIns_pay_dt())%></td>
                </tr>
		<%	}%>
	    </table>
	</td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
        <td align="right">
            <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
            <a href='javascript:reg_save()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_plus.gif" align="absmiddle" border="0"></a>
            <%}%>
        </td>
    </tr>	
    <tr>
        <td></td>
    </tr>
    <tr><td colspan=2 style='background-color:bebebe; height:1;'></td></td></tr>	
    <%if(rc_cont_size > 0){%>
    <tr><td class=h></td></tr>
    <tr>
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span> </td>
    </tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr> 
        <td class=line colspan="2">
            <table border="0" cellspacing="1" width=100%>
		<%	for(int i = 0 ; i < rc_cont_size ; i++){
    				Hashtable reservs = (Hashtable)rc_conts.elementAt(i);
    		%>
                <tr> 
                    <td class=title width=9%>������ȣ</td>
                    <td width=15%>&nbsp;<%=reservs.get("CAR_NO")%>
			<%if(rc_cont_size ==1){%>
			<a href="javascript:reserv_set2('<%=reservs.get("CAR_NO")%>','<%=reservs.get("CAR_NM")%>','<%=reservs.get("DELI_DT")%>','<%=reservs.get("RET_DT")%>')" onMouseOver="window.status=''; return true" onFocus="this.blur()" title='�������� ����Ÿ�� ������ û���� �����մϴ�.'>[����]</a>
			<%}else{%>
			<a href="javascript:reserv_set2('<%=reservs.get("CAR_NO")%>','<%=reservs.get("CAR_NM")%>','<%=reservs.get("DELI_DT")%>','<%=reservs.get("RET_DT")%>')" onMouseOver="window.status=''; return true" onFocus="this.blur()" title='�������� ����Ÿ�� ������ û���� �����մϴ�.'>[����]</a>						
			<%}%>
		    </td>
                    <td class=title width=9%>����</td>
                    <td width=23%>&nbsp;<%=reservs.get("CAR_NM")%>&nbsp;<%//=reservs.get("CAR_NAME")%></td>
                    <td class=title width=9%>�����Ⱓ</td>
                    <td width=35%>&nbsp;<%=AddUtil.ChangeDate3(String.valueOf(reservs.get("DELI_DT")))%>~<%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RET_DT")))%>
			&nbsp;<a href="javascript:view_scan_res('accid_doc','<%=reservs.get("CAR_MNG_ID")%>','<%=reservs.get("RENT_S_CD")%>')" onMouseOver="window.status=''; return true" title='�ܱ��༭ ����'><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		    </td>
                </tr>
		<%	}%>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>		
    <%}%>		
    <tr> 
        <td>
            <img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span>
	</td>
        <td align="right">
        
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
            <%if(ma_bean.getAccid_id().equals("")){%>
            <a href='javascript:save("i")' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>
            <%}else{%>
            <a href='javascript:save("u")' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>
            <%}%>
        <%}%>
        
	</td>
    </tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=9%>û������</td>
                    <td width=15%> 
                      <select name="ins_req_gu">
                        <option value="2" <%if(ma_bean.getIns_req_gu().equals("2"))%>selected<%%>>������</option>
                        <option value="1" <%if(ma_bean.getIns_req_gu().equals("1"))%>selected<%%>>������</option>
                      </select>
                    </td>
                    <td class=title width=9%>����</td>
                    <td width=15%> 
                      <select name="ins_req_st" onChange="javascript:cng_reserv(this.value)">
                        <option value="0" <%if(ma_bean.getIns_req_st().equals("0"))%>selected<%%>>��û��</option>
                        <option value="1" <%if(ma_bean.getIns_req_st().equals("1"))%>selected<%%>>û��</option>
                        <option value="2" <%if(ma_bean.getIns_req_st().equals("2"))%>selected<%%>>�Ϸ�</option>
                        <option value="3" <%if(ma_bean.getIns_req_st().equals("3"))%>selected<%%>>�ְ�������</option>
                      </select>
                    </td>
                    <td class=title width=9%>������ȣ</td>
                    <td width=15%> 
                      <input type="text" name="ins_car_no" value="<%=ma_bean.getIns_car_no()%>" size="14" class=text maxlength="12">
					  <%	if(!rc_bean.getCar_mng_id().equals("")){%>	
					  <%		if(String.valueOf(reserv.get("CAR_USE")).equals("2")){%>	
					  			<span class="b"><a href="javascript:res_car_search('Y','<%=reserv.get("SECTION")%>', '<%=reserv.get("CAR_NM")%>', '<%=rc_bean.getDeli_dt()%>', '<%=rc_bean.getRet_dt()%>', '<%=ma_bean.getIns_com()%>')" onMouseOver="window.status=''; return true" title="������ ������ ��ȸ�ϱ�"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
					  <%		}%>
					  <%	}else{%>
					  			<span class="b"><a href="javascript:res_car_search('N','', '', '', '', '')" onMouseOver="window.status=''; return true" title="������ ������ ��ȸ�ϱ�"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
					  <%	}%>
                    </td>
                    <td class=title width=9%>����</td>
                    <td width=19%> 
                      <input type="text" name="ins_car_nm" value="<%=ma_bean.getIns_car_nm()%>" class=text size="20" maxlength="30">
                    </td>
                </tr>
                <tr> 
                    <td class=title> �Ⱓ</td>
                    <td colspan="7">
                      <input type="text" name="ins_use_st" value="<%=AddUtil.ChangeDate2(i_start_dt)%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);' maxlength="12">

					  <select name="use_st_h">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(i_start_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="use_st_s">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(i_start_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>	

                      ~ 
                      <input type="text" name="ins_use_et" value="<%=AddUtil.ChangeDate2(i_end_dt)%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value); set_ins_use_dt();' maxlength="12">

					  <select name="use_et_h" onChange="javscript:set_ins_use_dt();">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(i_end_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="use_et_s" onChange="javscript:set_ins_use_dt();">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(i_end_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>	

                      ( 
                      <input type="text" name="ins_use_day" value="<%=ma_bean.getIns_use_day()%>" size="3" class=num onBlur='javscript:set_ins_amt();'>
                      ��					  
					  <input type="text" name="use_hour" value="<%=ma_bean.getUse_hour()%>" size="2" class=num onBlur='javscript:set_ins_amt();'>
                      �ð� 	
					  )&nbsp; 
        			  <span class="b"><a href="javascript:set_reqamt('')" onMouseOver="window.status=''; return true" title="����ϱ�"><img src="/acar/images/center/button_in_cal.gif" align="absmiddle" border="0"></a></span>
        			  <span class="b"><a href="javascript:set_reqamt('view')" onMouseOver="window.status=''; return true" title="���� ����"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a></span>
        			  </td>                    
                </tr>
                <tr> 
                    <td class=title>û������</td>
                    <td colspan="3"> 1�� 
                      <input type="text" name="ins_day_amt" value="<%=AddUtil.parseDecimal(ma_bean.getIns_day_amt())%>" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_ins_amt();'>
                      ��</td>
                    <td class=title>������</td>
					<%	int ot_fault_per = ma_bean.getOt_fault_per();
						if(ot_fault_per==0) ot_fault_per = Math.abs(a_bean.getOur_fault_per()-100);%>
                    <td colspan="3"> <input type=text name='ot_fault_per' value='<%=ot_fault_per%>' size="3" class=num>%</td>
                </tr>
                <tr> 
                    <td class=title>û���ݾ�</td>
                    <td colspan="7">
                      <input type="text" name="ins_req_amt" value="<%=AddUtil.parseDecimal(ma_bean.getIns_req_amt())%>" size="11" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��
					  <font color=#666666>&nbsp;(û���ݾ�=((1��û������*�����ϼ�)+(1��û������/24*�����ð�))*��������)</font>
					  </td>
                </tr>
                <tr> 
                    <td class=title>���ް�</td>
                    <td colspan="3"><input type="text" name="mc_s_amt" value="<%=AddUtil.parseDecimal(ma_bean.getMc_s_amt())%>" size="11" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_v_amt();'>
						�� </td>
                    <td class=title>�ΰ���</td>
                    <td colspan="3"><input type="text" name="mc_v_amt" value="<%=AddUtil.parseDecimal(ma_bean.getMc_v_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
						��
						  (<input type='checkbox' name='vat_yn' value="Y" <%if(ma_bean.getVat_yn().equals("Y"))%> checked<%%> onclick='javscript:set_ins_vat_amt()'>�ΰ�������)</td>
                </tr>				
                <tr> 
                    <td class=title>û������</td>
                    <td colspan="3"> 
					  <%if(ma_bean.getIns_req_dt().equals("") || nm_db.getWorkAuthUser("������",user_id)){%>	
                      <input type="text" name="ins_req_dt" value="<%=AddUtil.ChangeDate2(ma_bean.getIns_req_dt())%>" size="12" class=text   onBlur='javscript:this.value = ChangeDate(this.value);' maxlength="10">
					  <%}else{%>
					  <%=AddUtil.ChangeDate2(ma_bean.getIns_req_dt())%>
					  <input type='hidden' name="ins_req_dt" value="<%=ma_bean.getIns_req_dt()%>">
					  <%}%>
                    </td>
                    <td class=title>û����</td>   
                    <td colspan="3">&nbsp;<select name='bus_id2'>
                        <option value="">������</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(bus_id2.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>   					
                </tr>												
                <tr> 				
                    <td class=title>��û������</td>
                    <td colspan="7">
                    <textarea name="re_reason" cols="120" class="text" rows="2"><%=ma_bean.getRe_reason()%></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan='2'>(���ʵ����:<%=AddUtil.ChangeDate2(ma_bean.getReg_dt())%>, ���ʵ����:<%=c_db.getNameById(ma_bean.getReg_id(), "USER")%> / ���������:<%=AddUtil.ChangeDate2(ma_bean.getUpdate_dt())%>, ���������:<%=c_db.getNameById(ma_bean.getUpdate_id(), "USER")%>)
	    <%if(nm_db.getWorkAuthUser("������",user_id)){%><%=c_id%>/<%=accid_id%>/<%=seq_no%><%}%></td>
    </tr>		    	
    <tr> 
        <td width="30%"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ĵ����</td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="15%" colspan="2">�������� ��༭</td>
                    <td colspan='6'>
			<%if(attach_vt_size > 0){%>
			    <%	for (int i = 0 ; i < attach_vt_size ; i++){
    					Hashtable ht = (Hashtable)attach_vt.elementAt(i);%>
    					&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a>
    					&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
    					<%if(i+1 < attach_vt_size){%><br><%}%>
    			    <%	}%>		
			<%}else{%>
			    <a href="javascript:scan_reg(1)"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
			<%}%>
		    </td>
                </tr>
            </table>
        </td>
    </tr>	

    <tr><td class=h></td></tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=9%>�Աݱ���</td>
                  <td width=15%><select name="pay_gu" disabled>
				    <option value="" <%if(ma_bean.getPay_gu().equals(""))%>selected<%%>>����</option>
                    <option value="2" <%if(ma_bean.getPay_gu().equals("2"))%>selected<%%>>������</option>
                    <option value="1" <%if(ma_bean.getPay_gu().equals("1"))%>selected<%%>>������</option>
                  </select></td>
                    <td class=title width=9%>�Աݱݾ�</td>
                    <td width=15%><input type="text" name="ins_pay_amt" value="<%=AddUtil.parseDecimal(ma_bean.getIns_pay_amt())%>" size="10" <%if(nm_db.getWorkAuthUser("ȸ�����",user_id) || nm_db.getWorkAuthUser("������",user_id)){%>class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);' readonly<%}else{%>class=whitenum readonly<%}%>>
					�� 
                    </td>
                    <td class=title width=9%>�Ա�����</td>
                    <td width=43%> 
                      <input type="text" name="ins_pay_dt" value="<%=AddUtil.ChangeDate2(ma_bean.getIns_pay_dt())%>" size="12" <%if(nm_db.getWorkAuthUser("ȸ�����",user_id)|| nm_db.getWorkAuthUser("������",user_id) ){%>class=whitetext   onBlur='javscript:this.value = ChangeDate(this.value);'  readonly <%}else{%>class=whitetext readonly<%}%> maxlength="10">
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title>�����</td>
                    <td colspan="5"> 
					  <input type="text" name="ins_com" value="<%=ma_bean.getIns_com()%>" size="20" class='text' maxlength="20" readonly >
					  <a href="javascript:find_gov_search();" titile='����� �˻�'><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
					  <% 	if(!ma_bean.getIns_com().equals("") || !ma_bean.getIns_com_id().equals("")){
						  		Hashtable ins_com = ai_db.getInsCom(ma_bean.getIns_com_id(), ma_bean.getIns_com());						  		
					  %>	  		
					  &nbsp;
					  (<%=ma_bean.getIns_com()%> ����ó:<%=ins_com.get("AGNT_TEL")%>/FAX:<%=ins_com.get("AGNT_FAX")%>/����⵿:<%=ins_com.get("AGNT_IMGN_TEL")%>/�������:<%=ins_com.get("ACC_TEL")%>)
				 	  <%	   		
					  		}	  	
					  %>					  
                    </td>
                    <td class=title>������ȣ</td>
                    <td>NO.<input name="ins_num" type="text" class=text id="ins_num" value="<%=ma_bean.getIns_num()%>" size="30" maxlength="50" >
                    </td>
                </tr>		
                <tr> 
                    <td class=title width=9%>��������</td>
                    <td width=15%> 
                      <input type="text" name="ins_nm" value="<%=ma_bean.getIns_nm()%>" size="20" class=text maxlength="30" >
                    </td>
                    <td class=title width=9%>����ó��</td>
                    <td width=15%> 
                      <input type="text" name="ins_tel" value="<%=ma_bean.getIns_tel()%>" size="13" class=text maxlength="15" >
                    </td>
                    <td class=title width=9%>����ó��</td>
                    <td width=15%> 
                      <input type="text" name="ins_tel2" value="<%=ma_bean.getIns_tel2()%>" size="13" class=text maxlength="15" >
                    </td>
                    <td class=title width=9%>�ѽ�</td>
                    <td width=19%> 
                      <input type="text" name="ins_fax" value="<%=ma_bean.getIns_fax()%>" size="13" class=text maxlength="15" >
                    </td>
                </tr>
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
				<tr>
				  <td class=title>�ּ�</td>
				  <td colspan=7>
					<input type="text" name="t_zip" id="t_zip" size="7" maxlength='7' value="<%=ma_bean.getIns_zip()%>">
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr" size="100" value="<%=ma_bean.getIns_addr()%>">
				  </td>
				</tr>
                <tr> 
                    <td class=title>���</td>
                    <td colspan="7"> 
                      <input type="text" name="ins_etc" value="<%=ma_bean.getIns_etc()%>" size="110" class=text maxlength="200">
                    </td>
                </tr>
                <tr> 
                    <td class=title>÷�μ���</td>
                    <td colspan="7"> 
						<table cellspacing="2" cellpadding="2" border="0">
							<tr>
    							<td>[�⺻] �Ƹ���ī ����ڵ���� 1��, 
									�Ƹ���ī �ܱ�뿩���ǥ 1��, 
									�Ƹ���ī �������� ���� �纻 1��
								</td>
							</tr>
							
							<tr>
							    <td>
								  <%int s=0;
									String value[] = new String[11];
									
									if(!ma_bean.getApp_docs().equals("")){
								  		StringTokenizer st = new StringTokenizer(ma_bean.getApp_docs(),"^");
										
										while(st.hasMoreTokens()){
											value[s] = st.nextToken();
											s++;
										}
								  	}else{
										for(int i=0; i<11; i++){
											value[i] = "N";
										}
									}%>
								  [����]	
								  <br>
			                      <input type="checkbox" name="app_doc4"  value="Y" <%if(s>0 && value[3].equals("Y"))%>checked<%%>><%=d_var4%>
								  <input type="checkbox" name="app_doc5"  value="Y" <%if(s>0 && value[4].equals("Y"))%>checked<%%>><%=d_var5%>
								  <br>
								  <input type="checkbox" name="app_doc6"  value="Y" <%if(s>0 && value[5].equals("Y"))%>checked<%%>><%=d_var6%>
								  <input type="checkbox" name="app_doc7"  value="Y" <%if(s>0 && value[6].equals("Y"))%>checked<%%>><%=d_var7%>
								  <br>
								  <input type="checkbox" name="app_doc8"  value="Y" <%if(s>0 && value[7].equals("Y"))%>checked<%%>><%=d_var8%>								  
								  <br>
								  <input type="checkbox" name="app_doc10" value="Y" <%if(s>0 && value[9].equals("Y"))%>checked<%%>><%=d_var10%>
								  <input type="checkbox" name="app_doc11" value="Y" <%if(s>10 && value[10].equals("Y"))%>checked<%%>><%=d_var11%>
								  
								  <br><br>* ����������� ÷���� ������ üũ���ּ���.
								</td>
							</tr>
						</table>
                    </td>
                </tr>				
            </table>
        </td>
    </tr>    
	<%if(ti.getCar_mng_id().equals("")){%>
    <tr> 
        <td>&nbsp;</td>
        <td width="50%" align="right">
        	<a href="javascript:accid_tax()" title='û��������'><img src="/acar/images/center/button_cgsbh.gif" align="absmiddle" border="0"></a>
		&nbsp;&nbsp;<a href="javascript:DocSelect()" title='û�������ϰ��μ�'><img src="/acar/images/center/button_print_ig.gif" align="absmiddle" border="0"></a>		
		</td>
    </tr>	
	<%}else{%>	
    <tr> 
        <td>&nbsp; </td>
        <td align="right">
		<a href="javascript:DocPrint()" title='û�����μ�'><img src="/acar/images/center/button_print_cgs.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;		
		<%if(t_bean.getTax_no().equals("") && (nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ٺ�������",user_id) || nm_db.getWorkAuthUser("���ݰ�꼭�����",user_id) || nm_db.getWorkAuthUser("ä�ǰ�����",user_id) || user_id.equals(bus_id2))){%>	  
	  	<a href="javascript:ViewTaxItem()" title='�ŷ���������'><img src=/acar/images/center/button_modify_bill.gif align=absmiddle border=0></a>&nbsp;&nbsp;
	  	<%}%>
		<a href="javascript:MM_openBrWindow('�Ƹ���ī_��������_����纻.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src="/acar/images/center/button_tj.gif" align="absmiddle" border="0"></a>
		&nbsp;&nbsp;<a href="javascript:DocSelect()" title='û�������ϰ��μ�'><img src="/acar/images/center/button_print_ig.gif" align="absmiddle" border="0"></a>
		</td>
    </tr>	
	<%}%>
	<%
		Vector settles = s_db.getInsurHReqDocHistoryList(c_id, accid_id, seq_no);
		int settle_size = settles.size();%>
    <tr>
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������û������</span>
		<%	if(ma_bean.getDoc_req_dt().equals("")){%>
		<%		if(settle_size==0){%>&nbsp;<a href="javascript:accid_doc_req_msg()"><img src="/acar/images/center/button_send_smsdc.gif" align="absmiddle" border="0"></a>
		        					 &nbsp;<font color=green>(�����, �����, �ּ�, ÷�μ����� �� �Է��ϼ���.)</font>
		<%		}%>
		<%	}else{%>
		&nbsp;<font color=green><%=AddUtil.getDate3(ma_bean.getDoc_req_dt())%>�� ������û�����������Ƿ� �Ͽ���.</font>
		<%	}%>
		</td>
    </tr>
	<%	if(settle_size > 0){%>
    <tr><td class=line2 colspan=2></td></tr>
    <tr> 
        <td class="line" colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            	  <tr> 
            	    <td class='title' width=5%> ����</td>
		            <td class='title' width="15%">������ȣ</td>
		            <td class='title' width="15%">��������</td>
		            <td class='title' width="40%">����</td>
		            <td class='title' width="15%">����</td>
		            <td class='title' width="10%">�����</td>					
		          </tr>          
                </tr>
        		<%	for (int i = 0 ; i < settle_size ; i++){
						Hashtable settle = (Hashtable)settles.elementAt(i);%>		  
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td align='center'><a href="javascript:FineDocPrint('<%=settle.get("DOC_ID")%>')" onMouseOver="window.status=''; return true"><%=settle.get("DOC_ID")%></a></td>
			        <td align='center'><%=settle.get("DOC_DT")%></td>
			        <td align='center'><%=settle.get("GOV_NM")%></td>
			        <td align='center'><%=settle.get("MNG_DEPT")%> <%=settle.get("MNG_NM")%> <%=settle.get("MNG_POS")%></td>			
			        <td align='center'><%=settle.get("USER_NM")%></td>								
                </tr>
          		<%	}%>
            </table>
        </td>
    </tr>
	<%	}%>
    <tr><td class=h></td></tr>	
	<tr>
	    <td colspan="2" style='height:18'><font color=#666666>&nbsp;�� ������ȣ/���� : ������������</font> </td>
	</tr>			
	<tr>
	    <td colspan="2" style='height:18'><font color=#666666>&nbsp;�� [����ϱ�] : 1�� û������ �ݾ� ��� / [����] : ������ Ȯ�� (�������п� ���� 1�� �ݾ��� Ʋ�� �� ����. �������� �����ϼ���.)</font> </td>
	</tr>			
	<tr>
	    <td colspan="2" style='height:18'><font color=#666666>&nbsp;�� û���� ����� = û���� ������</font> </td>
	</tr>			
	<tr>
	    <td colspan="2" style='height:18'><font color=#666666>&nbsp;�� �Աݾװ� �Ա����ڴ� ȸ���������ڸ� ó���մϴ�.</font> </td>
	</tr>			
	<tr>
	    <td colspan="2" style='height:18'><font color=#red>&nbsp;�� ������� <font color=red>�ΰ��� ����</font>�� �ݾ��� û���մϴ�. /  ��꼭 �����Ƿڴ� <font color=red>û������</font>�� �ԷµǾ�� �� �� �ֽ��ϴ�.</font> </td>
	</tr>					
	<tr>
	    <td colspan="2" style='height:18'><font color=#666666>&nbsp;�� û������ �ϰ��μ� : �Ƹ���ī ����ڵ����/�ܱ�뿩���ǥ/����纻, ������� ��༭/�ڵ��������, �������� ��༭/�ڵ��������, û���� �ŷ������� �����Ͽ� �μ��Ҽ� �ֽ��ϴ�.</font> </td>
	</tr>			
	<tr>
	    <td colspan="2" style='height:18'><font color=#666666>&nbsp;�� û�����ڴ� �ѹ� �Է��ϸ� ������ �� �����ϴ�.</font> </td>
	</tr>			
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
