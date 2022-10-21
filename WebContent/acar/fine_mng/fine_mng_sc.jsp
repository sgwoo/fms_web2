<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.common.*, acar.client.*, acar.res_search.*, acar.user_mng.*, acar.im_email.*, acar.admin.*,java.net.URLEncoder" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" 	scope="page" class="acar.forfeit_mng.FineGovBean"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<jsp:useBean id="rl_bean" class="acar.common.RentListBean" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String f_list = request.getParameter("f_list")==null?"":request.getParameter("f_list");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String seq_no = request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String imgUrl = "";
	String yyyy = "";
	String fileName = "";
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String fault_st = request.getParameter("fault_st")==null?"":request.getParameter("fault_st");
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	auth_rw = rs_db.getAuthRw(user_id, "03", "06", "01");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	ForfeitDatabase fdb = ForfeitDatabase.getInstance();
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	
	//��������
	if(!c_id.equals("")){//���� ������ �˻��Ѵ�.
		rl_bean = fdb.getCarRent(c_id, m_id, l_cd);
	}
	
	//���·�����
	if(!c_id.equals("") && !seq_no.equals("")){//���� ������ �˻��Ѵ�.
		f_bean = a_fdb.getForfeitDetailAll(c_id, m_id, l_cd, seq_no);
		if(f_bean.getNote().equals("���·� OCR ���")) {
			if (f_bean.getFile_name() != null && !f_bean.getFile_name().equals("")){
				String[] fileNames =  f_bean.getFile_name().split("/");
				yyyy = fileNames[0];
				fileName = fileNames[1];
						
				imgUrl = "https://ocr.amazoncar.co.kr:8443/fine_mng/"+yyyy+"/"+ URLEncoder.encode(fileName, "EUC-KR");
			}
		}
	}
	
	//���·� ���ǽ�û����
	if(!c_id.equals("") && !seq_no.equals("")){//���� ������ �˻��Ѵ�.
		FineDocListBn = FineDocDb.getFineDocList(c_id, seq_no, m_id, l_cd);
		if(!FineDocListBn.getDoc_id().equals("")){
			FineDocBn = FineDocDb.getFineDoc(FineDocListBn.getDoc_id());
		}
		FineGovBn = FineDocDb.getFineGov(f_bean.getPol_sta());
	}
				
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//�ܺξ�ü ����Ʈ
	Vector outside = c_db.getUserList("", "", "OUTSIDE");
	int outside_size = outside.size();
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 3; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	if(f_bean.getMng_id().equals("")){
		if(f_bean.getFault_nm().equals(""))		f_bean.setMng_id(rl_bean.getBus_id2());
		else																	f_bean.setMng_id(f_bean.getFault_nm());
	}
	
	//�ŷ�ó
	ClientBean client = al_db.getClient(rl_bean.getClient_id());
	
	//email
	Hashtable base = ad_db.getContEmail(m_id, l_cd);	
	String email = String.valueOf(base.get("EMAIL"));
	
	
	
	
	String otime ="";

	int size = 0;
	
	String content_code = "FINE";
	String content_seq  = m_id+l_cd+c_id+seq_no;

	Vector attach_vt = null;
	int attach_vt_size = 0;
	
	if(!m_id.equals("")&&!l_cd.equals("")&&!c_id.equals("")&&!seq_no.equals("")){
		attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
		attach_vt_size = attach_vt.size();
	}
	
	String file_type1 = "";
	String seq1 = "";
	String file_type2 = "";
	String seq2 = "";
	String file_type3 = "";
	String seq3 = "";
	String file_name1 = "";
	String file_name2 = "";
	String file_name3 = "";
	String file_size3 = "";
	
	if(attach_vt_size >0){
		for(int i=0; i< attach_vt.size(); i++){
	    	Hashtable ht = (Hashtable)attach_vt.elementAt(i);   
			
			if((content_seq+1).equals(ht.get("CONTENT_SEQ"))){
				file_name1 = String.valueOf(ht.get("FILE_NAME"));
				file_type1 = String.valueOf(ht.get("FILE_TYPE"));
				seq1 = String.valueOf(ht.get("SEQ"));
				
			}else if((content_seq+2).equals(ht.get("CONTENT_SEQ"))){
				file_name2 = String.valueOf(ht.get("FILE_NAME"));
				file_type2 = String.valueOf(ht.get("FILE_TYPE"));
				seq2 = String.valueOf(ht.get("SEQ"));
				
			}else if((content_seq+3).equals(ht.get("CONTENT_SEQ"))){
				file_name3 = String.valueOf(ht.get("FILE_NAME"));
				file_type3 = String.valueOf(ht.get("FILE_TYPE"));
				seq3 = String.valueOf(ht.get("SEQ"));
				file_size3 = String.valueOf(ht.get("FILE_SIZE"));
			}
		}	
	}
	
	//�ȳ��� ���� ���� (20190619)
	CommonEtcBean[] ce_bean = c_db.getCommonEtcAll("fine_notice_ment", "", "", "", "", "", "", "", "");
	int ce_bean_size = ce_bean.length;
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table_ts.css">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
$(document).ready(function(){
	change_fine_st('<%=f_bean.getFine_st()%>');
});
<!--
		var popObj = null;
		
	//������ ����ý��� ��ȸ
	function CarResSearch(){
		var fm = document.form1;
		var SUBWIN="./car_rent_list_s.jsp?c_id="+fm.c_id.value;	
		window.open(SUBWIN, "CarResList", "left=100, top=100, width=820, height=600, scrollbars=yes");
	}
	
	//����Ʈ �޸�
	function RentMemo(s_cd, c_id, user_id){
		var SUBWIN="/acar/con_rent/res_memo_i.jsp?s_cd="+s_cd+"&c_id="+c_id+"&user_id="+user_id;	
		window.open(SUBWIN, "RentMemoDisp", "left=100, top=100, width=580, height=700, scrollbars=yes");
	}	

	//���·�ݾ� ����
	function set_paid_amt(){
		var fm = document.form1;
		var vio_cont  = replaceString(' ','',fm.vio_cont.value);

			if(vio_cont.indexOf('�ӵ�') != -1){
				fm.paid_amt.value = parseDecimal("40000");
				var s_len 	= vio_cont.indexOf('(')+1;
				var e_len 	= vio_cont.indexOf(')');	
				var add_km 	= toInt(vio_cont.substring(s_len, e_len));
				if(add_km <=20) 								fm.paid_amt.value = parseDecimal("40000");
				if(add_km >20 && add_km <=40) 	fm.paid_amt.value = parseDecimal("70000");
				if(add_km >40) 									fm.paid_amt.value = parseDecimal("100000");
				fm.vio_st.value='1';
			}
			
			if( vio_cont.indexOf('������') != -1) {		
				fm.paid_amt.value = parseDecimal("40000");		
				fm.vio_st.value='1';
			}
			
			if( vio_cont.indexOf('������') != -1) {		
				fm.paid_amt.value = parseDecimal("40000");		
				fm.vio_st.value='1';
			}

			if( vio_cont.indexOf('����') != -1) {		
				fm.paid_amt.value = parseDecimal("70000");		
				fm.vio_st.value='1';
			}

			if(vio_cont.indexOf('��ȣ') != -1){		
				fm.paid_amt.value = parseDecimal("70000");		
				fm.vio_st.value='1';
			}		

			if(vio_cont.indexOf('����') != -1){		
				fm.paid_amt.value = parseDecimal("50000");		
				fm.vio_st.value='1';
			}	

			if(vio_cont.indexOf('���') != -1){					
				fm.paid_amt.value = parseDecimal("90000");
				fm.vio_st.value='1';
			}

			if(vio_cont.indexOf('�߾Ӽ�') != -1){		
				fm.paid_amt.value = parseDecimal("90000");		
				fm.vio_st.value='1';
			}

			if(vio_cont.indexOf('����') != -1){		
				fm.paid_amt.value = parseDecimal("90000");		
				fm.vio_st.value='1';
			}

			if(vio_cont.indexOf('����') != -1){		
				fm.paid_amt.value = parseDecimal("50000");
				fm.vio_st.value='5';
			}
		
			if(vio_cont.indexOf('�����') != -1 && vio_cont.indexOf('����') != -1){		
				fm.paid_amt.value = parseDecimal("100000");
				fm.vio_st.value='4';
			}
		
			if(vio_cont.indexOf('�����̳�') != -1){
				fm.paid_amt.value = parseDecimal("");
				fm.vio_st.value='2';
			}
		
			if(vio_cont.indexOf('������ݹ̳�') != -1){
				fm.paid_amt.value = parseDecimal("");
				fm.vio_st.value='3';
			}
	}

	//���·�û����� �˻��ϱ�
	function fine_gov_search(){
		var fm = document.form1;	
		window.open("../fine_doc_reg/fine_gov_search.jsp?t_wd="+fm.gov_nm.value, "SEARCH_FINE_GOV", "left=200, top=200, width=900, height=450, scrollbars=yes");
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') {
			var fm = document.form1;
			if(fm.gov_nm.value == '1' || fm.gov_nm.value == '2'){
				gov_set();
			}else{
				fine_gov_search();
			}					
		}
	}
	
	function fine_set(){
		var fm = document.form1;	
		
		if(fm.fine_nm.value == '1'){
			fm.fine_nm.value = '����';
			fm.fine_gb.value = '1';
		}else if(fm.fine_nm.value == '2'){
			fm.fine_nm.value = '�۱�';
			fm.fine_gb.value = '2';
		
		}
	}
	
	function gov_set(){
		var fm = document.form1;	
		
		if(fm.gov_nm.value == '1'){
			fm.gov_nm.value = '��õ��������';
			fm.gov_id.value = '302';
		}else if(fm.gov_nm.value == '2'){
			fm.gov_nm.value = '���ְ�������';
			fm.gov_id.value = '178';
		}else if(fm.gov_nm.value == '3'){
			fm.gov_nm.value = '���￵������������';
			fm.gov_id.value = '079';		
		}else if(fm.gov_nm.value == '4'){
			fm.gov_nm.value = '��õ��������';
			fm.gov_id.value = '411';	
		}else if(fm.gov_nm.value == '5'){
			fm.gov_nm.value = '�ѱ����ΰ���';
			fm.gov_id.value = '339';	
		}else if(fm.gov_nm.value == '6'){
			fm.gov_nm.value = '�����ߺΰ�����(�ο���)';
			fm.gov_id.value = '588';	
		}	
		
	}
	
	function gov_set2(){
		var fm = document.form1;	
		
		if(fm.vio_cont.value == '1'){
			fm.vio_cont.value = '�ӵ�( km)';
		}else if(fm.vio_cont.value == '2'){
			fm.vio_cont.value = '����������';
		}else if(fm.vio_cont.value == '3'){
			fm.vio_cont.value = '�����̳�';
		}else if(fm.vio_cont.value == '4'){
			fm.vio_cont.value = '������ݹ̳�';
		}else if(fm.vio_cont.value == '5'){
			fm.vio_cont.value = '����������������';
		}else if(fm.vio_cont.value == '6'){
			fm.vio_cont.value = '���������������������';
		}
		
		set_paid_amt();
	}
	
	//���ο� �Է� ȭ��
	function ClearM(){
		var fm = document.form1;
		fm.seq_no.value = '';
		fm.target = 'd_content';
		fm.action = 'fine_mng_frame.jsp';
		fm.submit();
	}

	//���
	function ForfeitReg(){
		var fm = document.form1;

		if(fm.seq_no.value!=""){	alert("�������� �����մϴ�.");	return;	}
		
		if(fm.m_id.value==""){			alert("���õ� �ڵ����� �����ϴ�");									return;	}
		if(fm.l_cd.value==""){			alert("���õ� �ڵ����� �����ϴ�");									return;	}
		if(fm.c_id.value==""){			alert("���õ� �ڵ����� �����ϴ�");									return;	}
		if(fm.vio_ymd.value==""){		alert("�������ڸ� �Է��Ͻʽÿ�");			fm.vio_ymd.focus();		return;	}
		if(fm.vio_s.value==""){			alert("���ݽð��� �Է��Ͻʽÿ�");			fm.vio_s.focus();		return;	}
		if(fm.vio_m.value==""){			alert("���ݽð��� �Է��Ͻʽÿ�");			fm.vio_m.focus();		return;	}
		if(fm.vio_pla.value==""){		alert("������Ҹ� �Է��Ͻʽÿ�");			fm.vio_pla.focus();		return;	}
		if(fm.paid_no.value==""){		alert("���ΰ�������ȣ�� �Է��Ͻʽÿ�");		fm.paid_no.focus();		return;	}
		if(fm.vio_cont.value==""){		alert("���ݳ��븦 �Է��Ͻʽÿ�");			fm.vio_cont.focus();	return;	}
		if(fm.gov_nm.value==""){		alert("û������� �����Ͻʽÿ�");			fm.gov_nm.focus();		return;	}
		if(fm.mng_id.value==""){		alert("����ڸ� �����Ͻʽÿ�");				fm.mng_id.focus();		return;	}		
		if(toInt(parseDigit(fm.paid_amt.value)) < 1 ){		alert("���αݾ��� �Է��Ͻʽÿ�");		fm.paid_amt.focus();		return;}
		//�ܺξ�ü���� �ΰ�� -> ���Ǿ�ü �븮���̼�(20190904)
		if(fm.fault_st.value=='3' && $("#fault_nm_off").val() ==""){		alert("�������Ǿ�ü�� �������ּ���");	$("#fault_nm_off").focus();		return;	}
		
		//�Ƹ���ī ���������̰� ���α����� �����ں��� �϶�, �������ڰ� �Ӵ�Ⱓ�� ������ ����� ���(20181016)
		<%if(rl_bean.getFirm_nm().indexOf("�Ƹ���ī") != -1){%>
			if(fm.paid_st.value=='1'){ //���α����� �����ں����϶�
				var res_sdt = fm.res_sdt.value.replace(/-/g,"").replace("��","").replace("��","").replace(" ","");
				var res_edt = fm.res_edt.value.replace(/-/g,"").replace("��","").replace("��","").replace(" ","");
				var vio_dt = fm.vio_ymd.value.replace(/-/g,"")+""+fm.vio_s.value+""+fm.vio_m.value;
				if(vio_dt < res_sdt || vio_dt > res_edt){
					alert("�����Ͻð� �뿩�Ⱓ ������ �ƴմϴ�.");	return;
				}
			}
		<%}%>
		
		fm.cmd.value = "i";
		fm.vio_dt.value = fm.vio_ymd.value + "" + fm.vio_s.value + "" +fm.vio_m.value; 
		
		if(!confirm('����Ͻðڽ��ϱ�?')){
			return;
		}
		
		fm.target = 'i_no';
		fm.action = "fine_mng_i_a.jsp";		
		fm.submit();
	}

	//����
	function ForfeitUp(){
		var fm = document.form1;
		if(fm.seq_no.value==""){	alert("��ϸ��� �����մϴ�.");	return;	}		
		if(fm.m_id.value==""){			alert("���õ� �ڵ����� �����ϴ�");									return;	}
		if(fm.l_cd.value==""){			alert("���õ� �ڵ����� �����ϴ�");									return;	}
		if(fm.c_id.value==""){			alert("���õ� �ڵ����� �����ϴ�");									return;	}
		if(fm.vio_ymd.value==""){		alert("�������ڸ� �Է��Ͻʽÿ�");			fm.vio_ymd.focus();		return;	}
		if(fm.vio_s.value==""){			alert("���ݽð��� �Է��Ͻʽÿ�");			fm.vio_s.focus();		return;	}
		if(fm.vio_m.value==""){			alert("���ݽð��� �Է��Ͻʽÿ�");			fm.vio_m.focus();		return;	}
		if(fm.vio_pla.value==""){		alert("������Ҹ� �Է��Ͻʽÿ�");			fm.vio_pla.focus();		return;	}
		if(fm.paid_no.value==""){		alert("���ΰ�������ȣ�� �Է��Ͻʽÿ�");		fm.paid_no.focus();		return;}
		if(fm.vio_cont.value==""){		alert("���ݳ��븦 �Է��Ͻʽÿ�");			fm.vio_cont.focus();	return;	}
		if(fm.gov_nm.value==""){		alert("û������� �����Ͻʽÿ�");			fm.gov_nm.focus();		return;	}
		//�ܺξ�ü���� �ΰ�� -> ���Ǿ�ü �븮���̼�(20190904)
		if(fm.fault_st.value=='3' && $("#fault_nm_off").val() ==""){		alert("�������Ǿ�ü�� �������ּ���");	$("#fault_nm_off").focus();		return;	}
		
		if(!confirm('�����Ͻðڽ��ϱ�?')){
			return;
		}
		fm.cmd.value = "u";
		fm.vio_dt.value = fm.vio_ymd.value + "" + fm.vio_s.value + "" +fm.vio_m.value;
		fm.target = 'i_no';
		fm.action = "fine_mng_i_a.jsp";		
		fm.submit();
	}

	//����
	function ForfeitDel(){
		var fm = document.form1;
		if(fm.seq_no.value==""){	alert("��ϸ��� �����մϴ�.");	return;	}

		if(!confirm('�����Ͻðڽ��ϱ�?')){
			return;
		}
		if(!confirm('�ٽ��ѹ� Ȯ���Ͻʽÿ�. \n\n��¥�� �����Ͻðڽ��ϱ�?')){
			return;
		}
		fm.cmd.value = "d";
		fm.target = 'i_no';
		fm.action = "fine_mng_i_a.jsp";		
		fm.submit();
	}
	
	//����Ʈ ����
	function go_to_list(){
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var br_id 	= fm.br_id.value;
		var user_id	= fm.user_id.value;
		var gubun1 	= fm.gubun1.value;
		var gubun2 	= fm.gubun2.value;
		var gubun3 	= fm.gubun3.value;
		var gubun4 	= fm.gubun4.value;		
		var st_dt 	= fm.st_dt.value;
		var end_dt 	= fm.end_dt.value;
		var s_kd 	= fm.s_kd.value;
		var t_wd 	= fm.t_wd.value;
		var sort_gubun = fm.sort_gubun.value;
		var asc 	= fm.asc.value;
		if(fm.f_list.value == 'in'){
			parent.location = "/acar/con_forfeit/forfeit_frame_s.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc;
		}else{
			parent.location = "/acar/forfeit_mng/forfeit_s_frame.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc;
		}
	}	
	
	//���ű�� ���� 
	function view_fine_gov(gov_id){
		window.open("../fine_doc_reg/fine_gov_c.jsp?gov_id="+gov_id, "view_FINE_GOV", "left=200, top=200, width=560, height=150, scrollbars=yes");
	}
	
	//
	function fine_display(){
		var fm = document.form1;
		if(fm.paid_st.options[fm.paid_st.selectedIndex].value == '1'){
			tr_31.style.display			= 'none';
			tr_32.style.display 		= 'none';
		}else{
			tr_31.style.display			= '';
			tr_32.style.display 		= '';
		}	
	}
	
	function fine_list(){
		var fm = document.form1;
		if(fm.fault_st.value == '3'){
			gubun.style.display = "none";
			gubun1.style.display = "";
		}else{
			gubun.style.display = "";
			gubun1.style.display = "none";
		}	
	}
	
			
	//��ĵ���
	function scan_reg(file_st){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&seq_no=<%=seq_no%>&file_st="+file_st, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
			
	//��ĵ����
	function scan_del(file_st){
		var fm = document.form1;
		if(!confirm('�����Ͻðڽ��ϱ�?')){		return;	}
		fm.file_st.value = file_st;		
		fm.target = "i_no"
		fm.action = "del_scan_a.jsp";
		fm.submit();
		
		fm.file_st.value = '';		
	}	
		
	//�˾������� ����-��ĵ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/fine/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}	
	
	//�˾������� ����
	function ScanOpen(theURL,file_type) { //v2.0

		if( popObj != null ){
			popObj.close();
			popObj = null;
		}

		var mydate=new Date()
		var year=mydate.getYear()
			if (year < 1000)
				year+=1900

		var day=mydate.getDay()
		var month=mydate.getMonth()+1
			if (month<10)
				month="0"+month

		var daym=mydate.getDate()
			if (daym<10)
				daym="0"+daym
		
		var ckdate = year+month+daym

		theURL = "https://fms3.amazoncar.co.kr/data/fine/"+theURL+""+file_type;
		

		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj = window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}
		
		popObj.location = theURL;
		popObj.focus();
	
	}
	
