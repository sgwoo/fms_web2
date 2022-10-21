<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.consignment.*, acar.doc_settle.*, acar.car_register.*, acar.client.*, acar.cont.*, acar.car_mst.*, acar.car_office.*, acar.insur.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%-- <jsp:useBean id="ai_db" scope="page" class="acar.insur.InsDatabase"/> --%>
<%-- <jsp:useBean id="ins_bean" scope="page" class="acar.insur.InsurBean"/> --%>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//�α���ID&������ID&����
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "07", "02");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String cons_no 	= request.getParameter("cons_no")==null?"":request.getParameter("cons_no");
	String sub_l_cd1 = "";
	String sub_l_cd2 = "";
	String flag1 = "Y";
	String flag2 = "Y";
	String ins_change_std_dt1 = "";
	String ins_change_std_dt2 = "";
	String ins_change_flag1 = "";
	String ins_change_flag2 = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	
	//Ź���Ƿ� 1��
	ConsignmentBean b_cons = cs_db.getConsignment(cons_no, 1);
	
	ConsignmentBean b_cons2 = cs_db.getConsignment(cons_no, 2);
	
// 	String c_id1 = b_cons.getCar_mng_id();
// 	String c_id2 = b_cons2.getCar_mng_id();
	
// 	String ins_st1 = ai_db.getInsSt(c_id1);
// 	InsurBean ins1 = ai_db.getIns(c_id1, ins_st1);

// 	String ins_st2 = ai_db.getInsSt(c_id2);
// 	InsurBean ins2 = ai_db.getIns(c_id2, ins_st2);
	
// 	System.out.println("b_cons.getCons_cau() > " + b_cons.getCons_cau());

	// Ź��1�� ����/��� ������ ���
	if(b_cons.getCons_cau().equals("4") || b_cons.getCons_cau().equals("5")) {
// 		System.out.println("1����");
		// �� ������� ���� ���� ��ȸ 
		String cons_car_mng_id1 = b_cons.getCar_mng_id();
// 		System.out.println("cons_car_mng_id1 >> " + cons_car_mng_id1);
		sub_l_cd1 = b_cons.getSub_l_cd();
// 		System.out.println("sub_l_cd >> " + sub_l_cd1);
		String c_id1 = cs_db.getCarMngId(sub_l_cd1);
// 		System.out.println("car_mng_id >> " + c_id1);
		String ins_st = ai_db.getInsSt(c_id1); // ���� ������ ȸ�� ����
// 		System.out.println("ins_st >>>" + ins_st);
		acar.insur.InsurBean ins = ai_db.getIns(c_id1, ins_st);
// 		System.out.println("ins.getAge_scp() >>>"+ins.getAge_scp()); // ������� ���� ����
		// ������ ���� ������ ������ ���� 26������ � ���(21, 22��)
		if(ins.getAge_scp().equals("1") || ins.getAge_scp().equals("3") || ins.getAge_scp().equals("9")) {
			// ����� ���� �������� rent_cont�� ����� ������ �ִ� �� Ȯ���Ѵ�.
			Vector contRent = cs_db.getContRentList(sub_l_cd1, cons_car_mng_id1);
			int contRentSize = contRent.size();
// 			System.out.println("contRent.size() > " + contRent.size());
			if(contRent.size() < 1) {
				flag1="N";
			} else {
				for(int i=0; i<contRentSize; i++) {
					Hashtable cont_rent = (Hashtable)contRent.elementAt(i);
					ins_change_std_dt1 = String.valueOf(cont_rent.get("INS_CHANGE_STD_DT"));
					ins_change_flag1 = String.valueOf(cont_rent.get("INS_CHANGE_FLAG"));
// 					System.out.println("ins_change_std_dt1 >>" + ins_change_std_dt1);
// 				System.out.println("ins_change_flag1 >>" + ins_change_flag1);
				}
			}
		}
	  // Ź�� 1�� ���� ������ ���
	} else if(b_cons.getCons_cau().equals("3")) {
// 		System.out.println("1����(����)");
		String cons_car_mng_id1 = b_cons.getCar_mng_id();
// 		System.out.println("cons_car_mng_id1 >> " + cons_car_mng_id1);
		sub_l_cd1 = b_cons.getSub_l_cd();
// 		System.out.println("sub_l_cd >> " + sub_l_cd1);
		// sub_l_cd�� ��������� ���� ���� ��ȸ
		String drivingAge = cs_db.getDrivingAge(sub_l_cd1); // 0:26���̻� 1:21���̻� 2:���Ѿ��� 3:24���̻�
// 		System.out.println("drivingAge > " + drivingAge);
		
		// ������ ���� ������ ������ ���� 26������ � ���(21, 22��)
		if(drivingAge.equals("1") || drivingAge.equals("3")) {
			// ����� ���� �������� rent_cont�� ����� ������ �ִ� �� Ȯ���Ѵ�.
			Vector contRent = cs_db.getContRentList(sub_l_cd1, cons_car_mng_id1);
			int contRentSize = contRent.size();
// 			System.out.println(contRent.size());
			if(contRent.size() < 1) {
				flag1="N";
			} else {
				for(int i=0; i<contRentSize; i++) {
					Hashtable cont_rent = (Hashtable)contRent.elementAt(i);
					ins_change_std_dt1 = String.valueOf(cont_rent.get("INS_CHANGE_STD_DT"));
					ins_change_flag1 = String.valueOf(cont_rent.get("INS_CHANGE_FLAG"));
// 					System.out.println("ins_change_std_dt1 >>" + ins_change_std_dt1);
// 					System.out.println("ins_change_flag1 >>" + ins_change_flag1);
// 					System.out.println("ins_change_std_dt1 >>" + ins_change_std_dt1);
				}
			}
		}
	}
	
	// Ź��2�� ����/��� ������ ��� 
	if(b_cons2.getCons_cau().equals("4") || b_cons2.getCons_cau().equals("5")) {
// 		System.out.println("2����(����/���)");
		String cons_car_mng_id2 = b_cons2.getCar_mng_id();
// 		System.out.println("cons_car_mng_id2 >> " + cons_car_mng_id2);
		sub_l_cd2 = b_cons2.getSub_l_cd();
// 		System.out.println("sub_l_cd2 > " + sub_l_cd2);
		String c_id2 = cs_db.getCarMngId(sub_l_cd2);
// 		System.out.println("c_id2 > " + c_id2);
		String ins_st2 = ai_db.getInsSt(c_id2); // ���� ������ ȸ�� ����
// 		System.out.println("ins_st >>>" + ins_st2);
		acar.insur.InsurBean ins2 = ai_db.getIns(c_id2, ins_st2);
// 		System.out.println("ins2.getAge_scp() > " + ins2.getAge_scp()); // ������� ���� ����
		// ������ ���� ������ ������ ���� 26������ � ���(21, 22��)
		if(ins2.getAge_scp().equals("1") || ins2.getAge_scp().equals("3") || ins2.getAge_scp().equals("9")) {
			// ����� ���� �������� rent_cont�� ����� ������ �ִ� �� Ȯ���Ѵ�.
			Vector contRent2 = cs_db.getContRentList(sub_l_cd2, cons_car_mng_id2);
			int contRentSize2 = contRent2.size();
// 			System.out.println(contRent2.size());
			if(contRent2.size() < 1) {
				flag2="N";
			} else {
				for(int i=0; i<contRentSize2; i++) {
					Hashtable cont_rent2 = (Hashtable)contRent2.elementAt(i);
					ins_change_std_dt2= String.valueOf(cont_rent2.get("INS_CHANGE_STD_DT"));
					ins_change_flag2 = String.valueOf(cont_rent2.get("INS_CHANGE_FLAG"));
// 					System.out.println("ins_change_flag2 >>" + ins_change_flag2);
// 					System.out.println(ins_change_std_dt2);
				}
			}
		} 
	  // Ź��2�� ���������� ���
	} else if(b_cons2.getCons_cau().equals("3")) {
// 		System.out.println("2����(����)");
		String cons_car_mng_id2 = b_cons2.getCar_mng_id();
// 		System.out.println("cons_car_mng_id2 >> " + cons_car_mng_id2);
		sub_l_cd2 = b_cons2.getSub_l_cd();
// 		System.out.println("sub_l_cd >> " + sub_l_cd2);
		// sub_l_cd�� ��������� ���� ���� ��ȸ
		String drivingAge2 = cs_db.getDrivingAge(sub_l_cd2); // 0:26���̻� 1:21���̻� 2:���Ѿ��� 3:24���̻�
// 		System.out.println("drivingAge2 > " + drivingAge2);
		
		// ������ ���� ������ ������ ���� 26������ � ���(21, 22��)
		if(drivingAge2.equals("1") || drivingAge2.equals("3")) {
			// ����� ���� �������� rent_cont�� ����� ������ �ִ� �� Ȯ���Ѵ�.
			Vector contRent2 = cs_db.getContRentList(sub_l_cd2, cons_car_mng_id2);
			int contRentSize2 = contRent2.size();
// 			System.out.println(contRent2.size());
			if(contRent2.size() < 1) {
				flag2="N";
			} else {
				for(int i=0; i<contRentSize2; i++) {
					Hashtable cont_rent2 = (Hashtable)contRent2.elementAt(i);
					ins_change_std_dt2= String.valueOf(cont_rent2.get("INS_CHANGE_STD_DT"));
					ins_change_flag2 = String.valueOf(cont_rent2.get("INS_CHANGE_FLAG"));
// 					System.out.println("ins_change_flag2 >>" + ins_change_flag2);
// 					System.out.println(ins_change_std_dt2);
				}
			}
		} 
	}
	//������������� ���� �ö�� 
//	ContBaseBean 	base	= a_db.getCont(b_cons.getRent_mng_id(), b_cons.getRent_l_cd());
	
	//����ǰ��
	DocSettleBean doc = d_db.getDocSettleCommi("2", cons_no);
	
	//�Ƿ���
	UsersBean sender_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	//������
	UsersBean target_bean 	= new UsersBean();
	if(doc.getUser_id2().equals("")){
		target_bean = umd.getUsersBean(user_id);
		doc.setUser_id2(user_id);
	}else{
		target_bean = umd.getUsersBean(doc.getUser_id2());
	}
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
	
 	Vector  codes2 = new Vector();
	int c_size2 = 0;	
	/*
 	if (b_cons.getOff_id().equals("002740")||b_cons.getOff_id().equals("009217") ){
		codes2 = c_db.getCodeAllV_0022_New("0022");	
		c_size2 = codes2.size();
	} else	if ( b_cons.getOff_id().equals("010255")  ) {
		codes2 = c_db.getCodeAllV_0022_w("0022");	
		c_size2 = codes2.size();				
	} else {
		codes2 = c_db.getCodeAllV_0022_all("0022");	
		c_size2= codes2.size();
	}	
 	*/
 	 
 	codes2 = c_db.getCodeAllV_0022_all("0022");	
	c_size2= codes2.size();
	
	String white = "";
	String disabled = "";
	white = "white";
	disabled = "disabled";
	
	if(user_id.equals(doc.getUser_id2()) && !b_cons.getOff_nm().equals("(��)�Ƹ���ī")){
		white = "white";
		disabled = "disabled";
	}
	
	//ä�Ǿ絵������ �� ������
	Vector bond_trf_doc = cs_db.getBond_trf_doc(cons_no);
	int bond_trf_doc_size = bond_trf_doc.size();
	
	boolean userFlag = nm_db.getWorkAuthUser("������",user_id);
