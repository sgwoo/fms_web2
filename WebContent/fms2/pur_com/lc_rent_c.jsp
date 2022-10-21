<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.tint.*, acar.doc_settle.*, acar.estimate_mng.*, card.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<jsp:useBean id="ej_bean"   class="acar.estimate_mng.EstiJgVarBean"    scope="page"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String com_con_no 	= request.getParameter("com_con_no")==null?"":request.getParameter("com_con_no");
	
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");	
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();	
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	String est_id = e_db.getEst_id(rent_l_cd);
	//System.out.println(rent_l_cd);
	//System.out.println(est_id);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
		
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//��������
	Hashtable est = a_db.getRentEst(rent_mng_id, rent_l_cd);
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//������ȣ �̷�	
	CarHisBean ch_r [] = crd.getCarHisAll(base.getCar_mng_id());

	//�ܰ�����NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	

	//��������(�����)		
	CarPurDocListBean cpd_bean = cod.getCarPurCom(rent_mng_id, rent_l_cd, com_con_no);
	
	//������
	Vector vt = cod.getCarPurComCngs(rent_mng_id, rent_l_cd, com_con_no);
	int vt_size = vt.size();	

	int cng_size = 0;
	int max_cng_seq = 0;
	for(int i = 0 ; i < vt_size ; i++){
 		Hashtable ht = (Hashtable)vt.elementAt(i);
	    if(String.valueOf(ht.get("CNG_ST")).equals("1")){
	    	cng_size++;	
	    }
    	if(String.valueOf(ht.get("CNG_ST")).equals("2")){
	  		max_cng_seq = AddUtil.parseInt(String.valueOf(ht.get("SEQ")));
	  	}
  	}
	
	//�������		
	CarPurDocListBean cng_bean = new CarPurDocListBean();
	
	UsersBean dlv_mng_bean = umd.getUsersBean(cpd_bean.getDlv_mng_id());
		
	
	String vlaus =	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort="+sort+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+
					"&st_dt="+st_dt+"&end_dt="+end_dt+"&from_page="+from_page+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&com_con_no="+com_con_no+"";				   	
	
	String cng_act_yn = "";
	String cls_act_yn = "";
	String re_act_yn = "";	
	
	user_bean 	= umd.getUsersBean(ck_acar_id);
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "LC_RENT";
	String content_seq  = "";

	Vector attach_vt = new Vector();
	int attach_vt_size = 0;		
	
	Vector sr = cod.getSucResList(cpd_bean.getCom_con_no());
	int sr_size = sr.size();	
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
textarea.autosize { min-height: 50px; }
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var popObj = null;

	
	
	//�˾������� ����
	function ScanOpen2(theURL,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}	
		theURL = "https://fms3.amazoncar.co.kr/data/carReg/"+theURL+""+file_type;
		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj = window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');			
		}else{
			popObj = window.open(theURL,'popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}
		popObj.location = theURL;
		popObj.focus();			
	}	
	
	
	//�˾������� ����
	function MM_openBrWindow2(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/carReg/"+theURL+".pdf";
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();	
	}
	
	//����Ʈ
	function list(){
		var fm = document.form1;
		if(fm.from_page.value == ''){			
			fm.action = 'pur_est_frame.jsp';
		}else{
			fm.action = fm.from_page.value;
		}
		fm.target = 'd_content';
		fm.submit();
	}	

	//����
	function update(st, seq){
	
		var height = 250;
		
		if(st == 'dlv') 				height = 250;
		else if(st == 'amt') 			height = 500;
		else if(st == 'cng') 			height = 550;
		else if(st == 'cng_amt') 		height = 400;
		else if(st == 'cls1' || st == 'cls2'|| st == 're') 	height = 300;
		else if(st == 'con') 			height = 250;
		else if(st == 're_act')			height = 250;
		else if(st == 'cng2') 			height = 400;
		else if(st == 'cls3') 			height = 300;
		else if(st == 'settle') 		height = 250;
		else if(st == 'mm') 			height = 400;		
		else if(st == 'stock') 			height = 300;
		
		height = height + 50;
				
		window.open("lc_rent_u.jsp<%=vlaus%>&cng_item="+st+"&seq="+seq, "CHANGE_ITEM", "left=50, top=50, width=1050, height="+height+", scrollbars=yes, status=yes");		
	}	
	
	//����ݿ�ó��
	function dir_update(st, seq){
		var ment = '�ݿ�ó��';
		if(st=='cng_act') 	ment = '���� �ݿ�ó��';
		if(st=='cng_cancel') 	ment = '���� ���ó��';
		if(st=='cls_act') 	ment = '���� �ݿ�ó��';
		if(st=='cng_cont') 	ment = '��ຯ�� �ݿ�ó��';
		if(st=='order_req') ment = '�ֹ��� ��Ȯ��ó��';
		if(st=='end_act') 	ment = '�����ĺ��� �ݿ�ó��';
		if(st=='revival') 	ment = '��������� ��Ȱó��';
		if(st=='cls5') 		ment = '���������Ȳ���� ������� �������';
		if(!confirm(ment+" �� �Ͻðڽ��ϱ�?"))	return;
		var fm = document.form1;
		fm.cng_item.value = st;
		fm.seq.value = seq;
		fm.action = 'lc_rent_u_a.jsp';
		fm.target = 'i_no';
		fm.submit();
	}
	
	
				
	//�����̷�
	function view_sh_res_h(){
		var SUBWIN="reserveCarHistory.jsp?com_con_no=<%=cpd_bean.getCom_con_no()%>";
		window.open(SUBWIN, "reserveCarHistory", "left=50, top=50, width=850, height=800, scrollbars=yes, status=yes");
	}
	
	//��������� �����صα�
	function reserveCar(){
		var fm = document.form1;
		var SUBWIN="reserveCar.jsp?from_page=<%=from_page%>&com_con_no=<%=cpd_bean.getCom_con_no()%>&user_id=<%=user_id%>";
		window.open(SUBWIN, "reserveCar", "left=250, top=250, width=520, height=350, scrollbars=no, status=yes");
	}

	//����޸�����ϱ�
	function reserveCarM(seq, situation, memo, cust_nm, cust_tel, damdang_id){
		var fm = document.form1;
		var SUBWIN="reserveCarM.jsp?from_page=<%=from_page%>&user_id=<%=user_id%>&com_con_no=<%=cpd_bean.getCom_con_no()%>&seq="+seq+"&situation="+situation+"&memo="+memo+"&cust_nm="+cust_nm+"&cust_tel="+cust_tel+"&damdang_id="+damdang_id;
		window.open(SUBWIN, "reserveCar", "left=250, top=250, width=520, height=350, scrollbars=no, status=yes");
	}

	//���Ȯ������ ��ȯ�ϱ�
	function reserveCar2Cng(seq, situation, damdang_id, shres_reg_dt, shres_cust_nm, shres_cust_tel){
		var fm = document.form1;
		fm.shres_seq.value = seq;
		fm.situation.value = situation;
		fm.damdang_id.value = damdang_id;
		fm.shres_reg_dt.value = shres_reg_dt;
		fm.shres_cust_nm.value = shres_cust_nm;
		fm.shres_cust_tel.value = shres_cust_tel;
		if(!confirm("����߿��� ���Ȯ������ ��ȯ �Ͻðڽ��ϱ�?"))	return;
		fm.action = "reserveCar2cng.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
	//���࿬���ϱ�
	function reReserveCar(seq, situation, damdang_id, shres_reg_dt){
		var fm = document.form1;
		fm.shres_seq.value = seq;
		fm.situation.value = situation;
		fm.damdang_id.value = damdang_id;
		fm.shres_reg_dt.value = shres_reg_dt;
		if(!confirm("������ ���� �Ͻðڽ��ϱ�?"))	return;
		fm.action = "reReserveCar.jsp";
		fm.target = "i_no";
		fm.submit();
	}	
		
	//��������ϱ�
	function cancelCar(seq, situation, damdang_id, shres_reg_dt){
		var fm = document.form1;
		fm.shres_seq.value = seq;
		fm.situation.value = situation;
		fm.damdang_id.value = damdang_id;
		fm.shres_reg_dt.value = shres_reg_dt;
		if(!confirm("������ ��� �Ͻðڽ��ϱ�?"))	return;
		fm.action = "cancelCar.jsp";
		fm.target = "i_no";
		fm.submit();
	}
		
	//��� �����ϱ�
	function PurComReg(seq){
		var fm = document.form1;
		var SUBWIN="rePurcomReg.jsp?from_page=<%=from_page%>&user_id=<%=user_id%>&o_rent_mng_id=<%=cpd_bean.getRent_mng_id()%>&o_rent_l_cd=<%=cpd_bean.getRent_l_cd()%>&com_con_no=<%=cpd_bean.getCom_con_no()%>&seq="+seq;
		window.open(SUBWIN, "PurComReg", "left=50, top=450, width=1150, height=350, scrollbars=no, status=yes");
	}
	
	//������� �����
	function ReEsti(est_id){
		var fm = document.form1;
		fm.est_id.value = est_id;
		fm.cmd.value = 're';
		fm.action = '/acar/estimate_mng/esti_mng_atype_i.jsp';		
		fm.target = 'd_content';
		fm.submit();
	}
	
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='sort'	value='<%=sort%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="est_id" value="<%=est_id%>">
  <input type='hidden' name="cmd" value="">
  <input type='hidden' name="com_con_no" 	value="<%=com_con_no%>">
  <input type='hidden' name="car_mng_id" 	value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="client_id" 	value="<%=base.getClient_id()%>">  
  <input type='hidden' name="car_nm" 		value="<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>">  
  <input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>">  
  <input type='hidden' name="cng_item" 		value="">  
  <input type='hidden' name="seq" 		value="">  
  <input type='hidden' name="mode" 		value="<%=mode%>">  
  <input type="hidden" name="situation" 		value="">
  <input type="hidden" name="damdang_id" 		value="">
  <input type="hidden" name="shres_reg_dt" 	value="">
  <input type="hidden" name="shres_seq" 		value="">
  <input type="hidden" name="shres_cust_nm" 		value="">
  <input type="hidden" name="shres_cust_tel" 		value="">  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������� > <span class=style5>���⺸��</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <%if(!mode.equals("view")){%>
    <tr>
        <td align="right"><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a></td></td>
    <tr> 	
    <%}%>
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="2" class=title>����ȣ</td>
                    <td width=7% class=title>�Ƹ���ī</td>
                    <td width=19%>&nbsp;<%=rent_l_cd%></td>
                    <td width=7% rowspan="2" class=title>��������</td>
                    <td width=7% class=title>�������</td>
                    <td width="19%" >&nbsp;<%=AddUtil.ChangeDate10(cpd_bean.getReg_dt())%></td>
                    <td width=7% rowspan="2" class=title>�����</td>
                    <td width=7% class=title>������</td>
                    <td width="20%">&nbsp;<%=dlv_mng_bean.getDept_nm()%>&nbsp;<%=dlv_mng_bean.getUser_nm()%>&nbsp;<%=dlv_mng_bean.getUser_pos()%></td>
    		    </tr>
                <tr>
                  <td class=title><%=cm_bean.getCar_comp_nm()%></td>
                  <td>&nbsp;<%=cpd_bean.getCom_con_no()%>
                  	<%if(!mode.equals("view")){%> 
    								<%	if(cpd_bean.getSettle_dt().equals("") && !cpd_bean.getUse_yn().equals("N") && !cpd_bean.getSuc_yn().equals("D")){%>
    								<%		if(nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("��ü������",ck_acar_id) || nm_db.getWorkAuthUser("�ӿ�",ck_acar_id)){%>     
                    <a href='javascript:update("com_con_no", "")'><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
                    <%		}%>
                    <%	}%>
                    <%}%>
                  </td>
                  <td class=title>��������</td>
                  <td >&nbsp;<%=AddUtil.ChangeDate2(pur.getPur_req_dt())%></td>
                  <td width=5% class=title>����ó</td>
                  <td>&nbsp;<%=dlv_mng_bean.getHot_tel()%></td>
                </tr>	
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>
    
    <%if(!cpd_bean.getSuc_yn().equals("")){%>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><font color=red>�������</font></span>
            &nbsp;&nbsp;<a href="javascript:view_sh_res_h()" title="�̷�"><img src=/acar/images/center/button_ir_ss.gif align=absmiddle border=0></a>
		</td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td class="title" width="5%">����</td>
                    <td class="title" width="10%">�����</td>
                    <td class="title" width="10%">�����Ȳ</td>
                    <td class="title" width="15%">����Ⱓ</td>
                    <td class="title" width="35%">�޸�</td>
                    <td class="title" width="10%">�������</td>
                    <td class="title" width="15%">ó��</td>
                </tr>
                <%	for(int i = 0 ; i < sr_size ; i++){
                        Hashtable sr_ht = (Hashtable)sr.elementAt(i);                        
                %>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=c_db.getNameById(String.valueOf(sr_ht.get("REG_ID")),"USER")%></td>
                    <td align="center">
                    	<%	if(String.valueOf(sr_ht.get("SITUATION")).equals("0"))				out.print("�����");
                    			else if(String.valueOf(sr_ht.get("SITUATION")).equals("2"))		out.print("���Ȯ��");
                   				else if(String.valueOf(sr_ht.get("SITUATION")).equals("3"))		out.print("��࿬��");
                    	%>
                    </td>
                    <td align="center">
                    	<%if(!String.valueOf(sr_ht.get("RES_ST_DT")).equals("")){%>
                    	<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_ST_DT"))) %>~<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_END_DT"))) %>
                    	<%}%>
                    </td>
                    <td>&nbsp;
                    	<!--�޸����-->
                    	<%if(cpd_bean.getSuc_yn().equals("D")){%><a href="javascript:reserveCarM('<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("MEMO")%>', '<%=sr_ht.get("CUST_NM")%>', '<%=sr_ht.get("CUST_TEL")%>', '<%=sr_ht.get("REG_ID")%>');" title='�޸�����ϱ�'><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>&nbsp;<%}%>
                    	<%=sr_ht.get("CUST_NM")%>&nbsp;<%=sr_ht.get("CUST_TEL")%>&nbsp;<%=sr_ht.get("MEMO")%>
                    </td>
                    <td align="center"><%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("REG_DT"))) %></td>
                    <td align="center">
                    	<%if(cpd_bean.getSuc_yn().equals("D")){%>
                    	<!--����������� ��࿬��-->
                    	<%	if(String.valueOf(sr_ht.get("SITUATION")).equals("2") && String.valueOf(sr_ht.get("USE_YN")).equals("Y") && (user_id.equals(String.valueOf(sr_ht.get("REG_ID"))) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��ü������",user_id))){%>
                    	<input type="button" class="button" id="pre_cls" value='��� �����ϱ�' onclick="javascript:PurComReg('<%=sr_ht.get("SEQ")%>');">&nbsp;&nbsp;
                    	<%	}%>
                    	<%	if(user_id.equals(String.valueOf(sr_ht.get("REG_ID"))) || nm_db.getWorkAuthUser("������",user_id)){%>
                    	<%		if(i==0 && String.valueOf(sr_ht.get("SITUATION")).equals("0")){%>
                    	<!--����� ���Ȯ���� ��ȯ-->
                    	<a href="javascript:reserveCar2Cng('<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("REG_ID")%>', '<%=sr_ht.get("REG_DT")%>', '<%=sr_ht.get("CUST_NM")%>', '<%=sr_ht.get("CUST_TEL")%>');" title='�������� ���Ȯ���ϱ�'><img src=/acar/images/center/button_in_dec.gif align=absmiddle border=0></a>&nbsp;&nbsp;
                    	<%		}%>
                    	<!--1ȸ����-->
                    	<%		if((i==0 && String.valueOf(sr_ht.get("SITUATION")).equals("2") && AddUtil.parseInt(String.valueOf(sr_ht.get("ADD_CNT"))) == 0) || (i==0 && String.valueOf(sr_ht.get("SITUATION")).equals("0") && AddUtil.parseInt(String.valueOf(sr_ht.get("ADD_CNT_S"))) == 0)){%>
                    	<a href="javascript:reReserveCar('<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("REG_ID")%>', '<%=sr_ht.get("REG_DT")%>');" title='�������� �����ϱ�'><img src=/acar/images/center/button_in_yj.gif align=absmiddle border=0></a>&nbsp;&nbsp;
                    	<%		}%>
                    	<!--�������-->
                    	<a href="javascript:cancelCar('<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("REG_ID")%>', '<%=sr_ht.get("REG_DT")%>');" title='�������� ����ϱ�'><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a>&nbsp;&nbsp;
                    	<%	}%>
                    	<%}%>
                    </td>
                </tr>
				        <%}%>
				        <%if(sr_size==0){%>
                <tr>
                    <td align="center" colspan="7">��ϵ� ����Ÿ�� �����ϴ�.</td>
                </tr>
				        <%}%>
            </table>
	    </td>
    </tr>
    <%if(cpd_bean.getSuc_yn().equals("D")){%>
	  <%	if(sr_size < 3){%>
    <tr>
        <td align="right">
            <a href="javascript:reserveCar();" title='���������ϱ�'><img src=/acar/images/center/button_cryy.gif align=absmiddle border=0></a>
        </td>
    </tr>
	  <%	}%>
	  <%}%>
    <%}%>
    
        
    
    <%if(cng_size >0){%>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ ���</span></td>
    </tr>    
    <%}else{%>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���</span></td>
    </tr>    
    <%}%>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>����</td>
                    <td colspan="3">&nbsp;<%=cpd_bean.getCar_nm()%> <%if(cng_size==0 && !cm_bean.getCar_y_form().equals("")){%>(����:<%=cm_bean.getCar_y_form()%>)<%}%></td>
                </tr>
                <tr> 
                    <td width=14% class=title>���û��</td>
                    <td colspan="3" >&nbsp;<%=cpd_bean.getOpt()%></td>
                </tr>
                <tr> 
                    <td width=14% class=title>����(����/����/���Ͻ�)</td>
                    <td colspan="3" >&nbsp;<%=cpd_bean.getColo()%></td>
                </tr>
                <tr>
                  <td class=title>��������</td>
                  <td width="19%">&nbsp;<%=cpd_bean.getPurc_gu()%></td>
                  <td width=14% class=title>T/M</td>
                  <td>&nbsp;<%=cpd_bean.getAuto()%></td>
                </tr>	
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="2" class=title>����</td>
                    <td width=7% class=title>�Һ��ڰ�</td>
                    <td width=19%>&nbsp;<input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_c_amt())%>'  maxlength='10' class='whitenum' readonly >��</td>
                    <td width=7% rowspan="2" class=title>D/C</td>
                    <td width=7% class=title>D/C</td>
                    <td width="19%" >&nbsp;<input type='text' name='dc_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getDc_amt())%>'  maxlength='10' class='whitenum' readonly >��</td>
                    <td width="14%" class=title>D/C�հ�</td>
                    <td width="20%">&nbsp;<input type='text' name='car_d_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_d_amt())%>'  maxlength='10' class='whitenum' readonly >��</td>
    		    </tr>
                <tr>
                  <td class=title>���԰�</td>
                  <td>&nbsp;<input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_f_amt())%>'  maxlength='10' class='whitenum' readonly >��</td>
                  <td class=title>�߰�D/C</td>
                  <td >&nbsp;<input type='text' name='add_dc_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getAdd_dc_amt())%>'  maxlength='10' class='whitenum' readonly >��</td>
                  <td class=title>�ŷ��ݾװ�</td>
                  <td>&nbsp;<input type='text' name='car_g_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_g_amt())%>'  maxlength='10' class='whitenum' readonly >��</td>
                </tr>
                <%-- <%if (nm_db.getWorkAuthUser("������", user_id)) {%> --%>
                <tr>
                	<td class="title">�񱳰���</td>
                	<td colspan="7">&nbsp;<a href="javascript:ReEsti('<%=est_id%>');" title='�񱳰���'><img src=/acar/images/center/button_in_esti.gif align=absmiddle border=0></a></td>
                </tr>
                <%-- <%}%> --%>	
            </table>
        </td>
    </tr>       
    <%if(!mode.equals("view")){%>
    <%if(!cpd_bean.getUse_yn().equals("N") && !cpd_bean.getSuc_yn().equals("D")){%>
    <%	if(nm_db.getWorkAuthUser("��ü������",ck_acar_id) || 
    		nm_db.getWorkAuthUser("������",user_id) || 
           cpd_bean.getSettle_dt().equals("") && (cpd_bean.getUse_yn().equals("Y") || cpd_bean.getUse_yn().equals("C") || cpd_bean.getSuc_yn().equals("D")) && cng_size ==0 && (nm_db.getWorkAuthUser("������",user_id) || cpd_bean.getReg_id().equals(user_id) || nm_db.getWorkAuthUser("��ü������",ck_acar_id) )
        ){%>
    <tr>
	<td align="right">
		<a href="javascript:update('amt','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
	</td>
    <tr>	    
    <%}%>
    <%}%>
    <%}%>
    
    <%if(vt_size > 0){%>
    <%		for(int i = 0 ; i < vt_size ; i++){
    			Hashtable ht = (Hashtable)vt.elementAt(i);%>
    <tr>
        <td class=h></td>
    </tr>
    <%			if(String.valueOf(ht.get("CNG_ST")).equals("1")){
    				if(String.valueOf(ht.get("CNG_DT")).equals("")){
    					cng_act_yn = "N";
    				}
    				
    				//�������		
				cng_bean = cod.getCarPurComCng(rent_mng_id, rent_l_cd, com_con_no, String.valueOf(ht.get("SEQ")));
    %>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������(<%=i+1%>)</span></td>
    </tr>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>���汸��</td>
                    <td>&nbsp;<%=ht.get("CNG_CONT")%></td>
                    <td width=14% class=title>������</td>
                    <td width="19%" >&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")%>&nbsp;<%=ht.get("REG_DT")%></td>
                    <td width=14% class=title>ó������</td>
                    <td width="20%">&nbsp;
                        <%if(String.valueOf(ht.get("CNG_DT")).equals("")){%>
                            <%if(nm_db.getWorkAuthUser("��ü������",ck_acar_id)  || nm_db.getWorkAuthUser("�ӿ�",ck_acar_id)){%>     
                                <font color=red>�̹ݿ�</font>&nbsp;
                                <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
                                <a href="javascript:dir_update('cng_act','<%=ht.get("SEQ")%>')">[�ݿ�ó��]</a>
                                &nbsp;&nbsp;                                
                                <a href="javascript:dir_update('cng_cancel','<%=ht.get("SEQ")%>')"><b><font color=red>[�������]</font></b></a>
                                <%}%>
                            <%}%>    
                        <%}else{%><%=c_db.getNameById(String.valueOf(ht.get("CNG_ID")),"USER")%>&nbsp;<%=ht.get("CNG_DT")%><%}%></td>                    
                </tr> 
                <tr> 
                    <td width=14% class=title>���泻��</td>
                    <td colspan="5">&nbsp;<textarea class="autosize" style="width:90%;overflow-y:hidden"><%=ht.get("BIGO")%></textarea></td>
                </tr>
                <%if(!String.valueOf(ht.get("CNG_CONT")).equals("�����")){%>  
                <tr> 
                    <td width=14% class=title>����</td>
                    <td colspan="5">&nbsp;<%=ht.get("CAR_NM")%></td>
                </tr>
                <tr> 
                    <td width=14% class=title>���û��</td>
                    <td colspan="5" >&nbsp;<%=ht.get("OPT")%></td>
                </tr>
                <tr> 
                    <td width=14% class=title>����(����/����/���Ͻ�)</td>
                    <td colspan="5" >&nbsp;<%=ht.get("COLO")%></td>
                </tr>
                <tr>
                  <td class=title>��������</td>
                  <td width="19%">&nbsp;<%=ht.get("PURC_GU")%></td>
                  <td width=14% class=title>T/M</td>
                  <td colspan="3">&nbsp;<%=ht.get("AUTO")%></td>
                </tr>	
                <%}%>
            </table>
        </td>
    </tr> 
    <%if(!String.valueOf(ht.get("CNG_CONT")).equals("�����")){%>  
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="2" class=title>����</td>
                    <td width=7% class=title>�Һ��ڰ�</td>
                    <td width=19%>&nbsp;<input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_C_AMT")))%>'  maxlength='10' class='whitenum' readonly >��</td>
                    <td width=7% rowspan="2" class=title>D/C</td>
                    <td width=7% class=title>D/C</td>
                    <td width="19%" >&nbsp;<input type='text' name='dc_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("DC_AMT")))%>'  maxlength='10' class='whitenum' readonly >��</td>
                    <td width="14%" class=title>D/C�հ�</td>
                    <td width="20%">&nbsp;<input type='text' name='car_d_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_D_AMT")))%>'  maxlength='10' class='whitenum' readonly >��</td>
    		    </tr>
                <tr>
                  <td class=title>���԰�</td>
                  <td>&nbsp;<input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_F_AMT")))%>'  maxlength='10' class='whitenum' readonly >��</td>
                  <td class=title>�߰�D/C</td>
                  <td >&nbsp;<input type='text' name='add_dc_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("ADD_DC_AMT")))%>'  maxlength='10' class='whitenum' readonly >��</td>
                  <td class=title>�ŷ��ݾװ�</td>
                  <td>&nbsp;<input type='text' name='car_g_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_G_AMT")))%>'  maxlength='10' class='whitenum' readonly >��</td>
                </tr>	
            </table>
        </td>
    </tr>  
    <%if(!mode.equals("view")){%>
    <%if(!cpd_bean.getUse_yn().equals("N") && !cpd_bean.getSuc_yn().equals("D")){%>
    
    <%		if((cpd_bean.getUse_yn().equals("Y") || cpd_bean.getUse_yn().equals("C") || cpd_bean.getSuc_yn().equals("D")) && (nm_db.getWorkAuthUser("��ü������",ck_acar_id) || nm_db.getWorkAuthUser("������",user_id) || String.valueOf(ht.get("REG_ID")).equals(user_id))){%>
    <tr>
	<td align="right"><a href="javascript:update('cng_amt','<%=ht.get("SEQ")%>')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
    <tr>	    
    <%		}%>
         
    <%		if(i+1==vt_size && cpd_bean.getSettle_dt().equals("") && (cpd_bean.getUse_yn().equals("Y") || cpd_bean.getUse_yn().equals("C") || cpd_bean.getSuc_yn().equals("D"))){%>
    <tr>
	<td align="right"><a href="javascript:update('cng_amt','<%=ht.get("SEQ")%>')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
    <tr>	    
    <%		}%>
    <%}%>     
    <%}%>
    <%}%>    
    <%			}else if(String.valueOf(ht.get("CNG_ST")).equals("2")){
    				if(String.valueOf(ht.get("CNG_DT")).equals("")){
    					if(String.valueOf(ht.get("CNG_CONT")).equals("���������Ȳ���� ������") && cpd_bean.getSuc_yn().equals("D")){
    					}else{
    						cls_act_yn = "N";
    					}
    				}    
    %>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(String.valueOf(ht.get("CNG_CONT")).equals("���������Ȳ���� ������") && cpd_bean.getSuc_yn().equals("D")){%>����<%}else{%><font color=red>�������</font><%}%></span></td>
    </tr>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>��������</td>
                    <td>&nbsp;<%=ht.get("CNG_CONT")%></td>
                    <td width=14% class=title>�������</td>
                    <td width="19%" >&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")%>&nbsp;<%=ht.get("REG_DT")%></td>
                    <td width=14% class=title>ó������</td>
                    <td width="20%">&nbsp;
                        <%if(String.valueOf(ht.get("CNG_DT")).equals("")){%>�̹ݿ�&nbsp;
                            <%if(nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("��ü������",ck_acar_id) || nm_db.getWorkAuthUser("�ӿ�",ck_acar_id)){%>     
                            	<%if(String.valueOf(ht.get("CNG_CONT")).equals("���������Ȳ���� ������") && cpd_bean.getSuc_yn().equals("D")){%>
                    					<%}else{%>                            
                              <a href="javascript:dir_update('cls_act','<%=ht.get("SEQ")%>')">[�ݿ�ó��]</a>
                              <%}%>
                            <%}%>
                        <%}else{%><%=c_db.getNameById(String.valueOf(ht.get("CNG_ID")),"USER")%>&nbsp;<%=ht.get("CNG_DT")%><%}%>
                    </td>                    
                </tr>            
                <tr>
                    <td class=title>��������</td>
                    <td colspan="5">&nbsp;<textarea class="autosize" style="width:90%;overflow-y:hidden"><%=ht.get("BIGO")%></textarea></td>
                </tr>
            </table>
        </td>
    </tr>    
    <%			}else if(String.valueOf(ht.get("CNG_ST")).equals("3")){
    				if(String.valueOf(ht.get("CNG_DT")).equals("")){
    					re_act_yn = "N";
    				}    
    %>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><font color=red>�������û</font></span></td>
    </tr>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>����</td>
                    <td width=36%>&nbsp;<%=ht.get("CNG_CONT")%></td>
                    <td width=14% class=title>��������</td>
                    <td width="36%" >&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("PUR_REQ_DT")))%></td>
                </tr>            
                <tr> 
                    <td class=title>����</td>
                    <td colspan="3">&nbsp;<textarea class="autosize" style="width:90%;overflow-y:hidden"><%=ht.get("BIGO")%></textarea></td>
                </tr>            
                <tr> 
                    <td class=title>��û����</td>
                    <td >&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")%>&nbsp;<%=ht.get("REG_DT")%></td>
                    <td class=title>ó������</td>
                    <td >&nbsp;
                        <%if(String.valueOf(ht.get("CNG_DT")).equals("")){%>�̹ݿ�&nbsp;
                            <%if(nm_db.getWorkAuthUser("��ü������",ck_acar_id) || nm_db.getWorkAuthUser("�ӿ�",ck_acar_id)){%>    
                                <a href="javascript:update('re_act','<%=ht.get("SEQ")%>')">[�ݿ�ó��]</a>
                            <%}%>    
                        <%}else{%><%=c_db.getNameById(String.valueOf(ht.get("CNG_ID")),"USER")%>&nbsp;<%=ht.get("CNG_DT")%><%}%></td>                    
                </tr>            
            </table>
        </td>
    </tr>    
    <%			}else if(String.valueOf(ht.get("CNG_ST")).equals("5")){
    %>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><font color=red>������</font></span></td>
    </tr>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>���</td>
                    <td width="36%" >&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")%>&nbsp;<%=ht.get("REG_DT")%></td>
                    <td width=14% class=title>ó������</td>
                    <td width="36%">&nbsp;
                        <%if(String.valueOf(ht.get("CNG_DT")).equals("")){%>�̹ݿ�&nbsp;
                            <%if(nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("��ü������",ck_acar_id) || nm_db.getWorkAuthUser("�ӿ�",ck_acar_id)){%>     
                            	<%if(String.valueOf(ht.get("CNG_CONT")).equals("���������Ȳ���� ������") && cpd_bean.getSuc_yn().equals("D")){%>
                    					<%}else{%>                            
                              <a href="javascript:dir_update('cng_cont','<%=ht.get("SEQ")%>')">[�ݿ�ó��]</a>
                              <%}%>
                            <%}%>
                        <%}else{%><%=c_db.getNameById(String.valueOf(ht.get("CNG_ID")),"USER")%>&nbsp;<%=ht.get("CNG_DT")%><%}%>
                    </td>                    
                </tr>            
            </table>
        </td>
    </tr>                
    <%			}%>    
    <%		}%>     
    <%}%>     
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����</span></td>
    </tr>        
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="4" class=title>����</td>
                    <td width=7% class=title>����</td>
                    <td width=19%>&nbsp;<b>[<%if(cpd_bean.getDlv_st().equals("1")){%>����<%}%><%if(cpd_bean.getDlv_st().equals("2")){%>����<%}%>]</b>&nbsp;
                        <%if(cpd_bean.getDlv_st().equals("1")){%><%=AddUtil.ChangeDate2(cpd_bean.getDlv_est_dt())%><%}%>
                        <%if(cpd_bean.getDlv_st().equals("2")){%><%=AddUtil.ChangeDate2(cpd_bean.getDlv_con_dt())%><%}%>
                    </td>
                    <td width=7% rowspan="3" class=title>�����</td>
                    <td width=7% class=title>����</td>
                    <td width="19%" >&nbsp;<%if(cpd_bean.getUdt_st().equals("1") ){%>���ﺻ��<%}%><%if(cpd_bean.getUdt_st().equals("2")){%>�λ�����<%}%><%if(cpd_bean.getUdt_st().equals("3")){%>��������<%}%><%if(cpd_bean.getUdt_st().equals("4")){%>��<%}%><%if(cpd_bean.getUdt_st().equals("5")){%>�뱸����<%}%><%if(cpd_bean.getUdt_st().equals("6")){%>��������<%}%></td>
                    <td width="7%" rowspan="2" class=title>�����</td>
                    <td width="7%" class=title>�μ�/����</td>
                    <td width="20%">&nbsp;<%=cpd_bean.getUdt_mng_nm()%></td>
    		    </tr>
                <tr>
                  <td class=title>���繫��</td>
                  <td>&nbsp;<%=cpd_bean.getDlv_ext()%></td>
                  <td class=title>����/��ȣ</td>
                  <td >&nbsp;<%=cpd_bean.getUdt_firm()%></td>
                  <td class=title>����ó</td>
                  <td>&nbsp;<%=cpd_bean.getUdt_mng_tel()%></td>
                </tr>
                <tr>
                  <td class=title>���Ź�۷�</td>
                  <td>&nbsp;<input type='text' name='cons_amt' maxlength='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>' class='whitenum' size='10' readonly >��</td>
                  <td class=title>�ּ�</td>
                  <td colspan="4" >&nbsp;<%=cpd_bean.getUdt_addr()%></td>
                </tr>	
                <tr>
                  <td class=title>���Ź�ۻ�</td>
                  <td colspan="7">&nbsp;��ȣ : <input type='text' name='cons_off_nm' maxlength='50' value='<%=cpd_bean.getCons_off_nm()%>' class='whitetext' size='40' readonly >
                  	&nbsp;&nbsp;&nbsp;&nbsp;
                  	����ó : <input type='text' name='cons_off_tel' maxlength='50' value='<%=cpd_bean.getCons_off_tel()%>' class='whitetext' size='20' readonly >
                  	
                  	</td>
                </tr>                
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>
    <%if(!mode.equals("view")){%>
    <%	if(!cpd_bean.getUse_yn().equals("N") && !cpd_bean.getSuc_yn().equals("D")){%>
    <tr>
	    <td align="right">
        <%if(nm_db.getWorkAuthUser("��ü������",ck_acar_id) || nm_db.getWorkAuthUser("������",user_id) || ((cpd_bean.getUse_yn().equals("Y") || cpd_bean.getUse_yn().equals("C") || cpd_bean.getSuc_yn().equals("D")) && cpd_bean.getDlv_st().equals("1"))){%>
          <a href="javascript:update('dlv','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
        <%}%>
        <%if((nm_db.getWorkAuthUser("��ü������",ck_acar_id) || nm_db.getWorkAuthUser("������",user_id)) && (!cpd_bean.getSettle_dt().equals("") && base.getRent_start_dt().equals(""))){%>
          &nbsp;&nbsp;&nbsp;&nbsp;
          <a href="javascript:update('cons_off','')">[���Ź�ۻ�]</a>
        <%}%>
      </td>
    </tr>
    <%	} %>
    <%	if(cpd_bean.getUse_yn().equals("N") && cpd_bean.getSuc_yn().equals("D")){%>
    <%		if(nm_db.getWorkAuthUser("��������",ck_acar_id) || nm_db.getWorkAuthUser("������",user_id)){%>
    <tr>
	    <td align="right">
          <a href="javascript:update('dlv','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
      </td>
    </tr>   
    <%		} %> 
    <%	} %>
    <%}%>
    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>�ֹ���</td>
                    <td width=19%>&nbsp;<%if(cpd_bean.getOrder_car().equals("Y")){%>�ֹ���<%}%></td>
                    <td>&nbsp;<%if(cpd_bean.getOrder_car().equals("Y")){%>
                    						��Ȯ��:<%=c_db.getNameById(cpd_bean.getOrder_req_id(),"USER")%>&nbsp;<%=cpd_bean.getOrder_req_dt()%>
                    						<%if(cpd_bean.getOrder_req_dt().equals("")){%>
                    							<a href="javascript:dir_update('order_req','')">[��Ȯ��ó��]</a>
                    						<%}%>
                    						&nbsp;&nbsp;&nbsp;&nbsp;
                    						�ֹ���Ȯ��:<%=c_db.getNameById(cpd_bean.getOrder_chk_id(),"USER")%>&nbsp;<%=cpd_bean.getOrder_chk_dt()%>
                    						<%if(!cpd_bean.getOrder_req_dt().equals("") && cpd_bean.getOrder_chk_dt().equals("")){%>
                    							<!--<a href="javascript:dir_update('order_chk','')">[�ֹ���Ȯ��ó��]</a> ���뿡���� ó����.-->
                    						<%}%>
                              <%}%>
                    </td>
                </tr>
                <tr> 
                    <td width=14% class=title>�����Ȳ</td>
                    <td width=19%>&nbsp;<%if(cpd_bean.getStock_yn().equals("N")){%>����<%}%><%if(cpd_bean.getStock_yn().equals("Y")){%>����<%}%></td>
                    <td>&nbsp;<%if(cpd_bean.getStock_st().equals("1")){%>������ü(1�����̻�)<%}%>
                              <%if(cpd_bean.getStock_st().equals("2")){%>������ü(1�����̳�)<%}%>
                              <%if(cpd_bean.getStock_st().equals("3")){%>��������(��1~2��)<%}%>
                              <%if(cpd_bean.getStock_st().equals("4")){%>������ : �Ͻ���<%}%>
                              <%if(cpd_bean.getStock_st().equals("5")){%>������ : �����<%}%>
                    </td>
                </tr>
                <tr> 
                    <td width=14% class=title>Ư�̻���</td>
                    <td colspan='2'>&nbsp;<textarea class="autosize" style="width:90%;overflow-y:hidden"><%=cpd_bean.getBigo()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr>         
    <tr>
        <td class=h></td>
    </tr>
    <%if(!mode.equals("view")){%>
    <%if(!cpd_bean.getUse_yn().equals("N") && !cpd_bean.getSuc_yn().equals("D")){%>
    <%if(nm_db.getWorkAuthUser("��ü������",ck_acar_id) || nm_db.getWorkAuthUser("������",user_id) || ((cpd_bean.getUse_yn().equals("Y") || cpd_bean.getUse_yn().equals("C") || cpd_bean.getSuc_yn().equals("D")) && cpd_bean.getDlv_st().equals("1"))){%>
    <tr>
	<td align="right"><a href="javascript:update('stock','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
    <tr>	    
    <%}%>
    <%}%>
    <%}%>
    
    <%if(vt_size > 0){%>
    <%		for(int i = 0 ; i < vt_size ; i++){
    			Hashtable ht = (Hashtable)vt.elementAt(i);%>
    <%			if(String.valueOf(ht.get("CNG_ST")).equals("4")){
    %>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><font color=red>������ �������</font></span></td>
    </tr>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>����</td>
                    <td colspan='3'>&nbsp;<%=ht.get("CNG_CONT")%></td>
                </tr>            
                <tr> 
                    <td class=title>����</td>
                    <td colspan='3'>&nbsp;<textarea class="autosize" style="width:90%;overflow-y:hidden"><%=ht.get("BIGO")%></textarea></td>
                </tr> 
                <tr> 
                    <td class=title>��û����</td>
                    <td width=36% >&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")%>&nbsp;<%=ht.get("REG_DT")%></td>
                    <td width=14% class=title>ó������</td>
                    <td width=36% >&nbsp;
                        <%if(String.valueOf(ht.get("CNG_DT")).equals("")){%>�̹ݿ�&nbsp;
                            <%if(nm_db.getWorkAuthUser("��ü������",ck_acar_id) || nm_db.getWorkAuthUser("�ӿ�",ck_acar_id)){%>    
                                <a href="javascript:dir_update('end_act','<%=ht.get("SEQ")%>')">[�ݿ�ó��]</a>
                            <%}%>    
                        <%}else{%><%=c_db.getNameById(String.valueOf(ht.get("CNG_ID")),"USER")%>&nbsp;<%=ht.get("CNG_DT")%><%}%></td>                    
                </tr>                              
            </table>
        </td>
    </tr>         			
    <%			}	
    		}
      }%>		
    
      	    
    
    <%if(!cpd_bean.getDlv_dt().equals("")){%>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>�������</td>
                    <td width=19%>&nbsp;<%=AddUtil.ChangeDate2(cpd_bean.getDlv_dt())%></td>
                    <td width=14% class=title>�����</td>
                    <td width=53%>&nbsp;<%=c_db.getNameById(cpd_bean.getSettle_id(),"USER")%>&nbsp;<%=cpd_bean.getSettle_dt()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <%if(!mode.equals("view")){%>
    <%if(!cpd_bean.getUse_yn().equals("N") && !cpd_bean.getSuc_yn().equals("D")){%>
    <%		if(base.getDlv_dt().equals("") && (nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("��ü������",ck_acar_id) )){%>
    <tr>
	<td align="right"><a href="javascript:update('dlv_dt','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
    <tr>	    
    <%		}%>
    <%	}%>    
    <%}%>    
    <%}%>
    <%if(cpd_bean.getCar_comp_id().equals("0001") && !user_bean.getDept_id().equals("8888") && !pur.getPur_com_firm().equals("")){%>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>���������</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%>
                    <%	if(!base.getAgent_emp_id().equals("")){
                    		CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id());
                    %>
                    		(������Ʈ ����������� : <%=a_coe_bean.getEmp_nm()%>&nbsp;<%=a_coe_bean.getEmp_m_tel()%>)
                    <%	}%>  
                    </td>
                </tr>
            </table>
        </td>
    </tr>    
    <tr>
        <td class=h></td>
    </tr>     <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
		    <td colspan='2' class=title>������</td>
		    <td colspan='2' class=title>������(Ư��)</td>
                </tr>
                <tr> 
                    <td width=15% class=title>������</td>
		    <td width=35% class=title>��ȣ</td>
		    <td width=15% class=title>������</td>
		    <td width=35% class=title>��ȣ</td>
                </tr>
                <tr> 									
                    <td>&nbsp;<%if(client.getClient_st().equals("1")) 	out.println("����");
                      	else if(client.getClient_st().equals("2"))  	out.println("����");
                      	else if(client.getClient_st().equals("3")) 	out.println("���λ����(�Ϲݰ���)");
                      	else if(client.getClient_st().equals("4"))	out.println("���λ����(���̰���)");
                      	else if(client.getClient_st().equals("5")) 	out.println("���λ����(�鼼�����)");%>
                    </td>
                    <td>&nbsp;<%=client.getFirm_nm()%></td>
                    <td>&nbsp;����</td>
		    <td>&nbsp;<%=pur.getPur_com_firm()%>		        
		        <%if(pur.getPur_com_firm().equals("")){%>
		            <%=client.getFirm_nm()%>		            
		        <%}else{%>
		            &nbsp;<%=AddUtil.ChangeEnt_no(c_db.getNameById(pur.getPur_com_firm(),"ENP_NO"))%>
		        <%}%>
		    </td>
                </tr>
            </table>
        </td>
    </tr>      
    <%}else{%>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>���������</td>
                    <td width=19%>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%>
                    <%	if(!base.getAgent_emp_id().equals("")){
                    		CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id());
                    %>
                    		(������Ʈ ����������� : <%=a_coe_bean.getEmp_nm()%>&nbsp;<%=a_coe_bean.getEmp_m_tel()%>)
                    <%	}%>  
                    </td>
                    <td width=14% class=title>��ȣ</td>
                    <td width=53%>&nbsp;<%=pur.getPur_com_firm()%>                        
                        <%if(pur.getPur_com_firm().equals("")){%>
                            <%=client.getFirm_nm()%>
                        <%}else{%>
                            &nbsp;<%=AddUtil.ChangeEnt_no(c_db.getNameById(pur.getPur_com_firm(),"ENP_NO"))%>
                        <%}%>
                        
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <%}%>
    <tr>
        <td class=h></td>
    </tr>
    <%if(!cng_bean.getRent_mng_id().equals("") && cng_bean.getCar_g_amt() > 0 ){%>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>��������</td>
                    <td width=19%>&nbsp;<input type='text' name='car_amt1' value='<%=AddUtil.parseDecimal(cng_bean.getCar_g_amt())%>' class='whitenum' size='10' readonly >��</td>
                    <td width=14% class=title>���Ź�۷�</td>
                    <td width=19%>&nbsp;<input type='text' name='car_amt2' value='<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>' class='whitenum' size='10' readonly >��</td>
                    <td width=14% class=title>�հ�</td>
                    <td width=20%>&nbsp;<input type='text' name='car_amt3' value='<%=AddUtil.parseDecimal(cng_bean.getCar_g_amt()+cpd_bean.getCons_amt())%>' class='whitenum' size='10' readonly >��</td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else{%>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>��������</td>
                    <td width=19%>&nbsp;<input type='text' name='car_amt1' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_g_amt())%>' class='whitenum' size='10' readonly >��</td>
                    <td width=14% class=title>���Ź�۷�</td>
                    <td width=19%>&nbsp;<input type='text' name='car_amt2' value='<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>' class='whitenum' size='10' readonly >��</td>
                    <td width=14% class=title>�հ�</td>
                    <td width=20%>&nbsp;<input type='text' name='car_amt3' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_g_amt()+cpd_bean.getCons_amt())%>' class='whitenum' size='10' readonly >��</td>
                </tr>
            </table>
        </td>
    </tr>           
    <%}%>
    
    <%if(from_page.equals("/fms2/pur_com/pur_dlv_frame.jsp")){
    		if(pur.getPur_pay_dt().equals("")) pur.setPur_pay_dt(pur.getPur_est_dt());
    		
    		//ī������
		CardBean card_bean = CardDb.getCard(pur.getCardno1());
    %>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><font color=red>ī���������</font></span></td>
    </tr>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>ī���</td>
                    <td width=10%>&nbsp;<%=pur.getCard_kind1()%></td>
                    <td width=10% class=title>ī���ȣ</td>
                    <td width=26%>&nbsp;<%=pur.getCardno1()%>&nbsp;&nbsp;(<%=AddUtil.ChangeDate(card_bean.getCard_edate(),"MM/YY")%>)</td>
                    <td width=10% class=title>���������</td>
                    <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(pur.getPur_pay_dt())%></td>
                    <td width=10% class=title>����ݾ�</td>
                    <td width=10%>&nbsp;<%=AddUtil.parseDecimal(pur.getTrf_amt1())%>��</td>
                </tr>       
                <%if(pur.getTrf_st2().equals("2") || pur.getTrf_st2().equals("3") || pur.getTrf_st2().equals("7")){
                		card_bean = CardDb.getCard(pur.getCardno2());
                %>  
                <tr> 
                    <td width=14% class=title>ī���</td>
                    <td width=10%>&nbsp;<%=pur.getCard_kind2()%></td>
                    <td width=10% class=title>ī���ȣ</td>
                    <td width=26%>&nbsp;<%=pur.getCardno2()%>&nbsp;&nbsp;(<%=AddUtil.ChangeDate(card_bean.getCard_edate(),"MM/YY")%>)</td>
                    <td width=10% class=title>���������</td>
                    <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(pur.getPur_pay_dt())%></td>
                    <td width=10% class=title>����ݾ�</td>
                    <td width=10%>&nbsp;<%=AddUtil.parseDecimal(pur.getTrf_amt2())%>��</td>
                </tr>                
                <%} %>     
                <%if(pur.getTrf_st3().equals("2") || pur.getTrf_st3().equals("3") || pur.getTrf_st3().equals("7")){
                		card_bean = CardDb.getCard(pur.getCardno3());
                %>  
                <tr> 
                    <td width=14% class=title>ī���</td>
                    <td width=10%>&nbsp;<%=pur.getCard_kind3()%></td>
                    <td width=10% class=title>ī���ȣ</td>
                    <td width=26%>&nbsp;<%=pur.getCardno3()%>&nbsp;&nbsp;(<%=AddUtil.ChangeDate(card_bean.getCard_edate(),"MM/YY")%>)</td>
                    <td width=10% class=title>���������</td>
                    <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(pur.getPur_pay_dt())%></td>
                    <td width=10% class=title>����ݾ�</td>
                    <td width=10%>&nbsp;<%=AddUtil.parseDecimal(pur.getTrf_amt3())%>��</td>
                </tr>                
                <%} %>                            
            </table>
        </td>
    </tr>         	    
    <%}%>
    
    <tr>
	<td align="right">&nbsp;</td>
    <tr>     
    <%if(!mode.equals("view")){%>
    <%if(!cpd_bean.getUse_yn().equals("N") && !cpd_bean.getSuc_yn().equals("D")){%>
    <!-- ������Ȳ -->
    <%if(cpd_bean.getDlv_st().equals("1") && cpd_bean.getSettle_dt().equals("")){%>	   
    <tr>
	<td align='center'>	 
	    
	    <%if(cng_act_yn.equals("N")){%>	   
	    * �������� �̹ݿ��Ǿ����ϴ�. ���� �ݿ�ó���� �Ǿ�� �������û/��ຯ��/�������/������/�������� �� �� �ֽ��ϴ�.
	    <%}else{%>
	        <%if(cls_act_yn.equals("N")){%>	
	        * ��������� �̹ݿ��Ǿ����ϴ�. �ݿ�ó���� �ϸ� ������Ȳ���� �����ϴ�.<br>
	        <%}else{%>	
	        	<%if((cpd_bean.getUse_yn().equals("Y") || cpd_bean.getUse_yn().equals("C") || cpd_bean.getSuc_yn().equals("D"))){%>   
	        		     
	        			<a href="javascript:update('re','')"     title='�������û'   onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_ask_jbj.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;	
	        			<%if(!cpd_bean.getUse_yn().equals("N")){%>
	        			<a href="javascript:update('cng','')"    title='��ຯ��'     onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify_gyk.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp; 
	        				<%if(ej_bean.getJg_g_7().equals("3")){ %>
			        			<%if(nm_db.getWorkAuthUser("������������",ck_acar_id)){		//�������� ������ ����, ������ �븮�� ���� %>
			        				<a href="javascript:update('cls1','')"   title='��ǰ�������' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_hj_npcs.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
			        			<%} %>	
	        				<%}else{ %>
			        			<a href="javascript:update('cls1','')"   title='��ǰ�������' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_hj_npcs.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
	        				<%} %>  
	        			<!-- <a href="javascript:update('cls2','')"   title='������������' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_hj_cjbg.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp; -->	
	        			<%}%>
	        			<%if(nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("��ü������",ck_acar_id) || nm_db.getWorkAuthUser("�ӿ�",ck_acar_id)){%>     
	        			<a href="javascript:update('settle','')" title='���'         onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_cgo.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	        			<%}%>	        			

              			<%if(nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("��ü������",ck_acar_id) || nm_db.getWorkAuthUser("�ӿ�",ck_acar_id)){%>     
	        			<a href="javascript:update('con','')"    title='������'     onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_cgbj.gif align=absmiddle border=0></a>&nbsp;&nbsp;
        				<%}%>
	        	<%}%>
	        <%}%>	        
	    <%}%>
	    
	    
	        
	</td>
    </tr>	
    <%}%>
    <%}%>
    <!-- ������Ȳ -->
    <%if(cpd_bean.getDlv_st().equals("2") && cpd_bean.getSettle_dt().equals("")){%>	 
    <tr>
	<td align='center'>	
	        	<%if((cpd_bean.getUse_yn().equals("Y") || cpd_bean.getUse_yn().equals("C") || cpd_bean.getSuc_yn().equals("D"))){%>   	        		
	        		
	        			<a href="javascript:update('re','')"     title='�������û'   onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_ask_jbj.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;		        			
	        			<%if(!cpd_bean.getUse_yn().equals("N")){%>
	        			<a href="javascript:update('cng','')"    title='��ຯ��'     onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify_gyk.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
	        				<%if(ej_bean.getJg_g_7().equals("3")){ %>
			        			<%if(nm_db.getWorkAuthUser("������������",ck_acar_id)){		//�������� ������ ����, ������ �븮�� ���� %>
			        				<a href="javascript:update('cls1','')"   title='��ǰ�������' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_hj_npcs.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
			        			<%} %>	
	        				<%}else{ %>
			        			<a href="javascript:update('cls1','')"   title='��ǰ�������' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_hj_npcs.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
	        				<%} %>
	        			<a href="javascript:update('cng2','')"   title='�����ĺ���'   onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify_bj.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
	        			<%}%>	        			
	        			<a href="javascript:update('cls3','')"   title='�������'     onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_cancel_bj.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	        			<%if(nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("��ü������",ck_acar_id) || nm_db.getWorkAuthUser("�ӿ�",ck_acar_id)){%>     
	        			<a href="javascript:update('settle','')" title='���'         onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_cgo.gif align=absmiddle border=0></a>&nbsp;&nbsp;
	        			<%}%>
               	<%}else{%>	 
               		<%if(!cpd_bean.getUse_yn().equals("N")){%>       		        			
	        			<a href="javascript:update('cng2','')"   title='�����ĺ���'   onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify_bj.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
	        		<%}%>	
	        	<%}%>
	</td>
    </tr>	    
    <%}%>

    <%}%>
    
    <%if(cpd_bean.getUse_yn().equals("N")){%>   	
    <tr>
        <td align='center'>
	        	<!--�������-->
	        	<%	if(nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("��ü������",ck_acar_id) || nm_db.getWorkAuthUser("�ӿ�",ck_acar_id)){%>
	        	<%		if(cpd_bean.getSuc_yn().equals("") || cpd_bean.getSuc_yn().equals("N")){%>
	        	<input type="button" class="button" id="revival" value='��������� ��Ȱ' onclick="javascript:dir_update('revival', '<%=max_cng_seq%>');">
	        	<%		}%>
	        	<%	}%>        
        </td>
    </tr> 
    <%	}%>	


    
    <tr>
        <td class=h></td>
    </tr> 
    <%if(!base.getDlv_dt().equals("")){%>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="2" class=title>�μ�</td>
                    <td width=7% class=title>�μ�����</td>
                    <td width=19%>&nbsp;<%=AddUtil.ChangeDate2(pur.getUdt_est_dt())%></td>
                    <td width=7% rowspan="2" class=title>�ڵ������</td>
                    <td width=7% class=title>�������</td>
                    <td width="19%" >&nbsp;<%=cr_bean.getInit_reg_dt()%></td>
                    <td width=7% rowspan="2" class=title>��ĵ</td>
                    <td width=14% class=title>�ڵ��������</td>
                    <td width="13%">&nbsp;
                    <%	for(int i=0; i<ch_r.length; i++){
    				ch_bean = ch_r[i];
    				if(ch_bean.getScanfile().equals("")) continue;	%>
                            <%	if(ch_bean.getFile_type().equals("")){%>
    			    <a href="javascript:MM_openBrWindow2('<%=ch_bean.getScanfile()%>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><%=ch_bean.getScanfile()%>.pdf</a>
			    <%	}else{%>
    			    <a href="javascript:ScanOpen2('<%= ch_bean.getScanfile() %>','<%= ch_bean.getFile_type() %>')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a> 					
			    <%	}%>    					
		    <%	}%>	    
                    </td>
    		    </tr>
                <tr>
                  <td class=title>�μ���</td>
                  <td>&nbsp;<%String udt_st = pur.getUdt_st();%><%if(udt_st.equals("1")){%>���ﺻ�� <%}else if(udt_st.equals("2")){%>�λ����� <%}else if(udt_st.equals("3")){%>�������� <%}else if(udt_st.equals("4")){%>�� <%}else if(udt_st.equals("5")){%>�뱸���� <%}else if(udt_st.equals("6")){%>�������� <%}%></td>
                  <td class=title>��Ϲ�ȣ</td>
                  <td >&nbsp;<%=cr_bean.getCar_no()%></td>
                  <td class=title>�鼼��ǰ����Ű�</td>
                  <td>&nbsp;
                    	<%
				content_code = "LC_SCAN";
				content_seq  = rent_mng_id+""+rent_l_cd+"1"+"23";

				attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);		
				attach_vt_size = attach_vt.size();		                    	
				
				int scan_cnt = 0;
                    	%>
                    	
						<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);       								    								    											
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a>
    						<%	}%>
    						<%}%>
    						                  
                  </td>
                </tr>	
            </table>
        </td>
    </tr>   
    <%}%> 
    

        
    <%if(mode.equals("view")){%>
    <tr>
	<td align="right"><a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    <tr>    
    <%}%>  
    <%if(!mode.equals("view")){%> 
    <%if(!cpd_bean.getSettle_dt().equals("")){%>	 
    <tr>
	<td align='center'>	 
	        	<%if(!cpd_bean.getUse_yn().equals("N")){%>   	        		
        			<%if(nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("��ü������",ck_acar_id) ){%>
        				<%if(ej_bean.getJg_g_7().equals("3")){ %>
		        			<%if(ck_acar_id.equals("000144")||ck_acar_id.equals("000197")||nm_db.getWorkAuthUser("������",ck_acar_id)){		//�������� ������ ����, ������ �븮�� ���� %>
		        				<a href="javascript:update('cls1','')" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_hj_npcs.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
		        			<%} %>	
        				<%}else{ %>
		        			<a href="javascript:update('cls1','')" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_hj_npcs.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
        				<%} %>
        			<%}%>
	        	<%}%>
	</td>
    </tr>	    
    <%}%>  
    <%}%>        
    
    <!--���������Ȳ���� ������ ���¿��� �����ڰ� ������ ������� ó���Ҽ� �ִ�.-->
    <%if(cpd_bean.getSuc_yn().equals("D")){%>
    <tr>
	<td align='center'>	 
        			<%if(nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("��ü������",ck_acar_id) ){%> 
       				   <%if(ej_bean.getJg_g_7().equals("3")){ %>
		        			<%if(ck_acar_id.equals("000144")||ck_acar_id.equals("000197")||nm_db.getWorkAuthUser("������",ck_acar_id)){		//�������� ������ ����, ������ �븮�� ���� %>
		        				<a href="javascript:dir_update('cls5','')" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_hj_npcs.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
		        			<%} %>	
        				<%}else{ %>
		        			<a href="javascript:dir_update('cls5','')" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_hj_npcs.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
        				<%} %>
        			<%}%>
	</td>
    </tr>	        
    <%}%>    

    
</table>
</form>
<script language="JavaScript">
<!--	
var txtArea = $(".autosize");
if (txtArea) {
    txtArea.each(function(){
        $(this).height(this.scrollHeight);
    });
}
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