//�Ѱ������� �������� ���·� ���� �Է½�	
	function fine_gov_in(){
		var fm = document.form1;	
		window.open("fine_gov_in.jsp", "fine_gov_in", "left=200, top=20, width=750, height=700, scrollbars=yes");
	}
	
	//���Ϲ߼�
	function doc_email2(){
	   
		var fm = document.form1;
		if(fm.email.value==""||fm.email.value=="null"){		alert("�̸����� �Է����ּ���.");		return;		}
		if(fm.fine_st.value=="3"){	//�ȳ��� �߼� �߰�(20190620)
		<%-- <%if(file_name3.equals("")){%>
				alert("��ϵ� ������ �����ϴ�.");		return;
		<%}%> --%>
			if(confirm('��ϵ� ��ĵ���ϰ� �ȳ�������� ������ �߼��ϰڽ��ϱ�?')){
				fm.action="/fms2/forfeit_mng/forfeit_notice_mail_a.jsp";	
			}
		}else{
			if(fm.paid_st.value == '1'||fm.paid_st.value == '2'||fm.paid_st.value == '4'){ //������ ���� ���·� ����� �ȳ�.
				if(confirm('������ ���� ������ �߼��ϰڽ��ϱ�?')){	
					fm.action="/fms2/forfeit_mng/forfeit_nbc_mail_a.jsp";	
				}
			}else if(fm.paid_st.value == '3'){
				if(confirm('�������·� ������ �߼��ϰڽ��ϱ�?')){	
					fm.action="/fms2/forfeit_mng/forfeit_sn_mail_a.jsp";			
				}
			}
		}
		
		fm.vio_dt.value=<%= f_bean.getVio_dt()%>;
		fm.target='i_no';
		fm.submit();
	}
	
	//������߼�
	function doc_email1(){
	   
		var fm = document.form1;
		if(fm.email.value==""||fm.email.value=="null"){		alert("�̸����� �Է����ּ���.");		return;		}
		if(confirm('������ ��߼� �߼��ϰڽ��ϱ�?')){	
			if(fm.fine_st.value=="3"){
				<%-- <%if(file_name3.equals("")){%>
						alert("��ϵ� ������ �����ϴ�.");		return;
				<%}%> --%>
				fm.action="/fms2/forfeit_mng/forfeit_notice_mail_a.jsp";
			}else{
				if(fm.paid_st.value == '1'||fm.paid_st.value == '2'||fm.paid_st.value == '4'){ //������ ���� ���·� ����� �ȳ�.
					fm.action="/fms2/forfeit_mng/forfeit_nbcr_mail_a.jsp";			
				}else if(fm.paid_st.value == '3'){
					fm.action="/fms2/forfeit_mng/forfeit_doc_mail_a.jsp";			
				}
			}
			fm.vio_dt.value=<%= f_bean.getVio_dt()%>;
			fm.target='i_no';
			fm.submit();
		}											
	}
	
	function checkBoxValidate(cb) {
		for (j = 0; j < 2; j++) {
			if (eval("document.form1.fine_gb[" + j + "].checked") == true) {
				document.form1.fine_gb[j].checked = false;
				if (j == cb) {
					document.form1.fine_gb[j].checked = true;
				}
			}
	   }
	}
	
	
	//���ͳ� ������ ���� ���ڰ���
	function writeBox(){
	var fm = document.form1;
	if(fm.intext.checked) {
		fm.paid_no.value = "���ͳ� ������ ���� ���ڰ���";
	}else{
		fm.paid_no.value = "";
	}

	}
	
	
	function miss_write(){
		var fm = document.form1;	
		
		if(fm.paid_amt2.value > 10){
			fm.note.value = '���� ���·�';
		}
	}
	
	//����ϱ�
	function fine_reg(){
		window.open("/acar/fine_gov/fine_gov_i.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>", "REG_FINE_GOV", "left=200, top=200, width=550, height=400, scrollbars=yes");
	}
	
	//���� ����
	function change_fine_st(val){
		var fm = document.form1;
		if(val=="3"){	
			$("#file_gubun_text").html("�ȳ���");
			$(".notice_tag, #view_notice").css("display","");
			$("#view_fine").css("display","none");
		}else{
			$("#file_gubun_text").html("������/������");
			$(".notice_tag, #view_notice").css("display","none");
			$("#view_fine").css("display","");
		}
	}
	
	//���·� �ȳ��� ���� ���� �˾�
	function go_notice_pop(){
		window.open("fine_notice_pop.jsp", "FINE_NOTICE", "left=200, top=200, width=550, height=400, scrollbars=yes");
	}
	
	//���·� �ȳ��� ���� ���̱�
	function view_notice_ment(val){
		window.open("fine_notice_pop_a.jsp?mode=VIEW&col_1_val="+val, "FINE_NOTICE", "left=200, top=200, width=10, height=10, scrollbars=yes");
	}
	
	function msg_modify(){
		var fm = document.form1;
		var msg = $("#notice_ment").html();
		$("#notice_ment").html(msg.replace(/<br>/gi,"\n"));
	}