%>

<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script> -->
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//���̱��ϱ�
function cut_length(f,cut_len) {
	var fm = document.form1;	
	var max_len = f.length;
	var len = 0;
	var rf = "";
	for(k=0;k<max_len;k++) {
		t = f.charAt(k);
		if (escape(t).length > 4)
			len += 2;
		else
			len++;
		if(len <= cut_len){
			rf=rf+t;
		}
	}
	fm.sms_msg.value = rf;
}
	//����Ʈ
	function list(){
		var fm = document.form1;			
		if(fm.mode.value == 'doc_settle'){
			fm.action = '/fms2/doc_settle/doc_settle_frame.jsp';
		}else{
			if(fm.from_page.value == ''){
				fm.action = 'cons_rec_frame.jsp';
			}else{
				fm.action = fm.from_page.value;
			}
		}
		fm.target = 'd_content';
		fm.submit();
	}	

	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	

	//Ź�۾�ü ��ȸ
	function search_off()
	{
		window.open("/acar/cus0601/cus0602_frame.jsp?from_page=/fms2/consignment_new/cons_i_c.jsp", "SERV_OFF", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//Ź�۾�ü ����
	function view_off()
	{
		var fm = document.form1;
		if(fm.off_id.value == ""){ alert("���õ� Ź�۾�ü�� �����ϴ�."); return;}
		window.open("/acar/cus0601/cus0602_d_frame.jsp?from_page=/fms2/consignment_new/cons_i_c.jsp&off_id="+fm.off_id.value, "SERV_OFF", "left=10, top=10, width=900, height=250, scrollbars=yes, status=yes, resizable=yes");
	}		
		
	//�ڵ��� ��ȸ
	function search_car(idx)
	{
		window.open("/tax/pop_search/s_car.jsp?go_url=/fms2/consignment_new/cons_reg_step1.jsp&s_kd=2&idx="+idx, "CAR", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//�ڵ��� ����
	function view_car(idx)
	{
		var fm = document.form1;
		if(fm.off_id.value == ""){ alert("���õ� Ź�۾�ü�� �����ϴ�."); return;}
		if(fm.car_mng_id[idx].value == ""){ alert("���õ� �ڵ����� �����ϴ�."); return;}	
		window.open("/acar/car_register/car_view.jsp?rent_mng_id="+fm.rent_mng_id[idx].value+"&rent_l_cd="+fm.rent_l_cd[idx].value+"&car_mng_id="+fm.car_mng_id[idx].value+"&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}			

	//Ź�۱��п� ���� ����
	function cng_input(st){
		var fm = document.form1;
		
		var cons_su = toInt(fm.cons_su.value);
		
		if(cons_su == 1 && st == 2){
			fm.cons_su.value = 2;
			tr_cons1_1.style.display	= '';
			tr_cons1_2.style.display	= '';
			tr_cons1_3.style.display	= '';
			tr_cons1_4.style.display	= '';
			tr_cons1_5.style.display	= '';
		}		
	}	
	
	//��������� ���� ���÷���
	function cng_input2(cons_su){
		var fm = document.form1;		
		var cons_su = toInt(cons_su);
		
		return;
		
		if(cons_su >10){
			alert('�Է°����� �ִ�Ǽ��� 10�� �Դϴ�.');
			return;
		}		
		
		<%for(int i=1;i<3;i++){%>
		if(cons_su > <%=i%>){
			tr_cons<%=i%>_1.style.display	= '';
			tr_cons<%=i%>_2.style.display	= '';			
			tr_cons<%=i%>_3.style.display	= '';
			tr_cons<%=i%>_4.style.display	= '';
			tr_cons<%=i%>_5.style.display	= '';
		}else{
			tr_cons<%=i%>_1.style.display	= 'none';
			tr_cons<%=i%>_2.style.display	= 'none';
			tr_cons<%=i%>_3.style.display	= 'none';
			tr_cons<%=i%>_4.style.display	= 'none';
			tr_cons<%=i%>_5.style.display	= 'none';
		}
		<%}%>			
			
	}		
	
	//���/���� ���п� ���� �˾�
	function cng_input3(st, value, idx){
		var fm = document.form1;		
		var width 	= 600;
		var height 	= 400;
		var firm_nm = '';				
		var req_id 	= fm.req_id.value;
		var s_kd 	= '1';
				
		if(st == 'from' && fm.from_st[idx].value == ''){		alert('��� ������ �����Ͻʽÿ�.'); 	return;		}
		if(st == 'to' && fm.to_st[idx].value == ''){			alert('���� ������ �����Ͻʽÿ�.'); 	return;		}

		if(value == '2'){ 
			width 	= 800;
			firm_nm = fm.firm_nm[idx].value;
			if(firm_nm == '�Ƹ���ī' || firm_nm == '(��)�Ƹ���ī'){
				firm_nm = fm.car_no[idx].value;
				s_kd = '2';
			}
		}
		
		window.open("s_place.jsp?go_url=/fms2/consignment_new/cons_reg_step1.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd="+s_kd+"&t_wd="+firm_nm+"&req_id="+req_id, "PLACE", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");		
	}			
	
	//���/���� ����� ��ȸ
	function cng_input5(st, value, idx){
		var fm = document.form1;		
		var width 	= 600;
		var height 	= 500;
		var firm_nm = '';
		
		if(st == 'from' && fm.from_st[idx].value == ''){		alert('��� ������ �����Ͻʽÿ�.'); 	return;		}
		if(st == 'to' && fm.to_st[idx].value == ''){			alert('���� ������ �����Ͻʽÿ�.'); 	return;		}

		if(st == 'from')		firm_nm 	= fm.from_comp[idx].value;
		if(st == 'to')			firm_nm 	= fm.to_comp[idx].value;
		
		if(firm_nm == ''){ 		alert('������ �����Ͽ� ��Ҹ� ���� �����Ͽ� �ֽʽÿ�.'); 	return; }
		
		if(value == '1') 		firm_nm 	= replaceString('(��)�Ƹ���ī ','',firm_nm);
		
		if(value == '3'){		alert('���¾�ü�� ����� �˻��� �����ϴ�.');	return; }
		
		window.open("s_man.jsp?go_url=/fms2/consignment_new/cons_reg_step1.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd=1&t_wd="+firm_nm+"&rent_mng_id="+fm.rent_mng_id[idx].value+"&rent_l_cd="+fm.rent_l_cd[idx].value+"&car_no="+fm.car_no[idx].value, "MAN", "left=10, top=10, width="+width+", height=500, scrollbars=yes, status=yes, resizable=yes");		
	}			
	
	//������ ��ȸ
	function cng_input6(st, value, idx){
		var fm = document.form1;	
		var width 	= 400;
		var height 	= 700;		
		var firm_nm = '<%=b_cons.getOff_nm()%>';
		if('<%=b_cons.getOff_id()%>' == '003158'){
			width 	= 600;
			height 	= 700;
			value = '4';
			s_kd  = 2;
			if(<%=b_cons.getCons_su()%> > 1){
				if(fm.driver_nm[idx].value != '')		firm_nm = fm.driver_nm[idx].value;
				else									firm_nm = '';
			}else{
				if(fm.driver_nm.value != '')			firm_nm = fm.driver_nm.value;
				else									firm_nm = '';			
			}
			alert(firm_nm);
			window.open("s_man.jsp?go_url=/fms2/consignment_new/cons_reg_step2.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd="+s_kd+"&t_wd="+firm_nm+"&size=<%=b_cons.getCons_su()%>", "MAN", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");					
		}else{				
			window.open("s_man.jsp?go_url=/fms2/consignment_new/cons_reg_step2.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd=1&t_wd="+firm_nm+"&size=<%=b_cons.getCons_su()%>", "MAN", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");		
		}
	}			
		
	//Ź�ۻ����� ����
	function cng_input4(value, idx){
		
		if(value == "3" || value == "4" || value == "5") {
			$("[name=search]").eq(idx).css('display','inline-block');
			$("[name=sub_car_no]").eq(idx).css('display','inline-block');
			$("[name=car_no_text]").eq(idx).css('display','inline-block');
		} else {
			$("[name=search]").eq(idx).css('display','none');
			$("[name=sub_car_no]").eq(idx).css('display','none');
			$("[name=car_no_text]").eq(idx).css('display','none');
		}
		// ���� ���� �� sub_l_cd �ʱ�ȭ
		$("[name=sub_rent_l_cd]").eq(idx).val("");
		$("[name=sub_car_no]").eq(idx).val("");
		
		var fm = document.form1;		
		if(value != '20'){
			fm.cost_st[idx].value 	= '1';
			fm.pay_st[idx].value 	= '2';
		}
		if(value == '1' || value == '2' || value == '3' || value == '4' || value == '5' || value == '6' || value == '7' || value == '15' || value == '16'){
			fm.from_st[idx].value 	= '1';
			fm.to_st[idx].value 	= '2';
		}
		if(value == '8' || value == '9' || value == '10' || value == '11' || value == '12' || value == '13' || value == '14' || value == '17'){
			fm.from_st[idx].value 	= '2';
			fm.to_st[idx].value 	= '1';		
		}		
	}				
	
	//�����Ͻ� ����
	function cng_input7(st, idx){
		var fm = document.form1;	
		
		if(st == 'from'){
			if(fm.from_est_chk[idx].checked == true){
				fm.from_est_dt[idx].value 	= fm.from_req_dt[idx].value;
				fm.from_est_h[idx].value 	= fm.from_req_h[idx].value;
				fm.from_est_s[idx].value 	= fm.from_req_s[idx].value;		
				
				if(fm.to_est_dt[idx].value == ''){
					fm.to_est_dt[idx].value 	= fm.from_req_dt[idx].value;
					fm.to_est_h[idx].value 		= fm.from_req_h[idx].value;
					fm.to_est_s[idx].value 		= fm.from_req_s[idx].value;														
				}				
			}	
		}else{
			if(fm.to_est_chk[idx].checked == true){		
				fm.to_est_dt[idx].value 	= fm.to_req_dt[idx].value;
				fm.to_est_h[idx].value 		= fm.to_req_h[idx].value;
				fm.to_est_s[idx].value 		= fm.to_req_s[idx].value;									
			}
		}
	}
	
	//Ź�۳��� �����ϱ�
	function value_copy(idx){
		var fm = document.form1;
		
		//��������Ÿ ��ȣ
		var copy_idx = toInt(fm.cons_copy[idx].value)-1;
		
		fm.cons_cau[idx].value 		= fm.cons_cau[copy_idx].value;
		fm.cost_st[idx].value 		= fm.cost_st[copy_idx].value;
		fm.pay_st[idx].value 		= fm.pay_st[copy_idx].value;
		
		fm.from_st[idx].value 		= fm.from_st[copy_idx].value;								
		fm.from_place[idx].value 	= fm.from_place[copy_idx].value;
		fm.from_comp[idx].value 	= fm.from_comp[copy_idx].value;		
		fm.from_title[idx].value 	= fm.from_title[copy_idx].value;
		fm.from_man[idx].value 		= fm.from_man[copy_idx].value;
		fm.from_tel[idx].value 		= fm.from_tel[copy_idx].value;
		fm.from_m_tel[idx].value 	= fm.from_m_tel[copy_idx].value;
		fm.from_req_dt[idx].value 	= fm.from_req_dt[copy_idx].value;
		fm.from_req_h[idx].value 	= fm.from_req_h[copy_idx].value;
		fm.from_req_s[idx].value 	= fm.from_req_s[copy_idx].value;
		
		fm.to_st[idx].value 		= fm.to_st[copy_idx].value;				
		fm.to_place[idx].value 		= fm.to_place[copy_idx].value;
		fm.to_comp[idx].value 		= fm.to_comp[copy_idx].value;		
		fm.to_title[idx].value 		= fm.to_title[copy_idx].value;
		fm.to_man[idx].value 		= fm.to_man[copy_idx].value;
		fm.to_tel[idx].value 		= fm.to_tel[copy_idx].value;
		fm.to_m_tel[idx].value 		= fm.to_m_tel[copy_idx].value;
		fm.to_req_dt[idx].value 	= fm.to_req_dt[copy_idx].value;
		fm.to_req_h[idx].value 		= fm.to_req_h[copy_idx].value;
		fm.to_req_s[idx].value 		= fm.to_req_s[copy_idx].value;
		
		fm.wash_yn[idx].value 		= fm.wash_yn[copy_idx].value;
		fm.oil_yn[idx].value 		= fm.oil_yn[copy_idx].value;
		fm.oil_liter[idx].value 	= fm.oil_liter[copy_idx].value;
		fm.oil_est_amt[idx].value 	= fm.oil_est_amt[copy_idx].value;
		fm.etc[idx].value 			= fm.etc[copy_idx].value;		
		
	}	
	
	//Ź�۳��� �����ϱ� - �պ�ó��
	function value_copy2(idx){
		var fm = document.form1;
		
		
		//��������Ÿ ��ȣ
		var copy_idx = toInt(fm.cons_copy[idx].value)-1;

		if(fm.cons_cau[copy_idx].value == '1') 	fm.cons_cau[idx].value = '8';
		if(fm.cons_cau[copy_idx].value == '8') 	fm.cons_cau[idx].value = '1';
		if(fm.cons_cau[copy_idx].value == '4') 	fm.cons_cau[idx].value = '11';
		if(fm.cons_cau[copy_idx].value == '11') fm.cons_cau[idx].value = '4';
		if(fm.cons_cau[copy_idx].value == '9') 	fm.cons_cau[idx].value = '6';
		if(fm.cons_cau[copy_idx].value == '6') 	fm.cons_cau[idx].value = '9';
		if(fm.cons_cau[copy_idx].value == '5') 	fm.cons_cau[idx].value = '12';
		if(fm.cons_cau[copy_idx].value == '12') fm.cons_cau[idx].value = '5';
		if(fm.cons_cau[copy_idx].value == '10') fm.cons_cau[idx].value = '10';
		if(fm.cons_cau[copy_idx].value == '7') 	fm.cons_cau[idx].value = '7';
		
		fm.cost_st[idx].value 		= fm.cost_st[copy_idx].value;
		fm.pay_st[idx].value 		= fm.pay_st[copy_idx].value;

		fm.to_st[idx].value 		= fm.from_st[copy_idx].value;						
		fm.to_place[idx].value 		= fm.from_place[copy_idx].value;
		fm.to_comp[idx].value 		= fm.from_comp[copy_idx].value;		
		fm.to_title[idx].value 		= fm.from_title[copy_idx].value;
		fm.to_man[idx].value 		= fm.from_man[copy_idx].value;
		fm.to_tel[idx].value 		= fm.from_tel[copy_idx].value;
		fm.to_m_tel[idx].value 		= fm.from_m_tel[copy_idx].value;
		fm.to_req_dt[idx].value 	= fm.from_req_dt[copy_idx].value;
		fm.to_req_h[idx].value 		= fm.from_req_h[copy_idx].value;
		fm.to_req_s[idx].value 		= fm.from_req_s[copy_idx].value;
		
		fm.from_st[idx].value 		= fm.to_st[copy_idx].value;		
		fm.from_place[idx].value 	= fm.to_place[copy_idx].value;
		fm.from_comp[idx].value 	= fm.to_comp[copy_idx].value;		
		fm.from_title[idx].value 	= fm.to_title[copy_idx].value;
		fm.from_man[idx].value 		= fm.to_man[copy_idx].value;
		fm.from_tel[idx].value 		= fm.to_tel[copy_idx].value;
		fm.from_m_tel[idx].value 	= fm.to_m_tel[copy_idx].value;
		fm.from_req_dt[idx].value 	= fm.to_req_dt[copy_idx].value;
		fm.from_req_h[idx].value 	= fm.to_req_h[copy_idx].value;
		fm.from_req_s[idx].value 	= fm.to_req_s[copy_idx].value;
		
		fm.wash_yn[idx].value 		= fm.wash_yn[copy_idx].value;
		fm.oil_yn[idx].value 		= fm.oil_yn[copy_idx].value;
		fm.oil_liter[idx].value 	= fm.oil_liter[copy_idx].value;
		fm.oil_est_amt[idx].value 	= fm.oil_est_amt[copy_idx].value;
		fm.etc[idx].value 			= fm.etc[copy_idx].value;		
		
	}		
	
	function doc_sanction(doc_bit){
		var fm = document.form1;
		var size = toInt(fm.cons_su.value);
		var vali_switch = true;
		var cons_cau1 = $("[name=cons_cau]").eq(0).val(); // Ź��1 ����
		var cons_cau2 = $("[name=cons_cau]").eq(1).val(); // Ź��2 ����
		var ins_change_flag1 = '<%=ins_change_flag1%>';
		var ins_change_flag2 = '<%=ins_change_flag2%>';
		
		var ment = "";
		
		if(cons_cau1 == "3") {
			ment = "���� ����";
		} else if(cons_cau1 == "4") {
			ment = "���� ����";
		} else if(cons_cau1 == "5") {
			ment = "��� ����";
		}
		
// 		fm.doc_bit.value = doc_bit;
		if($('input:radio[name=cons_st]').eq(0).is(':checked') == true) {
			if(cons_cau1 == "3" || cons_cau1 == "4" || cons_cau1 == "5") {
				if(ins_change_flag1 != "N"){
					// ��
					var flag1 = '<%=flag1%>';
					if(flag1 == 'N') {
						alert("Ź��1 ������ ��ϵ� "+ment+" ���� ������ �����ϴ�.\n��������>��������>����������� ���� ���� �� Ź�� ������ �ּ���.\n���� ������ ���� ���� ��� ������ �� �����ϴ�.");
						return;
					} else {
						var ins_change_std_dt1 = parseInt('<%=ins_change_std_dt1%>');
						var from_est_dt1 = $("[name=from_est_dt]").eq(0).val();
				 		from_est_dt1 = parseInt(from_est_dt1.replaceAll('-',''));
						if(from_est_dt1 <= ins_change_std_dt1) {
							alert("Ź��1�� ���ڴ� ���� ������ ���� ���� ������("+ins_change_std_dt1+")���� �����ų� ���� �� �����ϴ�.");
							return;
						}
					}
				}
			}
		} else {
			if(cons_cau1 == "3" || cons_cau1 == "4" || cons_cau1 == "5") {
				if(ins_change_flag1 != "N"){
					// �պ�
					var flag1 = '<%=flag1%>';
					if(flag1 == 'N') {
						alert("Ź��1 ������ ��ϵ� "+ment+" ���� ������ �����ϴ�.\n��������>��������>����������� ���� ���� �� Ź�� ������ �ּ���.\n���� ������ ���� ���� ��� ������ �� �����ϴ�.");
						return;
					} else {
						var ins_change_std_dt1 = parseInt('<%=ins_change_std_dt1%>');
						var from_est_dt1 = $("[name=from_est_dt]").eq(0).val();
				 		from_est_dt1 = parseInt(from_est_dt1.replaceAll('-',''));
						if(from_est_dt1 <= ins_change_std_dt1) {
							alert("Ź��1�� ���ڴ� ���� ������ ���� ���� ������("+ins_change_std_dt1+")���� �����ų� ���� �� �����ϴ�.");
							return;
						}
					}
				}
			}
			if(cons_cau2 == "3" || cons_cau2 == "4" || cons_cau2 == "5") {
				if(ins_change_flag2 != "N"){
					// �պ�
					var flag2 = '<%=flag2%>';
					if(flag2 == 'N') {
						alert("Ź��2 ������ ��ϵ� "+ment+" ���� ������ �����ϴ�.\n��������>��������>����������� ���� ���� �� Ź�� ������ �ּ���.\n���� ������ ���� ���� ��� ������ �� �����ϴ�.");
						return;
					} else {
						var ins_change_std_dt2 = parseInt('<%=ins_change_std_dt2%>');
						var from_est_dt2 = $("[name=from_est_dt]").eq(1).val();
				 		from_est_dt2 = parseInt(from_est_dt2.replaceAll('-',''));
						if(from_est_dt2 <= ins_change_std_dt2) {
							alert("Ź��2�� ���ڴ� ���� ������ ���� ���� ������("+ins_change_std_dt2+")���� �����ų� ���� �� �����ϴ�.");
							return;
						}
					}
				}
			}
		}
		// ************* ���� �ּ� ���� �ʿ� *************
// 		return;
		
		if(size >1){
			for(i=0; i<size ; i++){
				if(fm.from_est_dt[i].value == "" || fm.from_est_h[i].value == "" || fm.from_est_s[i].value == "") 	{ 	alert((i+1)+"�� Ź�� : ���-�����Ͻø� �Է��Ͻʽÿ�."); 	return;	}					
				if(fm.to_est_dt[i].value == ""   || fm.to_est_h[i].value == ""   || fm.to_est_s[i].value == "") 	{ 	alert((i+1)+"�� Ź�� : ����-�����Ͻø� �Է��Ͻʽÿ�."); 	return;	}			
				if(fm.driver_nm[i].value == "") 	{ 	alert((i+1)+"�� Ź�� : �����ڸ��� �Է��Ͻʽÿ�."); 		return;	}
				if(fm.driver_m_tel[i].value == "") 	{ 	alert((i+1)+"�� Ź�� : �������ڵ����� �Է��Ͻʽÿ�."); 	return;	}
				if(fm.off_id.value == '003158'){
					if(fm.driver_nm[i].value != "" && fm.driver_id[i].value == "") { 		alert((i+1)+"�� Ź�� : �����ڸ� ��ȸ�Ͽ� �����Ͻʽÿ�."); 	return;	}
				}
			}
		}else{
// 			console.log(" 1 : "+fm.from_est_dt.value);
// 			console.log(" 2 : "+fm.from_est_h.value);
// 			console.log(" 3 : "+fm.from_est_s.value);
				var i=0;
				//if(fm.from_est_dt.value == "" || fm.from_est_h.value == "" || fm.from_est_s.value == "") 	{ 	alert((i+1)+"�� Ź�� : ���-�����Ͻø� �Է��Ͻʽÿ�."); 	return;	}					
				//if(fm.to_est_dt.value == ""   || fm.to_est_h.value == ""   || fm.to_est_s.value == "") 		{ 	alert((i+1)+"�� Ź�� : ����-�����Ͻø� �Է��Ͻʽÿ�."); 	return;	}			
				//if(fm.driver_nm.value == "") 		{ 	alert((i+1)+"�� Ź�� : �����ڸ��� �Է��Ͻʽÿ�."); 		return;	}
				//if(fm.driver_m_tel.value == "") 	{ 	alert((i+1)+"�� Ź�� : �������ڵ����� �Է��Ͻʽÿ�."); 	return;	}
				if(fm.off_id.value == '003158'){
					if(fm.driver_nm.value != "" && fm.driver_id.value == "") { 	alert("1�� Ź�� : �����ڸ� ��ȸ�Ͽ� �����Ͻʽÿ�."); 	return;	}
				}
		}
		// Ź�ۻ����� ȸ���� ���Եǰų� ����ݳ��� ��쿡�� ��� ������ ���� ���� �ڵ��� ��ȣ�� �ݵ�� ���� �Ѵ�. 2018.03.13
		$("select[name=cons_cau] option:selected").each(function(i, selected){
			var cons_cau_val = $(selected).text();
			if(cons_cau_val.indexOf("ȸ��")>0 || cons_cau_val.indexOf("��ݳ�")>0){
				if(fm.from_st[i].value==2){// ��� ������ ���� ���
					if(fm.from_m_tel[i].value.length < 11) {
						if($("input[name=cons_st]:checked").val()==1){
							if(i==1) {
								return false;
							}
						}
						alert((i+1)+"�� Ź�� : ���-����ó �ڵ��� ��ȣ�� �Է��Ͻʽÿ�.");
						vali_switch = false;
						fm.from_m_tel[i].focus();
						return false;
					}
				}
			}
		});
				
		if(vali_switch){
			if(confirm('�����Ͻðڽ��ϱ�?')){	
				fm.action='cons_reg_step2_a.jsp';		
//				fm.target='i_no';
				fm.target='d_content';
				fm.submit();
			} 	
		}
		
	}	
	
	function save(){
		var fm = document.form1;
		var size = toInt(fm.cons_su.value);
		
// 		var from_req_dt1 = $("[name=from_req_dt]").eq(0).val();
// 		from_req_dt1 = parseInt(from_req_dt1.replaceAll('-',''));
// 		var from_req_dt2 = $("[name=from_req_dt]").eq(1).val();
// 		from_req_dt2 = parseInt(from_req_dt2.replaceAll('-',''));
		
// 		alert(from_req_dt1);
// 		alert(from_req_dt2);
		
// 		return;
		
		var cons_cau1 = $("[name=cons_cau]").eq(0).val(); // Ź��1 ����
		var cons_cau2 = $("[name=cons_cau]").eq(1).val(); // Ź��2 ����
		var ins_change_flag1 = '<%=ins_change_flag1%>';
		var ins_change_flag2 = '<%=ins_change_flag2%>';
		
		if($('input:radio[name=cons_st]').eq(0).is(':checked') == true) {
			// ��
			if(cons_cau1 == "3" || cons_cau1 == "4" || cons_cau1 == "5") {
				if(!$("[name=sub_rent_l_cd]").eq(0).val()) {
					alert("Ź�� ������ ����/����/���/���� �ε��� ��� �� ����� ������ �����ؾ� �մϴ�.");
					return;
				}
			}
		} else {
			// �պ�
			if(cons_cau1 == "3" || cons_cau1 == "4" || cons_cau1 == "5") {
				if(!$("[name=sub_rent_l_cd]").eq(0).val()) {
					alert("Ź�� ������ ����/����/���/���� �ε��� ��� �� ����� ������ �����ؾ� �մϴ�.");
					return;
				}
			}
			
			if(cons_cau2 == "3" || cons_cau2 == "4" || cons_cau2 == "5") {
				if(!$("[name=sub_rent_l_cd]").eq(1).val()) {
					alert("Ź�� ������ ����/����/���/���� �ε��� ��� �� ����� ������ �����ؾ� �մϴ�.");
					return;
				}
			} 
		}
		
		if($('input:radio[name=cons_st]').eq(0).is(':checked') == true) {
			if(cons_cau1 == "3" || cons_cau1 == "4" || cons_cau1 == "5") {
					if(ins_change_flag1 != "N"){
					// ��
					var flag1 = '<%=flag1%>';
					if(flag1 == 'N') {
						alert("��ϵ� ���� ������ �����ϴ�. \n����������� ���� ���� �� Ź�� ������ �ּ���.");
						return;
					} else {
						var ins_change_std_dt1 = parseInt('<%=ins_change_std_dt1%>');
						var from_req_dt1 = $("[name=from_req_dt]").eq(0).val();
				 		from_req_dt1 = parseInt(from_req_dt1.replaceAll('-',''));
	// 					alert(ins_change_std_dt1);
	// 					alert(from_req_dt1);
						if(from_req_dt1 <= ins_change_std_dt1) {
							alert("Ź�� ��û�Ͻô� ���� ������ ���� ���� ������ ���� �����ų� ���� �� �����ϴ�.");
							 return;
						}
					}
				}
			}
		} else {
			if(cons_cau1 == "3" || cons_cau1 == "4" || cons_cau1 == "5") {
				if(ins_change_flag1 != "N"){
					// �պ�
					var flag1 = '<%=flag1%>';
					if(flag1 == 'N') {
						alert("Ź��1 ������ ��ϵ� ���� ������ �����ϴ�. \n����������� ���� ���� �� Ź�� ������ �ּ���.");
						return;
					} else {
						var ins_change_std_dt1 = parseInt('<%=ins_change_std_dt1%>');
						var from_req_dt1 = $("[name=from_req_dt]").eq(0).val();
				 		from_req_dt1 = parseInt(from_req_dt1.replaceAll('-',''));
	// 					alert(ins_change_std_dt1);
	// 					alert(from_est_dt1);
						if(from_req_dt1 <= ins_change_std_dt1) {
							alert("Ź��1�� ���ڴ� ���� ������ ���� ���� ������ ���� �����ų� ���� �� �����ϴ�.");
							 return;
						}
					}
				}
			}
			if(cons_cau2 == "3" || cons_cau2 == "4" || cons_cau2 == "5") {
				if(ins_change_flag2 != "N"){
					// �պ�
					var flag2 = '<%=flag2%>';
					if(flag2 == 'N') {
						alert("Ź��2 ������ ��ϵ� ���� ������ �����ϴ�. \n����������� ���� ���� �� Ź�� ������ �ּ���.");
						return;
					} else {
						var ins_change_std_dt2 = parseInt('<%=ins_change_std_dt2%>');
						var from_req_dt2 = $("[name=from_req_dt]").eq(1).val();
				 		from_req_dt2 = parseInt(from_req_dt2.replaceAll('-',''));
// 						alert(ins_change_std_dt2);
// 						alert(from_est_dt2);
						if(from_req_dt2 <= ins_change_std_dt2) {
							alert("Ź��2�� ���ڴ� ���� ������ ���� ���� ������ ���� �����ų� ���� �� �����ϴ�.");
							 return;
						}
					}
				}
			}
		}
		
		if(fm.off_id.value == "")	{ 	alert("���õ� Ź�۾�ü�� �����ϴ�."); 	return;	}
		if(fm.cons_su.value == "")	{ 	alert("��������� �Է��Ͻʽÿ�."); 		return;	}
		if(fm.cons_su.value == "0")	{ 	alert("��������� �Է��Ͻʽÿ�."); 		return;	}
		
		<% if(!userFlag) {%>
		if($("input[name=driver_nm]").eq(0).val() || $("input[name=driver_nm]").eq(1).val()) {
			alert("Ź�� ��簡 �����Ǿ����ϴ�. Ź�ۻ翡 �����ϼ���.");
			return;
		}
		<%}%>
				
		if ( size > 1) { //�պ� 
		
			for(i=0; i<size ; i++){
			
				if(fm.off_id.value == '002740' || fm.off_id.value == '003158' || fm.off_id.value == '009217' || fm.off_id.value == '010255' ){  //����Ź��, �Ƹ���ī, �Ƹ���Ź��, ������TS  �� ��� �ʼ�
				//if(fm.off_id.value == '003158'||fm.off_id.value == '009217'){
					if(fm.cmp_app[i].value == "" || fm.cmp_app[i].value == "S00" || fm.cmp_app[i].value == "D00" || fm.cmp_app[i].value == "B00" || fm.cmp_app[i].value == "C00" || fm.cmp_app[i].value == "E00"  || fm.cmp_app[i].value == "F00"  || fm.cmp_app[i].value == "T00" || fm.cmp_app[i].value == "W00" ){	alert('Ź�۱����� �����Ͻʽÿ�.');	return;} 
				//	if(fm.cmp_app[i].value == "" || fm.cmp_app[i].value == "S00" || fm.cmp_app[i].value == "D00" || fm.cmp_app[i].value == "B00"){	alert('Ź�۱����� �����Ͻʽÿ�.');	return;}
				}
	
				if(fm.car_no[i].value == "") 		{ 	alert((i+1)+"�� Ź�� : ���õ� ������ �����ϴ�."); 			return;	}
				if(fm.req_id[i].value == "")		{ 	alert((i+1)+"�� �Ƿ��ڸ� �Է��Ͻʽÿ�."); 					return;	}				
				if(fm.cons_cau[i].value == "") 		{ 	alert((i+1)+"�� Ź�� : Ź�ۻ����� �Է��Ͻʽÿ�."); 			return;	}
				if(fm.cons_cau[i].value == "20" && fm.cons_cau_etc[i].value == "") 
													{ 	alert((i+1)+"�� Ź�� : Ź�ۻ��� ��Ÿ�� �Է��Ͻʽÿ�."); 	return;	}
				if(fm.cost_st[i].value == "") 		{ 	alert((i+1)+"�� Ź�� : ��뱸���� �����Ͻʽÿ�."); 			return;	}
				if(fm.pay_st[i].value == "") 		{ 	alert((i+1)+"�� Ź�� : ���ޱ����� �����Ͻʽÿ�."); 			return;	}
				//if(fm.from_st[i].value == "") 	{ 	alert(i+"�� Ź�� : ���-������ �����Ͻʽÿ�."); 		return;	}
				if(fm.from_place[i].value == "") 	{ 	alert((i+1)+"�� Ź�� : ���-��Ҹ� �Է��Ͻʽÿ�."); 		return;	}
				if(fm.from_comp[i].value == "") 	{ 	alert((i+1)+"�� Ź�� : ���-��ȣ/������ �Է��Ͻʽÿ�."); 	return;	}
				if(fm.from_req_dt[i].value == "" || fm.from_req_h[i].value == "" || fm.from_req_s[i].value == "") 	
													{ 	alert((i+1)+"�� Ź�� : ���-��û�Ͻø� �Է��Ͻʽÿ�."); 	return;	}
				//if(fm.to_st[i].value == "") 		{ 	alert(i+"�� Ź�� : ����-������ �����Ͻʽÿ�."); 		return;	}
				if(fm.to_place[i].value == "") 		{ 	alert((i+1)+"�� Ź�� : ����-��Ҹ� �Է��Ͻʽÿ�."); 		return;	}
				if(fm.to_comp[i].value == "") 		{ 	alert((i+1)+"�� Ź�� : ����-��ȣ/������ �Է��Ͻʽÿ�."); 	return;	}
				if(fm.to_req_dt[i].value == "" || fm.to_req_h[i].value == "" || fm.to_req_s[i].value == "") 		
													{ 	alert((i+1)+"�� Ź�� : ����-��û�Ͻø� �Է��Ͻʽÿ�."); 	return;	}
			}
		} else { //�� 
			if(fm.off_id.value == '002740' || fm.off_id.value == '003158' || fm.off_id.value == '009217' || fm.off_id.value == '010255' ){  //����Ź��, �Ƹ���ī, �Ƹ���Ź��, ������TS  �� ��� �ʼ�
		//	if(fm.off_id.value == '003158'||fm.off_id.value == '009217'){
			//	alert(fm.cmp_app.value);
				if(fm.cmp_app.value == "" || fm.cmp_app.value == "S00" || fm.cmp_app.value == "D00" || fm.cmp_app.value == "B00" || fm.cmp_app.value == "C00" || fm.cmp_app.value == "E00"  || fm.cmp_app.value == "F00"  || fm.cmp_app.value == "W00"  || fm.cmp_app.value == "T00" ){	alert('Ź�۱����� �����Ͻʽÿ�.');	return;}
			}

			if(fm.car_no.value == "") 		{ 	alert("1�� Ź�� : ���õ� ������ �����ϴ�."); 			return;	}
			if(fm.req_id.value == "")		{ 	alert("1�� �Ƿ��ڸ� �Է��Ͻʽÿ�."); 					return;	}				
			if(fm.cons_cau.value == "") 		{ 	alert("1�� Ź�� : Ź�ۻ����� �Է��Ͻʽÿ�."); 			return;	}
			if(fm.cons_cau.value == "20" && fm.cons_cau_etc.value == "") 
												{ 	alert("1�� Ź�� : Ź�ۻ��� ��Ÿ�� �Է��Ͻʽÿ�."); 	return;	}
			if(fm.cost_st.value == "") 		{ 	alert("1�� Ź�� : ��뱸���� �����Ͻʽÿ�."); 			return;	}
			if(fm.pay_st.value == "") 		{ 	alert("1�� Ź�� : ���ޱ����� �����Ͻʽÿ�."); 			return;	}
		
			if(fm.from_place.value == "") 	{ 	alert("1�� Ź�� : ���-��Ҹ� �Է��Ͻʽÿ�."); 		return;	}
			if(fm.from_comp.value == "") 	{ 	alert("1�� Ź�� : ���-��ȣ/������ �Է��Ͻʽÿ�."); 	return;	}
			if(fm.from_req_dt.value == "" || fm.from_req_h.value == "" || fm.from_req_s.value == "") 	
												{ 	alert("1�� Ź�� : ���-��û�Ͻø� �Է��Ͻʽÿ�."); 	return;	}
		
			if(fm.to_place.value == "") 		{ 	alert("1�� Ź�� : ����-��Ҹ� �Է��Ͻʽÿ�."); 		return;	}
			if(fm.to_comp.value == "") 		{ 	alert("1�� Ź�� : ����-��ȣ/������ �Է��Ͻʽÿ�."); 	return;	}
			if(fm.to_req_dt.value == "" || fm.to_req_h.value == "" || fm.to_req_s.value == "") 		
												{ 	alert("1�� Ź�� : ����-��û�Ͻø� �Է��Ͻʽÿ�."); 	return;	}
		}
		
		if(confirm('�����Ͻðڽ��ϱ�?')){		
			fm.action='cons_reg_step2_a.jsp';
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}		
	}
	
	function cons_delete(mode, seq){
		var fm = document.form1;
		
		fm.mode.value = mode;
		fm.del_seq.value = seq;
		
		<% if(!userFlag) {%>
		if($("input[name=driver_nm]").eq(0).val() || $("input[name=driver_nm]").eq(1).val()) {
			alert("Ź�� ��簡 �����Ǿ����ϴ�. Ź�ۻ翡 �����ϼ���.");
			return;
		}
		<%}%>
		
		if(confirm('�����Ͻðڽ��ϱ�?')){
		if(confirm('��¥�� �����Ͻðڽ��ϱ�?')){
			fm.action='cons_delete.jsp';		
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}}
	}		
	
	function ConsPrint(seq){
		var fm = document.form1;	
		var width 	= 800;
		var height 	= 860;		
		window.open("cons_reg_print.jsp?cons_no=<%=cons_no%>&seq="+seq+"&step=2", "Print", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");		
	}
	
	function ConsCarList(car_no, from_req_dt){
		var fm = document.form1;	
		var width 	= 800;
		var height 	= 300;		
		window.open("cons_car_list.jsp?car_no="+car_no+"&from_req_dt="+from_req_dt, "CarList", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");		
	}
	
	function cons_rec_sms(){
		var fm = document.form1;	
		fm.doc_bit.value = 'sms';
		
		if(confirm('���ڸ� �߼��Ͻðڽ��ϱ�?')){	
			fm.action='cons_reg_step2_a.jsp';		
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}											
	}
	
	function cons_req_sms(){
		var fm = document.form1;	
		fm.doc_bit.value = 'sms_standby';
		
		cut_length("[Ź��������û]"+fm.from_req_dt[0].value+" "+fm.from_req_h[0].value+"��/���:"+fm.from_place[0].value+"/����:"+fm.to_place[0].value,90);
			
		if(confirm('���ڸ� �߼��Ͻðڽ��ϱ�?')){	
		if(confirm('�߼۸޽���:'+fm.sms_msg.value)){			
			fm.action='cons_reg_step2_a.jsp';		
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}}
	}	
	
	//�Ƿ��� ����
	function doc_id_cng(){
		var fm = document.form1;	
		var width 	= 400;
		var height 	= 200;		
		window.open("cons_reg_cng.jsp?cons_no=<%=cons_no%>", "CNG", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");			
	}	
	
	//Ź�۾�ü ����
	function doc_off_cng(){
		var fm = document.form1;	
		var width 	= 400;
		var height 	= 200;		
		window.open("cons_reg_off_cng.jsp?cons_no=<%=cons_no%>", "OFF_CNG", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");			
	}		

	
function f_man_sms(){
	var fm = document.form1;	
	fm.doc_bit.value = 'f_sms';
	
	if(confirm('���ڸ� �߼��Ͻðڽ��ϱ�?')){
		if(confirm('�߼۸޽���:[Ź�ۿ�û]-���� Ź���غ� �Ϸ�!!')){
			fm.action='cons_reg_step2_a.jsp';		
			fm.target='d_content';
			fm.submit();
		}
	}
}
	
function d_man_sms(){
	var fm = document.form1;	
	fm.doc_bit.value = 'd_sms';
	
	cut_length("[Ź�ۿ�û]"+fm.from_req_dt[0].value+" "+fm.from_req_h[0].value+"��/���:"+fm.from_place[0].value+"/����:"+fm.to_place[0].value,90);
		
	if(confirm('���ڸ� �߼��Ͻðڽ��ϱ�?')){	
		if(confirm('�߼۸޽���:'+fm.sms_msg.value)){			
			fm.action='cons_reg_step2_a.jsp';		
			fm.target='d_content';
			fm.submit();
		}
	}
}

//ä�Ǿ絵 ������ �� ������ ����
function view_bond_trf_doc(cons_no){
	<%-- window.open("/acar/res_stat/myaccid_doc_email.jsp?cons_no="+cons_no+"&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&seq="+seq+"&gubun="+gubun, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes"); --%>
	window.open("bond_trf_doc.jsp?cons_no="+cons_no, "SCAN", "left=10, top=10, width=800, height=900, scrollbars=yes, status=yes, resizable=yes");
}

function select(sub_rent_l_cd, idx, age_scp, car_no) {
	$("[name=sub_rent_l_cd]").eq(idx).val(sub_rent_l_cd);
	$("[name=age_scp]").eq(idx).val(age_scp);
	$("[name=sub_car_no]").eq(idx).val(car_no);
	if(!car_no) {
		$("[name=sub_car_no]").eq(idx).val(sub_rent_l_cd);
	}
	var age_scp = $("[name=age_scp]").eq(idx).val();
}

function test() {
	alert("����� ��ȸ ��ư�� Ŭ���Ͽ� �����ϼ���.");
}


$(document).on("click","[name=search]", function(){
	var fm = document.form1;
	var idx = $("[name=search]").index(this);
	$("[name=sub_rent_l_cd]").eq(idx).val("");
	$("[name=sub_car_no]").eq(idx).val("");
	// 3: �������� �ε�, 4: ������� �ε�, 5: ������ �ε�
	window.open("client_s.jsp?idx="+idx, "CLIENT_SEARCH", "left=50, top=50, width=1020, height=700, resizable=yes, scrollbars=yes, status=yes");
}); 

//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">
  <input type='hidden' name='cons_no' 	value='<%=cons_no%>'>
  <input type='hidden' name='off_id' 	value='<%=b_cons.getOff_id()%>'>
  <input type='hidden' name='off_nm' 	value='<%=b_cons.getOff_nm()%>'>
  <input type='hidden' name='reg_code' 	value='<%=b_cons.getReg_code()%>'>
<!--  <input type='hidden' name='req_id' 	value='<%=doc.getUser_id1()%>'>-->
  <input type='hidden' name="doc_no" 	value="<%=doc.getDoc_no()%>">  
  <input type='hidden' name="doc_bit" 	value="">
  <input type='hidden' name="del_seq" 	value="">  
  <input type='hidden' name="sms_msg" 	value="">    
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>���¾�ü > Ź�۰��� > <span class=style5>Ź���Ƿڼ���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>

    <tr>
	    <td align='right'><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a></td>
	</tr>	
	<tr>
	    <td class=line2></td>
	</tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>Ź�۹�ȣ</td>
                    <td>&nbsp;
        			  <%=cons_no%>
        			</td>
                    <td width='13%' class='title'>Ź�۾�ü</td>
                    <td>&nbsp;
        			  <%=b_cons.getOff_nm()%>
        			  <%if(white.equals("")){%>
        			  <span class="b"><a href="javascript:view_off()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a></span>
        			  <%}%>
        			  <%if(b_cons.getOff_id().equals("003158") && doc.getUser_dt2().equals("")){%>
        			  <%	if(doc.getUser_id1().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("Ź�۰�����",user_id)){%>
        			  <a href="javascript:doc_off_cng();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_modify_b.gif" align="absbottom" border="0"></a>
        			  <%	}%>
        			  <%}%>
        			</td>
                </tr>		  
                <tr>
                    <td width='13%' class='title'>Ź�۱���</td>
                    <td width="37%">&nbsp;
        			  <input type='radio' name="cons_st" value='1' <%if(b_cons.getCons_st().equals("1")){%>checked<%}%> <%=disabled%>>
        				��
        			  <input type='radio' name="cons_st" value='2' <%if(b_cons.getCons_st().equals("2")){%>checked<%}%> <%=disabled%>>
        				�պ�
        			</td>		  		  
                    <td width='13%' class='title'>�������</td>
                    <td width="37%">&nbsp;
                      <input type='text' name="cons_su" value='<%=b_cons.getCons_su()%>' size='2' class='<%//=white%>whitetext' onBlur='javscript:cng_input2(this.value);'>
        			  &nbsp;��
                    </td>					
                </tr>
                <tr> 
                    <td width='13%' class='title'>�����Է¿���</td>
                    <td colspan="3">&nbsp;
					<input type="checkbox" name="after_yn" value="Y" <%if(b_cons.getAfter_yn().equals("Y")){%>selected<%}%>>
        			  (Ź�ۿϷ�� �����Է��϶�)
                </tr>           					
            </table>
	    </td>
    </tr>
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>		
    <tr> 
        <td class='line'> 		
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
            	<tr><td class=line2 style='height:1'></td></tr>
                <tr>
                    <td class=title width=13% rowspan="2">����</td>
                    <td class=title width=15%>������</td>
                    <td class=title width=11%>�����</td>
                    <td class=title width=11%>����</td>
                    <td class=title width=13%>����</td>
                    <td class=title width=12%>û��</td>
                    <td class=title width=12%>�����Ȯ��</td>
                    <td class=title width=13%>���</td>
                </tr>
                <tr>
                    <td align="center"><font color="#999999"><%=sender_bean.getBr_nm()%></font></td>
                    <td align="center"><font color="#999999"><%=sender_bean.getUser_nm()%><br><%=doc.getUser_dt1()%><%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("Ź�۰�����",user_id)){%><br><a href="javascript:doc_id_cng();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_modify_b.gif" align="absbottom" border="0"></a><%}%></font></td>
                    <td align="center"><font color="#999999"><%=target_bean.getUser_nm()%><br><%if(doc.getUser_id2().equals(user_id)){%><!--<a href="javascript:doc_sanction('2')">����</a>--><%}%><br>&nbsp;</font></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
        			<td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                </tr>
            </table>
	    </td>
    </tr>
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>		
	<%if(doc.getUser_dt2().equals("")){%>
	<%//if(doc.getUser_id2().equals(user_id)){%>
	<%if(doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("Ź�۰�����",user_id)){%>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr><td class=line2 style='height:1'></td></tr>
    		    <tr>
        		    <td width="4%" rowspan="2" class='title'>����</td>
        			<td width="9%" rowspan="2" class='title'>������ȣ</td>
        		    <td colspan="2" class='title'>���</td>
        			<td colspan="2" class='title'>����</td>
        		    <td colspan="2" class='title'>������</td>
    	        </tr>
    		    <tr>
        		    <td width="12%" class='title'>���</td>
        		    <td width="18%" class='title'>�����Ͻ�</td>
        		    <td width="12%" class='title'>���</td>
        		    <td width="18%" class='title'>�����Ͻ�</td>
        		    <td width="13%" class='title'>����</td>
        		    <td width="14%" class='title'>�ڵ���</td>
    	        </tr>
    		  <%for(int j=0; j<b_cons.getCons_su(); j++){
    				ConsignmentBean cons 		= cs_db.getConsignment(cons_no, j+1);%>
    		  <%		String from_dt = "";
    			  		String from_h = "";
    					String from_s = "";
    					String get_from_dt = cons.getFrom_req_dt();
    					if(get_from_dt.length() == 12){
    						from_dt = get_from_dt.substring(0,8);
    						from_h 	= get_from_dt.substring(8,10);
    						from_s	= get_from_dt.substring(10,12);
    					}
    					String to_dt = "";
    			  		String to_h = "";
    					String to_s = "";
    					String get_to_dt = cons.getTo_req_dt();
    			  		if(get_to_dt.length() == 12){
    						to_dt 	= get_to_dt.substring(0,8);
    						to_h 	= get_to_dt.substring(8,10);
    						to_s 	= get_to_dt.substring(10,12);
    					}
    					String driver_nm 	= cons.getDriver_nm();
    					String driver_id 	= cons.getDriver_nm();
    					String driver_m_tel = cons.getDriver_m_tel();
    					if(!driver_nm.equals("") && cons.getOff_id().equals("003158")) driver_nm = c_db.getNameById(cons.getDriver_nm(),"USER");
    					if(driver_nm.equals("")){
    						driver_nm 		= target_bean.getUser_nm();
    						driver_id 		= target_bean.getUser_id();
    						driver_m_tel 	= target_bean.getUser_m_tel();
    					}
    					
    					String prev_car_no = cons.getCar_no();
    					String car_no = "";
    					if( prev_car_no.length() > 10 ) {
    						car_no = cs_db.getCarNo(cons_no, j+1);
    					}
    					car_no = car_no == "" ? prev_car_no : car_no;
    					%>						
    		    <tr>
        		    <td align="center"><%=j+1%></td>
        			<td align="center"><%=car_no%></td>
        		    <td align="center"><%=cons.getFrom_place()%></td>
        			<td align="center"><input type='text' name="from_est_dt" value='<%=AddUtil.ChangeDate2(from_dt)%>' size='11' class='default' onBlur='javascript:this.value=ChangeDate(this.value);'>
                      <input type='text' name="from_est_h" value='<%=from_h%>' size='1' maxlength="2" class='default'>
                      ��
                      <input type='text' name="from_est_s" value='<%=from_s%>' size='1' maxlength="2" class='default'>
                    ��</td>			
        		    <td align="center"><%=cons.getTo_place()%></td>
        		    <td align="center"><input type='text' name="to_est_dt" value='<%=AddUtil.ChangeDate2(to_dt)%>' size='11' class='default' onBlur='javascript:this.value=ChangeDate(this.value);'>
                      <input type='text' name="to_est_h" value='<%=to_h%>' size='1' maxlength="2" class='default'>
                      ��
                      <input type='text' name="to_est_s" value='<%=to_s%>' size='1' maxlength="2" class='default'>
                    ��</td>
        		    <td align="center"><input type='text' name="driver_nm" value='<%=driver_nm%>' size='10' class='default'><input type='hidden' name="driver_id" value='<%=driver_id%>'>&nbsp;<span class="b"><a href="javascript:cng_input6('driver','3',<%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a></span></td>
        		    <td align="center"><input type='text' name="driver_m_tel" value='<%=driver_m_tel%>' size='15' class='default'></td>
    	        </tr>
    		    <%}%>
    		    		  
			  
    		</table>
	    </td>
    </tr>		
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>				
	<tr>
	    <td align="center">&nbsp;<a href="javascript:doc_sanction('2');"><img src=/acar/images/center/button_gj.gif align=absmiddle border=0></a></td>
	</tr>
	<tr>
	    <td class=h></td>
	</tr>		
	<tr>
	    <td><font color=#999999>&nbsp;�� ���/���� �����Ͻ� : �Ƿ��ڰ� �Է��� ��û�Ͻð� ����Ʈ���Դϴ�. �����Ͻø� �����ϼ���. / ������ : ����� �ڵ����� �Է��ϼ���.</font> </td>
	</tr>			
	<tr>
	    <td><font color=#999999>&nbsp;�� ������� ��Ģ�̳� �����ʱ�� ��ȭ������ ��ϵǴ� �ǵ��� �ֽ��ϴ�. Ź���� �ߺ����� �ʵ��� ��û-��Ÿ�Ǵ� ��û�Ͻø� ���� ���� �����ϼ���.</font> </td>
	</tr>			
	<tr>
	    <td><font color=#999999>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ͻ翡 �̹� ������ �������� Ȯ���ؾ� �� �� �����ϴ�. Ź�ۿϷ���̶� FMS�� ����,����,û���� �ؾ� �մϴ�.</font> </td>
	</tr>	
	<tr>
	    <td><font color=#999999>&nbsp;�� ��� ���� �� �������� �ӽ����� ������ ��ϵ˴ϴ�. ��� ����� �ÿ��� �������� �ӽ������ ������ �����Ͻ� ���� ������ �ֽñ� �ٶ��ϴ�.</font> </td>
	</tr>		
	<%}%>	
	<%}%>
	<tr>
	    <td class=h></td>
	</tr>		
	<tr>
	    <td align="right" style='height:1; background-color=e5e5e5;'></td>
	</tr>	
	<tr>
	    <td class=h></td>
	</tr>
	<%for(int j=0; j<b_cons.getCons_su(); j++){
		//Ź���Ƿ� 1��
		ConsignmentBean cons 		= cs_db.getConsignment(cons_no, j+1);
		CarRegBean 	car 		= crd.getCarRegBean(cons.getCar_mng_id());
		ContCarBean 	car_etc 	= a_db.getContCarNew(cons.getRent_mng_id(), cons.getRent_l_cd());
		ClientBean 	client 		= al_db.getNewClient(cons.getClient_id());
		CarMstBean 	cm_bean 	= cmb.getCarNmCase(String.valueOf(car_etc.getCar_id()), String.valueOf(car_etc.getCar_seq()));
		
		//������������� ���� �ö�� 
		ContBaseBean 	base	= a_db.getCont(cons.getRent_mng_id(), cons.getRent_l_cd());
	
		//Ź����ȸ���� ���������� �������ð��(20190408)
		String car_nm = cm_bean.getCar_nm() + " " + cm_bean.getCar_name(); 
		if(car_nm.equals("")){		car_nm = car.getCar_nm();			}
		if(car_nm.equals("")){
			car 		= 		crd.getCarRegBean(base.getCar_mng_id());
			car_nm = car.getCar_nm();
		}
		if(car_nm.equals("")){
			car_nm = cmb.getCar_b_inc_name(car_etc.getCar_id(), car_etc.getCar_seq());
		}
		
		String prev_car_no = cons.getCar_no();
		String car_no = "";
		if( prev_car_no.length() > 10 ) {
			car_no = cs_db.getCarNo(cons_no, j+1);
		}
		car_no = car_no == "" ? prev_car_no : car_no;
	%>
	<tr id=tr_cons<%=j%>_1 style="display:''">
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>Ź��<%=j+1%></span></td>
	</tr>
    <tr id=tr_cons<%=j%>_2 style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr><td class=line2 style='height:1'></td></tr>
                <tr> 
                    <td width='13%' class='title'>������ȣ</td>
                    <td width='37%'>&nbsp;
        			  <input type='text' name="car_no" value='<%=car_no%>' size='30' class='whitetext' readonly>
        			  <input type='hidden' name='seq' value='<%=cons.getSeq()%>'>
        			  <input type='hidden' name='car_mng_id' value='<%=cons.getCar_mng_id()%>'>
        			  <input type='hidden' name='rent_mng_id' value='<%=cons.getRent_mng_id()%>'>
        			  <input type='hidden' name='rent_l_cd' value='<%=cons.getRent_l_cd()%>'>
        			  <input type='hidden' name='client_id' value='<%=cons.getClient_id()%>'>
        			  <%if(white.equals("")){%>
        			  	<%-- <%if(doc.getUser_dt2().equals("")){ %> --%>
        			  		<span class="b"><a href="javascript:search_car(<%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a></span>
        			  	<%-- <%}%> --%>
        			  <%}%>
        			</td>
        			<td width='13%' class='title'>����</td>
        			<td width='37%'>&nbsp;
    			    <%-- <input type='text' name="car_nm" value='<%=car.getCar_nm()%>' size='40' class='whitetext' readonly></td> --%>
    			    <input type='text' name="car_nm" value='<%=car_nm%>' size='40' class='whitetext' readonly></td>
                </tr>
    		    <tr>
        		    <td class='title'>����</td>
        			<td>&nbsp;
        			  <input type='text' name="car_y_form" value='<%=car.getCar_y_form()%>' size='40' class='whitetext' readonly>
        			</td>
        		    <td class='title'>����</td>
        			<td>&nbsp;
    			    <input type='text' name="color" value='<%=car_etc.getColo()%>' size='40' class='whitetext' readonly></td>			
    		    </tr>
    		    <tr>
        		    <td class='title'>�⺻���</td>
        			<td colspan="3" >&nbsp;
        			  <textarea rows='5' cols='100' name='car_b' readonly><%=cm_bean.getCar_b()%></textarea>        			  
        			</td>
    		    </tr>    	
    		    <tr>
        		    <td class='title'>���û��</td>
        			<td colspan="3" >&nbsp;
        			  <input type='text' name="opt" value='<%=car_etc.getOpt()%>' size='100' class='whitetext' readonly>
        			</td>
    		    </tr>    	     		    
    		    <tr>
        		    <td class='title'>����</td>
        			<td>&nbsp;
        			  <input type='text' name="firm_nm" value='<%=client.getFirm_nm()%>' size='70' class='whitetext' readonly>
        			</td>
        		<td class='title'>�����н�����</td>
        			<td>&nbsp;
        				<select name="r_hipass_yn" disabled >
                        <option value=''>����</option>
                        <option value='Y' <%if(car_etc.getHipass_yn().equals("Y"))%>selected<%%>>����</option>
                        <option value='N' <%if(car_etc.getHipass_yn().equals("N"))%>selected<%%>>����</option>
                      </select>
          			</td>	
    		    </tr>
		    </table>
	    </td>
    </tr>
    
	<tr id=tr_cons<%=j%>_3 style="display:''">
	    <td align="right">&nbsp;
	    </td>
	</tr>	
    <tr id=tr_cons<%=j%>_4 style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr><td class=line2 style='height:1'></td></tr>		  
    		    <tr>
        		    <td colspan="2" class='title'>�Ƿ���</td>
        		    <td >&nbsp;
					<%if(cons.getReq_id().equals("")) cons.setReq_id(doc.getUser_id1());%>
        			  <select name='req_id' <%=disabled%>>
                        <option value="">����</option>
                        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(cons.getReq_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%><%if(user.get("DEPT_ID").equals("1000")){%>[������Ʈ]<%}%></option>
                        <%		}
        					}%>
                      </select>
                      <%if(!cons.getAgent_emp_id().equals("")){ CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(cons.getAgent_emp_id()); %>�� �Ƿ��� : <%=a_coe_bean.getEmp_nm()%>&nbsp;<%=a_coe_bean.getEmp_m_tel()%><%}%>
        			</td>
        		    <td colspan="2" class='title'>Ź�۱���</td>
        		    <td >&nbsp;
        			  <select name="cmp_app" <%=disabled%>>
        			    <option value="">����</option>
        				<%for(int i = 0 ; i < c_size2 ; i++){
        					Hashtable code2 = (Hashtable)codes2.elementAt(i);%>
        					<option value='<%=code2.get("NM_CD")%>' <%if(cons.getCmp_app().equals(String.valueOf(code2.get("NM_CD") ))){%>selected<%}%>><%=code2.get("NM")%></option>
        				<%}%>
          			  </select>
        			  <!--(��üŹ���϶�)-->
        			</td>					
    	        </tr>
				<tr>
					<td colspan="2" class='title'>���������</td>
					<td colspan="4">&nbsp;
						<select name='mng_id' <%=disabled%>>
							<option value="">����</option>
							<%	if(user_size > 0){
									for(int i = 0 ; i < user_size ; i++){
										Hashtable user = (Hashtable)users.elementAt(i); %>
							<option value='<%=user.get("USER_ID")%>' <%if(base.getMng_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
							<%		}
								}%>
						  </select>
					</td>
				</tr>				
    		    <tr>
        		    <td colspan="2" class='title'>Ź�ۻ���</td>
        		    <td colspan="4">&nbsp;
        			  <select name="cons_cau" onChange="javascript:cng_input4(this.value, <%=j%>)" <%=disabled%>>
        			    <option value="">����</option>
        				<%for(int i = 0 ; i < c_size ; i++){
        					CodeBean code = codes[i];	%>
        				<option value='<%=code.getNm_cd()%>' <%if(cons.getCons_cau().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
        				<%}%>
          			  </select>
        			  &nbsp;��Ÿ���� : <input type='text' name="cons_cau_etc" value='<%=cons.getCons_cau_etc()%>' size='40' class='<%=white%>text'>
        			  <input type="button" id="search" name="search" onclick="" value="����� ��ȸ" style="display:none">
        			  <span id="car_no_text" name="car_no_text" style="display:none">����� ���� ��ȣ</span> 
        			  <input type="text" id="sub_car_no" name="sub_car_no" class="text" value="" style="display:none" onclick="test()" readonly>
        			  <input type="text" id="sub_rent_l_cd" name="sub_rent_l_cd" class="sub_rent_l_cd" style="display:none" value='<%=cons.getSub_l_cd()%>'>
        			  <input type="text" id="age_scp" name="age_scp" class="age_scp" style="display:none">
        			</td>
    	        </tr>
    		    <tr>
        		    <td colspan="2" class='title'>��뱸��</td>
        			<td>&nbsp;
        			  <select name="cost_st" <%=disabled%>>
        			    <option value="">����</option>
        			    <option value="1" <%if(cons.getCost_st().equals("1")){%>selected<%}%>>�Ƹ���ī</option>
        			    <option value="2" <%if(cons.getCost_st().equals("2")){%>selected<%}%>>��</option>								
          			  </select>
        			
        			  <%//	if(cons.getCost_st().equals("2") ){%>
        			  &nbsp;<font color=red>[���δ�]Ź�۷� : <input type='text' name="cust_amt" value='<%=AddUtil.parseDecimal(cons.getCust_amt())%>' size='7' class='rednum' onBlur='javascript:this.value=parseDecimal(this.value);'>��</font>
        			
        			  <%// } %>
        			
        			</td>						
        		    <td colspan="2" class='title'>���ޱ���</td>
        			<td>&nbsp;
        			  <select name="pay_st" <%=disabled%>>
        			    <option value="">����</option>
        			    <option value="1" <%if(cons.getPay_st().equals("1")){%>selected<%}%>>����</option>
        			    <option value="2" <%if(cons.getPay_st().equals("2")){%>selected<%}%>>�ĺ�</option>								
          			  </select>
        			</td>						
    	        </tr>
    		    <tr>
        		    <td rowspan="4" class='title'>��<br>
        	        û</td>
        		    <td class='title'>����</td>
        		    <td colspan="4">&nbsp;
        			  <select name="wash_yn" <%=disabled%>>
        			    <option value="">����</option>
        			    <%-- <option value="Y" <%if(cons.getWash_yn().equals("Y")){%>selected<%}%>>��û</option> --%>
        			    <option value="M" <%if(cons.getWash_yn().equals("M")||cons.getWash_yn().equals("Y")){%>selected<%}%>>��輼��</option>
        			    <option value="H" <%if(cons.getWash_yn().equals("H")){%>selected<%}%>>�ռ���</option>
        			    <option value="N" <%if(cons.getWash_yn().equals("N")){%>selected<%}%>>����</option>								
          			  </select>
        			</td>
    	        </tr>
    		    <tr>
        		    <td class='title'>����</td>
        		    <td colspan="4">&nbsp;
        			  <select name="oil_yn" <%=disabled%>>
        			    <option value="">����</option>
        			    <option value="Y" <%if(cons.getOil_yn().equals("Y")){%>selected<%}%>>��û</option>
        			    <option value="N" <%if(cons.getOil_yn().equals("N")){%>selected<%}%>>����</option>								
          			  </select>
        				������û�� -&gt; 
        			  <input type='text' name="oil_liter" value='<%=Util.parseDecimal(cons.getOil_liter())%>' size='11' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
        				����<!--��--> 
        				Ȥ��
        			  <input type='text' name="oil_est_amt" value='<%=Util.parseDecimal(cons.getOil_est_amt())%>' size='11' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
        				����ġ ���� ���ּ���.</td>
    	        </tr>
    		    <tr>
        		    <td class='title'>�����н����</td>
        		    <td colspan="4">&nbsp;
        			  <select name="hipass_yn">
        			    <option value="Y" <%if(cons.getHipass_yn().equals("Y")){%>selected<%}%>>��û</option>
        			    <option value="N" <%if(cons.getHipass_yn().equals("N")||cons.getHipass_yn().equals("")){%>selected<%}%>>����</option>								
          			  </select>
					  (��ϴ��� �Ƿڽ� �����Ͻʽÿ�.)
        			</td>
    	        </tr>								
    		    <tr>
    		        <td class='title'>��Ÿ</td>
    		        <td colspan="4">&nbsp;
                    <textarea rows='5' cols='90' name='etc' class='<%=white%>'><%=cons.getEtc()%></textarea></td>
    	        </tr>		  
    		    <tr>
        		    <td width="3%" rowspan="6" class='title'>��<br>��</td>
        		    <td width="10%" class='title'>����</td>
        		    <td width="37%">&nbsp;
        			  <select name="from_st" onChange="javascript:cng_input3('from', this.value, <%=j%>)" <%=disabled%>>
        			    <option value="">����</option>
        			    <option value="1" <%if(cons.getFrom_st().equals("1")){%>selected<%}%>>�Ƹ���ī</option>
        			    <option value="2" <%if(cons.getFrom_st().equals("2")){%>selected<%}%>>��</option>
        			    <option value="3" <%if(cons.getFrom_st().equals("3")){%>selected<%}%>>���¾�ü</option>
        			    <option value="4" <%if(cons.getFrom_st().equals("4")){%>selected<%}%>>�������</option>				
          			  </select>
        			  <%if(white.equals("")){%>		
        			  <span class="b"><a href="javascript:cng_input3('from', document.form1.from_st[<%=j%>].options[document.form1.from_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a></span>
        			  <%}%>
        			</td>
        		    <td width="3%" rowspan="6" class='title'>��<br>��</td>
        		    <td width="10%" class='title'>����</td>
        		    <td width="37%">&nbsp;
        			  <select name="to_st" onChange="javascript:cng_input3('to', this.value, <%=j%>)" <%=disabled%>>
        			    <option value="">����</option>
        			    <option value="1" <%if(cons.getTo_st().equals("1")){%>selected<%}%>>�Ƹ���ī</option>
        			    <option value="2" <%if(cons.getTo_st().equals("2")){%>selected<%}%>>��</option>
        			    <option value="3" <%if(cons.getTo_st().equals("3")){%>selected<%}%>>���¾�ü<%=cons.getTo_st()%></option>
          			  </select>
        			  <%if(white.equals("")){%>			
        			  <span class="b"><a href="javascript:cng_input3('to', document.form1.to_st[<%=j%>].options[document.form1.to_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a></span>
        			  <%}%>
        			</td>			
    		    </tr>
    		    <tr>
        		    <td width="10%" class='title'>���</td>
        		    <td>&nbsp;
                        <input type='text' name="from_place" id="from_place" value='<%=cons.getFrom_place()%>' size='40' class='<%=white%>text' ></td>
        		    <td width="10%" class='title'>���</td>
        		    <td>&nbsp;
                    <input type='text' name="to_place" value='<%=cons.getTo_place()%>' size='40' class='<%=white%>text' ></td>
    		    </tr>
    		    <tr>
        		    <td class='title'>��ȣ/����</td>
        		    <td>&nbsp;
                        <input type='text' name="from_comp" id="from_comp" value='<%=cons.getFrom_comp()%>' size='40' class='<%=white%>text' >
        				</td>
        		    <td class='title'>��ȣ/����</td>
        		    <td>&nbsp;
                        <input type='text' name="to_comp" value='<%=cons.getTo_comp()%>' size='40' class='<%=white%>text' ></td>
    		    </tr>
    		    <tr>
        		    <td class='title'>�����</td>
        	        <td>&nbsp;�μ�/����
        	          <input type='text' name="from_title" id="from_title" value='<%=cons.getFrom_title()%>' size='20' class='<%=white%>text' ><br>
                      &nbsp;����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <input type='text' name="from_man" id="from_man" value='<%=cons.getFrom_man()%>' size='20' class='<%=white%>text' >
        			  <%if(white.equals("")){%>
        			  <span class="b"><a href="javascript:cng_input5('from', document.form1.from_st[<%=j%>].options[document.form1.from_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a></span>
        			  <%}%>
        			</td>
        		    <td class='title'>�����</td>
        		    <td>&nbsp;�μ�/����
        		      <input type='text' name="to_title" value='<%=cons.getTo_title()%>' size='20' class='<%=white%>text' ><br>
        			  &nbsp;����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        			  <input type='text' name="to_man" value='<%=cons.getTo_man()%>' size='20' class='<%=white%>text' >
        			  <%if(white.equals("")){%>
        			  <span class="b"><a href="javascript:cng_input5('to', document.form1.to_st[<%=j%>].options[document.form1.to_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif" align="absmiddle" border="0"></a></span>
        			  <%}%>
        			</td>
    		    </tr>
    		    <tr>
        		    <td class='title'>����ó</td>
        		    <td>&nbsp;�繫��
                        <input type='text' name="from_tel" id="from_tel" value='<%=cons.getFrom_tel()%>' size='15' class='<%=white%>text' ><br>
        				&nbsp;�ڵ���
                        <input type='text' name="from_m_tel" id="from_m_tel" value='<%=cons.getFrom_m_tel()%>' size='15' class='<%=white%>text' >
        			</td>
        		    <td class='title'>����ó</td>
        		    <td>&nbsp;�繫��
                        <input type='text' name="to_tel" value='<%=cons.getTo_tel()%>' size='15' class='<%=white%>text' ><br>
        				&nbsp;�ڵ���
                        <input type='text' name="to_m_tel" value='<%=cons.getTo_m_tel()%>' size='15' class='<%=white%>text' >
        			</td>
    		    </tr>
    		    <tr>
        		    <td class='title'>��û�Ͻ�</td>
        		    <td>&nbsp;
        			  <%	String from_req_dt = "";
        			  		String from_req_h = "";
        					String from_req_s = "";
        			  		if(cons.getFrom_req_dt().length() == 12){
        						from_req_dt = cons.getFrom_req_dt().substring(0,8);
        						from_req_h 	= cons.getFrom_req_dt().substring(8,10);
        						from_req_s	= cons.getFrom_req_dt().substring(10,12);
        					}%>
                      <input type='text' name="from_req_dt" value='<%=AddUtil.ChangeDate2(from_req_dt)%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value); document.form1.to_req_dt[<%=j%>].value=this.value;'>
                      &nbsp;
        			  <select name="from_req_h" onchange="javascript:document.form1.to_req_h[<%=j%>].value=this.value;" <%=disabled%>>
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(from_req_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="from_req_s" onchange="javascript:document.form1.to_req_s[<%=j%>].value=this.value;" <%=disabled%>>
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(from_req_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                    </td>
        		    <td class='title'>��û�Ͻ�</td>
        		    <td>&nbsp;
        			  <%	String to_req_dt = "";
        			  		String to_req_h = "";
        					String to_req_s = "";
        			  		if(cons.getTo_req_dt().length() == 12){
        						to_req_dt 	= cons.getTo_req_dt().substring(0,8);
        						to_req_h 	= cons.getTo_req_dt().substring(8,10);
        						to_req_s 	= cons.getTo_req_dt().substring(10,12);
        					}%>			
                      <input type='text' name="to_req_dt" value='<%=AddUtil.ChangeDate2(to_req_dt)%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                      &nbsp;
        			  <select name="to_req_h" <%=disabled%>>
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(to_req_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                      <select name="to_req_s" <%=disabled%>>
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(to_req_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                        <%}%>
                      </select>
                    </td>
    	        </tr>  
            </table>
        </td>
    </tr>
    
	<tr id=tr_cons<%=j%>_5 style="display:''">
	    <td align="right">&nbsp;<a href="javascript:ConsPrint(<%=cons.getSeq()%>)"><img src="../../images/printer.gif" border="0"></a>
	  <%Vector vt = cs_db.getConsignmentCarList(cons.getCar_no(), from_req_dt);
		int vt_size = vt.size();
		if(vt_size>1){%>
		<a href="javascript:ConsCarList('<%=cons.getCar_no()%>','<%=from_req_dt%>')"><font color=red>��������/���Ͽ�û�Ϸ� ��ϵ� Ź���Ƿڰ� �ֽ��ϴ�.</font></a>&nbsp;
	  <%}%>
	    </td>
	</tr>		
	<%}%>		
	
	<tr>
	    <td align="center">
	    <%if(doc.getUser_id1().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("Ź�۰�����",user_id)){%>
	    <a href="javascript:save();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_modify.gif" align="absbottom" border="0"></a>&nbsp;
		<%}%>
		<%//if(b_cons.getCons_su() > 1 && nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("Ź�۰�����",user_id)){%>
		<%if(doc.getUser_dt2().equals("") && (doc.getUser_id1().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("Ź�۰�����",user_id))){%>
		<a href="javascript:cons_delete('all','');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_delete.gif" align="absbottom" border="0"></a>
		<%}%>
		<!-- ä�Ǿ絵������ �� ������ �����  -->
		<%-- <%if(bond_trf_doc_size > 0){ %>
		<tr>
			<td align="center"><a href="javascript:view_bond_trf_doc(<%=cons_no%>);" onMouseOver="window.status=''; return true" onFocus="this.blur()">[ä�Ǿ絵 ������ �� �����庸��]</a></td>
		</tr>
		<%} %> --%>
		<!--  -->
	    </td>
	</tr>
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>
	<tr>
		
		<td align="" class='' >
			
		</td>
	</tr>		
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>	
	<tr>
	    <td align="center">
<!--	    	
	    	&nbsp;
	    	<%if(b_cons.getF_man().equals("Y")&&b_cons.getD_man().equals("Y")){%>
	    	<%//if(doc.getUser_dt2().equals("") && (doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("������",user_id))){%>
		    <a href="javascript:f_man_sms();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_p_send_ddj.gif" border="0" align=absmiddle></a>
			<%//}%>
			&nbsp;
			<%//if((doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("������",user_id))){%>
		    <a href="javascript:d_man_sms();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_p_send_ts.gif" border="0" align=absmiddle></a>
			<%//}%>
			<%}else if(b_cons.getF_man().equals("Y")){%>
			&nbsp;
			<%//if((doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("������",user_id))){%>
		    <a href="javascript:f_man_sms();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_p_send_ddj.gif" border="0" align=absmiddle></a>
			<%//}%>
			<%}else if(b_cons.getD_man().equals("Y")){%>
			&nbsp;
			<%//if((doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("������",user_id))){%>
		    <a href="javascript:d_man_sms();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_p_send_ts.gif" border="0" align=absmiddle></a>
			<%//}%>  &nbsp;/
			<%}%>
	    	
	-->    	
	    <%//if(doc.getUser_dt2().equals("") && (nm_db.getWorkAuthUser("������",user_id)) || doc.getUser_id2().equals(user_id))){%>
		<%if(doc.getUser_dt2().equals("") && (doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("������",user_id))){%>
	    &nbsp;&nbsp;<a href="javascript:cons_rec_sms();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_sms_send.gif" align="absmiddle" border="0"></a>
		<%}%>
		&nbsp;
		<%-- <%if((doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("������",user_id))){%>
	    <a href="javascript:cons_req_sms();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_sms_jw.gif" border="0" align=absmiddle></a>
		<%}%>	 --%>
	    </td>
	</tr>
	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	
//-->
</script>
</body>
</html>
