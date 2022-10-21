<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.consignment.*, acar.doc_settle.*, acar.car_register.*, acar.client.*, acar.cont.*, acar.car_mst.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="shDb"      class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ include file="/agent/cookies.jsp" %> 

<%
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//�α���ID&������ID&����
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;

	
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
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	
	//Ź���Ƿ� 1��
	ConsignmentBean b_cons = cs_db.getConsignment(cons_no, 1);
	
	//����ǰ��
	DocSettleBean doc = d_db.getDocSettleCommi("2", cons_no);
	
	//�Ƿ���
	UsersBean sender_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
	
	Vector  codes2 = new Vector();
	int c_size2 = 0;	

	codes2 = c_db.getCodeAllV_0022_all("0022");	
	c_size2= codes2.size();
	
	String white = "";
	String disabled = "";
	white = "white";
	disabled = "disabled";
	
	if(from_page.equals("/agent/consignment/cons_oil_doc_frame.jsp")){
		white = "white";
		disabled = "disabled";		
	}
		
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//���̱��ϱ�
function cut_length(f,cut_len) {
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
	alert(len);	
	alert(rf);
//	return rf;
}

	//����Ʈ
	function list(){
		var fm = document.form1;			
		if(fm.mode.value == 'doc_settle'){
			fm.action = '/agent/doc_settle/doc_settle_frame.jsp';
		}else{
			if(fm.from_page.value == ''){
				fm.action = 'cons_settle_frame.jsp';
			}else{
				fm.action = fm.from_page.value;
			}
		}
		fm.target = 'd_content';
		fm.submit();
	}	


	//Ź�۾�ü ��ȸ
	function search_off()
	{
		window.open("/agent/cus0601/cus0602_frame.jsp?from_page=/agent/consignment/cons_reg_step3.jsp", "SERV_OFF", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//Ź�۾�ü ����
	function view_off()
	{
		var fm = document.form1;
		if(fm.off_id.value == ""){ alert("���õ� Ź�۾�ü�� �����ϴ�."); return;}
		window.open("/agent/cus0601/cus0602_d_frame.jsp?from_page=/agent/consignment/cons_reg_step3.jsp&off_id="+fm.off_id.value, "SERV_OFF", "left=10, top=10, width=900, height=200, scrollbars=yes, status=yes, resizable=yes");
	}		
		
	//�ڵ��� ��ȸ
	function search_car(idx)
	{
		window.open("/tax/pop_search/s_car.jsp?go_url=/agent/consignment/cons_reg_step3.jsp&s_kd=2&idx="+idx, "CAR", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//�ڵ��� ����
	function view_car(idx)
	{
		var fm = document.form1;
		if(fm.off_id.value == ""){ alert("���õ� Ź�۾�ü�� �����ϴ�."); return;}
		if(fm.car_mng_id[idx].value == ""){ alert("���õ� �ڵ����� �����ϴ�."); return;}	
		window.open("/agent/car_register/car_view.jsp?rent_mng_id="+fm.rent_mng_id[idx].value+"&rent_l_cd="+fm.rent_l_cd[idx].value+"&car_mng_id="+fm.car_mng_id[idx].value+"&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
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
		
		if(cons_su >10){
			alert('�Է°����� �ִ�Ǽ��� 10�� �Դϴ�.');
			return;
		}		
		
		<%for(int i=1;i<10;i++){%>
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
		
		window.open("s_place.jsp?go_url=/agent/consignment/cons_reg_step3.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd="+s_kd+"&t_wd="+firm_nm+"&req_id="+req_id, "PLACE", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");		
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
		
		window.open("s_man.jsp?go_url=/agent/consignment/cons_reg_step1.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd=1&t_wd="+firm_nm+"&rent_mng_id="+fm.rent_mng_id[idx].value+"&rent_l_cd="+fm.rent_l_cd[idx].value+"&car_no="+fm.car_no[idx].value, "MAN", "left=10, top=10, width="+width+", height=500, scrollbars=yes, status=yes, resizable=yes");		
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
			window.open("s_man.jsp?go_url=/agent/consignment/cons_reg_step3.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd="+s_kd+"&t_wd="+firm_nm+"&size=<%=b_cons.getCons_su()%>", "MAN", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");					
		}else{				
			window.open("s_man.jsp?go_url=/agent/consignment/cons_reg_step3.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd=1&t_wd="+firm_nm+"&size=<%=b_cons.getCons_su()%>", "MAN", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");		
		}
	}			
	
	//Ź�ۻ����� ����
	function cng_input4(value, idx){
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
			}	
		}else{
			if(fm.to_est_chk[idx].checked == true){		
				fm.to_est_dt[idx].value 	= fm.to_req_dt[idx].value;
				fm.to_est_h[idx].value 		= fm.to_req_h[idx].value;
				fm.to_est_s[idx].value 		= fm.to_req_s[idx].value;									
			}
		}
	}
	
	function cons_delete(mode, seq){
		var fm = document.form1;
		
		fm.mode.value 		= mode;
		fm.del_seq.value 	= seq;
		
		if(confirm('�����Ͻðڽ��ϱ�?')){
		if(confirm('��¥�� �����Ͻðڽ��ϱ�?')){
			fm.action='cons_delete.jsp';		
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}}
	}		
	
	//Ź�۰����� �������
	function doc_sanction_cancel(){
		var fm = document.form1;
		fm.cmd.value="cancel";
		if(confirm('������� �Ͻðڽ��ϱ�?')){	
			fm.action='cons_conf_a.jsp';
			fm.target='i_no';
			fm.submit();
		}									
	}
	
	function doc_sanction(doc_bit){
		var fm = document.form1;
		var size = toInt(fm.cons_su.value);
		
		fm.doc_bit.value = doc_bit;
		
		for(i=0; i<size ; i++){		
			if(size == 1){
				if(fm.from_dt.value == "" || fm.from_h.value == "" || fm.from_s.value == "") 			{ 	alert((i+1)+"�� �ڵ��� : ���-�Ͻø� �Է��Ͻʽÿ�."); 					return;	}					
				if(fm.to_dt.value == ""   || fm.to_h.value == ""   || fm.to_s.value == "") 				{ 	alert((i+1)+"�� �ڵ��� : ����-�Ͻø� �Է��Ͻʽÿ�."); 					return;	}			
				if(toInt(parseDigit(fm.other_amt[i].value)) > 0 &&  fm.other.value == "") 				{ 	alert((i+1)+"�� �ڵ��� : ��Ÿ�ݾ� ������ �Է��Ͻʽÿ�."); 				return;	}
				if(fm.cost_st2.value == "2" && fm.pay_st2.value == "1"){
					if(toInt(parseDigit(fm.cust_amt[i].value)) == 0)									{ 	alert((i+1)+"�� �ڵ��� : ����� Ź�۷Ḧ �Է��Ͻʽÿ�."); 			return;	}				
					if(toInt(parseDigit(fm.cust_amt[i].value)) > 0 &&  fm.cust_pay_dt.value == "")		{ 	alert((i+1)+"�� �ڵ��� : ����� Ź�۷� �������ڸ� �Է��Ͻʽÿ�."); 	return;	}				
				}
				//20091101���� ����� ����Ÿ� �Է� �ʼ�
				if(toInt(replaceString('-','',fm.from_dt.value)) >= 20091101){
					if(fm.tot_dist.value == "" || fm.tot_dist.value == "0")								{ 	alert((i+1)+"�� �ڵ��� : ����Ÿ��� �Է��Ͻʽÿ�."); 					return;	}					
					//20110713 �Է°� üũ
					/*
					if(toInt(fm.v_tot_dist.value) >1){
						var dist_cha = toInt(parseDigit(fm.v_tot_dist.value))-toInt(parseDigit(fm.tot_dist.value));
						if(dist_cha > 2000){
							alert((i+1)+"�� �ڵ��� : ��������Ÿ��� "+fm.v_tot_dist.value+"km�Դϴ�. �Է��� ����Ÿ��� ��������(-2000)�� �ʰ��մϴ�."); 			return;							
						}
					}	
					*/		
				}
				// 20180411 ��������Ÿ� �Է� ����(�޸��� ������ 6�ڸ������� �Է� ����)
				if(toInt(parseDigit(fm.tot_dist.value))>999999){					{ 	alert((i+1)+"�� �ڵ��� : ����Ÿ��� 999,999km�� ���� �� �����ϴ�."); 					return;	}
				}
			}else{
				if(fm.from_dt[i].value == "" || fm.from_h[i].value == "" || fm.from_s[i].value == "") 	{ 	alert((i+1)+"�� �ڵ��� : ���-�Ͻø� �Է��Ͻʽÿ�."); 					return;	}					
				if(fm.to_dt[i].value == ""   || fm.to_h[i].value == ""   || fm.to_s[i].value == "") 	{ 	alert((i+1)+"�� �ڵ��� : ����-�Ͻø� �Է��Ͻʽÿ�."); 					return;	}
				if(toInt(parseDigit(fm.other_amt[i].value)) > 0 &&  fm.other[i].value == "") 			{ 	alert((i+1)+"�� �ڵ��� : ��Ÿ�ݾ� ������ �Է��Ͻʽÿ�."); 				return;	}							
				if(fm.cost_st2[i].value == "2" && fm.pay_st2[i].value == "1"){
					if(toInt(parseDigit(fm.cust_amt[i].value)) == 0)									{ 	alert((i+1)+"�� �ڵ��� : ����� Ź�۷Ḧ �Է��Ͻʽÿ�."); 			return;	}				
					if(toInt(parseDigit(fm.cust_amt[i].value)) > 0 &&  fm.cust_pay_dt[i].value == "")	{ 	alert((i+1)+"�� �ڵ��� : ����� Ź�۷� �������ڸ� �Է��Ͻʽÿ�."); 	return;	}				
				}
				//20091101���� ����� ����Ÿ� �Է� �ʼ�
				if(toInt(replaceString('-','',fm.from_dt[i].value)) >= 20091101){
					if(fm.tot_dist[i].value == "" || fm.tot_dist[i].value == "0")						{ 	alert((i+1)+"�� �ڵ��� : ����Ÿ��� �Է��Ͻʽÿ�."); 					return;	}					
					//20110713 �Է°� üũ
					/*
					if(toInt(fm.v_tot_dist[i].value) >1){
						var dist_cha = toInt(parseDigit(fm.v_tot_dist[i].value))-toInt(parseDigit(fm.tot_dist[i].value));
						if(dist_cha > 2000){
							alert((i+1)+"�� �ڵ��� : ��������Ÿ��� "+fm.v_tot_dist[i].value+"km�Դϴ�. �Է��� ����Ÿ��� ��������(-2000)�� �ʰ��մϴ�."); 			return;							
						}
					}
					*/
				}
				// 20180411 ��������Ÿ� �Է� ����(�޸��� ������ 6�ڸ������� �Է� ����)
				if(toInt(parseDigit(fm.tot_dist[i].value))>999999){					{ 	alert((i+1)+"�� �ڵ��� : ����Ÿ��� 999,999km�� ���� �� �����ϴ�."); 					return;	}
				}
			}
			//if(toInt(parseDigit(fm.cons_amt[i].value)) == 0)			 								{ 	alert((i+1)+"�� �ڵ��� : Ź�۷Ḧ �Է��Ͻʽÿ�."); 						return;	}
		}
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='cons_reg_step3_a.jsp';
			fm.target='i_no';
//			fm.target='d_content';
			fm.submit();
		}									
	}	
	
	function save(idx){
		var fm = document.form1;
		
		fm.u_seq.value = idx;
		fm.mode.value = 'driver_modify';
		
		if(confirm('�����Ͻðڽ��ϱ�?')){		
			fm.action='cons_reg_step3_a.jsp';
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}		
	}
	
	//Ź���Ƿڼ� ���
	function ConsPrint(seq){
		var fm = document.form1;	
		var width 	= 800;
		var height 	= 700;		
		window.open("cons_reg_print.jsp?cons_no=<%=cons_no%>&seq="+seq+"&step=2", "Print", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");		
	}
	
	//�ݾ� ����
	function set_amt(){
		var fm = document.form1;	
		var size = toInt(fm.cons_su.value);
		
		fm.cons_amt[size].value 	= 0;
		fm.cons_other_amt[size].value 	= 0;
		fm.oil_amt[size].value 		= 0;
		fm.wash_amt[size].value 	= 0;
		fm.hipass_amt[size].value 	= 0;
		fm.other_amt[size].value 	= 0;
		fm.tot_amt[size].value 		= 0;
		fm.cust_amt[size].value 	= 0;		
		
		for(i=0; i<size ; i++){
			fm.tot_amt[i].value 		= parseDecimal( toInt(parseDigit(fm.cons_amt[i].value))  + toInt(parseDigit(fm.cons_other_amt[i].value))  + toInt(parseDigit(fm.oil_amt[i].value)) + toInt(parseDigit(fm.wash_amt[i].value)) + toInt(parseDigit(fm.hipass_amt[i].value)) + toInt(parseDigit(fm.other_amt[i].value)) );
			fm.cons_amt[size].value 	= parseDecimal( toInt(parseDigit(fm.cons_amt[size].value)) + toInt(parseDigit(fm.cons_amt[i].value)) );
			fm.cons_other_amt[size].value 	= parseDecimal( toInt(parseDigit(fm.cons_other_amt[size].value)) + toInt(parseDigit(fm.cons_other_amt[i].value)) );
			fm.oil_amt[size].value 		= parseDecimal( toInt(parseDigit(fm.oil_amt[size].value)) + toInt(parseDigit(fm.oil_amt[i].value)) );
			fm.wash_amt[size].value 	= parseDecimal( toInt(parseDigit(fm.wash_amt[size].value)) + toInt(parseDigit(fm.wash_amt[i].value)) );
			fm.hipass_amt[size].value 	= parseDecimal( toInt(parseDigit(fm.hipass_amt[size].value)) + toInt(parseDigit(fm.hipass_amt[i].value)) );
			fm.other_amt[size].value 	= parseDecimal( toInt(parseDigit(fm.other_amt[size].value)) + toInt(parseDigit(fm.other_amt[i].value)) );
			fm.tot_amt[size].value 		= parseDecimal( toInt(parseDigit(fm.tot_amt[size].value)) + toInt(parseDigit(fm.tot_amt[i].value)) );
			fm.cust_amt[size].value 	= parseDecimal( toInt(parseDigit(fm.cust_amt[size].value)) + toInt(parseDigit(fm.cust_amt[i].value)) );			
		}
	}
	
	//�Ƿ��� ����
	function doc_id_cng(){
		var fm = document.form1;	
		var width 	= 400;
		var height 	= 200;		
		window.open("cons_reg_cng.jsp?cons_no=<%=cons_no%>", "CNG", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");			
	}	
	
	//�������� ����
	function view_car_service(car_mng_id){
		window.open("/acar/secondhand_hp/service_history.jsp?c_id="+car_mng_id+"&from_page=/fms2/lc_rent/lc_b_s.jsp", "VIEW_CAR_SERV", "left=100, top=100, width=630, height=500, scrollbars=yes");		
	}
	
	
	//������氨��û�������
	function M_doc_action(st, m_doc_code, seq1, seq2, buy_user_id, doc_bit, doc_no){
		var fm = document.form1;
		fm.st.value 		= st;		
		fm.m_doc_code.value 	= m_doc_code;
		fm.seq1.value 		= seq1;
		fm.seq2.value 		= seq2;
		fm.buy_user_id.value 	= buy_user_id;
		fm.doc_bit.value 	= doc_bit;
		fm.doc_no.value 	= '';		
		fm.action = 'cons_oil_doc_u.jsp';		
		fm.target = 'd_content';
		fm.submit();
	}		
	
	//������Ʈ������ȸ
	function Agent_User_search(nm, idx)
	{
		var fm = document.form1;
		<%if(b_cons.getCons_su()>1){%>
		if(fm.req_id[idx].value == '')		{ alert('�Ƿ��ڸ� �����Ͻʽÿ�.'); 		return;}
		var t_wd = '';
		fm.action = "/fms2/lc_rent/search_agent_user.jsp?mode=EMP_Y&nm="+nm+"&t_wd="+t_wd+"&idx="+idx+"&agent_user_id="+fm.req_id[idx].value;
		<%}else{%>
		if(fm.req_id.value == '')		{ alert('�Ƿ��ڸ� �����Ͻʽÿ�.'); 		return;}
		var t_wd = '';
		fm.action = "/fms2/lc_rent/search_agent_user.jsp?mode=EMP_Y&nm="+nm+"&t_wd="+t_wd+"&idx=&agent_user_id="+fm.req_id.value;
		<%}%>
		window.open("about:blank",'Agent_User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');
		fm.target = "Agent_User_search";
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
<form action='' name="form1" method='post'>
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
  <input type='hidden' name='cons_no' value='<%=cons_no%>'>
  <input type='hidden' name='off_id' value='<%=b_cons.getOff_id()%>'>
  <input type='hidden' name='off_nm' value='<%=b_cons.getOff_nm()%>'>
  <input type='hidden' name='reg_code' value='<%=b_cons.getReg_code()%>'>
<!--<input type='hidden' name='req_id' value='<%=doc.getUser_id1()%>'>-->
  <input type='hidden' name="doc_no" 	value="<%=doc.getDoc_no()%>">  
  <input type='hidden' name="doc_bit" value="<%=doc_bit%>">
  <input type='hidden' name="del_seq" value="">  
  <input type='hidden' name="u_seq" value="">  
  
  <input type='hidden' name='st' 	 value=''>
  <input type='hidden' name='m_doc_code' value=''>  
  <input type='hidden' name='seq1' 	 value=''>
  <input type='hidden' name='seq2' 	 value=''>
  <input type='hidden' name='buy_user_id' value=''>    
  
  <input type='hidden' name='cmd' 	 value=''>
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > Ź�۰��� > <span class=style5>Ź���Ƿ�����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
	    <td align='right'><a href="javascript:list()"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>		
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>  	
                <tr> 
                    <td width='13%' class='title'>Ź�۹�ȣ</td>
                    <td colspan="3">&nbsp;
        			  <%=cons_no%> 
        			</td>
                </tr>
                <tr> 
                    <td width='13%' class='title'>Ź�۾�ü</td>
                    <td colspan="3">&nbsp;
        			  <%=b_cons.getOff_nm()%>
        			  <%if(white.equals("")){%>
        			  <span class="b"><a href="javascript:view_off()"><img src="/acar/images/center/button_in_see.gif" align=absmiddle></a></span>
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
                      <input type='text' name="cons_su" value='<%=b_cons.getCons_su()%>' size='2' class='<%=white%>text'><!-- onBlur='javscript:cng_input2(this.value);-->
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
	    <td class=line2></td>
	</tr>		
    <tr> 
        <td class='line'> 		
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=13% rowspan="2">����</td>
                    <td class=title width=15%>������</td>
                    <td class=title width=11%>�Ƿ�</td>
                    <td class=title width=11%>����</td>
                    <td class=title width=13%>����</td>
                    <td class=title width=12%>û��</td>
                    <td class=title width=12%>�Ƿ���Ȯ��</td>
                    <td class=title width=13%>Ź�۰�����</td>
                </tr>
                <tr>
                    <td align="center"><font color="#999999"><%=sender_bean.getBr_nm()%></font></td>
                    <td align="center"><font color="#999999"><%=sender_bean.getUser_pos()%> <%=sender_bean.getUser_nm()%><br><%=doc.getUser_dt1()%></font></td>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%></font></td>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%><%if(doc.getUser_dt3().equals("") && doc.getUser_id2().equals(user_id)){%><!--<a href="javascript:doc_sanction('3')">����</a>--><%}%>&nbsp;</font></td>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id4(),"USER_PO")%><br><%=doc.getUser_dt4()%></font></td>
        			<td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt5()%><%if(!doc.getUser_dt4().equals("") && doc.getUser_dt5().equals("") && doc.getUser_id1().equals(user_id)){%><a href="javascript:doc_sanction('5');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_gj.gif" align="absbottom" border="0"></a><%}%>&nbsp;</font></td>
        			<td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id6(),"USER_PO")%><br><%=doc.getUser_dt6()%>
						</font></td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
        <td></td>
    </tr>
	<tr>
	    <td align="right" style='height:1; background-color=e5e5e5;'></td>
	</tr>	
	<tr>
        <td></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>						
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
    		    <tr>
        		    <td width="3%" rowspan="2" class='title'>����</td>
        		    <td width="9%" rowspan="2" class='title'>������ȣ</td>
        		    <td width="8%" rowspan="2" class='title'>����Ͻ�</td>
        		    <td width="8%" rowspan="2" class='title'>�����Ͻ�</td>			
        		    <td colspan="8" class='title'>û���ݾ�</td>
        		    <td width="8%" rowspan="2" class='title'>����Ÿ�</td>													
        		    <td colspan="2" class='title'>�����(����)</td>			
    	        </tr>
    		    <tr>
        		    <td width="7%" class='title'>Ź�۷�</td>
        		    <td width="6%" class='title'>�ܺ�Ź�۷�</td>
        	        <td width="6%" class='title'>������</td>
        		    <td width="6%" class='title'>������</td>
        		    <td width="6%" class='title'>�����н����</td>					
        		    <td width="6%" class='title'>��Ÿ����</td>
        		    <td width="6%" class='title'>��Ÿ�ݾ�</td>
        		    <td width="7%" class='title'>�Ұ�</td>
        		    <td width="6%" class='title'>�ݾ�</td>
        		    <td width="7%" class='title'>��������</td>
    		    </tr>
		  <%for(int j=0; j<b_cons.getCons_su(); j++){
				ConsignmentBean cons 		= cs_db.getConsignment(cons_no, j+1);%>
		  <%		String from_dt = "";
			  		String from_h = "";
					String from_s = "";
					String get_from_dt = cons.getFrom_dt();
					if(get_from_dt.equals("")) get_from_dt = cons.getFrom_est_dt();
					if(get_from_dt.length() == 12){
						from_dt = get_from_dt.substring(0,8);
						from_h 	= get_from_dt.substring(8,10);
						from_s	= get_from_dt.substring(10,12);
					}
					String to_dt = "";
			  		String to_h = "";
					String to_s = "";
					String get_to_dt = cons.getTo_dt();
					if(get_to_dt.equals("")) get_to_dt = cons.getTo_est_dt();
			  		if(get_to_dt.length() == 12){
						to_dt 	= get_to_dt.substring(0,8);
						to_h 	= get_to_dt.substring(8,10);
						to_s 	= get_to_dt.substring(10,12);
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
        		    <td align="center"><input type='text' name="from_dt" value='<%=AddUtil.ChangeDate2(from_dt)%>' size='12' class='default' onBlur='javascript:this.value=ChangeDate(this.value);'><br>
        			  <input type='text' name="from_h" value='<%=from_h%>' size='1' maxlength="2" class='default'>��
        			  <input type='text' name="from_s" value='<%=from_s%>' size='1' maxlength="2" class='default'>��</td>
        			<td align="center"><input type='text' name="to_dt" value='<%=AddUtil.ChangeDate2(to_dt)%>' size='12' class='default' onBlur='javascript:this.value=ChangeDate(this.value);'><br>
        			  <input type='text' name="to_h" value='<%=to_h%>' size='1' maxlength="2" class='default'>��
        			  <input type='text' name="to_s" value='<%=to_s%>' size='1' maxlength="2" class='default'>��</td>			
        		    <td align="center"><input type='text' name="cons_amt" value='<%=AddUtil.parseDecimal(cons.getCons_amt())%>' size='6' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
        		      <td align="center"><input type='text' name="cons_other_amt" value='<%=AddUtil.parseDecimal(cons.getCons_other_amt())%>' size='6' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
        		    <td align="center"><input type='text' name="oil_amt" value='<%=AddUtil.parseDecimal(cons.getOil_amt())%>' size='6' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>        		    
        		    </td>
        		    <td align="center"><input type='text' name="wash_amt" value='<%=AddUtil.parseDecimal(cons.getWash_amt())%>' size='6' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
        		    <td align="center"><input type='text' name="hipass_amt" value='<%=AddUtil.parseDecimal(cons.getHipass_amt())%>' size='6' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>					
        		    <td align="center"><input type='text' name="other" value='<%=cons.getOther()%>' size='10' class='default'></td>
        		    <td align="center"><input type='text' name="other_amt" value='<%=AddUtil.parseDecimal(cons.getOther_amt())%>' size='6' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
        		    <td align="center"><input type='text' name="tot_amt" value='<%=AddUtil.parseDecimal(cons.getTot_amt())%>' size='6' class='whitenum'></td>
        		    <td align="center"><input type='text' name="tot_dist" value='<%=AddUtil.parseDecimal(cons.getTot_dist())%>' size='7' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>km</td>					  
        		    <td align="center"><input type='text' name="cust_amt" value='<%=AddUtil.parseDecimal(cons.getCust_amt())%>' size='6' class='<%if(cons.getCost_st().equals("2") && cons.getPay_st().equals("1")){%>default<%}else{%>white<%}%>num'></td>
        		    <td align="center"><input type='text' name="cust_pay_dt" value='<%=AddUtil.ChangeDate2(cons.getCust_pay_dt())%>' size='12' class='<%if(cons.getCost_st().equals("2") && cons.getPay_st().equals("1")){%>default<%}else{%>whitetext<%}%>' onBlur='javascript:this.value=ChangeDate(this.value);'></td>			
		        </tr>
		        <%}%>	
		        <tr>
        		    <td colspan="4" class='title'>�հ�</td>
        			<td class='title'><input type='text' name="cons_amt" value='' size='7' class='whitenum' readonly></td>
        			<td class='title'><input type='text' name="cons_other_amt" value='' size='7' class='whitenum' readonly></td>
        		    <td class='title'><input type='text' name="oil_amt" value='' size='7' class='whitenum' readonly></td>
        		    <td class='title'><input type='text' name="wash_amt" value='' size='7' class='whitenum' readonly></td>
        		    <td class='title'><input type='text' name="hipass_amt" value='' size='7' class='whitenum' readonly></td>					
        		    <td class='title'>&nbsp;</td>
        		    <td class='title'><input type='text' name="other_amt" value='' size='7' class='whitenum' readonly></td>
        		    <td class='title'><input type='text' name="tot_amt" value='' size='7' class='whitenum' readonly></td>
        		    <td class='title'>&nbsp;</td>					
        		    <td class='title'><input type='text' name="cust_amt" value='' size='7' class='whitenum' readonly></td>
        		    <td class='title'>&nbsp;</td>						
		        </tr>		  
		    </table>
	    </td>
    </tr>		
	<tr>
	    <td align="right">�� 2009��11��1���� Ź�ۺ��ʹ� ����� ���� ����Ÿ��� �Է��ؾ� �մϴ�.</td>
	</tr>
				
		
	
	<%for(int j=0; j<b_cons.getCons_su(); j++){
		//Ź���Ƿ� 1��
		ConsignmentBean 	cons 		= cs_db.getConsignment(cons_no, j+1);
		CarRegBean 		car 		= crd.getCarRegBean(cons.getCar_mng_id());
		ContCarBean 		car_etc 	= a_db.getContCarNew(cons.getRent_mng_id(), cons.getRent_l_cd());
		ClientBean 		client 		= al_db.getNewClient(cons.getClient_id());
		CarMstBean 		cm_bean 	= cmb.getCarNmCase(String.valueOf(car_etc.getCar_id()), String.valueOf(car_etc.getCar_seq()));
		String to_dt = "";
		String get_to_dt = cons.getTo_dt();
		if(get_to_dt.equals("")) get_to_dt = cons.getTo_est_dt();
  		if(get_to_dt.length() == 12){
			to_dt 	= get_to_dt.substring(0,8);
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
        			  <input type='text' name="car_no" value='<%=car_no%>' size='30' class='<%=white%>text' readonly>
        			  <input type='hidden' name='seq' value='<%=cons.getSeq()%>'>
        			  <input type='hidden' name='car_mng_id' value='<%=cons.getCar_mng_id()%>'>
        			  <input type='hidden' name='rent_mng_id' value='<%=cons.getRent_mng_id()%>'>
        			  <input type='hidden' name='rent_l_cd' value='<%=cons.getRent_l_cd()%>'>
        			  <input type='hidden' name='client_id' value='<%=cons.getClient_id()%>'>
					  (<%=cons.getCar_mng_id()%>)
        			</td>
        			<td width='13%' class='title'>����</td>
        			<td width='37%'>&nbsp;
        			  <input type='text' name="car_nm" value='<%=car.getCar_nm()%>' size='40' class='whitetext' readonly></td>
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
					<!--
        		    <td class='title'>��������Ÿ�</td>
        			<td>&nbsp;
        			  	<%Hashtable b_ht = shDb.getCarDistView2(cons.getCar_mng_id(), to_dt);%>
						<%if(!String.valueOf(b_ht.get("TOT_DIST")).equals("")){%>
						<b><%=AddUtil.parseDecimal(String.valueOf(b_ht.get("TOT_DIST")))%>km (<%=AddUtil.ChangeDate2(String.valueOf(b_ht.get("TOT_DT")))%>)</b>
						<span class="b"><a href="javascript:view_car_service('<%=cons.getCar_mng_id()%>')" onMouseOver="window.status=''; return true" title="���񳻿�����"><img src=/acar/images/center/button_in_jhir.gif align=absmiddle border=0></a></span>							  
						<input type='hidden' name='v_tot_dist' value='<%=b_ht.get("TOT_DIST")%>'>
						<%}else{%>
						<input type='hidden' name='v_tot_dist' value=''>
						<%}%>						
        			</td>
					-->
    		    </tr>
    		</table>
	    </td>
    </tr>
	<tr id=tr_cons<%=j%>_3 style="display:''">
	    <td align="right">&nbsp;</td>
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
                        <option value='<%=user.get("USER_ID")%>' <%if(cons.getReq_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}%>
                      </select>
                      &nbsp;
                      �� �Ƿ���
                      <input name="agent_emp_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(cons.getAgent_emp_id(),"CAR_OFF_EMP")%>" size="12"> 
			<input type="hidden" name="agent_emp_id" value="<%=cons.getAgent_emp_id()%>">
			<a href="javascript:Agent_User_search('agent_emp_id', <%=j%>);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>						 
                      
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
			  <input type='hidden' name='cost_st2' value='<%=cons.getCons_st()%>'>
			</td>						
		    <td colspan="2" class='title'>���ޱ���</td>
			<td>&nbsp;
			  <select name="pay_st" <%=disabled%>>
			    <option value="">����</option>
			    <option value="1" <%if(cons.getPay_st().equals("1")){%>selected<%}%>>����</option>
			    <option value="2" <%if(cons.getPay_st().equals("2")){%>selected<%}%>>�ĺ�</option>								
  			  </select>
			  <input type='hidden' name='pay_st2' value='<%=cons.getPay_st()%>'>
			</td>						
	      </tr>
		  <tr>
		    <td rowspan="4" class='title'>��<br>
	        û</td>
		    <td class='title'>����</td>
		    <td colspan="4">&nbsp;
			  <select name="wash_yn" <%=disabled%>>
			    <option value="">����</option>
			    <option value="Y" <%if(cons.getWash_yn().equals("Y")){%>selected<%}%>>��û</option>
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
        		    	<%if(disabled.equals("disabled")){%>        		    	          		    	  
        		    	  <%if(cons.getHipass_yn().equals("Y")){%><font color='red'><b>��û</b></font><%}%>
        		    	  <%if(cons.getHipass_yn().equals("N")){%>����<%}%>
        		    	  
        		    	<%}else{%>
        			  <select name="hipass_yn" <%=disabled%>>
        			    <option value="Y" <%if(cons.getHipass_yn().equals("Y")){%>selected<%}%>>��û</option>
        			    <option value="N" <%if(cons.getHipass_yn().equals("N")||cons.getHipass_yn().equals("")){%>selected<%}%>>����</option>								
          			  </select>
					  (��ϴ��� �Ƿڽ� �����Ͻʽÿ�.)        		    	  
        		    	<%}%>
        		    </td>
    	        </tr>					  
		  <tr>
		    <td class='title'>��Ÿ</td>
		    <td colspan="4">&nbsp;
              <textarea rows='5' cols='90' name='etc' class='<%=white%>'><%=cons.getEtc()%></textarea></td>
	      </tr>		  
		  <tr>
		    <td width="3%" rowspan="7" class='title'>��<br>��</td>
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
			  <span class="b"><a href="javascript:cng_input3('from', document.form1.from_st[<%=j%>].options[document.form1.from_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">��ȸ</a></span>
			  <%}%>
			</td>
		    <td width="3%" rowspan="7" class='title'>��<br>��</td>
		    <td width="10%" class='title'>����</td>
		    <td width="37%">&nbsp;
			  <select name="to_st" onChange="javascript:cng_input3('to', this.value, <%=j%>)" <%=disabled%>>
			    <option value="">����</option>
			    <option value="1" <%if(cons.getTo_st().equals("1")){%>selected<%}%>>�Ƹ���ī</option>
			    <option value="2" <%if(cons.getTo_st().equals("2")){%>selected<%}%>>��</option>
			    <option value="3" <%if(cons.getTo_st().equals("3")){%>selected<%}%>>���¾�ü</option>				
  			  </select>
			  <%if(white.equals("")){%>			
			  <span class="b"><a href="javascript:cng_input3('to', document.form1.to_st[<%=j%>].options[document.form1.to_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">��ȸ</a></span>
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
			  <span class="b"><a href="javascript:cng_input5('from', document.form1.from_st[<%=j%>].options[document.form1.from_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">��ȸ</a></span>
			  <%}%>
			</td>
		    <td class='title'>�����</td>
		    <td>&nbsp;�μ�/����
		      <input type='text' name="to_title" value='<%=cons.getTo_title()%>' size='20' class='<%=white%>text' ><br>
			  &nbsp;����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			  <input type='text' name="to_man" value='<%=cons.getTo_man()%>' size='20' class='<%=white%>text' >
			  <%if(white.equals("")){%>
			  <span class="b"><a href="javascript:cng_input5('to', document.form1.to_st[<%=j%>].options[document.form1.to_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">��ȸ</a></span>
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
		  <tr>
		    <td class='title'>�����Ͻ�</td>
		    <td>&nbsp;
			  <%	String from_est_dt = "";
			  		String from_est_h = "";
					String from_est_s = "";
			  		if(cons.getFrom_est_dt().length() == 12){
						from_est_dt = cons.getFrom_est_dt().substring(0,8);
						from_est_h 	= cons.getFrom_est_dt().substring(8,10);
						from_est_s	= cons.getFrom_est_dt().substring(10,12);
					}%>			
              <input type='text' name="from_est_dt" value='<%=AddUtil.ChangeDate2(from_est_dt)%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value); document.form1.to_est_dt[<%=j%>].value=this.value;'>
			  &nbsp;
			  <select name="from_est_h" <%=disabled%>>
                <%for(int i=0; i<24; i++){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(from_est_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                <%}%>
              </select>
              <select name="from_est_s" <%=disabled%>>
                <%for(int i=0; i<59; i+=5){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(from_est_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                <%}%>
              </select>
			  </td>
	        <td class='title'>�����Ͻ�</td>
	        <td>&nbsp;
			  <%	String to_est_dt = "";
			  		String to_est_h = "";
					String to_est_s = "";
			  		if(cons.getTo_est_dt().length() == 12){
						to_est_dt 	= cons.getTo_est_dt().substring(0,8);
						to_est_h 	= cons.getTo_est_dt().substring(8,10);
						to_est_s 	= cons.getTo_est_dt().substring(10,12);
					}%>						
              <input type='text' name="to_est_dt" value='<%=AddUtil.ChangeDate2(to_est_dt)%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value);'>
			  &nbsp;
			  <select name="to_est_h" <%=disabled%>>
                <%for(int i=0; i<24; i++){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(to_est_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                <%}%>
              </select>
              <select name="to_est_s" <%=disabled%>>
                <%for(int i=0; i<59; i+=5){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(to_est_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
                <%}%>
              </select>
			  </td>
		  </tr>
		  <%	String driver_nm = cons.getDriver_nm();
		  		if(cons.getOff_id().equals("003158")) driver_nm = c_db.getNameById(cons.getDriver_nm(),"USER");%>
		  <tr>
		    <td colspan="2" class='title'>�����ڸ�</td>
            <td>&nbsp;
                <input type='text' name="driver_nm" value='<%=driver_nm%>' size='15' class='default'>
				<input type='hidden' name="driver_id" value='<%=cons.getDriver_nm()%>'>
				&nbsp;<span class="b"><a href="javascript:cng_input6('driver','3',<%=j%>)" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif" align="absbottom" border="0"></a></a></span>
			</td>
            <td colspan="2" class='title'>�������ڵ���</td>
            <td>&nbsp;
                <input type='text' name="driver_m_tel" value='<%=cons.getDriver_m_tel()%>' size='15' class='default'></td>
	      </tr>		  
        </table>
      </td>
    </tr>	
	<tr id=tr_cons<%=j%>_5 style="display:''">
	  <td align="right">
	    <%if(doc.getUser_id1().equals(user_id) || b_cons.getReg_id().equals(user_id)){%>
	    <%		if(!doc.getUser_dt2().equals("")){}else{%>		
		<a href="javascript:save(<%=j%>);"><img src="/acar/images/center/button_modify.gif" align="absbottom" border="0"></a>	
		<%		}%>
		<%}%>
	    &nbsp;<a href="javascript:ConsPrint(<%=cons.getSeq()%>)"><img src="/acar/images/printer.gif" border="0"></a></td>
	</tr>		
	<%}%>			
	<tr>
	  <td align="right">&nbsp;</td>
	</tr>		

  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	set_amt();
//-->
</script>
</body>
</html>