//-->
</script>

<body>
<form action="" name="form1" method="POST" >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='f_list' value='<%=f_list%>'>
<input type="hidden" name="m_id" value="<%=m_id%>">
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type="hidden" name="seq_no" value="<%=seq_no%>">
<input type="hidden" name="s_cd" value="<%=f_bean.getRent_s_cd()%>">
<input type="hidden" name="vio_dt" value="">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="file_st" value="">
<input type="hidden" name="firm_nm" value="<%=client.getFirm_nm()%>">
<input type='hidden' name='from_page' value='<%=from_page%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <%if(rl_bean.getFirm_nm().indexOf("�Ƹ���ī") != -1 && f_bean.getRent_s_cd().equals("")){%>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span>&nbsp;&nbsp;<a href="javascript:CarResSearch()"><img src=../images/center/button_buc.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr>
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="15%">��ȣ</td>
                    <td width="35%">
                      <input type="text" name="res_firm" value="" size="30" class=text readonly>
                              
                    </td>
                    <td class=title width="15%">����</td>
                    <td width="35%">
                      <input type="text" name="res_client" value="" size="30" class=text readonly>
                    </td>
                </tr>
                <tr> 
                    <td class=title>��౸��</td>
                    <td width="35%">
                      <input type="text" name="res_st" value="" size="30" class=text readonly>
                    </td>
                    <td class=title width="15%">�뿩�Ⱓ</td>
                    <td> 
                      <input type="text" name="res_sdt" value="" size="20" class=text readonly>
                      ~
                      <input type="text" name="res_edt" value="" size="20" class=text readonly>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<%}%>
    <%if(!f_bean.getRent_s_cd().equals("")){//����ý��� ��� �����̸�
		//�ܱ�������
		RentContBean rc_bean = rs_db.getRentContCase(f_bean.getRent_s_cd(), c_id);
		//������
		RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
		rent_st = rc_bean.getRent_st();
		if(rent_st.equals("1"))		rent_st = "�ܱ�뿩";
		else if(rent_st.equals("2"))	rent_st = "�������";
		else if(rent_st.equals("3"))	rent_st = "������";
		else if(rent_st.equals("4"))	rent_st = "�����뿩";
		else if(rent_st.equals("5"))	rent_st = "��������";
		else if(rent_st.equals("6"))	rent_st = "��������";
		else if(rent_st.equals("7"))	rent_st = "��������";
		else if(rent_st.equals("8"))	rent_st = "�������";
		else if(rent_st.equals("9"))	rent_st = "�������";
		else if(rent_st.equals("10"))	rent_st = "��������";
		else if(rent_st.equals("12"))	rent_st = "����Ʈ";
	%>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span>&nbsp;&nbsp;<a href="javascript:CarResSearch()"><img src=../images/center/button_buc.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr>
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="15%">��ȣ</td>
                    <td width="35%">
                      <input type="text" name="res_firm" value="<%=rc_bean2.getFirm_nm()%>" size="30" class=text readonly>
                     <%  if ( rent_st.equals("����Ʈ")   ) { %> 
                      &nbsp;&nbsp;<a href="javascript:RentMemo('<%=f_bean.getRent_s_cd()%>','<%=f_bean.getCar_mng_id()%>','<%=ck_acar_id%>')"><img src=../images/center/button_th.gif align=absmiddle border=0></a>
                    <% } %>
                  
                    </td>
                    <td class=title width="15%">����</td>
                    <td width="35%">
                      <input type="text" name="res_client" value="<%=rc_bean2.getCust_nm()%>" size="30" class=text readonly>
                    </td>
                </tr>
                <tr> 
                    <td class=title>��౸��</td>
                    <td width="35%">
                      <input type="text" name="res_st" value="<%=rent_st%>" size="30" class=text readonly>
                    </td>
                    <td class=title width="15%">�뿩�Ⱓ</td>
                    <td> 
                      <input type="text" name="res_sdt" value="<%=AddUtil.ChangeDate3(rc_bean.getDeli_dt_d())%>" size="20" class=text readonly>
                      ~
                      <input type="text" name="res_edt" value="<%=AddUtil.ChangeDate3(rc_bean.getRet_dt_d())%>" size="20" class=text readonly>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<%}%>
	<%if(!seq_no.equals("")){%>
    <tr> 
        <td width="30%"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ĵ����<%if(f_bean.getPaid_st().equals("3")){%>&����<%}%></span> [<%=c_id%>:<%=seq_no%>]</td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="15%">
                    	<span id="file_gubun_text">������/������</span>
                    </td>
                    <td>&nbsp;
                    	<%if(f_bean.getNote().equals("���·� OCR ���") && !fileName.equals("") && fileName != null){ %>
                    	<a href="<%=imgUrl%>" onclick="window.open(this.href, '_blank', 'width=1000, height=1000'); return false;" target='_blank'><%=fileName%></a>
                    	<%}else{%>

                    	<div id="view_fine">
							<%if(file_name1.equals("")){%>
						  	<a href="javascript:scan_reg('1');"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
						  <%}else{%>
						  <%	if(file_type1.equals("image/jpeg")||file_type1.equals("image/pjpeg")||file_type1.equals("application/pdf")){%>
							 	<a href="javascript:openPopP('<%=file_type1%>','<%=seq1%>');" title='����' ><%=file_name1%></a>
							<%	}else{%>
							 <a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq1%>" target='_blank'><%=file_name1%></a>
							<%	}%>
								&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq1%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
							<%}%>
							<a href="javascript:location.reload()" onmouseover="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_reload.gif" align="absmiddle" border="0"></a>
						</div>
						<div id="view_notice" style="display: none;">
							<%if(file_name3.equals("")){%>
						  	<a href="javascript:scan_reg('3');"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
						  <%}else{%>
						  <%	if(file_type3.equals("image/jpeg")||file_type3.equals("image/pjpeg")||file_type3.equals("application/pdf")){%>
							 	<a href="javascript:openPopP('<%=file_type3%>','<%=seq3%>');" title='����' ><%=file_name3%></a>
							<%	}else{%>
							 <a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq3%>" target='_blank'><%=file_name3%></a>
							<%	}%>
								&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq3%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
							<%}%>
							<input type="hidden" name="file_size3" value="<%=file_size3%>">
							<input type="hidden" name="file_type3" value="<%=file_type3%>">
							<input type="hidden" name="seq3" value="<%=seq3%>">
							<a href="javascript:location.reload()" onmouseover="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_reload.gif" align="absmiddle" border="0"></a>
						</div>
						<%}%>

						</td>
                    <td class=title width="15%">������</td>
                    <td>&nbsp;
					  <%if(file_name2.equals("")){%>
				  		<a href="javascript:scan_reg('2');"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
				  	<%}else{%>
				  	<%	if(file_type2.equals("image/jpeg")||file_type2.equals("image/pjpeg")||file_type2.equals("application/pdf")){%>
					 		<a href="javascript:openPopP('<%=file_type2%>','<%=seq2%>');" title='����' ><%=file_name2%></a>
					 	<%	}else{%>
					 		<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq2%>" target='_blank'><%=file_name2%></a>
					 	<%	}%>
					 	&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq2%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
					 	<%}%>
						</td>
                </tr>
                <tr> 
                    <td class=title width="15%">����</td>
                    <td width="35%">&nbsp;�����ּ� : <input type='text' name='email' size='30' value='<%=email%>' class='text'>&nbsp;
			                <a href="javascript:doc_email2()"><img src="/acar/images/center/button_in_s.gif" align="absmiddle" border="0"></a></td>
					          <td class=title width="15%">��������</td>
                    <td align='center' width="35%"><%=AddUtil.getDate3(otime)%></td>
                </tr>
                <tr class="notice_tag" style="display: none;">
                	<td class="title">�ȳ��� ����</td>
                	<td colspan="3">
   		<% 	if(ce_bean_size>0){%>
   						<select onchange="javascript:view_notice_ment(this.value);" name="notice_title" id="notice_title">
   			<%	for(int i=0;i<ce_bean_size;i++){ %>
   							<option value="<%=ce_bean[i].getCol_1_val()%>"><%=ce_bean[i].getCol_1_val()%></option>
   			<% 	}%>
   						</select>	
   		<% 	}%>
                		<input type="button" class="button" value="�ȳ��� ���� ����" onclick="javascript:go_notice_pop();"><br>
                		<% 	if(ce_bean_size>0){%>
                		<pre id="notice_ment"><%=ce_bean[0].getEtc_content() %></pre><br>
                		<%} %>
                	</td>
                </tr>
            </table>
        </td>
    </tr>	
	<%}%>
    <tr> 
        <td width="30%"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>���Ȯ�� �� ��������</span></td>
        <td align="right"><img src=../images/center/arrow_ddj.gif align=absmiddle> : <%=c_db.getNameById(f_bean.getReg_id(), "USER")%>
    	    <%if(!f_bean.getFine_st().equals("")){%>
    	    &nbsp;&nbsp;&nbsp; <img src=../images/center/arrow_cjsjj.gif align=absmiddle> : 
            <input type="text" name="update_id" size="6" value="<%=c_db.getNameById(f_bean.getUpdate_id(), "USER")%>" class=whitetext readonly>
            &nbsp;&nbsp; <img src=../images/center/arrow_cjsji.gif align=absmiddle> : <%=AddUtil.ChangeDate2(f_bean.getUpdate_dt())%>         
    			<%}%>
    	    <%if(!f_bean.getRe_reg_dt().equals("")){%>
    	    �� ����:<%=c_db.getNameById(f_bean.getRe_reg_id(), "USER")%> <%=AddUtil.ChangeDate2(f_bean.getRe_reg_dt())%> 
    	    <%}%>
        </td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="15%">����</td>
                    <td width="35%"> 
                      <select name="fine_st" onchange="javascript:change_fine_st(this.value);">
                        <option value="1" <%if(f_bean.getFine_st().equals("1"))%>selected<%%>>���·�</option>
                        <option value="2" <%if(f_bean.getFine_st().equals("2"))%>selected<%%>>��Ģ��</option>
                        <option value="3" <%if(f_bean.getFine_st().equals("3"))%>selected<%%>>�ȳ���</option>
                      </select>
                		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�������Է½� : <a href="javascript:fine_gov_in()" ><img src=../images/center/button_in_reg.gif align=absmiddle border=0></a> 
                    </td>
                    <td class=title width="15%">���Ȯ�� ��������</td>
                    <td width="35%"> 
                      <input type="text" name="notice_dt" value="<%if(seq_no.equals("") && f_bean.getNotice_dt().equals("")) {%><%=AddUtil.getDate()%><%}else {%><%=AddUtil.ChangeDate2(f_bean.getNotice_dt())%><%}%>" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>��������ȣ</td>
                    <td> 
                      <input type="text" name="paid_no" value="<%=f_bean.getPaid_no()%>" size="30" class=text style='IME-MODE: inactive'>
					  <input type=checkbox  onClick="writeBox()" name='intext' value='���ڰ���'>���ڰ���</td>
                    <td class=title>�������</td>
                    <td> 
                      <input type="text" name="vio_pla" value="<%=f_bean.getVio_pla()%>" size="60" class=text maxlength="50" style='IME-MODE: active'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>�����Ͻ�</td>
                    <td>
					  <%String vio_dt_d = "";
					  	String vio_dt_h = "";
						String vio_dt_m = "";
						if(!seq_no.equals("")){
							if(f_bean.getVio_dt().length() >= 8){
								vio_dt_d = f_bean.getVio_dt().substring(0,8);
							}
							if(f_bean.getVio_dt().length() >= 10){
								vio_dt_h = f_bean.getVio_dt().substring(8,10);
							}
							if(f_bean.getVio_dt().length() >= 12){
								vio_dt_m = f_bean.getVio_dt().substring(10,12);
							}
						}
					  %>
					  <input type="text" name="vio_ymd" value="<%=AddUtil.ChangeDate2(vio_dt_d)%>" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <input type="text" name="vio_s" value="<%=vio_dt_h%>" size="2" maxlength=2 class=text>
                        ��
                        <input type="text" name="vio_m" value="<%=vio_dt_m%>" size="2" maxlength=2 class=text>
                        ��
                      <!-- onBlur="javascript:PaidNoCheck()" : ��������ȣ �ߺ�üũ--></td>
                    <td class=title>���ݳ���</td>
                    <td> 
                    	<select name="vio_st">
                    		<option value="">����</option>
                        <option value="1" <%if(f_bean.getVio_st().equals("1"))%>selected<%%>>���α����</option>
                        <option value="2" <%if(f_bean.getVio_st().equals("2"))%>selected<%%>>���ᵵ�ι�</option>
                        <option value="3" <%if(f_bean.getVio_st().equals("3"))%>selected<%%>>�������</option>
                        <option value="4" <%if(f_bean.getVio_st().equals("4"))%>selected<%%>>�����������������</option>
                        <option value="5" <%if(f_bean.getVio_st().equals("5"))%>selected<%%>>��⹰������</option>
                        <%-- <option value="6" <%if(f_bean.getVio_st().equals("6"))%>selected<%%>>����˻�Ⱓ���</option> --%><!-- �߰�(20181123) --><!-- �ٽû����ش޶��ؼ� ���� -->
                      </select>
                      &nbsp;                    	
                      <input type="text" name="vio_cont" value="<%=f_bean.getVio_cont()%>" size="30" class=text onBlur="javascript:gov_set2();" style='IME-MODE: active'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>û�����</td>
                    <td> 
                      <input name="gov_nm" type="text" class=text value="<%=FineGovBn.getGov_nm()%>" size="30" maxlength="50" style='IME-MODE: active' onKeyDown='javascript:enter()' onBlur='javascript:gov_set()'>
        			  <input type='hidden' name="mng_dept" value=''>
        			  <input type='hidden' name="gov_st" value=''>
        			  <input type='hidden' name="mng_nm" value=''>
        			  <input type='hidden' name="mng_pos" value=''>
        			  <input type='hidden' name="gov_id" value='<%=f_bean.getPol_sta()%>'>
                      <a href="javascript:fine_gov_search();" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_search1.gif align=absmiddle border=0></a>
        			  <%if(!f_bean.getPol_sta().equals("")){%> 
        			  &nbsp;<a href="javascript:view_fine_gov('<%=FineGovBn.getGov_id()%>');" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_see.gif align=absmiddle border=0></a>
        			  <%}%>
        			  </td>
                    <td class=title>�ǰ���������</td>
                    <td> 
                      <input type="text" name="obj_end_dt" value="<%=AddUtil.ChangeDate2(f_bean.getObj_end_dt())%>" size="11" maxlength=10 class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                      ���� </td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td colspan="3">
				    		    	<%if(!FineDocListBn.getDoc_id().equals("")){%>
                    	[������ȣ] : <%=FineDocBn.getDoc_id()%> &nbsp;[��������] : <%=AddUtil.ChangeDate2(FineDocBn.getDoc_dt())%> &nbsp;[�μ�����] : <%=AddUtil.ChangeDate2(FineDocBn.getPrint_dt())%>
    		    					<%}%>
    		    					<%if(!f_bean.getObj_dt1().equals("")){%>
                      &nbsp;&nbsp;&nbsp;&nbsp;[���ǽ�û] 1��: 
                      <input type="text" name="obj_dt1" value="<%=f_bean.getObj_dt1()%>" size="11" readonly maxlength=12 class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                      2��: 
                      <input type="text" name="obj_dt2" value="<%=f_bean.getObj_dt2()%>" size="11" readonly maxlength=12 class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
                      3��: 
                      <input type="text" name="obj_dt3" value="<%=f_bean.getObj_dt3()%>" size="11" readonly maxlength=12 class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>    		    					
    		    					<%}%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2">�� û����� �����Է� : ��õ������-1, ���ְ�����-2, ������������-3, ��õ��������-4, �ѱ����ΰ���-5, �����ߺΰ�����(�ο���)-6&nbsp;<a href='javascript:fine_reg()' onMouseOver="window.status=''; return true">[û��������]</a><br>
					<!--	�� ���ݳ��� �����Է� : 1.�ӵ�, 2.����������, 3.��ȣ����, 4.����������������, 5.��ӵ��� ����������������, 6.�߾���������, 7.�������� ����, 8.�����̳�, 9.������ݹ̳�
		  <!--��������û 1, ������������ 2, ���ֽ�û 3, ���ְ����� 4, ��õ��û 5, ��õ������ 6, ���ؽ�û 7, ���ذ����� 8, �λ꿬�������� 9, �λ��û 10, �ѱ����ΰ��� 20-->
		</td>
    </tr>
    <tr> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>���·� ����</span></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr>
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title>�����</td>
                    <td colspan="">
                      <select name='mng_id'>
                        <option value="">����</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(f_bean.getMng_id().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>			 
                    </td>
					<td class=title width="15%">��ϱ���</td>
                    <td width="35%">
						<input name="fine_nm" type="text" class=text value="<%=f_bean.getFine_nm()%>" size="30" maxlength="50" style='IME-MODE: active' onBlur='javascript:fine_set()'>
						<input type='hidden' name="fine_gb" value='<%=f_bean.getFine_gb()%>'>
                    </td>
                </tr>			
                <tr> 
                    <td class=title width="15%">���Ǳ���</td>
                    <td width="35%"> 
                      <select name="fault_st" onChange='javascript:fine_list()'>
                        <option value="1" <%if(f_bean.getFault_st().equals("1"))%>selected<%%>>������</option>
                        <option value="2" <%if(f_bean.getFault_st().equals("2"))%>selected<%%>>���������</option>
                        <option value="3" <%if(f_bean.getFault_st().equals("3"))%>selected<%%>>�ܺξ�ü����</option>
                      </select>
					  
					  
					  
                    </td>
                    <td class=title width="15%">���α���</td>
                    <td width="35%"> 
                      <select name="paid_st" onChange='javascript:fine_display()'>
                        <option value="1" <%if(f_bean.getPaid_st().equals("1"))%>selected<%%>>�����ں���</option>
                        <option value="2" <%if(f_bean.getPaid_st().equals("2"))%>selected<%%>>������</option>
                        <option value="4" <%if(f_bean.getPaid_st().equals("4"))%>selected<%%>>���ݳ���</option>
                        <option value="3" <%if(f_bean.getPaid_st().equals("3"))%>selected<%%>>ȸ��볳</option>
                      </select>
                    </td>
                </tr>
				<%if(!f_bean.getFault_st().equals("")){%>
				<%if(f_bean.getFault_st().equals("3")){%>
				<tr> 
                    <td class=title>����������</td>
					<td width="35%" >
						<select name='fault_nm' id="fault_nm_off">
							<option value="">����</option>
                        <%	if(outside_size > 0){
        						for (int i = 0 ; i < outside_size ; i++){
        							Hashtable outsd = (Hashtable)outside.elementAt(i);	%>
                        <option value='<%=outsd.get("USER_NM")%>' <%if(f_bean.getFault_nm().equals(outsd.get("USER_NM"))) out.println("selected");%>><%=outsd.get("USER_NM")%></option>
                        <%		}
        					}		%>
						</select>			 
					</td>
                    <td class=title width="15%">���������� �δ�ݾ�</td>
                    <td> 
                      <input type="text" name="fault_amt" value="<%=Util.parseDecimal(f_bean.getFault_amt())%>" size="10" maxlength=10 class=num onBlur="javascript:this.value=parseDecimal(this.value)">
                      ��</td>
                </tr>
				<%}else{%>
				<tr> 
                    <td class=title>����������</td>
					<td width="35%" >
						<select name='fault_nm'>
							<option value="">����</option>
                       		<%	if(user_size > 0){
									for (int i = 0 ; i < user_size ; i++){
										Hashtable user = (Hashtable)users.elementAt(i);	%>
							<option value='<%=user.get("USER_ID")%>' <%if(f_bean.getFault_nm().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
							<%		}
								}		%>
						</select>			 
					</td>
                    <td class=title width="15%">���������� �δ�ݾ�</td>
                    <td> 
                      <input type="text" name="fault_amt" value="<%=Util.parseDecimal(f_bean.getFault_amt())%>" size="10" maxlength=10 class=num onBlur="javascript:this.value=parseDecimal(this.value)">
                      ��</td>
                </tr>
				<%}%>
				<%}else{%>
                <tr> 
                    <td class=title>����������</td>
					<td width="35%" >
						<div id="gubun1" style="display:none">
						<select name='fault_nm' id="fault_nm_off">
							<option value="">����</option>
                        <%	if(outside_size > 0){
        						for (int i = 0 ; i < outside_size ; i++){
        							Hashtable outsd = (Hashtable)outside.elementAt(i);	%>
                        <option value='<%=outsd.get("USER_NM")%>' <%if(f_bean.getFault_nm().equals(outsd.get("USER_ID"))) out.println("selected");%>><%=outsd.get("USER_NM")%></option>
                        <%		}
        					}		%>
						</select>			 
					</div>
					<div id="gubun" style="display:">
						<select name='fault_nm'>
							<option value="">����</option>
							<%	if(user_size > 0){
									for (int i = 0 ; i < user_size ; i++){
										Hashtable user = (Hashtable)users.elementAt(i);	%>
							<option value='<%=user.get("USER_ID")%>' <%if(f_bean.getFault_nm().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
							<%		}
								}		%>
						</select>			 
						</div>
					</td>
                    <td class=title width="15%">���������� �δ�ݾ�</td>
                    <td> 
                      <input type="text" name="fault_amt" value="<%=Util.parseDecimal(f_bean.getFault_amt())%>" size="10" maxlength=10 class=num onBlur="javascript:this.value=parseDecimal(this.value)">
                      ��</td>
                </tr>
				<%}%>
                <tr> 
                    <td class=title>������ ��������</td>
                    <td> 
                      <input type="text" name="rec_dt" value="<%=AddUtil.ChangeDate2(f_bean.getRec_dt())%>" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title>���α���</td>
                    <td> 
                      <input type="text" name="paid_end_dt" value="<%=AddUtil.ChangeDate2(f_bean.getPaid_end_dt())%>" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                      ����</td>
                </tr>
                <tr> 
                    <td class=title>���αݾ�</td>
                    <td> 
                      <input type="text" name="paid_amt" value="<%=Util.parseDecimal(f_bean.getPaid_amt())%>" size="10" maxlength=8 class=num onBlur="javascript:this.value=parseDecimal(this.value)">
                      ��
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ǳ��αݾ�
					  <input type="text" name="paid_amt2" value="<%=Util.parseDecimal(f_bean.getPaid_amt2())%>" size="10" maxlength=8 class=num onBlur="javascript:this.value=parseDecimal(this.value);miss_write();">
                      ��
					  </td>
                    <td class=title>��������</td>
                    <td> 
					  <%if(nm_db.getWorkAuthUser("ȸ�����",user_id) || nm_db.getWorkAuthUser("Ź�۰�����",user_id)){%>
                      <input type="text" name="proxy_dt" value="<%=AddUtil.ChangeDate2(f_bean.getProxy_dt())%>" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
					  <%}else{%>
					  <input type="text" name="proxy_dt" value="<%=AddUtil.ChangeDate2(f_bean.getProxy_dt())%>" size="11" class=whitetext readonly>
					  <%}%>
                    </td>
                </tr>
                <tr> 
                    <td class=title>Ư�̻���</td>
                    <td colspan="3"> 
                      <textarea name="note" cols=86 rows=4 class=default><%=f_bean.getNote()%></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id=tr_31 style="display:<%if(f_bean.getPaid_st().equals("2") || f_bean.getPaid_st().equals("4") || f_bean.getPaid_st().equals("3")) {%>''<%}else{%>none<%}%>"> 
        <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�볳���·� ����</span></td>
    </tr>
    <tr id=tr_32 style="display:<%if(f_bean.getPaid_st().equals("2") || f_bean.getPaid_st().equals("4") || f_bean.getPaid_st().equals("3")) {%>''<%}else{%>none<%}%>">
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title colspan="2">û������</td>
                    <td width="35%"> 
                      <input type="text" name="dem_dt" value="<%=AddUtil.ChangeDate2(f_bean.getDem_dt())%>" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title width="15%">����û����</td>
                    <td width="10%"> 
                      <input type="text" name="f_dem_dt" value="<%=AddUtil.ChangeDate2(f_bean.getF_dem_dt())%>" size="11" class=whitetext readonly>
                    </td>
                    <td class=title width="15%">û����������</td>
                    <td width="10%"> 
                      <input type="text" name="e_dem_dt" value="<%=AddUtil.ChangeDate2(f_bean.getE_dem_dt())%>" size="11" class=whitetext readonly>
                    </td>
                </tr>
                <tr> 
                    <td class=title colspan="2">�Աݿ�����</td>
                    <td> 
                      <input type="text" name="rec_plan_dt" value="<%=AddUtil.ChangeDate2(f_bean.getRec_plan_dt())%>" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title>��������</td>
                    <td colspan="3"> 
					  <%if(nm_db.getWorkAuthUser("ȸ�����",user_id) || nm_db.getWorkAuthUser("Ź�۰�����",user_id)){%>
                      <input type="text" name="coll_dt" value="<%=AddUtil.ChangeDate2(f_bean.getColl_dt())%>" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
					  <%}else{%>
                      <input type="text" name="coll_dt" value="<%=AddUtil.ChangeDate2(f_bean.getColl_dt())%>" size="11" class=whitetext readonly>					  
					  <%}%>
                    </td>
                </tr>
                <tr> 
                    <td class=title rowspan="2" width="5%">����<br>
                      ��꼭</td>
                    <td class=title width="10%">���࿩��</td>
                    <td> 
                      <select name="tax_yn">
                        <option value="0" <%if(f_bean.getTax_yn().equals("0"))%>selected<%%>>�̹���</option>
                        <option value="1" <%if(f_bean.getTax_yn().equals("1"))%>selected<%%>>����</option>
                      </select>
        			  <%if(!f_bean.getExt_dt().equals("")){%>
        			  �������� : <%=f_bean.getExt_dt()%>
        			  <%}%>
                    </td>
                    <td class=title width="10%">�ΰ��� ���Կ���</td>
                    <td colspan="3"> 
                      <select name="vat_yn">
                        <option value="0" <%if(f_bean.getVat_yn().equals("0"))%>selected<%%>>������</option>
                        <option value="1" <%if(f_bean.getVat_yn().equals("1"))%>selected<%%>>����</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>�ŷ�����</td>
                    <td>
                      <select name="busi_st">
                        <option value="1" <%if(f_bean.getBusi_st().equals("1"))%>selected<%%>>���·�</option>
                        <option value="2" <%if(f_bean.getBusi_st().equals("2"))%>selected<%%>>��������</option>
                      </select>
                    </td>
                    <td class=title width="10%">�ŷ��������Կ���</td>
                    <td colspan="3"> 
                      <select name="bill_doc_yn">
                        <option value="0" <%if(f_bean.getBill_doc_yn().equals("0"))%>selected<%%>>������</option>
                        <option value="1" <%if(f_bean.getBill_doc_yn().equals("1"))%>selected<%%>>����</option>
                      </select>        			  
                      <select name="bill_mon">
                        <option value="">����</option>
        				<%for(int i=1;i<13;i++){%>
        				<option value="<%=AddUtil.addZero2(i)%>" <%if(AddUtil.addZero(f_bean.getBill_mon()).equals(AddUtil.addZero2(i)))%>selected<%%>><%=i%>��</option>
        				<%}%>
                      </select>			          			  
                    </td>
                </tr>
                <tr> 
                    <td class=title colspan="2">��������</td>
                    <td colspan="5"> 
                      <input type='checkbox' name='no_paid_yn' value="Y" <%if(f_bean.getNo_paid_yn().equals("Y"))%>checked<%%>>
                      ����: 
                      <input type="text" name="no_paid_cau" value="<%=f_bean.getNo_paid_cau()%>" size="120" class=text>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2"> 
            <table border=0 cellspacing=1 width="100%">
                <tr> 
                    <td align=right> 
        			<%if(mode.equals("view") ){%>
        			  <a href="javascript:window.close()"><img src=../images/center/button_close.gif align=absmiddle border=0></a>
        			<%}else{%>
                    <%			if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                    <%				if(f_bean.getCar_mng_id().equals("") ){%>
                        <a href="javascript:ForfeitReg()"><img src=../images/center/button_reg.gif align=absmiddle border=0></a> 
        			<%				}%>
                    <%				if(!f_bean.getCar_mng_id().equals("")){%>			  
                        <a href="javascript:ForfeitUp()"><img src=../images/center/button_modify.gif align=absmiddle border=0></a> 
						<%if(f_bean.getProxy_dt().equals("") && (nm_db.getWorkAuthUser("���·������",user_id)||nm_db.getWorkAuthUser("������",user_id))){%>
                        &nbsp;<a href="javascript:ForfeitDel()"><img src=../images/center/button_delete.gif align=absmiddle border=0></a> 
						<%}%>
						&nbsp;<a href="javascript:doc_email1()"><img src="/acar/images/center/button_mail.gif" align="absmiddle" border="0"></a>
                        &nbsp;<a href="javascript:ClearM()"><img src=../images/center/button_init.gif align=absmiddle border=0></a> 
                    <%				}%>
        			<%			}%>
                       
        			<%}%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2">�� ����/�Ա�ó���� ȸ����� ����ڸ� �մϴ�.</td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
